private import cpp
private import trailofbits.itergator.Invalidations

class Iterator extends Variable {
  Iterator() {
    this.getUnderlyingType().getName().matches("%iterator%")
    // getType is inconsistent
    or
    this.getAnAssignedValue().(FunctionCall).getTarget().(MemberFunction).getName().regexpMatch("c?r?begin")
    or
    this.getAnAssignedValue().(FunctionCall).getTarget().(MemberFunction).getName().regexpMatch("c?r?end")
    or this.getAnAssignedValue().(FunctionCall).getTarget().hasName("find")
  }
}

// the location where a variable is being iterated over
class Iterated extends VariableAccess {
  Iterator iterator;

  Iterated() {
    iterator.getAnAssignedValue().getChild(-1) = this and
    not this.getTarget().isCompilerGenerated()
    // show the iterable assigned to __range in ranged based for loops
    or
    (
      iterator.getAnAssignedValue().getChild(-1).(VariableAccess).getTarget().isCompilerGenerated() and
      this =
        iterator.getAnAssignedValue().getChild(-1).(VariableAccess).getTarget().getAnAssignedValue()
    )
  }

  Iterator iterator() { result = iterator }
}

// function call with utility predicates
private class FunctionCallR extends FunctionCall {
  predicate containedBy(Stmt other) {
    (
      other.getASuccessor*() = this and
      other.getAChild*() = this
    )
    // for destructors
    or
    exists(Function f | f.getBlock() = other and this.getEnclosingFunction() = f)
  }

  predicate callsPotentialInvalidation() {
    this.getTarget().(PotentialInvalidation).invalidates(any(Iterated i))
  }

  predicate callsPotentialInvalidation(Iterated i) {
    this.getTarget().(PotentialInvalidation).invalidates(i)
  }
}

// a call to any function that could call a PotentialInvalidation
class InvalidatorT extends FunctionCallR {
  InvalidatorT() {
    this.callsPotentialInvalidation()
    or
    exists(InvalidatorT i | i.containedBy(this.getTarget().getBlock()))
  }

  InvalidatorT child() {
    result = this.getTarget().getBlock().getAChild+().(InvalidatorT)
    or
    exists(DestructorCall d |
      d.getEnclosingFunction() = this.getTarget() and d.(InvalidatorT) = result
    )
  }

  Iterated iterated_() {
    this.callsPotentialInvalidation(result)
    or result = this.child().iterated_()
  }

  InvalidatorT potentialInvalidation() {
    this.callsPotentialInvalidation(this.iterated_()) and result = this
    or result = this.child().potentialInvalidation()
  }
}

// calls that actually perform the invalidation
class Invalidation extends InvalidatorT {
  Invalidator invalidator;

  Invalidation() {
    this = invalidator.potentialInvalidation() and invalidator.iterated() = this.iterated_()
  }

  Invalidator invalidator() { result = invalidator }
}

// the top level invalidation calls (directly inside loop bodies)
class Invalidator extends InvalidatorT {
  Iterated iterated;

  Invalidator() {
    iterated = this.iterated_() and
    this.containedBy(iterated.iterator().getParentScope())
  }

  Iterated iterated() { result = iterated }

  Invalidation invalidation() { result = any(Invalidation i | i.invalidator() = this) }
}
