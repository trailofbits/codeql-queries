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
 * A call to Desktop.browse() method. This is the platform-agnostic standard now.
 * NOTE(alan): the URLRedirect query will likely also trigger due to a little imprecision there
 */
class DesktopBrowseCall extends MethodCall {
  DesktopBrowseCall() {
    this.getMethod().hasName("browse") and
    this.getMethod().getDeclaringType().hasQualifiedName("java.awt", "Desktop")
  }

  Expr getUrlArgument() { result = this.getArgument(0) }
}

/**
 * Legacy Windows-specific command execution for protocol handling, based on https://imagej.net/ij/source/ij/plugin/BrowserLauncher.java and
 * seen in CVE-2022-43550. We match on the Windows shell command, since it more distinct and pervasive.
 */
class LegacyWindowsProtocolHandlerCall extends ArgumentToExec {
  LegacyWindowsProtocolHandlerCall() {
    // Single string: "rundll32 url.dll,FileProtocolHandler " + url
    this instanceof StringArgumentToExec and
    exists(StringLiteral sl |
      sl.getParent*() = this and
      sl.getValue().regexpMatch("(?i).*rundll32.*url\\.dll.*FileProtocolHandler.*")
    )
    or
    // Array: {"rundll32", "url.dll,FileProtocolHandler", url}
    this.getType().(Array).getElementType() instanceof TypeString and
    exists(ArrayInit init, StringLiteral rundll, StringLiteral urldll |
      init = this.(ArrayCreationExpr).getInit() and
      rundll = init.getAnInit() and
      urldll = init.getAnInit() and
      rundll.getValue().regexpMatch("(?i)rundll32(\\.exe)?") and
      urldll.getValue().regexpMatch("(?i)url\\.dll.*FileProtocolHandler")
    )
  }

  Expr getUrlArgument() {
    // For single string exec, the URL is tainted into the concatenated string
    result = this and this instanceof StringArgumentToExec
    or
    // For arrays, find elements after "url.dll,FileProtocolHandler"
    exists(ArrayInit init, int urlIdx, int dllIdx |
      init = this.(ArrayCreationExpr).getInit() and
      result = init.getInit(urlIdx) and
      init.getInit(dllIdx).(StringLiteral).getValue().regexpMatch("(?i)url\\.dll.*FileProtocolHandler") and
      urlIdx > dllIdx
    )
  }
}

/**
 * A guard that checks the URL scheme/protocol signifying sanitization before launch
 */
predicate isUrlSchemeCheck(Guard g, Expr e, boolean branch) {
  exists(MethodCall mc |
    mc = g and
    e = mc.getQualifier*() and
    branch = true and
    (
      // getScheme() or getProtocol() check
      mc.getMethod().hasName(["equals", "equalsIgnoreCase", "startsWith", "matches"]) and
      exists(MethodCall getScheme |
        getScheme.getParent*() = mc and
        getScheme.getMethod().hasName(["getScheme", "getProtocol"])
      )
      or
      // URL string contains check like: url.contains("http://") or url.startsWith("https://")
      mc.getMethod().hasName(["contains", "startsWith", "matches", "indexOf"]) and
      exists(StringLiteral sl | sl = mc.getAnArgument() | sl.getValue().regexpMatch(".*://.*"))
      or
      // Pattern matching on the string representation
      mc.getMethod().hasName(["matches", "find"]) and
      mc.getQualifier().getType().(RefType).hasQualifiedName("java.util.regex", "Matcher")
    )
  )
}

/**
 * Configuration for tracking untrusted data to protocol handler invocations
 */
module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(DesktopBrowseCall call | sink.asExpr() = call.getUrlArgument())
    or
    exists(LegacyWindowsProtocolHandlerCall call | sink.asExpr() = call.getUrlArgument())
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<isUrlSchemeCheck/3>::getABarrierNode()
  }
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
    exists(DesktopBrowseCall dbc |
      call = dbc and
      sink.getNode().asExpr() = dbc.getUrlArgument() and
      callType = "Desktop.browse()"
    )
    or
    exists(LegacyWindowsProtocolHandlerCall whc |
      call = whc and
      sink.getNode().asExpr() = whc.getUrlArgument() and
      callType = "rundll32 url.dll,FileProtocolHandler"
    )
  )
select call, source, sink,
  callType + " is called with untrusted input from $@ without proper URL scheme validation.",
  source.getNode(), "this source"
