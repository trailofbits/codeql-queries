/**
 * @name Unnecessary NULL check
 * @id tob/cpp/ggml-unnecessary-null-check
 * @description The return value from this function is guaranteed not to be `NULL` 
 * @kind problem
 * @tags correctness ml
 * @problem.severity warning
 * @precision medium
 * @group ml
 */

import cpp
import trailofbits.common
import trailofbits.ml.libraries

string toMessage(ReturnValue value) {
    result =
        "This check could be removed since the return value of `" +
        value.getFunction() +
        "` is guaranteed to be non-null"
}

from
    ControlFlowNode node,
    ReturnValue value
where
    value.notNull() and value.isCheckedAt(node)
select
    node.getLocation(), toMessage(value)