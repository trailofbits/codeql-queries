# Missing MinVersion in tls.Config
Golang's `tls.Config` struct accepts a `MinVersion` parameter that sets the minimum accepted TLS version. If the parameter is not provided, the default depends on the Go version in use. Since Go 1.18, `crypto/tls` clients default to TLS 1.2 (previously TLS 1.0). Since Go 1.22, `crypto/tls` servers also default to TLS 1.2 (previously TLS 1.0).

This query flags `tls.Config` values where `MinVersion` is never set explicitly and the project's `go.mod` declares support for a Go version where the defaults are insecure:

* Go &lt; 1.18 for client-side configs (when client default is TLS 1.0)
* Go &lt; 1.22 for server-side configs (when server default is TLS 1.0)
TLS 1.0 and 1.1 are deprecated and should not be used.


## Recommendation
Explicitly set the TLS version to TLS 1.2 or higher:

* For projects using Go &lt; 1.18: Set `MinVersion` for both clients and servers
* For projects using Go 1.18-1.21: Set `MinVersion` for servers
* For projects using Go &gt;= 1.22: Defaults are secure, but explicit setting is still recommended

## Example

```go
package main

import (
	"crypto/tls"
	"net/http"
	"os"
	"time"
)

func test1() *tls.Config {
	config := &tls.Config{
		MaxVersion: tls.VersionTLS10, // BAD: only max version is set
	}
	result := config
	return result
}

func test2() *tls.Config {
	config := &tls.Config{}
	config.MinVersion = 0 // GOOD: min version is set (however, to the default one)
	result := config
	return result
}

func main() {
	var cfg *tls.Config

	if len(os.Args) == 1 {
		cfg = test1()
	} else {
		cfg = test2()
	}
	srv := &http.Server{
		TLSConfig:    cfg,
		ReadTimeout:  time.Minute,
		WriteTimeout: time.Minute,
	}
	srv.ListenAndServeTLS("", "")
}

```
In this example, the `http.Server` may be set with TLS configuration created by either `test1` or `test2` functions. For projects with a `go` directive &lt; 1.22, the `test1` result will be highlighted by this query, as it fails to explicitly set minimum supported TLS version. The `test2` result will not be marked, even though it also uses the default value for minimum version. That is because the `test2` is explicit, and this query assumes that developers knew what they are doing.

Note: The query behavior depends on the `go` directive in `go.mod`:

* Go &lt; 1.18: Both client and server configs without MinVersion are flagged
* Go 1.18-1.21: Only server configs without MinVersion are flagged
* Go &gt;= 1.22: No configs are flagged (both defaults are secure)

## References
* [tls.Config specification](https://pkg.go.dev/crypto/tls#Config)
* [Go 1.18 Release Notes - TLS 1.0 and 1.1 disabled by default client-side](https://tip.golang.org/doc/go1.18#tls10)
* [Go 1.22 Release Notes - TLS 1.2 default for servers](https://tip.golang.org/doc/go1.22#minor_library_changes)
