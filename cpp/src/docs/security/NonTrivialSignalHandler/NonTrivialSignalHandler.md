# Non trivial signal handler
This is a CodeQL query constructed to find signal handlers that are performing async unsafe operations.

CVE-2024-6387 (regreSSHion) discovered by Qualys affected OpenSSH (sshd) because of signal handler race condition. Indeed, the kernel defines a list of async-safe signal functions in its [man page](https://man7.org/linux/man-pages/man7/signal-safety.7.html).


## Recommendation
Signal handlers should be as concise as possible. This compliant solution sets a flag of type volatile `sig_atomic_t` and returns; the `log_message()` and `free()` functions are called directly from main():


## Example

```c
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
 
enum { MAXLINE = 1024 };
volatile sig_atomic_t eflag = 0;
char *info = NULL;
 
void log_message(void) {
  fputs(info, stderr);
}
 
void correct_handler(int signum) {
  eflag = 1;
}
 
int main(void) {
  if (signal(SIGINT, correct_handler) == SIG_ERR) {
    /* Handle error */
  }
  info = (char *)malloc(MAXLINE);
  if (info == NULL) {
    /* Handle error */
  }
 
  while (!eflag) {
    /* Main loop program code */
 
    log_message();
 
    /* More program code */
  }
 
  log_message();
  free(info);
  info = NULL;
 
  return 0;
}
```
In this example, while both syntatically valid, a correct handler is defined in the `correct_handler` function and sets a flag. The function calls `log_message`, a async unsafe function, within the main loop.


## References
* [SEI CERT C Coding Standard "SIG30-C. Call only asynchronous-safe functions within signal handlers"](https://wiki.sei.cmu.edu/confluence/display/c/SIG30-C.+Call+only+asynchronous-safe+functions+within+signal+handlers)
* [Qualys. regreSSHion - CVE-2024-6387](https://blog.qualys.com/vulnerabilities-threat-research/2024/07/01/regresshion-remote-unauthenticated-code-execution-vulnerability-in-openssh-server)
