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
|[Invalid string size passed to string manipulation function](./cpp/src/docs/security/CStrnFinder/CStrnFinder.md)|Finds calls to functions that take as input a string and its size as separate arguments (e.g., `strncmp`, `strncat`, ...) and the size argument is wrong|error|low|
|[Missing null terminator](./cpp/src/docs/security/NoNullTerminator/NoNullTerminator.md)|This query finds incorrectly initialized strings that are passed to functions expecting null-byte-terminated strings|error|high|
|[Unsafe implicit integer conversion](./cpp/src/docs/security/UnsafeImplicitConversions/UnsafeImplicitConversions.md)|Finds implicit integer casts that may overflow or be truncated, with false positive reduction via Value Range Analysis|warning|low|

### Go

#### Cryptography

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Message not hashed before signature verification](./go/src/docs/crypto/MsgNotHashedBeforeSigVerfication/MsgNotHashedBeforeSigVerfication.md)|Detects calls to (EC)DSA APIs with a message that was not hashed. If the message is longer than the expected hash digest size, it is silently truncated|error|medium|

#### Security

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Invalid file permission parameter](./go/src/docs/security/FilePermsFlaws/FilePermsFlaws.md)|Finds non-octal (e.g., `755` vs `0o755`) and unsupported (e.g., `04666`) literals used as a filesystem permission parameter (`FileMode`)|error|medium|
|[Missing MinVersion in tls.Config](./go/src/docs/security/MissingMinVersionTLS/MissingMinVersionTLS.md)|This rule finds cases when you do not set the `tls.Config.MinVersion` explicitly for servers. By default version 1.0 is used, which is considered insecure. This rule does not mark explicitly set insecure versions|error|medium|
|[Trim functions misuse](./go/src/docs/security/TrimMisuse/TrimMisuse.md)|Finds calls to `string.{Trim,TrimLeft,TrimRight}` with the 2nd argument not being a cutset but a continuous substring to be trimmed|error|low|

### Java-kotlin

#### Security

| Name | Description | Severity | Precision  |
| ---  | ----------- | :----:   | :--------: |
|[Recursive functions](./java-kotlin/src/docs/security/Recursion/Recursion.md)|Detects recursive calls|warning|low|

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
cd codeql-queries
codeql test run ./cpp/test
codeql test run ./go/test
codeql test run ./java/test
```

Update dependencies:
```sh
bash ./scripts/install_all.sh
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
