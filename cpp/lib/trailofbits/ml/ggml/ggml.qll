// *********************************************************************
//
//  This library has been automatically generated using the Busy Work
//  VSCode extension from the file 'ggml.h'.                         
//
// *********************************************************************
import cpp
import trailofbits.common

// *********************************************************************
//
//  Function types matching the individual functions defined by       
//  'ggml.h'.                                                        
//
// *********************************************************************

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
 * struct ggml_context * ggml_init(struct ggml_init_params params);
 */
class GGML_init extends Alloc {
    GGML_init() {
        this.getName() = "ggml_init"
    }
}

/**
 * GGML_API void ggml_free(struct ggml_context * ctx);
 */
class GGML_free extends Free {
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
 * GGML_API void ggml_mul_mat_set_prec(
 *      struct ggml_tensor * a,
 *     enum ggml_prec prec
 * );
 */
class GGML_mul_mat_set_prec extends Function {
    GGML_mul_mat_set_prec() {
        this.getName() = "ggml_mul_mat_set_prec"
    }
}

/**
 * GGML_CALL void ggml_rope_yarn_corr_dims(
 *      int n_dims,
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
 *      struct ggml_context * ctx,
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
 *      struct ggml_context * ctx,
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
 *      struct ggml_context * ctx,
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
 *      struct ggml_context * ctx,
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
 *      enum ggml_type type,
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
 * GGML_API int gguf_get_arr_n (const struct gguf_context * ctx, int key_id);
 */
class GGUF_get_arr_n extends MustUse {
    GGUF_get_arr_n() {
        this.getName() = "gguf_get_arr_n"
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

// *********************************************************************
//
//  Custom allocators defined by 'ggml.h'.                     
//
// *********************************************************************

/**
 * Alloc:
 *     ggml_init
 *
 * Free:
 *     ggml_free
 */
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