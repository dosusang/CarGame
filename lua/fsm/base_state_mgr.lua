local M = Util.create_class()

local state_type_cfg = {
    idle = require("fsm.state.idle_state"):new(),
    chase = require("fsm.state.chase_state"):new(),
    attack = require("fsm.state.attack_state"):new(),
}

function M:_init()
    self.v_cur_state = nil

    self.v_state_map = {}

    self:_register_state()
    Log.Error("init success")
end

function M:_register_state()
    for state_type, state in pairs(state_type_cfg) do
        self.v_state_map[state_type] = state
    end 
end

function M:transition_state(state_type)
    if self.v_cur_state then
        self.v_cur_state:on_exit()
    end

    local transition_state = self.v_state_map[state_type]
    if transition_state then
        self.v_cur_state = transition_state
        self.v_cur_state:on_enter()
    else
        Log.Error("state is not exist! state name: ", state_type)
        return
    end
end

function M:on_update()
    if self.v_cur_state then
        self.v_cur_state:on_update()
    end
end

return M