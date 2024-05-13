import trailofbits.ml.common

/**
 * struct ggml_context * ggml_init(struct ggml_init_params params);
 */
class GGML_init extends Alloc {
    GGML_init() {
        this.getName() = "ggml_init"
    }
}

/**
 * void ggml_free(struct ggml_context * ctx);
 */
class GGML_free extends Free {
    GGML_free() {
        this.getName() = "ggml_free"
    }
}

class ContextAllocator extends CustomAllocator {
    ContextAllocator() {
        this = "ContextAllocator"
    }
    override predicate isAlloc(Function f) {
        f instanceof GGML_init
    }

    override predicate isFree(Function f) {
        f instanceof GGML_free
    }
}