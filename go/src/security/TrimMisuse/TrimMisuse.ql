/**
 * @name Trim functions misuse
 * @id tob/go/trim-misuse
 * @description Finds calls to `string.{Trim,TrimLeft,TrimRight}` with the 2nd argument not being a cutset but a continuous substring to be trimmed
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision low
 * @security-severity 3.0
 * @group security
 */

import go
import semmle.go.dataflow.DataFlow

/*
 * Flows from a string to TrimFamilyCall cutSet argument
 */
module Trim2ndArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StringLit
  }

  predicate isSink(DataFlow::Node sink) {
    exists(TrimFamilyCall trimCall | 
      sink.asExpr() = trimCall.getCutSetArg()
    )
  }
}
module Trim2ndArgFlow = DataFlow::Global<Trim2ndArgConfig>;

/*
 * Calls to Trim methods that we are interested in
 */
class TrimFamilyCall extends DataFlow::CallNode {
  TrimFamilyCall() {
    this.getTarget().hasQualifiedName("strings", ["TrimRight", "TrimLeft", "Trim"])
    or
    this.getTarget().hasQualifiedName("bytes", ["TrimRight", "TrimLeft", "Trim"])
  }

  Expr getCutSetArg() {
    result = this.getArgument(1).asExpr()
  }

}

from TrimFamilyCall trimCall, StringLit cutset
where
  // get 2nd argument value, if possible
  exists(DataFlow::Node source, DataFlow::Node sink |
    Trim2ndArgFlow::flow(source, sink)
    and source.asExpr() = cutset
    and sink.asExpr() = trimCall.getCutSetArg()
  )
  
  and (
    // repeated characters imply the bug
    cutset.getValue().length() != unique(string c | c = cutset.getValue().charAt(_) | c).length()

    or
    (
    // long strings are considered suspicious
    cutset.getValue().length() > 2

    // at least one alphanumeric
    and exists(cutset.getValue().regexpFind("[a-zA-Z0-9]{2}", _, _))

    // exclude probable false-positives
    and not cutset.getValue().matches("%1234567%")
    and not cutset.getValue().matches("%abcdefghijklmnopqrstuvwxyz%")
    )
  )
  
select trimCall, trimCall.getTarget().getName() + " will consider the second argument ($@) as a list of elements, and not as indivisible string.", cutset, cutset.getValue()
