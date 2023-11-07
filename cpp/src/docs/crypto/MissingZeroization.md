# Missing zeroization of random BIGNUMs

Randomly generated BIGNUMs often represent sensitive data (e.g. like ECDSA
nonces). These should be cleared as they go out of scope to ensure that
sensitive data does not remain in memory longer than required. 

This query identifies OpenSSL BIGNUMs which are inititialized using `BN_rand`
but not which are not zeroized using `BN_clear` before they go out of scope. The
following example function would be flagged as an issue by the query.

```cpp
void compute() {
    BIGNUM *n = BN_new();
    BN_rand(n, 128, BN_RAND_TOP_ANY, BN_RAND_BOTTOM_ANY);
    
    // Perform sensitive computation using `n`.

    BN_free(n);
}
```

