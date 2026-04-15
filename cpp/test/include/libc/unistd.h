#ifndef USE_HEADERS

#ifndef HEADER_UNISTD_STUB_H
#define HEADER_UNISTD_STUB_H

#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned long size_t;
#endif

#ifndef _SSIZE_T_DEFINED
#define _SSIZE_T_DEFINED
typedef long ssize_t;
#endif

#ifdef  __cplusplus
extern "C" {
#endif

ssize_t read(int, void *, size_t);

void _exit(int);

#ifdef  __cplusplus
}
#endif

#endif

#else // --- else USE_HEADERS

#include <unistd.h>

#endif // --- end USE_HEADERS