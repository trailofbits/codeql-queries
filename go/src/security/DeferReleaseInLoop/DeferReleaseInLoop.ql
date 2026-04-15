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

/**
 * A function that acquires a resource that could leak
 */
class ResourceAcquisition extends Function {
  ResourceAcquisition() {
    this.hasQualifiedName("os", ["Open", "OpenFile", "Create", "CreateTemp", "NewFile", "Pipe"])
    or
    this.hasQualifiedName("net", ["Dial", "DialTimeout", "Listen", "ListenPacket"])
    or
    this.hasQualifiedName("net", ["FileConn", "FileListener", "FilePacketConn"])
    or
    this.(Method).hasQualifiedName("net", "Dialer", ["Dial", "DialContext"])
    or
    this.hasQualifiedName("net/http", ["Get", "Post", "PostForm", "Head"])
    or
    this.(Method).hasQualifiedName("net/http", "Client", ["Do", "Get", "Post", "PostForm", "Head"])
    or
    this.hasQualifiedName("crypto/tls", ["Dial", "DialWithDialer", "Client", "Server"])
    or
    this.(Method).hasQualifiedName("crypto/tls", "Dialer", "DialContext")
    or
    this.hasQualifiedName("compress/gzip", ["NewReader", "NewWriter", "NewWriterLevel"])
    or
    this.hasQualifiedName("compress/zlib",
      ["NewReader", "NewWriter", "NewWriterLevel", "NewWriterLevelDict"])
    or
    this.hasQualifiedName("compress/flate", ["NewReader", "NewWriter"])
    or
    this.hasQualifiedName("compress/lzw", ["NewReader", "NewWriter"])
    or
    this.hasQualifiedName("archive/zip", "OpenReader")
  }
}

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
 * Gets the innermost identifier used as the receiver in `defer x.Close()`.
 * For `defer f.Close()`, this is `f`.
 * For `defer resp.Body.Close()`, this is `resp`.
 */
DataFlow::Node deferCloseReceiverBase(DeferStmt d) {
  d.getCall().getTarget().getName() = "Close" and
  exists(Expr base | base = d.getCall().getCalleeExpr().(SelectorExpr).getBase() |
    // defer f.Close() — base is an identifier
    result.asExpr() = base.(Ident)
    or
    // defer resp.Body.Close() — base is a selector, take its base identifier
    result.asExpr() = base.(SelectorExpr).getBase().(Ident)
  )
}

from DeferStmt deferStmt, DataFlow::CallNode acquisition, LoopStmt loop
where
  acquisition.getTarget() instanceof ResourceAcquisition and
  inLoopBody(acquisition.asExpr(), loop) and
  inLoopBody(deferStmt, loop) and
  DataFlow::localFlow(acquisition.getResult(0), deferCloseReceiverBase(deferStmt))
select deferStmt,
  "Deferred Close() of resource acquired from $@ in a loop will not execute until the function returns, leaking resources across iterations.",
  acquisition, acquisition.getTarget().getName() + "()"
