game_main = {}

local game = require("game_mode")

function game_main.update(dt)
    game.update()
    ResMgr:update()
end

function game_main.fixed_update()
    game.fixed_update()
end

function game_main.on_collide(a, b)
    game.on_collide(a, b)
end

function main()
    Global = {}
    TIME = CS.UnityEngine.Time
    Path = CS.PathFinder
    ResLoader = CS.ResLoader

    Input = CS.UnityEngine.Input
    UnityGameObject = CS.UnityEngine.GameObject
    TypeUnityGameObject = typeof(UnityGameObject)

    UnityRb = CS.UnityEngine.Rigidbody
    UnityCollider = CS.UnityEngine.Collider
    KeyCode = CS.UnityEngine.KeyCode
    Quaternion = CS.UnityEngine.Quaternion
    CompExtention = CS.CompExtention

    Util = require("util")
    Log = require("log")

    ResMgr = require("mgr.res_mgr"):new()
    SceneMgr = require("scene_mgr"):new()
    game.start()
end

main()


