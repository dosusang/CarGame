local Base = require("behaviorTree.BTNode")
local M = Util.extend_class(Base)

-- 测试叶子结点
function M:_init()
    Base._init(self)
end

function M:excute()
    Log.Error("跑步")
    return true
end

return M