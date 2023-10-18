/*
 * This file defines stub implementations for the OpenSSL EVP API.
 */

#ifndef HEADER_ENVELOPE_STUB_H
#define HEADER_ENVELOPE_STUB_H

#ifndef NULL
  #define NULL (0)
#endif

typedef void* EVP_MD;
typedef void* EVP_CIPHER;
typedef void* EVP_CIPHER_CTX;
typedef void* ENGINE;

# ifdef  __cplusplus
extern "C" {
# endif
  EVP_CIPHER_CTX* EVP_CIPHER_CTX_new(void) {
    return NULL;
  }

  void EVP_CIPHER_CTX_free(EVP_CIPHER_CTX* ctx) {}

  int EVP_EncryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
      const unsigned char *key, const unsigned char *iv) {
    return 1;
  }

  int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
      ENGINE *impl, const unsigned char *key, const unsigned char *iv) {
    return 1;
  }

  int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
      int *outl, const unsigned char *in, int inl) {
    return 1;
  }

  int EVP_EncryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out,
      int *outl) {
    return 1;
  }

  int EVP_DecryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
      const unsigned char *key, const unsigned char *iv) {
    return 1;
  }

  int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
      int *outl, const unsigned char *in, int inl) {
    return 1;
  }

  int EVP_DecryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out,
      int *outl) {
    return 1;
  }

  const EVP_CIPHER *EVP_chacha20_poly1305(void) {
    return NULL;
  }

  const EVP_CIPHER *EVP_aes_256_cbc(void) {
    return NULL;
  }

  const EVP_CIPHER *EVP_aes_128_cbc(void) {
    return NULL;
  }

  int EVP_BytesToKey(const EVP_CIPHER *type,const EVP_MD *md,
                     const unsigned char *salt,
                     const unsigned char *data, int datal, int count,
                     unsigned char *key,unsigned char *iv) {
    return datal > 0? 32: 0;
  }
# ifdef  __cplusplus
}
# endif

#endif
