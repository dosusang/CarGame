local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

local BaseMissileCfg = {
    name = "MissileTest",
    res_path = "Missile",
    live_time = 1
}

function M:_init(cfg, dx, dz)
    cfg = cfg or BaseMissileCfg
    Base._init(self, cfg)

    self.dz = dz
    self.dx = dx
    self.live_time = cfg.live_time or 1

    -- m/s
    self.move_speed = 20
end

function M:update_transform()
    local px, pz = self:get_pos2()
    local dt = TIME.deltaTime
    local speed = self.move_speed
    self:set_pos2(px + self.dx * dt * speed, pz + self.dz * dt * speed)
end

function M:on_update()
    Base.on_update(self)
    self.live_time = self.live_time - TIME.deltaTime
    if self.live_time < 0 then
        self:delete_self()
    end
    
    self:update_transform()
end

function M:delete_self()
    SceneMgr:destory_obj(self)
end

return M