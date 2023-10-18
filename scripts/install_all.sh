#!/bin/bash

cmd='QP="{}"; QPD="${QP%/*}"; echo "$QPD"; cd "$QPD"; codeql pack install'

echo "Installing queries and libraries"
find . -name 'qlpack.yml' -path '*/src/*' -exec sh -c "$cmd" \;

echo "Installing tests"
find . -name 'qlpack.yml' -path '*/test/*' -exec sh -c "$cmd" \;
