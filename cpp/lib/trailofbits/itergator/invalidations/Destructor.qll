private import trailofbits.itergator.Iterators
private import cpp
import trailofbits.itergator.Invalidations

class PotentialInvalidationDestructor extends PotentialInvalidation {
  PotentialInvalidationDestructor() {
    this instanceof MemberFunction and this.getName().matches("~%")
  }

  override predicate invalidates(Iterated i) { i.getType().refersTo(this.getParentScope()) }
}
