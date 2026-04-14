# Async unsafe signal handler
This is a CodeQL query constructed to find signal handlers that are performing async unsafe operations.

Because a signal may be delivered at any moment, e.g., in the middle of a malloc, the handler shouldn't touch the program's internal state.

The kernel defines a list of async-safe signal functions in its [man page](https://man7.org/linux/man-pages/man7/signal-safety.7.html). Any signal handler that performs operations that are not safe for asynchronous execution may be vulnerable.

Moreover, signal handlers may be re-entered. Handlers' logic should take that possibility into account.

If the issue is exploitable depends on attacker's ability to deliver the signal. Remote attacks may be limitted to some signals (like SIGALRM and SIGURG), while local attacks could use all signals.


## Recommendation
Attempt to keep signal handlers as simple as possible. Only call async-safe functions from signal handlers.

Block delivery of new signals inside signal handlers to prevent handler re-entrancy issues.


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
* [Michal Zalewski, "Delivering Signals for Fun and Profit"](https://lcamtuf.coredump.cx/signals.txt)
* [SEI CERT C Coding Standard "SIG30-C. Call only asynchronous-safe functions within signal handlers"](https://wiki.sei.cmu.edu/confluence/display/c/SIG30-C.+Call+only+asynchronous-safe+functions+within+signal+handlers)
* [regreSSHion: RCE in OpenSSH's server, on glibc-based Linux systems](https://www.qualys.com/2024/07/01/cve-2024-6387/regresshion.txt)
* [signal-safety - async-signal-safe functions](https://man7.org/linux/man-pages/man7/signal-safety.7.html)
