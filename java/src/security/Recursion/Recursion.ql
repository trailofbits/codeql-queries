/**
 * @name Recursive functions
 * @id tob/java/unbounded-recursion
 * @description Detects possibly unbounded recursive calls
 * @kind path-problem
 * @tags security
 * @precision low
 * @problem.severity warning
 * @security-severity 3.0
 * @group security
 */

import java
import semmle.code.java.dataflow.DataFlow

predicate isTestPackage(RefType referenceType) {
  referenceType.getPackage().getName().toLowerCase().matches("%test%") or
  referenceType.getPackage().getName().toLowerCase().matches("%benchmark%") or
  referenceType.getName().toLowerCase().matches("%test%")
}

class RecursionSource extends MethodCall {
  RecursionSource() { not isTestPackage(this.getCaller().getDeclaringType()) }

  override string toString() {
    result = this.getCaller().toString() + " clls " + this.getCallee().toString()
  }

}

/**
 * Check if the Expr uses directly an argument of the enclosing function
 */
class ParameterOperation extends Expr {
  ParameterOperation() {
      this instanceof BinaryExpr or this instanceof UnaryAssignExpr
      and exists(
        VarAccess va |
        va.getVariable() = this.getEnclosingCallable().getAParameter() |
        this.getAChildExpr+() = va
      )
  }
}

module RecursiveConfig implements DataFlow::StateConfigSig {
  class FlowState = Method;

  predicate isSource(DataFlow::Node node, FlowState state) {
    node.asExpr() instanceof RecursionSource and
    state = node.asExpr().(MethodCall).getCaller()
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    node.asExpr() instanceof RecursionSource and
    state.calls+(node.asExpr().(MethodCall).getCaller()) and
    node.asExpr().(MethodCall).getCallee().calls(state)
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(MethodCall ma  |
      ma = node.asExpr()
      and (
        exists(Expr e | e = ma.getAnArgument() and e instanceof ParameterOperation)
        // or exists(
        //   VarAccess e| 
        //   e = ma.getAnArgument() |
        //   e.getVariable().getAnAssignedValue().getAChildExpr() instanceof ParameterOperation
        // )
      )
    )
  }

  /**
   * Weird but useful deduplication logic
   */
  predicate isBarrierIn(DataFlow::Node node, FlowState state) {
    not node.asExpr() instanceof MethodCall
    or node.asExpr().(MethodCall).getCaller().getLocation().getStartLine() > state.getLocation().getStartLine()
  }
}

module RecursiveFlow = DataFlow::GlobalWithState<RecursiveConfig>;

import RecursiveFlow::PathGraph

/*
 * TODO: This query could be improved with the following ideas:
 *   - limit results to methods that take any user input
 *   - do not return methods that have calls to self (or unbounded recursion) that are conditional
 *   - gather and print whole call graph (list of calls from recursiveMethod to itself)
 */

from RecursiveFlow::PathNode source, RecursiveFlow::PathNode sink
where RecursiveFlow::flowPath(source, sink)
// TODO(dm): de-duplicate results
select sink.getNode(), source, sink, "Found a recursion: "