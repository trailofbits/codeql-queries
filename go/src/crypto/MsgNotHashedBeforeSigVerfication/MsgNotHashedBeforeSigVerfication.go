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