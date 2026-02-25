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
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.controlflow.StackVariableReachability

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
 * Identifies an unsigned postfix decrement inside a comparison against zero.
 */
pragma[nomagic]
predicate isDecInComparison(
  PostfixDecrExpr dec, VariableAccess varAcc,
  ComparisonOperation cmp, Variable var
) {
  varAcc = var.getAnAccess() and
  dec.getOperand() = varAcc.getExplicitlyConverted() and
  varAcc.getUnderlyingType().(IntegralType).isUnsigned() and
  cmp.getAnOperand().getAChild*() = varAcc and
  cmp.getAnOperand() instanceof Zero and
  lowerBound(varAcc) = 0
}

/**
 * Identifies a non-assignment read of a variable
 * (i.e., a use that could observe an overflowed value).
 */
pragma[nomagic]
predicate isReadOf(VariableAccess va, Variable var) {
  va = var.getAnAccess() and
  not exists(AssignExpr ae | ae.getLValue() = va)
}

/**
 * Basic-block-level reachability from a decrement comparison to a use
 * of the same stack variable, blocked by any definition of the variable.
 */
class DecOverflowReach extends StackVariableReachability {
  DecOverflowReach() { this = "DecOverflowReach" }

  override predicate isSource(ControlFlowNode node, StackVariable v) {
    isDecInComparison(_, _, node, v)
  }

  override predicate isSink(ControlFlowNode node, StackVariable v) {
    isReadOf(node, v)
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    isDefOf(node, v)
  }
}

/**
 * BB-level reachability for non-stack variables (globals, static locals).
 * Holds if `sink` is reachable from the entry of `bb` without crossing
 * a definition of `var`.
 */
private predicate nonStackBBEntryReaches(
  BasicBlock bb, Variable var, ControlFlowNode sink
) {
  exists(int n |
    sink = bb.getNode(n) and
    isReadOf(sink, var) and
    not exists(int m | m < n | isDefOf(bb.getNode(m), var))
  )
  or
  not isDefOf(bb.getNode(_), var) and
  nonStackBBEntryReaches(bb.getASuccessor(), var, sink)
}

/**
 * BB-level reachability from `source` to `sink` for non-stack variables,
 * without crossing a definition of `var`.
 */
pragma[nomagic]
predicate nonStackReaches(
  ComparisonOperation source, Variable var, ControlFlowNode sink
) {
  not var instanceof StackVariable and
  exists(BasicBlock bb, int i |
    bb.getNode(i) = source and
    not bb.isUnreachable()
  |
    exists(int j |
      j > i and
      sink = bb.getNode(j) and
      isReadOf(sink, var) and
      not exists(int k | k in [i + 1 .. j - 1] | isDefOf(bb.getNode(k), var))
    )
    or
    not exists(int k | k > i | isDefOf(bb.getNode(k), var)) and
    nonStackBBEntryReaches(bb.getASuccessor(), var, sink)
  )
}

from
  Variable var, VariableAccess varAcc, PostfixDecrExpr dec,
  VariableAccess varAccAfterOverflow, ComparisonOperation cmp
where
  isDecInComparison(dec, varAcc, cmp, var) and
  isReadOf(varAccAfterOverflow, var) and
  varAcc != varAccAfterOverflow and
  // reachable without intervening overwrite
  (
    any(DecOverflowReach r).reaches(cmp, var, varAccAfterOverflow)
    or
    nonStackReaches(cmp, var, varAccAfterOverflow)
  ) and
  // exclude accesses that are part of the comparison expression itself
  not cmp.getAnOperand().getAChild*() = varAccAfterOverflow and
  // var-- > 0 (0 < var--) then only accesses in false branch matter
  (
    if
      (
        cmp instanceof GTExpr and cmp.getRightOperand() instanceof Zero
        or
        cmp instanceof LTExpr and cmp.getLeftOperand() instanceof Zero
      )
    then cmp.getAFalseSuccessor().getASuccessor*() = varAccAfterOverflow
    else any()
  )

select dec, "Unsigned decrementation in comparison ($@) - $@", cmp, cmp.toString(),
  varAccAfterOverflow, varAccAfterOverflow.toString()
