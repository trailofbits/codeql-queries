#ifndef USE_HEADERS

#ifndef HEADER_STRINGSTUB_STUB_H
#define HEADER_STRINGSTUB_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef NULL
    #define NULL 0
#endif

typedef int wchar_t;
extern char* strcpy_s(char* dst, int max_amount, char* src);
extern int _mbsncat(char* dst, char* src, int count);
extern int _mbsncmp(char* dst, char* src, int count);
extern int _memicmp(char* a, char* b, long count);
extern int _mbsnbcmp(char* a, char* b, int count);
extern int printf(const char * format, ...);
extern unsigned long strlen(const char *s);
extern char* strcpy(char * dst, const char * src);
extern int wprintf(const wchar_t * format, ...);
extern wchar_t* wcscpy(wchar_t * s1, const wchar_t * s2);
extern void perror(const char *s);

#ifdef  __cplusplus
}
#endif

#endif

#else

#include <strings.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>

#define strcpy_s strcpy
#define _mbsncat strncat
#define _mbsncmp memcmp
#define _memicmp memcmp
#define _mbsnbcmp memcmp
#define mempcpy memcpy

#endif