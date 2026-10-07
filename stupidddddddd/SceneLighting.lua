-- ReplicatedStorage.Components.Common.SceneLighting
-- Script path: ReplicatedStorage.Components.Common.SceneLighting
-- Decompile time: 1.78 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local u23 = {}
local u24 = {
    "Ambient",
    "Brightness",
    "ColorShift_Bottom",
    "ColorShift_Top",
    "EnvironmentDiffuseScale",
    "EnvironmentSpecularScale",
    "GlobalShadows",
    "OutdoorAmbient",
    "ShadowSoftness",
    "ClockTime",
    "GeographicLatitude",
    "ExposureCompensation",
}
local u37 = {}
for i, j in u24 do
    u37[j] = Lighting[j]
end

local function replaceAssets(a1) -- Line: 29 -- upvalues: Lighting (val) -- types: a1: userdata?
    for i, j in Lighting:GetChildren() do
        if j.Name ~= "Menu" then
            j:Destroy()
        end
    end
    if a1 then
        local v1
        for k, n in a1:GetChildren() do
            v1 = n:Clone()
            v1.Parent = Lighting
        end
    end
end

function u23.ApplyGlobalShadows(a1) -- Line: 43
    -- upvalues: DataController (val), Players (val), Lighting (val)
    if DataController.Get(Players.LocalPlayer, "Settings.Video.Presets.Global Shadows") == false then
        Lighting.GlobalShadows = false
        return
    end
    if a1 ~= nil then
        Lighting.GlobalShadows = a1
    end
end

function u23.RestoreMap(a1, a2) -- Line: 51
    -- upvalues: Maps (val), u24 (val), Lighting (val), replaceAssets (val), u23 (val)
    if a1 == nil then
        a1 = workspace:GetAttribute("Map")
        if typeof(a1) ~= "string" then
            local Map = workspace:FindFirstChild("Map")
            a1 = if not Map then nil else Map:GetAttribute("MapName")
        end
    end
    if typeof(a1) ~= "string" then
        return a2
    end
    local v1 = Maps:FindFirstChild(a1)
    if v1 and v1:IsA("ModuleScript") then
        local GlobalShadows
        local Lighting_2 = require(v1).Lighting
        if not Lighting_2 then
            return a2
        end
        local Properties = Lighting_2.Properties
        if not Properties then
            GlobalShadows = a2
        else
            GlobalShadows = Properties.GlobalShadows
            for i, j in u24 do
                Lighting[j] = Properties[j]
            end
        end
        replaceAssets(Lighting_2.Assets)
        u23.ApplyGlobalShadows(GlobalShadows)
        return GlobalShadows
    end
    return a2
end

function u23.ApplyScene(a1, a2) -- Line: 84
    -- upvalues: Maps (val), u37 (val), u24 (val), Lighting (val), replaceAssets (val), u23 (val)
    local v1 = Maps:FindFirstChild(a1)
    local Lighting_2 = if not v1 then nil else if not v1:IsA("ModuleScript") then nil else require(v1).Lighting
    local Properties = if not Lighting_2 then u37 else if not Lighting_2.Properties then u37 else Lighting_2.Properties
    for i, j in u24 do
        Lighting[j] = Properties[j]
    end
    replaceAssets(a2)
    u23.ApplyGlobalShadows(Properties.GlobalShadows)
    return Properties.GlobalShadows
end

return u23