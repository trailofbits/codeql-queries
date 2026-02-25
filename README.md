# Trail of Bits public CodeQL queries

This repository contains CodeQL queries developed by Trail of Bits and made available to the public. They are part of our ongoing development efforts and are used in our security audits, vulnerability research, and internal projects. They will evolve over time as we identify new techniques.

## Using custom CodeQL queries

The easiest is to [download all packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/publishing-and-using-codeql-packs#running-codeql-pack-download-scopepack) from the GitHub registry:
```sh
codeql pack download trailofbits/cpp-queries trailofbits/go-queries
```

Then verify that new queries are installed:
```sh
codeql resolve qlpacks | grep trailofbits
```

And use the queries for analysis:
```sh
codeql database analyze database.db --format=sarif-latest --output=./tob.sarif -- trailofbits/cpp-queries
# or
codeql database analyze database.db --format=sarif-latest --output=./tob.sarif -- trailofbits/go-queries
```

## Queries

### C and C++

#### Cryptography

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[BN_CTX_free called before BN_CTX_end](./cpp/src/docs/crypto/BnCtxFreeBeforeEnd.md)|Detects BN_CTX_free called before BN_CTX_end, which violates the required lifecycle|error|medium|
|[Unbalanced BN_CTX_start and BN_CTX_end pair](./cpp/src/docs/crypto/UnbalancedBnCtx.md)|Detects if one call in the BN_CTX_start/BN_CTX_end pair is missing|warning|medium|
|[Crypto variable initialized using static key](./cpp/src/docs/crypto/StaticKeyFlow.md)|Finds crypto variables initialized using static keys|error|high|
|[Crypto variable initialized using static password](./cpp/src/docs/crypto/StaticPasswordFlow.md)|Finds crypto variables initialized using static passwords|error|high|
|[Crypto variable initialized using weak randomness](./cpp/src/docs/crypto/WeakRandomnessTaint.md)|Finds crypto variables initialized using weak randomness|error|high|
|[Invalid key size](./cpp/src/docs/crypto/InvalidKeySize.md)|Tests if keys passed to EVP_EncryptInit and EVP_EncryptInit_ex have the same size as the key size of the cipher used|warning|medium|
|[Memory leak related to custom allocator](./cpp/src/docs/crypto/CustomAllocatorLeak.md)|Finds memory leaks from custom allocated memory|warning|medium|
|[Memory use after free related to custom allocator](./cpp/src/docs/crypto/CustomAllocatorUseAfterFree.md)|Finds use-after-frees related to custom allocators like `BN_new`|warning|medium|
|[Missing OpenSSL engine initialization](./cpp/src/docs/crypto/MissingEngineInit.md)|Finds created OpenSSL engines that may not be properly initialized|warning|medium|
|[Missing error handling](./cpp/src/docs/crypto/MissingErrorHandling.md)|Checks if returned error codes are properly checked|warning|high|
|[Missing zeroization of potentially sensitive random BIGNUM](./cpp/src/docs/crypto/MissingZeroization.md)|Determines if random bignums are properly zeroized|warning|medium|
|[Random buffer too small](./cpp/src/docs/crypto/RandomBufferTooSmall.md)|Finds buffer overflows in calls to CSPRNGs|warning|high|
|[Use of legacy cryptographic algorithm](./cpp/src/docs/crypto/UseOfLegacyAlgorithm.md)|Detects potential instantiations of legacy cryptographic algorithms|warning|medium|

#### Security

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Async unsafe signal handler](./cpp/src/docs/security/AsyncUnsafeSignalHandler/AsyncUnsafeSignalHandler.md)|Async unsafe signal handler (like the one used in CVE-2024-6387)|warning|high|
|[Decrementation overflow when comparing](./cpp/src/docs/security/DecOverflowWhenComparing/DecOverflowWhenComparing.md)|This query finds unsigned integer overflows resulting from unchecked decrementation during comparison.|error|high|
|[Find all problematic implicit casts](./cpp/src/docs/security/UnsafeImplicitConversions/UnsafeImplicitConversions.md)|Find all implicit casts that may be problematic. That is, casts that may result in unexpected truncation, reinterpretation or widening of values.|error|high|
|[Inconsistent handling of return values from a specific function](./cpp/src/docs/security/InconsistentReturnValueHandling/InconsistentReturnValueHandling.md)|Detects functions whose return values are compared inconsistently across call sites, which may indicate bugs|warning|medium|
|[Invalid string size passed to string manipulation function](./cpp/src/docs/security/CStrnFinder/CStrnFinder.md)|Finds calls to functions that take as input a string and its size as separate arguments (e.g., `strncmp`, `strncat`, ...) and the size argument is wrong|error|low|
|[Missing null terminator](./cpp/src/docs/security/NoNullTerminator/NoNullTerminator.md)|This query finds incorrectly initialized strings that are passed to functions expecting null-byte-terminated strings|error|high|

