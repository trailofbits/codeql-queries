# BN_CTX_free called before BN_CTX_end
This query identifies instances where `BN_CTX_free` is called before `BN_CTX_end`, which violates the required lifecycle of OpenSSL's `BN_CTX` objects.

In OpenSSL, the proper lifecycle for using `BN_CTX` with nested allocations is:

1. `BN_CTX_start(ctx)` - marks the start of a nested allocation
1. Use `BN_CTX_get(ctx)` to get temporary BIGNUMs
1. `BN_CTX_end(ctx)` - releases the temporary BIGNUMs allocated since the matching `BN_CTX_start`
1. `BN_CTX_free(ctx)` - frees the entire context
Calling `BN_CTX_free` before `BN_CTX_end` can lead to corrupted state or undefined behavior, as temporary BIGNUMs allocated via `BN_CTX_get` are not properly released.

The following example would be flagged as an issue by the query:

```cpp
void compute(BIGNUM *result) {
    BN_CTX *ctx = BN_CTX_new();
    BN_CTX_start(ctx);

    BIGNUM *tmp = BN_CTX_get(ctx);
    // Perform computation using tmp

    // ERROR: BN_CTX_free called without calling BN_CTX_end first
    BN_CTX_free(ctx);
}
```
The correct version should call `BN_CTX_end` before `BN_CTX_free`:

```cpp
void compute(BIGNUM *result) {
    BN_CTX *ctx = BN_CTX_new();
    BN_CTX_start(ctx);

    BIGNUM *tmp = BN_CTX_get(ctx);
    // Perform computation using tmp

    BN_CTX_end(ctx);  // Properly release temporary BIGNUMs
    BN_CTX_free(ctx); // Now safe to free the context
}
```
