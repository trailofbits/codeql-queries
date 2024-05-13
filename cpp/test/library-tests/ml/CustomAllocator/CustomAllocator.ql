import cpp
import trailofbits.ml.common
import trailofbits.ml.libraries

from 
    CustomAllocator allocator,
    StackVariable var,
    ControlFlowNode node,
    string message,
    int line
where 
    (
        allocator.isAllocatedBy(node, var) and
        message = "`" + var + "` is allocated here" and
        line = node.getLocation().getStartLine()
    ) or 
    (
        allocator.isFreedBy(node, var) and
        message = "`" + var + "` is freed here" and
        line = node.getLocation().getStartLine()
    )
select
    line, message