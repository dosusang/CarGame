local M = Util.create_class()

function M:create_hero()
    return require("objs.entitys.basic_moveable"):new(hero_cfg)
end

function M:load_obj(path, luaobj)
    if not path then
        Log.Error("obj path is nil", debug.traceback())
    end
    local res = Util.load_prefab(path)
    if not res then
        Log.Error(path .. "资源不存在", debug.traceback())
        return
    end

    local obj = UnityGameObject.Instantiate(res)
    self.cid2obj[obj:GetInstanceID()] = luaobj;
    return obj
end

function M:delete_obj(obj)
    self.cid2obj[obj.gameobj:GetInstanceID()] = nil
    obj:on_destory()
end

function M:_init()
    self.cid2obj = {}
end

function M:enter_scene()
    Global.hero = self:create_hero()
end

function M:clear()
    Global.hero:die()
    Global.hero = nil
end

function M:update()
    local dt = TIME.deltaTime
    Global.hero:on_update(dt)
end

function M:fixed_update()
    Global.hero:on_fixed_update()
end

function M:on_collide(a_cid, b_cid)
    local missile = self.cid2obj[a_cid]

    if not missile or not missile.is_missile then return end
    local other = self.cid2obj[b_cid]
    if not other then return end

    missile:attack(other)
end

return M