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

// signal(SIGX, signalHandler)
predicate isSignal(FunctionCall signalCall, Function signalHandler) {
  signalCall.getTarget().getName() = "signal"
  and signalHandler.getAnAccess() = signalCall.getArgument(1).getAChild*()
}

/**
 * struct sigaction sigactVar = ...
 * sigaction(SIGX, &sigactVar, ...)
 */
predicate isSigaction(FunctionCall sigactionCall, Function signalHandler, Variable sigactVar) {
  exists(Struct sigactStruct, Field handlerField |
    sigactionCall.getTarget().getName() = "sigaction"
    and sigactionCall.getArgument(1).getAChild*() = sigactVar.getAnAccess()

    // struct sigaction with the handler func
    and sigactStruct.getName() = "sigaction"
    and handlerField.getName() = ["sa_handler", "sa_sigaction", "__sa_handler", "__sa_sigaction", "__sigaction_u"]
    and (
      handlerField = sigactStruct.getAField()
      or
      exists(Union u | u.getAField() = handlerField and u = sigactStruct.getAField().getType())
    )
    and (
      exists(Assignment a, ValueFieldAccess dfa |
        // sigactVar.sa_handler = &signalHandler
        a.getLValue() = dfa.getAChild*()
        and a.getRValue().getAChild*() = signalHandler.getAnAccess()
        and dfa.getTarget() = handlerField
        and dfa.getQualifier+() = sigactVar.getAnAccess()
      )
      or
      exists(ClassAggregateLiteral initLit |
        // struct sigaction sigactVar = {.sa_sigaction = signalHandler};
        // varDec.getVariable() = sigactVar
        sigactVar.getInitializer().getExpr() = initLit
        and signalHandler.getAnAccess() = initLit.getAFieldExpr(handlerField).getAChild*()
      )
    )
  )
}

predicate isSignalDeliveryBlocked(Variable sigactVar) {
  // TODO: should only find writes and for specific signals 
  exists(ValueFieldAccess dfa |
    dfa.getQualifier+() = sigactVar.getAnAccess() and dfa.getTarget().getName() = "sa_mask"
  )
  or
  exists(Field mask |
    mask.getName() = "sa_mask"
    and exists(sigactVar.getInitializer().getExpr().(ClassAggregateLiteral).getAFieldExpr(mask))
  )
}

string deliveryNotBlockedMsg() {
  result = "Delivery of new signals may be not blocked when the handler executes. "
}
 
from FunctionCall fc, Function signalHandler, string msg
where
  isAsyncUnsafe(signalHandler)
  and (
    (isSignal(fc, signalHandler) and msg = deliveryNotBlockedMsg())
    or
    exists(Variable sigactVar |
      isSigaction(fc, signalHandler, sigactVar)
      and if isSignalDeliveryBlocked(sigactVar) then
      msg = ""
      else
      msg = deliveryNotBlockedMsg()
    )
  )
select signalHandler, "is a non-trivial signal handler that uses not async-safe functions. " + msg +
  "Handler is registered by $@", fc, fc.toString()

