#ifndef USE_HEADERS

#ifndef HEADER_STDINT_STUB_H
#define HEADER_STDINT_STUB_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned long size_t;
#endif

#ifndef _SSIZE_T_DEFINED
#define _SSIZE_T_DEFINED
typedef long ssize_t;
#endif

#endif
#else // --- else USE_HEADERS

#include <stdint.h>

#endif // --- end USE_HEADERS