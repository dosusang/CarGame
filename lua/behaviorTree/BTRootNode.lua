local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)

-- 前提条件 条件节点
function M:_init(child_node)
    Base._init(self)
    self.v_child_node = child_node
end

function M:excute()
    return self.v_child_node:excute()
end

return M