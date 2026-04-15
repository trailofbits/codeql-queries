# Crypto variable initialized using weak randomness
This query finds crypto variables initialized using weak randomness like process IDs or timestamps.

Limitations: the query does not track weak randomness through a hash function, so keys derived by hashing a weak source are not flagged.

