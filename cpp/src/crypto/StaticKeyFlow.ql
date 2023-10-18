/**
 * @name Static key flow
 * @id tob/cpp/static-key-flow
 * @description Finds crypto variables initialized using static keys
 * @kind problem
 * @tags security crypto
 * @problem.severity error
 * @precision high
 * @group cryptography
 */

import cpp
import crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow

from
  DataFlow::Node source, DataFlow::Node sink,
  StrongRandomnessSink random
where
  StaticKeyFlow::flow(source, sink) and
  random = sink.asExpr()
select sink.getLocation(),
  random.getDescription() + " is initialized using static data from " + source.toString()
