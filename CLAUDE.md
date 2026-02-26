# CodeQL Queries Repository

## CI Checks

CI runs two steps (see `.github/workflows/test.yml`):

1. `make format-check` — verifies all `.ql` and `.qll` files are properly formatted
2. `make test` — runs all CodeQL tests across all languages

After editing any `.ql` or `.qll` file, run format check:
```sh
codeql query format --check-only <file>    # check only
codeql query format --in-place <file>      # auto-fix
```

Or check/fix all files at once:
```sh
make format-check   # check all
make format         # fix all
```

After significant changes (new queries, modified library logic, changed tests), run the full test suite:
```sh
make test
```

To run tests for a single query:
```sh
codeql test run cpp/test/query-tests/security/IteratorInvalidation/
```

## C/C++ Test Stubs

Tests cannot use real system headers. Minimal stub headers live in `cpp/test/include/` organized by library:
- `libc/` — C standard library stubs (signal.h, stdlib.h, string_stubs.h, etc.)
- `stl/` — C++ STL stubs (vector.h, deque.h, unordered_set.h)
- `openssl/` — OpenSSL stubs (evp.h, bn.h, rand.h, etc.)
- `mbedtls/` — mbed TLS stubs (bignum.h)

Stubs use a `USE_HEADERS` guard pattern to optionally fall back to real headers:
```c
#ifndef USE_HEADERS
// ... stub definitions ...
#else
#include <real_header.h>
#endif
```

Test `.cpp` files include stubs via relative paths:
```cpp
#include "../../../include/stl/vector.h"
```

Stubs only need enough declarations for CodeQL to resolve types and function names — no implementations required.

## Updating README Query Tables

When a query is added, removed, or its metadata changes, regenerate the README tables:
```sh
python ./scripts/queries_table_generator.py 2>/dev/null
```

This reads query metadata from all "full" suites and outputs markdown tables. Copy-paste the output into `README.md` under the `## Queries` section.
