/**
 * @name Use after free using a GGML custom allocator
 * @id tob/cpp/ggml-use-after-free
 * @description A value allocated using a GGML custom allocator is freed, and then reused without being reallocated.
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
    "The variable `" + var + "` is deallocated on line " + 
    toLine(source) + " and subsequently used on line " + toLine(sink)

}

from
  LocalUseAfterFree uaf,
  FreeCall source, 
  VariableAccess sink,
  SemanticStackVariable var
where 
  uaf.reaches(source, var, sink)
select 
  sink.getLocation(), toMessage(source, sink, var)