-- 配置方式
local hero_default_cfg = {
    name = "default_moveable",
    res_path = "Tank",
    speed = 3,
    born_pos = {x = 0, y = 0, z = 0},
}

local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg)
    cfg = cfg or hero_default_cfg
    Base._init(self, cfg)

    self:add_component(require("objs.components.player_ctrl"), "ctrler")
    self:add_component(require("objs.components.weapon.base_gun"), "gun")
end

function M:delete_self()
    SceneMgr:destory_obj(self)
end

return M