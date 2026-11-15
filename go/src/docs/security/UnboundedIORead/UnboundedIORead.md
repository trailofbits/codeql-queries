# Unbounded read of request body
Reading an HTTP request body with `io.ReadAll` (or the deprecated `ioutil.ReadAll`) allocates the entire body into memory with no upper bound. A malicious client can send an arbitrarily large request body to exhaust server memory, causing a denial-of-service condition.


## Recommendation
Wrap the request body with a size-limiting reader before reading it:


```go
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

```
Prefer `http.MaxBytesReader` which also sets the appropriate error on the response, or `io.LimitReader` for non-HTTP contexts.


## References
* [http.MaxBytesReader documentation](https://pkg.go.dev/net/http#MaxBytesReader)
* [io.LimitReader documentation](https://pkg.go.dev/io#LimitReader)
