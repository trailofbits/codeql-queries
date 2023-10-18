#include "../../../include/libc/string_stubs.h"

const char constin[] = "gros";
const int constinsize = 3;

static char staticin[] = "lol";
static int staticinsize = 2;

// Basic test
void test1(char **argv) {
    if (strncmp("LX/", argv[1], 2) != 0) { // the string length is 3, not 2
        puts("Passed 1");
    }
    else if (!memcmp(argv[1], "org/haxe/lime/HaxeObject;", 24)) { // the string length is 25, not 24
        puts("Passed 2");
    }
    else if (!wmemcmp(L"123456", L"123456789", 5)) { // the smaller string length is 6, not 5
        puts("Passed 3");
    }
    else if (strncmp(";", argv[1], 2) != 0) { // this is fine, we are comparing nullbytes
        puts("Passed 4");
    }
}

// Test size
char* test2() {
    char *dst = malloc(5);
    strncpy(dst, "test2", 4);
    return dst;
}

// Test indirect src
char* test3() {
    char *src = "abc";
    char *dst = malloc(5);
    strncpy(dst, src, 2);
    return dst;
}

// Test all indirect vars
char* test4() {
    const long size = 2;
    char src[] = "xyz";
    char *dst = malloc(5);
    memccpy(dst, src, 'x', size);
    return dst;
}

// Test with if
char* test5(int x) {
    char *src = "abc";
    if (x == 3) {
        src = "voovoo";
    }
    char *dst = malloc(5);
    strncpy(dst, src, 2);
    return dst;
}

// Test const globals - TODO
wchar_t* test6() {
    wchar_t *dst = malloc(5);
    wcsncat(dst, (wchar_t*)constin, constinsize);
    return dst;
}

// Test static globals - TODO
char* test7() {
    char *dst = malloc(5);
    _mbsncat(dst, staticin, staticinsize);
    return dst;
}

// Test cmp equal lengths
int test8() {
    char a[] = "abc";
    char b[] = "xyz";
    return _mbsncmp(a, b, 2);
}

// Test cmp first shorted
int test9() {
    char a[] = "led";
    char b[] = "wholelottalove";
    return memcmp(a, b, 2);
}

// Test cmp second shorted
int test10() {
    char a[] = "leavebreak";
    char b[] = "song";
    return memcmp(a, b, 2);
}

// Test cmp one missing
int test11(char **argv) {
    char a[] = "oovoov";
    return wmemcmp((wchar_t*)a, (wchar_t*)argv[0], 5);
}

// Test cmp same arg
int test12(char **argv) {
    char a[] = "hearth";
    return _memicmp(a, a, 5);
}

// Test cmp overflow
int test13(char **argv) {
    char a[] = "me";
    return _memicmp(a, argv[0], 8);
}

// Test cmp overflow two args
int test14(char **argv) {
    char a[] = "is";
    char b[] = "tomorrowneverbe";
    return memcmp(a, b, 5);
}

// Test overflow
char* test15() {
    char a[] = "Oo";
    char *dst = malloc(20);
    mempcpy(dst, a, 4);
    return dst;
}

// Test cmp true-positive similar to test_fp4
int test16(char **argv) {
    char a[] = "0123456789";
    return wcsncmp(a, argv[0], 9);
}

// Test strncat overflow
int test17() {
    char dst[10];
    char source[] = "1234567";
    return strncat(dst, source, 10);  // size limits source length (amount of appended bytes), and is not destination size
}

// Test strncat overflow 2
int test18() {
    short size = 7;
    char dst[size];
    memset(dst, 0x41, 4);
    return strncat(dst, "12345", 7);  // size limits source length (amount of appended bytes), and is not destination size
}

// Test #define and strncat overflow
int test19() {
    #define LEN 16
    char buf[LEN+5];
    const char str[] = ":12345";
    strncat(buf, str, LEN+4);
}

// Test widechar overflow - TODO
char* test20() {
    wchar_t src[] = L"test";
    char *dst = malloc(20);
    wmemcpy(dst, src, 8); // src is of size 20 bytes, there will be 8*4=32 bytes copied
    return dst;
}

/*
 * Tests for False Positives
 */

// Test cmp false-positive
int test_fp1() {
    char a[] = "abc";
    char b[] = "ab";
    return _mbsnbcmp(a, b, 3);  // ok, because shorter arg has length of 3
}

// Test single arg false-positive
char* test_fp2() {
    char a[] = "abc";
    char *dst = malloc(5);
    strncat(dst, a, 4);  // ok
    return dst;
}

// Test single arg false-positive too large typo to be true 
char* test_fp3() {
    char a[] = "abcdefghijkolove";
    char *dst = malloc(2);
    strncat(dst, a, 1);  // ok, because assumption is that typo in size would be <= 2
    return dst;
}

// Test cmp false-positive too large typo to be true
int test_fp4(char **argv) {
    char a[] = "lalalalallalalalalallala";
    return wcsncmp(a, argv[0], 6);  // ok, because assumption is that typo in size would be <= 2
}

// Test cmp overflow false-positive
int test_fp5(char **argv) {
    char a[] = "xd";
    char b[] = "owowowoowowowowow";
    return strncmp(a, b, 9);  // ok, because strings should be null-terminated
}

// Test strcpy overflow false-positive
int test_fp6(char **argv) {
    char a[] = "mem";
    char *dst = malloc(20);
    return strncpy(dst, a, 9);  // ok, because string should be null-terminated
}

// Test strncat with explicit strlen
int test_fp7() {
    #define LEN 16
    char buf[LEN+5];
    const char str[] = ":12345";
    strncat(buf, str, sizeof(buf) - strlen(buf) - 1); // size won't be computed by the codeql in the query
}


int main(int argc, char* argv[]) {
    if (argc > 1)
        test1(argv);
    free(test2());
    free(test3());
    free(test4());
    free(test5(2));
    free(test6());
    free(test7());
    test8();
    test9();
    test10();
    test11(argv);
    test12(argv);
    test13(argv);
    test14(argv);
    test15();

    test_fp1();
    free(test_fp2());
    free(test_fp3());
    test_fp4(argv);
    test_fp5(argv);
    test_fp6(argv);
    test_fp7();
}
