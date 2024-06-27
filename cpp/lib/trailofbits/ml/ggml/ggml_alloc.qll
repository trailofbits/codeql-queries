// *********************************************************************
//
//  This library has been automatically generated using the QLL Writer
//  VSCode extension from the the file ggml-alloc.h
//
// *********************************************************************
import cpp
import trailofbits.common

// *********************************************************************
//
//  Function types matching the individual functions defined in       
//  ggml-alloc.h
//
// *********************************************************************

/**
 * GGML_API struct ggml_tallocr ggml_tallocr_new(ggml_backend_buffer_t buffer);
 */
class GGML_tallocr_new extends MustUse {
    GGML_tallocr_new() {
        this.getName() = "ggml_tallocr_new"
    }
}

/**
 * GGML_API void ggml_tallocr_alloc(
 *     struct ggml_tallocr * talloc,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_tallocr_alloc extends Function {
    GGML_tallocr_alloc() {
        this.getName() = "ggml_tallocr_alloc"
    }
}

/**
 * GGML_API ggml_gallocr_t ggml_gallocr_new(ggml_backend_buffer_type_t buft);
 */
class GGML_gallocr_new extends Alloc {
    GGML_gallocr_new() {
        this.getName() = "ggml_gallocr_new"
    }
}

/**
 * GGML_API ggml_gallocr_t ggml_gallocr_new_n(
 *     ggml_backend_buffer_type_t * bufts,
 *     int n_bufs
 * );
 */
class GGML_gallocr_new_n extends Alloc {
    GGML_gallocr_new_n() {
        this.getName() = "ggml_gallocr_new_n"
    }
}

/**
 * GGML_API void ggml_gallocr_free(ggml_gallocr_t galloc);
 */
class GGML_gallocr_free extends Free {
    GGML_gallocr_free() {
        this.getName() = "ggml_gallocr_free"
    }
}

/**
 * GGML_API bool ggml_gallocr_reserve(
 *     ggml_gallocr_t galloc,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_gallocr_reserve extends MustUse {
    GGML_gallocr_reserve() {
        this.getName() = "ggml_gallocr_reserve"
    }
}

/**
 * GGML_API bool ggml_gallocr_reserve_n(
 *     ggml_gallocr_t galloc,
 *     struct ggml_cgraph * graph,
 *     const int * node_buffer_ids,
 *     const int * leaf_buffer_ids
 * );
 */
class GGML_gallocr_reserve_n extends MustUse {
    GGML_gallocr_reserve_n() {
        this.getName() = "ggml_gallocr_reserve_n"
    }
}

/**
 * GGML_API bool ggml_gallocr_alloc_graph(
 *     ggml_gallocr_t galloc,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_gallocr_alloc_graph extends MustUse {
    GGML_gallocr_alloc_graph() {
        this.getName() = "ggml_gallocr_alloc_graph"
    }
}

/**
 * GGML_API size_t ggml_gallocr_get_buffer_size(
 *     ggml_gallocr_t galloc,
 *     int buffer_id
 * );
 */
class GGML_gallocr_get_buffer_size extends MustUse {
    GGML_gallocr_get_buffer_size() {
        this.getName() = "ggml_gallocr_get_buffer_size"
    }
}

/**
 * GGML_API struct ggml_backend_buffer * ggml_backend_alloc_ctx_tensors_from_buft(
 *     struct ggml_context * ctx,
 *     ggml_backend_buffer_type_t buft
 * );
 */
class GGML_backend_alloc_ctx_tensors_from_buft extends MustCheck {
    GGML_backend_alloc_ctx_tensors_from_buft() {
        this.getName() = "ggml_backend_alloc_ctx_tensors_from_buft"
    }
}

/**
 * GGML_API struct ggml_backend_buffer * ggml_backend_alloc_ctx_tensors(
 *     struct ggml_context * ctx,
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_alloc_ctx_tensors extends MustCheck {
    GGML_backend_alloc_ctx_tensors() {
        this.getName() = "ggml_backend_alloc_ctx_tensors"
    }
}

// *********************************************************************
//
//  Custom allocators defined in ggml-alloc.h
//
// *********************************************************************

/**
 * GGML_gallocr_allocator
 *
 * Allocation functions:
 *   - ggml_gallocr_new
 *   - ggml_gallocr_new_n
 *
 * Deallocation functions:
 *   - ggml_gallocr_free
 */
class GGML_gallocr_allocator extends CustomAllocator {
    GGML_gallocr_allocator() { this = "GGML_gallocr_allocator" }

    override predicate isAlloc(Alloc f) {
        (f instanceof GGML_gallocr_new) or (f instanceof GGML_gallocr_new_n)
    }

    override predicate isFree(Free f) {
        f instanceof GGML_gallocr_free
    }
}
