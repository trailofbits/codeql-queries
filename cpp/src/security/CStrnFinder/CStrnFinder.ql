/**
 * @name Invalid string size passed to string manipulation function
 * @id tob/cpp/cstrnfinder
 * @description Finds calls to functions that take as input a string and its size as separate arguments (e.g., `strncmp`, `strncat`, ...) and the size argument is wrong
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision low
 * @security-severity 4.0
 * @group security
 */

import cpp
import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.dataflow.new.DataFlow

/* 
 * Class for all functions interesting for us 
 */
abstract class StrNFunction extends Function {
  abstract int getSourceArgs();
  abstract int getSizeArg();
}

/* 
 * Class for functions with two input (source) arguments
 */
class StrNFunctionCallTwoSources extends StrNFunction {
  StrNFunctionCallTwoSources() {
    this.getName() in [
      // STRNCMP like
      "strncmp",  // strncmp(src_a, src_b, count)
      "strnicmp", // strnicmp(src_a, src_b, count)
      "strncasecmp", // strncasecmp(src_a, src_b, count)
      "bcmp", // bcmp(src_a, src_b, count)
      "_mbsnbcmp", // _mbsnbcmp(src_a, src_b, count) multibyte
      "_mbsnbcmp_l", // _mbsnbcmp_l(src_a, src_b, count, locale) multibyte
      "_mbsncmp", // _mbsncmp(src_a, src_b, count) multibyte
      "_mbsncmp_l", // _mbsncmp_l(src_a, src_b, count, locale) multibyte
      "wcsncmp", // wcsncmp(src_a, src_b, count) widechar
      "wcsncasecmp", // wcsncasecmp(src_a, src_b, count) widechar
      "wcsncasecmp_l", // wcsncasecmp(src_a, src_b, count, locale) widechar

      // MEMCMP like
      "memcmp", // memcmp(src_a, src_b, count)
      "_memicmp", // _memicmp(src_a, src_b, count)
      "_memicmp_l", // _memicmp_l(src_a, src_b, count, locale)
      "wmemcmp" // wmemcmp(src_a, src_b, count) widechar
    ]
  }

  override int getSourceArgs() {
    result = 0
    or
    result = 1
  }

  override int getSizeArg() {
    result = 2
  }
}

/* 
 * Class for functions with single input (source) argument
 */
class StrNFunctionCallSingleSource extends StrNFunction {
  // https://github.com/gcc-mirror/gcc/blob/f3fc9b804a4e552a173e2d4071b2adec33178161/gcc/testsuite/gcc.c-torture/execute/builtins/chk.h
  // https://www.ibm.com/docs/ko/xl-c-and-cpp-linux/16.1.0?topic=functions-builtin-chk
  // https://github.com/llvm/llvm-project/blob/53e5cd4d3e39dad47312a48d4c6c71318bb2c283/clang/lib/Sema/SemaChecking.cpp#L1261-L1293
  
