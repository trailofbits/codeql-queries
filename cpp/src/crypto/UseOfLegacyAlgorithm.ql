/**
 * @name Use of legacy cryptographic algorithm
 * @id tob/cpp/use-of-legacy-algorithm
 * @description Detects potential instantiations of legacy cryptographic algorithms
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp

from FunctionCall call, string functionName, string cipherName
where
  functionName = call.getTarget().getQualifiedName().toLowerCase() and
  (
    exists(string cn |
      cn in [
          "MD2", "MD4", "MD5", "RIPEMD", "SHA1", "Whirlpool", "Streebog", "PBKDF1", "ArcFour",
          "Blowfish", "CAST", "IDEA", "Kasumi", "Magma", "RC2", "RC4", "TDEA"
        ] and
      cipherName = cn and
      functionName.matches("%" + cn.toLowerCase() + "%")
    )
    or
    /*
     * match DES, but avoid false positives by not matching common terms containing it:
     * 			nodes
     * 			modes
     * 			codes
     * 			describe
     * 			description
     * 			descriptor
     * 			design
     * 			descend
     * 			destroy
     */

    cipherName = "DES" and
    functionName.regexpMatch(".*(?<!no|mo|co)des(?!cri(be|ption|ptor)|ign|cend|troy).*")
  )
select call.getLocation(),
  "Potential use of legacy cryptographic algorithm " + cipherName + " detected in function name " +
    call.getTarget().getQualifiedName()
