# Checking if returned error codes are acted on

Many of the functions comprising the OpenSSL API return an integer error code
where 1 typically signals success, and 0 signals failure. To ensure that the
implementation is secure, these error codes must be checked and acted upon. This
query attempts to identify locations where a returned error code is not checked
by the codebase. In this context, checked means that the return value flows
to the condition of a control-flow statement like an if-statement, a while-
statement, or a switch-statement.

As an example, the following example function fails to check the return value
from `RAND_bytes`, and would be flagged as an issue by the query.

```cpp
void generateEncryptionKey(unsigned char *key, size_t keySize) {
    RAND_bytes(key, keySize);
}
```