// *********************************************************************
//
//  This library has been automatically generated using the Busy Work
//  VSCode extension from the file 'ggml-backend.h'.                 
//
// *********************************************************************
import cpp
import trailofbits.common

// *********************************************************************
//
//  Function types matching the individual functions defined by       
//  'ggml-backend.h'.                                                
//
// *********************************************************************

/**
 * GGML_API GGML_CALL ggml_backend_buffer_t ggml_backend_buft_alloc_buffer (
 *     ggml_backend_buffer_type_t buft,
 *     size_t size
 * );
 */
class GGML_backend_buft_alloc_buffer extends MustUse {
    GGML_backend_buft_alloc_buffer() {
        this.getName() = "ggml_backend_buft_alloc_buffer"
    }
}

/**
 * GGML_API size_t ggml_backend_buft_get_alignment (
 *     ggml_backend_buffer_type_t buft
 * );
 */
class GGML_backend_buft_get_alignment extends MustUse {
    GGML_backend_buft_get_alignment() {
        this.getName() = "ggml_backend_buft_get_alignment"
    }
}

/**
 * GGML_API size_t ggml_backend_buft_get_max_size (
 *     ggml_backend_buffer_type_t buft
 * );
 */
class GGML_backend_buft_get_max_size extends MustUse {
    GGML_backend_buft_get_max_size() {
        this.getName() = "ggml_backend_buft_get_max_size"
    }
}

/**
 * GGML_API GGML_CALL size_t ggml_backend_buft_get_alloc_size (
 *     ggml_backend_buffer_type_t buft,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_backend_buft_get_alloc_size extends MustUse {
    GGML_backend_buft_get_alloc_size() {
        this.getName() = "ggml_backend_buft_get_alloc_size"
    }
}

/**
 * GGML_API bool ggml_backend_buft_supports_backend(
 *     ggml_backend_buffer_type_t buft,
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_buft_supports_backend extends MustUse {
    GGML_backend_buft_supports_backend() {
        this.getName() = "ggml_backend_buft_supports_backend"
    }
}

/**
 * GGML_API bool ggml_backend_buft_is_host (ggml_backend_buffer_type_t buft);
 */
class GGML_backend_buft_is_host extends MustUse {
    GGML_backend_buft_is_host() {
        this.getName() = "ggml_backend_buft_is_host"
    }
}

/**
 * GGML_API void ggml_backend_buffer_free (ggml_backend_buffer_t buffer);
 */
class GGML_backend_buffer_free extends Function {
    GGML_backend_buffer_free() {
        this.getName() = "ggml_backend_buffer_free"
    }
}

/**
 * GGML_API size_t ggml_backend_buffer_get_size (ggml_backend_buffer_t buffer);
 */
class GGML_backend_buffer_get_size extends MustUse {
    GGML_backend_buffer_get_size() {
        this.getName() = "ggml_backend_buffer_get_size"
    }
}

/**
 * GGML_API GGML_CALL void ggml_backend_buffer_init_tensor (
 *     ggml_backend_buffer_t buffer,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_backend_buffer_init_tensor extends Function {
    GGML_backend_buffer_init_tensor() {
        this.getName() = "ggml_backend_buffer_init_tensor"
    }
}

/**
 * GGML_API size_t ggml_backend_buffer_get_alignment (
 *     ggml_backend_buffer_t buffer
 * );
 */
class GGML_backend_buffer_get_alignment extends MustUse {
    GGML_backend_buffer_get_alignment() {
        this.getName() = "ggml_backend_buffer_get_alignment"
    }
}

/**
 * GGML_API size_t ggml_backend_buffer_get_max_size (
 *     ggml_backend_buffer_t buffer
 * );
 */
class GGML_backend_buffer_get_max_size extends MustUse {
    GGML_backend_buffer_get_max_size() {
        this.getName() = "ggml_backend_buffer_get_max_size"
    }
}

