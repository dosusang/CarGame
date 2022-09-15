local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)

-- 前提条件 条件节点
function M:_init()
    Base._init(self)
end

function M:excute()
    return true
end

return M