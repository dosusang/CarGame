local M = Util.create_class()
local Missile = require("objs.entitys.missile")

local MissileMaxNum = 100000
local MISSILE_INDEX = 0

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

    -- 约定武器属性以attr_为前缀
    self.attr_shout_interval = 0.2
    self.attr_dmg = 5
    self.attr_crit = 0.25

    self.last_shout_time = 0

    self.v_missile_map = {} -- 记录发射出的子弹
    self.v_shout_missile_num = 0 -- 自己计算missile_map的长度，不需要每次用#去获取长度
end

-- todo 刷新武器属性
function M:update_attr()
    
end

function M:update_shout()
    local cur_time = TIME.time
    if cur_time - self.last_shout_time >= self.attr_shout_interval then
        self.last_shout_time = cur_time
        self:shout_missile()
    end
end

function M:get_missile_idx()
    MISSILE_INDEX = (MISSILE_INDEX + 1) % MissileMaxNum
    return MISSILE_INDEX
end

function M:shout_missile()
    local missile_idx = self:get_missile_idx()
    local x, y, z = self.entity:get_pos3()
    local missile_param = {
        dx = self.dx,
        dz = self.dz,
        gun = self,
        missile_idx = missile_idx,
    }
    local missile = Missile:new(nil, missile_param)
    missile:set_pos3(x, y, z)

    self.v_missile_map[missile_idx] = missile
    self.v_shout_missile_num = self.v_shout_missile_num + 1
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

function M:on_destory_missile(missile_idx)
    self.v_missile_map[missile_idx] = nil
    self.v_shout_missile_num = self.v_shout_missile_num - 1
end

return M
