/**
 * @name Potentially unguarded protocol handler invocation
 * @id tob/java/unguarded-protocol-handler
 * @description Detects calls to URL protocol handlers with untrusted input that may not be properly validated for dangerous protocols
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-939
 * @precision medium
 * @problem.severity warning
 * @security-severity 6.5
 * @group security
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards

/**
 * A call to Desktop.browse() method for handling
 * TODO(alan): also support legacy/generic cases like invoking "rundll32 url.dll,FileProtocolHandler"
 */
class DesktopBrowseCall extends MethodCall {
  DesktopBrowseCall() {
    this.getMethod().hasName("browse") and
    this.getMethod().getDeclaringType().hasQualifiedName("java.awt", "Desktop")
  }

  Expr getUrlArgument() { result = this.getArgument(0) }

  string getDescription() { result = "Desktop.browse()" }
}

/**
 * A guard that checks the URL scheme/protocol signifying sanitization before launch
 */
predicate isUrlSchemeCheck(Guard g, Expr e, boolean branch) {
  exists(MethodCall mc |
    mc = g and
    e = mc.getQualifier*() and
    branch = true and
    (
      // getScheme() or getProtocol() check
      mc.getMethod().hasName(["equals", "equalsIgnoreCase", "startsWith", "matches"]) and
      exists(MethodCall getScheme |
        getScheme.getParent*() = mc and
        getScheme.getMethod().hasName(["getScheme", "getProtocol"])
      )
      or
      // URL string contains check like: url.contains("http://") or url.startsWith("https://")
      mc.getMethod().hasName(["contains", "startsWith", "matches", "indexOf"]) and
      exists(StringLiteral sl | sl = mc.getAnArgument() | sl.getValue().regexpMatch(".*://.*"))
      or
      // Pattern matching on the string representation
      mc.getMethod().hasName(["matches", "find"]) and
      mc.getQualifier().getType().(RefType).hasQualifiedName("java.util.regex", "Matcher")
    )
  )
}

/**
 * Configuration for tracking untrusted data to protocol handler invocations
 */
module PotentiallyUnguardedProtocolHandlerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(DesktopBrowseCall call | sink.asExpr() = call.getUrlArgument())
  }

  predicate isBarrier(DataFlow::Node node) {
    // Consider sanitized if there's a guard checking the scheme
    node = DataFlow::BarrierGuard<isUrlSchemeCheck/3>::getABarrierNode()
  }
}

module PotentiallyUnguardedProtocolHandlerFlow =
  TaintTracking::Global<PotentiallyUnguardedProtocolHandlerConfig>;

import PotentiallyUnguardedProtocolHandlerFlow::PathGraph

from
  PotentiallyUnguardedProtocolHandlerFlow::PathNode source,
  PotentiallyUnguardedProtocolHandlerFlow::PathNode sink, DesktopBrowseCall call
where
  PotentiallyUnguardedProtocolHandlerFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = call.getUrlArgument()
select call, source, sink,
  call.getDescription() +
    " is called with untrusted input from $@ without proper URL scheme validation.",
  source.getNode(), "this source"
