private import cpp
private import trailofbits.itergator.Iterators

import semmle.code.cpp.dataflow.new.DataFlow

private module IteratorFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Access
    or exists(source.asParameter())
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Access).getTarget() instanceof Iterator
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget() instanceof CopyConstructor
  }
}

module IteratorFlow = DataFlow::Global<IteratorFlowConfig>;

private module IteratedFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Access
    or exists(source.asParameter())
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof Iterated }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget() instanceof CopyConstructor
  }
}

module IteratedFlow = DataFlow::Global<IteratedFlowConfig>;

private module InvalidationFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Access a | a = source.asExpr())
    or exists(source.asParameter())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Invalidation i | sink.asExpr() = i.getAChild())
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget() instanceof CopyConstructor
  }
}

module InvalidationFlow = DataFlow::Global<InvalidationFlowConfig>;

private module InvalidatorFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(source) }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().getEnclosingElement() instanceof Invalidator
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget() instanceof CopyConstructor
  }
}

module InvalidatorFlow = DataFlow::Global<InvalidatorFlowConfig>;
