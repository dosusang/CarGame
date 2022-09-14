local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)
local _insert = table.insert

-- 组合结点 一定是非叶子结点
function M:_init(index)
    Base._init(self)
end

return M