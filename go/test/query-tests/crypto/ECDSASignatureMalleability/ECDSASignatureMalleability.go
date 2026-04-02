package main

import (
	"bytes"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"fmt"
)

// finding: signature used as hex-encoded identifier
func test_sig_as_hex_id(key *ecdsa.PrivateKey, msg []byte) string {
	hash := sha256.Sum256(msg)
	sig, _ := ecdsa.SignASN1(rand.Reader, key, hash[:])
	return hex.EncodeToString(sig)
}

// TODO: not yet detected — r.String() concatenation breaks dataflow from big.Int
func test_sig_as_map_key(key *ecdsa.PrivateKey, msg []byte) {
	hash := sha256.Sum256(msg)
	r, s, _ := ecdsa.Sign(rand.Reader, key, hash[:])
	seen := make(map[string]bool)
	sigKey := r.String() + ":" + s.String()
	seen[sigKey] = true
}

// finding: signature compared with bytes.Equal (replay check)
func test_sig_bytes_equal(key *ecdsa.PrivateKey, msg []byte, prevSig []byte) bool {
	hash := sha256.Sum256(msg)
	sig, _ := ecdsa.SignASN1(rand.Reader, key, hash[:])
	return bytes.Equal(sig, prevSig)
}

// TODO: not yet detected — variadic argument matching needs refinement
func test_sig_in_db(db *sql.DB, key *ecdsa.PrivateKey, msg []byte) {
	hash := sha256.Sum256(msg)
	sig, _ := ecdsa.SignASN1(rand.Reader, key, hash[:])
	db.Exec("INSERT INTO sigs (sig) VALUES (?)", sig)
}

// finding: PrivateKey.Sign method result used as identifier
func test_method_sign_hex(key *ecdsa.PrivateKey, msg []byte) string {
	hash := sha256.Sum256(msg)
	sig, _ := key.Sign(rand.Reader, hash[:], nil)
	return hex.EncodeToString(sig)
}

/*
 * False positives that should NOT be flagged
 */

// ok: signature verified but not used as identifier
func test_fp_verify_only(key *ecdsa.PrivateKey, msg []byte) bool {
	hash := sha256.Sum256(msg)
	sig, _ := ecdsa.SignASN1(rand.Reader, key, hash[:])
	return ecdsa.VerifyASN1(&key.PublicKey, hash[:], sig)
}

// ok: message hash used as identifier (not signature)
func test_fp_hash_as_id(msg []byte) string {
	hash := sha256.Sum256(msg)
	return hex.EncodeToString(hash[:])
}

func main() {
	key, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	msg := []byte("test message")
	fmt.Println(test_sig_as_hex_id(key, msg))
	test_sig_as_map_key(key, msg)
	fmt.Println(test_sig_bytes_equal(key, msg, nil))
	test_sig_in_db(nil, key, msg)
	fmt.Println(test_method_sign_hex(key, msg))
	fmt.Println(test_fp_verify_only(key, msg))
	fmt.Println(test_fp_hash_as_id(msg))
}
