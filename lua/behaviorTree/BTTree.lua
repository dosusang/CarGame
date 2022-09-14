local M = Util.create_class()
local BTRootNode = require("behaviorTree.BTRootNode")
local SelectorNode = require("behaviorTree.Composition.SelectorNode")
local IdleNode = require("behaviorTree.Action.TestIdleActionNode")
local MoveNode = require("behaviorTree.Action.TestMoveActionNode")
local RunNode = require("behaviorTree.Action.TestRunActionNode")

function M:_init()
    local child_node = SelectorNode:new()
    local root_node = BTRootNode:new(child_node)
    local idle_node = IdleNode:new()
    local move_node = MoveNode:new()
    local run_node = MoveNode:new()
    root_node.v_child_node:add_child_node(idle_node)
    root_node.v_child_node:add_child_node(move_node)
    root_node.v_child_node:add_child_node(run_node)
    root_node:excute()
end

return M