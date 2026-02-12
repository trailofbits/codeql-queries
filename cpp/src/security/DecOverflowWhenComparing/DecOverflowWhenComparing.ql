/**
 * @name Decrementation overflow when comparing
 * @id tob/cpp/dec-overflow-when-comparing
 * @description This query finds unsigned integer overflows resulting from unchecked decrementation during comparison.
 * @kind graph
 * @tags security
 * @problem.severity error
 * @precision high
 * @security-severity 5.0
 * @group security
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

query predicate nodes(ControlFlowNode node, string key, string value) {
  exists(Variable var, PostfixDecrExpr dec |
    dec.getOperand() = var.getAnAccess().getExplicitlyConverted() and
    var.getUnderlyingType().(IntegralType).isUnsigned() and
    successorGuarded(node, _, var) and
    key = node.toString() and
    value = node.toString() + "-val"
  )
}

query predicate edges(ControlFlowNode source, ControlFlowNode target, string key, string value) {
  exists(Variable var, PostfixDecrExpr dec, VariableAccess acc |
    var.getAnAccess() = acc and
    dec.getOperand() = acc.getExplicitlyConverted() and
    var.getUnderlyingType().(IntegralType).isUnsigned() and
    
    source.getASuccessor() = target and

    key = source.toString()  + "-key" and
    value = target.toString() + "-val"
  )
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "graph"
}

/**
 * Find CFG paths from start to end that do not cross over node that is var's lvalue access
 * TODO: there must be an API for that...
 */
predicate successorGuarded(ControlFlowNode start, ControlFlowNode end, Variable var) {
  start = end
  or
  exists(ControlFlowNode interm |
    start.getASuccessor() = interm and

    // break the path if variable is overwritten
    not (
      interm = var.getAnAccess() and
      interm.(VariableAccess).isLValue()
    ) and

    (
      interm.getASuccessor() = end
      or
      successorGuarded(interm, end, var)
    )
  )
}

/*
from Variable var, VariableAccess varAcc, PostfixDecrExpr dec,
  VariableAccess varAccAfterOverflow, ComparisonOperation cmp
where
  // get unsigned variable that is decremented
  varAcc = var.getAnAccess() and
  varAccAfterOverflow = var.getAnAccess() and
  varAcc != varAccAfterOverflow and
  dec.getOperand() = varAcc.getExplicitlyConverted() and
  varAcc.getUnderlyingType().(IntegralType).isUnsigned() and

  // only decrementations inside comparisons
  cmp.getAnOperand().getAChild*() = varAcc and
  cmp.getAnOperand() instanceof Zero and

  // only if the variable is used after the comparison
  successorGuarded(cmp, varAccAfterOverflow, var) and
  cmp.getAnOperand().getAChild*() != varAccAfterOverflow and

  // var-- > 0 (0 < var--) then accesses only in false branch
  // var-- >= 0 then accesses in all branches
  // var-- == 0 then accesses in all branches
  // var-- != 0 then accesses in all branches
  if (
    (cmp instanceof GTExpr and cmp.getRightOperand() instanceof Zero)
    or
    (cmp instanceof LTExpr and cmp.getLeftOperand() instanceof Zero)
  )
  then
    cmp.getAFalseSuccessor().getASuccessor*() = varAccAfterOverflow
  else
    any()

  and

  // only if var may possibly be zero during comparison
  lowerBound(varAcc) = 0

  // skip tests etc
  and not dec.getFile().getAbsolutePath().toLowerCase().matches(["%test%", "%vendor%", "%third_party%"])

select dec, "Unsigned decrementation in comparison ($@) - $@", cmp, cmp.toString(), varAccAfterOverflow, varAccAfterOverflow.toString()

*/