# Missing null terminator
This is a CodeQL query constructed to find "C-string like" buffers without a null-terminator, passed to a function expecting a null-terminated string.

The correct way of creating a C-string (in C and C++) is:

```c
char buf[N+1] = "1234...N";
```
The C language allows to create a buffer without a null terminator at the end:

```c
char buf[N] = "123...N";
```
Passing such buffer to a function expecting a null-terminated string may result in out-of-bound read or write.

C compilers report `initializer-string for char array is too long` warnings for initializers that are strictly longer than the buffer's size. They do not warn about strings with length equal to the buffer's size. Even despite the fact that both type of initializers produce non-null-terminated strings. That is, the following arrays will be initialized with exactly the same data:

```c
char buf1[3] = "abc";
char buf2[3] = "abcdef";
```
Interestingly, C++ compilers report errors for both cases.


## Recommendation
Increase buffer sizes to include a null-byte at the end. Alternatively, do not specify buffer sizes explicitly, as these could be automatically computed be a compiler.


## Example

```c
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


```
In this example, one function creates a correct C-string (should not be reported) and the other one creates a non-compliant string. The non-null-terminated string will cause a buffer overread during later call to the `printf` function.


## References
* [SEI CERT C Coding Standard "STR11-C. Do not specify the bound of a character array initialized with a string literal"](https://wiki.sei.cmu.edu/confluence/display/c/STR11-C.+Do+not+specify+the+bound+of+a+character+array+initialized+with+a+string+literal)
