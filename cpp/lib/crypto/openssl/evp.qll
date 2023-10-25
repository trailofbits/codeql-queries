import cpp
import crypto.common

// This file contains CodeQL models for the OpenSSL EVP API defined in
// openssl/evp.h.

// int EVP_EncryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                     const unsigned char *key, const unsigned char *iv);
class EVP_EncryptInit extends SymmetricCipherInitWithKeyAndIv {
  EVP_EncryptInit() {
    this.getQualifiedName() = "EVP_EncryptInit"
  }

  int getCipher() {
    result = 1
  }


  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 2
  }

  override int getIv() {
    result = 3
  }
}

// int EVP_DecryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                     const unsigned char *key, const unsigned char *iv);
class EVP_DecryptInit extends SymmetricCipherInitWithKeyAndIv {
  EVP_DecryptInit() {
    this.getQualifiedName() = "EVP_DecryptInit"
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 2
  }

  override int getIv() {
    result = 3
  }
}

// int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                        ENGINE *impl, const unsigned char *key, const unsigned char *iv);
class EVP_EncryptInit_ex extends SymmetricCipherInitWithKeyAndIv {
  EVP_EncryptInit_ex() {
    this.getQualifiedName() = "EVP_EncryptInit_ex"
  }

  int getCipher(){
    result = 1
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 3
  }

  override int getIv() {
    result = 4
  }
}

// int EVP_DecryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                        ENGINE *impl, const unsigned char *key, const unsigned char *iv);
class EVP_DecryptInit_ex extends SymmetricCipherInitWithKeyAndIv {
  EVP_DecryptInit_ex() {
    this.getQualifiedName() = "EVP_DecryptInit_ex"
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 3
  }

  override int getIv() {
    result = 4
  }
}

// int EVP_CipherInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                    const unsigned char *key, const unsigned char *iv, int enc);
class EVP_CipherInit extends SymmetricCipherInitWithKeyAndIv {
  EVP_CipherInit() {
    this.getQualifiedName() = "EVP_CipherInit"
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 2
  }

  override int getIv() {
    result = 3
  }

  int getMode() {
    result = 4
  }
}

// int EVP_CipherInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                       ENGINE *impl, const unsigned char *key, const unsigned char *iv, int enc);
class EVP_CipherInit_ex extends SymmetricCipherInitWithKeyAndIv {
  EVP_CipherInit_ex() {
    this.getQualifiedName() = "EVP_CipherInit_ex"
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 3
  }

  override int getIv() {
    result = 4
  }

  int getMode() {
    result = 5
  }
}


class BIO_set_cipher extends SymmetricCipherInitWithKeyAndIv {
  BIO_set_cipher() {
    this.getQualifiedName() = "BIO_set_cipher"
  }

  override int getAContextArg() {
    result = 0
  }

  override int getKey() {
    result = 2
  }

  override int getIv() {
    result = 3
  }

  int getMode() {
    result = 4
  }
}

