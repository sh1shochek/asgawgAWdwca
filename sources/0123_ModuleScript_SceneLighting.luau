-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local u1 = { "Ambient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "GlobalShadows", "OutdoorAmbient", "ShadowSoftness", "ClockTime", "GeographicLatitude", "ExposureCompensation" };
local u2 = {};
local u3 = {};

for _, v in u1 do
    u2[v] = Lighting[v];
end;

local function replaceAssets(p4: userdata?) -- Line: 29
    -- upvalues: Lighting (copy)
    for _, child in Lighting:GetChildren() do
        if child.Name ~= "Menu" then
            child:Destroy();
        end;
    end;

    if p4 then
        for _, child in p4:GetChildren() do
            child:Clone().Parent = Lighting;
        end;
    end;
end;

function u3.ApplyGlobalShadows(p5: boolean?) -- Line: 43
    -- upvalues: DataController (copy), Players (copy), Lighting (copy)
    if DataController.Get(Players.LocalPlayer, "Settings.Video.Presets.Global Shadows") == false then
        Lighting.GlobalShadows = false;

        return;
    end;

    if p5 ~= nil then
        Lighting.GlobalShadows = p5;
    end;
end;

function u3.RestoreMap(p6: string?, p7: boolean?) -- Line: 51
    -- upvalues: Maps (copy), u1 (copy), Lighting (copy), replaceAssets (copy), u3 (copy)
    if p6 == nil then
        p6 = workspace:GetAttribute("Map");

        if typeof(p6) ~= "string" then
            local Map = workspace:FindFirstChild("Map");

            if Map then
                p6 = Map:GetAttribute("MapName");
            else
                p6 = nil;
            end;
        end;
    end;

    if typeof(p6) ~= "string" then
        return p7;
    end;

    local v8 = Maps:FindFirstChild(p6);

    if not (v8 and v8:IsA("ModuleScript")) then
        return p7;
    end;

    local Lighting2 = require(v8).Lighting;

    if not Lighting2 then
        return p7;
    end;

    local Properties = Lighting2.Properties;

    if Properties then
        p7 = Properties.GlobalShadows;

        for _, v in u1 do
            Lighting[v] = Properties[v];
        end;
    end;

    replaceAssets(Lighting2.Assets);
    u3.ApplyGlobalShadows(p7);

    return p7;
end;

function u3.ApplyScene(p9: string, p10: userdata) -- Line: 84
    -- upvalues: Maps (copy), u2 (copy), u1 (copy), Lighting (copy), replaceAssets (copy), u3 (copy)
    local v11 = Maps:FindFirstChild(p9);
    local v12;

    if v11 and v11:IsA("ModuleScript") then
        v12 = require(v11).Lighting;
    else
        v12 = nil;
    end;

    local v13;

    if v12 and v12.Properties then
        v13 = v12.Properties;
    else
        v13 = u2;
    end;

    for _, v in u1 do
        Lighting[v] = v13[v];
    end;

    replaceAssets(p10);
    u3.ApplyGlobalShadows(v13.GlobalShadows);

    return v13.GlobalShadows;
end;

return u3;