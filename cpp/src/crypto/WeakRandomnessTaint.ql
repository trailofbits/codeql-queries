/**
 * @name Weak randomness taint
 * @id tob/cpp/weak-randomness-taint
 * @description Finds crypto variables initialized using weak randomness
 * @kind problem
 * @tags security crypto
 * @problem.severity error
 * @precision high
 * @group cryptography
 */

import cpp
import tob.crypto.libraries
import semmle.code.cpp.dataflow.new.DataFlow
import WeakRandomnessTaint

from DataFlow::Node source, DataFlow::Node sink
where WeakRandomnessTaint::flow(source, sink)
select sink.getLocation(),
  WeakRandomnessConfig::sourceDescription(source) + " is used to initialize " +
    WeakRandomnessConfig::sinkDescription(sink)
