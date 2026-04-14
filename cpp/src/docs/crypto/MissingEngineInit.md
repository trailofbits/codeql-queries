# Missing engine initialization

This query identifies loaded OpenSSL engines which are not passed to both
`ENGINE_init` and `ENGINE_set_default`. `ENGINE_init` should always be called
when a new engine is loaded. It is generally good practise to also call
`ENGINE_set_default` to ensure that the primitives defined by the engine are
used by default.

The following code snippet would be flagged as an issue by the query.

```cpp
ENGINE* load_rdrand() {
    return ENGINE_by_id("rdrand");
}
```