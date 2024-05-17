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
import trailofbits.ml.common
import trailofbits.ml.libraries


from
    ReturnValue value
where
    value.mustCheck() and not value.isChecked()
select
    value.getLocation(), "The return value of `" + value.getFunction() + "` is not checked"