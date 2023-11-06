import cpp
import tob.crypto.common

// This file contains CodeQL models for the OpenSSL EVP API defined in
// openssl/evp.h.

// int EVP_EncryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
//                     const unsigned char *key, const unsigned char *iv);
class EVP_EncryptInit extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_DecryptInit extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_EncryptInit_ex extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_DecryptInit_ex extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_CipherInit extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_CipherInit_ex extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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


class BIO_set_cipher extends SymmetricCipherInitWithKeyAndIv, ReturnsErrorCode {
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
class EVP_EncryptUpdate extends SymmetricCipherUpdate, ReturnsErrorCode {
  EVP_EncryptUpdate() {
    this.getQualifiedName() = "EVP_EncryptUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
//                       int *outl, const unsigned char *in, int inl);
class EVP_DecryptUpdate extends SymmetricCipherUpdate, ReturnsErrorCode {
  EVP_DecryptUpdate() {
    this.getQualifiedName() = "EVP_DecryptUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
//                      int *outl, const unsigned char *in, int inl);
class EVP_CipherUpdate extends SymmetricCipherUpdate, ReturnsErrorCode {
  EVP_CipherUpdate() {
    this.getQualifiedName() = "EVP_CipherUpdate"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_EncryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
class EVP_EncryptFinal extends SymmetricCipherFinal, ReturnsErrorCode {
  EVP_EncryptFinal() {
    this.getQualifiedName() = "EVP_EncryptFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_DecryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_DecryptFinal extends SymmetricCipherFinal, ReturnsErrorCode {
  EVP_DecryptFinal() {
    this.getQualifiedName() = "EVP_DecryptFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
class EVP_EncryptFinal_ex extends SymmetricCipherFinal, ReturnsErrorCode {
  EVP_EncryptFinal_ex() {
    this.getQualifiedName() = "EVP_EncryptFinal_ex"
  }

  override int getAContextArg() {
    result = 0
  }
}

 // int EVP_DecryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_DecryptFinal_ex extends SymmetricCipherFinal, ReturnsErrorCode {
  EVP_DecryptFinal_ex() {
    this.getQualifiedName() = "EVP_DecryptFinal_ex"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_CipherFinal extends SymmetricCipherFinal, ReturnsErrorCode {
  EVP_CipherFinal() {
    this.getQualifiedName() = "EVP_CipherFinal"
  }

  override int getAContextArg() {
    result = 0
  }
}

// int EVP_CipherFinal(EVP_CIPHER_CTX *ctx, unsigned char *outm, int *outl);
class EVP_CipherFinal_ex extends SymmetricCipherFinal, ReturnsErrorCode {
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

// int EVP_BytesToKey(const EVP_CIPHER *type,
//                    const EVP_MD *md,
//                    const unsigned char *salt,
//                    const unsigned char *data,
//                    int datal,
//                    int count,
//                    unsigned char *key,
//                    unsigned char *iv);
class EVP_BytesToKey extends KeyDerivationFunctionWithPasswordAndSalt, ReturnsErrorCode {
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

// int PKCS5_PBE_keyivgen(EVP_CIPHER_CTX *ctx,
//                        const char *pass,
//                        int passlen,
//                        ASN1_TYPE *param,
//                        const EVP_CIPHER *cipher,
//                        const EVP_MD *md,
//                        int en_de);
class PKCS5_PBE_keyivgen extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
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

// int PKCS5_PBKDF2_HMAC_SHA1(const char *pass,
//                            int passlen,
//                            const unsigned char *salt,
//                            int saltlen,
//                            int iter,
//                            int keylen,
//                            unsigned char *out);
class PKCS5_PBKDF2_HMAC_SHA1 extends KeyDerivationFunctionWithPasswordAndSalt, ReturnsErrorCode {
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

// int PKCS5_PBKDF2_HMAC(const char *pass,
//                       int passlen,
//                       const unsigned char *salt,
//                       int saltlen,
//                       int iter,
//                       const EVP_MD *digest,
//                       int keylen,
//                       unsigned char *out);
class PKCS5_PBKDF2_HMAC extends KeyDerivationFunctionWithPasswordAndSalt, ReturnsErrorCode {
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

// int PKCS5_v2_PBE_keyivgen(EVP_CIPHER_CTX *ctx,
//                           const char *pass,
//                           int passlen,
//                           ASN1_TYPE *param,
//                           const EVP_CIPHER *cipher,
//                           const EVP_MD *md,
//                           int en_de);
class PKCS5_v2_PBE_keyivgen extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
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

// int PKCS5_v2_PBE_keyivgen_ex(EVP_CIPHER_CTX *ctx,
//                              const char *pass,
//                              int passlen,
//                              ASN1_TYPE *param,
//                              const EVP_CIPHER *cipher,
//                              const EVP_MD *md,
//                              int en_de,
//                              OSSL_LIB_CTX *libctx,
//                              const char *propq);
class PKCS5_v2_PBE_keyivgen_ex extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
  PKCS5_v2_PBE_keyivgen_ex() {
    this.getQualifiedName() = "PKCS5_v2_PBE_keyivgen_ex"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 6
  }
}

// int EVP_PBE_scrypt(const char *pass,
//                    size_t passlen,
//                    const unsigned char *salt,
//                    size_t saltlen,
//                    uint64_t N,
//                    uint64_t r,
//                    uint64_t p,
//                    uint64_t maxmem,
//                    unsigned char *key,
//                    size_t keylen);
class EVP_PBE_scrypt extends KeyDerivationFunctionWithPasswordAndSalt, ReturnsErrorCode {
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

// int EVP_PBE_scrypt_ex(const char *pass,
//                       size_t passlen,
//                       const unsigned char *salt,
//                       size_t saltlen,
//                       uint64_t N,
//                       uint64_t r,
//                       uint64_t p,
//                       uint64_t maxmem,
//                       unsigned char *key,
//                       size_t keylen,
//                       OSSL_LIB_CTX *ctx,
//                       const char *propq);
class EVP_PBE_scrypt_ex extends KeyDerivationFunctionWithPasswordAndSalt, ReturnsErrorCode {
  EVP_PBE_scrypt_ex() {
    this.getQualifiedName() = "EVP_PBE_scrypt"
  }

  override int getPassword() {
    result = 0
  }

  override int getSalt() {
    result = 2
  }
}

// int PKCS5_v2_scrypt_keyivgen(EVP_CIPHER_CTX *ctx,
//                              const char *pass,
//                              int passlen,
//                              ASN1_TYPE *param,
//                              const EVP_CIPHER *c,
//                              const EVP_MD *md,
//                              int en_de);
class PKCS5_v2_scrypt_keyivgen extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
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

// int PKCS5_v2_scrypt_keyivgen_ex(EVP_CIPHER_CTX *ctx,
//                                 const char *pass,
//                                 int passlen,
//                                 ASN1_TYPE *param,
//                                 const EVP_CIPHER *c,
//                                 const EVP_MD *md,
//                                 int en_de,
//                                 OSSL_LIB_CTX *ctx,
//                                 const char *propq);
class PKCS5_v2_scrypt_keyivgen_ex extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
  PKCS5_v2_scrypt_keyivgen_ex() {
    this.getQualifiedName() = "PKCS5_v2_scrypt_keyivgen"
  }

  override int getPassword() {
    result = 1
  }

  int getMode() {
    result = 6
  }
}

// int EVP_PBE_CipherInit(ASN1_OBJECT *pbe_obj,
//                        const char *pass,
//                        int passlen,
//                        ASN1_TYPE *param,
//                        EVP_CIPHER_CTX *ctx,
//                        int en_de);
class EVP_PBE_CipherInit extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
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

// int EVP_PBE_CipherInit_ex(ASN1_OBJECT *pbe_obj,
//                           const char *pass,
//                           int passlen,
//                           ASN1_TYPE *param,
//                           EVP_CIPHER_CTX *ctx,
//                           int en_de);
//                           OSSL_LIB_CTX *ctx,
//                           const char *propq);
class EVP_PBE_CipherInit_ex extends KeyDerivationFunctionWithPassword, ReturnsErrorCode {
  EVP_PBE_CipherInit_ex() {
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
    // AES variants.
    (this.getTarget().getName().matches("%EVP_aes_256_cbc%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_256_cfb%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_256_ctr%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_256_ecb%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_256_ofb%") and keySize = 32) or
    (this.getTarget().getName().matches("%EVP_aes_256_xts%") and keySize = 64) or
    (this.getTarget().getName().matches("%EVP_aes_192%") and keySize = 24) or
    (this.getTarget().getName().matches("%EVP_aes_128_cbc%") and keySize = 16) or
    (this.getTarget().getName().matches("%EVP_aes_128_cfb%") and keySize = 16) or
    (this.getTarget().getName().matches("%EVP_aes_128_ctr%") and keySize = 16) or
    (this.getTarget().getName().matches("%EVP_aes_128_ecb%") and keySize = 16) or
    (this.getTarget().getName().matches("%EVP_aes_128_ofb%") and keySize = 16) or
    (this.getTarget().getName().matches("%EVP_aes_128_xts%") and keySize = 32) or
    // Chacha20 variants.
    (this.getTarget().getName().matches("%EVP_chacha20%") and keySize = 32)
  }

  int getKeySize() {
      result = keySize
  }
}
