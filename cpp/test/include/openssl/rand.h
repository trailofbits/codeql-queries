/*
 * This file defines stub implementations for the OpenSSL randomness API.
 */

#ifndef HEADER_RAND_STUB_H
#define HEADER_RAND_STUB_H

#ifdef  __cplusplus
extern "C" {
#endif

void RAND_seed(const void *buf, int num) {
}

void RAND_add(const void *buf, int num, double randomness) {
}

int RAND_bytes(unsigned char *buf, int num) {
    return 1;
}

int RAND_priv_bytes(unsigned char *buf, int num) {
    return 1;
}

#ifdef  __cplusplus
}
#endif

#endif

