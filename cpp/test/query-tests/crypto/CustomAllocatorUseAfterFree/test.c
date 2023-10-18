#include "../../../include/openssl/bn.h"

int condition(BIGNUM* a) {
  return (*a == 1);
}

BIGNUM* calculate(BIGNUM* a) {
  BIGNUM *b = BN_new();

  if (condition(a)) {
    BN_free(b);
  }
  // Potential use-after-free here.
  if (condition(b)) {
    BN_free(a);
    a = BN_new();
  }

  return b;
}


int main(int argc, char** argv) {
  BIGNUM *a = BN_new();
  a = calculate(a);

  BN_free(a);
  return 0;
}
