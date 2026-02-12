import cpp
private import hash

// This file contains CodeQL models for the OpenSSL SHA functions defined in
// openssl/sha.h.
// int SHA1_Init(SHA_CTX *c);
class SHA1_Init extends Hash::Init, ReturnsErrorCode {
  SHA1_Init() { this.getQualifiedName() = "SHA1_Init" }
}

// int SHA1_Update(SHA_CTX *c, const void *data, size_t len);
class SHA1_Update extends Hash::Update, ReturnsErrorCode {
  SHA1_Update() { this.getQualifiedName() = "SHA1_Update" }
}

// int SHA1_Final(unsigned char *md, SHA_CTX *c);
class SHA1_Final extends Hash::Final, ReturnsErrorCode {
  SHA1_Final() { this.getQualifiedName() = "SHA1_Final" }
}

// unsigned char *SHA1(const unsigned char *d, size_t n, unsigned char *md);
class SHA1 extends Hash::Digest {
  SHA1() { this.getQualifiedName() = "SHA1" }
}

// int SHA224_Init(SHA_CTX *c);
class SHA224_Init extends Hash::Init, ReturnsErrorCode {
  SHA224_Init() { this.getQualifiedName() = "SHA224_Init" }
}

// int SHA224_Update(SHA_CTX *c, const void *data, size_t len);
class SHA224_Update extends Hash::Update, ReturnsErrorCode {
  SHA224_Update() { this.getQualifiedName() = "SHA224_Update" }
}

// int SHA224_Final(unsigned char *md, SHA_CTX *c);
class SHA224_Final extends Hash::Final, ReturnsErrorCode {
  SHA224_Final() { this.getQualifiedName() = "SHA224_Final" }
}

// unsigned char *SHA224(const unsigned char *d, size_t n, unsigned char *md);
class SHA224 extends Hash::Digest {
  SHA224() { this.getQualifiedName() = "SHA224" }
}

// int SHA256_Init(SHA_CTX *c);
class SHA256_Init extends Hash::Init, ReturnsErrorCode {
  SHA256_Init() { this.getQualifiedName() = "SHA256_Init" }
}

// int SHA256_Update(SHA_CTX *c, const void *data, size_t len);
class SHA256_Update extends Hash::Update, ReturnsErrorCode {
  SHA256_Update() { this.getQualifiedName() = "SHA256_Update" }
}

// int SHA256_Final(unsigned char *md, SHA_CTX *c);
class SHA256_Final extends Hash::Final, ReturnsErrorCode {
  SHA256_Final() { this.getQualifiedName() = "SHA256_Final" }
}

// unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md);
class SHA256 extends Hash::Digest {
  SHA256() { this.getQualifiedName() = "SHA256" }
}

// int SHA384_Init(SHA_CTX *c);
class SHA384_Init extends Hash::Init, ReturnsErrorCode {
  SHA384_Init() { this.getQualifiedName() = "SHA384_Init" }
}

// int SHA384_Update(SHA_CTX *c, const void *data, size_t len);
class SHA384_Update extends Hash::Update, ReturnsErrorCode {
  SHA384_Update() { this.getQualifiedName() = "SHA384_Update" }
}

// int SHA384_Final(unsigned char *md, SHA_CTX *c);
class SHA384_Final extends Hash::Final, ReturnsErrorCode {
  SHA384_Final() { this.getQualifiedName() = "SHA384_Final" }
}

// unsigned char *SHA384(const unsigned char *d, size_t n, unsigned char *md);
class SHA384 extends Hash::Digest {
  SHA384() { this.getQualifiedName() = "SHA384" }
}

// int SHA512_Init(SHA_CTX *c);
class SHA512_Init extends Hash::Init, ReturnsErrorCode {
  SHA512_Init() { this.getQualifiedName() = "SHA512_Init" }
}

// int SHA512_Update(SHA_CTX *c, const void *data, size_t len);
class SHA512_Update extends Hash::Update, ReturnsErrorCode {
  SHA512_Update() { this.getQualifiedName() = "SHA512_Update" }
}

// int SHA512_Final(unsigned char *md, SHA_CTX *c);
class SHA512_Final extends Hash::Final, ReturnsErrorCode {
  SHA512_Final() { this.getQualifiedName() = "SHA512_Final" }
}

// unsigned char *SHA512(const unsigned char *d, size_t n, unsigned char *md);
class SHA512 extends Hash::Digest {
  SHA512() { this.getQualifiedName() = "SHA512" }
}
