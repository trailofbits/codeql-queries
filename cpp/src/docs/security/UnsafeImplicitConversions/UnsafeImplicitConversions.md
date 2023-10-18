# Unsafe Implicit Conversions
Integer variables may be implicitly casted to a type of different size and signedness. If the variable is casted to a type of smaller bit-size or different signedness without a proper bound checking, then the casting may silently truncate the variable's value or make it semantically meaningless. This query finds implicit casts that cannot be proven to be safe.


## Recommendation
Either change variables types to avoid implicit conversions or verify that converting highlighted variables is always safe.


## Example

```cpp
/*
 * Compile: clang++ -Wall -pedantic UnsafeImplicitConversions.cpp
 * Test: ./a.out 0x100000001
*/
#include <stdlib.h>
#include <string.h>

char* malloc_wrapper(int size) {
    return (char*)malloc(size);
}

void test(uint64_t large) {
    char *p = malloc_wrapper(large);
    memset(p, 0, large);
    free(p);
}

int main(int argc, char *argv[]) {
    if (argc < 2)
        return 1;

    test(strtol(argv[1], NULL, 16));
    return 0;
}

```
In this example, the call to `malloc_wrapper` may silently truncate `large` variable, and so the allocated buffer will be of smaller size than the `test` function expects.

