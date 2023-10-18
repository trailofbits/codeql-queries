/**
 * @name RAND_bytes and BN_rand error handling
 * @id tob/cpp/error-handling
 * @description Checks if care is being taken to perform proper error handling
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision high
 * @group cryptography
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

predicate isChecked(Expr value) {
    // The return value flows into the condition of an if-statement.
    exists (IfStmt is |
        DataFlow::localFlow(
            DataFlow::exprNode(value),
            DataFlow::exprNode(is.getCondition().getAChild*())
        )
    ) or
    // The return value flows into the condition of a while-statement.
    exists (WhileStmt ws |
        DataFlow::localFlow(
            DataFlow::exprNode(value),
            DataFlow::exprNode(ws.getCondition().getAChild*())
        )
    ) or
    // The return value flows into the condition of a switch-statement.
    exists (SwitchStmt ss |
        DataFlow::localFlow(
            DataFlow::exprNode(value),
            DataFlow::exprNode(ss.getExpr().getAChild*())
        )
    )
}

// TODO: This should use an abstract type for functions that return status codes.
predicate isReturnValue(Expr value){
    value.(FunctionCall).getTarget().getName() in ["BN_rand", "RAND_bytes"]
}


from FunctionCall call
where isReturnValue(call)
    and not isChecked(call)
select call.getLocation(), "The function fails to check the return value of '" + call.getTarget().getName() + "'"
