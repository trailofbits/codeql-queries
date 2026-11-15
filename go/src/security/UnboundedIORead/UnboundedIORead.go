package main

import (
	"io"
	"net/http"
)

// BAD: unbounded read of request body
func badHandler(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body) // no size limit — OOM on large request
	w.Write(body)
}

// GOOD: limit body size before reading
func goodHandler(w http.ResponseWriter, r *http.Request) {
	r.Body = http.MaxBytesReader(w, r.Body, 1<<20) // 1 MB limit
	body, _ := io.ReadAll(r.Body)
	w.Write(body)
}
