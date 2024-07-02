#include "../../../include/libc/string_stubs.h"
#include "../../../include/libc/signal.h"
#include "../../../include/libc/stdlib.h"

void transitive_call() {
    printf("UNSAFE");
}
void transitive_call3() {
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

int main() {
    // Register the safe signal handler
    if (signal(SIGALRM, safe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        _Exit(EXIT_FAILURE);
    }

    // Unsafe example
    if (signal(SIGALRM, unsafe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        _Exit(EXIT_FAILURE);
    }

    // Another unsafe example
    struct sigaction act = { 0 };
    act.sa_flags = SA_SIGINFO;
    act.sa_sigaction = &unsafe_handler2;
    if (sigaction(SIGSEGV, &act, NULL) == -1) {
        perror("sigaction");
        _Exit(EXIT_FAILURE);
    }

    struct sigaction act2 = { 0 };
    act2.sa_flags = SA_SIGINFO;
    act2.sa_handler = &unsafe_handler3;
    if (sigaction(SIGALRM, &act2, NULL) == -1) {
        perror("sigaction 2");
        _Exit(EXIT_FAILURE);
    }

    return 0;
}