/**
 * GGML_API size_t ggml_backend_buffer_get_alloc_size(
 *     ggml_backend_buffer_t buffer,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_backend_buffer_get_alloc_size extends MustUse {
    GGML_backend_buffer_get_alloc_size() {
        this.getName() = "ggml_backend_buffer_get_alloc_size"
    }
}

/**
 * GGML_API void ggml_backend_buffer_clear (
 *     ggml_backend_buffer_t buffer,
 *     uint8_t value
 * );
 */
class GGML_backend_buffer_clear extends Function {
    GGML_backend_buffer_clear() {
        this.getName() = "ggml_backend_buffer_clear"
    }
}

/**
 * GGML_API bool ggml_backend_buffer_is_host (ggml_backend_buffer_t buffer);
 */
class GGML_backend_buffer_is_host extends MustUse {
    GGML_backend_buffer_is_host() {
        this.getName() = "ggml_backend_buffer_is_host"
    }
}

/**
 * GGML_API void ggml_backend_buffer_set_usage (
 *     ggml_backend_buffer_t buffer,
 *     enum ggml_backend_buffer_usage usage
 * );
 */
class GGML_backend_buffer_set_usage extends Function {
    GGML_backend_buffer_set_usage() {
        this.getName() = "ggml_backend_buffer_set_usage"
    }
}

/**
 * GGML_API ggml_backend_buffer_type_t ggml_backend_buffer_get_type (
 *     ggml_backend_buffer_t buffer
 * );
 */
class GGML_backend_buffer_get_type extends MustUse {
    GGML_backend_buffer_get_type() {
        this.getName() = "ggml_backend_buffer_get_type"
    }
}

/**
 * GGML_API void ggml_backend_buffer_reset (ggml_backend_buffer_t buffer);
 */
class GGML_backend_buffer_reset extends Function {
    GGML_backend_buffer_reset() {
        this.getName() = "ggml_backend_buffer_reset"
    }
}

/**
 * GGML_API ggml_guid_t ggml_backend_guid(ggml_backend_t backend);
 */
class GGML_backend_guid extends MustUse {
    GGML_backend_guid() {
        this.getName() = "ggml_backend_guid"
    }
}

/**
 * GGML_API void ggml_backend_free(ggml_backend_t backend);
 */
class GGML_backend_free extends Function {
    GGML_backend_free() {
        this.getName() = "ggml_backend_free"
    }
}

/**
 * GGML_API ggml_backend_buffer_type_t ggml_backend_get_default_buffer_type(
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_get_default_buffer_type extends MustUse {
    GGML_backend_get_default_buffer_type() {
        this.getName() = "ggml_backend_get_default_buffer_type"
    }
}

/**
 * GGML_API ggml_backend_buffer_t ggml_backend_alloc_buffer(
 *     ggml_backend_t backend,
 *     size_t size
 * );
 */
class GGML_backend_alloc_buffer extends MustUse {
    GGML_backend_alloc_buffer() {
        this.getName() = "ggml_backend_alloc_buffer"
    }
}

/**
 * GGML_API size_t ggml_backend_get_alignment(ggml_backend_t backend);
 */
class GGML_backend_get_alignment extends MustUse {
    GGML_backend_get_alignment() {
        this.getName() = "ggml_backend_get_alignment"
    }
}

/**
 * GGML_API size_t ggml_backend_get_max_size(ggml_backend_t backend);
 */
class GGML_backend_get_max_size extends MustUse {
    GGML_backend_get_max_size() {
        this.getName() = "ggml_backend_get_max_size"
    }
}

/**
 * GGML_API void ggml_backend_tensor_set_async(
 *     ggml_backend_t backend,
 *     struct ggml_tensor * tensor,
 *     const void * data,
 *     size_t offset,
 *     size_t size
 * );
 */
class GGML_backend_tensor_set_async extends Function {
    GGML_backend_tensor_set_async() {
        this.getName() = "ggml_backend_tensor_set_async"
    }
}

/**
 * GGML_API void ggml_backend_tensor_get_async(
 *     ggml_backend_t backend,
 *     const struct ggml_tensor * tensor,
 *     void * data,
 *     size_t offset,
 *     size_t size
 * );
 */
class GGML_backend_tensor_get_async extends Function {
    GGML_backend_tensor_get_async() {
        this.getName() = "ggml_backend_tensor_get_async"
    }
}

