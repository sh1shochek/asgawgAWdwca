-- ReplicatedStorage.Controllers.Observers.Game.MapLighting
-- Script path: ReplicatedStorage.Controllers.Observers.Game.MapLighting
-- Decompile time: 1.43 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting)
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local u20 = nil
local u21 = nil
local u22 = nil
local u23 = nil
local u24 = nil

local function applyMapLighting(a1) -- Line: 25 -- upvalues: u24 (ref), SceneLighting (val) -- types: a1: string
    u24 = SceneLighting.RestoreMap(a1, u24)
end

local function getMapNameFromInstance(a1) -- Line: 31 -- types: a1: userdata
    local Attribute = a1:GetAttribute("MapName")
    if typeof(Attribute) == "string" then
        return Attribute
    end
    return nil
end

local function shouldApplyMapLighting() -- Line: 38
    -- upvalues: u20 (ref), ReplicatedStorage (val), u21 (ref), u23 (ref), u22 (ref)
    u20 = u20 or require(ReplicatedStorage.Controllers.MenuSceneController)
    u21 = u21 or require(ReplicatedStorage.Controllers.CaseSceneController)
    u23 = u23 or require(ReplicatedStorage.Controllers.InspectController)
    u22 = u22 or require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    return not u20.IsActive() and not u20.IsTeamSelectSceneActive() and not u21.IsActive() and not u22.IsActive() and not u23.IsActive()
end

local function handleMapLoaded(a1) -- Line: 54
    -- upvalues: shouldApplyMapLighting (val), u24 (ref), SceneLighting (val)
    if not shouldApplyMapLighting() then
        return
    end
    local Attribute = a1:GetAttribute("MapName")
    local v1 = if typeof(Attribute) ~= "string" then nil else Attribute
    if v1 then
        u24 = SceneLighting.RestoreMap(v1, u24)
        return
    end
    local u18 = nil
    local v2 = (a1:GetAttributeChangedSignal("MapName")):Connect(function() -- Line: 65
        -- upvalues: shouldApplyMapLighting (upval), u18 (ref), a1 (val), u24 (upval), SceneLighting (upval)
        if not shouldApplyMapLighting() then
            u18:Disconnect()
            return
        end
        local Attribute = a1:GetAttribute("MapName")
        local v1 = if typeof(Attribute) ~= "string" then nil else Attribute
        if v1 then
            u18:Disconnect()
            u24 = SceneLighting.RestoreMap(v1, u24)
        end
    end)
end

local function handleMapAttributeChanged() -- Line: 83
    -- upvalues: shouldApplyMapLighting (val), u24 (ref), SceneLighting (val)
    if not shouldApplyMapLighting() then
        return
    end
    local Attribute = workspace:GetAttribute("Map")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        u24 = SceneLighting.RestoreMap(Attribute, u24)
    end
end

DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 96 -- upvalues: SceneLighting (val), u24 (ref)
    SceneLighting.ApplyGlobalShadows(u24)
end)
workspace.ChildAdded:Connect(function(a1) -- Line: 100 -- upvalues: handleMapLoaded (val)
    if a1.Name == "Map" then
        task.defer(handleMapLoaded, a1)
    end
end)
;(workspace:GetAttributeChangedSignal("Map")):Connect(function() -- Line: 106 -- upvalues: handleMapAttributeChanged (val)
    task.defer(handleMapAttributeChanged)
end)
local Map = workspace:FindFirstChild("Map")
if Map then
    task.defer(handleMapLoaded, Map)
end
task.defer(handleMapAttributeChanged)
return nil