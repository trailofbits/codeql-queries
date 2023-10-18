#include "../../../include/openssl/evp.h"

int rand() {
  int value;
  return value;
}

void init(EVP_CIPHER_CTX* ctx) {
  const EVP_CIPHER *cipher = EVP_chacha20_poly1305();
  EVP_EncryptInit(ctx, cipher, NULL, NULL);
}

void use(EVP_CIPHER_CTX* ctx) {
  EVP_EncryptUpdate(ctx, NULL, 0, NULL, 0);
  EVP_EncryptFinal(ctx, NULL, 0);
}

void bad() {
  EVP_CIPHER_CTX ctx;
  EVP_CIPHER_CTX *ctx_ptr;

  if (rand()) {
    init(&ctx);
    init(ctx_ptr);
  }

  if (rand()) {
    use(&ctx);
    use(ctx_ptr);
  }
}

void good() {
  EVP_CIPHER_CTX ctx;
  EVP_CIPHER_CTX *ctx_ptr;

  init(&ctx);
  init(ctx_ptr);

  if (rand()) {
    use(&ctx);
    use(ctx_ptr);
  }
}

int main(int argc, char** argv) {
  good();
  bad();

  return 0;
}
