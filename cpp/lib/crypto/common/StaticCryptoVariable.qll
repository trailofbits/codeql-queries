import cpp
import StrongPasswordSink
import StrongRandomnessSink
private import semmle.code.cpp.dataflow.new.DataFlow

class StaticKeyLiteral extends ArrayOrVectorAggregateLiteral {
  Variable var;

  StaticKeyLiteral() {
    this = var.getInitializer().getExpr()
  }

  int getSize() {
    result = this.getArraySize()
  }

  VariableAccess getAnAccess() {
    result = var.getAnAccess()
  }
}

class StaticKeyAccess extends VariableAccess {
  StaticKeyLiteral key;

  StaticKeyAccess() {
    this = key.getAnAccess()
  }

  StaticKeyLiteral getKey() {
    result = key
  }
}

class StaticPasswordLiteral extends StringLiteral {
  VariableAccess getAnAccess() {
    result = this.getEnclosingVariable().getAnAccess()
  }
}

class StaticPasswordAccess extends VariableAccess {
  StaticPasswordLiteral password;

  StaticPasswordAccess() {
    this = password.getAnAccess()
  }

  StaticPasswordLiteral getPassword() {
    result = password
  }
}

module StaticKeyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StaticKeyAccess
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() instanceof StrongRandomnessSink
  }
}

module StaticKeyFlow = DataFlow::Global<StaticKeyConfig>;

module StaticPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StaticPasswordAccess
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() instanceof StrongPasswordSink
  }
}

module StaticPasswordFlow = DataFlow::Global<StaticPasswordConfig>;
