/**
 * @name Custom allocator leak
 * @id tob/cpp/custom-allocator-leak
 * @description Finds memory leaks from custom allocated memory
 * @kind problem
 * @tags security crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import trailofbits.crypto.libraries

string toLine(ControlFlowNode node) { result = node.getLocation().getStartLine().toString() }

from
  SemanticStackVariable var, CustomAllocatorLeak leak, ControlFlowNode source, ControlFlowNode sink
where leak.reaches(source, var, sink)
select source.getLocation(),
  "The variable " + var.toString() + " is allocated on line " + toLine(source) +
    " and may leak on line " + toLine(sink)
