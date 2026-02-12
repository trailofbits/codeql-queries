/**
 * @name Decrementation overflow when comparing
 * @id tob/cpp/dec-overflow-when-comparing
 * @description This query finds unsigned integer overflows resulting from unchecked decrementation during comparison.
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @security-severity 5.0
 * @group security
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * Holds if `node` overwrites `var` (assignment or declaration with initializer).
 */
predicate isDefOf(ControlFlowNode node, Variable var) {
  node = var.getAnAccess() and node.(VariableAccess).isLValue()
  or
  node.(DeclStmt).getADeclaration() = var and exists(var.getInitializer())
  or
  node.(Assignment).getLValue().(VariableAccess).getTarget() = var
}

/**
 * Find CFG paths from start to end that do not cross over a definition of var.
 */
predicate successorGuarded(ControlFlowNode start, ControlFlowNode end, Variable var) {
  start = end
  or
  exists(ControlFlowNode interm |
    start.getASuccessor() = interm and
    not isDefOf(interm, var) and
    (
      interm.getASuccessor() = end
      or
      successorGuarded(interm, end, var)
    )
  )
}


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

  // only if the variable is used (not just overwritten) after the comparison
  successorGuarded(cmp, varAccAfterOverflow, var) and
  cmp.getAnOperand().getAChild*() != varAccAfterOverflow and
  not exists(AssignExpr ae | ae.getLValue() = varAccAfterOverflow) and

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

  // skip vendor code
  and not dec.getFile().getAbsolutePath().toLowerCase().matches(["%vendor%", "%third_party%"])

select dec, "Unsigned decrementation in comparison ($@) - $@", cmp, cmp.toString(), varAccAfterOverflow, varAccAfterOverflow.toString()
