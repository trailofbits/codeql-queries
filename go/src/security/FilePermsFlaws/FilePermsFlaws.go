package main

import "os"

func main() {
	if len(os.Args) >= 2 {
		if err := os.Chmod(os.Args[1], 644); err != nil {
			return
		}
	}
}
