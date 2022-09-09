-- 配置方式
local hero_default_cfg = {
    name = "default_moveable",
    res_path = "Tank",
    speed = 3,
    born_pos = {x = 0, y = 0, z = 0},
    gun = {
        lock_gun = false,
        keycode = KeyCode.Space,
        max = 20,
        speed = 10,
        shoot_cd = 0.01,
        live_time = 1,
        path = "Missile",
        auto_shot = false,
    }
}

local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg)
    cfg = cfg or hero_default_cfg
    Base._init(self, cfg)

    self:add_component(require("objs.components.player_ctrl"), "ctrler")
end

function M:die()
    Base.on_destory(self)
end

return M