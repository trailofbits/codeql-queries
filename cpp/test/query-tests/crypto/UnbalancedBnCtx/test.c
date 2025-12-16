#include "../../../include/openssl/bn.h"

void good_balanced() {
  BN_CTX *ctx = BN_CTX_new();
  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_end(ctx);
  BN_CTX_free(ctx);
}

void bad_start_without_end() {
  BN_CTX *ctx = BN_CTX_new();
  BN_CTX_start(ctx); // BUG: Missing corresponding end
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_free(ctx);
}

void bad_end_without_start() {
  BN_CTX *ctx = BN_CTX_new();
  BIGNUM *a = BN_CTX_get(ctx);
  BN_CTX_end(ctx); // BUG: No corresponding start
  BN_CTX_free(ctx);
}

void good_conditional_balanced(int condition) {
  BN_CTX *ctx = BN_CTX_new();
  if (condition) {
    BN_CTX_start(ctx);
    BIGNUM *a = BN_CTX_get(ctx);
    BN_CTX_end(ctx);
  } else {
    BN_CTX_start(ctx);
    BIGNUM *b = BN_CTX_get(ctx);
    BN_CTX_end(ctx);
  }
  BN_CTX_free(ctx);
}

void bad_conditional_start(int condition) {
  BN_CTX *ctx = BN_CTX_new();

  if (condition) {
    BN_CTX_start(ctx);
    BIGNUM *a = BN_CTX_get(ctx);
  }

  BN_CTX_end(ctx); // BUG: End without start if condition is false
  BN_CTX_free(ctx);
}

void bad_conditional_end(int condition) {
  BN_CTX *ctx = BN_CTX_new();

  BN_CTX_start(ctx);
  BIGNUM *a = BN_CTX_get(ctx);

  if (condition) {
    BN_CTX_end(ctx);
  }
  // BUG: Start without end if condition is false
  BN_CTX_free(ctx);
}