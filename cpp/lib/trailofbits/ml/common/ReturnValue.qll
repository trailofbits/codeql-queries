import cpp

import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Identifies functions where the return value must be used in some way.
 */
abstract class MustUse extends Function { }

/**
 * Identifies functions where the return value must be checked.
 */
abstract class MustCheck extends Function { }

/**
 * The return value of a function.
 */
class ReturnValue extends FunctionCall {
  /**
   * Returns the function that the return value corresponds to.
   */
  Function getFunction() {
    result = this.getTarget()
  }
  /**
   * True if the return value must be used.
   */
  predicate mustUse() {
    this.getTarget() instanceof MustUse
  }

  /**
   * True if the return value must be used.
   */
  predicate mustCheck() {
    this.getTarget() instanceof MustCheck
  }

  /**
   * Returns true if the corresponding function call is not an expression
   * statement.
   */
  predicate isUsed() {
    not exists(ExprStmt stmt | this = stmt.getExpr())
  }

  /**
   * Returns true if the return value flows into a conditional statement or
   * expression, or a return statement.
   */
  predicate isChecked() {
    // The return value flows into the condition of an if-statement.
    exists (IfStmt is |
      DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(is.getCondition().getAChild*())
      )
    ) or
    // The return value flows into the condition of a while-statement.
    exists (WhileStmt ws |
      DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(ws.getCondition().getAChild*())
      )
    ) or
    // The return value flows into the condition of a switch-statement.
    exists (SwitchStmt ss |
      DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(ss.getExpr().getAChild*())
      )
    ) or
    // The return value flows into a conditional expression.
    exists (ConditionalExpr ce |
      DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(ce.getCondition().getAChild*())
      )
    ) or
    // The return value is returned by the function.
    exists (ReturnStmt rs |
      DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(rs.getExpr().getAChild*())
      )
    )
  }
}
