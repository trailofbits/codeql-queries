#ifndef HEADER_BN_STUB_H
#define HEADER_BN_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

#define BIGNUM int

static BIGNUM BN = 1;

const int BN_RAND_TOP_ANY = 10;
const int BN_RAND_BOTTOM_ANY = 10;

BIGNUM *BN_new(void) {
  return &BN;
}
BIGNUM *BN_secure_new(void) {
  return &BN;
}

void BN_free(BIGNUM *a) {
}

void BN_clear_free(BIGNUM *a) {
}

void BN_clear(BIGNUM *a) {
}

int BN_rand(BIGNUM *rnd, int bits, int top, int bottom) {
  return 1;
}

// BN_CTX functions
#define BN_CTX int

BN_CTX *BN_CTX_new(void) {
  static BN_CTX ctx = 1;
  return &ctx;
}

BN_CTX *BN_CTX_secure_new(void) {
  static BN_CTX ctx = 1;
  return &ctx;
}

void BN_CTX_free(BN_CTX *c) {
}

void BN_CTX_start(BN_CTX *ctx) {
}

void BN_CTX_end(BN_CTX *ctx) {
}

BIGNUM *BN_CTX_get(BN_CTX *ctx) {
  return &BN;
}

# ifdef  __cplusplus
}
#endif

#endif
