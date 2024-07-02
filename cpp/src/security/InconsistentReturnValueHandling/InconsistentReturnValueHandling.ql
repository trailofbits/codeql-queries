/**
 * @name Inconsistent handling of return values from a specific function
 * @description If a function returns a value that is used in `if` statements,
 *  and in some statements the value is compared differently than in some other statements, this implies a possible bugs.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id tob/cpp/inconsistent-retval-handling
 * @tags security
 */

 /**
 * Possible inconsistencies
 * - small % of values is compared to a different type (int, bool, nullptr, retval of a function, ...)
 */


import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.IRGuards

newtype TCmpClass =
  Tint()
  or
  Tnull()
  or
  Tptr()
  or
  Tsizeof()
  or
  Tcall()
  or
  Targ()

class CmpClass extends TCmpClass {
  string toString() {
    this = Tint() and result = "int"
    or
    this = Tnull() and result = "null"
    or
    this = Tptr() and result = "ptr"
    or
    this = Tsizeof() and result = "sizeof"
    or
    this = Tcall() and result = "call"
    or
    this = Targ() and result = "arg"
  }
}

Expr getOtherOperand(ComparisonOperation cmp, Expr fcRetVal) {
    if cmp.getRightOperand() = fcRetVal then
        result = cmp.getLeftOperand()
    else
        result = cmp.getRightOperand()
}

// TODO: why codeql does not have IntegralLiteral?
predicate numericLiteral(Expr expr) {
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
}

int countRetValType(Function f, TCmpClass comparedValCategory, FunctionCall fc) {
    result = count(Expr fcRetVal, IfStmt ifs |
        fc.getTarget() = f
        and DataFlow::localFlow(
            DataFlow::exprNode(fc),
            DataFlow::exprNode(fcRetVal)
        )
        and fcRetVal = ifs.getCondition().getAChild*()
        and (
            (
                // if (retVal != comparedVal)
                exists(ComparisonOperation cmp, Expr comparedVal |
                    ifs.getCondition() = cmp
                    and comparedVal = getOtherOperand(cmp, fcRetVal)
                    and comparedValCategory = operandCategory(comparedVal)
                )
            )
            or
            (
                // if(func(retVal) != anything)
                exists(FunctionCall anyFc |
                    ifs.getCondition().getAChild*() = anyFc
                    and anyFc.getAnArgument() = fcRetVal
                    and comparedValCategory = Targ()
                )
            )
        )
        |
        comparedValCategory
    )
}

TCmpClass operandCategory(Expr comparedVal) {
    (numericLiteral(comparedVal) and result = Tint())
    or
    ((comparedVal.getType() instanceof NullPointerType or comparedVal instanceof NULL) and result = Tnull())
    or
    (comparedVal.getUnderlyingType() instanceof DerivedType and result = Tptr())
}

from Function f, int categoryCount,
    TCmpClass mostCommonCategory, CmpClass mostCommonCategoryClass, int categoryMax
    // TCmpClass buggyCategory, CmpClass buggyCategoryClass, FunctionCall buggyFc
where
    // we are interested only in defined and used functions
    exists(FunctionCall fc | fc.getTarget() = f)
    and f.hasDefinition()

    // the function's retVal must be used in some IF statements
    and categoryCount = countRetValType(f, _, _)
    and categoryCount > 2

    // now we find how the function's retVal is used most commonly
    and mostCommonCategory = max(| categoryMax = countRetValType(f, mostCommonCategory, _) | mostCommonCategory order by categoryMax)
    and mostCommonCategoryClass = mostCommonCategory

    // if threshold for "most common" use case is 80%, then remaining 20% function calls are handled incorrectly
    // and ((float)(categoryMax * 100) / categoryCount) >= 80

    // // and finally we are looking for calls that use retVal in an uncommon way
    // and countRetValType(f, buggyCategory, buggyFc) != 0
    // and buggyCategory != mostCommonCategory
    // and buggyCategoryClass = buggyCategory 
    
// select buggyFc, "Function $@ is usually compared with " + mostCommonCategoryClass + "(" + categoryMax +
//     " times), but this call compares with " + buggyCategoryClass, f, f.getName()

select f, mostCommonCategoryClass, categoryMax



// class RetValCheck {

// }

// predicate typicalRetValComparison(Function f) {

// }

// from Function f, FunctionCall fc, ControlFlowNode test, GuardCondition guard
// where 
//   fc.getTarget() = f
//   and guard.controls(fc.getBasicBlock(), _)
//   and test = guard.getTest()
//   and fc = rank[1 .. 5](FunctionCall a, string t, int c |
//     a.getTarget() = f
//     and any(RelationalOperation ro | ro = test.getElement() |
//       ro.getGreaterOperand() = a or ro.getLesserOperand() = a
//     ).getFullyConverted().getType().getName() = t
//     order by c = count(fc)
//     ).first()
// select f, fc, "Inconsistent return value handling found in function calls to \"" + f.getQualifiedName() + "\". The comparison type used in \"" + fc.toString() + "\" is not the most common comparison type."