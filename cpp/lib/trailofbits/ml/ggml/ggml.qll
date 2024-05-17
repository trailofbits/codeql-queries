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

/**
 * GGML_API struct gguf_context * gguf_init_empty(void);
 */
class GGUF_init_empty extends Alloc {
    GGUF_init_empty() {
        this.getName() = "gguf_init_empty"
    }
}

/**
 * GGML_API struct gguf_context * gguf_init_from_file(
 *     const char * fname, 
 *     struct gguf_init_params params
 * );
 */
class GGUF_init_from_file extends Alloc {
    GGUF_init_from_file() {
        this.getName() = "gguf_init_from_file"
    }
}

/**
 * GGML_API void gguf_free(struct gguf_context * ctx);
 */
class GGUF_free extends Free {
    GGUF_free() {
        this.getName() = "gguf_free"
    }
}

class GGMLContextAllocator extends CustomAllocator {
    GGMLContextAllocator() {
        this = "GGMLContextAllocator"
    }
    override predicate isAlloc(Alloc f) {
        // TODO: Overload `isAllocatedBy` to check if the `mem_buffer` field is
        // not `NULL`.
        f instanceof GGML_init
    }

    override predicate isFree(Free f) {
        f instanceof GGML_free
    }
}

class GGUFContextAllocator extends CustomAllocator {
    GGUFContextAllocator() {
        this = "GGUFContextAllocator"
    }
    override predicate isAlloc(Alloc f) {
        (f instanceof GGUF_init_empty) or (f instanceof GGUF_init_from_file)
    }

    override predicate isFree(Free f) {
        f instanceof GGUF_free
    } 
}