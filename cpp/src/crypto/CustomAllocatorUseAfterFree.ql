/**
 * @name Custom allocator use-after-free
 * @id tob/cpp/custom-allocator-use-after-free
 * @description Finds use-after-frees related to custom allocators like `BN_new`
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import tob.crypto.libraries

string toLine(ControlFlowNode node) { result = node.getLocation().getStartLine().toString() }

from
  CustomAllocatorUseAfterFree uaf, SemanticStackVariable var, ControlFlowNode source,
  ControlFlowNode sink
where uaf.reaches(source, var, sink)
select source.getLocation(),
  "The variable " + var.toString() + " is deallocated on line " + toLine(source) +
    " and then subsequently used on line " + toLine(sink)
