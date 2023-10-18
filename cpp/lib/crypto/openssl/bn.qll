import cpp
import crypto.common

// BIGNUM *BN_new(void);
class BN_new extends CustomAllocator {
  BN_new() {
    this.getQualifiedName() = "BN_new" and (
      dealloc instanceof BN_free or
      dealloc instanceof BN_clear_free
    )
  }
}

// BIGNUM *BN_secure_new(void);
class BN_secure_new extends CustomAllocator {
  BN_secure_new() {
    this.getQualifiedName() = "BN_secure_new" and (
      dealloc instanceof BN_free or
      dealloc instanceof BN_clear_free
    )
  }
}

// void BN_free(BIGNUM *a);
class BN_free extends CustomDeallocator {
  BN_free() {
    this.getQualifiedName() = "BN_free"
  }

  override int getPointer() {
    result = 0
  }
}

// void BN_clear_free(BIGNUM *a);
class BN_clear_free extends CustomDeallocator {
  BN_clear_free() {
    this.getQualifiedName() = "BN_clear_free"
  }

  override int getPointer() {
    result = 0
  }
}

// void BN_clear(BIGNUM *a);
class BN_clear extends FunctionCall {
  BN_clear() { this.getTarget().getName() = "BN_clear" }

  Expr getBignum() { result = this.getArgument(0) }
}

//  int BN_rand(BIGNUM *rnd, int bits, int top, int bottom);
class BN_rand extends FunctionCall {
  BN_rand() { this.getTarget().getName() = "BN_rand" }

  Expr getBignum() {
    result = this.getArgument(0)
  }
}

class BIGNUM extends FunctionCall {
  BIGNUM () {
    this.getTarget().getName() in ["BN_new"]
  }
}