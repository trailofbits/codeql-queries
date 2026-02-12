/**
 * @name Invalid key size
 * @id tob/cpp/invalid-key-size
 * @description Tests if keys passed to EVP_EncryptInit and EVP_EncryptInit_ex have the same size as the key size of the cipher used
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import trailofbits.crypto.libraries

class Key extends Variable {
  FunctionCall init;

  Key() {
    DataFlow::localFlow(DataFlow::exprNode(this.getAnAccess()),
      DataFlow::exprNode(init.getArgument(init.getTarget().(EVP_EncryptInit).getKey()))) or
    DataFlow::localFlow(DataFlow::exprNode(this.getAnAccess()),
      DataFlow::exprNode(init.getArgument(init.getTarget().(EVP_EncryptInit_ex).getKey())))
  }

  EVP_CIPHER getACipher() {
    DataFlow::localFlow(DataFlow::exprNode(result),
      DataFlow::exprNode(init.getArgument(init.getTarget().(EVP_EncryptInit).getCipher()))) or
    DataFlow::localFlow(DataFlow::exprNode(result),
      DataFlow::exprNode(init.getArgument(init.getTarget().(EVP_EncryptInit_ex).getCipher())))
  }

  FunctionCall getInitCall() { result = init }

  int getSize() { result = this.getUnderlyingType().getSize() }

  predicate correctKeySize(EVP_CIPHER cipher) { cipher.getKeySize() = this.getSize() }

  // Avoid matching on pointers where the key size is not known.
  predicate isArray() { this.getType() instanceof ArrayType }
}

from Key key, EVP_CIPHER cipher
where
  cipher = key.getACipher() and
  key.isArray() and
  not key.correctKeySize(cipher)
select key.getInitCall().getLocation(),
  "Key size (" + key.getSize() +
    " bytes) does not match the expected key size for the encryption algorithm (" +
    cipher.getKeySize() + " bytes)"
