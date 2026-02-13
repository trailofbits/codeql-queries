# Inconsistent handling of return values from a specific function
When a function's return value is checked in `if` statements across multiple call sites, the comparisons typically fall into a consistent pattern (e.g., compared against a numeric literal, `NULL`, or `sizeof`). If a small number of call sites compare the return value in a different way than the majority, these inconsistent comparisons may indicate a bug.

The query categorizes each comparison into one of the following categories:

* Numeric literal (e.g., `ret != -1`)
* Boolean (e.g., `ret == true`)
* Null pointer (e.g., `ret != NULL`)
* Pointer
* `sizeof` expression (e.g., `ret > sizeof(buf)`)
* Another function's return value (e.g., `ret != other_func()`)
* Passed as argument to another function (e.g., `if (check(ret))`)
* Arithmetic expression

When at least 75% of a function's return value comparisons fall into one category, the remaining comparisons in a different category are flagged as potentially incorrect.


## Recommendation
Review each flagged call site and verify that the comparison matches the function's return value semantics. If the function returns an error code or count, all call sites should compare it consistently. Fix any comparisons that use the wrong type of operand (e.g., comparing an integer return value against `sizeof` when all other sites compare against a numeric literal).


## Example

```c
struct header {
    int type;
    int length;
};

// Returns number of items processed, or -1 on error
int process_items(int *items, int count) {
    int processed = 0;
    for (int i = 0; i < count; i++) {
        if (items[i] < 0)
            return -1;
        processed++;
    }
    return processed;
}

void example() {
    int items[10];
    int result;

    // Typical: return value compared with a numeric literal
    result = process_items(items, 10);
    if (result > 0) { /* success */ }

    result = process_items(items, 5);
    if (result != -1) { /* no error */ }

    result = process_items(items, 3);
    if (result == 0) { /* empty */ }

    result = process_items(items, 8);
    if (result >= 1) { /* at least one */ }

    // BAD: comparing with sizeof instead of a numeric literal.
    // This is inconsistent with all other call sites and likely a bug.
    result = process_items(items, 7);
    if (result > sizeof(struct header)) { /* wrong comparison */ }
}
```
In this example, `process_items` returns the number of items processed or `-1` on error. Most call sites correctly compare the return value with a numeric literal. However, one call site mistakenly compares it with `sizeof(struct header)`, which is inconsistent with how the return value is used everywhere else.


## References
* [CWE-252: Unchecked Return Value](https://cwe.mitre.org/data/definitions/252.html)
* [CWE-253: Incorrect Check of Function Return Value](https://cwe.mitre.org/data/definitions/253.html)
