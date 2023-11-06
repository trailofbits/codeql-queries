#!/usr/bin/env sh

mkdir _tests && cd _tests || exit
codeql test run --search-path=.. ../test
cd ..
rm -rf _tests
