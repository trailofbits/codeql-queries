/**
 * @name Legacy cryptographic algorithm
 * @id tob/cpp/use-of-legacy-algorithm
 * @description Detects potential instantiations of legacy cryptographic algorithms
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
          // Symmetric ciphers
          "%arcfour%", "%blowfish%", "%cast%", "%camellia%", "%des%", "%idea%", "%kasumi%",
          "%magma%", "%rc2%", "%rc4%", "%tdea%",
          // Asymmetric ciphers
          "%rsa%"
        ])
select call.getLocation(),
  "Potential use of legacy cryptographic algorithm " + call.getTarget().getQualifiedName() +
    " detected"
