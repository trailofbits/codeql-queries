import cpp
private import semmle.code.cpp.controlflow.StackVariableReachability

/**
 * A custom allocator which returns a pointer to the allocated object.
 */
abstract class CustomAllocator extends Function {
  CustomDeallocator dealloc;

  CustomDeallocator getDeallocator() { result = dealloc }

  // Override this and return the index of the pointer argument if the
  // allocated pointer is passed as an argument.
  int getPointer() { result = -1 }
}

class CustomAllocatorCall extends FunctionCall {
  CustomAllocator alloc;

  CustomAllocatorCall() { this = alloc.getACallToThisFunction() }

  Expr getPointer() {
    if alloc.getPointer() < 0 then result = this else result = this.getArgument(alloc.getPointer())
  }

  CustomAllocator getAllocator() { result = alloc }

  CustomDeallocatorCall getADeallocatorCall() { result.getTarget() = alloc.getDeallocator() }
}

/**
 * A custom deallocator which takes the object to deallocate as an argument.
 */
abstract class CustomDeallocator extends Function {
  abstract int getPointer();
}

class CustomDeallocatorCall extends FunctionCall {
  CustomDeallocator dealloc;

  CustomDeallocatorCall() { this = dealloc.getACallToThisFunction() }

  Expr getPointer() { result = this.getArgument(dealloc.getPointer()) }
}

class CustomAllocatorLeak extends StackVariableReachabilityWithReassignment {
  CustomAllocatorCall alloc;

  CustomAllocatorLeak() { this = "CustomAllocatorLeak" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable var) {
    // A source is an allocation of the variable.
    node = alloc.getPointer() and
    (
      // When alloc returns allocated object.
      alloc.getPointer() = var.getAnAssignedValue()
      or
      // When alloc takes a pointer as an argument the variable can be either a
      // pointer or an object v, in which case &v is passed to the function and
      // we need to invoke getAChild() to get a variable access.
      alloc.getPointer().getAChild*() = var.getAnAccess()
    )
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable var) {
    node = alloc.getADeallocatorCall() and
    node.(CustomDeallocatorCall).getPointer().getAChild*() = var.getAnAccess()
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable var) {
    // A sink is a return statement not returning the allocated variable.
    var.getFunction() = node.(ReturnStmt).getEnclosingFunction() and
    not node.(ReturnStmt).getExpr() = var.getAnAccess()
  }
}

class CustomAllocatorUseAfterFree extends StackVariableReachabilityWithReassignment {
  CustomAllocatorUseAfterFree() { this = "CustomAllocatorUseAfterFree" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable var) {
    node.(CustomDeallocatorCall).getPointer() = var.getAnAccess()
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable var) {
    // A use is an access which is not a reassignment.
    node = var.getAnAccess() and
    not this.isAnAssignment(node, var)
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable var) {
    // Stop tracking the variable if it is reassigned.
    this.isAnAssignment(node, var)
  }

  // Returns true if the node is the lvalue of an assignment of var.
  predicate isAnAssignment(ControlFlowNode node, StackVariable var) {
    node = var.getAnAssignment().getLValue()
  }
}
