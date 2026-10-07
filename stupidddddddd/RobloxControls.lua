-- ReplicatedStorage.Packages.RobloxControls
-- Script path: ReplicatedStorage.Packages.RobloxControls
-- Decompile time: 1.53 ms

local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Promise = require(script.Parent.Promise)
local BindableEvent = Instance.new("BindableEvent")
local u23 = {Enum.CoreGuiType.All}
local u25 = {Public = {}, Private = {}}

function u25.Private.OnRespawnCharacterRequested() -- Line: 27 -- upvalues: Players (val)
    local Character = Players.LocalPlayer.Character
    if not Character then
        return
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return
    end
    Humanoid.Health = 0
end

function u25.Public.SetCoreAsync(a1, ...) -- Line: 63 -- upvalues: Promise (val), StarterGui (val)
    local u1 = {}
    u1[1] = ...
    return Promise.new(function(a1) -- Line: 66 -- upvalues: StarterGui (upval), u1 (val)
        local result, success
        local v1 = nil
        while not v1 do
            success, result = pcall(StarterGui.SetCore, StarterGui, table.unpack(u1))
            if not success then
                warn(result)
            end
            task.wait(0.5)
        end
        return a1()
    end)
end

function u25.Public.GetCoreAsync(a1, ...) -- Line: 100 -- upvalues: Promise (val), StarterGui (val)
    local u1 = {}
    u1[1] = ...
    return Promise.new(function(a1) -- Line: 103 -- upvalues: StarterGui (upval), u1 (val)
        local result, success
        local v1 = nil
        local v2 = nil
        while not v1 do
            success, result = pcall(StarterGui.SetCore, StarterGui, table.unpack(u1))
            if not success then
                warn(result)
            end
            task.wait(0.5)
        end
        return a1(v2)
    end)
end

function u25.Public.SetRespawnCallback(a1, a2) -- Line: 133 -- upvalues: u25 (val) -- types: a2: function
    u25.Private.OnRespawnCharacterRequested = a2
end

function u25.Public:DisableRespawning() -- Line: 147
    self:SetCoreAsync("ResetButtonCallback", false)
end

function u25.Public.EnableRespawning(a1) -- Line: 161 -- upvalues: BindableEvent (val)
    a1:SetCoreAsync("ResetButtonCallback", BindableEvent)
end

function u25.Public.SetDefaultCoreGui(a1, ...) -- Line: 179 -- upvalues: u23 (ref), StarterGui (val)
    u23 = {...}
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    for i, j in u23 do
        StarterGui:SetCoreGuiEnabled(j, true)
    end
end

function u25.Public.EnableCoreGui(a1) -- Line: 199 -- upvalues: u23 (ref), StarterGui (val)
    for i, j in u23 do
        StarterGui:SetCoreGuiEnabled(j, true)
    end
end

function u25.Public.DisableCoreGui(a1) -- Line: 215 -- upvalues: u23 (ref), StarterGui (val)
    for i, j in u23 do
        StarterGui:SetCoreGuiEnabled(j, false)
    end
end

function u25.Public.DisableCharacterInput(a1) -- Line: 231 -- upvalues: ContextActionService (val)
    local v1 = ContextActionService
    local v2 = table.unpack((Enum.PlayerActions:GetEnumItems()))
    v1:BindAction("RobloxControls-FreezeAction", function() -- Line: 232
        return Enum.ContextActionResult.Sink
    end, false, v2)
end

function u25.Public.EnableCharacterInput(a1) -- Line: 247 -- upvalues: ContextActionService (val)
    ContextActionService:UnbindAction("RobloxControls-FreezeAction")
end

u25.Public:DisableRespawning()
BindableEvent.Event:Connect(function() -- Line: 252 -- upvalues: u25 (val)
    u25.Private.OnRespawnCharacterRequested()
end)
return u25.Public