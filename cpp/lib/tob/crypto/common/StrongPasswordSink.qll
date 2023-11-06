import cpp

/**
 * A type modelling data flow sinks for strong passwords (e.g. KDFs).
 */
class StrongPasswordSink extends Expr {
  // Returns a description of this sink which can be used as part of a query
  // result.
  abstract string getDescription();
}
