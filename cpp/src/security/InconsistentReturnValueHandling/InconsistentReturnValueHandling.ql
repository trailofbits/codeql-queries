/**
 * @name Inconsistent handling of return values from a specific function
 * @description If a function's return value is used in `if` statements,
 *              and in a few statements the value is compared somehow differently than it is usually,
 *              then this rare comparisons may indicate bugs.
 *              The query categorizes uses of return values into a few categories
 *              (cmp with int, bool, nullptr, sizeof, another function, ...)
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id tob/cpp/inconsistent-retval-handling
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.IRGuards

newtype TCmpClass =
  Tint()
  or
  Tbool()
  or
  Tnull()
  or
  Tptr()
  or
  Tsizeof(Type s)
  or
  Tcall()
  or
  Targ()
  or
  Tarithm()

class CmpClass extends TCmpClass {
  string toString() {
    this = Tint() and result = " numeric literal"
    or
    this = Tbool() and result = " bool"
    or
    this = Tnull() and result = " null"
    or
    this = Tptr() and result = " pointer"
    or
    exists(Type s | this = Tsizeof(s) and result = " sizeof(" + s + ")")
    or
    this = Tcall() and result = " some function's return value"
    or
    this = Tarithm() and result = " arithmetic expression"
    or
    this = Targ() and result = "in call to some function"
  }
}

// TODO: why codeql does not have IntegralLiteral?
predicate numericLiteral(Expr expr) {
    (
        expr instanceof Literal
        and not (
            expr instanceof BlockExpr
            or
            expr instanceof FormatLiteral	
            or
            expr instanceof NULL
            or
            expr instanceof TextLiteral
            or
            expr instanceof LabelLiteral
            or
            expr.getType() instanceof NullPointerType
        )
    )
    or
    (
        expr instanceof UnaryArithmeticOperation
        and
        numericLiteral(expr.getAChild())
    )
}

predicate binaryComputation(Expr e) {
    e instanceof BinaryArithmeticOperation
    or
    e instanceof BinaryBitwiseOperation
    or
    e instanceof BinaryLogicalOperation
}

/**
 * Categorize expressions using literals instead of types, because
 * we want to differentiate between functions calls and hard-coded stuff 
 */
TCmpClass operandCategory(Expr comparedVal) {
    (numericLiteral(comparedVal) and not comparedVal.getType() instanceof BoolType and result = Tint())
    or
    (numericLiteral(comparedVal) and comparedVal.getType() instanceof BoolType and result = Tbool())
    or
    ((comparedVal.getType() instanceof NullPointerType or comparedVal instanceof NULL) and result = Tnull())
    or
    (comparedVal.getUnderlyingType() instanceof DerivedType and result = Tptr())
    or
    (comparedVal instanceof FunctionCall and result = Tcall())
    or
    (comparedVal instanceof SizeofOperator and
        (
        result = Tsizeof(comparedVal.(SizeofExprOperator).getExprOperand().getType())
        or
        result = Tsizeof(comparedVal.(SizeofTypeOperator).getTypeOperand())
        )
    )
    or
    (binaryComputation(comparedVal) and result = Tarithm())
}

module RetValFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
        source = source
    }

    predicate isSink(DataFlow::Node sink) {
        sink = sink
    }
}
module RetValFlow = DataFlow::Global<RetValFlowConfig>;

Expr getOtherOperand(ComparisonOperation cmp, Expr fcRetVal) {
    if cmp.getRightOperand().getAChild*() = fcRetVal then
        result = cmp.getLeftOperand()
    else
        result = cmp.getRightOperand()
}

predicate categorize(Function f, FunctionCall fc, TCmpClass comparedValCategory, IfStmt ifs) {
    exists(Expr fcRetVal |
        fc.getTarget() = f
        and RetValFlow::flow(
            DataFlow::exprNode(fc),
            DataFlow::exprNode(fcRetVal)
        )
        and ifs.getCondition().getAChild*() = fcRetVal
        and
        if
            // if(func(retVal) == anything)
            exists(FunctionCall anyFc |
                ifs.getCondition().getAChild*() = anyFc
                and anyFc.getAnArgument() = fcRetVal
            )
        then
            comparedValCategory = Targ()
        else
            // if (retVal != comparedVal)
            exists(ComparisonOperation cmp, Expr comparedVal |
                ifs.getCondition().getAChild*() = cmp
                and
                    // if (2*retVal+1 != comparedVal)
                    // if (retVal > 2*anything()+sizeof(struct))
                    if (
                        cmp.getAnOperand().getAChild*() = fcRetVal
                        and binaryComputation(cmp.getAnOperand())
                    )
                    then
                        comparedValCategory = Tarithm()
                    else
                        // if (retVal != comparedVal)
                        comparedVal = getOtherOperand(cmp, fcRetVal)
                        and comparedValCategory = operandCategory(comparedVal)
            )
    )
}

int countAllRetValTypes(Function f) {
    result = count(IfStmt ifs |
        categorize(f, _, _, ifs) |
        ifs
    )
}

int mostCommonRetValType(Function f, TCmpClass mostCommonCategory) {
    result = max(int numberOfRetValTypeInstances |
        categorize(f, _, mostCommonCategory, _)
        and numberOfRetValTypeInstances = count(IfStmt ifs | categorize(f, _, mostCommonCategory, ifs) | ifs)
    )
}

// uncomment for testing:
// from Function f, FunctionCall fc, TCmpClass comparedValCategory, CmpClass x, IfStmt ifs
// where
//     categorize(f, fc, comparedValCategory, ifs)
//     and x = comparedValCategory
// select f, fc, x, ifs


from Function f, int retValsTotalAmount,
    TCmpClass mostCommonCategory, CmpClass mostCommonCategoryClass, int categoryMax,
    TCmpClass buggyCategory, CmpClass buggyCategoryClass, FunctionCall buggyFc
where
    // we are interested only in used functions
    exists(FunctionCall fc | fc.getTarget() = f)
    // and f.hasDefinition()

    // the function's retVal must be used in some IF statements
    and retValsTotalAmount = countAllRetValTypes(f)
    and retValsTotalAmount >= 4

    // now we find how the function's retVal is used most commonly
    and categoryMax = mostCommonRetValType(f, mostCommonCategory)
    and mostCommonCategoryClass = mostCommonCategory

    // if threshold for "most common" use case is ~75%, then remaining 25% function calls are handled somehow incorrectly
    and ((float)(categoryMax * 100) / retValsTotalAmount) >= 74

    // // and finally we are looking for calls that use retVal in an uncommon way
    and categorize(f, buggyFc, buggyCategory, _)
    and buggyCategory != mostCommonCategory
    and buggyCategoryClass = buggyCategory 
    
select buggyFc, "Function $@ return value is usually compared with" + mostCommonCategoryClass + " (" + categoryMax +
    " times), but this call compares with" + buggyCategoryClass, f, f.getName()
