/**
 * @name Potentially unguarded protocol handler invocation
 * @id tob/cpp/unguarded-protocol-handler
 * @description Detects calls to URL protocol handlers with untrusted input that may not be properly validated for dangerous protocols
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-939
 * @precision medium
 * @problem.severity warning
 * @security-severity 6.5
 * @group security
 */

import cpp
private import semmle.code.cpp.ir.dataflow.TaintTracking
private import semmle.code.cpp.security.FlowSources
private import semmle.code.cpp.security.CommandExecution

/**
 * Generic case: invoke protocol handling through OS's protocol handling utilities. This aligns with CVE-2022-43550.
 */
class ShellProtocolHandler extends SystemFunction {
  ShellProtocolHandler() {
    // Check if any calls to this function contain protocol handler invocations
    exists(FunctionCall call |
      call.getTarget() = this and
      exists(Expr arg |
        arg = call.getArgument(0).getAChild*() and
        exists(StringLiteral sl | sl = arg or sl.getParent*() = arg |
          sl.getValue()
              .regexpMatch("(?i).*(rundll32.*url\\.dll.*FileProtocolHandler|xdg-open|\\bopen\\b).*")
        )
      )
    )
  }

  string getHandlerType() {
    exists(FunctionCall call, StringLiteral sl |
      call.getTarget() = this and
      sl.getParent*() = call.getArgument(0) and
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
 * Qt's QDesktopServices::openUrl method
 */
class QtProtocolHandler extends FunctionCall {
  QtProtocolHandler() { this.getTarget().hasQualifiedName("QDesktopServices", "openUrl") }

  Expr getUrlArgument() { result = this.getArgument(0) }
}

/**
 * A sanitizer node that represents URL scheme validation
 */
class UrlSchemeValidationSanitizer extends DataFlow::Node {
  UrlSchemeValidationSanitizer() {
    exists(FunctionCall fc |
      fc = this.asExpr() and
      (
        // String comparison on the untrusted URL
        fc.getTarget().getName() =
          [
            "strcmp", "strncmp", "strcasecmp", "strncasecmp", "strstr", "strcasestr", "_stricmp",
            "_strnicmp"
          ]
        or
        // Qt QUrl::scheme() comparison - QUrl::scheme() returns QString
        // Pattern: url.scheme() == "http" or url.scheme() == "https"
        exists(FunctionCall schemeCall |
          schemeCall.getTarget().hasQualifiedName("QUrl", "scheme") and
          (
            // Direct comparison
            fc.getTarget().hasName(["operator==", "operator!="]) and
            fc.getAnArgument() = schemeCall
            or
            // QString comparison methods
            fc = schemeCall and
            exists(FunctionCall qstringCmp |
              qstringCmp.getQualifier() = schemeCall and
              qstringCmp.getTarget().hasQualifiedName("QString", ["compare", "operator=="])
            )
          )
        )
        or
        // Qt QString startsWith check for direct URL strings
        fc.getTarget().hasQualifiedName("QString", "startsWith")
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
    // QDesktopServices::openUrl()
    exists(QtProtocolHandler call | sink.asExpr() = call.getUrlArgument())
    or
    // Shell protocol handlers (rundll32, xdg-open, open) via system()/popen()/exec*()
    exists(FunctionCall call |
      call.getTarget() instanceof ShellProtocolHandler and
      sink.asExpr() = call.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof UrlSchemeValidationSanitizer }
}

module PotentiallyUnguardedProtocolHandlerFlow =
  TaintTracking::Global<PotentiallyUnguardedProtocolHandlerConfig>;

import PotentiallyUnguardedProtocolHandlerFlow::PathGraph

from
  PotentiallyUnguardedProtocolHandlerFlow::PathNode source,
  PotentiallyUnguardedProtocolHandlerFlow::PathNode sink, FunctionCall call, string callType
where
  PotentiallyUnguardedProtocolHandlerFlow::flowPath(source, sink) and
  (
    exists(QtProtocolHandler qtCall |
      call = qtCall and
      sink.getNode().asExpr() = qtCall.getUrlArgument() and
      callType = "QDesktopServices::openUrl()"
    )
    or
    exists(ShellProtocolHandler shellFunc |
      call.getTarget() = shellFunc and
      sink.getNode().asExpr() = call.getArgument(0) and
      callType = shellFunc.getHandlerType()
    )
  )
select call, source, sink,
  callType + " is called with untrusted input from $@ without proper URL scheme validation.",
  source.getNode(), "this source"
