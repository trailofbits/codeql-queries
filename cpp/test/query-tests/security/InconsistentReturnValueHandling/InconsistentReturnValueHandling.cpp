#include "../../../include/libc/string_stubs.h"

struct something {
    int x;
    char w;
};

struct athing {
    int x;
    char w;
    int y;
};

static int w = 2;

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

void test_1_2() {
    // the baseline for target_func_1
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

void test_1_1() {
    // BAD: comparing with sizeof instead of hard-coded int
    if (target_func_1(2) != sizeof(something)) {
        puts("something");
    }
}

// BAD 2
int target_func_2(int a)
{
    return a - 2;
}

void test_2_1() {
    if (target_func_2(2) != sizeof(struct something)) {
        puts("something");
    }
}

void test_2_2() {
    if (target_func_2(-123) != sizeof(struct something)) {
        puts("something");
    }
    int r = target_func_2(123);
    if (r > sizeof(struct something)) {
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
    if (target_func_3(2) != sizeof(struct something)) {
        puts("something");
    }
}

void test_3_2() {
    auto athingInstance = athing{};
    auto somethingInstance = something{};

    if (target_func_3(-123) != sizeof(something)) {
        puts("something");
    }
    int r = target_func_3(123);
    if (r > sizeof(struct something)) {
        return;
    }
    r = target_func_3(1223);
    if (r > sizeof(somethingInstance)) {
        return;
    }
    r = target_func_3(1323);
    if (r >= sizeof(somethingInstance)) {
        return;
    }
    r = target_func_3(1523);
    if (r != sizeof(somethingInstance)) {
        return;
    }

    r = target_func_3(-3);
    // BAD: comparing with a different sizeof
    if (r > sizeof(struct athing)) {
        puts("something2");
    }

    r = target_func_3(-3);
    // BAD: comparing with a different sizeof
    if (r > sizeof(athingInstance)) {
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

void test_7_1() {
    if (some_func_cmp(target_func_7(2))) {
        puts("something");
    }
}

void test_7_2() {
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

// BAD 8
bool target_func_8(int a)
{
    return a > 10 ? true : false;
}
int some_func_arithmetic(int x) {
    return x*3;
}

void test_8_1() {
    if (target_func_8(2)*4 == 2*5+6) {
        puts("something");
    }
}

void test_8_2() {
    if (target_func_8(12) != 4*some_func_arithmetic(-3)) {
        puts("something");
    }
    bool r = target_func_8(123);
    if (r*2 < sizeof(something)) {
        return;
    }

    r = target_func_8(-3);
    // BAD: comparing with constant instead of dynamically computed value
    if (r != 3) {
        puts("something8");
    }
}

// BAD 9
int* target_func_9(int a)
{
    return a > 10 ? &w : NULL;
}

void test_9_1() {
    if (target_func_9(2) == NULL) {
        puts("something");
    }
}

void test_9_2() {
    int *tt;
    if ((tt = target_func_9(12)) != NULL) {
        puts("something");
    }
    tt = target_func_9(123);
    if (tt == NULL) {
        return;
    }

    // BAD: comparing with int instead of NULL
    if ((int)(tt = target_func_9(-3)) != 0) {
        puts("something8");
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

// GOOD 3: always comparing with int, check only first use
bool target_func_g3(int a)
{
    return a > 10 ? true : false;
}

void test_g_3_1() {
    if (target_func_g3(2) != 3) {
        puts("something");
    }
}

void test_g_3_2() {
    if (target_func_g3(-123) != 4) {
        puts("something");
    }
    bool r = target_func_g3(123);
    if (r == 777) {
        return;
    }

    r = target_func_g3(-3);
    if (r > -123) {
        puts("something2");
    }
    // We don't want to find this use, because it is not a ret val check
    // but an actuall use
    if (cmp_func(r)) {
        return;
    }
}

// GOOD 4: always comparing with int, handle multi-condition IFs
bool target_func_g4(int a)
{
    return a > 10 ? true : false;
}

void test_g_4_1() {
    if (target_func_g4(2) != 3) {
        puts("something");
    }
}

void test_g_4_2() {
    int *www = &w;

    if (target_func_g4(-123) != 4) {
        puts("something");
    }
    bool r = target_func_g4(123);
    if (r == 777) {
        return;
    }

    r = target_func_g4(-3);
    if (r > -123) {
        puts("something2");
    }

    bool rr = target_func_g4(-3);
    if (www == NULL || rr > -123) {
        puts("something2");
    }
}

// BAD 10: 4 int comparisons + 1 variable comparison (variable is outlier)
int target_func_10(int a)
{
    return a + 10;
}

void test_10_1() {
    if (target_func_10(2) != 1) {
        puts("something");
    }
    if (target_func_10(3) > 0) {
        puts("something");
    }
    int r = target_func_10(4);
    if (r > 0) {
        puts("something");
    }
    if (target_func_10(7) != 99) {
        puts("something");
    }
}

void test_10_2() {
    int threshold = 42;
    // BAD: comparing with a variable instead of hard-coded int
    if (target_func_10(5) != threshold) {
        puts("something");
    }
}

// BAD 11: 4 enum comparisons + 1 int literal (int literal is outlier)
enum ErrorCode { EC_OK = 0, EC_FAIL = 1, EC_RETRY = 2, EC_TIMEOUT = 3 };

int target_func_11(int a)
{
    return a > 10 ? EC_OK : EC_FAIL;
}

void test_11_1() {
    if (target_func_11(2) != EC_OK) {
        puts("something");
    }
    if (target_func_11(3) != EC_FAIL) {
        puts("something");
    }
    int r = target_func_11(4);
    if (r == EC_RETRY) {
        puts("something");
    }
    r = target_func_11(5);
    if (r != EC_TIMEOUT) {
        puts("something");
    }
}

void test_11_2() {
    // BAD: comparing with int literal instead of enum constant
    if (target_func_11(6) != 42) {
        puts("something");
    }
}

// BAD 12: 3 int + || with two sizeof calls (sizeof is the outlier)
int target_func_12(int a)
{
    return a * 2;
}

void test_12_1() {
    if (target_func_12(2) != 1) {
        puts("something");
    }
    if (target_func_12(3) > 0) {
        puts("something");
    }
    int r = target_func_12(4);
    if (r > 0) {
        puts("something");
    }
}

void test_12_2() {
    // BAD: sizeof comparison in short-circuit expression
    if (target_func_12(5) > sizeof(something) || target_func_12(6) > sizeof(something)) {
        puts("something");
    }
}

// GOOD 5: 4 int comparisons + bare if(f()) which is silently dropped
int target_func_g5(int a)
{
    return a + 5;
}

void test_g_5_1() {
    if (target_func_g5(2) != 1) {
        puts("something");
    }
    if (target_func_g5(3) > 0) {
        puts("something");
    }
    int r = target_func_g5(4);
    if (r > 0) {
        puts("something");
    }
    if (target_func_g5(7) != 99) {
        puts("something");
    }
}

void test_g_5_2() {
    // bare conditional: no comparison, should be silently dropped
    if (target_func_g5(6)) {
        puts("something");
    }
}

// GOOD 6: only 3 uses, below threshold of 4
int target_func_g6(int a)
{
    return a + 6;
}

void test_g_6_1() {
    if (target_func_g6(2) != 1) {
        puts("something");
    }
    if (target_func_g6(3) > 0) {
        puts("something");
    }
}

void test_g_6_2() {
    if (target_func_g6(4) > sizeof(something)) {
        puts("something");
    }
}

// GOOD 7: 2 int + 2 sizeof, 50/50 split below 74% threshold
int target_func_g7(int a)
{
    return a + 7;
}

void test_g_7_1() {
    if (target_func_g7(2) != 1) {
        puts("something");
    }
    if (target_func_g7(3) > 0) {
        puts("something");
    }
}

void test_g_7_2() {
    if (target_func_g7(4) > sizeof(something)) {
        puts("something");
    }
    int r = target_func_g7(5);
    if (r > sizeof(something)) {
        puts("something");
    }
}

// GOOD 8: 4 bool comparisons + if(!f()) which is silently dropped
bool target_func_g8(int a)
{
    return a > 10;
}

void test_g_8_1() {
    if (target_func_g8(2) != true) {
        puts("something");
    }
    if (target_func_g8(3) == false) {
        puts("something");
    }
    bool r = target_func_g8(4);
    if (r == true) {
        puts("something");
    }
    if (target_func_g8(5) != false) {
        puts("something");
    }
}

void test_g_8_2() {
    // negation: no comparison operator, should be silently dropped
    if (!target_func_g8(6)) {
        puts("something");
    }
}

// BAD 13: bare if(func()) mixed with comparisons, should not affect categorization
int target_func_13(int a)
{
    return a + 13;
}

void test_13_1() {
    if (target_func_13(2) != 1) {
        puts("something");
    }
    if (target_func_13(3) > 0) {
        puts("something");
    }
    int r = target_func_13(4);
    if (r > 0) {
        puts("something");
    }
}

void test_13_2() {
    // bare conditional: no comparison, should be silently dropped
    if (target_func_13(5)) {
        puts("something");
    }
    // BAD: sizeof comparison when others use int
    if (target_func_13(6) > sizeof(something)) {
        puts("something");
    }
}

// BAD 14: comparison in else-if is properly categorized
int target_func_14(int a)
{
    return a + 14;
}

void test_14_1() {
    if (target_func_14(2) != 1) {
        puts("something");
    }
    if (target_func_14(3) > 0) {
        puts("something");
    }
    int r = target_func_14(4);
    if (r > 0) {
        puts("something");
    }
}

void test_14_2() {
    int x = 42;
    // BAD: sizeof comparison in else-if branch
    if (x > 100) {
        puts("high");
    } else if (target_func_14(5) > sizeof(something)) {
        puts("something");
    }
}

// BAD 15: comparison inside && short-circuit expression
int target_func_15(int a)
{
    return a + 15;
}

void test_15_1() {
    if (target_func_15(2) != 1) {
        puts("something");
    }
    if (target_func_15(3) > 0) {
        puts("something");
    }
    int r = target_func_15(4);
    if (r > 0) {
        puts("something");
    }
}

void test_15_2() {
    int other = 42;
    // BAD: sizeof comparison inside && expression
    if (target_func_15(5) > sizeof(something) && other > 0) {
        puts("something");
    }
}

// BAD 16: deep variable copy chain before comparison
int target_func_16(int a)
{
    return a + 16;
}

void test_16_1() {
    if (target_func_16(2) != 1) {
        puts("something");
    }
    if (target_func_16(3) > 0) {
        puts("something");
    }
    int r = target_func_16(4);
    if (r > 0) {
        puts("something");
    }
}

void test_16_2() {
    int r = target_func_16(5);
    int s = r;
    // BAD: sizeof comparison after variable copy
    if (s > sizeof(something)) {
        puts("something");
    }
}

// GOOD 9: all bare if(func()) — nothing categorized, below threshold
int target_func_g9(int a)
{
    return a + 9;
}

void test_g_9_1() {
    if (target_func_g9(1)) {
        puts("something");
    }
    if (target_func_g9(2)) {
        puts("something");
    }
    if (target_func_g9(3)) {
        puts("something");
    }
    if (target_func_g9(4)) {
        puts("something");
    }
    if (target_func_g9(5)) {
        puts("something");
    }
}

// GOOD 10: reversed operand order — all same category (Tint)
int target_func_g10(int a)
{
    return a + 100;
}

void test_g_10_1() {
    if (target_func_g10(1) > 0) {
        puts("something");
    }
    if (target_func_g10(2) != 5) {
        puts("something");
    }
    if (0 < target_func_g10(3)) {
        puts("something");
    }
    if (target_func_g10(4) >= -1) {
        puts("something");
    }
}

// GOOD 11: return value used only in while/for, not in if
int target_func_g12(int a)
{
    return a + 120;
}

void test_g_12_1() {
    while (target_func_g12(1) > 0) {
        break;
    }
    while (target_func_g12(2) > sizeof(something)) {
        break;
    }
    for (int i = 0; target_func_g12(3) > 0; i++) {
        break;
    }
    for (int i = 0; target_func_g12(4) > sizeof(something); i++) {
        break;
    }
}