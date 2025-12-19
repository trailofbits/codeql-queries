import cpp
import InitUpdateFinalPattern
import StrongRandomnessSink

// This abstract class represent a function which initializes a key or
// cipher context.
abstract class SymmetricCipherInit extends InitFunction {
  // Returns the indices of the arguments requiring strong randomness.
  abstract int getAStrongRandomnessSink();
}

abstract class SymmetricCipherInitWithKey extends SymmetricCipherInit {
  // Returns the index of the key argument.
  abstract int getKey();

  override int getAStrongRandomnessSink() { result = this.getKey() }
}

abstract class SymmetricCipherInitWithIv extends SymmetricCipherInit {
  // Returns the index of the IV argument.
  abstract int getIv();

  override int getAStrongRandomnessSink() { result = this.getIv() }
}

abstract class SymmetricCipherInitWithKeyAndIv extends SymmetricCipherInitWithKey,
  SymmetricCipherInitWithIv
{
  override int getAStrongRandomnessSink() { result = this.getKey() or result = this.getIv() }
}

class SymmetricCipherInitCall extends InitCall {
  override SymmetricCipherInit init;

  // Returns an argument requiring strong randomness.
  Expr getAStrongRandomnessSink() { result = this.getArgument(init.getAStrongRandomnessSink()) }
}

class SymmetricCipherInitSink extends StrongRandomnessSink {
  SymmetricCipherInitCall init;

  SymmetricCipherInitSink() { this = init.getAStrongRandomnessSink() }

  override string getDescription() {
    result = init.getTarget().getQualifiedName() + " parameter " + this.toString()
  }
}

// This abstract class represent a function which takes an initialized key or
// cipher context as argument and updates it with more data.
abstract class SymmetricCipherUpdate extends UpdateFunction { }

class SymmetricCipherUpdaterCall extends UpdateCall {
  override SymmetricCipherUpdate update;
}

// This abstract class represent a function which takes an initialized key or
// cipher context as argument and updates it with more data.
abstract class SymmetricCipherFinal extends FinalFunction { }

class SymmetricCipherFinalCall extends FinalCall {
  override SymmetricCipherFinal final;
}
