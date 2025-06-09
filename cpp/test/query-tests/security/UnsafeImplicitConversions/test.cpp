/* Compile with clang -Wall -pedantic -DUSE_HEADERS test.cpp gives no warnings. */
/* Using clang -Wall -pedantic -Wconversion -DUSE_HEADERS test.cpp warns about the truncated integer. */

#ifndef USE_HEADERS
    typedef unsigned long uint64_t;
    typedef long int64_t;
    typedef unsigned long size_t;
    typedef long ssize_t;
    typedef unsigned short uint16_t;
    typedef unsigned int uint32_t;
    void *malloc(size_t);
    void *memset(void*, int, size_t);
    void free(void*);
    void puts(char*);
    ssize_t read(int, void*, size_t);
#else
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdint.h>
    #include <string.h> 
    #include <unistd.h> 
#endif

size_t get_number() {
    size_t ret;
    read(0, &ret, sizeof(size_t));
    return ret;
}

void* broken_malloc(int);
int test_func_1(int size);
int test_func_2(int, int size);
int test_func_3(int, int, int size);

void* broken_malloc(int size) {
    return malloc((size_t)size);
}

int test_func_1(int size) {
    return size > 0;
}

int test_func_2(int a, int size) {
    return a & test_func_1(size);
}

int test_func_3(int a, int b, int size) {
    return a & b & test_func_1(size);
}

int test_func_4(int a, int b, char c, int size) {
    return a | (b & c & test_func_1(size));
}

int test_func_5(unsigned int usize) {
    return usize > 0;
}

int test_func_6(const unsigned short& size) {
    return size > 0;
}

int test_func_7(const int& size) {
    return size > 0;
}

int test_func_8(int64_t size) {
    return size > 0;
}

int test_func_9(uint16_t size) {
    return size > 0;
}


// Test simple cases
void test1() {
    uint64_t large = get_number();
    large += (uint64_t)get_number();
    test_func_1(large);
    test_func_2(1, large);
    test_func_3(1, 1, large);
    test_func_4(1, 1, 'x', large);
}

// Test indirect var
void test2(uint64_t large) {
    char *p = (char*)broken_malloc(large);
    // memset(p, 0, large); // crash
    free(p);
}

// Test hardcoded value
void test3() {
    uint64_t large = get_number();
    test_func_1(large);
}

// Test unsigned
void test4() {
    uint64_t large = get_number();
    test_func_5(large);
}

// Test size_t
void test5() {
    size_t large = get_number();
    test_func_5(large);
}

// Test int64_t
void test6() {
    int64_t large = (int64_t)get_number();
    test_func_1(large);
}

// Test reference
void test7() {
    uint64_t large = get_number();
    uint64_t& x = large;
    uint64_t& y = x;
    test_func_1(y);
}

// Test two args bug
void test8() {
    unsigned int large = (unsigned int)get_number();
    unsigned int& x = large;
    test_func_3(large, 22, x);
}

// Test passing by reference
void test9() {
    uint64_t large = get_number();
    test_func_6(large);
}

// Test passing by reference second
void test10() {
    uint64_t large = get_number();
    test_func_7(large);
}

// Test pointer derederence
void test11() {
    uint64_t large = get_number();
    uint64_t *x = &large;
    test_func_6(*x);
}

// Test sign
void test12() {
    unsigned int large = (unsigned int)get_number();
    test_func_1(large);
}

// Test large overflow
void test13() {
    test_func_1(get_number());
}

// Test negative to unsigned
void test14() {
    int64_t large = (int64_t)get_number();
    test_func_5(large);
}

// Implicit type promotion
void test15() {
    int large = (int)get_number();
    test_func_9((uint16_t)large - (uint16_t)get_number());
}

// Implicit widening in usual arithmetic conversions
void test16() {
    short a = (short)get_number();
    unsigned int b = (unsigned int)get_number();
    unsigned short c = a & b;
}

// Implicit type promotion with binary complement
void test17() {
    unsigned short val = (unsigned short)get_number();
    int val2 = (~val) >> 3;
}

// Implicit casts in comparisons - widening
void test18() {
    int x = (int)get_number();
    if (x > sizeof(int)) { puts("That's why."); }
}

// Implicit casts in comparisons - reinterpretation
void test19() {
    long long x = (long long)get_number();
    if (x > sizeof(int)) { puts("That's why."); }
}

// Implicit cast in comparison, int -> unsigned int
void test20(int a) {
    const unsigned int b = (unsigned int)get_number();
    if (a != b) {  // negative a may wrap to b
        puts("here");
        return;
    }
}

// Implicit cast in comparison, int -> unsigned int
void test21(unsigned int a) {
    int b = (int)get_number();
    if (a != b) {  // b may wrap to a
        puts("here");
        return;
    }
}

// Implicit cast in comparison, int -> unsigned long long
void test22(int a) {
    unsigned long long b = (unsigned long long)get_number();
    if (a != b) {  // negative a may wrap to b
        puts("here");
        return;
    }
}

/*
 * Tests for False Positives
 */

// Test explicit cast false-positive
void test_fp1(uint64_t large) {
    test_func_1((int)large);
}

// Test with value known at compile time to fit in 32 bits
void test_fp2() {
    const uint64_t const_large_ok_value = (uint64_t)get_number();
    uint64_t const_large_ok_value2 = get_number();
    test_func_1((int)const_large_ok_value);
    test_func_1((int)const_large_ok_value2);
}

