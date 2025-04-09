/**
 * @name Find all problematic implicit casts
 * @description Find all implicit casts that may be problematic. That is, may result in unexpected truncation, reinterpretation or widening of values.
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

private class BufLenFunc extends SimpleRangeAnalysisExpr, FunctionCall {
  BufLenFunc() {
    this.getTarget()
        .getName()
        .matches([
            "buf_len", "buf_reverse_capacity", "buf_forward_capacity", "buf_forward_capacity_total"
          ])
  }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = typeUpperBound(this.getExpectedReturnType()) }

  override predicate dependsOnChild(Expr child) { none() }
}

private class LenApproxFunc extends SimpleRangeAnalysisExpr, FunctionCall {
  LenApproxFunc() {
    this.getTarget().hasName(["recvfrom", "recv", "sendto", "send", "read", "write"])
  }

  override float getLowerBounds() { result = -1 }

  override float getUpperBounds() { result = getFullyConvertedUpperBounds(this.getArgument(2)) }

  override predicate dependsOnChild(Expr child) { child = this.getArgument(2) }
}

private class StrlenFunAssumption extends SimpleRangeAnalysisExpr, FunctionCall {
  StrlenFunAssumption() { this.getTarget().hasName("strlen") }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = 536870911 }

  override predicate dependsOnChild(Expr child) { none() }
}

private class OpenSSLFunc extends SimpleRangeAnalysisExpr, FunctionCall {
  OpenSSLFunc() {
    this.getTarget()
        .getName()
        .matches([
            "EVP_CIPHER_get_block_size", "cipher_ctx_block_size", "EVP_CIPHER_CTX_get_block_size",
            "EVP_CIPHER_block_size", "HMAC_size", "hmac_ctx_size", "EVP_MAC_CTX_get_mac_size",
            "EVP_CIPHER_CTX_mode", "EVP_CIPHER_CTX_get_mode", "EVP_CIPHER_iv_length",
            "cipher_ctx_iv_length", "EVP_CIPHER_key_length", "EVP_MD_size", "EVP_MD_get_size",
            "cipher_kt_iv_size", "cipher_kt_block_size", "EVP_PKEY_get_size", "EVP_PKEY_get_bits",
            "EVP_PKEY_get_security_bits"
          ])
  }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = 32768 }

  override predicate dependsOnChild(Expr child) { none() }
}

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

predicate getLeftRightOrOperands(Expr orExpr, Expr l, Expr r) {
  l = orExpr.(BitwiseOrExpr).getLeftOperand() and
  r = orExpr.(BitwiseOrExpr).getRightOperand()
  or
  l = orExpr.(AssignOrExpr).getLValue() and
  r = orExpr.(AssignOrExpr).getRValue()
}

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

predicate safeLowerBound(Expr cast, IntegralType toType) {
  exists(float lowerB |
    lowerB = lowerBound(cast) and
    lowerB >= typeLowerBound(toType)
  )
  or
  exists(Instruction instr, Bound b, int delta |
    not exists(float knownValue | knownValue = cast.getValue().toFloat()) and
    instr.getUnconvertedResultExpression() = cast and
    boundedInstruction(instr, b, delta, false, _) and // false = lower bound
    lowerBound(b.getInstruction().getUnconvertedResultExpression()) + delta >=
      typeLowerBound(toType)
  )
}

predicate safeUpperBound(Expr cast, IntegralType toType) {
  exists(float upperB |
    upperB = upperBound(cast) and
    upperB <= typeUpperBound(toType)
  )
  or
  exists(Instruction instr, Bound b, int delta |
    not exists(float knownValue | knownValue = cast.getValue().toFloat()) and
    instr.getUnconvertedResultExpression() = cast and
    boundedInstruction(instr, b, delta, true, _) and // true = upper bound
    upperBound(b.getInstruction().getUnconvertedResultExpression()) + delta <=
      typeUpperBound(toType)
  )
}

predicate safeBounds(Expr cast, IntegralType toType) {
  safeLowerBound(cast, toType) and safeUpperBound(cast, toType)
}

from
  IntegralConversion cast, IntegralType fromType, IntegralType toType, Expr castExpr,
  string problemType
where
  cast.isImplicit() and
  fromType = cast.getExpr().getExplicitlyConverted().getUnspecifiedType() and
  toType = cast.getUnspecifiedType() and
  fromType != toType and
  not toType instanceof BoolType and
  cast.getExpr() = castExpr and
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
  not (
    // skip conversions in arithmetic operations
    fromType.getSize() <= toType.getSize() and // should always hold
    exists(BinaryArithmeticOperation arithmetic |
      (
        arithmetic instanceof AddExpr or
        arithmetic instanceof SubExpr or
        arithmetic instanceof MulExpr
      ) and
      arithmetic.getAnOperand().getConversion*() = cast
    )
  ) and
  not (
    // skip some conversions in equality operations
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
  ) and
  // skip casts in call to msg
  not exists(MacroInvocation msgCall |
    msgCall.getMacro().hasName("msg") and
    msgCall.getStmt().getAChild*() = cast.getEnclosingStmt()
  ) and
  // not interesting file
  not cast.getLocation().getFile().getBaseName().matches("options.c")
select cast, "Implicit cast from " + fromType + " to " + toType + " (" + problemType + ")"
