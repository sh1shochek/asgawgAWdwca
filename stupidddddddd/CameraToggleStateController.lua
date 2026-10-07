-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraToggleStateController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraToggleStateController
-- Decompile time: 0.89 ms

game:GetService("Players")
game:GetService("UserInputService")
UserSettings():GetService("UserGameSettings")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local u40 = false
local u42 = tick()
local u43 = false
local u44 = false
local u45 = false
CameraUI.setCameraModeToastEnabled(false)
return function(a1) -- Line: 20
    -- upvalues: CameraInput (val), u40 (ref), u43 (ref), u42 (ref), CameraUI (val), u45 (ref), u44 (ref)
    -- upvalues: CameraUtils (val)
    local v1 = CameraInput.getTogglePan()
    if a1 and v1 ~= u40 then
        u43 = true
    end
    if u40 ~= v1 or tick() - u42 > 3 then
        CameraUI.setCameraModeToastOpen(v1 and tick() - u42 < 3)
        if v1 then
            u43 = false
        end
        u42 = tick()
        u40 = v1
    end
    if a1 ~= u45 then
        if a1 then
            u44 = CameraInput.getTogglePan()
            CameraInput.setTogglePan(true)
        elseif not u43 then
            CameraInput.setTogglePan(u44)
        end
    end
    if not a1 then
        if CameraInput.getTogglePan() then
            CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
            CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
        elseif not CameraInput.getHoldPan() then
            CameraUtils.restoreMouseIcon()
            CameraUtils.restoreMouseBehavior()
            CameraUtils.restoreRotationType()
        else
            CameraUtils.restoreMouseIcon()
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
            CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
        end
    else
        if not CameraInput.getTogglePan() then
            CameraUtils.restoreMouseIcon()
            CameraUtils.restoreMouseBehavior()
        else
            CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
        end
        CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
    end
    u45 = a1
end