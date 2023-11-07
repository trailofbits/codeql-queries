# Legacy cryptographic algorithm

This query finds uses of weak or depracated cryptographic algorithms like `MD5`,
`SHA1`, and `DES`. The query will flag calls to functions containing any of the
following names:

  - `MD2`
  - `MD4`
  - `MD5`
  - `RIPEMD`
  - `SHA1`
  - `Streebog`
  - `Whirlpool`

  - `PBKDF1`

  - `Arcfour`
  - `Blowfish`
  - `CAST`
  - `DES`
  - `IDEA`
  - `Kasumi`
  - `Magma`
  - `RC2`
  - `RC4`
  - `TDEA`