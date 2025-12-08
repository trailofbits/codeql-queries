package main

import (
	"crypto/tls"
	"net/http"
	"os"
)

func setVersion(c *tls.Config, x bool) {
	if x {
		c.MinVersion = tls.VersionTLS10
	}
}

func dontSetVersion(c *tls.Config) {
	c.MaxVersion = tls.VersionTLS12
}

func makeAlias(c *tls.Config) *tls.Config {
	return c
}

func minTlsVersion() {
	{
		config := &tls.Config{} // BAD: no min version set
		_ = config
	}
	{
		config := &tls.Config{
			MinVersion: tls.VersionSSL30, // GOOD: min version is set
		}
		_ = config
	}
	{
		config := &tls.Config{
			MaxVersion: tls.VersionTLS10, // BAD: only max version is set
		}
		_ = config
	}
	{
		config := &tls.Config{}
		config.MinVersion = 0 // GOOD: min version is set
		_ = config
	}
	{
		config := tls.Config{}
		setVersion(&config, true) // GOOD: min version is set
	}
	{
		config := tls.Config{}
		setVersion(&config, false) // BAD: min version will not be set
	}
	{
		x := os.Getuid() > 0
		config := tls.Config{}
		setVersion(&config, x) // GOOD: min version may be set
		// TODO: we can mark this as BAD if there is conditional setting and
		// variable name doesnt indicate debug flag or explicitely insecure flag
	}
	{
		config := tls.Config{}
		dontSetVersion(&config) // BAD: only max version set
	}
	{
		x := os.Getuid() > 0
		config := tls.Config{}
		config2 := makeAlias(&config)
		config3 := &config2
		setVersion(*config3, x) // GOOD: min version may be set
	}
	{
		config := tls.Config{}
		config2 := makeAlias(&config)
		config3 := &config2
		config4 := (*config3).Clone()
		var config5 *tls.Config = (*config3).Clone()
		var config6 *tls.Config = (*config3).Clone()
		setVersion(*config3, true)
		dontSetVersion(config4)   // TODO BAD: min version not set for cloned config
		dontSetVersion(config5)   // TODO BAD: min version not set for cloned config
		setVersion(config6, true) // GOOD: min version set
	}
}

type Configs struct {
	Something string
	tconf     tls.Config
}

func (c *Configs) Init() {
	c.tconf = tls.Config{} // GOOD: catch only if really used, so calls to that function
}

func (c *Configs) Init2() {
	// GOOD: proper initialization with min version
	c.tconf = tls.Config{
		MinVersion: tls.VersionTLS12,
	}
}

func (c *Configs) Init3() {
	// GOOD: catch only if really used, so calls to that function
	c.tconf = tls.Config{
		MaxVersion: tls.VersionTLS12,
	}
}

func main() {
	{
		c := Configs{} // BAD
		c.Init()
	}
	{
		c := Configs{}
		c.Init2() // GOOD
	}
	{
		c := Configs{} // BAD
		c.Init3()
	}
	{
		c := Configs{tconf: tls.Config{MinVersion: tls.VersionTLS10}} // GOOD
		_ = &c
	}
	{
		c := Configs{tconf: tls.Config{MaxVersion: tls.VersionTLS10}} // Bad
		_ = &c
	}
	{
		tmp := tls.Config{MinVersion: tls.VersionTLS10}
		c := Configs{tconf: tmp} // GOOD
		_ = &c
	}
	{
		tmp := tls.Config{MaxVersion: tls.VersionTLS10} // TODO: exclude such temporary variables maybe
		c := Configs{tconf: tmp}                        // Bad
		_ = &c
	}
	{
		// GOOD: conditionally correct initialization
		// TODO: maybe we should mark this as BAD, if the condition is not of "debug" or explicitly "insecure" type
		c := Configs{tconf: tls.Config{MaxVersion: tls.VersionTLS10}}
		if os.Getuid() > 0 {
			c.Init2()
		}
	}
	{
		// BAD
		c := Configs{tconf: tls.Config{MaxVersion: tls.VersionTLS10}}
		if os.Getuid() > 0 {
			c.Init3()
		}
	}
	// BAD for Go < 1.18: config used for a client (clients default to TLS 1.0)
	// OK for Go >= 1.18: clients default to TLS 1.2
	{
		client := &http.Client{
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{
					MaxVersion: tls.VersionTLS13,
				},
			},
		}
		client.Get("")
	}
	// BAD: config used for server
	{
		srv := &http.Server{
			TLSConfig: &tls.Config{MaxVersion: tls.VersionTLS13},
		}
		srv2 := &http.Server{
			TLSConfig: &tls.Config{MaxVersion: tls.VersionTLS13},
		}
		srv.ListenAndServeTLS("", "")
		srv2.ListenAndServeTLS("", "")

		c := &tls.Config{MaxVersion: tls.VersionTLS13}
		client := &http.Client{
			Transport: &http.Transport{
				TLSClientConfig: c,
			},
		}
		srv3 := &http.Server{TLSConfig: c}

		srv3.ListenAndServeTLS("", "")
		client.Get("")
	}
}
