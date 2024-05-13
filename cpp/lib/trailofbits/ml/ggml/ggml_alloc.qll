import trailofbits.ml.common

/**
 * GGML_API ggml_gallocr_t ggml_gallocr_new(ggml_backend_buffer_type_t buft);
 * 
 * The allocator guarantees that the return value and internal fields are not NULL.
 */
class GGML_gallocr_new extends Alloc {
    GGML_gallocr_new() { this.getName() = "ggml_gallocr_new" }
}

/**
 * GGML_API ggml_gallocr_t ggml_gallocr_new_n(ggml_backend_buffer_type_t * bufts, int n_bufs);
 */
class GGML_gallocr_new_n extends Alloc { 
    GGML_gallocr_new_n() { this.getName() = "ggml_gallocr_new_n" }
}

/**
 * GGML_API void ggml_gallocr_free(ggml_gallocr_t galloc);
 */
class GGML_gallocr_free extends Free {
    GGML_gallocr_free() { this.getName() = "ggml_gallocr_free" }
}

/**
 * GGML_API bool ggml_gallocr_alloc_graph(ggml_gallocr_t galloc, struct ggml_cgraph * graph);
 */
class GGML_gallocr_alloc_graph extends MustCheck {
    GGML_gallocr_alloc_graph() { this.getName() = "ggml_gallocr_alloc_graph" }
}

/**
 * GGML_API bool ggml_gallocr_reserve(ggml_gallocr_t galloc, struct ggml_cgraph * graph);
 */
class GGML_gallocr_reserve extends MustCheck {
    GGML_gallocr_reserve() { this.getName() = "ggml_gallocr_reserve" }
} 

/**
 * GGML_API bool ggml_gallocr_reserve_n(
 *     ggml_gallocr_t galloc,
 *     struct ggml_cgraph * graph,
 *     const int * node_buffer_ids,
 *     const int * leaf_buffer_ids);
 */
class GGML_gallocr_reserve_n extends MustCheck {
    GGML_gallocr_reserve_n() { this.getName() = "ggml_gallocr_reserve_n" }
}

/**
 * GGML_API size_t ggml_gallocr_get_buffer_size(ggml_gallocr_t galloc, int buffer_id);
 */
class GGML_gallocr_get_buffer_size extends MustUse {
    GGML_gallocr_get_buffer_size() { this.getName() = "ggml_gallocr_get_buffer_size" }
}

class GraphAllocator extends CustomAllocator {
    GraphAllocator() { this = "GraphAllocator" }
    
    override predicate isAlloc(Alloc f) {
        (f instanceof GGML_gallocr_new) or (f instanceof GGML_gallocr_new_n)
    }

    override predicate isFree(Free f) {
        f instanceof GGML_gallocr_free
    }
}