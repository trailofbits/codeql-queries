#ifndef USE_HEADERS

#ifndef HEADER_STDLIB_STUB_H
#define HEADER_STDLIB_STUB_H

    #define SIGALRM 14
    #define SIG_ERR -1
    #define EXIT_FAILURE 2
    typedef void (*sighandler_t)(int);
    int signal(int, sighandler_t);

#endif


#else // --- else USE_HEADERS

#include <signal.h>

#endif // --- end USE_HEADERS