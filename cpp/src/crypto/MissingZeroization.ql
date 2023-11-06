/**
 * @name Missing zeroization of random BIGNUMs
 * @id tob/cpp/bignum-clearing
 * @description Determines if random bignums are properly zeroized
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import tob.crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow

predicate isCleared(Expr bignum) {
  exists(BN_clear clear |
    DataFlow::localFlow(DataFlow::exprNode(bignum), DataFlow::exprNode(clear.getArgument(0)))
  )
}

predicate isRandom(Expr bignum) {
  exists(BN_rand rand |
    DataFlow::localFlow(DataFlow::exprNode(bignum), DataFlow::exprNode(rand.getArgument(0)))
  )
}

from BIGNUM bignum
where isRandom(bignum) and not isCleared(bignum)
select bignum.getLocation(), "Bignum is initialized with random data but is not zeroized before it goes out of scope"
