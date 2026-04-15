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
private import semmle.code.cpp.controlflow.IRGuards

/**
 * Holds when `call` invokes a system function (system, popen, exec*) with a command string
 * that contains a URL protocol handler, `sink` is the argument carrying the URL, and
 * `handlerType` describes which handler is invoked.
 */
predicate isShellProtocolHandlerSink(FunctionCall call, Expr sink, string handlerType) {
  call.getTarget() instanceof SystemFunction and
  exists(StringLiteral sl |
    sl.getParent*() = call.getArgument(0) and
    (
      sl.getValue().regexpMatch("(?i).*rundll32.*url\\.dll.*FileProtocolHandler.*") and
      handlerType = "rundll32 url.dll,FileProtocolHandler"
      or
      sl.getValue().regexpMatch("(?i).*xdg-open.*") and
      handlerType = "xdg-open"
      or
      sl.getValue().regexpMatch("(?i).*\\bopen\\b.*") and
      handlerType = "open"
    )
  ) and
  sink = call.getArgument(0)
}

/**
 * Holds when `call` invokes QDesktopServices::openUrl and `sink` is the URL argument.
 */
predicate isQtProtocolHandlerSink(FunctionCall call, Expr sink) {
  call.getTarget().hasQualifiedName("", "QDesktopServices", "openUrl") and
  sink = call.getArgument(0)
}

/**
 * Gets the sink expression for a given DataFlow::Node matching either Qt or shell handler sinks.
 */
Expr getSinkExpr(DataFlow::Node sink) {
  result = sink.asExpr() or
  result = sink.asIndirectExpr()
}

/**
 * Holds when `g` is a guard condition that validates the URL scheme of expression `e`.
 * Flow is considered safe on the `branch` edge.
 */
predicate urlSchemeGuardChecks(IRGuardCondition g, Expr e, boolean branch) {
  branch = [true, false] and
  exists(FunctionCall fc | g.getUnconvertedResultExpression().getAChild*() = fc |
    // C string comparison on the URL (strcmp, strncmp, etc.)
    fc.getTarget().getName() =
      [
        "strcmp", "strncmp", "strcasecmp", "strncasecmp", "strstr", "strcasestr", "_stricmp",
        "_strnicmp"
      ] and
    e = fc.getAnArgument()
    or
    // Qt QString::startsWith check
    fc.getTarget().hasQualifiedName("", "QString", "startsWith") and
    e = fc.getQualifier()
    or
    // Qt QUrl::scheme() comparison
    exists(FunctionCall schemeCall |
      schemeCall.getTarget().hasQualifiedName("", "QUrl", "scheme") and
      fc.getAnArgument() = schemeCall and
      e = schemeCall.getQualifier()
    )
  )
}

/**
 * Configuration for tracking untrusted data to protocol handler invocations.
 */
module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    isQtProtocolHandlerSink(_, getSinkExpr(sink))
    or
    isShellProtocolHandlerSink(_, getSinkExpr(sink), _)
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<urlSchemeGuardChecks/3>::getABarrierNode()
    or
    node = DataFlow::BarrierGuard<urlSchemeGuardChecks/3>::getAnIndirectBarrierNode()
  }
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
    isQtProtocolHandlerSink(call, getSinkExpr(sink.getNode())) and
    callType = "QDesktopServices::openUrl()"
    or
    isShellProtocolHandlerSink(call, getSinkExpr(sink.getNode()), callType)
  )
select call, source, sink,
  callType + " is called with untrusted input from $@ without proper URL scheme validation.",
  source.getNode(), "this source"
