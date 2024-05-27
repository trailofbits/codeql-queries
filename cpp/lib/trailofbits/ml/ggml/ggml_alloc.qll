// *********************************************************************
//
//  This library has been automatically generated using the Busy Work
//  VSCode extension from the file 'ggml-alloc.h'.                   
//
// *********************************************************************
import cpp
import trailofbits.common

// *********************************************************************
//
//  Function types matching the individual functions defined by       
//  'ggml-alloc.h'.                                                  
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
 *      ggml_gallocr_t galloc,
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

// *********************************************************************
//
//  Custom allocators defined by 'ggml-alloc.h'.                     
//
// *********************************************************************

/**
 * Alloc:
 *     ggml_gallocr_new
 *
 * Free:
 *     ggml_gallocr_new
 */
class GGMLGraphAllocator extends CustomAllocator {
    GGMLGraphAllocator() { this = "GGMLGraphAllocator" }

    override predicate isAlloc(Alloc f) {
        (f instanceof GGML_gallocr_new) or (f instanceof GGML_gallocr_new_n)
    }

    override predicate isFree(Free f) {
        f instanceof GGML_gallocr_free
    }
}
