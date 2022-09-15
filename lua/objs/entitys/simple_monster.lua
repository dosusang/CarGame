local hero_default_cfg = {
    name = "monster",
    res_path = "SimpleMonster",
    speed = 3,
    born_pos = {x = 0, y = 0, z = 0},
}

local MathX = require("base.mathx")
local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg, x, z)
    cfg = cfg or hero_default_cfg
    Base._init(self, cfg)

    self.move_speed = 1

    -- 招怪自动随机位置
    if not x and not z then
        local hero_x, hero_z = Global.hero:get_pos2()
        local rd_x, rd_z = (math.random()-0.5) * 20, (math.random()-0.5) * 20
        self:set_pos2(hero_x + rd_x, hero_z + rd_z)
    end
end

function M:delete_self()
    SceneMgr:destory_obj(self)
end

function M:on_update()
    Base.on_update(self)

    local dt = TIME.deltaTime
    local hero_x, hero_z = Global.hero:get_pos2()
    local self_x, _, self_z = self.transform:GetPosA()
    local dx, dz = MathX.normalize2(hero_x - self_x, hero_z - self_z)

    local speed = self.move_speed
    -- 碰撞检测
    self:set_pos2(self_x + dx * speed * dt, self_z + dz * speed * dt)
end

M.is_monster = true

return M