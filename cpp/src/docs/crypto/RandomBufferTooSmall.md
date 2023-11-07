# Random buffer too small

This query finds buffer overflows in calls to CSPRNGs like `RAND_bytes`,
`RAND_bytes_ex`, and `RAND_priv_bytes`. It is currently restricted to statically
allocated buffers to allow us to easily determine the input buffer size, but
could easily be extended to dynamically allocated buffers as well.

The following example code would be flagged as vulnerable by the query.

```cpp
#define KEY_SIZE 16

// ...

unsigned char key[KEY_SIZE];
int res = RAND_bytes(key, 32)
```