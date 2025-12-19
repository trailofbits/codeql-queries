/**
 * @name Missing null terminator
 * @id tob/cpp/no-null-terminator
 * @description This query finds incorrectly initialized strings that are passed to functions expecting null-byte-terminated strings
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @security-severity 7.0
 * @group security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.models.implementations.Strcpy
import semmle.code.cpp.commons.Printf
import semmle.code.cpp.commons.StringAnalysis

class NullStrFunction extends Function {
  int strPosition;

  NullStrFunction() {
    this instanceof StrcpyFunction and strPosition = this.(StrcpyFunction).getParamSrc()
    or
    this instanceof FormattingFunction and strPosition = [0 .. this.getNumberOfParameters()]
    or
    this.getName() =
      [
        "strcasecmp", "strstr", "strcasecmp_l", "strcasestr", "strcasestr_l", "strcoll_l",
        "strlcpy", "strlcat", "strtok_r", "strcat", "strcmp", "strcoll", "strspn", "strcspn",
        "strtok", "strpbrk"
      ] and
    strPosition = [0, 1]
    or
    this.getName() =
      [
        "strchr", "strrchr", "strlen", "wcslen", "_mbslen", "_mbslen_l", "_mbstrlen", "_mbstrlen_l",
        "strdup", "perror"
      ] and
    strPosition = 0
    or
    this.getName() = ["strvis", "stravis"] and
    strPosition = 1
  }

  int getStrPosition() { result = strPosition }
}

module StrFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getType() instanceof AnyCharArrayType
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc, NullStrFunction f |
      fc.getTarget() = f and
      sink.asExpr() = fc.getArgument(f.getStrPosition())
    )
  }
}

module StrFlow = DataFlow::Global<StrFlowConfig>;

// based on https://github.com/github/codeql/blob/main/cpp/ql/src/Security/CWE/CWE-676/DangerousUseOfCin.ql
class AnyCharArrayType extends ArrayType {
  AnyCharArrayType() {
    (
      this.getBaseType().getUnderlyingType() instanceof CharType
      or
      this.getBaseType() instanceof Wchar_t
    ) and
    this.hasArraySize()
  }
}

from
  Variable var, StringLiteral varInit, string msg, int varSize, int varInitSize, FunctionCall fc,
  DataFlow::Node sink
where
  var.getType() instanceof AnyCharArrayType and
  varSize = var.getType().getSize() and
  varInit = var.getInitializer().getExpr().getFullyConverted() and
  varInitSize = varInit.getValue().length() * var.getType().(ArrayType).getBaseType().getSize() and
  (
    // array won't have terminating null byte
    varSize = varInitSize and
    msg =
      ", as the arary size is equal to initialization string's length (" + varInitSize + " bytes)."
    or
    // should not be possible
    varSize < varInitSize and
    msg =
      ", as initialization string's length (" + varInitSize + ") is greater than the arary size (" +
        varSize + ")."
  ) and
  // TODO: there is no explicit nullbyte in the string
  // and not exists(int i | varInit.getValue().charAt(i) = "\u0000" )
  // the string flows to a str function (eg strcpy, strcat, printf)
  StrFlow::flow(DataFlow::exprNode(var.getAnAccess()), sink) and
  fc.getAnArgument() = sink.asExpr()
select var,
  "String is initialized without terminating null byte" + msg +
    ". String is then used as an argument to a function requiring null-terminated strings: $@", fc,
  fc.toString()