// int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
//                       int *outl, const unsigned char *in, int inl);
class EVP_EncryptUpdate extends SymmetricCipherUpdate {
  EVP_EncryptUpdate() {
    this.getQualifiedName() = "EVP_EncryptUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
//                       int *outl, const unsigned char *in, int inl);
class EVP_DecryptUpdate extends SymmetricCipherUpdate {
  EVP_DecryptUpdate() {
    this.getQualifiedName() = "EVP_DecryptUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
//                      int *outl, const unsigned char *in, int inl);
class EVP_CipherUpdate extends SymmetricCipherUpdate {
  EVP_CipherUpdate() {
    this.getQualifiedName() = "EVP_CipherUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_EncryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
class EVP_EncryptFinal extends SymmetricCipherFinal {
  EVP_EncryptFinal() {
    this.getQualifiedName() = "EVP_EncryptFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_DecryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_DecryptFinal extends SymmetricCipherFinal {
  EVP_DecryptFinal() {
    this.getQualifiedName() = "EVP_DecryptFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
class EVP_EncryptFinal_ex extends SymmetricCipherFinal {
  EVP_EncryptFinal_ex() {
    this.getQualifiedName() = "EVP_EncryptFinal_ex"
  }

  override int getAContextArg() {
    result = 0
  }
}

 // int EVP_DecryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_DecryptFinal_ex extends SymmetricCipherFinal {
  EVP_DecryptFinal_ex() {
    this.getQualifiedName() = "EVP_DecryptFinal_ex"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_CipherFinal extends SymmetricCipherFinal {
  EVP_CipherFinal() {
    this.getQualifiedName() = "EVP_CipherFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_CipherFinal_ex extends SymmetricCipherFinal {
  EVP_CipherFinal_ex() {
    this.getQualifiedName() = "EVP_CipherFinal_ex"
  }

  override int getAContextArg() {
    result = 0
  }
}

// Used by the MissingInitializer query.
class EVP_EncryptTuple extends InitUpdateFinalTuple {
  EVP_EncryptTuple() {
    this = "EVP_EncryptTuple"
  }

  override InitFunction getInit() {
    result instanceof EVP_EncryptInit or
    result instanceof EVP_EncryptInit_ex
  }

  override UpdateFunction getUpdate() {
    result instanceof EVP_EncryptUpdate
  }

  override FinalFunction getFinal() {
    result instanceof EVP_EncryptFinal or
    result instanceof EVP_EncryptFinal_ex
  }
}

// Used by the MissingInitializer query.
class EVP_DecryptTuple extends InitUpdateFinalTuple {
  EVP_DecryptTuple() {
    this = "EVP_DecryptTuple"
  }

  override InitFunction getInit() {
    result instanceof EVP_DecryptInit or
    result instanceof EVP_DecryptInit_ex
  }

  override UpdateFunction getUpdate() {
    result instanceof EVP_DecryptUpdate
  }

  override FinalFunction getFinal() {
    result instanceof EVP_DecryptFinal or
    result instanceof EVP_DecryptFinal_ex
  }
}

// Used by the MissingInitializer query.
class EVP_CipherTuple extends InitUpdateFinalTuple {
  EVP_CipherTuple() {
    this = "EVP_CipherTuple"
  }

  override InitFunction getInit() {
    result instanceof EVP_CipherInit or
    result instanceof EVP_CipherInit_ex
  }

  override UpdateFunction getUpdate() {
    result instanceof EVP_CipherUpdate
  }

  override FinalFunction getFinal() {
    result instanceof EVP_CipherFinal or
    result instanceof EVP_CipherFinal_ex
  }
}

class EVP_BytesToKey extends KeyDerivationFunctionWithPasswordAndSalt {
  EVP_BytesToKey() {
    this.getQualifiedName() = "EVP_BytesToKey"
  }

  override int getPassword() {
    result = 3
  }

  override int getSalt() {
    result = 2
  }
}

class PKCS5_PBE_keyivgen extends KeyDerivationFunctionWithPassword {
  PKCS5_PBE_keyivgen() {
    this.getQualifiedName() = "PKCS5_PBE_keyivgen"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 6
  }
}

class PKCS5_PBKDF2_HMAC_SHA1 extends KeyDerivationFunctionWithPasswordAndSalt {
  PKCS5_PBKDF2_HMAC_SHA1() {
    this.getQualifiedName() = "PKCS5_PBKDF2_HMAC_SHA1"
  }

  override int getPassword() {
    result = 0
  }

  override int getSalt() {
    result = 2
  }
}

class PKCS5_PBKDF2_HMAC extends KeyDerivationFunctionWithPasswordAndSalt {
  PKCS5_PBKDF2_HMAC() {
    this.getQualifiedName() = "PKCS5_PBKDF2_HMAC"
  }

  override int getPassword() {
    result = 0
  }

  override int getSalt() {
    result = 2
  }
}

class PKCS5_v2_PBE_keyivgen extends KeyDerivationFunctionWithPassword {
  PKCS5_v2_PBE_keyivgen() {
    this.getQualifiedName() = "PKCS5_v2_PBE_keyivgen"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 6
  }
}

class EVP_PBE_scrypt extends KeyDerivationFunctionWithPasswordAndSalt {
  EVP_PBE_scrypt() {
    this.getQualifiedName() = "EVP_PBE_scrypt"
  }

  override int getPassword() {
    result = 0
  }

  override int getSalt() {
    result = 2
  }
}

class PKCS5_v2_scrypt_keyivgen extends KeyDerivationFunctionWithPassword {
  PKCS5_v2_scrypt_keyivgen() {
    this.getQualifiedName() = "PKCS5_v2_scrypt_keyivgen"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 6
  }
}

class EVP_PBE_CipherInit extends KeyDerivationFunctionWithPassword {
  EVP_PBE_CipherInit() {
    this.getQualifiedName() = "EVP_PBE_CipherInit"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 5
  }
}

// TODO: Implement support for `EVP_CIPHER_fetch`.
class EVP_CIPHER extends FunctionCall {

  int keySize;

  EVP_CIPHER () {
    // AES XTS variants.
    (this.getTarget().getName().matches("%EVP_aes_256_xts%") and keySize = 64) or
    (this.getTarget().getName().matches("%EVP_aes_128_xts%") and keySize = 32) or
    // Remaining AES variants.
    (this.getTarget().getName().matches("%EVP_aes_256%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_192%") and keySize = 24) or
    (this.getTarget().getName().matches("%EVP_aes_128%") and keySize = 16) or
    // Chacha20 variants.
    (this.getTarget().getName().matches("%EVP_chacha20%") and keySize = 32)
  }

  int getKeySize() {
      result = keySize
  }
}
