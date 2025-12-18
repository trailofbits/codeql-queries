import cpp

// This abstract class represent a function which initializes a hash, key, or
// cipher context.
abstract class InitFunction extends Function {
  // Returns the index (or indices) of the context argument initialized by a
  // call to this function.
  abstract int getAContextArg();

  // Override and return true if the function returns the initialized context.
  predicate returnsContext() { 1 = 0 }
}

// This type represents a call to the corresponding init function.
class InitCall extends FunctionCall {
  InitFunction init;

  InitCall() { init = this.getTarget() }

  Expr getAContext() {
    result = this.getArgument(init.getAContextArg())
    or
    init.returnsContext() and result = this
  }
}

// This abstract class represent a function which updates a hash, key, or
// cipher context with more data.
abstract class UpdateFunction extends Function {
  // Returns the index (or indices) of the context argument updated by a
  // call to this function.
  abstract int getAContextArg();

  // Override and return true if the function returns the updated context.
  predicate returnsContext() { 1 = 0 }
}

// This type represents a call to the corresponding update function.
class UpdateCall extends FunctionCall {
  UpdateFunction update;

  UpdateCall() { update = this.getTarget() }

  Expr getAContext() {
    result = this.getArgument(update.getAContextArg())
    or
    update.returnsContext() and result = this
  }
}

// This abstract class represent a function which finalizes a hash, key, or
// cipher context.
abstract class FinalFunction extends Function {
  // Returns the index (or indices) of the context argument initialized by a
  // call to this function.
  abstract int getAContextArg();

  // Override and return true if the function returns the initialized context.
  predicate returnsContext() { 1 = 0 }
}

class FinalCall extends FunctionCall {
  FinalFunction final;

  FinalCall() { final = this.getTarget() }

  Expr getAContext() {
    result = this.getArgument(final.getAContextArg())
    or
    final.returnsContext() and result = this
  }
}

// This abstract class encodes a tuple of Init, Update, Final functions for the
// same context type. It is used by the MissingInitialzier query to ensure that
// the *correct* initializer is called before the context is accessed.
//
// (Note that all three functions (getInit, getUpdate, and getFinal) below may
// be multi-valued. I.e. a priori there may be more than one valid update or
// finalizer for a given initialier.)
class InitUpdateFinalTuple extends string {
  bindingset[this]
  InitUpdateFinalTuple() { any() }

  abstract InitFunction getInit();

  abstract UpdateFunction getUpdate();

  abstract FinalFunction getFinal();

  InitCall getAnInitCall() { result = this.getInit().getACallToThisFunction() }

  UpdateCall getAnUpdateCall() { result = this.getUpdate().getACallToThisFunction() }

  FinalCall getAFinalCall() { result = this.getFinal().getACallToThisFunction() }
}
