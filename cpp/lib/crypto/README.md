# Overview

This directory contains CodeQL base types targeted at C and C++
cryptographic implementations. The code is organized as follows:

  - `common`: Common, abstract base types used for general queries. These are collected
    in the QL library `common.qll`.
  - `libraries`: Library specific implementations of abstract base types
    defined under `common`. The library currently contains concrete
    implementations for parts of the `OpenSSL` and `mbedtls` libraries. Each
    library exposes a `<LIBRARY NAME>.qll` library which can be
    imported to target that specific library. When targeting all libraries,
    import `libraries.qll`.

A goal of this project is to attempt to define reusable, abstract base types
with enough expressive power to describe many common cryptographic
vulnerabilities across many different implementations. This is still very much
a work in progress which means that the structure and definitions of these
types will most likely change over time.
