local Base = require("fsm.state.base_state")
local M = Util.extend_class(Base)

function M:_init(state_cfg, state_mgr)
    Base._init(self, state_cfg, state_mgr)
end

function M:on_enter()
    Log.Info("on enter idle state")
end

function M:on_update()
    Log.Info("on update idle state")
end

function M:on_exit()
    Log.Info("on exit idle state")
end

return M