/**
 * @name Memory leak from a GGML custom allocator
 * @id tob/cpp/ggml-memory-leak
 * @description A value allocated using a custom allocator is never freed, leaking the corresponding memory
 * @kind problem
 * @tags correctness ml
 * @problem.severity warning
 * @precision medium
 * @group ml
 */

import cpp
import trailofbits.common
import trailofbits.ml.libraries

string toLine(ControlFlowNode node) { result = node.getLocation().getStartLine().toString() }

string toMessage(ControlFlowNode source, ControlFlowNode sink, StackVariable var) {
  result =
    "The variable `" + var + "` is allocated on line " + 
    toLine(source) + " and may leak on line " + toLine(sink)

}

from
  LocalMemoryLeak leak,
  AllocCall source, 
  Stmt sink,
  SemanticStackVariable var
where
  leak.reaches(source, var, sink)
select 
  source.getLocation(), toMessage(source, sink, var)