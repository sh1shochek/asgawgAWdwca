-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting);
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function applyMapLighting(p6: string) -- Line: 25
    -- upvalues: u5 (ref), SceneLighting (copy)
    u5 = SceneLighting.RestoreMap(p6, u5);
end;

local function getMapNameFromInstance(p7: userdata) -- Line: 31
    local Attribute = p7:GetAttribute("MapName");

    if typeof(Attribute) == "string" then
        return Attribute;
    end;

    return nil;
end;

local function shouldApplyMapLighting() -- Line: 38
    -- upvalues: u1 (ref), ReplicatedStorage (copy), u2 (ref), u4 (ref), u3 (ref)
    u1 = u1 or require(ReplicatedStorage.Controllers.MenuSceneController);
    u2 = u2 or require(ReplicatedStorage.Controllers.CaseSceneController);
    u4 = u4 or require(ReplicatedStorage.Controllers.InspectController);
    u3 = u3 or require(ReplicatedStorage.Controllers.BlackMarketSceneController);
    local v8 = not (u1.IsActive() or u1.IsTeamSelectSceneActive() or (u2.IsActive() or u3.IsActive())) and not u4.IsActive();

    return v8;
end;

local function handleMapLoaded(u9: userdata) -- Line: 54
    -- upvalues: shouldApplyMapLighting (copy), u5 (ref), SceneLighting (copy)
    if not shouldApplyMapLighting() then
        return;
    end;

    local Attribute = u9:GetAttribute("MapName");

    if typeof(Attribute) ~= "string" then
        Attribute = nil;
    end;

    if Attribute then
        u5 = SceneLighting.RestoreMap(Attribute, u5);

        return;
    end;

    local u10 = nil;
    u10 = u9:GetAttributeChangedSignal("MapName"):Connect(function() -- Line: 65
        -- upvalues: shouldApplyMapLighting (ref), u10 (ref), u9 (copy), u5 (ref), SceneLighting (ref)
        if not shouldApplyMapLighting() then
            u10:Disconnect();

            return;
        end;

        local Attribute2 = u9:GetAttribute("MapName");

        if typeof(Attribute2) ~= "string" then
            Attribute2 = nil;
        end;

        if Attribute2 then
            u10:Disconnect();
            u5 = SceneLighting.RestoreMap(Attribute2, u5);
        end;
    end);
end;

local function handleMapAttributeChanged() -- Line: 83
    -- upvalues: shouldApplyMapLighting (copy), u5 (ref), SceneLighting (copy)
    if not shouldApplyMapLighting() then
        return;
    end;

    local Attribute = workspace:GetAttribute("Map");

    if typeof(Attribute) == "string" and Attribute ~= "" then
        u5 = SceneLighting.RestoreMap(Attribute, u5);
    end;
end;

DataController.CreateListener(Players.LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 96
    -- upvalues: SceneLighting (copy), u5 (ref)
    SceneLighting.ApplyGlobalShadows(u5);
end);
workspace.ChildAdded:Connect(function(p11) -- Line: 100
    -- upvalues: handleMapLoaded (copy)
    if p11.Name == "Map" then
        task.defer(handleMapLoaded, p11);
    end;
end);
workspace:GetAttributeChangedSignal("Map"):Connect(function() -- Line: 106
    -- upvalues: handleMapAttributeChanged (copy)
    task.defer(handleMapAttributeChanged);
end);
local Map = workspace:FindFirstChild("Map");

if Map then
    task.defer(handleMapLoaded, Map);
end;

task.defer(handleMapAttributeChanged);

return nil;