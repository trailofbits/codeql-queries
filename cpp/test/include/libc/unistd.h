#ifndef USE_HEADERS

#ifndef HEADER_UNISTD_STUB_H
#define HEADER_UNISTD_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

void _exit(int);

#ifdef  __cplusplus
}
#endif

#endif

#else // --- else USE_HEADERS

#include <unistd.h>

#endif // --- end USE_HEADERS