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
