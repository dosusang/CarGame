local M = Util.create_class()
local Missile = require("objs.entitys.missile")

-- 所有的gun都是自动射击
-- 一定具有以下几个属性 
-- 射击速度: 多少发每秒；  
-- 攻击力：xx点； 
-- 暴击率 xx
-- 击退力度 

-- todo 武器技能？

function M:_init(entity)
    self.v_gameobj = entity.gameobj
    self.entity = entity
    self.transform = self.v_gameobj.transform
    self.dx = 0
    self.dz = 0

    self.attr_shout_interval = 0.2
    self.attr_dmg = 5
    self.attr_crit = 0.25

    self.last_shout_time = 0
end

-- todo 刷新武器属性
function M:update_attr()
    
end

function M:update_shout()
    local cur_time = TIME.time
    if cur_time - self.last_shout_time >= self.attr_shout_interval then
        self.last_shout_time = cur_time

        local x, y, z = self.entity:get_pos3()
        local missile = Missile:new(nil, self.dx, self.dz)
        missile:set_pos3(x, y, z)
    end
end

function M:update_dir()
    local cpt_value = self.entity.cpt_value
    self.dx = cpt_value.normal_x
    self.dz = cpt_value.normal_z
end

function M:on_update()
    self:update_shout()
    self:update_dir()
end

return M
