/**
 * @name Iterator invalidation
 * @id tob/cpp/iterator-invalidation
 * @description Modifying a container while iterating over it can invalidate
 *              iterators, leading to undefined behavior.
 * @kind problem
 * @tags security correctness
 * @problem.severity warning
 * @precision medium
 * @security-severity 7.5
 * @group security
 */

import cpp
import trailofbits.itergator.Iterators
import trailofbits.itergator.DataFlow
import trailofbits.itergator.invalidations.STL
import trailofbits.itergator.invalidations.Destructor

class NotStackVariable extends Variable {
  NotStackVariable() { not this instanceof StackVariable }
}

Variable nodeToVariable(DataFlow::Node node) { result = node.asExpr().(VariableAccess).getTarget() }

predicate falsePositive(Iterator it, Invalidator inv) {
  forex(ControlFlowNode n | n = inv.getASuccessor() |
    n.(BreakStmt).getBreakable().(Loop) = it.getParentScope()
    or
    n.(ReturnStmt).getEnclosingFunction() = it.getParentScope+()
    or
    exists(ExitBasicBlock b |
      b = n.getBasicBlock() and
      b.getEnclosingFunction() = it.getParentScope+() and
      not b.contains(it.getAnAccess())
    )
  )
  or
  inv = it.getAnAssignedValue()
}

predicate invalidatesChild(Invalidation invd, Expr container) {
  invd.getTarget().(PotentialInvalidation).invalidatedChild(invd) = container
}

from
  int significance, DataFlow::Node source, DataFlow::Node invalidationNode,
  DataFlow::Node iteratedNode, DataFlow::Node invalidatorNode, Invalidator inv, Iterated itd,
  Iterator it, Invalidation invd
where
  itd = iteratedNode.asExpr() and
  itd = inv.iterated() and
  it = itd.iterator() and
  inv = invalidatorNode.asExpr().getEnclosingElement() and
  invalidatesChild(inv.invalidation(), invalidationNode.asExpr()) and
  invd = invalidationNode.asExpr().getEnclosingElement() and
  // make sure the actions can operate on the same values
  (
    // the same value flows to the iterator, the invalidator, and the invalidation
    IteratedFlow::flow(source, iteratedNode) and
    InvalidatorFlow::flow(source, invalidatorNode) and
    InvalidationFlow::flow(source, invalidationNode) and
    InvalidationFlow::flow(invalidatorNode, invalidationNode) and
    significance = 0
    or
    // or some access of the iterated variable flows to the invalidation
    exists(DataFlow::Node source2 |
      IteratedFlow::flow(source, iteratedNode) and
      InvalidationFlow::flow(source2, invalidationNode) and
      // stack variables should have sequential flow (caught by above)
      nodeToVariable(source).(NotStackVariable) = nodeToVariable(source2).(NotStackVariable) and
      (
        nodeToVariable(source) instanceof GlobalOrNamespaceVariable and significance = 1
        or
        not nodeToVariable(source) instanceof GlobalOrNamespaceVariable and significance = 2
      )
    )
  ) and
  not falsePositive(it, inv)
select itd,
  "Iterating over this container may cause undefined behavior: $@ can invalidate active iterators.",
  inv, inv.toString()
