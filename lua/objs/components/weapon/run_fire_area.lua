local Base = require("objs.components.weapon.base_gun")
local M = Util.extend_class(Base)
local Missile = require("objs.entitys.missile")
local _abs = math.abs
local _min = math.min
local _floor = math.floor
local _sqrt = math.sqrt

function M:_init(entity)
    Base._init(self, entity)
    self.attr_shout_interval = 0.5
    self.run_distance_interval = 0.5
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
            self.last_shout_time = cur_time
            self:shout_missile()
            self.cache_entity_pos_x = x
            self.cache_entity_pos_z = z
        end
    end

    local is_touch_point = false
    for idx, missile in pairs(self.v_missile_map) do
        local mx, mz = missile:get_pos2()
        if _abs(x - mx) < 0.5 and _abs(z - mz) < 0.5 and idx ~= self.v_shout_missile_num then
            if self.v_shout_missile_num > 5 and not self.v_is_create_fire_area then
                touch_idx = idx
                is_touch_point = true
            end
            break
        end
    end
    if is_touch_point then
        self:create_fire_area(touch_idx)
    end
end

function M:create_fire_area(touch_idx)
    local sum_x = 0
    local sum_z = 0
    local num = 0
    for idx, missile in pairs(self.v_missile_map) do
        if idx >= touch_idx then
            local x, z = missile:get_pos2()
            sum_x = sum_x + x
            sum_z = sum_z + z
            num = num + 1
        end
    end

    sum_x = sum_x / num
    sum_z = sum_z / num

    local _, entity_y, _ = self.entity:get_pos3()
    self:create_fire_missile(sum_x, entity_y, sum_z)

    for idx, missile in pairs(self.v_missile_map) do
        if idx >= touch_idx then
            local m_x, m_z = missile:get_pos2()
            local dis_x = _abs(sum_x - m_x)
            local dis_z = _abs(sum_z - m_z)
            local is_add_interval_x = true
            if (sum_x - m_x) > 0 then
                is_add_interval_x = false
            end
            local is_add_interval_z = true
            if (sum_z - m_z) > 0 then
                is_add_interval_z = false
            end
            local result_val = (dis_x * dis_x + dis_z * dis_z)
            local inter_val_num = _floor(math.sqrt(result_val))
            local missile_interval_x = dis_x / inter_val_num
            if not is_add_interval_x then
                missile_interval_x = -missile_interval_x
            end
            local missile_interval_z = dis_z / inter_val_num
            if not is_add_interval_z then
                missile_interval_z = -missile_interval_z
            end
            while (inter_val_num > 0) do
                local now_x = sum_x + inter_val_num * missile_interval_x
                local now_z = sum_z + inter_val_num * missile_interval_z
                inter_val_num = inter_val_num - 1
                self:create_fire_missile(now_x, entity_y, now_z)
            end
        end
    end
    self.v_is_create_fire_area = true
end

function M:shout_missile()
    local missile_idx = self:get_missile_idx()
    local x, y, z = self.entity:get_pos3()
    local missile_param = {
        dx = self.dx,
        dz = self.dz,
        gun = self,
        missile_idx = missile_idx,
        move_speed = 0
    }
    local missile = Missile:new(nil, missile_param)
    missile:set_pos3(x, y, z)

    self.v_missile_map[missile_idx] = missile
    self.v_shout_missile_num = self.v_shout_missile_num + 1
end

function M:create_fire_missile(now_x, entity_y, now_z)
    local missile_idx = self:get_missile_idx()
    local x, y, z = self.entity:get_pos3()
    local missile_param = {
        dx = self.dx,
        dz = self.dz,
        gun = self,
        missile_idx = missile_idx,
        move_speed = 0
    }
    local missile = Missile:new(nil, missile_param)
    missile:set_pos3(now_x, entity_y, now_z)
end

return M
