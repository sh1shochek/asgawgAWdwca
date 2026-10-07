-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraUI
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraUI
-- Decompile time: 0.34 ms

local StarterGui = game:GetService("StarterGui")
local u5 = false
local u6 = {}

function u6.setCameraModeToastEnabled(a1) -- Line: 10 -- upvalues: u5 (ref), u6 (val) -- types: a1: boolean
    if not a1 and not u5 then
        return
    end
    if not u5 then
        u5 = true
    end
    if not a1 then
        u6.setCameraModeToastOpen(false)
    end
end

function u6.setCameraModeToastOpen(a1) -- Line: 24 -- upvalues: u5 (ref), StarterGui (val) -- types: a1: boolean
    assert(u5)
    if a1 then
        StarterGui:SetCore("SendNotification", {Title = "Camera Control Enabled", Text = "Right click to toggle", Duration = 3})
    end
end

return u6