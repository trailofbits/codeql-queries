/**
 * @name Function return value is not checked
 * @id tob/cpp/ggml-return-value-not-checked
 * @description The return value from this function is expected to be checked in some way, but it is not
 * @kind problem
 * @tags correctness ml
 * @problem.severity warning
 * @precision medium
 * @group ml
 */

import cpp
import trailofbits.common
import trailofbits.ml.libraries


from
    ReturnValue value
where
    value.mustCheck() and not (value.isChecked() or value.isReturned()) 
select
    value.getLocation(), value.getFunction().(MustCheck).getMessage()