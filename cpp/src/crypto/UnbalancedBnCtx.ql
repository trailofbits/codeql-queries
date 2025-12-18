/**
 * @name Unbalanced BN_CTX_start and BN_CTX_end pair
 * @id tob/cpp/missing-bn-ctx-end
 * @description Detects if one call in the BN_CTX_start/BN_CTX_end pair is missing
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import trailofbits.crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.Guards

predicate hasMatchingEnd(BN_CTX_start start) {
  exists(BN_CTX_end end, Function f |
    start.getEnclosingFunction() = f and
    end.getEnclosingFunction() = f and
    DataFlow::localFlow(DataFlow::exprNode(start.getContext()), DataFlow::exprNode(end.getContext()))
  )
}

predicate hasMatchingStart(BN_CTX_end end) {
  exists(BN_CTX_start start, Function f |
    end.getEnclosingFunction() = f and
    start.getEnclosingFunction() = f and
    DataFlow::localFlow(DataFlow::exprNode(start.getContext()), DataFlow::exprNode(end.getContext()))
  )
}

from FunctionCall call, string message
where
  (
    call instanceof BN_CTX_start and
    not hasMatchingEnd(call) and
    message = "BN_CTX_start called without corresponding BN_CTX_end"
  ) or
  (
    call instanceof BN_CTX_end and
    not hasMatchingStart(call) and
    message = "BN_CTX_end called without corresponding BN_CTX_start"
  )
select call.getLocation(), message
