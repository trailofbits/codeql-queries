/**
 * @name Recursive functions
 * @id tob/java/unbounded-recursion
 * @description Detects possibly unbounded recursive calls
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

class RecursiveMethod extends Method {
  RecursiveMethod() {
    exists(Method m | this.calls+(m) and this = m)
  }
}

/**
 * TODO ideas:
 *   - limit results to methods that take any user input 
 *   - check if recursive calls are bounded (takes argument that is decremented for every call)
 *   - do not return methods that have calls to self (or unbounded recursion) that are conditional
 *   - gather and print whole call graph (list of calls from recursiveMethod to itself) 
 */
from RecursiveMethod recursiveMethod
where
  not isTestPackage(recursiveMethod.getDeclaringType())
select recursiveMethod, "Method $@ has unbounded, possibly infinite recursive calls", recursiveMethod, recursiveMethod.toString()
