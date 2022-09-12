local M = Util.create_class()

function M:_init(entity)
    self.v_gameobj = entity.gameobj
    self.entity = entity
    self.transform = self.v_gameobj.transform
end

local KEYMAP = {
    [KeyCode.Space] = function(self)
        local missile = require("objs.entitys.missile"):new()
        local x, y, z = self.entity:get_pos3()
        missile:set_pos3(x, y, z)
    end
}

function M:get_input()
    for k, func in pairs(KEYMAP) do
        if Input.GetKey(k) then
            func(self)
        end
    end
end

function M:on_update()
    self:get_input()
end

return M
