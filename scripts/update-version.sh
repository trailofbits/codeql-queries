#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <version>" >&2
	echo "Example: $0 0.4.0" >&2
	exit 1
fi

version="$1"

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "Error: version must be semver (X.Y.Z), got: $version" >&2
	exit 1
fi

packs=(
	cpp/lib/qlpack.yml
	cpp/src/qlpack.yml
	go/src/qlpack.yml
	java/src/qlpack.yml
)

for f in "${packs[@]}"; do
	if [[ ! -f "$f" ]]; then
		echo "Error: file not found: $f (run from repo root)" >&2
		exit 1
	fi
	if ! grep -q '^version: ' "$f"; then
		echo "Error: no 'version:' line in $f" >&2
		exit 1
	fi
done

for f in "${packs[@]}"; do
	tmp="$(mktemp)"
	sed "s/^version: .*/version: $version/" "$f" >"$tmp"
	mv "$tmp" "$f"
	echo "Updated $f -> $version"
done
