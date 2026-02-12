import cpp
import StrongRandomnessSink

abstract class CsprngInitializer extends Function {
  // Returns the index of the seed argument (if it exists).
  abstract int getAStrongRandomnessSink();
}

class CsprngInitializerCall extends FunctionCall {
  CsprngInitializer init;

  CsprngInitializerCall() { this.getTarget() = init }

  // Returns the seed argument.
  Expr getAStrongRandomnessSink() { result = this.getArgument(init.getAStrongRandomnessSink()) }
}

// A type representing the seed argument of a CSPRNG initializer function.
class CsprngInitializerSink extends StrongRandomnessSink {
  CsprngInitializerCall init;

  CsprngInitializerSink() { this = init.getAStrongRandomnessSink() }

  override string getDescription() {
    result = init.getTarget().getQualifiedName() + " parameter " + this.toString()
  }
}
