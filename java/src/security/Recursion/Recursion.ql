/**
 * @name Recursive functions
 * @id tob/java/unbounded-recursion
 * @description Detects possibly unbounded recursive calls
 * @kind path-problem
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
  Call entryCall;
  Call lastCall;

  RecursiveMethod() {
    not isTestPackage(this.getDeclaringType())
    and entryCall.getEnclosingCallable() = this
    and edges+(entryCall, lastCall) and lastCall.getCallee() = this
  }

  Call getEntryCall() { result = entryCall}

  Call getLastCall() { result = lastCall}
}

query predicate edges(Call a, Call b) {
  exists(Callable c |
    a.getCallee() = c and b.getCaller() = c
  )
}

from RecursiveMethod recursiveMethod
where
  /* for a single recursion loop we would return multiple results so we deduplicate redundant findings
     returning only the one starting from a method with "greatest" name
  */
  not exists(RecursiveMethod rm2 |
    edges+(rm2.getEntryCall(), recursiveMethod.getLastCall())
    and exists(Call x | edges(recursiveMethod.getLastCall(), x) and edges(x, rm2.getEntryCall()))
    and rm2 != recursiveMethod
    and rm2.getQualifiedName() > recursiveMethod.getQualifiedName()
  )
select recursiveMethod.getLastCall(), recursiveMethod.getEntryCall(), recursiveMethod.getLastCall(),
  "Found a recursion path from/to method $@", recursiveMethod, recursiveMethod.toString()

/**
 * TODO ideas:
 *   - limit results to methods that take any user input 
 *   - check if recursive calls are bounded (takes argument that is decremented for every call)
 *   - do not return methods that have calls to self (or unbounded recursion) that are conditional
 *   - gather and print whole call graph (list of calls from recursiveMethod to itself) 
 */