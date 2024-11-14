/**
 * @name Recursive functions
 * @id tob/java/recursion
 * @description Detects recursive calls
 * @kind problem
 * @tags security
 * @precision low
 * @problem.severity warning
 * @security-severity 3.0
 * @group security
 */

import java

predicate isTestPackage(RefType referenceType) {
  referenceType.getPackage().getName().toLowerCase().matches("%test%") or
  referenceType.getPackage().getName().toLowerCase().matches("%benchmark%") or
  referenceType.getName().toLowerCase().matches("%test%")
}

predicate isBefore(Method a, Method b) {
  a.getLocation().getStartLine() < b.getLocation().getStartLine()
}

abstract class RecursiveCall extends MethodCall {
  Method m1;
  Method m2;
  Method m3;
  Method m4;

  abstract string asString();

  string toString(Method m) {
    result = m.getName() + "(" + m.getLocation().getStartLine() + ")" + " -> "
  }
}

class RecursiveCallOrder1 extends RecursiveCall {
  RecursiveCallOrder1() {
    this.getMethod() = this.getEnclosingCallable() and
    m1 = this.getMethod()
  }

  override string asString() { result = "Recursion(1): " + toString(m1) + m1.getName() }
}

class RecursiveCallOrder2 extends RecursiveCall {
  //RecursiveCallOrder1 {
  RecursiveCallOrder2() {
    m1 = this.getMethod() and
    m2 = m1.getACallee() and
    m2.getACallee() = m1 and
    isBefore(m1, m2)
  }

  override string asString() {
    result = "Recursion(2): " + toString(m1) + toString(m2) + m1.getName()
  }
}

class RecursiveCallOrder3 extends RecursiveCall {
  RecursiveCallOrder3() {
    m1 = this.getMethod() and
    m2 = m1.getACallee() and
    m3 = m2.getACallee() and
    m3.getACallee() = m1 and
    isBefore(m1, m2) and
    isBefore(m1, m3)
  }

  override string asString() {
    result = "Recursion(3): " + toString(m1) + toString(m2) + toString(m3) + m1.getName()
  }
}

class RecursiveCallOrder4 extends RecursiveCall {
  RecursiveCallOrder4() {
    m1 = this.getMethod() and
    m2 = m1.getACallee() and
    m3 = m2.getACallee() and
    m4 = m3.getACallee() and
    m4.getACallee() = m1 and
    isBefore(m1, m2) and
    isBefore(m1, m3) and
    isBefore(m1, m4)
  }

  override string asString() {
    result =
      "Recursion(4): " + toString(m1) + toString(m2) + toString(m3) + toString(m4) + m1.getName()
  }
}

from RecursiveCall recursiveCall
where not isTestPackage(recursiveCall.getMethod().getDeclaringType())
select recursiveCall, "$@", recursiveCall, recursiveCall.asString()
