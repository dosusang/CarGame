local M = {}

M.start = function()
    SceneMgr:enter_scene()
end

M.update = function()
    SceneMgr:update()
end

M.fixed_update = function()
    SceneMgr:fixed_update()
end

M.on_collide = function (a, b)
    SceneMgr:on_collide(a, b)
end

return M