/**
 * @name Unbounded read of request body
 * @id tob/go/unbounded-io-read
 * @description Reading an HTTP request body with `io.ReadAll` or `ioutil.ReadAll` without a size limit allows a malicious client to exhaust server memory with an arbitrarily large request.
 * @kind path-problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @group security
 */

import go

/**
 * An `io.ReadAll` or `ioutil.ReadAll` call — functions that read an entire
 * reader into memory with no size bound.
 */
class UnboundedReadCall extends DataFlow::CallNode {
  UnboundedReadCall() {
    this.getTarget().hasQualifiedName("io", "ReadAll")
    or
    this.getTarget().hasQualifiedName("io/ioutil", "ReadAll")
    or
    this.getTarget().hasQualifiedName("ioutil", "ReadAll")
  }
}

/**
 * A source node: an HTTP request body that can be controlled by an attacker.
 *
 * Matches `r.Body` where `r` is an `*http.Request`.
 */
class HTTPRequestBodySource extends DataFlow::Node {
  HTTPRequestBodySource() {
    exists(Field f, SelectorExpr sel |
      f.hasQualifiedName("net/http", "Request", "Body") and
      sel.getSelector().refersTo(f) and
      this.asExpr() = sel
    )
  }
}

/**
 * A call that wraps a reader with a size limit, acting as a sanitizer.
 */
class SizeLimitingCall extends DataFlow::CallNode {
  SizeLimitingCall() {
    this.getTarget().hasQualifiedName("net/http", "MaxBytesReader")
    or
    this.getTarget().hasQualifiedName("io", "LimitReader")
  }
}

/**
 * Holds if `r.Body` is reassigned from a size-limiting call in the same function
 * that `bodyRead` is in, on the same request variable `r`.
 */
predicate bodyLimitedByReassignment(SelectorExpr bodyRead) {
  exists(SizeLimitingCall limiter, Assignment assign, SelectorExpr lhs, Variable v |
    // The assignment target is `v.Body`
    assign.getLhs() = lhs and
    lhs.getSelector().getName() = "Body" and
    lhs.getBase().(Ident).refersTo(v) and
    // The RHS is a MaxBytesReader/LimitReader call
    assign.getRhs() = limiter.asExpr() and
    // The body read is on the same variable: `v.Body`
    bodyRead.getBase().(Ident).refersTo(v) and
    // Both in the same function
    assign.getEnclosingFunction() = bodyRead.getEnclosingFunction()
  )
}

module UnboundedReadConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof HTTPRequestBodySource and
    // Exclude r.Body reads where r.Body was reassigned from a size limiter
    not bodyLimitedByReassignment(source.asExpr())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(UnboundedReadCall readAll | sink = readAll.getArgument(0))
  }

  predicate isBarrier(DataFlow::Node node) {
    // If the body passes through a size-limiting wrapper (io.LimitReader pattern), it is safe
    node = any(SizeLimitingCall c).getResult(0)
    or
    node = any(SizeLimitingCall c).getResult()
  }
}

module UnboundedReadFlow = DataFlow::Global<UnboundedReadConfig>;

import UnboundedReadFlow::PathGraph

from UnboundedReadFlow::PathNode source, UnboundedReadFlow::PathNode sink
where UnboundedReadFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Unbounded read of HTTP request $@ with no size limit allows denial of service via memory exhaustion.",
  source.getNode(), "body"
