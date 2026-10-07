-- ReplicatedStorage.Database.Custom.GameStats.Missions
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Missions
-- Decompile time: 0.71 ms

local v1
local v2 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local u11 = {}
local u12 = {}

function v2.GetMissionDefinition(a1) -- Line: 22 -- upvalues: u11 (val) -- types: a1: string
    return u11[a1]
end

function v2.GetMissionCategory(a1) -- Line: 28 -- upvalues: u11 (val) -- types: a1: string
    local v1 = u11[a1]
    return v1 and v1.Category or nil
end

function v2.GetMissionDisplayName(a1) -- Line: 35 -- upvalues: u11 (val) -- types: a1: string
    local v1 = u11[a1]
    return v1 and v1.DisplayName or a1
end

function v2.GetMissionDefinitions() -- Line: 42 -- upvalues: u12 (val)
    return table.clone(u12)
end

function v2.IsMissionAvailableForGamemode(a1, a2, a3) -- Line: 48 -- types: a3: boolean?
    if not a1.Gamemodes then
        return true
    end
    if not a2 then
        return a3 == true
    end
    return table.find(a1.Gamemodes, a2) ~= nil
end

for i, v in ipairs(script:GetDescendants()) do
    if v:IsA("ModuleScript") then
        v1 = require(v)
        if v1 and v1.MissionId then
            u11[v1.MissionId] = v1
            table.insert(u12, v1)
        end
    end
end
return v2