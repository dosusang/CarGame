local M = Util.create_class()
local _insert = table.insert

local RUNNING_RESULT = {
    Success = 1,
    Failure = 2,
    Running = 3,
}

-- 所有节点的基类
function M:_init()
    self.v_child_node_list = {}
end

-- 执行函数 需要重写 返回 bool
function M:excute()

end

function M:add_child_node(child_node)
    _insert(self.v_child_node_list, child_node)
end

return M