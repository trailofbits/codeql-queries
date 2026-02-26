private import cpp
private import trailofbits.itergator.Iterators

abstract class PotentialInvalidation extends Function {
  cached abstract predicate invalidates(Iterated i);

  Expr invalidatedChild(Invalidation invd) {
    // by default, invalidates object method is called on
    result = invd.getQualifier()
  }
}
