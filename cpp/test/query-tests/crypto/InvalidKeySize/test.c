#include "../../../include/openssl/evp.h"
#include "../../../include/openssl/rand.h"

int main(void)
{
    unsigned char key[31];  // should be 32 for 256 bit key

    const EVP_CIPHER *c = EVP_aes_128_cbc();

    int rc = RAND_bytes(key, sizeof(key));

    /* A 128 bit IV */
    unsigned char *iv = (unsigned char *)"0123456789012345";

    EVP_EncryptInit_ex(EVP_CIPHER_CTX_new(), EVP_aes_256_cbc(), NULL, key, iv);

    return 0;
}