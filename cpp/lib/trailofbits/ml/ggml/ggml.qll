// *********************************************************************
//
//  This library has been automatically generated using the QLL Writer
//  VSCode extension from the the file ggml.h
//
// *********************************************************************
import cpp
import trailofbits.common

// *********************************************************************
//
//  Function types matching the individual functions defined in       
//  ggml.h
//
// *********************************************************************

/**
 * GGML_API GGML_CALL const char * ggml_status_to_string(
 *     enum ggml_status status
 * );
 */
class GGML_status_to_string extends MustCheck {
    GGML_status_to_string() {
        this.getName() = "ggml_status_to_string"
    }
}

/**
 * GGML_API float ggml_fp16_to_fp32(ggml_fp16_t x);
 */
class GGML_fp16_to_fp32 extends MustUse {
    GGML_fp16_to_fp32() {
        this.getName() = "ggml_fp16_to_fp32"
    }
}

/**
 * GGML_API ggml_fp16_t ggml_fp32_to_fp16(float x);
 */
class GGML_fp32_to_fp16 extends MustUse {
    GGML_fp32_to_fp16() {
        this.getName() = "ggml_fp32_to_fp16"
    }
}

/**
 * GGML_API void ggml_fp16_to_fp32_row(
 *     const ggml_fp16_t * x,
 *     float * y,
 *     int64_t n
 * );
 */
class GGML_fp16_to_fp32_row extends Function {
    GGML_fp16_to_fp32_row() {
        this.getName() = "ggml_fp16_to_fp32_row"
    }
}

/**
 * GGML_API void ggml_fp32_to_fp16_row(
 *     const float * x,
 *     ggml_fp16_t * y,
 *     int64_t n
 * );
 */
class GGML_fp32_to_fp16_row extends Function {
    GGML_fp32_to_fp16_row() {
        this.getName() = "ggml_fp32_to_fp16_row"
    }
}

/**
 * GGML_API bool ggml_guid_matches(ggml_guid_t guid_a, ggml_guid_t guid_b);
 */
class GGML_guid_matches extends MustUse {
    GGML_guid_matches() {
        this.getName() = "ggml_guid_matches"
    }
}

/**
 * GGML_API void ggml_time_init(void);
 */
class GGML_time_init extends Function {
    GGML_time_init() {
        this.getName() = "ggml_time_init"
    }
}

/**
 * GGML_API int64_t ggml_time_ms(void);
 */
class GGML_time_ms extends MustUse {
    GGML_time_ms() {
        this.getName() = "ggml_time_ms"
    }
}

/**
 * GGML_API int64_t ggml_time_us(void);
 */
class GGML_time_us extends MustUse {
    GGML_time_us() {
        this.getName() = "ggml_time_us"
    }
}

/**
 * GGML_API int64_t ggml_cycles(void);
 */
class GGML_cycles extends MustUse {
    GGML_cycles() {
        this.getName() = "ggml_cycles"
    }
}

/**
 * GGML_API int64_t ggml_cycles_per_ms(void);
 */
class GGML_cycles_per_ms extends MustUse {
    GGML_cycles_per_ms() {
        this.getName() = "ggml_cycles_per_ms"
    }
}

/**
 * GGML_API void ggml_print_backtrace(void);
 */
class GGML_print_backtrace extends Function {
    GGML_print_backtrace() {
        this.getName() = "ggml_print_backtrace"
    }
}

/**
 * GGML_API FILE * ggml_fopen(const char * fname, const char * mode);
 */
class GGML_fopen extends MustCheck {
    GGML_fopen() {
        this.getName() = "ggml_fopen"
    }
}

/**
 * GGML_API void ggml_numa_init(enum ggml_numa_strategy numa);
 */
class GGML_numa_init extends Function {
    GGML_numa_init() {
        this.getName() = "ggml_numa_init"
    }
}

/**
 * GGML_API bool ggml_is_numa(void);
 */
class GGML_is_numa extends MustUse {
    GGML_is_numa() {
        this.getName() = "ggml_is_numa"
    }
}

/**
 * GGML_API void ggml_print_object (const struct ggml_object * obj);
 */
class GGML_print_object extends Function {
    GGML_print_object() {
        this.getName() = "ggml_print_object"
    }
}

/**
 * GGML_API void ggml_print_objects(const struct ggml_context * ctx);
 */
class GGML_print_objects extends Function {
    GGML_print_objects() {
        this.getName() = "ggml_print_objects"
    }
}

/**
 * GGML_API GGML_CALL int64_t ggml_nelements (
 *     const struct ggml_tensor * tensor
 * );
 */
class GGML_nelements extends MustUse {
    GGML_nelements() {
        this.getName() = "ggml_nelements"
    }
}

/**
 * GGML_API GGML_CALL int64_t ggml_nrows (const struct ggml_tensor * tensor);
 */
class GGML_nrows extends MustUse {
    GGML_nrows() {
        this.getName() = "ggml_nrows"
    }
}

/**
 * GGML_API GGML_CALL size_t ggml_nbytes (const struct ggml_tensor * tensor);
 */
class GGML_nbytes extends MustUse {
    GGML_nbytes() {
        this.getName() = "ggml_nbytes"
    }
}

/**
 * GGML_API size_t ggml_nbytes_pad (const struct ggml_tensor * tensor);
 */
class GGML_nbytes_pad extends MustUse {
    GGML_nbytes_pad() {
        this.getName() = "ggml_nbytes_pad"
    }
}

/**
 * GGML_API GGML_CALL int ggml_blck_size(enum ggml_type type);
 */
class GGML_blck_size extends MustUse {
    GGML_blck_size() {
        this.getName() = "ggml_blck_size"
    }
}

/**
 * GGML_API GGML_CALL size_t ggml_type_size(enum ggml_type type);
 */
class GGML_type_size extends MustUse {
    GGML_type_size() {
        this.getName() = "ggml_type_size"
    }
}

/**
 * GGML_API GGML_CALL size_t ggml_row_size (enum ggml_type type, int64_t ne);
 */
class GGML_row_size extends MustUse {
    GGML_row_size() {
        this.getName() = "ggml_row_size"
    }
}

/**
 * GGML_API GGML_CALL const char * ggml_type_name(enum ggml_type type);
 */
class GGML_type_name extends MustCheck {
    GGML_type_name() {
        this.getName() = "ggml_type_name"
    }
}

/**
 * GGML_API GGML_CALL const char * ggml_op_name (enum ggml_op op);
 */
class GGML_op_name extends MustCheck {
    GGML_op_name() {
        this.getName() = "ggml_op_name"
    }
}

/**
 * GGML_API const char * ggml_op_symbol(enum ggml_op op);
 */
class GGML_op_symbol extends MustCheck {
    GGML_op_symbol() {
        this.getName() = "ggml_op_symbol"
    }
}

/**
 * GGML_API const char * ggml_unary_op_name(enum ggml_unary_op op);
 */
class GGML_unary_op_name extends MustCheck {
    GGML_unary_op_name() {
        this.getName() = "ggml_unary_op_name"
    }
}

/**
 * GGML_API GGML_CALL const char * ggml_op_desc(const struct ggml_tensor * t);
 */
class GGML_op_desc extends MustCheck {
    GGML_op_desc() {
        this.getName() = "ggml_op_desc"
    }
}

/**
 * GGML_API GGML_CALL size_t ggml_element_size(
 *     const struct ggml_tensor * tensor
 * );
 */
