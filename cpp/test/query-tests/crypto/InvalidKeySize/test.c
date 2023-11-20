#include "../../../include/openssl/evp.h"
#include "../../../include/openssl/rand.h"

void found(EVP_CIPHER_CTX *ctx) {
  unsigned char key[16]; // should be 32 for 256 bit key
  unsigned char *iv = (unsigned char *)"0123456789012345";

  RAND_bytes(key, sizeof(key));
  EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv);
}

void notFound(EVP_CIPHER_CTX *ctx, unsigned char *key) {
  unsigned char *iv = (unsigned char *)"0123456789012345";

  EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv);
}

int main(void) {
  {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    found(ctx);
  }
  {
    unsigned char key[16]; // should be 32 for 256 bit key
    RAND_bytes(key, sizeof(key));
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    notFound(ctx, key);
  }

  return 0;
}
