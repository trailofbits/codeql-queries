/**
 * @name Use after free related to custom allocator
 * @id tob/cpp/local-use-after-free
 * @description Finds use-after-frees related to GGML custom allocators
 * @kind problem
 * @tags correctness ml
 * @problem.severity warning
 * @precision medium
 * @group ml
 */

import cpp
import trailofbits.ml.common
import trailofbits.ml.libraries

string toLine(ControlFlowNode node) { result = node.getLocation().getStartLine().toString() }

string toMessage(ControlFlowNode source, ControlFlowNode sink, StackVariable var) {
  result =
    "The variable `" + var + "` is deallocated on line " + 
    toLine(source) + " and subsequently used on line " + toLine(sink)

}

from
  LocalUseAfterFree uaf,
  ControlFlowNode source, 
  ControlFlowNode sink,
  StackVariable var
where 
  uaf.reaches(source, var, sink)
select 
  sink.getLocation(), toMessage(source, sink, var)