local Base = require("fsm.state.base_state")
local M = Util.extend_class(Base)

function M:_init(state_cfg, state_mgr)
    Base._init(self, state_cfg, state_mgr)
end

function M:on_enter()
    Log.Info("on enter chase state")
end

function M:on_update()
    Log.Info("on update chase state")
end

function M:on_exit()
    Log.Info("on exit chase state")
end

return M