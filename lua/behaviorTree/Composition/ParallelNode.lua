local Base = require("behaviorTree.BTComposition")
local M = Util.extend_class(Base)

-- 并行器 条件节点
function M:_init()
    Base._init(self)
end

function M:excute()
    Base.excute(self)
    for _, child_node in pairs(self.v_child_node_list) do
        child_node:excute()
    end
    return true
end

return M