class GGML_element_size extends MustUse {
    GGML_element_size() {
        this.getName() = "ggml_element_size"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_is_quantized(enum ggml_type type);
 */
class GGML_is_quantized extends MustUse {
    GGML_is_quantized() {
        this.getName() = "ggml_is_quantized"
    }
}

/**
 * GGML_API enum ggml_type ggml_ftype_to_ggml_type(enum ggml_ftype ftype);
 */
class GGML_ftype_to_ggml_type extends MustUse {
    GGML_ftype_to_ggml_type() {
        this.getName() = "ggml_ftype_to_ggml_type"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_is_transposed(
 *     const struct ggml_tensor * tensor
 * );
 */
class GGML_is_transposed extends MustUse {
    GGML_is_transposed() {
        this.getName() = "ggml_is_transposed"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_is_contiguous(
 *     const struct ggml_tensor * tensor
 * );
 */
class GGML_is_contiguous extends MustUse {
    GGML_is_contiguous() {
        this.getName() = "ggml_is_contiguous"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_is_permuted (const struct ggml_tensor * tensor);
 */
class GGML_is_permuted extends MustUse {
    GGML_is_permuted() {
        this.getName() = "ggml_is_permuted"
    }
}

/**
 * GGML_API GGML_CALL bool ggml_is_empty (const struct ggml_tensor * tensor);
 */
class GGML_is_empty extends MustUse {
    GGML_is_empty() {
        this.getName() = "ggml_is_empty"
    }
}

/**
 * GGML_API bool ggml_is_scalar (const struct ggml_tensor * tensor);
 */
class GGML_is_scalar extends MustUse {
    GGML_is_scalar() {
        this.getName() = "ggml_is_scalar"
    }
}

/**
 * GGML_API bool ggml_is_vector (const struct ggml_tensor * tensor);
 */
class GGML_is_vector extends MustUse {
    GGML_is_vector() {
        this.getName() = "ggml_is_vector"
    }
}

/**
 * GGML_API bool ggml_is_matrix (const struct ggml_tensor * tensor);
 */
class GGML_is_matrix extends MustUse {
    GGML_is_matrix() {
        this.getName() = "ggml_is_matrix"
    }
}

/**
 * GGML_API bool ggml_is_3d (const struct ggml_tensor * tensor);
 */
class GGML_is_3d extends MustUse {
    GGML_is_3d() {
        this.getName() = "ggml_is_3d"
    }
}

/**
 * GGML_API int ggml_n_dims (const struct ggml_tensor * tensor);
 */
class GGML_n_dims extends MustUse {
    GGML_n_dims() {
        this.getName() = "ggml_n_dims"
    }
}

/**
 * GGML_API bool ggml_are_same_shape(
 *     const struct ggml_tensor * t0,
 *     const struct ggml_tensor * t1
 * );
 */
class GGML_are_same_shape extends MustUse {
    GGML_are_same_shape() {
        this.getName() = "ggml_are_same_shape"
    }
}

/**
 * GGML_API size_t ggml_tensor_overhead(void);
 */
class GGML_tensor_overhead extends MustUse {
    GGML_tensor_overhead() {
        this.getName() = "ggml_tensor_overhead"
    }
}

/**
 * GGML_API struct ggml_context * ggml_init(struct ggml_init_params params);
 */
class GGML_init extends MustCheck {
    GGML_init() {
        this.getName() = "ggml_init"
    }
}

/**
 * GGML_API void ggml_free(struct ggml_context * ctx);
 */
class GGML_free extends Function {
    GGML_free() {
        this.getName() = "ggml_free"
    }
}

/**
 * GGML_API size_t ggml_used_mem(const struct ggml_context * ctx);
 */
class GGML_used_mem extends MustUse {
    GGML_used_mem() {
        this.getName() = "ggml_used_mem"
    }
}

/**
 * GGML_API size_t ggml_set_scratch (
 *     struct ggml_context * ctx,
 *     struct ggml_scratch scratch
 * );
 */
class GGML_set_scratch extends MustUse {
    GGML_set_scratch() {
        this.getName() = "ggml_set_scratch"
    }
}

/**
 * GGML_API bool ggml_get_no_alloc(struct ggml_context * ctx);
 */
class GGML_get_no_alloc extends MustUse {
    GGML_get_no_alloc() {
        this.getName() = "ggml_get_no_alloc"
    }
}

/**
 * GGML_API void ggml_set_no_alloc(struct ggml_context * ctx, bool no_alloc);
 */
class GGML_set_no_alloc extends Function {
    GGML_set_no_alloc() {
        this.getName() = "ggml_set_no_alloc"
    }
}

/**
 * GGML_API void * ggml_get_mem_buffer (const struct ggml_context * ctx);
 */
class GGML_get_mem_buffer extends MustCheck {
    GGML_get_mem_buffer() {
        this.getName() = "ggml_get_mem_buffer"
    }
}

/**
 * GGML_API size_t ggml_get_mem_size (const struct ggml_context * ctx);
 */
class GGML_get_mem_size extends MustUse {
    GGML_get_mem_size() {
        this.getName() = "ggml_get_mem_size"
    }
}

/**
 * GGML_API size_t ggml_get_max_tensor_size(const struct ggml_context * ctx);
 */
class GGML_get_max_tensor_size extends MustUse {
    GGML_get_max_tensor_size() {
        this.getName() = "ggml_get_max_tensor_size"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_tensor(
 *     struct ggml_context * ctx,
 *     enum ggml_type type,
 *     int n_dims,
 *     const int64_t *ne
 * );
 */
class GGML_new_tensor extends MustCheck {
    GGML_new_tensor() {
        this.getName() = "ggml_new_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_tensor_1d(
 *     struct ggml_context * ctx,
 *     enum ggml_type type,
 *     int64_t ne0
 * );
 */
class GGML_new_tensor_1d extends MustCheck {
    GGML_new_tensor_1d() {
        this.getName() = "ggml_new_tensor_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_tensor_2d(
 *     struct ggml_context * ctx,
 *     enum ggml_type type,
 *     int64_t ne0,
 *     int64_t ne1
 * );
 */
class GGML_new_tensor_2d extends MustCheck {
    GGML_new_tensor_2d() {
        this.getName() = "ggml_new_tensor_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_tensor_3d(
 *     struct ggml_context * ctx,
 *     enum ggml_type type,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2
 * );
 */
class GGML_new_tensor_3d extends MustCheck {
    GGML_new_tensor_3d() {
        this.getName() = "ggml_new_tensor_3d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_tensor_4d(
 *     struct ggml_context * ctx,
 *     enum ggml_type type,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2,
 *     int64_t ne3
 * );
 */
class GGML_new_tensor_4d extends MustCheck {
    GGML_new_tensor_4d() {
        this.getName() = "ggml_new_tensor_4d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_i32(
 *     struct ggml_context * ctx,
 *     int32_t value
 * );
 */
class GGML_new_i32 extends MustCheck {
    GGML_new_i32() {
        this.getName() = "ggml_new_i32"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_new_f32(
 *     struct ggml_context * ctx,
 *     float value
 * );
 */
class GGML_new_f32 extends MustCheck {
    GGML_new_f32() {
        this.getName() = "ggml_new_f32"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_dup_tensor (
 *     struct ggml_context * ctx,
 *     const struct ggml_tensor * src
 * );
 */
class GGML_dup_tensor extends MustCheck {
    GGML_dup_tensor() {
        this.getName() = "ggml_dup_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_view_tensor(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * src
 * );
 */
class GGML_view_tensor extends MustCheck {
    GGML_view_tensor() {
        this.getName() = "ggml_view_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_first_tensor(
 *     const struct ggml_context * ctx
 * );
 */
class GGML_get_first_tensor extends MustCheck {
    GGML_get_first_tensor() {
        this.getName() = "ggml_get_first_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_next_tensor (
 *     const struct ggml_context * ctx,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_get_next_tensor extends MustCheck {
    GGML_get_next_tensor() {
        this.getName() = "ggml_get_next_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_tensor(
 *     struct ggml_context * ctx,
 *     const char * name
 * );
 */
class GGML_get_tensor extends MustCheck {
    GGML_get_tensor() {
        this.getName() = "ggml_get_tensor"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_zero(struct ggml_tensor * tensor);
 */
class GGML_set_zero extends MustCheck {
    GGML_set_zero() {
        this.getName() = "ggml_set_zero"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_i32 (
 *     struct ggml_tensor * tensor,
 *     int32_t value
 * );
 */
class GGML_set_i32 extends MustCheck {
    GGML_set_i32() {
        this.getName() = "ggml_set_i32"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_f32 (
 *     struct ggml_tensor * tensor,
 *     float value
 * );
 */
class GGML_set_f32 extends MustCheck {
    GGML_set_f32() {
        this.getName() = "ggml_set_f32"
    }
}

/**
 * GGML_API void ggml_unravel_index(
 *     const struct ggml_tensor * tensor,
 *     int64_t i,
 *     int64_t * i0,
 *     int64_t * i1,
 *     int64_t * i2,
 *     int64_t * i3
 * );
 */
class GGML_unravel_index extends Function {
    GGML_unravel_index() {
        this.getName() = "ggml_unravel_index"
    }
}

/**
 * GGML_API int32_t ggml_get_i32_1d(const struct ggml_tensor * tensor, int i);
 */
class GGML_get_i32_1d extends MustUse {
    GGML_get_i32_1d() {
        this.getName() = "ggml_get_i32_1d"
    }
}

/**
 * GGML_API void ggml_set_i32_1d(
 *     const struct ggml_tensor * tensor,
 *     int i,
 *     int32_t value
 * );
 */
class GGML_set_i32_1d extends Function {
    GGML_set_i32_1d() {
        this.getName() = "ggml_set_i32_1d"
    }
}

/**
 * GGML_API int32_t ggml_get_i32_nd(
 *     const struct ggml_tensor * tensor,
 *     int i0,
 *     int i1,
 *     int i2,
 *     int i3
 * );
 */
class GGML_get_i32_nd extends MustUse {
    GGML_get_i32_nd() {
        this.getName() = "ggml_get_i32_nd"
    }
}

/**
 * GGML_API void ggml_set_i32_nd(
 *     const struct ggml_tensor * tensor,
 *     int i0,
 *     int i1,
 *     int i2,
 *     int i3,
 *     int32_t value
 * );
 */
class GGML_set_i32_nd extends Function {
    GGML_set_i32_nd() {
        this.getName() = "ggml_set_i32_nd"
    }
}

/**
 * GGML_API float ggml_get_f32_1d(const struct ggml_tensor * tensor, int i);
 */
class GGML_get_f32_1d extends MustUse {
    GGML_get_f32_1d() {
        this.getName() = "ggml_get_f32_1d"
    }
}

/**
 * GGML_API void ggml_set_f32_1d(
 *     const struct ggml_tensor * tensor,
 *     int i,
 *     float value
 * );
 */
class GGML_set_f32_1d extends Function {
    GGML_set_f32_1d() {
        this.getName() = "ggml_set_f32_1d"
    }
}

/**
 * GGML_API float ggml_get_f32_nd(
 *     const struct ggml_tensor * tensor,
 *     int i0,
 *     int i1,
 *     int i2,
 *     int i3
 * );
 */
class GGML_get_f32_nd extends MustUse {
    GGML_get_f32_nd() {
        this.getName() = "ggml_get_f32_nd"
    }
}

/**
 * GGML_API void ggml_set_f32_nd(
 *     const struct ggml_tensor * tensor,
 *     int i0,
 *     int i1,
 *     int i2,
 *     int i3,
 *     float value
 * );
 */
class GGML_set_f32_nd extends Function {
    GGML_set_f32_nd() {
        this.getName() = "ggml_set_f32_nd"
    }
}

/**
 * GGML_API void * ggml_get_data (const struct ggml_tensor * tensor);
 */
class GGML_get_data extends MustCheck {
    GGML_get_data() {
        this.getName() = "ggml_get_data"
    }
}

/**
 * GGML_API float * ggml_get_data_f32(const struct ggml_tensor * tensor);
 */
class GGML_get_data_f32 extends MustCheck {
    GGML_get_data_f32() {
        this.getName() = "ggml_get_data_f32"
    }
}

/**
 * GGML_API GGML_CALL enum ggml_unary_op ggml_get_unary_op(
 *     const struct ggml_tensor * tensor
 * );
 */
class GGML_get_unary_op extends MustUse {
    GGML_get_unary_op() {
        this.getName() = "ggml_get_unary_op"
    }
}

/**
 * GGML_API const char * ggml_get_name (const struct ggml_tensor * tensor);
 */
class GGML_get_name extends MustCheck {
    GGML_get_name() {
        this.getName() = "ggml_get_name"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_name (
 *     struct ggml_tensor * tensor,
 *     const char * name
 * );
 */
class GGML_set_name extends MustCheck {
    GGML_set_name() {
        this.getName() = "ggml_set_name"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_format_name(
 *     struct ggml_tensor * tensor,
 *     const char * fmt,
 *     ...
 * );
 */
class GGML_format_name extends MustCheck {
    GGML_format_name() {
        this.getName() = "ggml_format_name"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_dup(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_dup extends MustCheck {
    GGML_dup() {
        this.getName() = "ggml_dup"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_dup_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_dup_inplace extends MustCheck {
    GGML_dup_inplace() {
        this.getName() = "ggml_dup_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_add extends MustCheck {
    GGML_add() {
        this.getName() = "ggml_add"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_add_inplace extends MustCheck {
    GGML_add_inplace() {
        this.getName() = "ggml_add_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add_cast(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     enum ggml_type type
 * );
 */
class GGML_add_cast extends MustCheck {
    GGML_add_cast() {
        this.getName() = "ggml_add_cast"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add1(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_add1 extends MustCheck {
    GGML_add1() {
        this.getName() = "ggml_add1"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add1_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_add1_inplace extends MustCheck {
    GGML_add1_inplace() {
        this.getName() = "ggml_add1_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_acc(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t nb2,
 *     size_t nb3,
 *     size_t offset
 * );
 */
class GGML_acc extends MustCheck {
    GGML_acc() {
        this.getName() = "ggml_acc"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_acc_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t nb2,
 *     size_t nb3,
 *     size_t offset
 * );
 */
class GGML_acc_inplace extends MustCheck {
    GGML_acc_inplace() {
        this.getName() = "ggml_acc_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sub(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_sub extends MustCheck {
    GGML_sub() {
        this.getName() = "ggml_sub"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sub_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_sub_inplace extends MustCheck {
    GGML_sub_inplace() {
        this.getName() = "ggml_sub_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_mul(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_mul extends MustCheck {
    GGML_mul() {
        this.getName() = "ggml_mul"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_mul_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_mul_inplace extends MustCheck {
    GGML_mul_inplace() {
        this.getName() = "ggml_mul_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_div(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_div extends MustCheck {
    GGML_div() {
        this.getName() = "ggml_div"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_div_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_div_inplace extends MustCheck {
    GGML_div_inplace() {
        this.getName() = "ggml_div_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sqr(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sqr extends MustCheck {
    GGML_sqr() {
        this.getName() = "ggml_sqr"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sqr_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sqr_inplace extends MustCheck {
    GGML_sqr_inplace() {
        this.getName() = "ggml_sqr_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sqrt(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sqrt extends MustCheck {
    GGML_sqrt() {
        this.getName() = "ggml_sqrt"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sqrt_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sqrt_inplace extends MustCheck {
    GGML_sqrt_inplace() {
        this.getName() = "ggml_sqrt_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_log(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_log extends MustCheck {
    GGML_log() {
        this.getName() = "ggml_log"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_log_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_log_inplace extends MustCheck {
    GGML_log_inplace() {
        this.getName() = "ggml_log_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sum(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sum extends MustCheck {
    GGML_sum() {
        this.getName() = "ggml_sum"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sum_rows(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sum_rows extends MustCheck {
    GGML_sum_rows() {
        this.getName() = "ggml_sum_rows"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_mean(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_mean extends MustCheck {
    GGML_mean() {
        this.getName() = "ggml_mean"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_argmax(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_argmax extends MustCheck {
    GGML_argmax() {
        this.getName() = "ggml_argmax"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_repeat(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_repeat extends MustCheck {
    GGML_repeat() {
        this.getName() = "ggml_repeat"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_repeat_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_repeat_back extends MustCheck {
    GGML_repeat_back() {
        this.getName() = "ggml_repeat_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_concat(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_concat extends MustCheck {
    GGML_concat() {
        this.getName() = "ggml_concat"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_abs(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_abs extends MustCheck {
    GGML_abs() {
        this.getName() = "ggml_abs"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_abs_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_abs_inplace extends MustCheck {
    GGML_abs_inplace() {
        this.getName() = "ggml_abs_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sgn(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sgn extends MustCheck {
    GGML_sgn() {
        this.getName() = "ggml_sgn"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sgn_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sgn_inplace extends MustCheck {
    GGML_sgn_inplace() {
        this.getName() = "ggml_sgn_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_neg(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_neg extends MustCheck {
    GGML_neg() {
        this.getName() = "ggml_neg"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_neg_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_neg_inplace extends MustCheck {
    GGML_neg_inplace() {
        this.getName() = "ggml_neg_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_step(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_step extends MustCheck {
    GGML_step() {
        this.getName() = "ggml_step"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_step_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_step_inplace extends MustCheck {
    GGML_step_inplace() {
        this.getName() = "ggml_step_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_tanh(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_tanh extends MustCheck {
    GGML_tanh() {
        this.getName() = "ggml_tanh"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_tanh_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_tanh_inplace extends MustCheck {
    GGML_tanh_inplace() {
        this.getName() = "ggml_tanh_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_elu(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_elu extends MustCheck {
    GGML_elu() {
        this.getName() = "ggml_elu"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_elu_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_elu_inplace extends MustCheck {
    GGML_elu_inplace() {
        this.getName() = "ggml_elu_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_relu(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_relu extends MustCheck {
    GGML_relu() {
        this.getName() = "ggml_relu"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sigmoid(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sigmoid extends MustCheck {
    GGML_sigmoid() {
        this.getName() = "ggml_sigmoid"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_leaky_relu(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float negative_slope,
 *     bool inplace
 * );
 */
class GGML_leaky_relu extends MustCheck {
    GGML_leaky_relu() {
        this.getName() = "ggml_leaky_relu"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_relu_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_relu_inplace extends MustCheck {
    GGML_relu_inplace() {
        this.getName() = "ggml_relu_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_sigmoid_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_sigmoid_inplace extends MustCheck {
    GGML_sigmoid_inplace() {
        this.getName() = "ggml_sigmoid_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_gelu(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_gelu extends MustCheck {
    GGML_gelu() {
        this.getName() = "ggml_gelu"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_gelu_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_gelu_inplace extends MustCheck {
    GGML_gelu_inplace() {
        this.getName() = "ggml_gelu_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_gelu_quick(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_gelu_quick extends MustCheck {
    GGML_gelu_quick() {
        this.getName() = "ggml_gelu_quick"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_gelu_quick_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_gelu_quick_inplace extends MustCheck {
    GGML_gelu_quick_inplace() {
        this.getName() = "ggml_gelu_quick_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_silu(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_silu extends MustCheck {
    GGML_silu() {
        this.getName() = "ggml_silu"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_silu_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_silu_inplace extends MustCheck {
    GGML_silu_inplace() {
        this.getName() = "ggml_silu_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_silu_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_silu_back extends MustCheck {
    GGML_silu_back() {
        this.getName() = "ggml_silu_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_hardswish(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_hardswish extends MustCheck {
    GGML_hardswish() {
        this.getName() = "ggml_hardswish"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_hardsigmoid(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_hardsigmoid extends MustCheck {
    GGML_hardsigmoid() {
        this.getName() = "ggml_hardsigmoid"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_norm(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float eps
 * );
 */
class GGML_norm extends MustCheck {
    GGML_norm() {
        this.getName() = "ggml_norm"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_norm_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float eps
 * );
 */
class GGML_norm_inplace extends MustCheck {
    GGML_norm_inplace() {
        this.getName() = "ggml_norm_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rms_norm(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float eps
 * );
 */
class GGML_rms_norm extends MustCheck {
    GGML_rms_norm() {
        this.getName() = "ggml_rms_norm"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rms_norm_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float eps
 * );
 */
class GGML_rms_norm_inplace extends MustCheck {
    GGML_rms_norm_inplace() {
        this.getName() = "ggml_rms_norm_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_group_norm(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_groups
 * );
 */
class GGML_group_norm extends MustCheck {
    GGML_group_norm() {
        this.getName() = "ggml_group_norm"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_group_norm_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_groups
 * );
 */
class GGML_group_norm_inplace extends MustCheck {
    GGML_group_norm_inplace() {
        this.getName() = "ggml_group_norm_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rms_norm_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     float eps
 * );
 */
class GGML_rms_norm_back extends MustCheck {
    GGML_rms_norm_back() {
        this.getName() = "ggml_rms_norm_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_mul_mat(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_mul_mat extends MustCheck {
    GGML_mul_mat() {
        this.getName() = "ggml_mul_mat"
    }
}

/**
 * GGML_API void ggml_mul_mat_set_prec(
 *     struct ggml_tensor * a,
 *     enum ggml_prec prec
 * );
 */
class GGML_mul_mat_set_prec extends Function {
    GGML_mul_mat_set_prec() {
        this.getName() = "ggml_mul_mat_set_prec"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_mul_mat_id(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * as,
 *     struct ggml_tensor * ids,
 *     int id,
 *     struct ggml_tensor * b
 * );
 */
class GGML_mul_mat_id extends MustCheck {
    GGML_mul_mat_id() {
        this.getName() = "ggml_mul_mat_id"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_out_prod(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_out_prod extends MustCheck {
    GGML_out_prod() {
        this.getName() = "ggml_out_prod"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_scale(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float s
 * );
 */
class GGML_scale extends MustCheck {
    GGML_scale() {
        this.getName() = "ggml_scale"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_scale_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float s
 * );
 */
class GGML_scale_inplace extends MustCheck {
    GGML_scale_inplace() {
        this.getName() = "ggml_scale_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t nb2,
 *     size_t nb3,
 *     size_t offset
 * );
 */
class GGML_set extends MustCheck {
    GGML_set() {
        this.getName() = "ggml_set"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t nb2,
 *     size_t nb3,
 *     size_t offset
 * );
 */
class GGML_set_inplace extends MustCheck {
    GGML_set_inplace() {
        this.getName() = "ggml_set_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t offset
 * );
 */
class GGML_set_1d extends MustCheck {
    GGML_set_1d() {
        this.getName() = "ggml_set_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_1d_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t offset
 * );
 */
class GGML_set_1d_inplace extends MustCheck {
    GGML_set_1d_inplace() {
        this.getName() = "ggml_set_1d_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t offset
 * );
 */
class GGML_set_2d extends MustCheck {
    GGML_set_2d() {
        this.getName() = "ggml_set_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_set_2d_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     size_t nb1,
 *     size_t offset
 * );
 */
class GGML_set_2d_inplace extends MustCheck {
    GGML_set_2d_inplace() {
        this.getName() = "ggml_set_2d_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cpy(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_cpy extends MustCheck {
    GGML_cpy() {
        this.getName() = "ggml_cpy"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cast(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_type type
 * );
 */
class GGML_cast extends MustCheck {
    GGML_cast() {
        this.getName() = "ggml_cast"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cont(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_cont extends MustCheck {
    GGML_cont() {
        this.getName() = "ggml_cont"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cont_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0
 * );
 */
class GGML_cont_1d extends MustCheck {
    GGML_cont_1d() {
        this.getName() = "ggml_cont_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cont_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1
 * );
 */
class GGML_cont_2d extends MustCheck {
    GGML_cont_2d() {
        this.getName() = "ggml_cont_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cont_3d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2
 * );
 */
class GGML_cont_3d extends MustCheck {
    GGML_cont_3d() {
        this.getName() = "ggml_cont_3d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cont_4d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2,
 *     int64_t ne3
 * );
 */
class GGML_cont_4d extends MustCheck {
    GGML_cont_4d() {
        this.getName() = "ggml_cont_4d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_reshape(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_reshape extends MustCheck {
    GGML_reshape() {
        this.getName() = "ggml_reshape"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_reshape_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0
 * );
 */
class GGML_reshape_1d extends MustCheck {
    GGML_reshape_1d() {
        this.getName() = "ggml_reshape_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_reshape_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1
 * );
 */
class GGML_reshape_2d extends MustCheck {
    GGML_reshape_2d() {
        this.getName() = "ggml_reshape_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_reshape_3d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2
 * );
 */
class GGML_reshape_3d extends MustCheck {
    GGML_reshape_3d() {
        this.getName() = "ggml_reshape_3d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_reshape_4d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2,
 *     int64_t ne3
 * );
 */
class GGML_reshape_4d extends MustCheck {
    GGML_reshape_4d() {
        this.getName() = "ggml_reshape_4d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_view_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     size_t offset
 * );
 */
class GGML_view_1d extends MustCheck {
    GGML_view_1d() {
        this.getName() = "ggml_view_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_view_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     size_t nb1,
 *     // row stride in bytes size_t offset
 * );
 */
class GGML_view_2d extends MustCheck {
    GGML_view_2d() {
        this.getName() = "ggml_view_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_view_3d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2,
 *     size_t nb1,
 *     // row stride in bytes size_t nb2,
 *     // slice stride in bytes size_t offset
 * );
 */
class GGML_view_3d extends MustCheck {
    GGML_view_3d() {
        this.getName() = "ggml_view_3d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_view_4d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int64_t ne0,
 *     int64_t ne1,
 *     int64_t ne2,
 *     int64_t ne3,
 *     size_t nb1,
 *     // row stride in bytes size_t nb2,
 *     // slice stride in bytes size_t nb3,
 *     size_t offset
 * );
 */
class GGML_view_4d extends MustCheck {
    GGML_view_4d() {
        this.getName() = "ggml_view_4d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_permute(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int axis0,
 *     int axis1,
 *     int axis2,
 *     int axis3
 * );
 */
class GGML_permute extends MustCheck {
    GGML_permute() {
        this.getName() = "ggml_permute"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_transpose(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_transpose extends MustCheck {
    GGML_transpose() {
        this.getName() = "ggml_transpose"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_rows(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_get_rows extends MustCheck {
    GGML_get_rows() {
        this.getName() = "ggml_get_rows"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_rows_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     struct ggml_tensor * c
 * );
 */
class GGML_get_rows_back extends MustCheck {
    GGML_get_rows_back() {
        this.getName() = "ggml_get_rows_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_diag(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_diag extends MustCheck {
    GGML_diag() {
        this.getName() = "ggml_diag"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_diag_mask_inf(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_past
 * );
 */
class GGML_diag_mask_inf extends MustCheck {
    GGML_diag_mask_inf() {
        this.getName() = "ggml_diag_mask_inf"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_diag_mask_inf_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_past
 * );
 */
class GGML_diag_mask_inf_inplace extends MustCheck {
    GGML_diag_mask_inf_inplace() {
        this.getName() = "ggml_diag_mask_inf_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_diag_mask_zero(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_past
 * );
 */
class GGML_diag_mask_zero extends MustCheck {
    GGML_diag_mask_zero() {
        this.getName() = "ggml_diag_mask_zero"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_diag_mask_zero_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int n_past
 * );
 */
class GGML_diag_mask_zero_inplace extends MustCheck {
    GGML_diag_mask_zero_inplace() {
        this.getName() = "ggml_diag_mask_zero_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_soft_max(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_soft_max extends MustCheck {
    GGML_soft_max() {
        this.getName() = "ggml_soft_max"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_soft_max_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a
 * );
 */
class GGML_soft_max_inplace extends MustCheck {
    GGML_soft_max_inplace() {
        this.getName() = "ggml_soft_max_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_soft_max_ext(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * mask,
 *     struct ggml_tensor * pos,
 *     float scale,
 *     float max_bias
 * );
 */
class GGML_soft_max_ext extends MustCheck {
    GGML_soft_max_ext() {
        this.getName() = "ggml_soft_max_ext"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_soft_max_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_soft_max_back extends MustCheck {
    GGML_soft_max_back() {
        this.getName() = "ggml_soft_max_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_soft_max_back_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_soft_max_back_inplace extends MustCheck {
    GGML_soft_max_back_inplace() {
        this.getName() = "ggml_soft_max_back_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     int mode,
 *     int n_ctx
 * );
 */
class GGML_rope extends MustCheck {
    GGML_rope() {
        this.getName() = "ggml_rope"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     int mode,
 *     int n_ctx
 * );
 */
class GGML_rope_inplace extends MustCheck {
    GGML_rope_inplace() {
        this.getName() = "ggml_rope_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope_custom(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     int mode,
 *     int n_ctx,
 *     int n_orig_ctx,
 *     float freq_base,
 *     float freq_scale,
 *     float ext_factor,
 *     float attn_factor,
 *     float beta_fast,
 *     float beta_slow
 * );
 */
class GGML_rope_custom extends MustCheck {
    GGML_rope_custom() {
        this.getName() = "ggml_rope_custom"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope_custom_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     int mode,
 *     int n_ctx,
 *     int n_orig_ctx,
 *     float freq_base,
 *     float freq_scale,
 *     float ext_factor,
 *     float attn_factor,
 *     float beta_fast,
 *     float beta_slow
 * );
 */
class GGML_rope_custom_inplace extends MustCheck {
    GGML_rope_custom_inplace() {
        this.getName() = "ggml_rope_custom_inplace"
    }
}

/**
 * GGML_CALL void ggml_rope_yarn_corr_dims(
 *     int n_dims,
 *     int n_orig_ctx,
 *     float freq_base,
 *     float beta_fast,
 *     float beta_slow,
 *     float dims[2]
 * );
 */
class GGML_rope_yarn_corr_dims extends Function {
    GGML_rope_yarn_corr_dims() {
        this.getName() = "ggml_rope_yarn_corr_dims"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope_xpos_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     float base,
 *     bool down
 * );
 */
class GGML_rope_xpos_inplace extends MustCheck {
    GGML_rope_xpos_inplace() {
        this.getName() = "ggml_rope_xpos_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_rope_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int n_dims,
 *     int mode,
 *     int n_ctx,
 *     int n_orig_ctx,
 *     float freq_base,
 *     float freq_scale,
 *     float ext_factor,
 *     float attn_factor,
 *     float beta_fast,
 *     float beta_slow,
 *     float xpos_base,
 *     bool xpos_down
 * );
 */
class GGML_rope_back extends MustCheck {
    GGML_rope_back() {
        this.getName() = "ggml_rope_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_clamp(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     float min,
 *     float max
 * );
 */
class GGML_clamp extends MustCheck {
    GGML_clamp() {
        this.getName() = "ggml_clamp"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_im2col(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s0,
 *     int s1,
 *     int p0,
 *     int p1,
 *     int d0,
 *     int d1,
 *     bool is_2D,
 *     enum ggml_type dst_type
 * );
 */
class GGML_im2col extends MustCheck {
    GGML_im2col() {
        this.getName() = "ggml_im2col"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_depthwise_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s0,
 *     int s1,
 *     int p0,
 *     int p1,
 *     int d0,
 *     int d1
 * );
 */
class GGML_conv_depthwise_2d extends MustCheck {
    GGML_conv_depthwise_2d() {
        this.getName() = "ggml_conv_depthwise_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s0,
 *     // stride int p0,
 *     // padding int d0
 * );
 */
class GGML_conv_1d extends MustCheck {
    GGML_conv_1d() {
        this.getName() = "ggml_conv_1d"
    }
}

/**
 * GGML_API struct ggml_tensor* ggml_conv_1d_ph(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s,
 *     int d
 * );
 */
class GGML_conv_1d_ph extends MustCheck {
    GGML_conv_1d_ph() {
        this.getName() = "ggml_conv_1d_ph"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_transpose_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s0,
 *     int p0,
 *     int d0
 * );
 */
class GGML_conv_transpose_1d extends MustCheck {
    GGML_conv_transpose_1d() {
        this.getName() = "ggml_conv_transpose_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int s0,
 *     int s1,
 *     int p0,
 *     int p1,
 *     int d0,
 *     int d1
 * );
 */
class GGML_conv_2d extends MustCheck {
    GGML_conv_2d() {
        this.getName() = "ggml_conv_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_2d_sk_p0(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_conv_2d_sk_p0 extends MustCheck {
    GGML_conv_2d_sk_p0() {
        this.getName() = "ggml_conv_2d_sk_p0"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_2d_s1_ph(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_conv_2d_s1_ph extends MustCheck {
    GGML_conv_2d_s1_ph() {
        this.getName() = "ggml_conv_2d_s1_ph"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_conv_transpose_2d_p0(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     int stride
 * );
 */
class GGML_conv_transpose_2d_p0 extends MustCheck {
    GGML_conv_transpose_2d_p0() {
        this.getName() = "ggml_conv_transpose_2d_p0"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_pool_1d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_op_pool op,
 *     int k0,
 *     // kernel size int s0,
 *     // stride int p0
 * );
 */
class GGML_pool_1d extends MustCheck {
    GGML_pool_1d() {
        this.getName() = "ggml_pool_1d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_pool_2d(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_op_pool op,
 *     int k0,
 *     int k1,
 *     int s0,
 *     int s1,
 *     float p0,
 *     float p1
 * );
 */
class GGML_pool_2d extends MustCheck {
    GGML_pool_2d() {
        this.getName() = "ggml_pool_2d"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_upscale(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int scale_factor
 * );
 */
class GGML_upscale extends MustCheck {
    GGML_upscale() {
        this.getName() = "ggml_upscale"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_pad(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int p0,
 *     int p1,
 *     int p2,
 *     int p3
 * );
 */
class GGML_pad extends MustCheck {
    GGML_pad() {
        this.getName() = "ggml_pad"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_timestep_embedding(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * timesteps,
 *     int dim,
 *     int max_period
 * );
 */
class GGML_timestep_embedding extends MustCheck {
    GGML_timestep_embedding() {
        this.getName() = "ggml_timestep_embedding"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_argsort(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_sort_order order
 * );
 */
class GGML_argsort extends MustCheck {
    GGML_argsort() {
        this.getName() = "ggml_argsort"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_arange(
 *     struct ggml_context * ctx,
 *     float start,
 *     float stop,
 *     float step
 * );
 */
class GGML_arange extends MustCheck {
    GGML_arange() {
        this.getName() = "ggml_arange"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_top_k(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int k
 * );
 */
class GGML_top_k extends MustCheck {
    GGML_top_k() {
        this.getName() = "ggml_top_k"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_flash_attn(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * q,
 *     struct ggml_tensor * k,
 *     struct ggml_tensor * v,
 *     bool masked
 * );
 */
class GGML_flash_attn extends MustCheck {
    GGML_flash_attn() {
        this.getName() = "ggml_flash_attn"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_flash_attn_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * q,
 *     struct ggml_tensor * k,
 *     struct ggml_tensor * v,
 *     struct ggml_tensor * d,
 *     bool masked
 * );
 */
class GGML_flash_attn_back extends MustCheck {
    GGML_flash_attn_back() {
        this.getName() = "ggml_flash_attn_back"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_flash_ff(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b0,
 *     struct ggml_tensor * b1,
 *     struct ggml_tensor * c0,
 *     struct ggml_tensor * c1
 * );
 */
class GGML_flash_ff extends MustCheck {
    GGML_flash_ff() {
        this.getName() = "ggml_flash_ff"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_ssm_conv(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * s,
 *     struct ggml_tensor * x,
 *     struct ggml_tensor * c,
 *     struct ggml_tensor * sq
 * );
 */
class GGML_ssm_conv extends MustCheck {
    GGML_ssm_conv() {
        this.getName() = "ggml_ssm_conv"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_ssm_scan(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * s,
 *     struct ggml_tensor * x,
 *     struct ggml_tensor * dt,
 *     struct ggml_tensor * A,
 *     struct ggml_tensor * B,
 *     struct ggml_tensor * C,
 *     struct ggml_tensor * sq
 * );
 */
class GGML_ssm_scan extends MustCheck {
    GGML_ssm_scan() {
        this.getName() = "ggml_ssm_scan"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_win_part(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int w
 * );
 */
class GGML_win_part extends MustCheck {
    GGML_win_part() {
        this.getName() = "ggml_win_part"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_win_unpart(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int w0,
 *     int h0,
 *     int w
 * );
 */
class GGML_win_unpart extends MustCheck {
    GGML_win_unpart() {
        this.getName() = "ggml_win_unpart"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_unary(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_unary_op op
 * );
 */
class GGML_unary extends MustCheck {
    GGML_unary() {
        this.getName() = "ggml_unary"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_unary_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     enum ggml_unary_op op
 * );
 */
class GGML_unary_inplace extends MustCheck {
    GGML_unary_inplace() {
        this.getName() = "ggml_unary_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_get_rel_pos(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     int qh,
 *     int kh
 * );
 */
class GGML_get_rel_pos extends MustCheck {
    GGML_get_rel_pos() {
        this.getName() = "ggml_get_rel_pos"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add_rel_pos(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * pw,
 *     struct ggml_tensor * ph
 * );
 */
class GGML_add_rel_pos extends MustCheck {
    GGML_add_rel_pos() {
        this.getName() = "ggml_add_rel_pos"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_add_rel_pos_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * pw,
 *     struct ggml_tensor * ph
 * );
 */
class GGML_add_rel_pos_inplace extends MustCheck {
    GGML_add_rel_pos_inplace() {
        this.getName() = "ggml_add_rel_pos_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom1(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     ggml_custom1_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom1 extends MustCheck {
    GGML_map_custom1() {
        this.getName() = "ggml_map_custom1"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom1_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     ggml_custom1_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom1_inplace extends MustCheck {
    GGML_map_custom1_inplace() {
        this.getName() = "ggml_map_custom1_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom2(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     ggml_custom2_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom2 extends MustCheck {
    GGML_map_custom2() {
        this.getName() = "ggml_map_custom2"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom2_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     ggml_custom2_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom2_inplace extends MustCheck {
    GGML_map_custom2_inplace() {
        this.getName() = "ggml_map_custom2_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom3(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     struct ggml_tensor * c,
 *     ggml_custom3_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom3 extends MustCheck {
    GGML_map_custom3() {
        this.getName() = "ggml_map_custom3"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_map_custom3_inplace(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     struct ggml_tensor * c,
 *     ggml_custom3_op_t fun,
 *     int n_tasks,
 *     void * userdata
 * );
 */
class GGML_map_custom3_inplace extends MustCheck {
    GGML_map_custom3_inplace() {
        this.getName() = "ggml_map_custom3_inplace"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cross_entropy_loss(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b
 * );
 */
class GGML_cross_entropy_loss extends MustCheck {
    GGML_cross_entropy_loss() {
        this.getName() = "ggml_cross_entropy_loss"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_cross_entropy_loss_back(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * a,
 *     struct ggml_tensor * b,
 *     struct ggml_tensor * c
 * );
 */
class GGML_cross_entropy_loss_back extends MustCheck {
    GGML_cross_entropy_loss_back() {
        this.getName() = "ggml_cross_entropy_loss_back"
    }
}

/**
 * GGML_API void ggml_set_param(
 *     struct ggml_context * ctx,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_set_param extends Function {
    GGML_set_param() {
        this.getName() = "ggml_set_param"
    }
}

/**
 * GGML_API void ggml_build_forward_expand (
 *     struct ggml_cgraph * cgraph,
 *     struct ggml_tensor * tensor
 * );
 */
class GGML_build_forward_expand extends Function {
    GGML_build_forward_expand() {
        this.getName() = "ggml_build_forward_expand"
    }
}

/**
 * GGML_API void ggml_build_backward_expand(
 *     struct ggml_context * ctx,
 *     struct ggml_cgraph * gf,
 *     struct ggml_cgraph * gb,
 *     bool keep
 * );
 */
class GGML_build_backward_expand extends Function {
    GGML_build_backward_expand() {
        this.getName() = "ggml_build_backward_expand"
    }
}

/**
 * GGML_API struct ggml_cgraph * ggml_new_graph (struct ggml_context * ctx);
 */
class GGML_new_graph extends MustCheck {
    GGML_new_graph() {
        this.getName() = "ggml_new_graph"
    }
}

/**
 * GGML_API struct ggml_cgraph * ggml_new_graph_custom (
 *     struct ggml_context * ctx,
 *     size_t size,
 *     bool grads
 * );
 */
class GGML_new_graph_custom extends MustCheck {
    GGML_new_graph_custom() {
        this.getName() = "ggml_new_graph_custom"
    }
}

/**
 * GGML_API struct ggml_cgraph * ggml_graph_dup (
 *     struct ggml_context * ctx,
 *     struct ggml_cgraph * cgraph
 * );
 */
class GGML_graph_dup extends MustCheck {
    GGML_graph_dup() {
        this.getName() = "ggml_graph_dup"
    }
}

/**
 * GGML_API struct ggml_cgraph ggml_graph_view (
 *     struct ggml_cgraph * cgraph,
 *     int i0,
 *     int i1
 * );
 */
class GGML_graph_view extends MustUse {
    GGML_graph_view() {
        this.getName() = "ggml_graph_view"
    }
}

/**
 * GGML_API void ggml_graph_cpy (
 *     struct ggml_cgraph * src,
 *     struct ggml_cgraph * dst
 * );
 */
class GGML_graph_cpy extends Function {
    GGML_graph_cpy() {
        this.getName() = "ggml_graph_cpy"
    }
}

/**
 * GGML_API void ggml_graph_reset (struct ggml_cgraph * cgraph);
 */
class GGML_graph_reset extends Function {
    GGML_graph_reset() {
        this.getName() = "ggml_graph_reset"
    }
}

/**
 * GGML_API void ggml_graph_clear (struct ggml_cgraph * cgraph);
 */
class GGML_graph_clear extends Function {
    GGML_graph_clear() {
        this.getName() = "ggml_graph_clear"
    }
}

/**
 * GGML_API size_t ggml_graph_overhead(void);
 */
class GGML_graph_overhead extends MustUse {
    GGML_graph_overhead() {
        this.getName() = "ggml_graph_overhead"
    }
}

/**
 * GGML_API size_t ggml_graph_overhead_custom(size_t size, bool grads);
 */
class GGML_graph_overhead_custom extends MustUse {
    GGML_graph_overhead_custom() {
        this.getName() = "ggml_graph_overhead_custom"
    }
}

/**
 * GGML_API struct ggml_cplan ggml_graph_plan (
 *     const struct ggml_cgraph * cgraph,
 *     int n_threads 
 * );
 */
class GGML_graph_plan extends MustUse {
    GGML_graph_plan() {
        this.getName() = "ggml_graph_plan"
    }
}

/**
 * GGML_API enum ggml_status ggml_graph_compute (
 *     struct ggml_cgraph * cgraph,
 *     struct ggml_cplan * cplan
 * );
 */
class GGML_graph_compute extends MustUse {
    GGML_graph_compute() {
        this.getName() = "ggml_graph_compute"
    }
}

/**
 * GGML_API enum ggml_status ggml_graph_compute_with_ctx(
 *     struct ggml_context * ctx,
 *     struct ggml_cgraph * cgraph,
 *     int n_threads
 * );
 */
class GGML_graph_compute_with_ctx extends MustUse {
    GGML_graph_compute_with_ctx() {
        this.getName() = "ggml_graph_compute_with_ctx"
    }
}

/**
 * GGML_API struct ggml_tensor * ggml_graph_get_tensor(
 *     struct ggml_cgraph * cgraph,
 *     const char * name
 * );
 */
class GGML_graph_get_tensor extends MustCheck {
    GGML_graph_get_tensor() {
        this.getName() = "ggml_graph_get_tensor"
    }
}

/**
 * GGML_API void ggml_graph_export(
 *     const struct ggml_cgraph * cgraph,
 *     const char * fname
 * );
 */
class GGML_graph_export extends Function {
    GGML_graph_export() {
        this.getName() = "ggml_graph_export"
    }
}

/**
 * GGML_API struct ggml_cgraph * ggml_graph_import(
 *     const char * fname,
 *     struct ggml_context ** ctx_data,
 *     struct ggml_context ** ctx_eval
 * );
 */
class GGML_graph_import extends MustCheck {
    GGML_graph_import() {
        this.getName() = "ggml_graph_import"
    }
}

/**
 * GGML_API void ggml_graph_print(const struct ggml_cgraph * cgraph);
 */
class GGML_graph_print extends Function {
    GGML_graph_print() {
        this.getName() = "ggml_graph_print"
    }
}

/**
 * GGML_API void ggml_graph_dump_dot(
 *     const struct ggml_cgraph * gb,
 *     const struct ggml_cgraph * gf,
 *     const char * filename
 * );
 */
class GGML_graph_dump_dot extends Function {
    GGML_graph_dump_dot() {
        this.getName() = "ggml_graph_dump_dot"
    }
}

/**
 * GGML_API void ggml_build_backward_gradient_checkpointing(
 *     struct ggml_context * ctx,
 *     struct ggml_cgraph * gf,
 *     struct ggml_cgraph * gb,
 *     struct ggml_cgraph * gb_tmp,
 *     struct ggml_tensor * * checkpoints,
 *     int n_checkpoints
 * );
 */
class GGML_build_backward_gradient_checkpointing extends Function {
    GGML_build_backward_gradient_checkpointing() {
        this.getName() = "ggml_build_backward_gradient_checkpointing"
    }
}

/**
 * GGML_API struct ggml_opt_params ggml_opt_default_params(
 *     enum ggml_opt_type type
 * );
 */
class GGML_opt_default_params extends MustUse {
    GGML_opt_default_params() {
        this.getName() = "ggml_opt_default_params"
    }
}

/**
 * GGML_API enum ggml_opt_result ggml_opt(
 *     struct ggml_context * ctx,
 *     struct ggml_opt_params params,
 *     struct ggml_tensor * f
 * );
 */
class GGML_opt extends MustUse {
    GGML_opt() {
        this.getName() = "ggml_opt"
    }
}

/**
 * GGML_API void ggml_opt_init(
 *     struct ggml_context * ctx,
 *     struct ggml_opt_context * opt,
 *     struct ggml_opt_params params,
 *     int64_t nx
 * );
 */
class GGML_opt_init extends Function {
    GGML_opt_init() {
        this.getName() = "ggml_opt_init"
    }
}

/**
 * GGML_API enum ggml_opt_result ggml_opt_resume(
 *     struct ggml_context * ctx,
 *     struct ggml_opt_context * opt,
 *     struct ggml_tensor * f
 * );
 */
class GGML_opt_resume extends MustUse {
    GGML_opt_resume() {
        this.getName() = "ggml_opt_resume"
    }
}

/**
 * GGML_API enum ggml_opt_result ggml_opt_resume_g(
 *     struct ggml_context * ctx,
 *     struct ggml_opt_context * opt,
 *     struct ggml_tensor * f,
 *     struct ggml_cgraph * gf,
 *     struct ggml_cgraph * gb,
 *     ggml_opt_callback callback,
 *     void * callback_data
 * );
 */
class GGML_opt_resume_g extends MustUse {
    GGML_opt_resume_g() {
        this.getName() = "ggml_opt_resume_g"
    }
}

/**
 * GGML_API void ggml_set_input(struct ggml_tensor * tensor);
 */
class GGML_set_input extends Function {
    GGML_set_input() {
        this.getName() = "ggml_set_input"
    }
}

/**
 * GGML_API void ggml_set_output(struct ggml_tensor * tensor);
 */
class GGML_set_output extends Function {
    GGML_set_output() {
        this.getName() = "ggml_set_output"
    }
}

/**
 * GGML_API void ggml_quantize_init(enum ggml_type type);
 */
class GGML_quantize_init extends Function {
    GGML_quantize_init() {
        this.getName() = "ggml_quantize_init"
    }
}

/**
 * GGML_API void ggml_quantize_free(void);
 */
class GGML_quantize_free extends Function {
    GGML_quantize_free() {
        this.getName() = "ggml_quantize_free"
    }
}

/**
 * GGML_API bool ggml_quantize_requires_imatrix(enum ggml_type type);
 */
class GGML_quantize_requires_imatrix extends MustUse {
    GGML_quantize_requires_imatrix() {
        this.getName() = "ggml_quantize_requires_imatrix"
    }
}

/**
 * GGML_API size_t ggml_quantize_chunk(
 *     enum ggml_type type,
 *     const float * src,
 *     void * dst,
 *     int64_t start,
 *     int64_t nrows,
 *     int64_t n_per_row,
 *     const float * imatrix
 * );
 */
class GGML_quantize_chunk extends MustUse {
    GGML_quantize_chunk() {
        this.getName() = "ggml_quantize_chunk"
    }
}

/**
 * GGML_API struct gguf_context * gguf_init_empty(void);
 */
class GGUF_init_empty extends MustCheck {
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
class GGUF_init_from_file extends MustCheck {
    GGUF_init_from_file() {
        this.getName() = "gguf_init_from_file"
    }
}

/**
 * GGML_API void gguf_free(struct gguf_context * ctx);
 */
class GGUF_free extends Function {
    GGUF_free() {
        this.getName() = "gguf_free"
    }
}

/**
 * GGML_API const char * gguf_type_name(enum gguf_type type);
 */
class GGUF_type_name extends MustCheck {
    GGUF_type_name() {
        this.getName() = "gguf_type_name"
    }
}

/**
 * GGML_API int gguf_get_version (const struct gguf_context * ctx);
 */
class GGUF_get_version extends MustUse {
    GGUF_get_version() {
        this.getName() = "gguf_get_version"
    }
}

/**
 * GGML_API size_t gguf_get_alignment (const struct gguf_context * ctx);
 */
class GGUF_get_alignment extends MustUse {
    GGUF_get_alignment() {
        this.getName() = "gguf_get_alignment"
    }
}

/**
 * GGML_API size_t gguf_get_data_offset(const struct gguf_context * ctx);
 */
class GGUF_get_data_offset extends MustUse {
    GGUF_get_data_offset() {
        this.getName() = "gguf_get_data_offset"
    }
}

/**
 * GGML_API void * gguf_get_data (const struct gguf_context * ctx);
 */
class GGUF_get_data extends MustCheck {
    GGUF_get_data() {
        this.getName() = "gguf_get_data"
    }
}

/**
 * GGML_API int gguf_get_n_kv(const struct gguf_context * ctx);
 */
class GGUF_get_n_kv extends MustUse {
    GGUF_get_n_kv() {
        this.getName() = "gguf_get_n_kv"
    }
}

/**
 * GGML_API int gguf_find_key(
 *     const struct gguf_context * ctx,
 *     const char * key
 * );
 */
class GGUF_find_key extends MustUse {
    GGUF_find_key() {
        this.getName() = "gguf_find_key"
    }
}

/**
 * GGML_API const char * gguf_get_key (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_key extends MustCheck {
    GGUF_get_key() {
        this.getName() = "gguf_get_key"
    }
}

/**
 * GGML_API enum gguf_type gguf_get_kv_type (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_kv_type extends MustUse {
    GGUF_get_kv_type() {
        this.getName() = "gguf_get_kv_type"
    }
}

/**
 * GGML_API enum gguf_type gguf_get_arr_type(
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_arr_type extends MustUse {
    GGUF_get_arr_type() {
        this.getName() = "gguf_get_arr_type"
    }
}

/**
 * GGML_API uint8_t gguf_get_val_u8 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_u8 extends MustUse {
    GGUF_get_val_u8() {
        this.getName() = "gguf_get_val_u8"
    }
}

/**
 * GGML_API int8_t gguf_get_val_i8 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_i8 extends MustUse {
    GGUF_get_val_i8() {
        this.getName() = "gguf_get_val_i8"
    }
}

/**
 * GGML_API uint16_t gguf_get_val_u16 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_u16 extends MustUse {
    GGUF_get_val_u16() {
        this.getName() = "gguf_get_val_u16"
    }
}

/**
 * GGML_API int16_t gguf_get_val_i16 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_i16 extends MustUse {
    GGUF_get_val_i16() {
        this.getName() = "gguf_get_val_i16"
    }
}

/**
 * GGML_API uint32_t gguf_get_val_u32 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_u32 extends MustUse {
    GGUF_get_val_u32() {
        this.getName() = "gguf_get_val_u32"
    }
}

/**
 * GGML_API int32_t gguf_get_val_i32 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_i32 extends MustUse {
    GGUF_get_val_i32() {
        this.getName() = "gguf_get_val_i32"
    }
}

/**
 * GGML_API float gguf_get_val_f32 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_f32 extends MustUse {
    GGUF_get_val_f32() {
        this.getName() = "gguf_get_val_f32"
    }
}

/**
 * GGML_API uint64_t gguf_get_val_u64 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_u64 extends MustUse {
    GGUF_get_val_u64() {
        this.getName() = "gguf_get_val_u64"
    }
}

/**
 * GGML_API int64_t gguf_get_val_i64 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_i64 extends MustUse {
    GGUF_get_val_i64() {
        this.getName() = "gguf_get_val_i64"
    }
}

/**
 * GGML_API double gguf_get_val_f64 (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_f64 extends MustUse {
    GGUF_get_val_f64() {
        this.getName() = "gguf_get_val_f64"
    }
}

/**
 * GGML_API bool gguf_get_val_bool(const struct gguf_context * ctx, int key_id);
 */
class GGUF_get_val_bool extends MustUse {
    GGUF_get_val_bool() {
        this.getName() = "gguf_get_val_bool"
    }
}

/**
 * GGML_API const char * gguf_get_val_str (
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_str extends MustCheck {
    GGUF_get_val_str() {
        this.getName() = "gguf_get_val_str"
    }
}

/**
 * GGML_API const void * gguf_get_val_data(
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_val_data extends MustCheck {
    GGUF_get_val_data() {
        this.getName() = "gguf_get_val_data"
    }
}

/**
 * GGML_API int gguf_get_arr_n (const struct gguf_context * ctx, int key_id);
 */
class GGUF_get_arr_n extends MustUse {
    GGUF_get_arr_n() {
        this.getName() = "gguf_get_arr_n"
    }
}

/**
 * GGML_API const void * gguf_get_arr_data(
 *     const struct gguf_context * ctx,
 *     int key_id
 * );
 */
class GGUF_get_arr_data extends MustCheck {
    GGUF_get_arr_data() {
        this.getName() = "gguf_get_arr_data"
    }
}

/**
 * GGML_API const char * gguf_get_arr_str (
 *     const struct gguf_context * ctx,
 *     int key_id,
 *     int i
 * );
 */
class GGUF_get_arr_str extends MustCheck {
    GGUF_get_arr_str() {
        this.getName() = "gguf_get_arr_str"
    }
}

/**
 * GGML_API int gguf_get_n_tensors (const struct gguf_context * ctx);
 */
class GGUF_get_n_tensors extends MustUse {
    GGUF_get_n_tensors() {
        this.getName() = "gguf_get_n_tensors"
    }
}

/**
 * GGML_API int gguf_find_tensor (
 *     const struct gguf_context * ctx,
 *     const char * name
 * );
 */
class GGUF_find_tensor extends MustUse {
    GGUF_find_tensor() {
        this.getName() = "gguf_find_tensor"
    }
}

/**
 * GGML_API size_t gguf_get_tensor_offset(
 *     const struct gguf_context * ctx,
 *     int i
 * );
 */
class GGUF_get_tensor_offset extends MustUse {
    GGUF_get_tensor_offset() {
        this.getName() = "gguf_get_tensor_offset"
    }
}

/**
 * GGML_API char * gguf_get_tensor_name (
 *     const struct gguf_context * ctx,
 *     int i
 * );
 */
class GGUF_get_tensor_name extends MustCheck {
    GGUF_get_tensor_name() {
        this.getName() = "gguf_get_tensor_name"
    }
}

/**
 * GGML_API enum ggml_type gguf_get_tensor_type (
 *     const struct gguf_context * ctx,
 *     int i
 * );
 */
class GGUF_get_tensor_type extends MustUse {
    GGUF_get_tensor_type() {
        this.getName() = "gguf_get_tensor_type"
    }
}

/**
 * GGML_API void gguf_set_val_u8 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     uint8_t val
 * );
 */
class GGUF_set_val_u8 extends Function {
    GGUF_set_val_u8() {
        this.getName() = "gguf_set_val_u8"
    }
}

/**
 * GGML_API void gguf_set_val_i8 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     int8_t val
 * );
 */
class GGUF_set_val_i8 extends Function {
    GGUF_set_val_i8() {
        this.getName() = "gguf_set_val_i8"
    }
}

/**
 * GGML_API void gguf_set_val_u16 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     uint16_t val
 * );
 */
class GGUF_set_val_u16 extends Function {
    GGUF_set_val_u16() {
        this.getName() = "gguf_set_val_u16"
    }
}

/**
 * GGML_API void gguf_set_val_i16 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     int16_t val
 * );
 */
class GGUF_set_val_i16 extends Function {
    GGUF_set_val_i16() {
        this.getName() = "gguf_set_val_i16"
    }
}

/**
 * GGML_API void gguf_set_val_u32 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     uint32_t val
 * );
 */
class GGUF_set_val_u32 extends Function {
    GGUF_set_val_u32() {
        this.getName() = "gguf_set_val_u32"
    }
}

/**
 * GGML_API void gguf_set_val_i32 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     int32_t val
 * );
 */
class GGUF_set_val_i32 extends Function {
    GGUF_set_val_i32() {
        this.getName() = "gguf_set_val_i32"
    }
}

/**
 * GGML_API void gguf_set_val_f32 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     float val
 * );
 */
class GGUF_set_val_f32 extends Function {
    GGUF_set_val_f32() {
        this.getName() = "gguf_set_val_f32"
    }
}

/**
 * GGML_API void gguf_set_val_u64 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     uint64_t val
 * );
 */
class GGUF_set_val_u64 extends Function {
    GGUF_set_val_u64() {
        this.getName() = "gguf_set_val_u64"
    }
}

/**
 * GGML_API void gguf_set_val_i64 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     int64_t val
 * );
 */
class GGUF_set_val_i64 extends Function {
    GGUF_set_val_i64() {
        this.getName() = "gguf_set_val_i64"
    }
}

/**
 * GGML_API void gguf_set_val_f64 (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     double val
 * );
 */
class GGUF_set_val_f64 extends Function {
    GGUF_set_val_f64() {
        this.getName() = "gguf_set_val_f64"
    }
}

/**
 * GGML_API void gguf_set_val_bool(
 *     struct gguf_context * ctx,
 *     const char * key,
 *     bool val
 * );
 */
class GGUF_set_val_bool extends Function {
    GGUF_set_val_bool() {
        this.getName() = "gguf_set_val_bool"
    }
}

/**
 * GGML_API void gguf_set_val_str (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     const char * val
 * );
 */
class GGUF_set_val_str extends Function {
    GGUF_set_val_str() {
        this.getName() = "gguf_set_val_str"
    }
}

/**
 * GGML_API void gguf_set_arr_data(
 *     struct gguf_context * ctx,
 *     const char * key,
 *     enum gguf_type type,
 *     const void * data,
 *     int n
 * );
 */
class GGUF_set_arr_data extends Function {
    GGUF_set_arr_data() {
        this.getName() = "gguf_set_arr_data"
    }
}

/**
 * GGML_API void gguf_set_arr_str (
 *     struct gguf_context * ctx,
 *     const char * key,
 *     const char ** data,
 *     int n
 * );
 */
class GGUF_set_arr_str extends Function {
    GGUF_set_arr_str() {
        this.getName() = "gguf_set_arr_str"
    }
}

/**
 * GGML_API void gguf_set_kv(
 *     struct gguf_context * ctx,
 *     struct gguf_context * src
 * );
 */
class GGUF_set_kv extends Function {
    GGUF_set_kv() {
        this.getName() = "gguf_set_kv"
    }
}

/**
 * GGML_API void gguf_add_tensor(
 *     struct gguf_context * ctx,
 *     const struct ggml_tensor * tensor
 * );
 */
class GGUF_add_tensor extends Function {
    GGUF_add_tensor() {
        this.getName() = "gguf_add_tensor"
    }
}

/**
 * GGML_API void gguf_set_tensor_type(
 *     struct gguf_context * ctx,
 *     const char * name,
 *     enum ggml_type type
 * );
 */
class GGUF_set_tensor_type extends Function {
    GGUF_set_tensor_type() {
        this.getName() = "gguf_set_tensor_type"
    }
}

/**
 * GGML_API void gguf_set_tensor_data(
 *     struct gguf_context * ctx,
 *     const char * name,
 *     const void * data,
 *     size_t size
 * );
 */
class GGUF_set_tensor_data extends Function {
    GGUF_set_tensor_data() {
        this.getName() = "gguf_set_tensor_data"
    }
}

/**
 * GGML_API void gguf_write_to_file(
 *     const struct gguf_context * ctx,
 *     const char * fname,
 *     bool only_meta
 * );
 */
class GGUF_write_to_file extends Function {
    GGUF_write_to_file() {
        this.getName() = "gguf_write_to_file"
    }
}

/**
 * GGML_API size_t gguf_get_meta_size(const struct gguf_context * ctx);
 */
class GGUF_get_meta_size extends MustUse {
    GGUF_get_meta_size() {
        this.getName() = "gguf_get_meta_size"
    }
}

/**
 * GGML_API void gguf_get_meta_data(
 *     const struct gguf_context * ctx,
 *     void * data
 * );
 */
class GGUF_get_meta_data extends Function {
    GGUF_get_meta_data() {
        this.getName() = "gguf_get_meta_data"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx (void);
 */
class GGML_cpu_has_avx extends MustUse {
    GGML_cpu_has_avx() {
        this.getName() = "ggml_cpu_has_avx"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx_vnni (void);
 */
class GGML_cpu_has_avx_vnni extends MustUse {
    GGML_cpu_has_avx_vnni() {
        this.getName() = "ggml_cpu_has_avx_vnni"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx2 (void);
 */
class GGML_cpu_has_avx2 extends MustUse {
    GGML_cpu_has_avx2() {
        this.getName() = "ggml_cpu_has_avx2"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx512 (void);
 */
class GGML_cpu_has_avx512 extends MustUse {
    GGML_cpu_has_avx512() {
        this.getName() = "ggml_cpu_has_avx512"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx512_vbmi(void);
 */
class GGML_cpu_has_avx512_vbmi extends MustUse {
    GGML_cpu_has_avx512_vbmi() {
        this.getName() = "ggml_cpu_has_avx512_vbmi"
    }
}

/**
 * GGML_API int ggml_cpu_has_avx512_vnni(void);
 */
class GGML_cpu_has_avx512_vnni extends MustUse {
    GGML_cpu_has_avx512_vnni() {
        this.getName() = "ggml_cpu_has_avx512_vnni"
    }
}

/**
 * GGML_API int ggml_cpu_has_fma (void);
 */
class GGML_cpu_has_fma extends MustUse {
    GGML_cpu_has_fma() {
        this.getName() = "ggml_cpu_has_fma"
    }
}

/**
 * GGML_API int ggml_cpu_has_neon (void);
 */
class GGML_cpu_has_neon extends MustUse {
    GGML_cpu_has_neon() {
        this.getName() = "ggml_cpu_has_neon"
    }
}

/**
 * GGML_API int ggml_cpu_has_arm_fma (void);
 */
class GGML_cpu_has_arm_fma extends MustUse {
    GGML_cpu_has_arm_fma() {
        this.getName() = "ggml_cpu_has_arm_fma"
    }
}

/**
 * GGML_API int ggml_cpu_has_metal (void);
 */
class GGML_cpu_has_metal extends MustUse {
    GGML_cpu_has_metal() {
        this.getName() = "ggml_cpu_has_metal"
    }
}

/**
 * GGML_API int ggml_cpu_has_f16c (void);
 */
class GGML_cpu_has_f16c extends MustUse {
    GGML_cpu_has_f16c() {
        this.getName() = "ggml_cpu_has_f16c"
    }
}

/**
 * GGML_API int ggml_cpu_has_fp16_va (void);
 */
class GGML_cpu_has_fp16_va extends MustUse {
    GGML_cpu_has_fp16_va() {
        this.getName() = "ggml_cpu_has_fp16_va"
    }
}

/**
 * GGML_API int ggml_cpu_has_wasm_simd (void);
 */
class GGML_cpu_has_wasm_simd extends MustUse {
    GGML_cpu_has_wasm_simd() {
        this.getName() = "ggml_cpu_has_wasm_simd"
    }
}

/**
 * GGML_API int ggml_cpu_has_blas (void);
 */
class GGML_cpu_has_blas extends MustUse {
    GGML_cpu_has_blas() {
        this.getName() = "ggml_cpu_has_blas"
    }
}

/**
 * GGML_API int ggml_cpu_has_cuda (void);
 */
class GGML_cpu_has_cuda extends MustUse {
    GGML_cpu_has_cuda() {
        this.getName() = "ggml_cpu_has_cuda"
    }
}

/**
 * GGML_API int ggml_cpu_has_clblast (void);
 */
class GGML_cpu_has_clblast extends MustUse {
    GGML_cpu_has_clblast() {
        this.getName() = "ggml_cpu_has_clblast"
    }
}

/**
 * GGML_API int ggml_cpu_has_vulkan (void);
 */
class GGML_cpu_has_vulkan extends MustUse {
    GGML_cpu_has_vulkan() {
        this.getName() = "ggml_cpu_has_vulkan"
    }
}

/**
 * GGML_API int ggml_cpu_has_kompute (void);
 */
class GGML_cpu_has_kompute extends MustUse {
    GGML_cpu_has_kompute() {
        this.getName() = "ggml_cpu_has_kompute"
    }
}

/**
 * GGML_API int ggml_cpu_has_gpublas (void);
 */
class GGML_cpu_has_gpublas extends MustUse {
    GGML_cpu_has_gpublas() {
        this.getName() = "ggml_cpu_has_gpublas"
    }
}

/**
 * GGML_API int ggml_cpu_has_sse3 (void);
 */
class GGML_cpu_has_sse3 extends MustUse {
    GGML_cpu_has_sse3() {
        this.getName() = "ggml_cpu_has_sse3"
    }
}

/**
 * GGML_API int ggml_cpu_has_ssse3 (void);
 */
class GGML_cpu_has_ssse3 extends MustUse {
    GGML_cpu_has_ssse3() {
        this.getName() = "ggml_cpu_has_ssse3"
    }
}

/**
 * GGML_API int ggml_cpu_has_sycl (void);
 */
class GGML_cpu_has_sycl extends MustUse {
    GGML_cpu_has_sycl() {
        this.getName() = "ggml_cpu_has_sycl"
    }
}

/**
 * GGML_API int ggml_cpu_has_vsx (void);
 */
class GGML_cpu_has_vsx extends MustUse {
    GGML_cpu_has_vsx() {
        this.getName() = "ggml_cpu_has_vsx"
    }
}

/**
 * GGML_API int ggml_cpu_has_matmul_int8(void);
 */
class GGML_cpu_has_matmul_int8 extends MustUse {
    GGML_cpu_has_matmul_int8() {
        this.getName() = "ggml_cpu_has_matmul_int8"
    }
}

/**
 * GGML_API ggml_type_traits_t ggml_internal_get_type_traits(
 *     enum ggml_type type
 * );
 */
class GGML_internal_get_type_traits extends MustUse {
    GGML_internal_get_type_traits() {
        this.getName() = "ggml_internal_get_type_traits"
    }
}
