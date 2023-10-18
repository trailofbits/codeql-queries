# CStrNFinder
Some functions receive input buffer (strings, arrays, ...) and the buffer's size as separate arguments. For manually provided (hardcoded) sizes one may make simple mistakes resulting from typos or misunderstanding of fuctions' APIs. For example:

* a hardcoded string's length may be incorrectly stated
* size arguments of strncat-like functions may be mistreated as destination buffer sizes, instead of input buffers
* `memcmp`-like functions may not take into account both inputs' lengths


This query finds calls to functions that take as input string and its size as separate arguments (`strncmp`, `strncpy`, `memmove`, ...), and:

* the size argument is slightly smaller than the source string's length (probable typo or off-by-one bug)
* the size argument is greater than the input string's length and memory function is used (buffer overread)
* the size argument is greater than the input string's length, and `strncat` like function is used (probable incorrect `strncat` use)


Most of the cases detected by this query are related to incorrect string comparisons, e.g. when comparing:



* paths (e.g., "path/" compared without "/")
* extensions (".exe" compared with size=4)
* parsing of various formats tokens (which can cause a given parsing library to act differently than other libraries that parse the same format)
* more examples can be found in \[disconnect3d/cstrnfinder\](https://github.com/disconnect3d/cstrnfinder\#reported-or-fixed-bugs)

## Recommendation
Review results and verify that provided sizes are correct.


## Example

```c
/*
 * Compile: clang -Wall -pedantic CStrnFinder.c
 * Test: ./a.out org/tob/test/SafeDatX
*/
#include <string.h>
#include <stdio.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        return 1;
    }

    if (!strncmp(argv[1], "org/tob/test/SafeData", 20)) { // the string length is 21, not 20
        puts("Secure");
    } else {
        puts("Not secure");
    }
    return 0;
}

```
In this example, the call to `strncmp` is not correct - it fails to compare last character of the hardcoded string.

