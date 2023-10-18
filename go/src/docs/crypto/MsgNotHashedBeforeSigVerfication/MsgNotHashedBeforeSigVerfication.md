# Message not hashed before signature verification
ECDSA, DSA and some other cryptographic methods expect data for signing and verification to be pre-hashed. If the data is longer than the expected hash digest size, the data is silently truncated. This query finds flows into such methods, but only flows that are not sanitized by calls to hash functions or by slicing operations.


## Recommendation
Hash data before using it in the signature verification/creation method. If the data is known to be hashed then ignore the finding.


## Example

```go
package main

import (
    "crypto/ecdsa"
    "crypto/elliptic"
    "crypto/rand"
    "fmt"
    "os"
)

func main() {
    privateKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
    if err != nil { panic(err) }

    data, err := os.ReadFile("/etc/passwd")
    if err != nil { panic(err) }

    sig, err := ecdsa.SignASN1(rand.Reader, privateKey, data)
    if err != nil { panic(err) }
    fmt.Printf("signature: %x\n", sig)

    valid := ecdsa.VerifyASN1(&privateKey.PublicKey, data, sig)
    fmt.Println("signature verified:", valid)
}
```
In this example, we read content of the `/etc/passwd` file, sign the content and verify the signature. Because the content is not hashed before signing/verification, only the first 32 bytes of the file are actually signed.

