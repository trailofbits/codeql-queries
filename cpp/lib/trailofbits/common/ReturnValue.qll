import cpp

import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Identifies functions where the return value must be used in some way.
 */
abstract class MustUse extends Function { 
  /**
   * Override this for more detailed messages on why the return value is
   * expected to be used.
   */
  string getMessage() {
    result = "The return value of `" + this.getName() + "` is discarded here"
  }
}

/**
 * Identifies functions where the return value must be checked.
 */
abstract class MustCheck extends Function {
  /**
   * Override this method for more detailed messages on why and how the return
   * value should be checked.
   */
  string getMessage() {
    result = "The return value of `" + this.getName() + "` is not checked"
  }
}

/** 
 * Identifies functions that return a pointer guaranteed not to be `NULL`.
 */
abstract class NotNull extends Function { }

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
   * True if the return value is a pointer guaranteed not to be `NULL`.
   */
  predicate notNull() {
    this.getTarget() instanceof NotNull
  }

  /**
   * Returns true if the corresponding function call is not an expression
   * statement. This means that the return value may be assigned to a variable,
   * but this variable may be unused.
   */
  predicate isUsed() {
    not exists(ExprStmt stmt | this = stmt.getExpr())
  }

  /**
   * Returns true if the return value flows into the condition of a conditional
   * statement or a conditional expression represented by the given control-flow
   * node.
   */
  predicate isCheckedAt(ControlFlowNode node) {
    // The return value flows into the condition of an if-statement.
    DataFlow::localFlow(
        DataFlow::exprNode(this),
        DataFlow::exprNode(node.(IfStmt).getCondition().getAChild*())
    ) or
    // The return value flows into the condition of a while-statement.
    DataFlow::localFlow(
      DataFlow::exprNode(this),
      DataFlow::exprNode(node.(WhileStmt).getCondition().getAChild*())
    ) or
    // The return value flows into the condition of a switch-statement.
    DataFlow::localFlow(
      DataFlow::exprNode(this),
      DataFlow::exprNode(node.(SwitchStmt).getExpr().getAChild*())
    ) or
    // The return value flows into a conditional expression.
    DataFlow::localFlow(
      DataFlow::exprNode(this),
      DataFlow::exprNode(node.(ConditionalExpr).getCondition().getAChild*())
    )
  }

  /**
   * Returns true if the return value flows into the condition of a conditional
   * statement or a conditional expression.
   */
  predicate isChecked() {
    isCheckedAt(_)
  }

  /**
   * True if the return value flows to a return value of the calling function,
   * represented by the given control-flow node. 
   */  
  predicate isReturnedAt(ControlFlowNode node) {
    // The return value is returned by the function.
    DataFlow::localFlow(
      DataFlow::exprNode(this),
      DataFlow::exprNode(node.(ReturnStmt).getExpr().getAChild*())
    )
  }

  /**
   * True if the return value flows to a return value of the calling function.
   */  
  predicate isReturned() {
    isReturnedAt(_)
  }
}
