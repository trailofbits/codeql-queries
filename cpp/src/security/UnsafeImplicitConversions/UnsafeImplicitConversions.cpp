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
