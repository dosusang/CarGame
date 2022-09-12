local Base = require("objs.entitys.base_obj")
local Vec3 = require("base.vec3")
local M = Util.extend_class(Base)

local cam_default_cfg = {
    name = "GameCam",
    res_path = "GameCamera",
    born_pos = {x = 0, y = 0, z = 0},
}

function M:_init(cfg)
    cfg = cfg or cam_default_cfg
    Base._init(self, cfg)

    self.lerp_to_pos = Vec3.New()
    self.cur_pos_temp = Vec3.New()
end

function M:on_fixed_update()
    Base.on_update(self)

    if Global.hero then
        local px, py, pz = Global.hero:get_pos3()

         -- 10 臂长
        local tx, ty, tz = self.transform:GetForwardA(-10)
        self.lerp_to_pos:Set(px + tx, py + ty, pz + tz)
    end

    self.cur_pos_temp:LerpC(self.lerp_to_pos, 0.02)
    self:set_pos3(self.cur_pos_temp.x, self.cur_pos_temp.y, self.cur_pos_temp.z)
end

return M