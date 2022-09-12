local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

local BaseMissileCfg = {
    name = "MissileTest",
    res_path = "Missile",
    LiveTime = 1
}


function M:_init(cfg)
    cfg = cfg or BaseMissileCfg
    Base._init(self, cfg)

    self.live_time = cfg.LiveTime or 1
end

function M:on_update()
    Base.on_update(self)
    self.live_time = self.live_time - TIME.deltaTime
    if self.live_time < 0 then
        self:delete_self()
    end
    
    local px, pz = self:get_pos2()
    self:set_pos2(px, pz+0.1)
end

function M:delete_self()
    SceneMgr:destory_obj(self)
end

return M