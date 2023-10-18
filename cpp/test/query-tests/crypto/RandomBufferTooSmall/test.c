#include "../../../include/openssl/rand.h"

#define KEY_SIZE 16

int notFound(unsigned char *key) {

    return RAND_bytes(key, 32);

}

int main(void)
{
    const int keySize = KEY_SIZE;

    unsigned char key[keySize];

    int rc = RAND_bytes(key, 32);

    unsigned char *keyBad;

    notFound(key);

    notFound(keyBad);

    return 0;
}
