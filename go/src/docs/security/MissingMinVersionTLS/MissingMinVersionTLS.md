# Missing MinVersion in tls.Config
Golang's `tls.Config` struct accepts `MinVersion` parameter that sets minimum accepted TLS version. If the parameter is not provided, default value is used: TLS1.2 for clients, and TLS1.0 for servers. TLS1.0 is considered deprecated and should not be used.


## Recommendation
Explicitly set tls version to an up-to-date one.


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
	config.MinVersion = 0 // GOOD: min version is set (hovewer, to the default one)
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
In this example, the `http.Server` may be set with TLS configuration created by either `test1` or `test2` functions. The `test1` result will be highlighted by this query, as it fails to explicitly set minimum supported TLS version. The `test2` result will not be marked, even that it also uses the default value for minimum version. That is because the `test2` is explicit, and this query assumes that developers knew what they are doing.


## References
* [tls.Config specification](https://pkg.go.dev/crypto/tls#Config)
