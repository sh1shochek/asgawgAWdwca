-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget
-- Decompile time: 1.13 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local LocalPlayer = Players.LocalPlayer

function v1.DisableInput(a1) -- Line: 20 -- types: a1: userdata
    a1.Active = false
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("GuiObject") then
            v.Active = false
        end
    end
end

local function currentTarget() -- Line: 30 -- upvalues: SpectateController (val), LocalPlayer (val)
    local v1 = SpectateController.GetCurrentSpectateInstance()
    if v1 then
        return v1.Player
    end
    return LocalPlayer
end

function v1.Follow(a1) -- Line: 36
    -- upvalues: LocalPlayer (val), SpectateController (val), GameState (val)
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 37 -- upvalues: a1 (val), SpectateController (upval), LocalPlayer (upval)
        local v1 = SpectateController.GetCurrentSpectateInstance()
        a1(if not v1 then LocalPlayer else v1.Player)
    end)
    SpectateController.ListenToSpectate:Connect(function(a1_2) -- Line: 41 -- upvalues: a1 (val), LocalPlayer (upval)
        if a1_2 then
            a1(a1_2)
            return
        end
        if not LocalPlayer:GetAttribute("IsSpectating") then
            a1(LocalPlayer)
        end
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(function() -- Line: 52 -- upvalues: LocalPlayer (upval), a1 (val), SpectateController (upval)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            a1(LocalPlayer)
            return
        end
        local v1 = SpectateController.GetPlayer()
        if v1 then
            a1(v1)
        end
    end)
    if not LocalPlayer:GetAttribute("IsSpectating") then
        a1(LocalPlayer)
    else
        local v1 = SpectateController.GetPlayer()
        if v1 then
            a1(v1)
        end
    end
    GameState.ListenToState(function(a1_2, a2) -- Line: 75 -- upvalues: a1 (val), SpectateController (upval), LocalPlayer (upval)
        if a2 == "Buy Period" or a2 == "Round In Progress" then
            local v1 = SpectateController.GetCurrentSpectateInstance()
            a1(if not v1 then LocalPlayer else v1.Player)
        end
    end)
end

return v1