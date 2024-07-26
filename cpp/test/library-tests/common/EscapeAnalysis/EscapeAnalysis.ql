import cpp
import trailofbits.common

from
    ControlFlowNode node,
    SemanticStackVariable var
where
    mayEscapeFunctionAt(node, var)
select
    node.getLocation(), var.getName()
