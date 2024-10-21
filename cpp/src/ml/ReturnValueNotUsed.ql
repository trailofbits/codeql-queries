/**
 * @name Function return value is discarded
 * @id tob/cpp/ggml-return-value-not-used
 * @description The return value from this function is expected to be used, but it is immediately discarded
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
    value.mustUse() and not value.isUsed()
select
    value.getLocation(), value.getFunction().(MustUse).getMessage()