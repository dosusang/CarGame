local Base = require("objs.components.weapon.base_gun")
local M = Util.extend_class(Base)
local Missile = require("objs.entitys.missile")
local _abs = math.abs

-- 所有的gun都是自动射击
-- 一定具有以下几个属性 
-- 射击速度: 多少发每秒；  
-- 攻击力：xx点； 
-- 暴击率 xx
-- 击退力度 

-- todo 武器技能？

function M:_init(entity)
    Base._init(self, entity)
    self.attr_shout_interval = 0.2
    self.run_distance_interval = 1
    local x, y, z = self.entity:get_pos3()
    self.cache_entity_pos_x = x
    self.cache_entity_pos_z = z
end
 
-- todo 刷新武器属性
function M:update_attr()
    
end

function M:update_shout()
    local cur_time = TIME.time
    local x, y, z = self.entity:get_pos3()
    if cur_time - self.last_shout_time >= self.attr_shout_interval then
        if _abs(x - self.cache_entity_pos_x) > self.run_distance_interval or _abs(z - self.cache_entity_pos_z) > self.run_distance_interval then
            self:shout_missile()
            self.cache_entity_pos_x = x
            self.cache_entity_pos_z = z
        end
    end
end

return M
