/**
 * @name Static password flow
 * @id tob/cpp/static-password-flow
 * @description Finds crypto variables initialized using static passwords
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
  StrongPasswordSink random
where
  StaticPasswordFlow::flow(source, sink) and
  random = sink.asExpr()
select sink.getLocation(),
  random.getDescription() + " is initialized using static data from " + source.toString()
