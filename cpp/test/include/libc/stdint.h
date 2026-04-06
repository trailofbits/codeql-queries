#ifndef USE_HEADERS

#ifndef HEADER_STDINT_STUB_H
#define HEADER_STDINT_STUB_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;
typedef long ssize_t;

#endif
#else // --- else USE_HEADERS

#include <stdint.h>

#endif // --- end USE_HEADERS