/**
 * This library contains a best-effort escape analysis which is used to
 * determine if an allocated value may escape the current function. To avoid
 * performance issues we try to determine if the value escapes based on the
 * given control flow node alone. 
 * 
 * To avoid false positives in the memory leak query (`LocalMemoryLeak.ql`), we
 * over-estimate the number of values that escape the function.
 */
import cpp
import MethodCall

/**
 * True if the operation at `node` may cause the value of `var` to escape the
 * enclosing function.
 */
predicate mayEscapeFunctionAt(ControlFlowNode node, SemanticStackVariable var) {
  exists (EscapeAnalysis ea | ea.mayEscapeAt(node, var))
}

abstract class EscapeAnalysis extends string {
  bindingset[this]
  EscapeAnalysis() { any() }

  /**
   * True if the operation at `node` may cause the value of `var` to escape the
   * function.
   */
  abstract predicate mayEscapeAt(ControlFlowNode node, SemanticStackVariable var);
}

/**
 * Captures values that are returned by the current function.
 */
class ReturnValueAnalysis extends EscapeAnalysis {
  ReturnValueAnalysis() {
    this = "ReturnValueAnalysis"
  }

  override predicate mayEscapeAt(ControlFlowNode node, SemanticStackVariable var) {
    // `node` is a return statement returning the variable `var`, or
    // an expression containing the variable `var`. (This may lead to)
    // false positives, but is intended to catch instances where `var`
    // is returned through a struct, or through a function call.
    node.(ReturnStmt).getExpr().getAChild*() = var.getAnAccess()
  }
}

/**
 * Captures values that escape through an assignment to a pointer parameter.
 * (We do not currently handle reassignments.)
 */
class PointerParameterAnalysis extends EscapeAnalysis {
  PointerParameterAnalysis() {
    this = "PointerParameterAnalysis"
  }

  /**
   * Returns a pointer parameter of the given function.
   */
  private Parameter getAPointerParameter(Function f) {
    result = f.getAParameter() and result.getType() instanceof PointerType
  }

  /**
   * Returns an access to a pointer parameter in the given function.
   */
  private VariableAccess getAPointerParameterAccess(Function f) {
    result = getAPointerParameter(f).getAnAccess()
  }

  override predicate mayEscapeAt(ControlFlowNode node, SemanticStackVariable var) {
    // `node` is an assignment of `var` to an lvalue containing a pointer
    // parameter as a sub-expression. This is meant to cover the case when 
    // `var` is assigned to either
    //
    //   1. The (dereferenced) parameter directly
    //   2. A parameter field access (in the case of a struct or class parameter)
    //   3. An indexing operation on the parameter (in the case of an array or vector)
    node.(AssignExpr).getRValue() = var.getAnAccess() and
    // Using + rather than * here excludes the following case where the local
    // variable `ptr` is simply reassigned.
    //
    // ```c
    //   void f(int *ptr) {
    //     int *x = malloc(sizeof(int));
    //     ptr = x;
    //   }
    // ```
    node.(AssignExpr).getLValue().getAChild+() = getAPointerParameterAccess(var.getFunction())
  }
}

/**
 * Captures values that escape through an assignment to a reference parameter.
 * (We do not currently handle reassignments.)
 */
class ReferenceParameterAnalysis extends EscapeAnalysis {
  ReferenceParameterAnalysis() {
    this = "ReferenceParameterAnalysis"
  }

  /**
   * Returns a reference parameter of the given function.
   */
  private Parameter getAReferenceParameter(Function f) {
    result = f.getAParameter() and result.getType() instanceof ReferenceType
  }

  /**
   * Returns an access to a reference parameter in the given function.
   */
  private VariableAccess getAReferenceParameterAccess(Function f) {
    result = getAReferenceParameter(f).getAnAccess()
  }

  override predicate mayEscapeAt(ControlFlowNode node, SemanticStackVariable var) {
    // `node` is an assignment of `var` to an lvalue containing a reference
    // parameter as a sub-expression. This is meant to cover the case when 
    // `var` is assigned to either
    //
    //   1. The parameter directly
    //   2. A parameter field access (in the case of a struct or class parameter)
    //   3. An indexing operation on the parameter (in the case of an array or vector)
    node.(AssignExpr).getRValue() = var.getAnAccess() and
    node.(AssignExpr).getLValue().getAChild*() = getAReferenceParameterAccess(var.getFunction())
  }
}

class VectorParameterEscapeAnalysis extends EscapeAnalysis {
  VectorParameterEscapeAnalysis() {
    this = "VectorParameterEscapeAnalysis"
  }

  /**
   * True if the given call is a call to `vector<T>::push_back` for some `T`.
   */
  private predicate isVectorPushBack(MethodCall call, Expr vec, Expr elem) {
    call.getClass().getName().matches("vector<%>") and
    call.getTarget().getName() = "push_back" and
    call.getThis() = vec and
    call.getArgument(0) = elem
  }

  override predicate mayEscapeAt(ControlFlowNode node, SemanticStackVariable var) {
    exists (Expr expr, Parameter param |
      // This is an imprecise way of catching both expressions like
      // `v.push_back(x)` where `v` is a parameter, and expressions
      // like `foo->v.push_back(x)` where `foo` is a parameter.
      expr.getAChild*() = param.getAnAccess() and  
      isVectorPushBack(node, expr, var.getAnAccess())
    )
  }
}