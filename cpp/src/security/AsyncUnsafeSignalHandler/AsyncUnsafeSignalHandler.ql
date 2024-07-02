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
predicate isSigaction(FunctionCall sigactionCall, Function signalHandler) {
  exists(Variable sigactVar, Struct sigactStruct, Field handlerField |
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
      exists(VariableDeclarationEntry varDec, ClassAggregateLiteral init |
        // struct sigaction sigactVar = {.sa_sigaction = signalHandler};
        varDec.getVariable() = sigactVar
        and sigactVar.getInitializer().getExpr() = init
        and signalHandler.getAnAccess() = init.getAFieldExpr(handlerField).getAChild*()
        // ignore if signals are blocked via sa_mask
        and not exists(Field mask | mask.getName() = "sa_mask" and exists(init.getAFieldExpr(mask)))
      )
    )
    // ignore if signals are blocked via sa_mask
    and not exists(ValueFieldAccess dfa |
      dfa.getQualifier+() = sigactVar.getAnAccess()
      and dfa.getTarget().getName() = "sa_mask"
    )
  )
}
 
from FunctionCall fc, Function signalHandler  
where
  isAsyncUnsafe(signalHandler)
  and (
    isSignal(fc, signalHandler)
    or
    isSigaction(fc, signalHandler)
  )
select signalHandler, "is a non-trivial signal handler that may be using not async-safe functions. Registered by $@", fc, fc.toString()

