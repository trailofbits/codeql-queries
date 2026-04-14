# Invalid key size

The `EVP_EncryptInit` and `EVP_EncryptInit_ex` functions do not take the size
of the key as input, and the implementation will simply read the expected number
of bytes from the buffer. This query will check if the size of the key buffer
passed as an argument to one of these functions is equal to the key size of the
corresponding cipher.

The following code snippet is an example of an issue that would be identified by
the query.

```cpp
unsigned char key[16];  // This should be 32 for a 256 bit key
RAND_bytes(key, sizeof(key));

unsigned char *iv = (unsigned char *)"0123456789ABCDEF";  // A fixed 16 byte IV

EVP_EncryptInit_ex(EVP_CIPHER_CTX_new(), EVP_aes_256_cbc(), NULL, key, iv);
```