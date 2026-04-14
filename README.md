# Trail of Bits public CodeQL queries

This repository contains CodeQL queries developed by Trail of Bits and made available to the public. They are part of our ongoing development efforts and are used in our security audits, vulnerability research, and internal projects. They will evolve over time as we identify new techniques.

## Setup

```bash
make download
codeql resolve packs | grep trailofbits
```

See [QUERIES.md](doc/QUERIES.md) for details.

## Usage

```bash
codeql database analyze database.db --format=sarif-latest --output=./tob.sarif -- trailofbits/cpp-queries
codeql database analyze database.db --format=sarif-latest --output=./tob.sarif -- trailofbits/go-queries
codeql database analyze database.db --format=sarif-latest --output=./tob.sarif -- trailofbits/java-queries
```

## Query suites

CodeQL queries are grouped into suites. To execute queries from a specific suite add its name after a colon: `trailofbits/cpp-queries:codeql-suites/tob-cpp-full.qls`.

The recommended suite - `tob-cpp-code-scanning.qls` - is chosen and executed when you do not explicitly specify any suite. Other suites in this repository are:

* `tob-<lang>-crypto.qls` - queries targeting cryptographic vulnerabilities
* `tob-<lang>-security.qls` - queries targeting standard security issues
* `tob-<lang>-full.qls` - all queries, including experimental ones

## Development

### Prepare environment

Configure global CodeQL's search path:

```bash
git clone https://github.com/trailofbits/codeql-queries
mkdir -p "${HOME}/.config/codeql/"
echo "--search-path '$PWD/codeql-queries'" > "${HOME}/.config/codeql/config"

cd codeql-queries/
make pack-install

codeql resolve packs | grep trailofbits
```

### Before committing

```bash
make pack-upgrade
make test format
make generate-table generate-help
```
