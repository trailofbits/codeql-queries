# Find all problematic implicit casts
Integer variables may be implicitly casted to a type of different size and signedness. If the variable is casted to a type of smaller bit-size or different signedness without a proper bound checking, then the casting may silently change the variable's value or make it semantically meaningless. Since implicit casts are introduced by the compiler, developers may be not aware of them and the compiled code may behave incorrectly aka may have bugs. This query finds implicit casts that cannot be proven to be safe. Safe means that the input value is known to fit into destination type aka the value won't change.


## Recommendation
Either adjust types of problematic variables to avoid implicit conversions, make the code validate that converting the variables is safe, or add explicit conversions that would make the compiler avoid introducing implicit ones.


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
In this example, the call to `malloc_wrapper` may silently truncate `large` variable so that the allocated buffer will be of smaller size than the `test` function expects.

