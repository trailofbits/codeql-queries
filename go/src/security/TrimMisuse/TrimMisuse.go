// Run with: go run ./TrimMisuse.go dGFzazE6bm9ybWFsIGVhdDpzbGVlcDpyZXBlYXQ6YnVkZ2U6ZHVkZTpkZWJ1Zw==
package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"strings"
)

func processJob(idx int, job string) {
	fmt.Printf("Doing job {%d} - {%s}\n", idx, job)
}

func main() {
	if len(os.Args) < 2 {
		return
	}

	// jobs list in form of task1:task2:taskN
	jobs, err := base64.StdEncoding.DecodeString(os.Args[1])
	if err != nil {
		return
	}

	// disable debugging
	sanitizedJobs := strings.TrimRight(string(jobs), ":debug")

	for i, job := range strings.Split(sanitizedJobs, ":") {
		processJob(i, job)
	}
}
