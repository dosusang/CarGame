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
    self.v_missile_pos_list = {}
    self.v_missile_to_idx = {}

    self.v_head_idx = 1
    self.v_tail_idx = 1
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
            local missile = Missile:new(nil, 0, 0, self)
            missile:set_pos3(x, y, z)
            self.cache_entity_pos_x = x
            self.cache_entity_pos_z = z
            self.v_missile_pos_list[self.v_tail_idx] = missile
            self.v_missile_to_idx[missile] = self.v_tail_idx
            self.v_tail_idx = self.v_tail_idx + 1
        end
    end

    local is_touch_point = false
    for idx, missile in pairs(self.v_missile_pos_list) do
        local px, pz = missile:get_pos2()
        if _abs(x - px) < 0.5 and _abs(z - pz) < 0.5 then
            if self.v_tail_idx - idx > 5 and not self.v_test then
                touch_idx = idx
                is_touch_point = true
            end
            break
        end
    end
    if is_touch_point then
        self.v_test = true
        self:cal_middile_point(touch_idx)
    end
end

function M:on_destory_missile(missile)
    local idx = self.v_missile_to_idx[missile]
    self.v_missile_pos_list[idx] = nil
    self.v_missile_to_idx[missile] = nil
    self.v_head_idx = self.v_head_idx + 1
end

function M:cal_middile_point(touch_idx)
    local sum_x = 0
    local sum_z = 0
    local num = self.v_tail_idx - touch_idx
    for i = touch_idx, self.v_tail_idx - 1 do
        local missile = self.v_missile_pos_list[i]
        local x, z = missile:get_pos2()
        sum_x = sum_x + x
        sum_z = sum_z + z
    end

    sum_x = sum_x / num
    sum_z = sum_z / num

    local _, entity_y, _ = self.entity:get_pos3()
    for i = touch_idx, self.v_tail_idx - 1 do
        local missile = self.v_missile_pos_list[i]
        local front_x, front_z = missile:get_pos2()
        local dis_x = _abs(sum_x - front_x)
        local dis_z = _abs(sum_z - front_z)
        local x_zheng_sign = true
        if (sum_x - front_x) > 0 then
            x_zheng_sign = false
        end
        local z_zheng_sign = true
        if (sum_z - front_z) > 0 then
            z_zheng_sign = false
        end
        local result_val = (dis_x * dis_x + dis_z * dis_z)
        local inter_val_num = _floor(math.sqrt(result_val))
        local missile_interval_x = dis_x / inter_val_num
        if not x_zheng_sign then
            missile_interval_x = -missile_interval_x
        end
        local missile_interval_z = dis_z / inter_val_num
        if not z_zheng_sign then
            missile_interval_z = -missile_interval_z
        end
        while (inter_val_num > 0) do
            local now_x = sum_x + inter_val_num * missile_interval_x
            local now_z = sum_z + inter_val_num * missile_interval_z
            inter_val_num = inter_val_num - 1
            local missile = Missile:new(nil, 0, 0, self)
            missile:set_pos3(now_x, entity_y, now_z)
        end
    end
end

function M:create_area(touch_idx)
    local x, y, z = self.entity:get_pos3()
    local i = self.v_tail_idx - 1
    local j = touch_idx
    while (i > j) do
        local last_missile = self.v_missile_pos_list[i]
        local last_x, last_z = last_missile:get_pos2()
        local front_missile = self.v_missile_pos_list[j]
        local front_x, front_z = front_missile:get_pos2()
        local interval_x = _abs(last_x - front_x)
        local interval_z = _abs(last_z - front_z)
        local start_x = _min(last_x, front_x)
        local start_z = _min(last_z, front_z)
        local result_val = (interval_x * interval_x + interval_z * interval_z)
        local inter_val_num = _floor(math.sqrt(result_val))
        local missile_interval_x = interval_x / inter_val_num
        local missile_interval_z = interval_z / inter_val_num
        while (inter_val_num > 0) do
            local now_x = start_x + inter_val_num * missile_interval_x
            local now_z = start_z + inter_val_num * missile_interval_z
            inter_val_num = inter_val_num - 1
            local missile = Missile:new(nil, 0, 0, self)
            missile:set_pos3(now_x, y, now_z)
        end
        i = i - 1
        j = j + 1
    end
end

return M
