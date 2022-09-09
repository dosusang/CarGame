local M = {}

M.Rad2Deg = math.deg(1)
M.Deg2Rad = math.rad(1)

local _atan = math.atan
local _floor = math.floor
local _sin = math.sin
local _cos = math.cos
local _acos = math.acos

UnityVector3 = CS.UnityEngine.Vector3
UnityVector2 = CS.UnityEngine.Vector2

function M.delta_angle(a1, a2)
	return (a2 - a1 + 180) % 360 - 180
end

function M.lerp_angle(a1, a2, p)
	if p > 1 then
		p = 1
	end

	return a1 + ((a2 - a1 + 180) % 360 - 180) * p
end

function M.lerp_number(num1, num2, t)
	t = math.min(t, 1)
	return num1 + (num2 - num1) * t
end

function M.inverse_lerp(min, max, value)
    return (value - min) / (max - min)
end

function M.distance(x1, y1, z1, x2, y2, z2)
	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1
	return (dx * dx + dy * dy + dz * dz) ^ 0.5
end

function M.square_distance(x1, y1, z1, x2, y2, z2)
	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1
	return dx * dx + dy * dy + dz * dz
end

function M.distance2(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1

	return (dx * dx + dy * dy) ^ 0.5
end

function M.square_distance2(x1, z1, x2, z2)
	local dx = x2 - x1
	local dz = z2 - z1
 	return dx*dx + dz*dz
end

function M.Clamp(value, min, max)
	if value < min then
		value = min
	elseif value > max then
		value = max    
	end
	
	return value
end

function M.Clamp01(value)
	if value < 0 then
		return 0
	elseif value > 1 then
		return 1   
	end
	
	return value
end

function M.Sign(num)  
	if num > 0 then
		num = 1
	elseif num < 0 then
		num = -1
	else 
		num = 0
	end

	return num
end

function M.dot(x1, y1, x2, y2, x3, y3)
    local dx1, dy1 = x1 - x2, y1 - y2
    local dx2, dy2 = x3 - x2, y3 - y2

    return dx1 * dx2 + dy1 * dy2
end

function M.normalize(x, y, z)
	local len = math.sqrt(x * x + y * y + z * z)
	if len > 1e-5 then
		return x / len, y / len, z / len
	else
		return 0, 0, 0
	end
end

function M.normalize2(x, z)
    local len = (x * x + z * z) ^ 0.5
    if len > 1e-5 then
        return x / len, z / len
    else
        return 0, 0
    end
end
--
function M.dist_vec2A(x1, z1, x2, z2)
    local dx, dz = x1 - x2, z1 - z2
    return (dx * dx + dz * dz) ^ 0.5
end

function M.dist_vec3A(x1, y1, z1, x2, y2, z2)
    local dx, dy, dz = x1 - x2, y1 - y2, z1 - z2
    return (dx * dx + dy * dy + dz * dz) ^ 0.5
end

local _deg2rad = M.Deg2Rad
function M.rotate_vec2(x, y, deg)
    local sin_rad, cos_rad = _sin(-deg * _deg2rad), _cos(-deg * _deg2rad)
    return cos_rad * x - sin_rad * y, sin_rad * x + cos_rad * y
end

-- 获取三点间夹角
local _normalize2 = M.normalize2
local _clamp = M.Clamp
function M.get_vec2_angle(basex, basey, x1, y1, x2, y2)
    local vec_x1, vec_y1 = _normalize2(x1 - basex, y1 - basey)
    local vec_x2, vec_y2 = _normalize2(x2 - basex, y2 - basey)
    local dot = vec_x1 * vec_x2 + vec_y1 * vec_y2
    return _acos(_clamp(dot, -1, 1)) * 57.29578
end

local _rad2Deg = M.Rad2Deg 
function M.get_angle2A(x, y)
    if x == 0 and y == 0 then
        return 
    end

    local l = x*x + y*y
    x = x/l
    y = y/l
    return _atan(y, x) * _rad2Deg
end
--

function M.create_vector3(x, y, z)
	return UnityVector3(x, y, z)
end

function M.create_vector2(x, y)
	return UnityVector2(x, y)
end

function M.get_lookat_dir(x1, z1, x2, z2)
	return _floor(_atan(x2 - x1, z2 - z1) * M.Rad2Deg) % 360
end

function M.CatmulRom(x1, z1, x2, z2, x3, z3, x4, z4, t)
    local ax = -0.5*x1 + 1.5*x2 -1.5*x3 +0.5*x4
    local bx = x1 - 2.5*x2 + 2*x3 - 0.5*x4
    local cx = -0.5*x1 + 0.5*x3
    local dx = x2

    local az = -0.5*z1 + 1.5*z2 -1.5*z3 +0.5*z4
    local bz = z1 - 2.5*z2 + 2*z3 - 0.5*z4
    local cz = -0.5*z1 + 0.5*z3
    local dz = z2

    local x = (((ax*t+bx)*t+cx)*t+dx)
    local z = (((az*t+bz)*t+cz)*t+dz)

    return x, z
end

function M.almost_zero2(x, y)
    local len = x * x + y * y
    return len <= 1e-5
end

function M.almost_equal(x1, z1, x2, z2)
	local dx = x2 - x1
	local dz = z2 - z1

	local len = dx * dx + dz * dz
	return len <= 0.1
end

function M.almost_equal_vec3(v1, v2)
	local dx = v1.x - v2.x
	local dy = v1.y - v2.y
	local dz = v1.z - v2.z

	local len = dx * dx + dy * dy + dz * dz
	return len <= 0.1
end

-- 一个控制点的贝兹曲线
-- 若大量调用，把t计算出值缓存起来
-- t1 = (1-t)^2 , t2 = 2(1-t)t , t3 = t^2
function M.bezier_3d_2o(x0, y0, z0, x1, y1, z1, x2, y2, z2, t)
	local one_sub_t = 1 - t
	local t1 = one_sub_t * one_sub_t
	local t2 = 2 * one_sub_t * t
	local t3 = t * t

	local x = t1 * x0 + t2 * x1 + t3 * x2
	local y = t1 * y0 + t2 * y1 + t3 * y2
	local z = t1 * z0 + t2 * z1 + t3 * z2

	return x, y, z
end

-- 两个控制点的贝兹曲线若
-- 大量调用，把t计算出值缓存起来
-- t1 = (1-t)^3 , t2 = 3(1-t)2t , t3 = 3(1-t)t2 , t4 = t^3
function M.bezier_3d_3o(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, t)
	local one_sub_t = 1 - t
	local t1 = one_sub_t * one_sub_t * one_sub_t
	local t2 = 3 * one_sub_t * one_sub_t * t
	local t3 = 3 * one_sub_t * t * t
	local t4 = t * t * t

	local x = t1 * x0 + t2 * x1 + t3 * x2 + t4 * x3
	local y = t1 * y0 + t2 * y1 + t3 * y2 + t4 * y3
	local z = t1 * z0 + t2 * z1 + t3 * z2 + t4 * z3

	return x, y, z
end

function M.item_drop_curvey(x0, y0, z0, x2, y2, z2, t)
	local x1 = x0
	local y1 = y0 + 10
	local z1 = z0
	return M.bezier_3d_2o(x0, y0, z0, x1, y1, z1, x2, y2, z2, t)
end

function M.item_fly_curvey(x0, y0, z0, x2, y2, z2, t)
	local dir_x, dir_y, dir_z = M.normalize(x2 - x0, y2 - y0, z2 - z0)

	local x1 = x0 + dir_x
	local y1 = y0 + dir_y + 2
	local z1 = z0 + dir_z
	return M.bezier_3d_2o(x0, y0, z0, x1, y1, z1, x2, y2, z2, t)
end

return M
