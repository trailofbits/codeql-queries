#include "../../../include/libc/stdlib.h"
#include "../../../include/openssl/rand.h"


void seedRandomNumberGenerator(const unsigned char *random, unsigned long size) {
  RAND_seed(random, size);
}

void updateRandomNumberGenerator(const unsigned char *random, unsigned long size) {
  RAND_add(random, size, 1.0);
}

int main(int argc, char** argv) {
  long random = rand();
  seedRandomNumberGenerator((unsigned char*)&random, sizeof(long));

  random = lrand48();
  updateRandomNumberGenerator((unsigned char*)&random, sizeof(long));

  return 0;
}
