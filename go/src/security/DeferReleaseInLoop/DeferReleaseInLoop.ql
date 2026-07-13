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
import semmle.go.dataflow.ExternalFlow

/**
 * Holds if `inner` is a (transitive) child of `outer` without crossing
 * a function literal boundary.
 */
predicate parentWithoutFuncLit(AstNode inner, AstNode outer) {
  inner.getParent() = outer and not inner instanceof FuncLit
  or
  exists(AstNode mid |
    parentWithoutFuncLit(inner, mid) and
    parentWithoutFuncLit(mid, outer)
  )
}

/** Holds if `node` is inside the body of `loop`, not crossing closures. */
predicate inLoopBody(AstNode node, LoopStmt loop) {
  parentWithoutFuncLit(node, loop.(ForStmt).getBody())
  or
  parentWithoutFuncLit(node, loop.(RangeStmt).getBody())
}

/**
 * Gets the root identifier of an identifier or (possibly nested) selector
 * expression: `f` for `f`, `resp` for `resp.Body`, `a` for `a.b.c`.
 */
Ident selectorRoot(Expr e) {
  result = e
  or
  result = selectorRoot(e.(SelectorExpr).getBase())
}

/**
 * Gets the data-flow node for the root variable of a `defer x.Close()`
 * receiver chain. For `defer f.Close()`, this is `f`; for
 * `defer resp.Body.Close()`, this is `resp`; for `defer a.b.c.Close()`,
 * this is `a`.
 */
DataFlow::Node deferCloseReceiverBase(DeferStmt d) {
  d.getCall().getTarget().getName() = "Close" and
  result.asExpr() = selectorRoot(d.getCall().getCalleeExpr().(SelectorExpr).getBase())
}

from DeferStmt deferStmt, DataFlow::CallNode acquisition, DataFlow::Node acquired, LoopStmt loop
where
  // Match any return value modeled as a resource acquisition, not just the
  // first — e.g. `os.Pipe` returns both a read and a write `*os.File`.
  acquired = acquisition.getResult(_) and
  sourceNode(acquired, "tob-resource-acq") and
  inLoopBody(acquisition.asExpr(), loop) and
  inLoopBody(deferStmt, loop) and
  DataFlow::localFlow(acquired, deferCloseReceiverBase(deferStmt))
select deferStmt,
  "Deferred Close() of resource acquired from $@ in a loop will not execute until the function returns, leaking resources across iterations.",
  acquisition, acquisition.getTarget().getName() + "()"
