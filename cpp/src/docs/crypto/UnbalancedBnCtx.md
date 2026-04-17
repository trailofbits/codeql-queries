# Unbalanced BN_CTX_start and BN_CTX_end pair
This query detects unbalanced pairs of `BN_CTX_start` and `BN_CTX_end` calls in OpenSSL code. These functions must be used in matching pairs to properly manage temporary BIGNUM allocations within a `BN_CTX` context.

`BN_CTX_start` marks the beginning of a nested allocation scope, and `BN_CTX_end` releases all temporary BIGNUMs allocated via `BN_CTX_get` since the matching `BN_CTX_start`. Each call to `BN_CTX_start` must have a corresponding `BN_CTX_end` call, and vice versa.

Common issues include:

* Calling `BN_CTX_start` without a corresponding `BN_CTX_end` (memory leak of temporary allocations)
* Calling `BN_CTX_end` without a corresponding `BN_CTX_start` (undefined behavior)
* Missing `BN_CTX_end` in error paths
The following example would be flagged for missing `BN_CTX_end`:

```cpp
int compute(BN_CTX *ctx, BIGNUM *result) {
    BN_CTX_start(ctx);

    BIGNUM *tmp1 = BN_CTX_get(ctx);
    BIGNUM *tmp2 = BN_CTX_get(ctx);

    if (!tmp1 || !tmp2) {
        // ERROR: Missing BN_CTX_end on error path
        return 0;
    }

    // Perform computation

    BN_CTX_end(ctx);
    return 1;
}
```
The correct version ensures `BN_CTX_end` is called on all code paths:

```cpp
int compute(BN_CTX *ctx, BIGNUM *result) {
    BN_CTX_start(ctx);

    BIGNUM *tmp1 = BN_CTX_get(ctx);
    BIGNUM *tmp2 = BN_CTX_get(ctx);

    if (!tmp1 || !tmp2) {
        BN_CTX_end(ctx);  // Properly clean up on error path
        return 0;
    }

    // Perform computation

    BN_CTX_end(ctx);
    return 1;
}
```
