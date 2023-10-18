#include "../../../include/openssl/evp.h"


const unsigned char GLOBAL_KEY[32] = { 
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
  0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
};
const unsigned char GLOBAL_IV[12] = {
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b
};


int encryptWithKeyAndIv(
  const unsigned char* input,
  unsigned long        input_size,
  unsigned char*       output,
  unsigned long*       output_size,
  const unsigned char* key,
  const unsigned char* iv
) {
  int result = -1;

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

int decryptWithStaticKeyAndIv(
  const unsigned char* input,
  unsigned long        input_size,
  unsigned char*       output,
  unsigned long*       output_size
) {
  int result = -1;

  const EVP_CIPHER *cipher = EVP_chacha20_poly1305();
  EVP_CIPHER_CTX *context = EVP_CIPHER_CTX_new();
  if (context == NULL) {
    goto exit;
  }
  if (EVP_DecryptInit(context, cipher, GLOBAL_KEY, GLOBAL_IV) != 1) {
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

int main(int argc, char** argv) {
  unsigned char plain[256] = { 0 };
  unsigned char cipher[256] = { 0 };

  unsigned long cipher_size = 256;
  encryptWithKeyAndIv(plain, 256, cipher, &cipher_size, GLOBAL_KEY, GLOBAL_IV);

  const unsigned char *global_key = GLOBAL_KEY;
  const unsigned char *global_iv = GLOBAL_IV;
  encryptWithKeyAndIv(plain, 256, cipher, &cipher_size, global_key, global_iv);

  const unsigned char local_key[32] = { 
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
  };
  const unsigned char local_iv[12] = {
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b
  };
  encryptWithKeyAndIv(plain, 256, cipher, &cipher_size, local_key, local_iv);
  
  unsigned long plain_size = 256;
  decryptWithStaticKeyAndIv(cipher, 256, plain, &plain_size);

  return 0;
}
