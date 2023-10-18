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
