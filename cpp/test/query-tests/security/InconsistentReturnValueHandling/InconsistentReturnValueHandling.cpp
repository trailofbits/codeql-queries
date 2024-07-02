#include <stdio.h>

struct something {
    int x;
    char w;
};

struct athing {
    int x;
    char w;
    int y;
};

bool cmp_func(int a)
{
    return a >= 10 ? true : false;
}
bool cmp_func2(int a)
{
    return a >= 102 ? true : false;
}

int main() {
    return 0;
}

// BAD 1
int target_func_1(int a)
{
    return a + 1;
}

void test_1_1() {
    // BAD: comparing with sizeof instead of hard-coded int
    if (target_func_1(2) != sizeof(something)) {
        puts("something");
    }
}

void test_1_2() {
    if (target_func_1(2) != 1) {
        puts("something2");
    }
    if (target_func_1(2) > 0) {
        puts("something2");
    }
    int r = target_func_1(3);
    if (r > 0) {
        puts("something2");
    }
}



// BAD 2
int target_func_2(int a)
{
    return a - 2;
}

void test_2_1() {
    if (target_func_2(2) != sizeof(something)) {
        puts("something");
    }
}

void test_2_2() {
    if (target_func_2(-123) != sizeof(something)) {
        puts("something");
    }
    int r = target_func_2(123);
    if (r > sizeof(something)) {
        return;
    }

    r = target_func_2(3);
    // BAD: comparing with hard-coded int instead of sizeof
    if (r > 0) {
        puts("something2");
    }
}

// BAD 3
int target_func_3(int a)
{
    return a*a;
}

void test_3_1() {
    if (target_func_3(2) != sizeof(something)) {
        puts("something");
    }
}

void test_3_2() {
    if (target_func_3(-123) != sizeof(something)) {
        puts("something");
    }
    int r = target_func_3(123);
    if (r > sizeof(something)) {
        return;
    }

    r = target_func_3(-3);
    // BAD: comparing with a different sizeof
    if (r > sizeof(athing)) {
        puts("something2");
    }
}

// BAD 4
class SomeClass
{
private:
    bool r;
    int r2;
public:
    SomeClass();
    void DoSomething(int);
    void DoSomethingElse();
    int target_func_4(int);
};

void test_4_1() {
    SomeClass sc = SomeClass();
    if (sc.target_func_4(2) != 1) {
        puts("something");
    }
}

void test_4_2() {
    SomeClass sc = SomeClass();
    if (sc.target_func_4(-123) != -1) {
        puts("something");
    }
    int r = sc.target_func_4(123);
    if (r > 0) {
        return;
    }

    r = sc.target_func_4(-3);
    if (r > 123) {
        puts("something2");
    }
}

SomeClass::SomeClass() {
    r = true;
    r2 = 33;
}

void SomeClass::DoSomething(int a) {
    if (target_func_4(-123) != -1) {
        puts("something");
    }
    int r = target_func_4(123);
    if (r > 0) {
        return;
    }

    r = target_func_4(-3);
    if (r > 123) {
        puts("something2");
    }
}

void SomeClass::DoSomethingElse() {
    if (target_func_4(-123) != -1) {
        puts("something");
    }
    int r = target_func_4(123);
    // BAD: bool instead of int comparison
    if (r != true) {
        return;
    }
}

int SomeClass::target_func_4(int a) {
    return a + 2;
}

// BAD 5
static int w = 2;
int* target_func_5(int a)
{
    return &w;
}

void test_5_1() {
    if (target_func_5(2) != nullptr) {
        puts("something");
    }
}

void test_5_2() {
    if (target_func_5(-123) != nullptr) {
        puts("something");
    }
    int *r = target_func_5(123);
    if (r == NULL) {
        return;
    }

    r = target_func_5(-3);
    int *some_ptr = &w;
    // BAD: comparing with a pointer instead of NULL
    if (r > some_ptr) {
        puts("something2");
    }
}

// BAD 6
bool target_func_6(int a)
{
    return a > 10 ? true : false;
}

void test_6_1() {
    if (target_func_6(2) != cmp_func(2)) {
        puts("something");
    }
}

void test_6_2() {
    if (target_func_6(-123) != cmp_func2(-123)) {
        puts("something");
    }
    bool r = target_func_6(123);
    if (r == cmp_func(3333)) {
        return;
    }

    r = target_func_6(-3);
    // BAD: comparing with sizeof instead of some other function
    if (r != (bool)sizeof(something)) {
        puts("something2");
    }
}

// BAD 7
bool target_func_7(int a)
{
    return a > 10 ? true : false;
}
bool some_func_cmp(bool x) {
    return !x;
}

void test_6_1() {
    if (some_func_cmp(target_func_7(2))) {
        puts("something");
    }
}

void test_6_2() {
    if (some_func_cmp(target_func_7(12)) != cmp_func2(-123)) {
        puts("something");
    }
    bool r = target_func_7(123);
    if (some_func_cmp(r) < 7) {
        return;
    }

    r = target_func_7(-3);
    // BAD: comparing with something instead of using as argument to a function
    if (r != cmp_func2(-123)) {
        puts("something2");
    }
}

// GOOD 1: always comparing with NULL
int* target_func_g1(int a)
{
    return &w;
}

void test_g_1_1() {
    if (target_func_g1(2) != nullptr) {
        puts("something");
    }
}

void test_g_1_2() {
    if (target_func_g1(-123) != nullptr) {
        puts("something");
    }
    int *r = target_func_g1(123);
    if (r == NULL) {
        return;
    }

    r = target_func_g1(-3);
    if (r == nullptr) {
        puts("something2");
    }
}

// GOOD 2: always comparing with some function
bool target_func_g2(int a)
{
    return a > 10 ? true : false;
}

void test_g_2_1() {
    if (target_func_g2(2) != cmp_func(2)) {
        puts("something");
    }
}

void test_g_2_2() {
    if (target_func_g2(-123) != cmp_func(-123)) {
        puts("something");
    }
    bool r = target_func_g2(123);
    if (r == cmp_func(3333)) {
        return;
    }

    r = target_func_g2(-3);
    if (r > cmp_func2(-3)) {
        puts("something2");
    }
}