/**
 * GGML_API GGML_CALL void ggml_backend_tensor_set(
 *      struct ggml_tensor * tensor,
 *     const void * data,
 *     size_t offset,
 *     size_t size
 * );
 */
class GGML_backend_tensor_set extends Function {
    GGML_backend_tensor_set() {
        this.getName() = "ggml_backend_tensor_set"
    }
}

/**
 * GGML_API GGML_CALL void ggml_backend_tensor_get(
 *     const struct ggml_tensor * tensor,
 *     void * data,
 *     size_t offset,
 *     size_t size
 * );
 */
class GGML_backend_tensor_get extends Function {
    GGML_backend_tensor_get() {
        this.getName() = "ggml_backend_tensor_get"
    }
}

/**
 * GGML_API void ggml_backend_synchronize(ggml_backend_t backend);
 */
class GGML_backend_synchronize extends Function {
    GGML_backend_synchronize() {
        this.getName() = "ggml_backend_synchronize"
    }
}

/**
 * GGML_API ggml_backend_graph_plan_t ggml_backend_graph_plan_create(
 *     ggml_backend_t backend,
 *     struct ggml_cgraph * cgraph
 * );
 */
class GGML_backend_graph_plan_create extends MustUse {
    GGML_backend_graph_plan_create() {
        this.getName() = "ggml_backend_graph_plan_create"
    }
}

/**
 * GGML_API void ggml_backend_graph_plan_free (
 *     ggml_backend_t backend,
 *     ggml_backend_graph_plan_t plan
 * );
 */
class GGML_backend_graph_plan_free extends Function {
    GGML_backend_graph_plan_free() {
        this.getName() = "ggml_backend_graph_plan_free"
    }
}

/**
 * GGML_API enum ggml_status ggml_backend_graph_plan_compute (
 *     ggml_backend_t backend,
 *     ggml_backend_graph_plan_t plan
 * );
 */
class GGML_backend_graph_plan_compute extends MustUse {
    GGML_backend_graph_plan_compute() {
        this.getName() = "ggml_backend_graph_plan_compute"
    }
}

/**
 * GGML_API enum ggml_status ggml_backend_graph_compute (
 *     ggml_backend_t backend,
 *     struct ggml_cgraph * cgraph
 * );
 */
class GGML_backend_graph_compute extends MustUse {
    GGML_backend_graph_compute() {
        this.getName() = "ggml_backend_graph_compute"
    }
}

/**
 * GGML_API enum ggml_status ggml_backend_graph_compute_async(
 *     ggml_backend_t backend,
 *     struct ggml_cgraph * cgraph
 * );
 */
class GGML_backend_graph_compute_async extends MustUse {
    GGML_backend_graph_compute_async() {
        this.getName() = "ggml_backend_graph_compute_async"
    }
}

/**
 * GGML_API bool ggml_backend_supports_op(
 *     ggml_backend_t backend,
 *     const struct ggml_tensor * op
 * );
 */
class GGML_backend_supports_op extends MustUse {
    GGML_backend_supports_op() {
        this.getName() = "ggml_backend_supports_op"
    }
}

/**
 * GGML_API bool ggml_backend_offload_op(
 *     ggml_backend_t backend,
 *     const struct ggml_tensor * op
 * );
 */
class GGML_backend_offload_op extends MustUse {
    GGML_backend_offload_op() {
        this.getName() = "ggml_backend_offload_op"
    }
}

/**
 * GGML_API void ggml_backend_tensor_copy(
 *     struct ggml_tensor * src,
 *     struct ggml_tensor * dst
 * );
 */
class GGML_backend_tensor_copy extends Function {
    GGML_backend_tensor_copy() {
        this.getName() = "ggml_backend_tensor_copy"
    }
}

/**
 * GGML_API void ggml_backend_tensor_copy_async(
 *     ggml_backend_t backend_src,
 *     ggml_backend_t backend_dst,
 *     struct ggml_tensor * src,
 *     struct ggml_tensor * dst
 * );
 */
