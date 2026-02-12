#ifndef USE_HEADERS

#ifndef HEADER_STDARG_STUB_H
#define HEADER_STDARG_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

typedef void *va_list;
#define va_start(ap, parmN)
#define va_end(ap)
#define va_arg(ap, type) ((type)0)

#ifdef  __cplusplus
}
#endif

#endif

#else // --- else USE_HEADERS

#include <stdarg.h>

#endif // --- end USE_HEADERS