  StrNFunctionCallSingleSource() {
    // STRNCPY like
    this.hasGlobalOrStdOrBslName([
      "strncpy", // strncpy(dst, src, max_copy)
      "__builtin___strncpy_chk", // __builtin___strncpy_chk (dst, src, max_copy, os)
      "__builtin_strncpy", // __builtin_strncpy (dst, src, max_copy)
      "wcsncpy", // wcsncpy(dst, src, max_copy) widechar
      "strxfrm", // strxfrm(dst, src, max_copy)
      "wcsxfrm" // wcsxfrm(dst, src, max_copy) widechar
      // should be safe
      // "wcsncpy_s" // wcsncpy_s(dst, dst_size, src, max_copy)
      // "wcslcpy" // wcslcpy(dst, src, dst_size)
    ])
    or
    this.hasGlobalName([
      "_strncpy_l", // _strncpy_l(dst, src, max_copy, locale)
      "_wcsncpy_l", // _wcsncpy_l(dst, src, max_copy, locale) widechar
      "_mbsncpy", // _mbsncpy(dst, src, max_copy) multibyte
      "_mbsncpy_l", // _mbsncpy_l(dst, src, max_copy, locale) multibyte
      "_strxfrm_l", // _strxfrm_l(dst, src, max_copy, locale)
      "wcsxfrm_l", // _strxfrm_l(dst, src, max_copy, locale) widechar
      "_mbsnbcpy", // _mbsnbcpy(dst, src, max_copy) multibyte
      "_mbsnbcpy_l", // _mbsnbcpy_l(dst, src, max_copy, locale) multibyte
      // should be safe
      // "_mbsnbcpy_s", // _mbsnbcpy_s(dst, dst_size, src)
      // "_mbsnbcpy_s_l", // _mbsnbcpy_s_l(dst, dst_size, src, locale)
      // "_mbscpy_s", // _mbscpy_s(dst, dst_size, src)
      "stpncpy", // stpncpy(dst, src, max_copy)
      "__builtin___stpncpy_chk", // __builtin___stpncpy_chk(dst, src, max_copy, os)
      "__builtin_stpncpy", // __builtin_stpncpy(dst, src, max_copy)
      "strlcpy", // strlcpy(dst, src, max_copy_minus_one)
      "__builtin___strlcpy_chk" // __builtin___strlcpy_chk(dst, src, max_copy_minus_one)
    ])
    
    // should be safe
    // or
    // this.hasGlobalOrStdName([
    //   "strcpy_s", // strcpy_s(dst, dst_size, src)
    //   "wcscpy_s" // wcscpy_s(dst, dst_size, src) widechar
    // ])

    // STRNCAT like
    or
    this.hasGlobalOrStdOrBslName([
      "strncat", // strncat(dst, src, max_copy)
      "__builtin___strncat_chk", // __builtin___strncat_chk(dst, src, max_copy, os)
      "__builtin_strncat", // __builtin_strncat(dst, src, max_copy)
      "wcsncat", // wcsncat(dst, src, max_copy) widechar
      // should be safe
      // "wcsncat_s" // wcsncat_s(dst, dst_size, src, max_copy)
      // "wcslcat" // wcslcat(dst, src, dst_size)
    ])
    or
    this.hasGlobalName([
      "_mbsncat", // _mbsncat(dst, src, max_copy) multibyte
      "_mbsncat_l", // _mbsncat_l(dst, src, max_copy, locale) multibyte
      "_mbsnbcat", // _mbsnbcat(dst, src, max_copy)
      "_mbsnbcat_l" // _mbsnbcat_l(dst, src, max_copy, locale)
      // should be safe
      // "_mbsnbcat_s"
      // "_mbsnbcat_s_l"

      // STRL should be safe
      // "strlcat", // strlcat(dst, src, dst_size)
      // "__builtin___strlcat_chk", // __builtin___strlcat_chk(dst, src, dst_size)
    ])

    // MEMCPY like
    or
    this.hasGlobalOrStdOrBslName([
      "memcpy", // memcpy(dst, src, max_copy)
      "__builtin___memcpy_chk", // __builtin___memcpy_chk (dst, src, max_copy, os)
      "__builtin_memcpy", // __builtin_memcpy(dst, src, max_copy, os)
      "memmove", // memmove(dst, src, max_copy)
      " __builtin___memmove_chk", // __builtin___memmove_chk(dst, src, max_copy, os)
      "__builtin_memmove", // __builtin_memmove(dst, src, max_copy)
      "wmemmove" // wmemmove(dst, src, max_copy) widechar
    ])
    or
    this.hasGlobalName([
      "bcopy", // bcopy(src, dst, max_copy)
      "mempcpy", // mempcpy(dst, src, max_copy)
      " __builtin___mempcpy_chk", // __builtin___mempcpy_chk(dst, src, max_copy, os)
      "__builtin_mempcpy", // __builtin_mempcpy(dst, src, max_copy)
      "memccpy", // memccpy(dst, src, c, max_copy)
      "__builtin___memccpy_chk", // __builtin___memccpy_chk() TODO - args
      "wmemcpy", // wmemcpy(dst, src, max_copy) widechar
      "wmempcpy", // wmempcpy(dst, src, max_copy) widechar
      "wmemccpy", // wmemccpy(dst, src, max_copy) widechar
      "wcpncpy", // wcpncpy(dst, src, max_copy) widechar
      "RtlCopyMemoryNonTemporal" // RtlCopyMemoryNonTemporal(dst, src, max_copy)
    ])
  }

  override int getSourceArgs() {
    if this.getName() in ["bcopy"] then
      result = 0
    else
      result = 1
  }

  override int getSizeArg() {
    if this.getName() in ["memccpy", "__builtin___memccpy_chk"] then
      result = 3
    else
      result = 2
  }
}

/*
 * Finds constant numeric value of the given expression, if possible
 */
int getKnownInt(Expr argument) {
  result = argument.getValue().toInt()
}

/*
 * Finds length of given string, if possible
 * The length does not count terminating nullbyte
 */ 
int getKnownLen(Expr sourceArg) {
  result = sourceArg.(StringLiteral).getOriginalLength() - 1
  or
  exists(LocalScopeVariable v, SsaDefinition ssaDef |
    sourceArg = ssaDef.getAUse(v)
    and result = ssaDef.getAnUltimateDefiningValue(v).(StringLiteral).getOriginalLength() - 1
  )
}

// TODO: review against widechars and multibytes
from StrNFunction f, FunctionCall fc,  int sourceSize, int sizeArgValue, string msg
where
  // find calls to interesting functions
  f = fc.getTarget()

  // consider only the shorter argument for two-arg functions (e.g., strncmp)
  and sourceSize = min(int sourceSizeTmp |
    sourceSizeTmp = getKnownLen(fc.getArgument(f.getSourceArgs())) |
    sourceSizeTmp
  )
  
  // get size argument
  and sizeArgValue = getKnownInt(fc.getArgument(f.getSizeArg()))

  and
  (
    // typo bug
    // for "testabc" report sizes 6 and 5; 7 and greater sizes are fine; greater typos are probably intended
    (
      sourceSize - sizeArgValue = [1, 2]
      and msg = "Not whole source buffer is consumed, which may be a bug."
    )
    or
    (
      sizeArgValue - 1 > sourceSize
      and
      if f.getName().matches("%mem%") or f.getName() in ["RtlCopyMemoryNonTemporal", "bcopy"] then
        msg = "This is a buffer overread vulnerability."
      else if f.getName().matches("%cat%") then
        msg = "This indicates that the destination buffer may overflow, as the size argument limits amount of bytes copied, and not total length."
      else
        none()
    )
  )

select fc, "Call to " + f.getName() + " receives an input string of size " + sourceSize +
          ", but is passed size argument of " + sizeArgValue + ". " + msg
