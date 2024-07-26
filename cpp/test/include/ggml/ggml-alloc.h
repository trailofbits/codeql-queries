#pragma once

#ifdef  __cplusplus
extern "C" {
#endif

#include "ggml.h"

typedef void* ggml_backend_buffer_type_t;
typedef void* ggml_gallocr_t;

ggml_gallocr_t ggml_gallocr_new(ggml_backend_buffer_type_t buft) { return 0; }
ggml_gallocr_t ggml_gallocr_new_n(ggml_backend_buffer_type_t * bufts, int n_bufs) { return 0; }
void           ggml_gallocr_free(ggml_gallocr_t galloc) {}

# ifdef  __cplusplus
}
#endif
