/**
 * @name Async unsafe signal handler
 * @id tob/cpp/async-unsafe-signal-handler
 * @description Async unsafe signal handler (like the one used in CVE-2024-6387)
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision high
 * @security-severity 7.0
 * @group security
 */

import cpp

/* List from https://man7.org/linux/man-pages/man3/stdio.3.html */
class StdioFunction extends Function {
  StdioFunction() {
    this.getName() in [
        "fopen", "freopen", "fflush", "fclose", "fread", "fwrite", "fgetc", "fgets", "fputc",
        "fputs", "getc", "getchar", "gets", "putc", "putchar", "puts", "ungetc", "fprintf",
        "fscanf", "printf", "scanf", "sprintf", "sscanf", "vprintf", "vfprintf", "vsprintf",
        "fgetpos", "fsetpos", "ftell", "fseek", "rewind", "clearerr", "feof", "ferror", "perror",
        "setbuf", "setvbuf", "remove", "rename", "tmpfile", "tmpnam",
      ]
  }
}

/* List from https://man7.org/linux/man-pages/man3/syslog.3.html */
class SyslogFunction extends Function {
  SyslogFunction() { this.getName() in ["syslog", "vsyslog",] }
}

/* List from https://man7.org/linux/man-pages/man0/stdlib.h.0p.html */
class StdlibFunction extends Function {
  StdlibFunction() { this.getName() in ["malloc", "calloc", "realloc", "free",] }
}

predicate isAsyncUnsafe(Function signalHandler) {
  exists(Function f |
    signalHandler.calls+(f) and
    (
      f instanceof StdioFunction or
      f instanceof SyslogFunction or
      f instanceof StdlibFunction
    )
  )
}

predicate isSignalHandlerField(FieldAccess fa) {
  fa.getTarget().getName() in ["__sa_handler", "__sa_sigaction", "sa_handler", "sa_sigaction"]
}

from FunctionCall fc, Function signalHandler, FieldAccess fa
where
  (
    fc.getTarget().getName().matches("%_signal") or
    fc.getTarget().getName() = "signal"
  ) and
  signalHandler.getName() = fc.getArgument(1).toString() and
  isAsyncUnsafe(signalHandler)
  or
  fc.getTarget().getName() = "sigaction" and
  isSignalHandlerField(fa) and
  signalHandler = fa.getTarget().getAnAssignedValue().(AddressOfExpr).getAddressable() and
  isAsyncUnsafe(signalHandler)
select signalHandler,
  "is a non-trivial signal handler that may be using functions that are not async-safe."
