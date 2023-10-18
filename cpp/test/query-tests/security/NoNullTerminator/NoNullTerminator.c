#include "../../../include/libc/string_stubs.h"

#define LABEL_BUF_SIZE 8

void good_initializations() {
    // These are correct C-strings
    char xx[3] = "ab";
    printf("%s", xx);
    unsigned char yy[3] = "";
    printf("%s", yy);
    unsigned char aa[3] = "AB\x00";
    printf("%s", aa);
    unsigned char ab[3] = "A\000\000";
    printf("%s", ab);
    unsigned char ac[3] = "\000\000";
    printf("%s", ac);
    unsigned char ad[3] = "\000\000\x00";
    printf("%s", ad);
    wchar_t qq[9] = L"12345678";
    wprintf(L"%ls", qq);
}

// TODO: these are false positives that should not be identified as bug
void good_initializations_explicit_nullbyte() {
    // These are correct C-strings
    char xx[3] = "ab\0";
    printf("%s", xx);
    unsigned char yy[4] = "12\x00""4";
    printf("%s", yy);
    unsigned char aa[3] = "A\000B";
    printf("%s", aa);
    unsigned char ab[8] = "1234\x00""678";
    printf("%s", ab);
    wchar_t qq[8] = L"1234\x00" L"678";
    wprintf(L"%ls", qq);
}

int not_null_terminated_initializations() {
    // These are buffers without null terminators, not C-strings (but "C-string likes")
    char ww[4] = "cdef"; // no warning from compilator
    unsigned char qq[6] = "ghijklllllllll\000"; // warning from compilator
    unsigned char kk[3] = "iop\000\x00"; // warning from compilator
    // Out of bound reads
    printf("%s", ww);
    printf("%s", qq);
    printf("%s", kk);
    return strlen(ww);
}

void not_null_terminated_initializations_widechars() {
    // wide char OOB
    wchar_t secret[] = L"secret";
    wchar_t tt[8] = L"12345678";
    wprintf(L"%ls", tt);

    wchar_t dst[50];
    wcscpy(dst, tt);
    wprintf(L"%ls", dst);
}

void not_a_string() {
    char s[4] = { 'a', 'b', 'c', 'd' }; // valid, but not recommended initialization of not-a-string
    printf("%d", s);
}

int main() {
    good_initializations();
    good_initializations_explicit_nullbyte();
    not_null_terminated_initializations();
    not_null_terminated_initializations_widechars();
    not_a_string();
}

