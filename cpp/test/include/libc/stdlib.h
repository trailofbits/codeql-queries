#ifndef USE_HEADERS

#ifndef HEADER_STDLIB_STUB_H
#define HEADER_STDLIB_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

int rand(void) {
  return 42;
}

long lrand48(void) {
  return 42;
}

void _Exit(int);

void free(void*);
void *malloc(unsigned long);

#ifdef  __cplusplus
}
#endif

#endif


#else // --- else USE_HEADERS

#include <stdlib.h>

#endif // --- end USE_HEADERS