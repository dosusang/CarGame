local M = Util.create_class()
local MathX = require ("base.mathx")
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local test = require "fsm.base_state_mgr"

function M:_init(entity) 
    self.v_gameobj = entity.gameobj
    self.entity = entity
    self.transform = self.v_gameobj.transform
    self.speed = entity.cfg.speed

    self.vx = 0
    self.vz = 0

    self.v_test_state_mgr = test:new()
end

local KEYMAP = {
    [KeyCode.E] = function(self)
        self.entity:delete_self()
    end,

    [KeyCode.Q] = function(self)
        self.v_test_state_mgr:transition_state("idle")
    end,

    [KeyCode.A] = function(self)
        self.v_test_state_mgr:transition_state("attack")
    end,

    [KeyCode.Z] = function(self)
        self.v_test_state_mgr:transition_state("chase")
    end,
}

function M:get_input()
    for k, func in pairs(KEYMAP) do
        if Input.GetKey(k) then
            func(self)
        end
    end

    self.vx = Input.GetAxis("Horizontal");
    self.vz = Input.GetAxis("Vertical");
end

function M:on_update()
    self:get_input()

    if self.v_test_state_mgr then
        self.v_test_state_mgr:on_update()
    end
end


function M:on_fixed_update()
    local pos = self.entity.pos
    pos.x = pos.x + self.vx * self.speed * 0.02
    pos.z = pos.z + self.vz * self.speed * 0.02

    self.entity:set_pos2(pos.x, pos.z)
end

return M