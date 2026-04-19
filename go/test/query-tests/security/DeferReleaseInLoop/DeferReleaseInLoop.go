package main

import (
	"archive/zip"
	"compress/gzip"
	"compress/zlib"
	"fmt"
	"net"
	"net/http"
	"os"
	"strings"
	"sync"
)

// finding: os.Open in range loop
func test_os_open(paths []string) {
	for _, path := range paths {
		f, err := os.Open(path)
		if err != nil {
			continue
		}
		defer f.Close()
		fmt.Println(f.Name())
	}
}

// finding: os.Create in for loop
func test_os_create() {
	for i := 0; i < 100; i++ {
		f, err := os.Create(fmt.Sprintf("/tmp/file%d", i))
		if err != nil {
			continue
		}
		defer f.Close()
		fmt.Println(f.Name())
	}
}

// finding: os.OpenFile
func test_os_openfile(paths []string) {
	for _, path := range paths {
		f, err := os.OpenFile(path, os.O_RDONLY, 0)
		if err != nil {
			continue
		}
		defer f.Close()
		_ = f
	}
}

// finding: os.CreateTemp
func test_os_createtemp(n int) {
	for i := 0; i < n; i++ {
		f, err := os.CreateTemp("", "prefix")
		if err != nil {
			continue
		}
		defer f.Close()
		_ = f
	}
}

// finding: http.Get — resp.Body.Close()
func test_http_get(urls []string) {
	for _, url := range urls {
		resp, err := http.Get(url)
		if err != nil {
			continue
		}
		defer resp.Body.Close()
		fmt.Println(resp.Status)
	}
}

// finding: http.Client.Do — resp.Body.Close()
func test_http_client_do(client *http.Client, urls []string) {
	for _, url := range urls {
		req, _ := http.NewRequest("GET", url, nil)
		resp, err := client.Do(req)
		if err != nil {
			continue
		}
		defer resp.Body.Close()
		fmt.Println(resp.Status)
	}
}

// finding: net.Dial
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

// finding: net.Listen
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

// finding: gzip.NewReader
func test_gzip_reader(paths []string) {
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

// finding: zlib.NewReader
func test_zlib_reader(paths []string) {
	for _, path := range paths {
		f, err := os.Open(path)
		if err != nil {
			continue
		}
		zr, err := zlib.NewReader(f)
		if err != nil {
			f.Close()
			continue
		}
		defer zr.Close()
		defer f.Close()
		_ = zr
	}
}

// finding: zip.OpenReader
func test_zip_openreader(paths []string) {
	for _, path := range paths {
		zr, err := zip.OpenReader(path)
		if err != nil {
			continue
		}
		defer zr.Close()
		_ = zr
	}
}

// finding: nested loop — inner os.Open
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

// ok: non-resource defer in loop
func test_fp_arbitrary_defer(items []string) {
	for _, item := range items {
		defer fmt.Println(item)
	}
}

// ok: sync.Mutex — not a file/IO resource
func test_fp_mutex(items []string) {
	var mu sync.Mutex
	for _, item := range items {
		mu.Lock()
		defer mu.Unlock()
		fmt.Println(item)
	}
}

// ok: Close on a resource NOT from FileResourceAcquisition
func test_fp_strings_reader() {
	for i := 0; i < 10; i++ {
		r := strings.NewReader("hello")
		_ = r // strings.Reader has no Close, but even if it did, not modeled
	}
}

// ok: resource acquired outside loop, defer inside is still scoped to function
func test_fp_acquired_outside_loop(path string) {
	f, err := os.Open(path)
	if err != nil {
		return
	}
	defer f.Close() // not in a loop
	for i := 0; i < 10; i++ {
		fmt.Fprintln(f, i)
	}
}

func main() {
	test_os_open(os.Args[1:])
	test_os_create()
	test_os_openfile(os.Args[1:])
	test_os_createtemp(3)
	test_http_get(os.Args[1:])
	test_http_client_do(http.DefaultClient, os.Args[1:])
	test_net_dial(os.Args[1:])
	test_net_listen(os.Args[1:])
	test_gzip_reader(os.Args[1:])
	test_zlib_reader(os.Args[1:])
	test_zip_openreader(os.Args[1:])
	test_nested_loop(os.Args[1:])
	test_fp_closure(os.Args[1:])
	test_fp_no_loop()
	test_fp_arbitrary_defer(os.Args[1:])
	test_fp_mutex(os.Args[1:])
	test_fp_strings_reader()
	test_fp_acquired_outside_loop("/tmp/test")
}