// Test reference with valid type
void test_fp3() {
    int x = (int)get_number();
    int& y = x;
    test_func_1(y);
}

// Test passing by reference with valid type
void test_fp4() {
    unsigned short x = (unsigned short)get_number();
    unsigned short& y = x;
    test_func_6(y);
}

// Test pointer derederence with explicit cast
void test_fp5() {
    uint64_t large = get_number();
    uint64_t *x = &large;
    test_func_6((unsigned short)(*x));
}

// Test passing by reference with shorter type
void test_fp6() {
    unsigned short x = (unsigned short)get_number();
    unsigned short& y = x;
    test_func_7(y);
}

// Test sign false-positive
void test_fp7() {
    unsigned int large = (unsigned int)get_number();
    test_func_1((int)large);  // ok, explicit cast
}

// Test large but valid false-positive
void test_fp8() {
    uint64_t large = get_number();
    test_func_8((int64_t)large);  // ok, explicit cast
}

// Test explicit cast false-positive
void test_fp9() {
    int large = (int)get_number();
    test_func_9((uint16_t)large);  // ok, explicit cast
    test_func_9((uint16_t)(large - (int)get_number()));  // ok, explicit cast
}

// Test arithmetic
void test_fp10(int argc) {
    uint64_t large = get_number();
    large += (uint64_t)get_number();
    large = large - (uint64_t)get_number();
    large = large & (uint64_t)get_number();
    if (argc == 2)
        test_func_8((int64_t)large);  // ok, explicit cast
    else
        test_func_8((int64_t)(large + (uint64_t)get_number()));  // ok, explicit cast
}

#define CA 16
#define CB 32
#define CC 64
typedef uint32_t sa;
typedef uint32_t sb;

int max_int(int x, int y) {
    if (x > y)
        return x;
    return y;
}

static inline int complex_two_possible(bool switchx)
{
    if (switchx)
        return sizeof(sa) - (switchx ? sizeof(sb) : 0);
    else
        return -12;
}

unsigned int complex_const(void) {
    return complex_two_possible(true) + CA + CB; // TODO
}


int test_fp11(int argc, size_t c) {
    int a = argc * 2;
    size_t b = (size_t)max_int((int)get_number(), a);
    int h2 = (int)c;
    if (h2 > 0) {
        c = (size_t)get_number();
        int w = (int)c;
    }

    if (argc > 1)
        b += (size_t)get_number();
    b += (size_t)get_number();

    c = 0;
    c += complex_const();
    c += (size_t)get_number();
    c += (size_t)get_number();
    c += (size_t)get_number();
    c = (c + (size_t)get_number()) & ~((size_t)get_number()) | (size_t)get_number();
    b += c;

    int result = (int)b;
    return result;
}

void test_fp12() {
    unsigned short val = (unsigned short)get_number();
    int val2 = (unsigned short) (~val) >> 3; // TODO: exclude explicit conversions
}

void test_fp13() {
    unsigned short val = (unsigned short)get_number();
    int val2 = -(int)val;
}

void test_fp14() {
    uint64_t large = get_number();
    test_func_1((int)large);
    test_func_1(static_cast<int>(large));
    test_func_1(int(large));
}

void test_fp15() {
    short a = (short)get_number();
    unsigned int b = (unsigned int)get_number();
    unsigned short c = (unsigned short)((unsigned int)a & b);
}

void test_fp16(unsigned short a, unsigned short b) {
    if ( (a-(unsigned short)get_number()) < 0) { // promotion to int, possibly unexpected but we are not reporting such issues
        puts("called");
    }

    b = b - (unsigned short)get_number();
    if (b < 0) {  // no unexpected promotion
        puts("not called");
    }
}

// Safe implicit cast in comparison, int -> unsigned int
void test_fp17(int a) {
    unsigned int b = (unsigned int)get_number();
    if (a != (int)b) {  // explicit cast to avoid implicit conversion
        puts("here");
        return;
    }
}

// Safe implicit cast in comparison, unsigned int -> long long
void test_fp18(unsigned int a) {
    long long b = (long long)get_number();
    if ((long long)a != b) {  // explicit cast to avoid implicit conversion
        puts("here");
        return;
    }
}

// Safe implicit cast in comparison, int -> unsigned long long
void test_fp19(int a) {
    unsigned long long b = (unsigned long long)get_number();
    if ((unsigned long long)a != b) {  // explicit cast to avoid implicit conversion
        puts("here");
        return;
    }
}


int main(int argc, char **argv) {
    uint64_t large;
    large = get_number();

    size_t somenumber = get_number();

    test1();
    test2(large);
    test3();
    test4();
    test5();
    test6();
    test7();
    test8();
    test9();
    test10();
    test11();
    test12();
    test13();
    test14();
    test15();
    test16();
    test17();
    test18();
    test19();
    test20((int)somenumber);
    test21((unsigned int)somenumber);
    test22((int)somenumber);

    test_fp1(large);
    test_fp2();
    test_fp3();
    test_fp4();
    test_fp5();
    test_fp6();
    test_fp7();
    test_fp8();
    test_fp9();
    test_fp10((int)somenumber);

    test_fp11((int)somenumber, (size_t)get_number());
    test_fp11((int)somenumber, somenumber);

    test_fp12();
    test_fp13();
    test_fp14();
    test_fp15();
    test_fp16((unsigned short)somenumber, (unsigned short)somenumber);
    test_fp17((int)somenumber);
    test_fp18((unsigned int)somenumber);
    test_fp19((int)somenumber);
    
    return 0;
}

