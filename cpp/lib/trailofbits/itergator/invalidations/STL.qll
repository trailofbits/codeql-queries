private import trailofbits.itergator.Iterators
private import cpp

import trailofbits.itergator.Invalidations

private string typeName(Iterated i) { result = i.getTarget().getType().stripType().getName() }

class PotentialInvalidationSTL extends PotentialInvalidation {
  PotentialInvalidationSTL() { this instanceof MemberFunction }

  override Expr invalidatedChild(Invalidation invd) {
    result = super.invalidatedChild(invd)
    // swap can also invalidate the first argument
    or this.hasName("swap") and result = invd.getArgument(0)
  }

  override predicate invalidates(Iterated i) {
    i.getType().refersTo(this.getParentScope()) and
    (
      typeName(i).matches("vector<%") and this.vectorInvalidation()
      or
      typeName(i).matches("deque<%") and this.dequeInvalidation()
      or
      typeName(i).regexpMatch("unordered_(set|multiset)<.*") and this.setInvalidation()
    )
  }

  predicate vectorInvalidation() {
    this.hasName("push_back")
    or this.hasName("reserve")
    or this.hasName("insert")
    or this.hasName("emplace_back")
    or this.hasName("emplace")
    or this.hasName("erase")
    or this.hasName("pop_back")
    or this.hasName("resize")
    or this.hasName("shrink_to_fit")
    or this.hasName("clear")
    or this.hasName("swap")
  }

  predicate dequeInvalidation() {
    this.hasName("push_back")
    or this.hasName("push_front")
    or this.hasName("pop_back")
    or this.hasName("pop_front")
    or this.hasName("insert")
    or this.hasName("erase")
    or this.hasName("emplace")
    or this.hasName("emplace_front")
    or this.hasName("emplace_back")
    or this.hasName("resize")
    or this.hasName("clear")
    or this.hasName("shrink_to_fit")
    or this.hasName("swap")
  }

  predicate setInvalidation() {
    this.hasName("emplace")
    or this.hasName("emplace_hint")
    or this.hasName("insert")
    or this.hasName("clear")
  }
}
