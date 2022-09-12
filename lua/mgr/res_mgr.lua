local M = Util.create_class()
local ResPool = require("mgr.res_pool")
local UPDATE_INTERVAL = 2

function M:_init()
    self.path2pool = {}
    self.cid2pool = {}
    self.last_update_time = 0

    UnityGameObjectDontDestory("POOL")
end

function M:update()
    if TIME.time - self.last_update_time > UPDATE_INTERVAL then
        self.last_update_time = TIME.time
        for _, pool in pairs(self.path2pool) do
            pool:update_free_objs(UPDATE_INTERVAL)
        end
    end
end

function M:load(path, type)
    local pool = self.path2pool[path]
    if not pool then
        pool = ResPool:new(path, type)
    end

    local gameobj = pool:get()
    gameobj:SetActive(true)

    self.cid2pool[gameobj:GetInstanceID()] = pool
    self.path2pool[path] = pool
    return gameobj
end

function M:release(gameobj)
    local pool = self.cid2pool[gameobj:GetInstanceID()]
    if not pool then
        Log.Error("尝试释放一个没有被Pooled的gameobj", gameobj, debug.traceback())
        return
    end

    gameobj:SetActive(false)

    pool:try_cache_obj(gameobj)
end

return M

