local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)
local Math = require("base.mathx")

local BaseMissileCfg = {
    name = "MissileTest",
    res_path = "Missile",
    live_time = 1
}

function M:_init(cfg, param_tb)
    local dx = param_tb.dx
    local dz = param_tb.dz
    local gun = param_tb.gun
    local missile_idx = param_tb.missile_idx
    local move_speed = param_tb.move_speed
    cfg = cfg or BaseMissileCfg
    Base._init(self, cfg)

    self.dx, self.dz = Math.normalize2(dx, dz)
    self.live_time = cfg.live_time or 1

    -- m/s
    self.move_speed = move_speed and move_speed or 20
    self.gun = gun

    self.missile_idx = missile_idx
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

-- 最简单的逻辑，之后的伤害计算会在这边
function M:attack(other)

    -- 阵营区分
    if other.is_monster then
        SceneMgr:destory_obj(other)
        self:delete_self()
    end
end 

function M:delete_self()
    self.gun:on_destory_missile(self.missile_idx)
    self.gun = nil
    SceneMgr:destory_obj(self)
end

M.is_missile = true

return M