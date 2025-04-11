/**
 * @name Find all problematic implicit casts
 * @description Find all implicit casts that may be problematic. That is, casts that may result in unexpected truncation, reinterpretation or widening of values.
 * @kind problem
 * @id tob/cpp/unsafe-implicit-conversions
 * @tags security
 * @problem.severity warning
 * @precision medium
 */

import cpp
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
private import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisDefinition
private import experimental.semmle.code.cpp.rangeanalysis.RangeAnalysis
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * Models standard I/O functions that return a length value bounded by their size argument
 * with possible -1 error return value
 */
private class LenApproxFunc extends SimpleRangeAnalysisExpr, FunctionCall {
  LenApproxFunc() {
    this.getTarget().hasName(["recvfrom", "recv", "sendto", "send", "read", "write"])
  }

  override float getLowerBounds() { result = -1 }

  override float getUpperBounds() { result = getFullyConvertedUpperBounds(this.getArgument(2)) }

  override predicate dependsOnChild(Expr child) { child = this.getArgument(2) }
}

/*
 * Uncomment the class below to silent findings that require large strings
 * to be passed to strlen to be exploitable.
 */

/*
 * private class StrlenFunAssumption extends SimpleRangeAnalysisExpr, FunctionCall {
 *  StrlenFunAssumption() { this.getTarget().hasName("strlen") }
 *
 *  override float getLowerBounds() { result = 0 }
 *
 *  override float getUpperBounds() { result = 536870911 }
 *
 *  override predicate dependsOnChild(Expr child) { none() }
 * }
 */

/**
 * Determines if a function's address is taken in the codebase.
 * This indicates that the function may be called while
 * the call is not in the FunctionCall class.
 */
predicate addressIsTaken(Function f) {
  exists(FunctionCall call | call.getAnArgument().getFullyConverted() = f.getAnAccess())
  or
  exists(Expr e |
    e.getFullyConverted() = f.getAnAccess() and
    e.getType() instanceof FunctionPointerType
  )
  or
  exists(Variable v |
    v.getInitializer().getExpr().getFullyConverted() = f.getAnAccess() and
    v.getType() instanceof FunctionPointerType
  )
  or
  exists(ArrayAggregateLiteral arrayInit |
    arrayInit.getAnElementExpr(_).getFullyConverted() = f.getAnAccess()
  )
  or
  exists(ReturnStmt ret | ret.getExpr().getFullyConverted() = f.getAnAccess())
}

/**
 * Propagates argument range information from function calls to function parameters
 */
class ConstrainArgs extends SimpleRangeAnalysisDefinition {
  private Function func;
  private Parameter param;
  private FunctionCall call;

  ConstrainArgs() {
    param.getFunction() = func and
    call.getTarget() = func and
    call.getEnclosingFunction() != func and
    param.getType().getUnspecifiedType() instanceof IntegralType and
    this = param.getFunction().getEntryPoint() and
    not addressIsTaken(func)
  }

  override predicate hasRangeInformationFor(StackVariable v) { v = param }

  override float getLowerBounds(StackVariable v) {
    v = param and
    result = getFullyConvertedLowerBounds(call.getArgument(param.getIndex()))
  }

  override float getUpperBounds(StackVariable v) {
    v = param and
    result = getFullyConvertedUpperBounds(call.getArgument(param.getIndex()))
  }

  override predicate dependsOnExpr(StackVariable v, Expr e) {
    v = param and
    e = call.getArgument(param.getIndex())
  }
}

/**
 * Helper to extract left and right operands from bitwise OR operations
 */
predicate getLeftRightOrOperands(Expr orExpr, Expr l, Expr r) {
  l = orExpr.(BitwiseOrExpr).getLeftOperand() and
  r = orExpr.(BitwiseOrExpr).getRightOperand()
  or
  l = orExpr.(AssignOrExpr).getLValue() and
  r = orExpr.(AssignOrExpr).getRValue()
}

/**
 * Provides range analysis for bitwise OR operations with non-negative constants
 */
private class ConstantBitwiseOrExprRange extends SimpleRangeAnalysisExpr {
  ConstantBitwiseOrExprRange() {
    exists(Expr l, Expr r | getLeftRightOrOperands(this, l, r) |
      // No operand can be a negative constant
      not (evaluateConstantExpr(l) < 0 or evaluateConstantExpr(r) < 0)
    )
  }

  Expr getLeftOperand() { getLeftRightOrOperands(this, result, _) }

  Expr getRightOperand() { getLeftRightOrOperands(this, _, result) }

  override float getLowerBounds() {
    // If an operand can have negative values, the lower bound is unconstrained.
    // Otherwise, the upper bound is the sum of upper bounds.
    exists(float lLower, float rLower |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      (
        (lLower < 0 or rLower < 0) and
        result = exprMinVal(this)
        or
        result = lLower.maximum(rLower)
      )
    )
  }

  override float getUpperBounds() {
    // If an operand can have negative values, the upper bound is unconstrained.
    // Otherwise, the upper bound is the greatest upper bound.
    exists(float lLower, float lUpper, float rLower, float rUpper |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      (
        (lLower < 0 or rLower < 0) and
        result = exprMaxVal(this)
        or
        result = rUpper + lUpper
      )
    )
  }

  override predicate dependsOnChild(Expr child) {
    child = this.getLeftOperand() or child = this.getRightOperand()
  }
}

/**
 * Checks if an expression has a safe lower bound for conversion to the given type
 * using both SimpleRangeAnalysis and IR-based RangeAnalysis
 */