class GGML_backend_tensor_copy_async extends Function {
    GGML_backend_tensor_copy_async() {
        this.getName() = "ggml_backend_tensor_copy_async"
    }
}

/**
 * GGML_API ggml_backend_event_t ggml_backend_event_new (
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_event_new extends Alloc {
    GGML_backend_event_new() {
        this.getName() = "ggml_backend_event_new"
    }
}

/**
 * GGML_API void ggml_backend_event_free (ggml_backend_event_t event);
 */
class GGML_backend_event_free extends Free {
    GGML_backend_event_free() {
        this.getName() = "ggml_backend_event_free"
    }
}

/**
 * GGML_API void ggml_backend_event_record (ggml_backend_event_t event);
 */
class GGML_backend_event_record extends Function {
    GGML_backend_event_record() {
        this.getName() = "ggml_backend_event_record"
    }
}

/**
 * GGML_API void ggml_backend_event_synchronize(ggml_backend_event_t event);
 */
class GGML_backend_event_synchronize extends Function {
    GGML_backend_event_synchronize() {
        this.getName() = "ggml_backend_event_synchronize"
    }
}

/**
 * GGML_API void ggml_backend_event_wait (
 *     ggml_backend_t backend,
 *     ggml_backend_event_t event
 * );
 */
class GGML_backend_event_wait extends Function {
    GGML_backend_event_wait() {
        this.getName() = "ggml_backend_event_wait"
    }
}

/**
 * GGML_API ggml_backend_t ggml_backend_cpu_init(void);
 */
