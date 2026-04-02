/**
 * @name Deferred resource release in loop
 * @id tob/go/defer-release-in-loop
 * @description Deferring a resource release (Close, Rollback, etc.) inside a loop delays cleanup until the enclosing function returns, causing resource leaks across iterations such as file descriptor exhaustion or connection pool starvation.
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision medium
 * @security-severity 3.0
 * @group security
 */

import go
import ResourceModel

/**
 * Holds if `inner` is a (transitive) child of `outer` without crossing
 * a function literal boundary. This ensures we don't catch defers inside
 * closures that are invoked per-iteration.
 */
predicate parentWithoutFuncLit(AstNode inner, AstNode outer) {
  inner.getParent() = outer and not inner instanceof FuncLit
  or
  exists(AstNode mid |
    parentWithoutFuncLit(inner, mid) and
    parentWithoutFuncLit(mid, outer)
  )
}

/**
 * A `defer` statement that defers a resource close/release call.
 */
class DeferredResourceClose extends DeferStmt {
  ResourceCloseMethod closeMethod;

  DeferredResourceClose() { closeMethod = this.getCall().getTarget() }

  string getMethodName() { result = closeMethod.getName() }
}

from DeferredResourceClose deferStmt, LoopStmt loop
where
  parentWithoutFuncLit(deferStmt, loop.(ForStmt).getBody())
  or
  parentWithoutFuncLit(deferStmt, loop.(RangeStmt).getBody())
select deferStmt,
  "Deferred " + deferStmt.getMethodName() +
    "() in a loop will not execute until the function returns, leaking resources across iterations."
