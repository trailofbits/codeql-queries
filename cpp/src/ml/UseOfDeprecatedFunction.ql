/**
 * @name Use of deprecated function
 * @id tob/cpp/ggml-deprecated-function-use
 * @description The called function is deprecated and should not be used
 * @kind problem
 * @tags ml
 * @problem.severity warning
 * @precision high
 * @group ml
 */

import cpp
import trailofbits.common
import trailofbits.ml.libraries

from
    Deprecated deprecated
select
    deprecated.getACallToThisFunction(), "This function is deprecated and should not be used"
