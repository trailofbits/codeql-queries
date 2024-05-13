/**
 * @name Memory leak related to custom allocator
 * @id tob/cpp/local-memory-leak
 * @description Finds memory leaks related to GGML custom allocators
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
    "The variable `" + var + "` is allocated on line " + 
    toLine(source) + " and leaks on line " + toLine(sink)

}

from
  LocalMemoryLeak leak,
  ControlFlowNode source, 
  ControlFlowNode sink,
  StackVariable var
where 
  leak.reaches(source, var, sink)
select 
  source.getLocation(), toMessage(source, sink, var)