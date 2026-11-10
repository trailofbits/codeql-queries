/**
 * @name Potentially unguarded protocol handler invocation
 * @id tob/java/unguarded-protocol-handler
 * @description Finds URL protocol handlers called with URLs from untrusted sources
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-939
 * @precision medium
 * @problem.severity warning
 * @security-severity 6.5
 * @group security
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

class DesktopBrowseProtocolHandler extends MethodCall {
  DesktopBrowseProtocolHandler() {
    this.getMethod().hasQualifiedName("java.awt", "Desktop", "browse")
  }

  Expr getUrlArgument() { result = this.getArgument(0) }

  string getHandlerType() { result = "Desktop.browse()" }
}

private ArrayInit getCommandArray(Expr command) {
  result = command.(ArrayInit)
  or
  result = command.(ArrayCreationExpr).getInit()
  or
  exists(VarAccess access |
    command = access and
    result = getCommandArray(access.getVariable().getAnAssignedValue())
  )
}

class RuntimeProtocolHandler extends MethodCall {
  RuntimeProtocolHandler() { this.getMethod().hasQualifiedName("java.lang", "Runtime", "exec") }

  Expr getUrlArgument() {
    result = this.getArgument(0) and result.getType() instanceof TypeString
    or
    exists(ArrayInit command, int urlIndex, int markerIndex, StringLiteral marker |
      command = getCommandArray(this.getArgument(0)) and
      result = command.getInit(urlIndex) and
      marker = command.getInit(markerIndex) and
      marker.getValue().regexpMatch("(?i)(url\\.dll.*FileProtocolHandler|xdg-open|open)") and
      urlIndex > markerIndex
    )
  }

  string getHandlerType() {
    exists(StringLiteral literal |
      literal.getParent*() = this.getArgument(0) and
      (
        literal.getValue().regexpMatch("(?i).*rundll32.*url\\.dll.*FileProtocolHandler.*") and
        result = "rundll32 url.dll,FileProtocolHandler"
        or
        literal.getValue().regexpMatch("(?i).*xdg-open.*") and result = "xdg-open"
        or
        literal.getValue().regexpMatch("(?i).*\\bopen\\b.*") and
        not literal.getValue().regexpMatch("(?i).*xdg-open.*") and
        result = "open"
      )
    )
    or
    exists(ArrayInit command, StringLiteral executable, StringLiteral marker |
      command = getCommandArray(this.getArgument(0)) and
      executable = command.getAnInit() and
      marker = command.getAnInit() and
      (
        executable.getValue().regexpMatch("(?i)rundll32(\\.exe)?") and
        marker.getValue().regexpMatch("(?i)url\\.dll.*FileProtocolHandler") and
        result = "rundll32 url.dll,FileProtocolHandler"
        or
        executable.getValue().regexpMatch("(?i)(xdg-open|open|/usr/bin/open)") and
        result = executable.getValue()
      )
    )
  }
}

class ProcessBuilderProtocolHandler extends ClassInstanceExpr {
  ProcessBuilderProtocolHandler() {
    this.getConstructor().getDeclaringType().hasQualifiedName("java.lang", "ProcessBuilder") and
    exists(MethodCall start |
      start.getMethod().hasQualifiedName("java.lang", "ProcessBuilder", "start") and
      DataFlow::localFlow(DataFlow::exprNode(this), DataFlow::exprNode(start.getQualifier()))
    )
  }

  Expr getUrlArgument() {
    exists(int urlIndex, int markerIndex, StringLiteral marker |
      result = this.getArgument(urlIndex) and
      marker = this.getArgument(markerIndex) and
      marker.getValue().regexpMatch("(?i)(url\\.dll.*FileProtocolHandler|xdg-open|open)") and
      urlIndex > markerIndex
    )
  }

  string getHandlerType() {
    exists(StringLiteral executable, StringLiteral marker |
      executable = this.getAnArgument() and
      marker = this.getAnArgument() and
      (
        executable.getValue().regexpMatch("(?i)rundll32(\\.exe)?") and
        marker.getValue().regexpMatch("(?i)url\\.dll.*FileProtocolHandler") and
        result = "rundll32 url.dll,FileProtocolHandler"
        or
        executable.getValue().regexpMatch("(?i)(xdg-open|open|/usr/bin/open)") and
        result = executable.getValue()
      )
    )
  }
}

predicate protocolHandlerCall(Expr call, Expr url, string handlerType) {
  exists(DesktopBrowseProtocolHandler handler |
    call = handler and
    url = handler.getUrlArgument() and
    handlerType = handler.getHandlerType()
  )
  or
  exists(RuntimeProtocolHandler handler |
    call = handler and
    url = handler.getUrlArgument() and
    handlerType = handler.getHandlerType()
  )
  or
  exists(ProcessBuilderProtocolHandler handler |
    call = handler and
    url = handler.getUrlArgument() and
    handlerType = handler.getHandlerType()
  )
}

predicate urlSchemeGuardChecks(Guard guard, Expr checked, boolean branch) {
  exists(MethodCall comparison, MethodCall scheme, CompileTimeConstantExpr allowed |
    guard = comparison and
    comparison.getMethod().getDeclaringType() instanceof TypeString and
    comparison.getMethod().hasName(["equals", "equalsIgnoreCase"]) and
    (
      scheme = comparison.getQualifier() and allowed = comparison.getArgument(0)
      or
      scheme = comparison.getArgument(0) and allowed = comparison.getQualifier()
    ) and
    allowed.getStringValue() = ["http", "https"] and
    scheme.getMethod().hasName(["getScheme", "getProtocol"]) and
    checked = scheme.getQualifier() and
    branch = true
  )
  or
  exists(MethodCall comparison, CompileTimeConstantExpr allowed |
    guard = comparison and
    comparison.getMethod().getDeclaringType() instanceof TypeString and
    comparison.getMethod().hasName("startsWith") and
    comparison.getArgument(0) = allowed and
    allowed.getStringValue() = ["http://", "https://"] and
    checked = comparison.getQualifier() and
    branch = true
  )
}

module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(Expr call | protocolHandlerCall(call, sink.asExpr(), _))
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<urlSchemeGuardChecks/3>::getABarrierNode()
  }
}

module PotentiallyUnguardedProtocolHandlerFlow =
  TaintTracking::Global<PotentiallyUnguardedProtocolHandlerConfig>;

import PotentiallyUnguardedProtocolHandlerFlow::PathGraph

from
  PotentiallyUnguardedProtocolHandlerFlow::PathNode source,
  PotentiallyUnguardedProtocolHandlerFlow::PathNode sink, Expr call, string handlerType
where
  PotentiallyUnguardedProtocolHandlerFlow::flowPath(source, sink) and
  protocolHandlerCall(call, sink.getNode().asExpr(), handlerType)
select call, source, sink,
  handlerType + " is called with untrusted input from $@ without URL scheme validation.",
  source.getNode(), "this source"
