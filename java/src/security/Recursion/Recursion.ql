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

class RecursionSource extends Method {
  RecursionSource() {
    not isTestPackage(this.getDeclaringType()) and
    this.calls+(this)
  }
}

/**
 * Check if the Expr uses directly an argument of the enclosing function
 */
class ParameterOperation extends Expr {
  ParameterOperation() {
    (this instanceof BinaryExpr or this instanceof UnaryAssignExpr) and
    exists(VarAccess va | va.getVariable() = this.getEnclosingCallable().getAParameter() |
      this.getAChildExpr+() = va
    )
  }
}

module RecursiveConfig implements DataFlow::StateConfigSig {
  class FlowState = Method;

  predicate isSource(DataFlow::Node node, FlowState firstMethod) {
    node.asExpr().(MethodCall).getCallee() instanceof RecursionSource and
    firstMethod = node.asExpr().(MethodCall).getCallee()
  }

  predicate isSink(DataFlow::Node node, FlowState firstMethod) {
    node.asExpr().(MethodCall).getCallee().calls(firstMethod) and
    firstMethod.calls+(node.asExpr().(MethodCall).getCaller())
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(MethodCall ma |
      ma = node.asExpr() and
      exists(Expr e | e = ma.getAnArgument() and e instanceof ParameterOperation)
    )
  }
  // /**
  //  * Weird but useful deduplication logic
  //  */
  // predicate isBarrierOut(DataFlow::Node node, FlowState state) {
  //   node.asExpr().(MethodCall).getCallee().getName() > state.getName()
  // }
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
select sink.getNode(), source, sink, "Found a recursion: "
