/**
 * @name Potentially unguarded protocol handler invocation
 * @id tob/java/unguarded-protocol-handler
 * @description Detects calls to URL protocol handlers with untrusted input that may not be properly validated for dangerous protocols
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-939
 * @precision medium
 * @problem.severity warning
 * @security-severity 6.5
 * @group security
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.ExternalProcess

/**
 * Generic case: invoke protocol handling through OS's protocol handling utilities. This aligns with CVE-2022-43550.
 */
class ShellProtocolHandler extends ArgumentToExec {
  ShellProtocolHandler() {
    // Single string: "rundll32 url.dll,FileProtocolHandler " + url or "xdg-open " + url
    this instanceof StringArgumentToExec and
    exists(StringLiteral sl |
      sl.getParent*() = this and
      sl.getValue()
          .regexpMatch("(?i).*(rundll32.*url\\.dll.*FileProtocolHandler|xdg-open|\\bopen\\b).*")
    )
    or
    // Array: {"rundll32", "url.dll,FileProtocolHandler", url} or {"xdg-open", url}
    this.getType().(Array).getElementType() instanceof TypeString and
    exists(ArrayInit init, StringLiteral handler |
      init = this.(ArrayCreationExpr).getInit() and
      handler = init.getAnInit() and
      handler.getValue().regexpMatch("(?i)(rundll32(\\.exe)?|xdg-open|open|/usr/bin/open)")
    )
  }

  Expr getUrlArgument() {
    // For single string exec, the URL is tainted into the concatenated string
    result = this and this instanceof StringArgumentToExec
    or
    // For arrays with rundll32, find elements after "url.dll,FileProtocolHandler"
    exists(ArrayInit init, int urlIdx, int dllIdx |
      init = this.(ArrayCreationExpr).getInit() and
      result = init.getInit(urlIdx) and
      init.getInit(dllIdx)
          .(StringLiteral)
          .getValue()
          .regexpMatch("(?i)url\\.dll.*FileProtocolHandler") and
      urlIdx > dllIdx
    )
    or
    // For arrays with xdg-open/open, find elements after the handler
    exists(ArrayInit init, int urlIdx, int handlerIdx |
      init = this.(ArrayCreationExpr).getInit() and
      result = init.getInit(urlIdx) and
      init.getInit(handlerIdx)
          .(StringLiteral)
          .getValue()
          .regexpMatch("(?i)(xdg-open|open|/usr/bin/open)") and
      urlIdx > handlerIdx
    )
  }

  string getHandlerType() {
    exists(StringLiteral sl |
      sl.getParent*() = this and
      (
        sl.getValue().regexpMatch("(?i).*rundll32.*url\\.dll.*FileProtocolHandler.*") and
        result = "rundll32 url.dll,FileProtocolHandler"
        or
        sl.getValue().regexpMatch("(?i).*xdg-open.*") and
        result = "xdg-open"
        or
        sl.getValue().regexpMatch("(?i).*\\bopen\\b.*") and
        result = "open"
      )
    )
  }
}

/**
 * A call to Desktop.browse() method. This is the platform-agnostic standard now.
 * NOTE(alan): the URLRedirect query will likely also trigger due to a little imprecision there
 */
class DesktopBrowseProtocolHandler extends MethodCall {
  DesktopBrowseProtocolHandler() {
    this.getMethod().hasName("browse") and
    this.getMethod().getDeclaringType().hasQualifiedName("java.awt", "Desktop")
  }

  Expr getUrlArgument() { result = this.getArgument(0) }
}

/**
 * A sanitizer node that represents URL scheme validation
 */
class UrlSchemeValidationSanitizer extends DataFlow::Node {
  UrlSchemeValidationSanitizer() {
    exists(MethodCall mc |
      mc = this.asExpr() and
      (
        // String comparison on the untrusted URL
        mc.getMethod().hasName(["equals", "equalsIgnoreCase", "startsWith", "matches"]) and
        exists(MethodCall getScheme |
          getScheme.getParent*() = mc and
          getScheme.getMethod().hasName(["getScheme", "getProtocol"])
        )
        or
        // URL string contains check like: url.contains("://")
        mc.getMethod().hasName(["contains", "startsWith", "matches", "indexOf"]) and
        exists(StringLiteral sl | sl = mc.getAnArgument() | sl.getValue().regexpMatch(".*://.*"))
        or
        // Pattern matching on the string representation
        mc.getMethod().hasName(["matches", "find"]) and
        mc.getQualifier().getType().(RefType).hasQualifiedName("java.util.regex", "Matcher")
      )
    )
  }
}

/**
 * Configuration for tracking untrusted data to protocol handler invocations
 */
module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(DesktopBrowseProtocolHandler call | sink.asExpr() = call.getUrlArgument())
    or
    exists(ShellProtocolHandler call | sink.asExpr() = call.getUrlArgument())
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof UrlSchemeValidationSanitizer }
}

module PotentiallyUnguardedProtocolHandlerFlow =
  TaintTracking::Global<PotentiallyUnguardedProtocolHandlerConfig>;

import PotentiallyUnguardedProtocolHandlerFlow::PathGraph

from
  PotentiallyUnguardedProtocolHandlerFlow::PathNode source,
  PotentiallyUnguardedProtocolHandlerFlow::PathNode sink, Expr call, string callType
where
  PotentiallyUnguardedProtocolHandlerFlow::flowPath(source, sink) and
  (
    exists(DesktopBrowseProtocolHandler dbc |
      call = dbc and
      sink.getNode().asExpr() = dbc.getUrlArgument() and
      callType = "Desktop.browse()"
    )
    or
    exists(ShellProtocolHandler shc |
      call = shc and
      sink.getNode().asExpr() = shc.getUrlArgument() and
      callType = shc.getHandlerType()
    )
  )
select call, source, sink,
  callType + " is called with untrusted input from $@ without proper URL scheme validation.",
  source.getNode(), "this source"
