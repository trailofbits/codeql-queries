#include "../../../include/openssl/evp.h"


#define NULL (0)


typedef int int32_t;
typedef unsigned char uint8_t;
typedef unsigned long size_t;


const uint8_t KEY[32] = { 
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
  0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
};
const uint8_t IV[12] = {
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b
};


int32_t encryptWithKeyAndIv(
  const uint8_t*  input,
  size_t          input_size,
  uint8_t*        output,
  size_t*         output_size,
  const uint8_t*  key,
  const uint8_t*  iv
) {
  int32_t result = -1;

  const EVP_CIPHER *cipher = EVP_chacha20_poly1305();
  EVP_CIPHER_CTX *context = EVP_CIPHER_CTX_new();
  if (context == NULL) {
    goto exit;
  }
  if (EVP_EncryptInit(context, cipher, key, iv) != 1) {
    goto cleanup;
  }
  if(EVP_EncryptUpdate(context, output, (int *)output_size, output, input_size) != 1) {
    goto cleanup;
  }

  int final_size = 0;
  if (EVP_EncryptFinal(context, output + *output_size, &final_size) != 1) {
    goto cleanup;
  }
  output_size += final_size;
  result = 0;

cleanup:
  EVP_CIPHER_CTX_free(context);

exit:
  return result;
}

int32_t decryptWithStaticKeyAndIv(
  const uint8_t*  input,
  size_t          input_size,
  uint8_t*        output,
  size_t*         output_size
) {
  int32_t result = -1;

  const EVP_CIPHER *cipher = EVP_chacha20_poly1305();
  EVP_CIPHER_CTX *context = EVP_CIPHER_CTX_new();
  if (context == NULL) {
    goto exit;
  }
  if (EVP_DecryptInit(context, cipher, KEY, IV) != 1) {
    goto cleanup;
  }
  if(EVP_DecryptUpdate(context, output, (int *)output_size, output, input_size) != 1) {
    goto cleanup;
  }

  int final_size = 0;
  if (EVP_DecryptFinal(context, output + *output_size, &final_size) != 1) {
    goto cleanup;
  }
  output_size += final_size;
  result = 0;

cleanup:
  EVP_CIPHER_CTX_free(context);

exit:
  return result;
}

int32_t main(int32_t argc, char** argv) {
  uint8_t plain[256] = { 0 };
  uint8_t cipher[256] = { 0 };

  size_t cipher_size = 256;
  encryptWithKeyAndIv(plain, 256, cipher, &cipher_size, KEY, IV);

  size_t plain_size = 256;
  decryptWithStaticKeyAndIv(cipher, 256, plain, &plain_size);

  return 0;
}
