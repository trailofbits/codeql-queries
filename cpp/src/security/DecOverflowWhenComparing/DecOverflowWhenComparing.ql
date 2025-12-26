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

from Variable var, VariableAccess varAcc, DecrementOperation dec,
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
  cmp.getASuccessor+() = varAccAfterOverflow and
  cmp.getAnOperand().getAChild*() != varAccAfterOverflow and

  // skip if the variable is overwritten
  // TODO: handle loops correctly
  // not exists(VariableAccess varAccLV | varAccLV.isUsedAsLValue() |
  //   varAccLV = var.getAnAccess() and
  //   varAccLV != varAcc and
  //   varAccLV != varAccAfterOverflow and
  //   cmp.getASuccessor+() = varAccLV and
  //   varAccAfterOverflow.getAPredecessor+() = varAccLV
  // ) and

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
select cmp, varAccAfterOverflow