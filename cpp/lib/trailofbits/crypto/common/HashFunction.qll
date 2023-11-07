import cpp


// A type modelling a (taint propagating) hash function.
abstract class HashFunction extends TaintFunction {
  // Returns the index of the input data argument.
  abstract int getInput();

  // Returns an the index of an output data argument (if there is one).
  abstract int getAnOutput();

  // True if the function returns a reference or pointer to the output.
  abstract boolean returnsOutput();

  // Ensure that taint propagates from the input to the output.
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.getInput()) and
    (
      output.isParameterDeref(this.getAnOutput()) or
      (this.returnsOutput() = true and output.isReturnValueDeref())
    )
  }
}

// A type modelling a (taint propagating) hash context.
class HashContext extends Expr {
}

// A type modelling a hash context initializer.
abstract class HashContextInitializer extends Function {
  // Returns the index of the context argument (if there is one).
  abstract int getAContext();

  // True iff the initializer returns the context.
  abstract boolean returnsContext();
}

class HashContextInitializerCall extends FunctionCall {
  HashContextInitializer init;

  // Returns the hash context argument.
  HashContext getContext() {
    (init.returnsContext() = true and result = this) or
    (result = this.getArgument(init.getAContext()))
  }

  // Returns the corresponding initializer function.
  HashContextInitializer getInitializer() {
    result = init
  }
}

// A type modelling a hash context update function.
abstract class HashContextUpdater extends TaintFunction {
  // Returns the index of the context argument.
  abstract int getContext();

  // Returns an index of an input data argument.
  abstract int getAnInput();

  // Since C++ does not have AdditionalTaintFlow we use TaintFunction to model
  // taint from input to output through the hash context.
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.getAnInput()) and
    output.isParameterDeref(this.getContext())
  }
}

class HashContextUpdaterCall extends FunctionCall {
  HashContextUpdater update;

  // Returns the hash context argument.
  HashContext getContext() {
    result = this.getArgument(update.getContext())
  }

  // Returns the corresponding update function.
  HashContextInitializer getUpdater() {
    result = update
  }
  
  // Returns an input data argument.
  Expr getAnInput() {
    result = this.getArgument(update.getAnInput())
  }
}

// A type modelling a hash context finalizer function.
abstract class HashContextFinalizer extends TaintFunction {
  // Returns the index of the context argument.
  abstract int getContext();
  
  // Returns the output digest argument (if it exists).
  abstract int getAnOutput();

  // True iff the finalizer function returns a pointer or reference to the
  // output digest.
  abstract boolean returnsOutput();
  
  // Since C++ does not have AdditionalTaintFlow we use TaintFunction to model
  // taint from input to output through the hash context.
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.getContext()) and
    (
      output.isParameterDeref(this.getAnOutput()) or
      (this.returnsOutput() = true and output.isReturnValueDeref())
    )
  }
}

class HashContextFinalizerCall extends FunctionCall {
  HashContextFinalizer final;

  // Returns the hash context argument.
  HashContext getContext() {
    result = this.getArgument(final.getContext())
  }

  // Returns the corresponding finalizer function.
  HashContextInitializer getFinalizer() {
    result = final
  }

  // Returns an expression representing the output digest.
  Expr getAnOutput() {
    (final.returnsOutput() = true and result = this) or
    (result = this.getArgument(final.getAnOutput()))
  }
}

