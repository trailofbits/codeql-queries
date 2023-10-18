#include <stdio.h>

void foo() {
    // That's a correct C-string!
    char s[4] = "abc";
    printf("%s", s);
}

void bar() {
    // That's a buffer without a null terminator, not a C-string (but "C-string like")
    char s[3] = "abc";
    // OOB READ!
    printf("%s", s);
}

int main() {
    foo();
    bar();
}

