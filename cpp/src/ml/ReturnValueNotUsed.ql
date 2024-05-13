/**
 * @name Function return value is discarded
 * @id tob/cpp/return-value-not-used
 * @description Finds function calls where the return value is expected to be used
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
    value.mustUse() and not value.isUsed()
select
    value.getLocation(), "The return value of `" + value.getFunction() + "` is discarded here"