#include "../../../include/openssl/bn.h"

void good_proper_lifecycle() {
  BN_CTX *ctx = BN_CTX_new();
  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_end(ctx); // Properly call end before free
  BN_CTX_free(ctx);
}

void bad_free_before_end() {
  BN_CTX *ctx = BN_CTX_new();
  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_free(ctx); // BUG: free before end
}

void good_mult_ctx() {
  BN_CTX *ctx = BN_CTX_new();

  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_end(ctx);

  BN_CTX_start(ctx);
  BIGNUM *b = BN_CTX_get(ctx);
  BN_CTX_end(ctx);

  BN_CTX_free(ctx);
}

void bad_conditional_end(int condition) {
  BN_CTX *ctx = BN_CTX_new();
  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);

  if (condition) {
    BN_CTX_end(ctx);
  }
  BN_CTX_free(ctx); // BUG: May free before end if condition is false
}

int main(void) {}