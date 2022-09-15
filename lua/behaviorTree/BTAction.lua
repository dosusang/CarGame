local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)

local ACTION_NODE_STATE = {
    Excuting = 1,
    Completed = 2,
}

-- 行为结点 一定只能是叶子结点
function M:_init()

end

return M