local M = Util.create_class()
local MathX = require ("base.mathx")
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)

function M:_init(entity) 
    self.v_gameobj = entity.gameobj
    self.entity = entity
    self.transform = self.v_gameobj.transform
    self.speed = entity.cfg.speed

    self.vx = 0
    self.vz = 1

    -- 归一化后的xz
    self.normal_x = 0
    self.normal_z = 1
    self:set_normalized_dir(self.normal_x, self.normal_z)
end

local KEYMAP = {
    [KeyCode.E] = function(self)
        self.entity:delete_self()
    end,
}

function M:get_input()
    -- 获取输入，也可以改成UI的
    for k, func in pairs(KEYMAP) do
        if Input.GetKey(k) then
            func(self)
        end
    end

    -- update_dir
    self.vx = Input.GetAxis("Horizontal");
    self.vz = Input.GetAxis("Vertical");

    self.normal_x, self.normal_z = MathX.normalize2(self.vx, self.vz)
    if self.normal_x + self.normal_z ~= 0 then
        self:set_normalized_dir(self.normal_x, self.normal_z)
    end
end

function M:set_normalized_dir(x, z)
    local cpt_value = self.entity.cpt_value
    cpt_value.normal_x = x
    cpt_value.normal_z = z
end

function M:on_update()
    self:get_input()
end


function M:on_fixed_update()
    local pos = self.entity.pos
    pos.x = pos.x + self.vx * self.speed * 0.02
    pos.z = pos.z + self.vz * self.speed * 0.02

    self.entity:set_pos2(pos.x, pos.z)
end

return M