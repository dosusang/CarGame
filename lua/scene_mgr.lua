local M = Util.create_class()

function M:_init()
    self.cid2obj = {}

    self.last_create_monster_time = 0
end

function M:load_obj(path, luaobj)
    if not path then
        Log.Error("obj path is nil", debug.traceback())
    end

    local obj = ResMgr:load(path, TypeUnityGameObject)

    if not obj then
        Log.Error(path .. "资源不存在", debug.traceback())
        return
    end

    self.cid2obj[obj:GetInstanceID()] = luaobj
    return obj
end

function M:destory_obj(luaobj)
    if not luaobj then
        Log.Error("destory_obj: luaobj is nil", debug.traceback()) 
        return 
    end

    if luaobj.is_destroyed then 
        Log.Error("destory_obj: luaobj is is_destroyed", debug.traceback()) 
        return 
    end

    self.cid2obj[luaobj.gameobj:GetInstanceID()] = nil;
    ResMgr:release(luaobj.gameobj)
    luaobj:on_destory()
end

function M:create_hero()
    return require("objs.entitys.hero"):new()
end

function M:enter_scene()
    Global.hero = self:create_hero()
    Global.main_cam = require("objs.entitys.camera"):new()
end

function M:clear()
    Global.hero:die()
    Global.hero = nil
end

-- 召怪要不要做个管理器
local create_monster_interval = 1
function M:update_create_monster()
    local cur_time = TIME.time
    if cur_time - self.last_create_monster_time > create_monster_interval then
        self.last_create_monster_time = cur_time
        require("objs.entitys.simple_monster"):new()
    end
end

function M:update()
    local dt = TIME.deltaTime
    self:update_create_monster()

    for _, luaobj in pairs(self.cid2obj)  do
        luaobj:on_update(dt)
    end
end

function M:fixed_update()

    for _, luaobj in pairs(self.cid2obj) do
        luaobj:on_fixed_update()
    end
end

function M:on_collide(a_cid, b_cid)
    local missile = self.cid2obj[a_cid]

    if not missile or not missile.is_missile then return end
    local other = self.cid2obj[b_cid]
    if not other then return end

    missile:attack(other)
end

return M