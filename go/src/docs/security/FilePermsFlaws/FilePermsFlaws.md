# File permission flaws
`FileMode` parameters (for methods accessing filesystem) are usually provided as octal numbers. This query detects hardcoded `FileMode`s that are not in octal form - numbers you see in the code are not what you will get. The query filters out some commonly used, not-octal integers to reduce number of false positives. Moreover, the query detect calls to permission-changing methods (e.g., `os.Chmod`, `os.Mkdir`) when the `FileMode` has more than 9 bits set - other bits may not be used, depending on the operating system.


## Recommendation
Review results and replace highlighted permissions with their octal versions.


## Example

```go
package main

import "os"

func main() {
	if len(os.Args) >= 2 {
		if err := os.Chmod(os.Args[1], 644); err != nil {
			return
		}
	}
}

```
In this example, the call to `os.Chmod` is most probably not correct - it sets the new directory permissions to `0o1204`, and not to the `0644`.

