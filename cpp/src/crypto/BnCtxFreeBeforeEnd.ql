/**
 * @name BN_CTX_free called before BN_CTX_end
 * @id tob/cpp/bn-ctx-free-before-end
 * @description Detects BN_CTX_free called before BN_CTX_end, which violates the required lifecycle
 * @kind path-problem
 * @tags correctness crypto
 * @problem.severity error
 * @precision medium
 * @group cryptography
 */

import cpp
import trailofbits.crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.ControlFlowGraph

/**
 * Tracks BN_CTX from BN_CTX_start to BN_CTX_free without going through BN_CTX_end
 */
module BnCtxFreeBeforeEndConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(BN_CTX_start start | source.asExpr() = start.getContext())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CustomDeallocatorCall free |
      free.getTarget() instanceof BN_CTX_free and
      sink.asExpr() = free.getPointer()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    // If the context flows through BN_CTX_end, it's properly handled
    exists(BN_CTX_end end | node.asExpr() = end.getContext())
  }
}

module BnCtxFreeBeforeEndFlow = DataFlow::Global<BnCtxFreeBeforeEndConfig>;

import BnCtxFreeBeforeEndFlow::PathGraph

from
  BnCtxFreeBeforeEndFlow::PathNode source, BnCtxFreeBeforeEndFlow::PathNode sink,
  BN_CTX_start start, CustomDeallocatorCall free
where
  BnCtxFreeBeforeEndFlow::flowPath(source, sink) and
  source.getNode().asExpr() = start.getContext() and
  sink.getNode().asExpr() = free.getPointer() and
  free.getTarget() instanceof BN_CTX_free
select free, source, sink,
  "BN_CTX_free called at line " + free.getLocation().getStartLine().toString() +
    " before BN_CTX_end after BN_CTX_start at line " + start.getLocation().getStartLine().toString()
