/**
 * @name Random buffer too small
 * @id tob/cpp/random-buffer-too-small
 * @description Finds buffer overflows in calls to `RAND_bytes`
 * @kind problem
 * @tags security crypto
 * @problem.severity warning
 * @precision high
 * @group cryptography
 */

import cpp
import crypto.libraries

predicate requestedRandomnessFitsInBuffer(RAND_bytes call) { call.getRequestedBytes() <= call.getBufferSize() }

predicate bufferIsPointer(RAND_bytes call) {
    call.getBuffer().getType().getPointerIndirectionLevel() > 0
}

from RAND_bytes randBytesCall
where not bufferIsPointer(randBytesCall) and not requestedRandomnessFitsInBuffer(randBytesCall)
select randBytesCall.getLocation(), "Buffer size (" + randBytesCall.getBufferSize() + ") is smaller than the number of requested bytes (" + randBytesCall.getRequestedBytes() + ") in call to RAND_bytes."
