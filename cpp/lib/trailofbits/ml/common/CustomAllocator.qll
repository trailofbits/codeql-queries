import cpp
import ReturnValue

private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.controlflow.StackVariableReachability

/**
 * A custom `alloc` function which returns a pointer to the allocated memory.
 */
abstract class Alloc extends MustCheck {}

/**
 * A custom `free` which takes a pointer to the allocated memory as its only
 * argument. 
 */
abstract class Free extends Function {}

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
    abstract predicate isAlloc(Function f);

    /**
     * Is true if `f` is a `free` function for the custom allocator. (There
     * may be more than one function that serves as a `free` function for the
     * allocator.)
     * 
     * If the `free` function takes more than one argument, override `isFreedBy`
     * directly instead.
     */
    abstract predicate isFree(Function f);

    /**
     * Returns a call to an `alloc` function.
     */
    FunctionCall getAnAllocCall() {
        this.isAlloc(result.getTarget())
    }

    /**
     * Returns a call to a `free` function.
     */
    FunctionCall getAFreeCall() {
        this.isFree(result.getTarget())
    }

    /**
     * True if `var` is allocated by the `alloc` call.
     */
    predicate isAllocatedBy(FunctionCall alloc, Variable var) {
        alloc = this.getAnAllocCall() and alloc = var.getAnAssignedValue()
    }

    /**
     * True if `var` is freed by the `free` call.
     */
    predicate isFreedBy(FunctionCall free, Variable var) {
        free = this.getAFreeCall() and free.getAnArgument() = var.getAnAccess()
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
      alloc.isFreedBy(node, var)
    }
  
    override predicate isSinkActual(ControlFlowNode node, StackVariable var) {
      // A sink is a return statement not returning the allocated variable.
      node instanceof ReturnStmt and not node.(ReturnStmt).getExpr() = var.getAnAccess()
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
      node = var.getAnAccess() and not this.isAnAssignment(node, var)
    }
  
    override predicate isBarrier(ControlFlowNode node, StackVariable var) {
      // Stop tracking the variable if it is reassigned.
      this.isAnAssignment(node, var)
    }
  
    // Returns true if the `node` is the lvalue of an assignment to `var`.
    predicate isAnAssignment(ControlFlowNode node, StackVariable var) {
      node = var.getAnAssignment().getLValue()
    }
  }