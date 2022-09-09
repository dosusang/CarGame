local Math = require "base.mathx"

local math  = math
local acos	= math.acos
local sqrt 	= math.sqrt
local max 	= math.max
local min 	= math.min
local clamp = Math.Clamp
local cos	= math.cos
local sin	= math.sin
local abs	= math.abs
local sign	= Math.Sign
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local type = type

local _cos = math.cos
local _sin = math.sin

local rad2Deg = Math.Rad2Deg
local deg2Rad = Math.Deg2Rad

local vec3 = {}
-- vec3.__index = vec3

function vec3.ConstNew(x, y, z)
	local ret = {
		__const = {x = x or 0, y = y or 0, z = z or 0}
	}
	setmetatable(ret, vec3)

	return ret
end

local _constNew = vec3.ConstNew

function vec3.New(x, y, z)
	local v = {x = x or 0, y = y or 0, z = z or 0}
	setmetatable(v, vec3)
	return v
end

local _new = vec3.New

vec3.__call = function(t,x,y,z)
	return _new(x,y,z)
end
	
function vec3:Set(x,y,z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function vec3:SetA(vec)
	self.x = vec.x or 0
	self.y = vec.y or 0
	self.z = vec.z or 0
end

function vec3:Get()			
	return self.x, self.y, self.z	
end

function vec3:GetArray()
	return {self.x, self.y, self.z}
end

function vec3:Clone()
	return _new(self.x, self.y, self.z)
end

function vec3:ToRight()
	return _new(self.z, self.y, -self.x)
end

function vec3.Distance(va, vb)
	return sqrt((va.x - vb.x)^2 + (va.y - vb.y)^2 + (va.z - vb.z)^2)
end

function vec3.SquareDistance(a, b)
	return ((a.x -b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2)
end

function vec3.Dot(lhs, rhs)
	return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
end

function vec3.DotA(x1, y1, z1, x2, y2, z2)
	return x1 * x2 + y1 * y2 + z1 * z2
end

function vec3.Lerp(from, to, t)	
	t = clamp(t, 0, 1)
	return _new(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function vec3.LerpB(from, to, t)
	t = clamp(t, 0, 1)
	return from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t
end

function vec3.LerpA(from, to, t, out)	
	t = clamp(t, 0, 1)
	out:Set(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function vec3:Magnitude()
	return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function vec3.Max(lhs, rhs)
	return _new(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
end

function vec3.Min(lhs, rhs)
	return _new(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
end

function vec3.Normalize(v)
	local x,y,z = v.x, v.y, v.z		
	local num = sqrt(x * x + y * y + z * z)	
	
	if num > 1e-5 then		
		return _new(x/num, y/num, z/num)   			
    end
	  
	return _new(0, 0, 0)			
end

function vec3:SetNormalize()
	local num = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	
	if num > 1e-5 then    
        self.x = self.x / num
		self.y = self.y / num
		self.z = self.z /num
    else    
		self.x = 0
		self.y = 0
		self.z = 0
	end 

	return self
end
	
function vec3:SqrMagnitude()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

local dot = vec3.Dot

function vec3.Angle(from, to)
	return acos(clamp(dot(from:Normalize(), to:Normalize()), -1, 1)) * rad2Deg
end

function vec3.AngleRaw(from, to)
	return acos(dot(from, to)) * rad2Deg
end

function vec3:ClampMagnitude(maxLength)	
	if self:SqrMagnitude() > (maxLength * maxLength) then    
		self:SetNormalize()
		self:Mul(maxLength)        
    end
	
    return self
end

function vec3.OrthoNormalize(va, vb, vc)	
	va:SetNormalize()
	vb:Sub(vb:Project(va))
	vb:SetNormalize()
	
	if vc == nil then
		return va, vb
	end
	
	vc:Sub(vc:Project(va))
	vc:Sub(vc:Project(vb))
	vc:SetNormalize()		
	return va, vb, vc
end

--[[function vec3.RotateTowards2(from, to, maxRadiansDelta, maxMagnitudeDelta)	
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)
	
	local dota	= dot(v1, v2)
	local angle = acos(dota)			
	local theta = min(angle, maxRadiansDelta)	
	local len	= 0
	
	if len1 < len2 then
		len = min(len2, len1 + maxMagnitudeDelta)
	elseif len1 == len2 then
		len = len1
	else
		len = max(len2, len1 - maxMagnitudeDelta)
	end
						    
    v2:Sub(v1 * dota)
    v2:SetNormalize()     
	v2:Mul(sin(theta))
	v1:Mul(cos(theta))
	v2:Add(v1)
	v2:SetNormalize()
	v2:Mul(len)
	return v2	
end

function vec3.RotateTowards1(from, to, maxRadiansDelta, maxMagnitudeDelta)	
	local omega, sinom, scale0, scale1, len, theta
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)
	
	local cosom = dot(v1, v2)
	
	if len1 < len2 then
		len = min(len2, len1 + maxMagnitudeDelta)	
	elseif len1 == len2 then
		len = len1
	else
		len = max(len2, len1 - maxMagnitudeDelta)
	end 	
	
	if 1 - cosom > 1e-6 then	
		omega 	= acos(cosom)
		theta 	= min(omega, maxRadiansDelta)		
		sinom 	= sin(omega)
		scale0 	= sin(omega - theta) / sinom
		scale1 	= sin(theta) / sinom
		
		v1:Mul(scale0)
		v2:Mul(scale1)
		v2:Add(v1)
		v2:Mul(len)
		return v2
	else 		
		v1:Mul(len)
		return v1
	end			
end]]
	
function vec3.MoveTowards(current, target, maxDistanceDelta)	
	local delta = target - current	
    local sqrDelta = delta:SqrMagnitude()
	local sqrDistance = maxDistanceDelta * maxDistanceDelta
	
    if sqrDelta > sqrDistance then    
		local magnitude = sqrt(sqrDelta)
		
		if magnitude > 1e-6 then
			delta:Mul(maxDistanceDelta / magnitude)
			delta:Add(current)
			return delta
		else
			return current:Clone()
		end
    end
	
    return target:Clone()
end

function vec3:AlmostZero()
	local len = self:SqrMagnitude()
	return len <= 0.1
end

function vec3:Rotate2(radian)
	local cos = _cos(radian)
	local sin = _sin(radian)

	local x = self.x * cos + self.y * sin
	local y = self.y * cos + self.x * sin

	return vec3.New(x, 0, y)
end

function ClampedMove(lhs, rhs, clampedDelta)
	local delta = rhs - lhs
	
	if delta > 0 then
		return lhs + min(delta, clampedDelta)
	else
		return lhs - min(-delta, clampedDelta)
	end
end

local overSqrt2 = 0.7071067811865475244008443621048490

local function OrthoNormalVector(vec)
	local res = _new()
	
	if abs(vec.z) > overSqrt2 then			
		local a = vec.y * vec.y + vec.z * vec.z
		local k = 1 / sqrt (a)
		res.x = 0
		res.y = -vec.z * k
		res.z = vec.y * k
	else			
		local a = vec.x * vec.x + vec.y * vec.y
		local k = 1 / sqrt (a)
		res.x = -vec.y * k
		res.y = vec.x * k
		res.z = 0
	end
	
	return res
end

function vec3.RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta)
	local len1 = current:Magnitude()
	local len2 = target:Magnitude()
	
	if len1 > 1e-6 and len2 > 1e-6 then	
		local from = current / len1
		local to = target / len2		
		local cosom = dot(from, to)
				
		if cosom > 1 - 1e-6 then		
			return vec3.MoveTowards (current, target, maxMagnitudeDelta)		
		elseif cosom < -1 + 1e-6 then		
			local axis = OrthoNormalVector(from)						
			local q = Quaternion.AngleAxis(maxRadiansDelta * rad2Deg, axis)	
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		else		
			local angle = acos(cosom)
			local axis = vec3.Cross(from, to)
			axis:SetNormalize ()
			local q = Quaternion.AngleAxis(min(maxRadiansDelta, angle) * rad2Deg, axis)			
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		end
	end
		
	return vec3.MoveTowards(current, target, maxMagnitudeDelta)
end
	
function vec3.SmoothDamp(current, target, currentVelocity, smoothTime)
	local maxSpeed = math.huge
	local deltaTime = Global.elapsed
    smoothTime = max(0.0001, smoothTime)
    local num = 2 / smoothTime
    local num2 = num * deltaTime
    local num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)    
    local vector2 = target:Clone()
    local maxLength = maxSpeed * smoothTime
	local vector = current - target
    vector:ClampMagnitude(maxLength)
    target = current - vector
    local vec3 = (currentVelocity + (vector * num)) * deltaTime
    currentVelocity = (currentVelocity - (vec3 * num)) * num3
    local vector4 = target + (vector + vec3) * num3	
	
    if vec3.Dot(vector2 - current, vector4 - vector2) > 0 then    
        vector4 = vector2
        currentVelocity:Set(0,0,0)
    end
	
    return vector4, currentVelocity
end	
	
function vec3.Scale(a, b)
	local x = a.x * b.x
	local y = a.y * b.y
	local z = a.z * b.z	
	return _new(x, y, z)
end
	
function vec3.Cross(lhs, rhs)
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	return _new(x,y,z)	
end
	
function vec3:Equals(other)
	return self.x == other.x and self.y == other.y and self.z == other.z
end
		
function vec3.Reflect(inDirection, inNormal)
	local num = -2 * dot(inNormal, inDirection)
	inNormal = inNormal * num
	inNormal:Add(inDirection)
	return inNormal
end

	
function vec3.Project(vector, onNormal)
	local num = onNormal:SqrMagnitude()
	
	if num < 1.175494e-38 then	
		return _new(0,0,0)
	end
	
	local num2 = dot(vector, onNormal)
	local v3 = onNormal:Clone()
	v3:Mul(num2/num)	
	return v3
end

function vec3.ProjectEx(vector, onNormal, out)
	local num = onNormal:SqrMagnitude()
	
	if num < 1.175494e-38 then	
		out:Set(0,0,0)
		return out
	end
	
	local num2 = dot(vector, onNormal)
	out:SetA(onNormal)
	out:Mul(num2/num)	
	return out
end

function vec3.ProjectOnPlane(vector, planeNormal)
	local v3 = vec3.Project(vector, planeNormal)
	v3:Mul(-1)
	v3:Add(vector)
	return v3
end		

function vec3.Slerp(from, to, t)
	local omega, sinom, scale0, scale1

	if t <= 0 then		
		return from:Clone()
	elseif t >= 1 then		
		return to:Clone()
	end
	
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)

	local len 	= (len2 - len1) * t + len1
	local cosom = dot(v1, v2)
	
	if 1 - cosom > 1e-6 then
		omega 	= acos(cosom)
		sinom 	= sin(omega)
		scale0 	= sin((1 - t) * omega) / sinom
		scale1 	= sin(t * omega) / sinom
	else 
		scale0 = 1 - t
		scale1 = t
	end

	v1:Mul(scale0)
	v2:Mul(scale1)
	v2:Add(v1)
	v2:Mul(len)
	return v2
end

function vec3:Mul(q)
	if type(q) == "number" then
		self.x = self.x * q
		self.y = self.y * q
		self.z = self.z * q
	else
		self:MulQuat(q)
	end
	
	return self
end

function vec3:Div(d)
	self.x = self.x / d
	self.y = self.y / d
	self.z = self.z / d
	
	return self
end

function vec3:Add(vb)
	self.x = self.x + vb.x
	self.y = self.y + vb.y
	self.z = self.z + vb.z
	
	return self
end

function vec3:Sub(vb)
	self.x = self.x - vb.x
	self.y = self.y - vb.y
	self.z = self.z - vb.z
	
	return self
end

function vec3:MulQuat(quat)	   
	local num 	= quat.x * 2
	local num2 	= quat.y * 2
	local num3 	= quat.z * 2
	local num4 	= quat.x * num
	local num5 	= quat.y * num2
	local num6 	= quat.z * num3
	local num7 	= quat.x * num2
	local num8 	= quat.x * num3
	local num9 	= quat.y * num3
	local num10 = quat.w * num
	local num11 = quat.w * num2
	local num12 = quat.w * num3
	
	local x = (((1 - (num5 + num6)) * self.x) + ((num7 - num12) * self.y)) + ((num8 + num11) * self.z)
	local y = (((num7 + num12) * self.x) + ((1 - (num4 + num6)) * self.y)) + ((num9 - num10) * self.z)
	local z = (((num8 - num11) * self.x) + ((num9 + num10) * self.y)) + ((1 - (num4 + num5)) * self.z)
	
	self:Set(x, y, z)	
	return self
end

function vec3.AngleAroundAxis (from, to, axis)	 	 
	from = from - vec3.Project(from, axis)
	to = to - vec3.Project(to, axis) 	    
	local angle = vec3.Angle (from, to)	   	    
	return angle * (vec3.Dot (axis, vec3.Cross (from, to)) < 0 and -1 or 1)
end

-- vec3.__tostring = function(self)
-- 	return "["..self.x..","..self.y..","..self.z.."]"
-- end

vec3.__div = function(va, d)
	return _new(va.x / d, va.y / d, va.z / d)
end

vec3.__mul = function(va, d)
	if type(d) == "number" then
		return _new(va.x * d, va.y * d, va.z * d)
	else
		local vec = va:Clone()
		vec:MulQuat(d)
		return vec
	end	
end

vec3.__add = function(va, vb)
	return _new(va.x + vb.x, va.y + vb.y, va.z + vb.z)
end

vec3.__sub = function(va, vb)
	return _new(va.x - vb.x, va.y - vb.y, va.z - vb.z)
end

vec3.__unm = function(va)
	return _new(-va.x, -va.y, -va.z)
end

vec3.__eq = function(a,b)
	local v = a - b
	local delta = v:SqrMagnitude()
	return delta < 1e-10
end

vec3.__index = function(tbl, key)
	local __const = rawget(tbl, "__const")
	if __const then
		return __const[key] or vec3[key]
	else
		return vec3[key]
	end
end

vec3.__newindex = function(tbl, key)
	assert(nil, "const vec3 不能赋值")
end

vec3.up 		= _constNew(0,1,0)
vec3.down 		= _constNew(0,-1,0)
vec3.right		= _constNew(1,0,0)
vec3.left		= _constNew(-1,0,0)
vec3.forward 	= _constNew(0,0,1)
vec3.back		= _constNew(0,0,-1)
vec3.zero		= _constNew(0,0,0)
vec3.one		= _constNew(1,1,1)

vec3.magnitude	= vec3.Magnitude
vec3.normalized	= vec3.Normalize
vec3.sqrMagnitude= vec3.SqrMagnitude

return vec3
