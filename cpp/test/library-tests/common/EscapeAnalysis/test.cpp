#include "../../../include/std/vector.hpp"

typedef int* intptr_t;

class Foo {
public:
    int *x;
    std::vector<int *> v;
};

struct bar_t {
  int *x;
};

// `x` escapes through `var`.
void test_0(int **var) {
  int *x = 0;
  *var = x;
}

// `x` escapes through `vars`.
void test_1(int **vars) {
  int *x = 0;
  vars[0] = x;
}

// `x` escapes through `ptr`.
void test_2(intptr_t &ptr) {
  int *x = 0;
  ptr = x;
}

// `x` escapes through `foo`.
void test_3(Foo &foo) {
  int *x = 0;
  foo.x = x;
}

// `x` escapes through `v`.
void test_4(std::vector<int *> &v) {
  int *x = 0;
  v.push_back(x);
}

// `x` escapes through `v`.
void test_5(std::vector<int *> *v) {
  int *x = 0;
  v->push_back(x);
}

// `x` escapes through `foo`.
void test_6(Foo &foo) {
  int *x = 0;
  foo.v.push_back(x);
}

// `x` escapes through `foo`.
void test_7(Foo *foo) {
  int *x = 0;
  foo->v.push_back(x);
}

// `x` escapes through return value.
int *test_8() {
    int *x = 0;
    return x;
}

// `x` escapes through return value.
struct bar_t test_9() {
    int *x = 0;
    return (struct bar_t){ x };
}

// `x` does not escape.
void test_10(int *p) {
    int *x = 0;
    p = x;
}
