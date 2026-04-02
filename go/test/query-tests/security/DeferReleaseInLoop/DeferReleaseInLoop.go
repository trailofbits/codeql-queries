package main

import (
	"compress/gzip"
	"fmt"
	"net"
	"net/http"
	"os"
	"sync"
)

// finding: defer os.File.Close in range loop
func test_file_range_close(paths []string) {
	for _, path := range paths {
		f, err := os.Open(path)
		if err != nil {
			continue
		}
		defer f.Close()
		fmt.Println(f.Name())
	}
}

// finding: defer os.File.Close in for loop (via os.Create)
func test_file_for_close() {
	for i := 0; i < 100; i++ {
		f, err := os.Create(fmt.Sprintf("/tmp/file%d", i))
		if err != nil {
			continue
		}
		defer f.Close()
		fmt.Println(f.Name())
	}
}

// finding: defer resp.Body.Close() in loop (io.ReadCloser)
func test_http_body(urls []string) {
	for _, url := range urls {
		resp, err := http.Get(url)
		if err != nil {
			continue
		}
		defer resp.Body.Close()
		fmt.Println(resp.Status)
	}
}

// finding: defer net.Conn.Close in loop
func test_net_dial(addrs []string) {
	for _, addr := range addrs {
		conn, err := net.Dial("tcp", addr)
		if err != nil {
			continue
		}
		defer conn.Close()
		fmt.Fprintln(conn, "hello")
	}
}

// finding: defer net.Listener.Close in loop
func test_net_listen(ports []string) {
	for _, port := range ports {
		ln, err := net.Listen("tcp", ":"+port)
		if err != nil {
			continue
		}
		defer ln.Close()
		_ = ln
	}
}

// finding: defer gzip.Reader.Close in loop
func test_gzip_close(paths []string) {
	for _, path := range paths {
		f, err := os.Open(path)
		if err != nil {
			continue
		}
		gz, err := gzip.NewReader(f)
		if err != nil {
			f.Close()
			continue
		}
		defer gz.Close()
		defer f.Close()
		_ = gz
	}
}

// finding: defer os.File.Close in nested loop
func test_nested_loop(paths []string) {
	for i := 0; i < 3; i++ {
		for _, path := range paths {
			f, err := os.Open(path)
			if err != nil {
				continue
			}
			defer f.Close()
			fmt.Println(f.Name())
		}
	}
}

/*
 * False positives that should NOT be flagged
 */

// ok: defer Close in closure inside loop — runs per iteration
func test_fp_closure(paths []string) {
	for _, path := range paths {
		func() {
			f, err := os.Open(path)
			if err != nil {
				return
			}
			defer f.Close()
			fmt.Println(f.Name())
		}()
	}
}

// ok: defer Close outside any loop
func test_fp_no_loop() {
	f, err := os.Open("/tmp/test")
	if err != nil {
		return
	}
	defer f.Close()
	fmt.Println(f.Name())
}

// ok: defer of non-resource call in loop (fmt.Println is not a release)
func test_fp_arbitrary_defer(items []string) {
	for _, item := range items {
		defer fmt.Println(item)
	}
}

// ok: defer Unlock in loop (sync.Mutex is not file/IO/socket)
func test_fp_mutex(items []string) {
	var mu sync.Mutex
	for _, item := range items {
		mu.Lock()
		defer mu.Unlock()
		fmt.Println(item)
	}
}

func main() {
	test_file_range_close(os.Args[1:])
	test_file_for_close()
	test_http_body(os.Args[1:])
	test_net_dial(os.Args[1:])
	test_net_listen(os.Args[1:])
	test_gzip_close(os.Args[1:])
	test_nested_loop(os.Args[1:])
	test_fp_closure(os.Args[1:])
	test_fp_no_loop()
	test_fp_arbitrary_defer(os.Args[1:])
	test_fp_mutex(os.Args[1:])
}
