# Custom allocator leak

This query identifies potential memory leaks from custom allocators like
`BN_new`. 

The following example would be identified by the query as a potential memory
leak.

```cpp
int compute(BIGNUM* a) {
  BIGNUM *b = BN_new();

  // Perform computation on `a` and `b`.

  if (condition(a)) {
    BN_free(b);
    return a;
  }

  // The BIGNUM `b` may leak here.
  return a;
}
```