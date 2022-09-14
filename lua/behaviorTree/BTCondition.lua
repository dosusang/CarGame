local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)

-- 条件结点 一定只能是叶子结点
function M:_init()
    Base._init(self)
end

return M