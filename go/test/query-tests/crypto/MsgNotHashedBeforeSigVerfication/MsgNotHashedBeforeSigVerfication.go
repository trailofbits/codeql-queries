package main

import (
	"crypto/dsa"
	"crypto/ecdsa"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"math/big"

	"github.com/btcsuite/btcd/btcec"
	dcrd "github.com/decred/dcrd/dcrec/secp256k1"
	"github.com/umbracle/ethgo/wallet"
	"golang.org/x/crypto/sha3"
)

func Keccak256(v ...[]byte) []byte {
	h := sha3.NewLegacyKeccak256()
	for _, i := range v {
		h.Write(i)
	}

	return h.Sum(nil)
}

var longMsg string

func init() {
	longMsg = "cafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabecafebabe"
}

func bad1(key *wallet.Key) error {
	raw, err := hex.DecodeString(longMsg)
	if err != nil {
		return fmt.Errorf("cannot decode message: %w", err)
	}

	signature, err := key.Sign(raw) // missing hashing, uses btcsuite/btcd/btcec internally
	if err != nil {
		return fmt.Errorf("cannot create message signature: %w", err)
	}

	fmt.Println(signature)
	return nil
}

func bad2(key *wallet.Key) error {
	pubKeyBytes, err := hex.DecodeString("02a673638cb9587cb68ea08dbef685c" +
		"6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5")
	if err != nil {
		return err
	}
	pubKey, err := btcec.ParsePubKey(pubKeyBytes, btcec.S256())
	if err != nil {
		return err
	}

	sigBytes, err := hex.DecodeString("30450220090ebfb3690a0ff115bb1b38b" +
		"8b323a667b7653454f1bccb06d4bbdca42c2079022100ec95778b51e707" +
		"1cb1205f8bde9af6592fc978b0452dafe599481c46d6b2e479")
	if err != nil {
		return err
	}
	signature, err := btcec.ParseSignature(sigBytes, btcec.S256())
	if err != nil {
		return err
	}

	msg := "test message"
	verified := signature.Verify([]byte(msg), pubKey) // missing hash
	if !verified {
		return fmt.Errorf("verification error %t", verified)
	}
	return nil
}

func bad3() error {
	ok := ecdsa.Verify(nil, []byte("test message"), big.NewInt(0), big.NewInt(0)) // not hashed before sign
	if !ok {
		return fmt.Errorf("cannot verify message signature")
	}
	return nil
}

func bad4() error {
	ok := dsa.Verify(nil, []byte("test message"), big.NewInt(0), big.NewInt(0)) // not hashed before sign
	if !ok {
		return fmt.Errorf("cannot verify message signature")
	}
	return nil
}

func bad5() error {
	pubKeyBytes, err := hex.DecodeString("02a673638cb9587cb68ea08dbef685c" +
		"6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5")
	if err != nil {
		return err
	}
	pubKey, err := dcrd.ParsePubKey(pubKeyBytes)
	if err != nil {
		return err
	}

	sigBytes, err := hex.DecodeString("30450220090ebfb3690a0ff115bb1b38b" +
		"8b323a667b7653454f1bccb06d4bbdca42c2079022100ec95778b51e707" +
		"1cb1205f8bde9af6592fc978b0452dafe599481c46d6b2e479")
	if err != nil {
		return err
	}
	signature, err := dcrd.ParseSignature(sigBytes)
	if err != nil {
		return err
	}

	msg := "test message"
	verified := signature.Verify([]byte(msg), pubKey) // missing hash
	if !verified {
		return fmt.Errorf("verification error %t", verified)
	}
	return nil
}

func ok1(key *wallet.Key) error {
	msg := "test"
	msgHash := Keccak256([]byte(msg))
	signature, err := key.Sign(msgHash) // hashed before sign
	if err != nil {
		return fmt.Errorf("cannot create message signature: %w", err)
	}

	fmt.Println(signature)
	return nil
}

