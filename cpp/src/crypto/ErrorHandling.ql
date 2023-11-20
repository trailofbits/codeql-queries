/**
 * @name Missing error handling
 * @id tob/cpp/error-handling
 * @description Checks if returned error codes are properly checked
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision high
 * @group cryptography
 */

import cpp
import trailofbits.crypto.common
import trailofbits.crypto.libraries
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

from
  ErrorCode res
where
  not isChecked(res)
select
  res.getLocation(),
  "The function fails to check the return value of '" + res.getTarget().getName() + "'"
