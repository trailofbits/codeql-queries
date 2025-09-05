/**
 * @name Use of legacy cryptographic algorithm
 * @id tob/cpp/use-of-legacy-algorithm
 * @description Detects potential calls to legacy cryptographic algorithms
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp

from FunctionCall call
where
  call.getTarget()
      .getQualifiedName()
      .toLowerCase()
      .matches([
          // Hash functions
          "%md2%", "%md4%", "%md5%", "%ripemd%", "%sha1%", "%whirlpool%", "%streebog%",
          // KDFs
          "%pbkdf1%",
          // Symmetric ciphers
          "%arcfour%", "%blowfish%", "%kasumi%", "%magma%", "%rc2%", "%rc4%", "%tdea%"
      ])
select call.getLocation(),
  "Potential use of legacy cryptographic algorithm " + call.getTarget().getQualifiedName() +
    " detected"