class GGML_backend_cpu_init extends MustUse {
    GGML_backend_cpu_init() {
        this.getName() = "ggml_backend_cpu_init"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_backend_is_cpu (ggml_backend_t backend);
 */
class GGML_backend_is_cpu extends MustUse {
    GGML_backend_is_cpu() {
        this.getName() = "ggml_backend_is_cpu"
    }
}

/**
 * GGML_API void ggml_backend_cpu_set_n_threads (
 *     ggml_backend_t backend_cpu,
 *     int n_threads
 * );
 */
class GGML_backend_cpu_set_n_threads extends Function {
    GGML_backend_cpu_set_n_threads() {
        this.getName() = "ggml_backend_cpu_set_n_threads"
    }
}

/**
 * GGML_API void ggml_backend_cpu_set_abort_callback(
 *     ggml_backend_t backend_cpu,
 *     ggml_abort_callback abort_callback,
 *     void * abort_callback_data
 * );
 */
class GGML_backend_cpu_set_abort_callback extends Function {
    GGML_backend_cpu_set_abort_callback() {
        this.getName() = "ggml_backend_cpu_set_abort_callback"
    }
}

/**
 * GGML_API GGML_CALL ggml_backend_buffer_t ggml_backend_cpu_buffer_from_ptr(
 *     void * ptr,
 *     size_t size
 * );
 */
class GGML_backend_cpu_buffer_from_ptr extends MustUse {
    GGML_backend_cpu_buffer_from_ptr() {
        this.getName() = "ggml_backend_cpu_buffer_from_ptr"
    }
}

/**
 * GGML_API GGML_CALL ggml_backend_buffer_type_t ggml_backend_cpu_buffer_type(
 *     void
 * );
 */
class GGML_backend_cpu_buffer_type extends MustUse {
    GGML_backend_cpu_buffer_type() {
        this.getName() = "ggml_backend_cpu_buffer_type"
    }
}

/**
 * GGML_API ggml_backend_buffer_type_t ggml_backend_cpu_hbm_buffer_type(void);
 */
class GGML_backend_cpu_hbm_buffer_type extends MustUse {
    GGML_backend_cpu_hbm_buffer_type() {
        this.getName() = "ggml_backend_cpu_hbm_buffer_type"
    }
}

/**
 * GGML_API size_t ggml_backend_reg_get_count(void);
 */
class GGML_backend_reg_get_count extends MustUse {
    GGML_backend_reg_get_count() {
        this.getName() = "ggml_backend_reg_get_count"
    }
}

/**
 * GGML_API size_t ggml_backend_reg_find_by_name(const char * name);
 */
class GGML_backend_reg_find_by_name extends MustUse {
    GGML_backend_reg_find_by_name() {
        this.getName() = "ggml_backend_reg_find_by_name"
    }
}

/**
 * GGML_API ggml_backend_t ggml_backend_reg_init_backend_from_str(
 *     const char * backend_str
 * );
 */
class GGML_backend_reg_init_backend_from_str extends MustUse {
    GGML_backend_reg_init_backend_from_str() {
        this.getName() = "ggml_backend_reg_init_backend_from_str"
    }
}

/**
 * GGML_API ggml_backend_t ggml_backend_reg_init_backend(
 *     size_t i,
 *     const char * params
 * );
 */
class GGML_backend_reg_init_backend extends MustUse {
    GGML_backend_reg_init_backend() {
        this.getName() = "ggml_backend_reg_init_backend"
    }
}

/**
 * GGML_API ggml_backend_buffer_type_t ggml_backend_reg_get_default_buffer_type(
 *     size_t i
 * );
 */
class GGML_backend_reg_get_default_buffer_type extends MustUse {
    GGML_backend_reg_get_default_buffer_type() {
        this.getName() = "ggml_backend_reg_get_default_buffer_type"
    }
}

/**
 * GGML_API ggml_backend_buffer_t ggml_backend_reg_alloc_buffer(
 *     size_t i,
 *     size_t size
 * );
 */
class GGML_backend_reg_alloc_buffer extends MustUse {
    GGML_backend_reg_alloc_buffer() {
        this.getName() = "ggml_backend_reg_alloc_buffer"
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
 * GGML_API bool ggml_backend_sched_reserve(
 *     ggml_backend_sched_t sched,
 *     struct ggml_cgraph * measure_graph
 * );
 */
class GGML_backend_sched_reserve extends MustUse {
    GGML_backend_sched_reserve() {
        this.getName() = "ggml_backend_sched_reserve"
    }
}

/**
 * GGML_API int ggml_backend_sched_get_n_splits(ggml_backend_sched_t sched);
 */
class GGML_backend_sched_get_n_splits extends MustUse {
    GGML_backend_sched_get_n_splits() {
        this.getName() = "ggml_backend_sched_get_n_splits"
    }
}

/**
 * GGML_API int ggml_backend_sched_get_n_copies(ggml_backend_sched_t sched);
 */
class GGML_backend_sched_get_n_copies extends MustUse {
    GGML_backend_sched_get_n_copies() {
        this.getName() = "ggml_backend_sched_get_n_copies"
    }
}

/**
 * GGML_API size_t ggml_backend_sched_get_buffer_size(
 *     ggml_backend_sched_t sched,
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_sched_get_buffer_size extends MustUse {
    GGML_backend_sched_get_buffer_size() {
        this.getName() = "ggml_backend_sched_get_buffer_size"
    }
}

/**
 * GGML_API void ggml_backend_sched_set_tensor_backend(
 *     ggml_backend_sched_t sched,
 *     struct ggml_tensor * node,
 *     ggml_backend_t backend
 * );
 */
class GGML_backend_sched_set_tensor_backend extends Function {
    GGML_backend_sched_set_tensor_backend() {
        this.getName() = "ggml_backend_sched_set_tensor_backend"
    }
}

/**
 * GGML_API ggml_backend_t ggml_backend_sched_get_tensor_backend(
 *     ggml_backend_sched_t sched,
 *     struct ggml_tensor * node
 * );
 */
class GGML_backend_sched_get_tensor_backend extends MustUse {
    GGML_backend_sched_get_tensor_backend() {
        this.getName() = "ggml_backend_sched_get_tensor_backend"
    }
}

/**
 * GGML_API bool ggml_backend_sched_alloc_graph(
 *     ggml_backend_sched_t sched,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_backend_sched_alloc_graph extends MustUse {
    GGML_backend_sched_alloc_graph() {
        this.getName() = "ggml_backend_sched_alloc_graph"
    }
}

/**
 * GGML_API enum ggml_status ggml_backend_sched_graph_compute(
 *     ggml_backend_sched_t sched,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_backend_sched_graph_compute extends MustUse {
    GGML_backend_sched_graph_compute() {
        this.getName() = "ggml_backend_sched_graph_compute"
    }
}

/**
 * GGML_API enum ggml_status ggml_backend_sched_graph_compute_async(
 *     ggml_backend_sched_t sched,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_backend_sched_graph_compute_async extends MustUse {
    GGML_backend_sched_graph_compute_async() {
        this.getName() = "ggml_backend_sched_graph_compute_async"
    }
}

/**
 * GGML_API void ggml_backend_sched_synchronize(ggml_backend_sched_t sched);
 */
class GGML_backend_sched_synchronize extends Function {
    GGML_backend_sched_synchronize() {
        this.getName() = "ggml_backend_sched_synchronize"
    }
}

/**
 * GGML_API void ggml_backend_sched_reset(ggml_backend_sched_t sched);
 */
class GGML_backend_sched_reset extends Function {
    GGML_backend_sched_reset() {
        this.getName() = "ggml_backend_sched_reset"
    }
}

/**
 * GGML_API void ggml_backend_sched_set_eval_callback(
 *     ggml_backend_sched_t sched,
 *     ggml_backend_sched_eval_callback callback,
 *     void * user_data
 * );
 */
class GGML_backend_sched_set_eval_callback extends Function {
    GGML_backend_sched_set_eval_callback() {
        this.getName() = "ggml_backend_sched_set_eval_callback"
    }
}

/**
 * GGML_API struct ggml_backend_graph_copy ggml_backend_graph_copy(
 *     ggml_backend_t backend,
 *     struct ggml_cgraph * graph
 * );
 */
class GGML_backend_graph_copy extends MustUse {
    GGML_backend_graph_copy() {
        this.getName() = "ggml_backend_graph_copy"
    }
}

/**
 * GGML_API void ggml_backend_graph_copy_free(
 *     struct ggml_backend_graph_copy copy
 * );
 */
class GGML_backend_graph_copy_free extends Function {
    GGML_backend_graph_copy_free() {
        this.getName() = "ggml_backend_graph_copy_free"
    }
}

/**
 * GGML_API bool ggml_backend_compare_graph_backend(
 *     ggml_backend_t backend1,
 *     ggml_backend_t backend2,
 *     struct ggml_cgraph * graph,
 *     ggml_backend_eval_callback callback,
 *     void * user_data
 * );
 */
class GGML_backend_compare_graph_backend extends MustUse {
    GGML_backend_compare_graph_backend() {
        this.getName() = "ggml_backend_compare_graph_backend"
    }
}

/**
 * GGML_API void ggml_backend_tensor_alloc(
 *     ggml_backend_buffer_t buffer,
 *     struct ggml_tensor * tensor,
 *     void * addr
 * );
 */
class GGML_backend_tensor_alloc extends Function {
    GGML_backend_tensor_alloc() {
        this.getName() = "ggml_backend_tensor_alloc"
    }
}

/**
 * GGML_API void ggml_backend_view_init(
 *     ggml_backend_buffer_t buffer,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_backend_view_init extends Function {
    GGML_backend_view_init() {
        this.getName() = "ggml_backend_view_init"
    }
}

// *********************************************************************
//
//  Custom allocators defined by 'ggml-backend.h'.                   
//
// *********************************************************************

/**
 * Alloc:
 *     ggml_backend_event_new
 *
 * Free:
 *     ggml_backend_event_free
 */
class GGMLBackendEventAllocator extends CustomAllocator {
    GGMLBackendEventAllocator() { this = "GGMLBackendEventAllocator" }

    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_event_new
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_event_free
    }
}

/**
 * Alloc:
 *     ggml_backend_sched_new
 *
 * Free:
 *     ggml_backend_sched_free
 */
class GGMLBackendScheduleAllocator extends CustomAllocator {
    GGMLBackendScheduleAllocator() { this = "GGMLBackendScheduleAllocator" }

    override predicate isAlloc(Alloc f) {
        f instanceof GGML_backend_sched_new
    }

    override predicate isFree(Free f) {
        f instanceof GGML_backend_sched_free
    }
}
