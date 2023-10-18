#include "../../../include/openssl/evp.h"


const char s_PASSWORD[] = "correct horse battery staple";


const char* getStaticPassword() {
  return s_PASSWORD;
}

int generateKey(const char* password, unsigned char* key) {
  const unsigned char *data = (const unsigned char*)password;
  return EVP_BytesToKey(0, 0, 0, data, 28, 1024, key, 0);
}

int main(int argc, char** argv) {
  const char* password = getStaticPassword();
  unsigned char key[32];

  generateKey(password, key);

  return 0;
}