func ok2(key *wallet.Key) error {
	msg := "test"
	signature, err := key.SignMsg([]byte(msg)) // hashed internally before sign
	if err != nil {
		return fmt.Errorf("cannot create message signature: %w", err)
	}

	fmt.Println(signature)
	return nil
}

func ok3() error {
	pubKeyBytes, err := hex.DecodeString("02a673638cb9587cb68ea08dbef685c" +
		"6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5")
	if err != nil {
		return err
	}
	pubKey, err := btcec.ParsePubKey(pubKeyBytes, btcec.S256())
	if err != nil {
		return err
	}

	sigBytes, err := hex.DecodeString("30450220090ebfb3690a0ff115bb1b38b" +
		"8b323a667b7653454f1bccb06d4bbdca42c2079022100ec95778b51e707" +
		"1cb1205f8bde9af6592fc978b0452dafe599481c46d6b2e479")
	if err != nil {
		return err
	}
	signature, err := btcec.ParseSignature(sigBytes, btcec.S256())
	if err != nil {
		return err
	}

	msg := "test message"
	msgHash := Keccak256([]byte(msg))
	verified := signature.Verify(msgHash, pubKey) // ok
	if !verified {
		return fmt.Errorf("verification error %t", verified)
	}
	return nil
}

func ok4(key *wallet.Key) error {
	h := sha256.New()
	h.Write([]byte("test message"))
	sum := h.Sum(nil)
	signature, err := key.Sign(sum) // hashed before sign
	if err != nil {
		return fmt.Errorf("cannot create message signature: %w", err)
	}

	fmt.Println(signature)
	return nil
}

func ok5() error {
	h := sha256.New()
	ok := ecdsa.Verify(nil, h.Sum([]byte("test message")), big.NewInt(0), big.NewInt(0)) // hashed before sign
	if !ok {
		return fmt.Errorf("cannot verify message signature")
	}
	return nil
}

func ok6() error {
	h := sha256.New()
	ok := dsa.Verify(nil, h.Sum([]byte("test message")), big.NewInt(0), big.NewInt(0)) // hashed before sign
	if !ok {
		return fmt.Errorf("cannot verify message signature")
	}
	return nil
}

func ok7() error {
	pubKeyBytes, err := hex.DecodeString("02a673638cb9587cb68ea08dbef685c" +
		"6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5")
	if err != nil {
		return err
	}
	pubKey, err := dcrd.ParsePubKey(pubKeyBytes)
	if err != nil {
		return err
	}

	sigBytes, err := hex.DecodeString("30450220090ebfb3690a0ff115bb1b38b" +
		"8b323a667b7653454f1bccb06d4bbdca42c2079022100ec95778b51e707" +
		"1cb1205f8bde9af6592fc978b0452dafe599481c46d6b2e479")
	if err != nil {
		return err
	}
	signature, err := dcrd.ParseSignature(sigBytes)
	if err != nil {
		return err
	}

	h := sha256.New()
	msg := "test message"
	verified := signature.Verify(h.Sum([]byte(msg)), pubKey)
	if !verified {
		return fmt.Errorf("verification error %t", verified)
	}
	return nil
}

func main() {
	key, err := wallet.GenerateKey()
	if err != nil {
		panic("Cannot generate key")
	}

	if err := bad1(key); err != nil {
		fmt.Println(err)
	}
	if err := bad2(key); err != nil {
		fmt.Println(err)
	}
	if err := bad3(); err != nil {
		fmt.Println(err)
	}
	if err := bad4(); err != nil {
		fmt.Println(err)
	}
	if err := bad5(); err != nil {
		fmt.Println(err)
	}

	if err := ok1(key); err != nil {
		fmt.Println(err)
	}
	if err := ok2(key); err != nil {
		fmt.Println(err)
	}
	if err := ok3(); err != nil {
		fmt.Println(err)
	}
	if err := ok4(key); err != nil {
		fmt.Println(err)
	}
	if err := ok5(); err != nil {
		fmt.Println(err)
	}
	if err := ok6(); err != nil {
		fmt.Println(err)
	}
	if err := ok7(); err != nil {
		fmt.Println(err)
	}
}
