/**
 * @name Invalid file permission parameter
 * @id tob/go/file-perms-flaws
 * @description Finds non-octal (e.g., `755` vs `0o755`) and unsupported (e.g., `04666`) literals used as a filesystem permission parameter (`FileMode`)
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @security-severity 4.0
 * @group security
 */

import go

/*
 * From https://github.com/github/codeql/blob/ef0ea247c40da805efa427a37f5213457d18f714/cpp/ql/src/Security/CWE/CWE-732/FilePermissions.qll#L4-L21
 */

bindingset[n, digit]
private string octalDigit(int n, int digit) {
  result = n.bitShiftRight(digit * 3).bitAnd(7).toString()
}

bindingset[n, digit]
private string octalDigitOpt(int n, int digit) {
  exists(string s | s = octalDigit(n, digit) | if s = "0" then result = "" else result = s)
}

bindingset[mode]
string octalFileMode(int mode) {
  result = octalDigitOpt(mode, 3) + octalDigit(mode, 2) + octalDigit(mode, 1) + octalDigit(mode, 0)
}

predicate isKnownValidConstant(string fileMode) {
  fileMode = ["365", "420", "436", "438", "511", "509", "493"]
  or
  fileMode = ["0x16d", "0x1a4", "0x1b4", "0x1b6", "0x1ff", "0x1fd", "0x1ed"]
}

class PermChangingMethod extends CallExpr {
  PermChangingMethod() {
    this.getTarget().hasQualifiedName("os", ["Chmod", "Mkdir", "MkdirAll", "WriteFile", "OpenFile"])
    or
    this.getTarget().hasQualifiedName("os.File", ["Chmod"])
  }
}

/*
 * TODO: on windows OS, only '0400' and '0600' should be used https://golang.org/pkg/os/#Chmod
 */

from Expr fileModeExpr, IntLit fileModeLit, int fileModeInt, string fileModeLitStr, string message
where
  // get a FileMode
  fileModeExpr.getType().getName() = "FileMode" and
  // go over all numeric constants in expressions like `013 | 37 & os.ModeSticky`
  fileModeLit.getParent*() = fileModeExpr and
  // get integer and string values of the mode
  fileModeLit.getIntValue() = fileModeInt and
  fileModeLitStr = fileModeLit.toString() and
  // skip reporting if a popular decimal constant is used
  not isKnownValidConstant(fileModeLitStr) and
  // report early if special bits are set in modes for function calls
  // Go uses only 9 permission bits for Mkdir, Chmod etc
  // and support for other bits is platform specific
  // for details see https://github.com/golang/go/issues/25539#issuecomment-394484403
  // TODO: use only permission-changing methods
  // chmod
  if
    fileModeInt > 511 and
    /* 0o777 */ exists(PermChangingMethod use | use.getAnArgument() = fileModeExpr)
  then
    message =
      "- only 9 permission bits are supported in Mkdir/MkdirAll/Chmod methods on all platforms"
  else (
    // skip reporting if the mode is large - probably a mask
    not fileModeInt > 1911 and
    /* 0x777 */
    // the most interesting case of number encoding typos
    exists(string fileModeAsOctal, string fileModeAsSeen |
      // what you see; left-pad with three zeros
      fileModeAsSeen =
        ("000" + fileModeLitStr.replaceAll("_", "").regexpCapture("(0o|0x|0b)?(.+)", 2))
            .regexpCapture("0*(.{3,})", 1) and
      // what you get
      fileModeAsOctal = octalFileMode(fileModeInt) and
      // what you see != what you get
      fileModeAsSeen != fileModeAsOctal and
      message = "will evaluate to 0o" + fileModeAsOctal
    )
  )
// TODO: skip numbers used in arithmetic operations and bitshifts
select fileModeLit, "Found invalid permissions: " + fileModeLit + " " + message
