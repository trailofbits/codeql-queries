/**
 * @name Missing engine initialization
 * @id tob/cpp/missing-engine-init
 * @description Finds created OpenSSL engines that may not be properly initialized
 * @kind problem
 * @tags correctness crypto
 * @problem.severity warning
 * @precision medium
 * @group cryptography
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

// REFERENCE: https://www.openssl.org/docs/man1.1.1/man3/ENGINE_init.html
//
// ENGINE_new, ENGINE_by_id, etc, all create a new engine object.
class CreateEngine extends FunctionCall {
  CreateEngine() {
    getTarget().getName() in ["ENGINE_new", "ENGINE_by_id", "ENGINE_get_next", "ENGINE_get_prev"]
  }
}

// ENGINE_init is called to initialize the engine.
class ENGINE_Init extends FunctionCall {
  ENGINE_Init() { getTarget().getName() = "ENGINE_init" }

  Expr getEngine() { result = this.getArgument(0) }
}

// ENGINE_set_default should usually be called to enable the provided algorithms as defaults.
class ENGINE_set_default extends FunctionCall {
  ENGINE_set_default() { getTarget().getName() = "ENGINE_set_default" }

  Expr getEngine() { result = this.getArgument(0) }
}

predicate flowsToEngineInit(CreateEngine create) {
  exists(ENGINE_Init init |
    DataFlow::localFlow(DataFlow::exprNode(create), DataFlow::exprNode(init.getEngine()))
  )
}

predicate flowsToEngineSet(CreateEngine create) {
  exists(ENGINE_set_default set |
    DataFlow::localFlow(DataFlow::exprNode(create), DataFlow::exprNode(set.getEngine()))
  )
}

from CreateEngine createCall
where not flowsToEngineInit(createCall) or not flowsToEngineSet(createCall)
select createCall.getLocation(), "Engine may not be properly initialized"
