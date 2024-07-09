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

/**
 * Categories for uses of functions' return values
 */
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
    this = Targ() and result = "in a function"
  }
}

/**
 * Literals like 3, 123, 43, 2
 */
pragma[inline]
predicate numericLiteral(Expr expr) {
    expr instanceof Literal
    and not expr instanceof BlockExpr
    and not expr instanceof FormatLiteral   
    and not expr instanceof NULL
    and not expr instanceof TextLiteral
    and not expr instanceof LabelLiteral
    and not expr.getType() instanceof NullPointerType
    and not expr.getType() instanceof BoolType
}

/**
 * Literals like 3, 123, -43, +2
 * TODO: why codeql for cpp does not have IntegralLiteral?
 */
pragma[inline]
predicate numericArithmLiteral(Expr expr) {
    numericLiteral(expr)
    or
    (
        expr instanceof UnaryArithmeticOperation
        and
        numericLiteral(expr.getAChild())
    )
}

pragma[inline]
predicate binaryComputation(Expr e) {
    e instanceof BinaryArithmeticOperation
    or
    e instanceof BinaryBitwiseOperation
    or
    e instanceof BinaryLogicalOperation
}

pragma[inline]
Expr getOtherOperand(ComparisonOperation cmp, Expr fcRetVal) {
    (cmp.getRightOperand().getAChild*() = fcRetVal and result = cmp.getLeftOperand())
    or
    (cmp.getLeftOperand().getAChild*() = fcRetVal and result = cmp.getRightOperand())
}

/**
 * Categorize expressions using mostly literals instead of types, because
 * we want to differentiate between functions calls and hard-coded stuff.
 */
pragma[inline]
TCmpClass operandCategory(Expr comparedVal) {
    (numericArithmLiteral(comparedVal) and result = Tint())
    or
    (comparedVal instanceof Literal and comparedVal.getType() instanceof BoolType and result = Tbool())
    or
    ((comparedVal.getType() instanceof NullPointerType or comparedVal instanceof NULL) and result = Tnull())
    or
    (comparedVal.getUnderlyingType() instanceof DerivedType and result = Tptr())
    or
    (comparedVal instanceof Call and result = Tcall())
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

// module RetValFlowConfig implements DataFlow::ConfigSig {
//     predicate isSource(DataFlow::Node source) {
//         source.asExpr() = any(Call f)
//     }

//     predicate isSink(DataFlow::Node sink) {
//         exists(IfStmt ifs | ifs.getCondition().getAChild*() = sink.asExpr())
//     }
// }
// module RetValFlow = DataFlow::Global<RetValFlowConfig>;

/**
 * Given function's return value, find its first use in an IF statement
 * and assign proper TCmpClass category
 */
predicate categorize(Function f, Call fc, TCmpClass comparedValCategory, IfStmt ifs) {
    exists(Expr fcRetVal |
        fc.getTarget() = f
        and ifs.getCondition().getAChild*() = fcRetVal

        // we could use global DF with a barrier, but that would return a lot of false positives
        and DataFlow::localFlow(
            DataFlow::exprNode(fc),
            DataFlow::exprNode(fcRetVal)
        )
        
        // exclude far-reaching flows, when the ret val is not checked but is actually used
        // in other words, find only the first use in an IF statement 
        and not exists(IfStmt ifsPrev |
            ifsPrev != ifs
            and DataFlow::localFlow(
                DataFlow::exprNode(fc),
                DataFlow::exprNode(ifsPrev.getCondition().getAChild*())
            )
        )

        and
        if
            // if(func(retVal))
            exists(Call anyFc |
                ifs.getCondition().getAChild*() = anyFc
                and anyFc.getAnArgument().getAChild*() = fcRetVal
            )
        then
            comparedValCategory = Targ()
        else (
            // if (retVal != comparedVal)
            exists(ComparisonOperation cmp |
                ifs.getCondition().getAChild*() = cmp
                // skip if we are passing the return value to some function
                and not exists(Call tmpCall |
                    cmp.getAChild*() = tmpCall
                    and tmpCall.getAnArgument().getAChild*() = fcRetVal
                )
                and (
                    // if (2*retVal+1 != comparedVal)
                    // if (retVal > 2*anything()+sizeof(struct))
                    if (
                        cmp.getAnOperand().getAChild*() = fcRetVal
                        and binaryComputation(cmp.getAnOperand())
                    )
                    then
                        comparedValCategory = Tarithm()
                    else (
                        // if (retVal != comparedVal)
                        comparedValCategory = operandCategory(getOtherOperand(cmp, fcRetVal))
                    )
                )
            )
        )
    )
}

/**
 * Count all eligible IF statements that
 * checks return values of the given function
 */
int countAllRetValTypes(Function f) {
    result = count(IfStmt ifs |
        categorize(f, _, _, ifs) |
        ifs
    )
}

/**
 * Determine what is the most commont TCmpClass category
 * for the given function (by counting eligible IF statements)
 */
int mostCommonRetValType(Function f, TCmpClass mostCommonCategory) {
    result = max(int numberOfRetValTypeInstances |
        categorize(f, _, mostCommonCategory, _)
        and numberOfRetValTypeInstances = count(IfStmt ifs | categorize(f, _, mostCommonCategory, ifs) | ifs)
    )
}

// uncomment for testing:
// from Function f, Call fc, TCmpClass comparedValCategory, CmpClass x, IfStmt ifs
// where
//     categorize(f, fc, comparedValCategory, ifs)
//     and x = comparedValCategory
//     // and f.getName() = "sshbuf_fromb"
// select f, fc, x, ifs


from Function f, int retValsTotalAmount,
    TCmpClass mostCommonCategory, CmpClass mostCommonCategoryClass, int categoryMax,
    TCmpClass buggyCategory, CmpClass buggyCategoryClass, Call buggyFc,
    IfStmt ifs
where
    not buggyFc.getLocation().getFile().toString().toLowerCase().regexpMatch(".*test.*")
    // we are interested only in defined (e.g., not libc) and used functions
    and exists(Call fc | fc.getTarget() = f)
    and f.hasDefinition()

    // the function's retVal must be used in some IF statements
    and retValsTotalAmount = countAllRetValTypes(f)
    and retValsTotalAmount >= 4

    // now we find how the function's retVal is used most commonly
    and categoryMax = mostCommonRetValType(f, mostCommonCategory)
    and mostCommonCategoryClass = mostCommonCategory

    // if threshold for "most common" use case is ~75%, then remaining 25% function calls are handled somehow incorrectly
    and ((float)(categoryMax * 100) / retValsTotalAmount) >= 74

    // // and finally we are looking for calls that use retVal in an uncommon way
    and categorize(f, buggyFc, buggyCategory, ifs)
    and buggyCategory != mostCommonCategory
    and buggyCategoryClass = buggyCategory

    // return value could be used multiple times in a single IF statement
    // don't show such findings
    and not categoryMax = retValsTotalAmount
    
select buggyFc, "Function $@ return value is usually compared with" + mostCommonCategoryClass + " (" + categoryMax +
    " of " + retValsTotalAmount + " times), but this call compares with" + buggyCategoryClass + " $@",
    f, f.getName(), ifs, "here"
