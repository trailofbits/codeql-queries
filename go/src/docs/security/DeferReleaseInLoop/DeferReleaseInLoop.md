# Deferred resource release in loop
In Go, `defer` schedules a function call to run when the *enclosing function* returns — not when the enclosing block or loop iteration ends. Deferring a resource release call (such as `Close`, `Unlock`, or `Rollback`) inside a loop means that cleanup calls accumulate and only execute after the loop finishes and the function returns.

This can lead to resource exhaustion: file descriptors pile up, database connections are held open, locks are held longer than intended, or transactions remain open across iterations.


## Recommendation
Extract the loop body into a separate function or closure so that `defer` runs at the end of each iteration:


```go
package main

import (
	"fmt"
	"os"
)

// BAD: defer Close inside a loop leaks file descriptors
func badReadFiles(paths []string) {
	for _, path := range paths {
		f, err := os.Open(path)
		if err != nil {
			continue
		}
		defer f.Close() // not closed until function returns
		fmt.Println(f.Name())
	}
}

// GOOD: extract into a function so defer runs per iteration
func goodReadFiles(paths []string) {
	for _, path := range paths {
		func() {
			f, err := os.Open(path)
			if err != nil {
				return
			}
			defer f.Close() // closed at end of this closure
			fmt.Println(f.Name())
		}()
	}
}

```
Alternatively, call the cleanup function directly without `defer` at the appropriate point in the loop body.


## References
* [Go Language Specification — Defer statements](https://go.dev/ref/spec#Defer_statements)
* [Gotchas of Defer in Go](https://blog.learngoprogramming.com/gotchas-of-defer-in-go-1-8d070894cb01)
