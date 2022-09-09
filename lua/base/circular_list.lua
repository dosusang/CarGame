-- 循环数组
-- 固定容量
-- 头部加入 头部弹出 尾部加入 尾部弹出
local M = Util.create_class()

function M:_init(max_size)
	assert(max_size)

	self.v_max_size = max_size
	self.v_begin_idx = 0
	self.v_end_idx = 0
	self.v_size = 0
	self.v_list = {}
end

function M:get_size()
	return self.v_size
end

function M:get_max_size()
	return self.v_max_size
end

function M:is_empty()
	return self.v_size == 0
end

function M:is_full()
	return self.v_size >= self.v_max_size
end

function M:get(idx)
	assert(idx)

	if self.v_size < idx then
		return nil
	end

	return self.v_list[self:_get_real_idx(idx)]
end

function M:get_front()
	if self:is_empty() then
		return nil
	end

	return self.v_list[self.v_begin_idx]
end

function M:get_back()
	if self:is_empty() then
		return nil
	end

	return self.v_list[self.v_end_idx]
end

function M:clear()
	while not self:is_empty() do
		self:pop_back()
	end
end

function M:pop_front()
	if self:is_empty() then
		return
	end

	local value = self.v_list[self:_get_real_idx(1)]

	self.v_list[self:_get_real_idx(1)] = nil

	if self.v_size == 1 then
		self.v_begin_idx = 0
		self.v_end_idx = 0
		self.v_size = 0 
	else
		self.v_begin_idx = self:_get_real_idx(2)
		self.v_size = self.v_size - 1
	end

	return value
end

-- force 如果满了则强制弹出最后一个
function M:push_front(value, force)
	assert(value ~= nil)

	if self:is_full() then
		if force then
			self:pop_back()
			return self:push_front(value, force)
		else
			return false
		end
	end

	if self:is_empty() then
		self.v_begin_idx = 1
		self.v_end_idx = 1
		self.v_size = 1

		self.v_list[self.v_begin_idx] = value
	else
		if self.v_begin_idx == 1 then
			self.v_begin_idx = self.v_max_size
		else
			self.v_begin_idx = self:_get_real_idx(0)
		end

		self.v_list[self.v_begin_idx] = value
		self.v_size = self.v_size + 1
	end

	return true
end

function M:pop_back()
	if self:is_empty() then
		return
	end

	local value = self.v_list[self:_get_real_idx(1)]

	self.v_list[self:_get_real_idx(self.v_size)] = nil

	if self.v_size == 1 then
		self.v_begin_idx = 0
		self.v_end_idx = 0
		self.v_size = 0
	else
		self.v_end_idx = self:_get_real_idx(self.v_size - 1)
		self.v_size = self.v_size - 1
	end

	return value
end

-- force 如果满了则强制弹出第一个
function M:push_back(value, force)
	assert(value ~= nil)
	
	if self:is_full() then
		if force then
			self:pop_front()
			return self:push_back(value, force)
		else
			return false
		end
	end

	if self:is_empty() then
		self.v_begin_idx = 1
		self.v_end_idx = 1
		self.v_size = 1

		self.v_list[self.v_begin_idx] = value
	else
		self.v_end_idx = self:_get_real_idx(self.v_size + 1)
		self.v_list[self.v_end_idx] = value
		self.v_size = self.v_size + 1
	end

	return true
end

function M:_get_real_idx(idx)
	return ((self.v_begin_idx - 1) + (idx - 1)) % self.v_max_size + 1
end

return M