local M = Util.create_class()

----------------------------
-- 游戏GameObject缓冲池 对应每一个资源path
-- 策略：一般状态下自动管理Asset实例
-- 对于同一资源，若回收时间超过1分钟 则直接销毁
-- 若回收时间在30s~60s之间  缓存且在一分钟后销毁
-- 若回收时间小于30s 缓存且在30s后销毁
----------------------------

local TIME_LONG = 60
local TIME_SHORT = 30
local _tinsert = table.insert
local _tremove = table.remove

function M:_init(name, type)
    self.name = name
    self.type = type

    self.cur_len = 0

    self.using_objs = {}
    self.free_objs = {}
    self.base_res = ResLoader.LoadRes(Path.GetPath(self.name), self.type)
    self.root_trans = UnityGameObjectDontDestory("POOL" .. name).transform
end

function M:get()
    local free_obj = self:_get_free_obj()
    if free_obj then
       return free_obj 
    end

    local luaobj = self:_create()
    return luaobj.gameobj
end

function M:_create()
    local ret = {}

    if not self.base_res then
        Log.Error("资源不存在", self.name, "type", self.type)
        return
    end
    ret.gameobj = UnityGameObject.Instantiate(self.base_res)

    ret.enable_time = TIME.time
    ret.cid = ret.gameobj:GetInstanceID()

    self.using_objs[ret.cid] = ret
    return ret
end

function M:try_cache_obj(obj)
    obj.transform:SetParent(self.root_trans)

    local luaobj = self.using_objs[obj:GetInstanceID()]
    local cur_time = TIME.time

    local live_time = cur_time - luaobj.enable_time
    if live_time > TIME_LONG then
        self:destory_using_obj(luaobj)
    elseif live_time > TIME_SHORT then
        self:_cache_free_obj(luaobj, TIME_LONG)
    else
        self:_cache_free_obj(luaobj, TIME_SHORT)
    end
end

function M:_cache_free_obj(luaobj, cache_time)
    luaobj.cache_time = cache_time

    self.using_objs[luaobj.cid] = nil
    _tinsert(self.free_objs, luaobj)
end

function M:_get_free_obj()
    local last_idx = #self.free_objs
    if last_idx == 0 then return end

    local obj = self.free_objs[last_idx]
    obj.enable_time = TIME.time

    _tremove(self.free_objs, last_idx)
    self.using_objs[obj.cid] = obj
    return obj.gameobj
end

function M:update_free_objs(update_interval)
    local obj 
    for i = #self.free_objs, 1, -1 do
        obj = self.free_objs[i]
        if obj.cache_time > 0 then
            obj.cache_time = obj.cache_time - update_interval -- 两秒update一次
        else
            UnityGameObject.Destroy(obj.gameobj)
            _tremove(self.free_objs, i)
        end
    end
end

function M:destory_using_obj(luaobj)
    self.using_objs[luaobj.cid] = nil
    UnityGameObject.Destroy(luaobj.gameobj)
end

function M:on_destory()
    -- Resources.load无法卸载指定预设 只能通过统一接口卸载
    -- ResLoader.UnloadRes(self.base_res)
end

return M