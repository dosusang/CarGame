local M = {}
local rad2deg = math.deg(1)

local function basic_new_funciton(class, ...)
    local obj = setmetatable({}, class)
    obj:_init(...)
    return obj
end

local function basic_delete_func(obj)
    
end

M.create_class = function()
    local class = {}
    class.__index = class
    class.new = basic_new_funciton
    return class
end

M.extend_class = function(base)
   local child = setmetatable({}, base)
   child.__index = child
   return child
end

M.get_rb = function (gameobj)
    return gameobj:GetComponent(typeof(UnityRb))
end

M.get_angle2A = function(x, y)
    if x == 0 and y == 0 then
        return 
    end

    local l = x*x + y*y
    x = x/l
    y = y/l
    return math.atan(y, x) * rad2deg
end

function M.lerp_angle(a1, a2, p)
	if p > 1 then
		p = 1
	end

	return a1 + ((a2 - a1 + 180) % 360 - 180) * p
end

function M.lerp_rad(a1, a2, p)
	if p > 1 then
		p = 1
	end

	return a1 + ((a2 - a1 + 3.14159) % 6.283 - 3.14159) * p
end

function M.lerp(x, y, t)
    return x + t * (y - x)
end

function M.add3(x1, y1, z1, x2, y2, z2)
    return x1+x2, y1+y2, z1+z2
end

function M.clamp(x, min, max)
    if x < min then return min end
    if x < max then return x end
    return max
end

function M.load_prefab(name)
    return ResLoader.LoadRes(Path.GetPath(name .. ".prefab"), TypeUnityGameObject)
end

function M.bezier(x0, y0, x1, y1, x2, y2, t)
    local one_sub_t = 1 - t

    local p0 = one_sub_t * one_sub_t 
    local p1 = 2 * t * one_sub_t
    local p2 = t * t

    return p0 * x0 + p1 * x1 +  p2 * x2, p0 * y0 + p1 * y1 +  p2 * y2
end

function UnityGameObjectDontDestory(name)
    local obj = UnityGameObject(name)
    UnityGameObject.DontDestroyOnLoad(obj)
    return obj
end

return M