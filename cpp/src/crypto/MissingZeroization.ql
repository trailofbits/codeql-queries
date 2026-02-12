/**
 * @name Missing zeroization of potentially sensitive random BIGNUM
 * @id tob/cpp/bignum-clearing
 * @description Determines if random bignums are properly zeroized
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import trailofbits.crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow

predicate isCleared(Expr bignum) {
  exists(BN_clear clear |
    DataFlow::localFlow(DataFlow::exprNode(bignum), DataFlow::exprNode(clear.getBignum()))
  )
  or
  exists(CustomDeallocatorCall clear_free |
    clear_free.getTarget() instanceof BN_clear_free and
    DataFlow::localFlow(DataFlow::exprNode(bignum), DataFlow::exprNode(clear_free.getPointer()))
  )
}

predicate isRandom(Expr bignum) {
  exists(BN_rand rand |
    DataFlow::localFlow(DataFlow::exprNode(bignum), DataFlow::exprNode(rand.getBignum()))
  )
}

from BIGNUM bignum
where isRandom(bignum) and not isCleared(bignum)
select bignum.getLocation(),
  "Bignum is initialized with random data but is not zeroized before it goes out of scope"
