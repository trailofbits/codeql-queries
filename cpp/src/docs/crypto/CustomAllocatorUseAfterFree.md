# Custom allocator use-after-free

This query identifies use-after-frees with custom allocators like `BN_new`.

The following code snippet would be identified as an issue by the query.

```cpp
BIGNUM* compute(BIGNUM* a) {
  BIGNUM *b = BN_new();

  if (condition(a)) {
    // The BIGNUM `b` may be freed here.
    BN_free(b);
  }
  // Potential use-after-free of `b` here.
  if (condition(b)) {
    BN_free(a);
    a = BN_new();
  }

  return b;
}
```
