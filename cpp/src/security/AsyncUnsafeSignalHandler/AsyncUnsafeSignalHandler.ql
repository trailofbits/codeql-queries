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
import semmle.code.cpp.dataflow.new.DataFlow

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

/**
 * Flows from any function ptr
 */
module HandlerToSignalConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() = any(Function f | | f.getAnAccess())
  }

  predicate isSink(DataFlow::Node sink) { sink = sink }
}

module HandlerToSignal = DataFlow::Global<HandlerToSignalConfiguration>;

/**
 * signal(SIGX, signalHandler)
 */
predicate isSignal(FunctionCall signalCall, Function signalHandler) {
  signalCall.getTarget().getName() = "signal" and
  exists(DataFlow::Node source, DataFlow::Node sink |
    HandlerToSignal::flow(source, sink) and
    source.asExpr() = signalHandler.getAnAccess() and
    sink.asExpr() = signalCall.getArgument(1)
  )
}

/**
 * struct sigaction sigactVar = ...
 * sigaction(SIGX, &sigactVar, ...)
 */
predicate isSigaction(FunctionCall sigactionCall, Function signalHandler, Variable sigactVar) {
  exists(Struct sigactStruct, Field handlerField, DataFlow::Node source, DataFlow::Node sink |
    sigactionCall.getTarget().getName() = "sigaction" and
    sigactionCall.getArgument(1).getAChild*() = sigactVar.getAnAccess() and
    // struct sigaction with the handler func
    sigactStruct.getName() = "sigaction" and
    handlerField.getName() =
      ["sa_handler", "sa_sigaction", "__sa_handler", "__sa_sigaction", "__sigaction_u"] and
    (
      handlerField = sigactStruct.getAField()
      or
      exists(Union u | u.getAField() = handlerField and u = sigactStruct.getAField().getType())
    ) and
    (
      // sigactVar.sa_handler = &signalHandler
      exists(Assignment a, ValueFieldAccess vfa |
        vfa.getTarget() = handlerField and
        vfa.getQualifier+() = sigactVar.getAnAccess() and
        a.getLValue() = vfa.getAChild*() and
        source.asExpr() = signalHandler.getAnAccess() and
        sink.asExpr() = a.getRValue() and
        HandlerToSignal::flow(source, sink)
      )
      or
      // struct sigaction sigactVar = {.sa_sigaction = signalHandler};
      exists(ClassAggregateLiteral initLit |
        sigactVar.getInitializer().getExpr() = initLit and
        source.asExpr() = signalHandler.getAnAccess() and
        sink.asExpr() = initLit.getAFieldExpr(handlerField).getAChild*() and
        HandlerToSignal::flow(source, sink)
      )
    )
  )
}

/**
 * Determine if new signals are blocked
 * TODO: should only find writes and only for correct (or all) signals
 * TODO: should detect other block mechanisms
 */
predicate isSignalDeliveryBlocked(Variable sigactVar) {
  exists(ValueFieldAccess dfa |
    dfa.getQualifier+() = sigactVar.getAnAccess() and dfa.getTarget().getName() = "sa_mask"
  )
  or
  exists(Field mask |
    mask.getName() = "sa_mask" and
    exists(sigactVar.getInitializer().getExpr().(ClassAggregateLiteral).getAFieldExpr(mask))
  )
}

string deliveryNotBlockedMsg() { result = "Moreover, delivery of new signals may be not blocked. " }

from FunctionCall fc, Function signalHandler, string msg
where
  isAsyncUnsafe(signalHandler) and
  (
    isSignal(fc, signalHandler) and msg = deliveryNotBlockedMsg()
    or
    exists(Variable sigactVar |
      isSigaction(fc, signalHandler, sigactVar) and
      if isSignalDeliveryBlocked(sigactVar) then msg = "" else msg = deliveryNotBlockedMsg()
    )
  )
select signalHandler,
  "$@ is a non-trivial signal handler that uses not async-safe functions. " + msg +
    "Handler is registered by $@.", signalHandler, signalHandler.toString(), fc, fc.toString()
