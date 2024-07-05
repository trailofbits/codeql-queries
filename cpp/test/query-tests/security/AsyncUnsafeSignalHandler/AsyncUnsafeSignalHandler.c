#include "../../../include/libc/string_stubs.h"
#include "../../../include/libc/signal.h"
#include "../../../include/libc/stdlib.h"
#include "../../../include/libc/unistd.h"
#include "../../../include/libc/stdarg.h"

void transitive_call() {
    printf("UNSAFE");
}
void transitive_call3() {
    // TODO: decide which functions are exploitable
    int *x = (int*)malloc(16);
    free(x);
}
void transitive_call2() {
    transitive_call3();
}

// Signal handler function
void safe_handler(int sig) {
    if (sig == SIGALRM) {
        kill(1, SIGALRM);
    }
}

void unsafe_handler(int sig) {
    transitive_call();
}

void unsafe_handler2(int signo, siginfo_t *info, void *context) {
    if (signo == 3) {
        _Exit(0);
    }
    transitive_call2();
}

void unsafe_handler3(int signal) {
    transitive_call3();
}

// data flow case, regresshion-like
#define sigdie(...) do_logging_and_die(__FILE__, NULL, __VA_ARGS__)

static void do_log(int level, const char *suffix, const char *fmt, va_list args) {
	int pri = 0;
    openlog(suffix, 1, 2);
    // the unsafe call from the handler
    syslog(pri, "%.500s", fmt);
    closelog();
}

static const int level = 0;
void logv(const char *file, const char *suffix, const char *fmt, va_list args) {
    char tmp[] = "sufsuf: ";
    suffix = tmp;
    if(!args) {
        suffix = &tmp[3];
    }
	do_log(level, suffix, fmt, args);
}

void do_logging_and_die(const char *file, const char *suffix, const char *fmt, ...) {
	va_list args;
	va_start(args, fmt);
	logv(file, suffix, fmt, args);
	va_end(args);
	_exit(1);
}

static void df_handler(int sig) {
	if (2*sig % 5 == 3) {
		_exit(1);
	}
	sigdie("some log %d", sig);
}

sighandler_t register_signal(int signum, sighandler_t handler) {
	struct sigaction sa, osa;
	memset(&sa, 0, sizeof(sa));
	sa.sa_handler = handler;
	sigfillset(&sa.sa_mask);
	if (sigaction(signum, &sa, &osa) == -1) {
		return NULL;
	}
	return osa.sa_handler;
}

int main() {
    // Register the safe signal handler
    if (signal(SIGALRM, safe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 1
    if (signal(SIGALRM, unsafe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 2
    // TODO: decide which signals are exploitable and should produce findings
    struct sigaction act = { 0 };
    act.sa_flags = SA_SIGINFO;
    act.sa_sigaction = &unsafe_handler2;
    if (sigaction(SIGSEGV, &act, NULL) == -1) {
        perror("sigaction");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 3
    struct sigaction act2 = {.sa_flags = SA_SIGINFO, .sa_sigaction = unsafe_handler2};
    if (sigaction(SIGALRM, &act2, NULL) == -1) {
        perror("sigaction 2");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 4
    // TODO: not every masked signals should indicate safe signal handling
    sigset_t sigset;
    sigemptyset(&sigset);
    sigaddset(&sigset, SIGALRM);
    struct sigaction act3 = {.sa_flags = SA_SIGINFO, .sa_sigaction = unsafe_handler2, .sa_mask = sigset};
    if (sigaction(SIGALRM, &act3, NULL) == -1) {
        perror("sigaction 3");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 5
    struct sigaction act4 = {.sa_flags = SA_SIGINFO, .sa_sigaction = unsafe_handler2};
    act4.sa_mask = sigset;
    if (sigaction(SIGSEGV, &act4, NULL) == -1) {
        perror("sigaction 4");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 6
    struct sigaction act5 = {.sa_mask = sigset};
    act5.sa_flags = SA_SIGINFO;
    act5.sa_sigaction = &unsafe_handler2;
    if (sigaction(SIGSEGV, &act5, NULL) == -1) {
        perror("sigaction 5");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example 7, indirect handler registration
    if(register_signal(SIGALRM, df_handler)) {
        _exit(EXIT_FAILURE);
    }

    return 0;
}