# Trim functions misuse
`strings.Trim`, `strings.TrimLeft`, `strings.TrimRight`, and corresponding `bytes.*` methods remove \*all\* provided Unicode code points from the beginning and/or end of a string. They do not remove whole suffix and/or prefix, as may be incorrectly assumed. Such task can be accomplished by `strings.TrimPrefix` and `strings.TrimSuffix` methods. For example, `strings.Trim("abbaXXXaaaab", "ab") == "XXX"` and not `"baXXXaaa"`. This query finds calls to the buggy Trim methods with second argument of length greater than 1. This is a simple heuristic that is meant to assist with manual code review.


## Recommendation
Review results and ensure that the correct Trimming methods are used.


## Example

```go
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

```
In this example, instead of removing `:debug` suffix (a "debug" task) from the `jobs` string, we remove all tasks composed from letters "d", "e", "b", "g", "u" until a task with any other letter is found.


## References
* [strings.TrimRight specification](https://pkg.go.dev/strings#TrimRight)
