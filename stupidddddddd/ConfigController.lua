-- ReplicatedStorage.Controllers.ConfigController
-- Script path: ReplicatedStorage.Controllers.ConfigController
-- Decompile time: 1.80 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys)
local u22 = RunService:IsServer()
local u25 = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer
local u27 = {}
local u28 = nil

local function getSnapshot() -- Line: 20 -- upvalues: u22 (val), u28 (ref)
    if not u22 then
        return nil
    end
    if u28 then
        return u28
    end
    local success, result = pcall(function() -- Line: 24
        return game:GetService("ConfigService"):GetConfigAsync()
    end)
    if success and result then
        result.UpdateAvailable:Connect(function() -- Line: 30 -- upvalues: result (val)
            pcall(result.Refresh, result)
        end)
        return result
    end
    return nil
end

function u27.Get(a1) -- Line: 36
    -- upvalues: u25 (val), ConfigKeys (val), u22 (val), getSnapshot (val), LocalPlayer (val)
    if u25 and ConfigKeys.Defaults[a1] ~= nil then
        return ConfigKeys.Defaults[a1]
    end
    if not u22 then
        return LocalPlayer:GetAttribute(a1)
    end
    local v1 = getSnapshot()
    if not v1 then
        return nil
    end
    local success, result = pcall(v1.GetValue, v1, a1)
    if success then
        return result
    end
    return nil
end

function u27.GetRewardMultiplier(a1) -- Line: 50 -- upvalues: u27 (val), ConfigKeys (val) -- types: a1: string
    return (math.max(0, tonumber((u27.Get(a1))) or ConfigKeys.Defaults[a1] or 1))
end

function u27.OnChanged(a1, a2) -- Line: 54
    -- upvalues: u22 (val), getSnapshot (val), LocalPlayer (val)
    if not u22 then
        return (LocalPlayer:GetAttributeChangedSignal(a1)):Connect(function() -- Line: 65 -- upvalues: a2 (val), LocalPlayer (upval), a1 (val)
            a2(LocalPlayer:GetAttribute(a1))
        end)
    end
    local u4 = getSnapshot()
    if not u4 then
        return nil
    end
    local success, result = pcall(u4.GetValueChangedSignal, u4, a1)
    if success and result then
        return result:Connect(function() -- Line: 60 -- upvalues: u4 (val), a1 (val), a2 (val)
            local success, result = pcall(u4.GetValue, u4, a1)
            a2(if not success then nil else result)
        end)
    end
    return nil
end

return u27