### Go

#### Cryptography

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Message not hashed before signature verification](./go/src/docs/crypto/MsgNotHashedBeforeSigVerfication/MsgNotHashedBeforeSigVerfication.md)|Detects calls to (EC)DSA APIs with a message that was not hashed. If the message is longer than the expected hash digest size, it is silently truncated|error|medium|

#### Security

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Invalid file permission parameter](./go/src/docs/security/FilePermsFlaws/FilePermsFlaws.md)|Finds non-octal (e.g., `755` vs `0o755`) and unsupported (e.g., `04666`) literals used as a filesystem permission parameter (`FileMode`)|error|medium|
|[Missing MinVersion in tls.Config](./go/src/docs/security/MissingMinVersionTLS/MissingMinVersionTLS.md)|Finds uses of tls.Config where MinVersion is not set and the project's minimum Go version (from go.mod) indicates insecure defaults: Go < 1.18 for clients or Go < 1.22 for servers. Does not mark explicitly set versions (including explicitly insecure ones).|error|medium|
|[Trim functions misuse](./go/src/docs/security/TrimMisuse/TrimMisuse.md)|Finds calls to `string.{Trim,TrimLeft,TrimRight}` with the 2nd argument not being a cutset but a continuous substring to be trimmed|error|low|

### Java-kotlin

#### Security

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Recursive functions](./java-kotlin/src/docs/security/Recursion/Recursion.md)|Detects possibly unbounded recursive calls|warning|low|

## Query suites

CodeQL queries are grouped into "suites". To execute queries from a specific suit add its name after a colon: `trailofbits/cpp-queries:codeql-suites/tob-cpp-full.qls`.

The recommended suit - `tob-cpp-code-scanning.qls` - is chosen and executed when you do not explicitly specify any suit. Other suits in this repository are:

* `tob-<lang>-crypto.qls` - queries targeting cryptographic vulnerabilities
* `tob-<lang>-security.qls` - queries targeting standard security issues
* `tob-<lang>-full.qls` - all queries, including experimental ones

## Development

#### Prepare environment

Clone this repository and configure global CodeQL's search path:
```sh
git clone git@github.com:trailofbits/codeql-queries.git
mkdir -p "${HOME}/.config/codeql/"
echo "--search-path '$PWD/codeql-queries'" > "${HOME}/.config/codeql/config"
```

Check that CodeQL CLI detects the new qlpacks:
```sh
codeql resolve packs | grep trailofbits
```

#### Before committing

Run tests:

```sh
make test
```

Format queries:

```sh
make format
```

Install dependencies:

```sh
make install
```

Generate query tables and copy-paste it to README.md file
```sh
python ./scripts/queries_table_generator.py 2>/dev/null
```

Generate markdown query help files
```sh
codeql generate query-help ./cpp/src/ --format=markdown --output ./cpp/src/docs
codeql generate query-help ./go/src/ --format=markdown --output ./go/src/docs
codeql generate query-help ./java/src/ --format=markdown --output ./java/src/docs
```
