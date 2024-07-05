#ifndef USE_HEADERS

#ifndef HEADER_SIGNAL_STUB_H
#define HEADER_SIGNAL_STUB_H



#define SIGALRM 14
#define SIGSEGV 11
#define SIGTERM 15
#define SIG_ERR -1
#define EXIT_FAILURE 2
#define SA_SIGINFO 4

{} // to silent error from codeql's extractor
typedef void (*sighandler_t)(int);
extern int signal(int, sighandler_t);

typedef struct {
    unsigned long sig[64];
} sigset_t;

typedef struct {
    int      si_signo;     /* Signal number */
    int      si_errno;     /* An errno value */
    int      si_code;      /* Signal code */
} siginfo_t;

struct sigaction {
    void     (*sa_handler)(int);
    void     (*sa_sigaction)(int, siginfo_t *, void *);
    sigset_t   sa_mask;
    int        sa_flags;
    void     (*sa_restorer)(void);
};

extern int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact);
extern int kill(int pid, int sig);


#endif

#else // --- else USE_HEADERS

#include <signal.h>

#endif // --- end USE_HEADERS