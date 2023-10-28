import cpp


abstract class Csprng extends Function {
  abstract int getAStrongRandomnessSource();

  abstract int getRequestedBytes();
}


class CsprngCall extends FunctionCall {
  Csprng csprng;

  // Ensures that the call target is an instance of Csprng.
  CsprngCall() { csprng = this.getTarget() }

  Expr getAStrongRandomnessSource() { result = this.getArgument(csprng.getAStrongRandomnessSource()) }

  Expr getRequestedBytes() { result = this.getArgument(csprng.getRequestedBytes()) }
}
