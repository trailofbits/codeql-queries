# Static key flow

This query flags locations where a static buffer is used as an argument to a
function requiring strong, cryptographic level randomness (e.g. an encryption
key).
