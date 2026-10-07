-- Players.Caelclaw404.PlayerScripts.PlayerModule
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule
-- Decompile time: 0.48 ms

local u0 = {}
u0.__index = u0

function u0.new() -- Line: 12 -- upvalues: u0 (val)
    local v1 = setmetatable({}, u0)
    v1.cameras = require(script:WaitForChild("CameraModule"))
    v1.controls = require(script:WaitForChild("ControlModule"))
    return v1
end

function u0.GetCameras(a1) -- Line: 19
    return a1.cameras
end

function u0.GetControls(a1) -- Line: 23
    return a1.controls
end

function u0:GetClickToMoveController() -- Line: 27
    return self.controls:GetClickToMoveController()
end

return u0.new()