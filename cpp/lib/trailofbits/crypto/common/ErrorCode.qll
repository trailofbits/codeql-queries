import cpp

/**
 * A type modelling functions that return an error or status code that should be acted on.
 */
abstract class ReturnsErrorCode extends Function { }


/**
 * A type modelling the return value from a function that returns an error or status code.
 */
class ErrorCode extends FunctionCall {
  ErrorCode() { this.getTarget() instanceof ReturnsErrorCode }
}
