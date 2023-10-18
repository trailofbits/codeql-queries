#include "../../../include/openssl/bn.h"
#include "../../../include/mbedtls/bignum.h"


int condition(BIGNUM* a) {
  return (*a == 1);
}

int bad(BIGNUM* a) {
  BIGNUM *b = BN_new();

  if (condition(a)) {
    BN_free(b);
  }

  // b may leak here.
  return 7;
}

int alsoBad() {
  mbedtls_mpi x;
  mbedtls_mpi_init(&x);

  if (condition(&x)) {
    return -1;
  }
  mbedtls_mpi_free(&x);
  return 1;
}

BIGNUM* notBad() {
  BIGNUM *b = BN_new();
  return b;
}

int main(int argc, char** argv) {
  BIGNUM *a = notBad();
  bad(a);

  if (condition(a)) {
    BN_free(a);
  } else {
    BN_free(a);
  }
  return alsoBad();
}
