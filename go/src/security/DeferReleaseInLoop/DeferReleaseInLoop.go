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