predicate safeLowerBound(Expr cast, IntegralType toType) {
  exists(float lowerB |
    lowerB = lowerBound(cast) and
    lowerB >= typeLowerBound(toType)
  )
  // comment the exists formula below to speed up the query
  or
  exists(Instruction instr, Bound b, int delta |
    not exists(float knownValue | knownValue = cast.getValue().toFloat()) and
    instr.getUnconvertedResultExpression() = cast and
    boundedInstruction(instr, b, delta, false, _) and // false = lower bound
    lowerBound(b.getInstruction().getUnconvertedResultExpression()) + delta >=
      typeLowerBound(toType)
  )
}

/**
 * Checks if an expression has a safe upper bound for conversion to the given type
 * using both SimpleRangeAnalysis and IR-based RangeAnalysis
 */
predicate safeUpperBound(Expr cast, IntegralType toType) {
  exists(float upperB |
    upperB = upperBound(cast) and
    upperB <= typeUpperBound(toType)
  )
  // comment the exists formula below to speed up the query
  or
  exists(Instruction instr, Bound b, int delta |
    not exists(float knownValue | knownValue = cast.getValue().toFloat()) and
    instr.getUnconvertedResultExpression() = cast and
    boundedInstruction(instr, b, delta, true, _) and // true = upper bound
    upperBound(b.getInstruction().getUnconvertedResultExpression()) + delta <=
      typeUpperBound(toType)
  )
}

/**
 * Checks if an expression has both safe lower and upper bounds for conversion to the given type
 */
predicate safeBounds(Expr cast, IntegralType toType) {
  safeLowerBound(cast, toType) and safeUpperBound(cast, toType)
}

/**
 * Taint tracking from user-controlled inputs to implicit conversions
 * UNUSED: uncomment the code below (near "select") to use
 */
module UnsafeUserInputConversionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(RemoteFlowSourceFunction remoteFlow |
      remoteFlow = source.asExpr().(Call).getTarget() and
      remoteFlow.hasRemoteFlowSource(_, _)
    )
    or
    exists(LocalFlowSourceFunction localFlow |
      localFlow = source.asExpr().(Call).getTarget() and
      localFlow.hasLocalFlowSource(_, _)
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(IntegralConversion cast |
      cast.isImplicit() and
      cast.getExpr() = sink.asExpr()
    )
  }
}

module UnsafeUserInputConversionFlow = TaintTracking::Global<UnsafeUserInputConversionConfig>;

from
  IntegralConversion cast, IntegralType fromType, IntegralType toType, Expr castExpr,
  string problemType
where
  cast.getExpr() = castExpr and
  // only implicit conversions
  cast.isImplicit() and
  // the cast expression has attached all explicit and implicit casts; we skip all conversions up to the last explicit casts
  fromType = castExpr.getExplicitlyConverted().getUnspecifiedType() and
  toType = cast.getUnspecifiedType() and
  // skip same type casts and casts to bools
  fromType != toType and
  not toType instanceof BoolType and
  // limit findings to only possibly problematic cases
  (
    // truncation
    problemType = "truncation" and
    fromType.getSize() > toType.getSize() and
    not safeBounds(castExpr, toType)
    or
    // reinterpretation
    problemType = "reinterpretation" and
    fromType.getSize() = toType.getSize() and
    (
      fromType.isUnsigned() and toType.isSigned() and not safeUpperBound(castExpr, toType)
      or
      fromType.isSigned() and toType.isUnsigned() and not safeLowerBound(castExpr, toType)
    )
    or
    // widening
    fromType.getSize() < toType.getSize() and
    (
      problemType = "widening" and
      fromType.isSigned() and
      toType.isUnsigned() and
      not safeLowerBound(castExpr, toType)
      or
      // unsafe promotion
      problemType = "promotion with bitwise complement" and
      exists(ComplementExpr complement | complement.getOperand().getConversion*() = cast)
    )
  ) and
  // skip conversions in some arithmetic operations
  not (
    fromType.getSize() <= toType.getSize() and
    exists(BinaryArithmeticOperation arithmetic |
      (
        arithmetic instanceof AddExpr or
        arithmetic instanceof SubExpr or
        arithmetic instanceof MulExpr
      ) and
      arithmetic.getAnOperand().getConversion*() = cast
    )
  ) and
  // skip some conversions in some equality operations
  not (
    fromType.getSize() <= toType.getSize() and
    fromType.isSigned() and // should always hold
    exists(EqualityOperation eq, Expr castHandSide, Expr otherHandSide |
      castHandSide = eq.getAnOperand() and
      otherHandSide = eq.getAnOperand() and
      castHandSide != otherHandSide and
      castHandSide.getConversion*() = cast and
      otherHandSide.getValue().toFloat() < typeUpperBound(toType) + typeLowerBound(fromType)
    )
  ) and
  // skip unused function
  (
    exists(FunctionCall fc | fc.getTarget() = cast.getEnclosingFunction())
    or
    exists(FunctionAccess fc | fc.getTarget() = cast.getEnclosingFunction())
    or
    cast.getEnclosingFunction().getName() = "main"
    or
    addressIsTaken(cast.getEnclosingFunction())
  )
// Uncomment to report conversions with untrusted inputs only
/*
 *  and exists(DataFlow::Node source, DataFlow::Node sink |
 *    cast.getExpr() = sink.asExpr() and
 *    UnsafeUserInputConversionFlow::flow(source, sink)
 *  )
 */

select cast, "Implicit cast from " + fromType + " to " + toType + " (" + problemType + ")"
