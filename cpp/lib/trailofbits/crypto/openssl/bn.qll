import cpp
import trailofbits.crypto.common

// BIGNUM *BN_new(void);
class BN_new extends CustomAllocator {
  BN_new() {
    this.getQualifiedName() = "BN_new" and
    (
      dealloc instanceof BN_free or
      dealloc instanceof BN_clear_free
    )
  }
}

// BIGNUM *BN_secure_new(void);
class BN_secure_new extends CustomAllocator {
  BN_secure_new() {
    this.getQualifiedName() = "BN_secure_new" and
    (
      dealloc instanceof BN_free or
      dealloc instanceof BN_clear_free
    )
  }
}

// void BN_free(BIGNUM *a);
class BN_free extends CustomDeallocator {
  BN_free() { this.getQualifiedName() = "BN_free" }

  override int getPointer() { result = 0 }
}

// void BN_clear_free(BIGNUM *a);
class BN_clear_free extends CustomDeallocator {
  BN_clear_free() { this.getQualifiedName() = "BN_clear_free" }

  override int getPointer() { result = 0 }
}

// void BN_clear(BIGNUM *a);
class BN_clear extends FunctionCall {
  BN_clear() { this.getTarget().getName() = "BN_clear" }

  Expr getBignum() { result = this.getArgument(0) }
}

//  int BN_rand(BIGNUM *rnd, int bits, int top, int bottom); (and variants)
/// Reference: https://docs.openssl.org/master/man3/BN_rand/#synopsis
class BN_rand extends FunctionCall {
  BN_rand() {
    this.getTarget().getName().matches("BN\\_rand%") or
    this.getTarget().getName().matches("BN\\_priv\\_rand%") or
    this.getTarget().getName().matches("BN\\_pseudo\\_rand%")
  }

  Expr getBignum() { result = this.getArgument(0) }
}

class BIGNUM extends FunctionCall {
  BIGNUM() {
    this.getTarget() instanceof BN_new or
    this.getTarget() instanceof BN_secure_new
  }
}

// BN_CTX *BN_CTX_new(void);
class BN_CTX_new extends CustomAllocator {
  BN_CTX_new() {
    this.getQualifiedName().matches("BN\\_CTX_new%")
    or
    this.getQualifiedName().matches("BN\\_CTX\\_secure\\_new%") and
    dealloc instanceof BN_CTX_free
  }
}

// void BN_CTX_free(BN_CTX *c);
class BN_CTX_free extends CustomDeallocator {
  BN_CTX_free() { this.getQualifiedName() = "BN_CTX_free" }

  override int getPointer() { result = 0 }
}

// void BN_CTX_start(BN_CTX *ctx);
class BN_CTX_start extends FunctionCall {
  BN_CTX_start() { this.getTarget().getName() = "BN_CTX_start" }

  Expr getContext() { result = this.getArgument(0) }
}

// void BN_CTX_end(BN_CTX *ctx);
class BN_CTX_end extends FunctionCall {
  BN_CTX_end() { this.getTarget().getName() = "BN_CTX_end" }

  Expr getContext() { result = this.getArgument(0) }
}

// BIGNUM *BN_CTX_get(BN_CTX *ctx);
class BN_CTX_get extends FunctionCall {
  BN_CTX_get() { this.getTarget().getName() = "BN_CTX_get" }

  Expr getContext() { result = this.getArgument(0) }
}

class BN_CTX extends FunctionCall {
  BN_CTX() { this.getTarget() instanceof BN_CTX_new }
}
