/**
 * @name Random buffer too small
 * @id tob/cpp/random-buffer-too-small
 * @description Finds buffer overflows in calls to CSPRNGs
 * @kind problem
 * @tags security crypto
 * @problem.severity warning
 * @precision high
 * @group cryptography
 */

import cpp
import trailofbits.crypto.common
import trailofbits.crypto.libraries

// Exclude pointer arguments where we cannot determine the buffer size.
predicate sourceIsPointer(CsprngCall call) {
  call.getAStrongRandomnessSource().getType().getPointerIndirectionLevel() > 0
}

int getBufferSize(CsprngCall call) {
  result = call.getAStrongRandomnessSource().getUnderlyingType().getSize()
}

int getRequestedBytes(CsprngCall call) { result = call.getRequestedBytes().getValue().toInt() }

from CsprngCall call, int bufferSize, int requestedSize
where
  not sourceIsPointer(call) and
  bufferSize = getBufferSize(call) and
  requestedSize = getRequestedBytes(call) and
  requestedSize > bufferSize
select call.getLocation(),
  "Buffer size (" + bufferSize + ") is smaller than the number of requested bytes (" + requestedSize
    + ") in call to '" + call.getTarget().getName() + "'."
