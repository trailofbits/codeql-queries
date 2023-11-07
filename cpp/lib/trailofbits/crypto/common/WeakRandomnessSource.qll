import cpp
import StrongRandomnessSink
import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.dataflow.new.TaintTracking

abstract class WeakRandomnessSource extends Expr {
  abstract string getDescription();
}

// int rand(void);
class Rand extends FunctionCall, WeakRandomnessSource {
  Rand() { this.getTarget().getQualifiedName() = "rand" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// double drand48(void);
class DRand48 extends FunctionCall, WeakRandomnessSource {
  DRand48() { this.getTarget().getQualifiedName() = "drand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// double erand48(unsigned short xsubi[3]);
class ERand48 extends FunctionCall, WeakRandomnessSource {
  ERand48() { this.getTarget().getQualifiedName() = "erand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// long jrand48(unsigned short xsubi[3]);
class JRand48 extends FunctionCall, WeakRandomnessSource {
  JRand48() { this.getTarget().getQualifiedName() = "jrand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// long lrand48(void);
class LRand48 extends FunctionCall, WeakRandomnessSource {
  LRand48() { this.getTarget().getQualifiedName() = "lrand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// long mrand48(void);
class MRand48 extends FunctionCall, WeakRandomnessSource {
  MRand48() { this.getTarget().getQualifiedName() = "mrand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// long nrand48(unsigned short xsubi[3]);
class NRand48 extends FunctionCall, WeakRandomnessSource {
  NRand48() { this.getTarget().getQualifiedName() = "nrand48" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// uint32_t arc4random(void);
class Arc4Random extends FunctionCall, WeakRandomnessSource {
  Arc4Random() { this.getTarget().getQualifiedName() = "arc4random" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// void arc4random_buf(void *buf, size_t nbytes);
class Arc4Random_Buf extends WeakRandomnessSource {
  FunctionCall call;

  Arc4Random_Buf() {
    this = call.getArgument(0).getAChild*() and
    call.getTarget().getQualifiedName() = "arc4random_buf"
  }

  override string getDescription() { result = call.getTarget().getQualifiedName() + " output" }
}

// uint32_t arc4random_uniform(uint32_t upper_bound);
class Arc4Random_Uniform extends FunctionCall, WeakRandomnessSource {
  Arc4Random_Uniform() { this.getTarget().getQualifiedName() = "arc4random_uniform" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// time_t time(time_t *tloc);
class Time extends WeakRandomnessSource {
  FunctionCall call;

  Time() {
    // The output from time is given both as the return value, and is also used
    // to update the first argument.
    this = call.getAChild*() and
    call.getTarget().getQualifiedName() = "time"
  }

  override string getDescription() { result = call.getTarget().getQualifiedName() + " output" }
}

// pid_t getpid(void);
class GetPid extends FunctionCall, WeakRandomnessSource {
  GetPid() { this.getTarget().getQualifiedName() = "getpid" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// pid_t getppid(void);
class GetPPid extends FunctionCall, WeakRandomnessSource {
  GetPPid() { this.getTarget().getQualifiedName() = "getppid" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

// long gethostid(void);
class GetHostId extends FunctionCall, WeakRandomnessSource {
  GetHostId() { this.getTarget().getQualifiedName() = "gethostid" }

  override string getDescription() { result = this.getTarget().getQualifiedName() + " output" }
}

module WeakRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof WeakRandomnessSource
    // source = source
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asIndirectExpr() instanceof StrongRandomnessSink
    // sink = sink
  }

  additional string sourceDescription(DataFlow::Node source) {
    result = source.asExpr().(WeakRandomnessSource).getDescription()
  }

  additional string sinkDescription(DataFlow::Node sink) {
    result = sink.asIndirectExpr().(StrongRandomnessSink).getDescription()
  }
}

module WeakRandomnessTaint = TaintTracking::Global<WeakRandomnessConfig>;
