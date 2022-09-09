local M = Util.create_class()
local Vec3 = require("base.vec3")

function M:_init(obj_cfg)
    self.cfg = obj_cfg

    local obj = SceneMgr:load_obj(obj_cfg.res_path, self)

    self.name = obj_cfg.name or "No Name Obj"
    obj.name = self.name
    self.transform = obj.transform
    self.gameobj = obj

    self.components = {}
    self.pos = Vec3.New()
    self.transform.position = self.pos
    self.is_destroyed = false

    local born_pos = obj_cfg.born_pos
    if born_pos then
        self:set_pos2(born_pos.x, born_pos.z)
    end
end

function M:on_update(dt)
    for _, component in pairs(self.components) do
        if component.on_update then
            component:on_update(dt)
        end
    end
end

function M:on_fixed_update()
    for _, component in pairs(self.components) do
        if component.on_fixed_update then
            component:on_fixed_update()
        end
    end
end

function M:add_component(class, name, ...)
    local component = class:new(self, ...)
    self.components[name] = component
    self[name] = component
end

function M:on_destory()
    for name, component in pairs(self.components) do
        if component.on_destory then
            component:on_destory() 
        end
        self[name] = nil
        self.components[name] = nil
    end

    UnityGameObject.Destroy(self.gameobj)
    self.transform = nil
    self.is_destroyed = true
end

function M:set_pos2(x, z)
    local pos = self.pos
    pos.x, pos.z = x, z

    CompExtention.SetPosA(self.gameobj, x, pos.y, pos.z)
end

function M:get_pos2()
    return self.pos.x, self.pos.z
end

function M:get_dist_sqrt(obj)
    if not obj or obj.is_destroyed then
        return
    end

    local x, z = self:get_pos2()
    local px, pz = obj:get_pos2()
    return (x - px) * (x - px) + (z - pz) * (z - pz) 
end

function M:get_faceto_obj_rad(obj)
    local x, z = self:get_pos2()
    local px, pz = obj:get_pos2()
    local tx, tz = px- x, pz - z
    return math.atan(tz, tx)
end

return M