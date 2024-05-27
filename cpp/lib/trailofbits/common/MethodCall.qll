import cpp

class MethodCall extends FunctionCall {
    MemberFunction method;
    MethodCall() {
        this = method.getACallToThisFunction()
    }

    /**
     * The called method.
     */
    MemberFunction getMethod() {
        result = method
    }

    /**
     * The instance of the class the method was called on.
     */
    Expr getThis() {
        result = this.getAChild() and result != this.getAnArgument()
    }

    /**
     * The class that this method is defined on.
     */
    Type getClass() {
        result = this.getThis().getType().stripType()
    }
}
