import cpp
import StrongPasswordSink

abstract class KeyDerivationFunction extends Function {
  // Returns the indices of the arguments requiring a strong password.
  abstract int getAStrongPasswordSink();
}

abstract class KeyDerivationFunctionWithPassword extends KeyDerivationFunction {
  // Returns the index of the password argument.
  abstract int getPassword();

  override int getAStrongPasswordSink() { result = this.getPassword() }
}

abstract class KeyDerivationFunctionWithSalt extends KeyDerivationFunction {
  // Returns the index of the salt argument.
  abstract int getSalt();
}

abstract class KeyDerivationFunctionWithPasswordAndSalt extends KeyDerivationFunctionWithPassword,
  KeyDerivationFunctionWithSalt
{ }

class KeyDerivationFunctionWithPasswordCall extends FunctionCall {
  KeyDerivationFunctionWithPassword kdf;

  KeyDerivationFunctionWithPasswordCall() { this.getTarget() = kdf }

  Expr getAStrongPasswordSink() { result = this.getArgument(kdf.getAStrongPasswordSink()) }
}

// A type representing the password argument of a key derivation function.
class KeyDerivationFunctionSink extends StrongPasswordSink {
  KeyDerivationFunctionWithPasswordCall kdf;

  KeyDerivationFunctionSink() { this = kdf.getAStrongPasswordSink() }

  override string getDescription() {
    result = kdf.getTarget().getQualifiedName() + " parameter " + this.toString()
  }
}
