/**
 * @name Missing BN_CTX_end after BN_CTX_start
 * @id tob/cpp/missing-bn-ctx-end
 * @description Detects BN_CTX_start calls without corresponding BN_CTX_end calls
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
    DataFlow::localFlow(DataFlow::exprNode(start.getContext()),
                        DataFlow::exprNode(end.getContext()))
  )
}

from BN_CTX_start start
where not hasMatchingEnd(start)
select start.getLocation(),
  "BN_CTX_start called without corresponding BN_CTX_end"
