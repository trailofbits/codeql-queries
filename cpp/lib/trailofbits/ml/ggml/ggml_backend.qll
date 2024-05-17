import cpp
import trailofbits.ml.common

/**
 * GGML_API ggml_backend_buffer_t ggml_backend_buft_alloc_buffer(
 *     ggml_backend_buffer_type_t buft, 
 *     size_t size
 * );
 */
class GGML_backend_buft_alloc_buffer extends Alloc {
    GGML_backend_buft_alloc_buffer() {
        this.getName() = "ggml_backend_buft_alloc_buffer"
    }
}

/**
 * GGML_API void ggml_backend_buffer_free(ggml_backend_buffer_t buffer);
 */
class GGML_backend_buffer_free extends Free {
    GGML_backend_buffer_free() {
        this.getName() = "ggml_backend_buffer_free"
    }
}

/**
 * GGML_API ggml_backend_sched_t ggml_backend_sched_new(
 *     ggml_backend_t * backends, 
 *     ggml_backend_buffer_type_t * bufts, 
 *     int n_backends, 
 *     size_t graph_size, 
 *     bool parallel
 * );
 */
class GGML_backend_sched_new extends Alloc {
    GGML_backend_sched_new() {
        this.getName() = "ggml_backend_sched_new"
    }
}

/**
 * GGML_API void ggml_backend_sched_free(ggml_backend_sched_t sched);
 */
class GGML_backend_sched_free extends Free {
    GGML_backend_sched_free() {
        this.getName() = "ggml_backend_sched_free"
    }
}

/**
 * GGML_API struct ggml_backend_graph_copy ggml_backend_graph_copy(
 *     ggml_backend_t backend, 
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_backend_graph_copy extends Alloc {
    GGML_backend_graph_copy() {
        this.getName() = "ggml_backend_graph_copy"
    }
}

/**
 * GGML_API void ggml_backend_graph_copy_free(struct ggml_backend_graph_copy copy);
 */
class GGML_backend_graph_copy_free extends Free {
    GGML_backend_graph_copy_free() {
        this.getName() = "ggml_backend_graph_copy_free"
    }
}

/**
 * GGML_API ggml_backend_graph_plan_t ggml_backend_graph_plan_create(
 *      ggml_backend_t backend, 
 *      struct ggml_cgraph *cgraph
 * );
 */
class GGML_backend_graph_plan_create extends Alloc {
    GGML_backend_graph_plan_create() {
        this.getName() = "ggml_backend_graph_plan_create"
    }
}

/**
 * GGML_API void ggml_backend_graph_plan_free(
 *     ggml_backend_t backend, 
 *     ggml_backend_graph_plan_t plan
 * );
 */
class GGML_backend_graph_plan_free extends Free {
    GGML_backend_graph_plan_free() {
        this.getName() = "ggml_backend_graph_plan_free"
    }
}

/**
 * GGML_API ggml_backend_event_t ggml_backend_event_new(ggml_backend_t backend);
 */
class GGML_backend_event_new extends Alloc {
    GGML_backend_event_new() {
        this.getName() = "ggml_backend_event_new"
    }
}

/**
 * GGML_API void ggml_backend_event_free(ggml_backend_event_t event);
 */
class GGML_backend_event_free extends Free {
    GGML_backend_event_free() {
        this.getName() = "ggml_backend_event_free"
    }
}

class BackendBufferAllocator extends CustomAllocator {
    BackendBufferAllocator() { this = "BackendBufferAllocator" }
    
    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_buft_alloc_buffer
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_buffer_free
    }
}

class BackendSchedulerAllocator extends CustomAllocator {
    BackendSchedulerAllocator() { this = "BackendSchedulerAllocator" }
    
    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_sched_new
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_sched_free
    }
}

class BackendGraphCopyAllocator extends CustomAllocator {
    BackendGraphCopyAllocator() { this = "BackendGraphCopyAllocator" }
    
    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_graph_copy
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_graph_copy_free
    }
}

class BackendGraphPlanAllocator extends CustomAllocator {
    BackendGraphPlanAllocator() { this = "BackendGraphPlanAllocator" }
    
    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_graph_plan_create
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_graph_plan_free
    }
}

class BackendEventAllocator extends CustomAllocator {
    BackendEventAllocator() { this = "BackendEventAllocator" }
    
    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_event_new
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_event_free
    } 
}