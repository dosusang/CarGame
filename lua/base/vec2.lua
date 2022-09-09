local Math = require("base.mathx")

local clamp = Math.Clamp
local acos = math.acos
local sqrt = math.sqrt
local _cos = math.cos
local _sin = math.sin
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget

local vec2 = {}
vec2.__index = vec2

vec2.__call = function(t, x, y)
	return vec2.New(x, y)
end

function vec2.New(x, y)
	local v = {x = x or 0, y = y or 0}
	setmetatable(v, vec2)	
	return v
end

function vec2:Set(x,y)
	self.x = x or 0
	self.y = y or 0	
end

function vec2:Get()
	return self.x, self.y
end

function vec2:GetArray()
	return {self.x, self.y}
end

function vec2:SqrMagnitude()
	return self.x * self.x + self.y * self.y
end

function vec2:Clone()
	return vec2.New(self.x, self.y)
end

function vec2:Normalize()
	local v = self:Clone()
	return v:SetNormalize()	
end

function vec2:SetNormalize()
	local num = self:Magnitude()	
	
	if num == 1 then
		return self
    elseif num > 1e-05 then    
        self:Div(num)
    else    
        self:Set(0,0)
	end 

	return self
end

function vec2.Dot(lhs, rhs)
	return lhs.x * rhs.x + lhs.y * rhs.y
end

function vec2:Rotate(radian)
	local cos = _cos(radian)
	local sin = _sin(radian)

	local x = self.x * cos + self.y * sin
	local y = self.y * cos + self.x * sin

	return vec2.New(x, y)
end

function vec2:SetRotate(radian)
	local cos = _cos(radian)
	local sin = _sin(radian)

	local x = self.x * cos - self.y * sin
	local y = self.y * cos + self.x * sin

	self.x = x
	self.y = y
end

function vec2.Cross(lhs, rhs)
    return lhs.x * rhs.y - lhs.y * rhs.x
end

function vec2.Angle(from, to)
	return acos(clamp(vec2.Dot(from:Normalize(), to:Normalize()), -1, 1)) * 57.29578
end

function vec2.Magnitude(v2)
	return sqrt(v2.x * v2.x + v2.y * v2.y)
end

function vec2:Div(d)
	self.x = self.x / d
	self.y = self.y / d	
	
	return self
end

function vec2:Mul(d)
	self.x = self.x * d
	self.y = self.y * d
	
	return self
end

function vec2:Add(b)
	self.x = self.x + b.x
	self.y = self.y + b.y
	
	return self
end

function vec2:Sub(b)
	self.x = self.x - b.x
	self.y = self.y - b.y
	
	return
end

vec2.__tostring = function(self)
	return string.format("[%f,%f]", self.x, self.y)
end

vec2.__div = function(va, d)
	return vec2.New(va.x / d, va.y / d)
end

vec2.__mul = function(va, d)
	return vec2.New(va.x * d, va.y * d)
end

vec2.__add = function(va, vb)
	return vec2.New(va.x + vb.x, va.y + vb.y)
end

vec2.__sub = function(va, vb)
	return vec2.New(va.x - vb.x, va.y - vb.y)
end

vec2.__unm = function(va)
	return vec2.New(-va.x, -va.y)
end

vec2.__eq = function(va,vb)
	return va.x == vb.x and va.y == vb.y
end

vec2.up 		= vec2.New(0,1)
vec2.right	= vec2.New(1,0)
vec2.zero	= vec2.New(0,0)
vec2.one		= vec2.New(1,1)

vec2.magnitude 		= vec2.Magnitude
vec2.normalized 		= vec2.Normalize
vec2.sqrMagnitude 	= vec2.SqrMagnitude

return vec2
