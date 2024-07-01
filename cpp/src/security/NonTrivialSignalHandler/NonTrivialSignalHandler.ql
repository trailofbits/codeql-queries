/**
 * @name Non trivial signal handler
 * @id tob/cpp/non-trivial-signal-handler
 * @description Analyze potential locations for non-thread safe signal handlers (like the one used in CVE-2024-6387)
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision low
 * @security-severity 7.0
 * @group security
 */

 import cpp

/* List from https://man7.org/linux/man-pages/man7/signal-safety.7.html */
class SafeFunction extends Function {
  SafeFunction() {
    this.getName() in [
      "abort", "accept", "access", "aio_error", "aio_return", "aio_suspend",
      "alarm", "bind", "cfgetispeed", "cfgetospeed", "cfsetispeed", "cfsetospeed",
      "chdir", "chmod", "chown", "clock_gettime", "close", "connect", "creat",
      "dup", "dup2", "execl", "execle", "execv", "execve", "_exit", "_Exit",
      "faccessat", "fchdir", "fchmod", "fchmodat", "fchown", "fchownat", "fcntl",
      "fdatasync", "fexecve", "ffs", "fork", "fstat", "fstatat", "fsync",
      "ftruncate", "futimens", "getegid", "geteuid", "getgid", "getgroups",
      "getpeername", "getpgrp", "getpid", "getppid", "getsockname", "getsockopt",
      "getuid", "htonl", "htons", "kill", "link", "linkat", "listen", "longjmp",
      "lseek", "lstat", "memccpy", "memchr", "memcmp", "memcpy", "memmove",
      "memset", "mkdir", "mkdirat", "mkfifo", "mkfifoat", "mknod", "mknodat",
      "ntohl", "ntohs", "open", "openat", "pause", "pipe", "poll", "posix_trace_event",
      "pselect", "pthread_kill", "pthread_self", "pthread_sigmask", "raise", "read",
      "readlink", "readlinkat", "recv", "recvfrom", "recvmsg", "rename", "renameat",
      "rmdir", "select", "sem_post", "send", "sendmsg", "sendto", "setgid", "setpgid",
      "setsid", "setsockopt", "setuid", "shutdown", "sigaction", "sigaddset", "sigdelset",
      "sigemptyset", "sigfillset", "sigismember", "siglongjmp", "signal", "sigpause",
      "sigpending", "sigprocmask", "sigqueue", "sigset", "sigsuspend", "sleep", "sockatmark",
      "socket", "socketpair", "stat", "stpcpy", "stpncpy", "strcat", "strchr", "strcmp",
      "strcpy", "strcspn", "strlen", "strncat", "strncmp", "strncpy", "strnlen", "strpbrk",
      "strrchr", "strspn", "strstr", "strtok_r", "symlink", "symlinkat", "tcdrain", "tcflow",
      "tcflush", "tcgetattr", "tcgetpgrp", "tcsendbreak", "tcsetattr", "tcsetpgrp", "time",
      "timer_getoverrun", "timer_gettime", "timer_settime", "times", "umask", "uname",
      "unlink", "unlinkat", "utime", "utimensat", "utimes", "wait", "waitpid", "wcpcpy",
      "wcpncpy", "wcscat", "wcschr", "wcscmp", "wcscpy", "wcscspn", "wcslen", "wcsncat",
      "wcsncmp", "wcsncpy", "wcsnlen", "wcspbrk", "wcsrchr", "wcsspn", "wcsstr", "wcstok",
      "wmemchr", "wmemcmp", "wmemcpy", "wmemmove", "wmemset", "write"
    ]
  }
}

predicate isDangerous(Function signalHandler) {
  exists(Function f |
    signalHandler.calls+(f)
    and not f instanceof SafeFunction
  )
}


from FunctionCall fc, Function signalHandler
where fc.getTarget().getName() = "signal"
  and signalHandler.getName() = fc.getArgument(1).toString()
  and isDangerous(signalHandler)
select signalHandler, "Signal handler registered"