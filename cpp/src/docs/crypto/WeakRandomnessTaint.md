# Weak randomness taint

This query finds crypto variables initialized using weak randomness like process
IDs or timestamps.

A long-term goal is to be able to find locations where weak randomness is hashed
to create cryptographic keys. This requires taint flow from hash function inputs
to the digest, which is currently not supported.
