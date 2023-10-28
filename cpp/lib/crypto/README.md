# Overview

This directory contains CodeQL base types targeted at C and C++
cryptographic implementations. The code is organized as follows:

  - `common`: Common, abstract base types used for general queries. These are
    collected in the QL library `common.qll`.
  - `openssl`: OpenSSL specific implementations of abstract base types
    defined under `common`. These are exposed by importing `openssl.qll`.
  - `mbedtls`: Mbedtls specific implementations of abstract base types
    defined under `common`. These are exposed by importing `mbedtls.qll`.

A goal of this project is to attempt to define reusable, abstract base types
with enough expressive power to describe many common cryptographic
vulnerabilities across different implementations. This is still very much
a work in progress which means that the structure and definitions of these
types will most likely change over time.

This repository contains a number of queries built on top of the primitives
defined here. These can be found under [`cpp/src/crypto`](../../src/crypto).
