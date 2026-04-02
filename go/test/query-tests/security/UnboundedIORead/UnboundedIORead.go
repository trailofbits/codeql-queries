package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
)

// finding: io.ReadAll on raw request body
func test_readall_raw(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	w.Write(body)
}

// finding: ioutil.ReadAll on raw request body (deprecated but common)
func test_ioutil_readall_raw(w http.ResponseWriter, r *http.Request) {
	body, _ := ioutil.ReadAll(r.Body)
	w.Write(body)
}

// finding: body passed through variable
func test_readall_via_var(w http.ResponseWriter, r *http.Request) {
	reader := r.Body
	body, _ := io.ReadAll(reader)
	w.Write(body)
}

/*
 * False positives that should NOT be flagged
 */

// ok: body wrapped with MaxBytesReader
func test_fp_maxbytes(w http.ResponseWriter, r *http.Request) {
	r.Body = http.MaxBytesReader(w, r.Body, 1<<20)
	body, _ := io.ReadAll(r.Body)
	w.Write(body)
}

// ok: body wrapped with LimitReader
func test_fp_limitreader(w http.ResponseWriter, r *http.Request) {
	limited := io.LimitReader(r.Body, 1<<20)
	body, _ := io.ReadAll(limited)
	w.Write(body)
}

// ok: reading from a non-HTTP source
func test_fp_non_http() {
	resp, _ := http.Get("http://example.com")
	body, _ := io.ReadAll(resp.Body)
	fmt.Println(string(body))
}

func main() {
	http.HandleFunc("/raw", test_readall_raw)
	http.HandleFunc("/ioutil", test_ioutil_readall_raw)
	http.HandleFunc("/var", test_readall_via_var)
	http.HandleFunc("/maxbytes", test_fp_maxbytes)
	http.HandleFunc("/limit", test_fp_limitreader)
	test_fp_non_http()
}
