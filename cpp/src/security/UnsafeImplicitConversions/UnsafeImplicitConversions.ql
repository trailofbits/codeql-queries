/**
 * @name Unsafe implicit integer conversion
 * @id tob/cpp/unsafe-implicit-conversions
 * @description Finds implicit integer casts that may overflow or be truncated, with false positive reduction via Value Range Analysis
 * @kind problem
 * @tags security experimental
 * @problem.severity warning
 * @precision low
 * @security-severity 4.0
 * @group security
 **/

import cpp
private import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils


predicate safeLowerBound(Expr cast, IntegralType toType) {
    exists(float lowerB |
        lowerB = lowerBound(cast)
        and lowerB >= typeLowerBound(toType)
    )
}

predicate safeUpperBound(Expr cast, IntegralType toType) {
    exists(float upperB |
        upperB = upperBound(cast)
        and upperB <= typeUpperBound(toType)
    )
}

predicate safeBounds(Expr cast, IntegralType toType) {
    safeLowerBound(cast, toType) and safeUpperBound(cast, toType)
}


from IntegralConversion cast, IntegralType fromType, IntegralType toType
where
    cast.isImplicit()
    and fromType = cast.getExpr().getExplicitlyConverted().getUnspecifiedType()
    and toType = cast.getUnspecifiedType()
    and not toType instanceof BoolType

    and (
        // truncation
        fromType.getSize() > toType.getSize()
        or
        // reinterpretation
        (
            fromType.getSize() = toType.getSize()
            and
            (
                (fromType.isUnsigned() and toType.isSigned())
                or
                (fromType.isSigned() and toType.isUnsigned())
            )
        )
        or
        // widening
        (
            fromType.getSize() < toType.getSize() and fromType.isSigned() and toType.isUnsigned()
        )
    )
    
    // skip if value is in safe range
    and not safeBounds(cast.getExpr(), toType)

    and not (
        // skip conversions in arithmetic operations
        fromType.getSize() <= toType.getSize() // should always hold
        and exists(BinaryArithmeticOperation arithmetic |
            (arithmetic instanceof AddExpr or arithmetic instanceof SubExpr or arithmetic instanceof MulExpr)
            and arithmetic.getAnOperand().getConversion*() = cast
        )
    )

    and not (
        // skip some conversions in equality operations
        fromType.getSize() <= toType.getSize()
        and fromType.isSigned() // should always hold
        and exists(EqualityOperation eq, Expr castHandSide, Expr otherHandSide |
            castHandSide = eq.getAnOperand()
            and otherHandSide = eq.getAnOperand()
            and castHandSide != otherHandSide
            and castHandSide.getConversion*() = cast
            and otherHandSide.getValue().toFloat() < typeUpperBound(toType) + typeLowerBound(fromType)
        )
    )
    
    // skip unused function
    and (
        exists(FunctionCall fc | fc.getTarget() = cast.getEnclosingFunction())
        or
        exists(FunctionAccess fc | fc.getTarget() = cast.getEnclosingFunction())
    )
select cast, "Implicit cast from " + fromType + " to " + toType + "; bounds are [" + lowerBound(cast.getExpr())+ "; " + upperBound(cast.getExpr()) + "]"
