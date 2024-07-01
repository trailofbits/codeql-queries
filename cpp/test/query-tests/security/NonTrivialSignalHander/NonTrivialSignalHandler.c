#include "../../../include/libc/string_stubs.h"
#include "../../../include/libc/signal.h"

void transitive_call() {
    printf("UNSAFE");
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

int main() {
    // Register the signal handler
    if (signal(SIGALRM, safe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        exit(EXIT_FAILURE);
    }

    if (signal(SIGALRM, unsafe_handler) == SIG_ERR) {
        perror("Unable to catch SIGALRM");
        exit(EXIT_FAILURE);
    }

    return 0;
}