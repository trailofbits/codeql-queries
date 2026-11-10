/**
 * @name Potentially unguarded protocol handler invocation
 * @id tob/cpp/unguarded-protocol-handler
 * @description Finds URL protocol handlers called with URLs from untrusted sources
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-939
 * @precision medium
 * @problem.severity warning
 * @security-severity 6.5
 * @group security
 */

import cpp
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.ir.dataflow.TaintTracking
private import semmle.code.cpp.security.CommandExecution
private import semmle.code.cpp.security.FlowSources

predicate isProtocolHandlerLiteral(StringLiteral literal, string handlerType) {
  literal.getValue().regexpMatch("(?i).*rundll32.*url\\.dll.*FileProtocolHandler.*") and
  handlerType = "rundll32 url.dll,FileProtocolHandler"
  or
  literal.getValue().regexpMatch("(?i).*xdg-open.*") and
  handlerType = "xdg-open"
  or
  literal.getValue().regexpMatch("(?i).*\\bopen\\b.*") and
  not literal.getValue().regexpMatch("(?i).*xdg-open.*") and
  handlerType = "open"
}

predicate localTaint(Expr source, Expr sink) {
  exists(DataFlow::Node sourceNode, DataFlow::Node sinkNode |
    source = [sourceNode.asExpr(), sourceNode.asIndirectExpr()] and
    sink = [sinkNode.asExpr(), sinkNode.asIndirectExpr()] and
    TaintTracking::localTaint(sourceNode, sinkNode)
  )
}

predicate isShellProtocolHandlerCall(FunctionCall call, string handlerType) {
  call.getTarget() instanceof SystemFunction and
  exists(StringLiteral literal |
    isProtocolHandlerLiteral(literal, handlerType) and
    localTaint(literal, call.getArgument(0))
  )
}

predicate isAllowedScheme(StringLiteral literal, Expr length) {
  literal.getValue() = "http://" and length.getValue() = "7"
  or
  literal.getValue() = "https://" and length.getValue() = "8"
}

predicate comparisonChecksSuccess(IRGuardCondition guard, FunctionCall call, boolean branch) {
  exists(EqualityOperation comparison |
    comparison = guard.getUnconvertedResultExpression() and
    comparison.getAnOperand() = call and
    comparison.getAnOperand().getValue() = "0" and
    (
      comparison instanceof EQExpr and branch = true
      or
      comparison instanceof NEExpr and branch = false
    )
  )
}

predicate stringPrefixGuard(IRGuardCondition guard, Expr checked, boolean branch) {
  exists(FunctionCall call, StringLiteral allowed, Expr length |
    call.getTarget().getName() = ["strncmp", "strncasecmp", "_strnicmp"] and
    isAllowedScheme(allowed, length) and
    call.getArgument(2) = length and
    (
      call.getArgument(0) = checked and call.getArgument(1) = allowed
      or
      call.getArgument(1) = checked and call.getArgument(0) = allowed
    ) and
    comparisonChecksSuccess(guard, call, branch)
  )
  or
  exists(FunctionCall call, StringLiteral allowed |
    call = guard.getUnconvertedResultExpression() and
    call.getTarget().hasQualifiedName("", "QString", "startsWith") and
    call.getArgument(0) = allowed and
    allowed.getValue() = ["http://", "https://"] and
    checked = call.getQualifier() and
    branch = true
  )
}

predicate urlSchemeGuardChecks(IRGuardCondition guard, Expr checked, boolean branch) {
  stringPrefixGuard(guard, checked, branch)
  or
  exists(FunctionCall comparison, FunctionCall scheme, StringLiteral allowed |
    comparison = guard.getUnconvertedResultExpression() and
    comparison.getTarget().getName() = "operator==" and
    scheme.getTarget().hasQualifiedName("", "QUrl", "scheme") and
    scheme = comparison.getQualifier() and
    comparison.getArgument(0) = allowed and
    allowed.getValue() = ["http", "https"] and
    checked = scheme.getQualifier() and
    branch = true
  )
}

module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().hasQualifiedName("", "QDesktopServices", "openUrl") and
      sink.asConvertedExpr() = call.getArgument(0)
    )
    or
    exists(FunctionCall call |
      isShellProtocolHandlerCall(call, _) and
      sink.asIndirectExpr() = call.getArgument(0)
    )
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
    call.getTarget().hasQualifiedName("", "QDesktopServices", "openUrl") and
    sink.getNode().asConvertedExpr() = call.getArgument(0) and
    callType = "QDesktopServices::openUrl()"
    or
    isShellProtocolHandlerCall(call, callType) and
    sink.getNode().asIndirectExpr() = call.getArgument(0)
  )
select call, source, sink,
  callType + " is called with untrusted input from $@ without URL scheme validation.",
  source.getNode(), "this source"
