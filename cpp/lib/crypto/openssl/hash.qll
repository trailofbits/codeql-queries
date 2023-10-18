import cpp
import crypto.common

// Common API definitions for OpenSSL hash functions.
module Hash {
  // int SHA1_Init(SHA_CTX *c);
  abstract class Init extends HashContextInitializer {
    // Returns the index of the context argument (if there is one).
    override int getAContext() {
      result = 0
    }

    // True iff the initializer returns the context.
    override boolean returnsContext() {
      result = false
    }
  }

  // int SHA1_Update(SHA_CTX *c, const void *data, size_t len);
  abstract class Update extends HashContextUpdater {
    // Returns the index of the context argument.
    override int getContext() {
      result = 0
    }

    // Returns an index of an input data argument.
    override int getAnInput() {
      result = 1
    }
  }

  // int SHA1_Final(unsigned char *md, SHA_CTX *c);
  abstract class Final extends HashContextFinalizer {
    // Returns the index of the context argument.
    override int getContext() {
      result = 1
    }

    // Returns the output digest argument (if it exists).
    override int getAnOutput() {
      result = 0
    }

    // True iff the finalizer function returns a pointer or reference to the
    // output digest.
    override boolean returnsOutput() {
      result = false
    }
  }

  abstract class Digest extends HashFunction {
    // Returns the index of the input data argument.
    override int getInput() {
      result = 0
    }

    // Returns an the index of an output data argument (if there is one).
    override int getAnOutput() {
      result = 2
    }

    // True if the function returns a reference or pointer to the output.
    override boolean returnsOutput() {
      result = true
    }
  }
}

