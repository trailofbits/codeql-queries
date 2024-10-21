import cpp
import ReturnValue
import EscapeAnalysis

private import semmle.code.cpp.controlflow.Nullness
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.controlflow.StackVariableReachability

/**
 * A custom `alloc` function which returns a pointer to the allocated memory.
 */
abstract class Alloc extends MustUse {}

/**
 * A custom `free` which takes a pointer to the allocated memory as its only
 * argument. 
 */
abstract class Free extends Function {}

/**
 * A call to `free` for some custom allocator.
 */
class AllocCall extends FunctionCall {
  AllocCall() {
    this.getTarget() instanceof Alloc
  }
}

/**
 * A call to `free` for some custom allocator.
 */
class FreeCall extends FunctionCall {
  FreeCall() {
    this.getTarget() instanceof Free
  }
}

/**
 * A custom allocator is a pair of functions `(alloc, free)`. We assume that
 * `alloc` returns a pointer to the allocated memory, and that `free` takes
 * a pointer to the allocated memory as its only argument.
 */
abstract class CustomAllocator extends string {

  bindingset[this]
  CustomAllocator() { any() }

  /**
   * Is true if `f` is an `alloc` function for the custom allocator. (There
   * may be more than one function that serves as an `alloc` function for the
   * allocator.)
   * 
   * If the `alloc` function takes the allocated pointer as an argument, override 
   * `isAllocatedBy` directly instead.
   */
  abstract predicate isAlloc(Alloc f);

  /**
   * Is true if `f` is a `free` function for the custom allocator. (There
   * may be more than one function that serves as a `free` function for the
   * allocator.)
   * 
   * If the `free` function takes more than one argument, override `isFreedBy`
   * directly instead.
   */
  abstract predicate isFree(Free f);

  /**
   * Returns a call to an `alloc` function.
   */
  AllocCall getAnAllocCall() {
      this.isAlloc(result.getTarget())
  }

  /**
   * Returns a call to a `free` function.
   */
  FreeCall getAFreeCall() {
      this.isFree(result.getTarget())
  }

  /**
   * True if `var` is allocated by the `alloc` call.
   */
  predicate isAllocatedBy(AllocCall alloc, Variable var) {
    alloc = this.getAnAllocCall() and alloc = var.getAnAssignedValue()
  }

  /**
   * True if `var` is freed by the `free` call.
   */
  predicate isFreedBy(FreeCall free, Variable var) {
    free = this.getAFreeCall() and free.getArgument(0) = var.getAnAccess()
  }      
}

class LocalMemoryLeak extends StackVariableReachabilityWithReassignment {
  CustomAllocator alloc;

  LocalMemoryLeak() {
    this = "LocalMemoryLeak"
  }

  override predicate isSourceActual(ControlFlowNode node, StackVariable var) {
    alloc.isAllocatedBy(node, var)
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable var) {
    // A barrier is a call to `free` or an assignment to a variable which
    // escapes the current function.
    alloc.isFreedBy(node, var) or mayEscapeFunctionAt(node, var)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable var) {
    // A sink is either the last statement in the parent scope of the allocated
    // variable, or a return statement in the parent scope which does not return
    // the allocated variable.
    (
      // `node` represents a return statement in the parent scope.
      node.(ReturnStmt).getEnclosingElement*() = var.getParentScope() or 
      // `node` represents the last statement in the parent scope.
      node = var.getParentScope().(BlockStmt).getLastStmtIn()
    ) and
    // `node` does not represent a return statement returning the allocated value.
    not node.(ReturnStmt).getExpr() = var.getAnAccess() and
    // `node` does not represent a call to `free`, freeing the allocated value.
    not isBarrier(node.(Stmt).getAChild*(), var) and
    // `node` is not guarded by a condition ensuring that the variable is `NULL`.
    not checkedNull(var, node)
  }
}

class LocalUseAfterFree extends StackVariableReachabilityWithReassignment {
  CustomAllocator alloc;
  
  LocalUseAfterFree() {
    this = "LocalUseAfterFree"
  }

  override predicate isSourceActual(ControlFlowNode node, StackVariable var) {
    alloc.isFreedBy(node, var)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable var) {
    // A sink is an access which is not a reassignment.
    node = var.getAnAccess() and 
    not isAnAssignment(node, var) 
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable var) {
    // Stop tracking the variable if it is reassigned.
    this.isAnAssignment(node, var)
  }

  /**
   * Returns true if the `node` is the lvalue of an assignment to `var`.
   */
  predicate isAnAssignment(ControlFlowNode node, StackVariable var) {
    node = var.getAnAssignedValue()
  }
}
