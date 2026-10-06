-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Signal = require(ReplicatedStorage.Packages.Signal);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local table_freeze_ret = table.freeze({ "Counter-Terrorists", "Terrorists" });
local table_freeze_ret2 = table.freeze({ "Vanilla", "Stock" });
u1.Changed = Signal.new();
local u2 = {};
local u3 = {};

local function GetPlainIcon(p4: string) -- Line: 47
    -- upvalues: u2 (copy), GetWeaponProperties (copy)
    local v5 = u2[p4];

    if v5 then
        return v5;
    end;

    local success, result = pcall(GetWeaponProperties, p4);
    local v6 = (not success or typeof(result) ~= "table") and "" or tostring(result.Icon or (result.ReverseIcon or ""));

    if v6 ~= "" then
        u2[p4] = v6;
    end;

    return v6;
end;

local function GetStockIcon(p7: string) -- Line: 69
    -- upvalues: u3 (copy), Skins (copy), table_freeze_ret2 (copy)
    local v8 = u3[p7];

    if v8 then
        return v8;
    end;

    local AllSkinsForWeapon = Skins.GetAllSkinsForWeapon(p7);

    if not AllSkinsForWeapon then
        return "";
    end;

    for _, v in ipairs(table_freeze_ret2) do
        local v9 = v;

        for _, v2 in ipairs(AllSkinsForWeapon) do
            if v2.skin == v9 then
                local v10 = Skins.GetWearImageForFloat(v2, 0) or (v2.imageAssetId or "");

                if v10 ~= "" then
                    u3[p7] = v10;

                    return v10;
                end;
            end;
        end;
    end;

    return "";
end;

local function CollectEquippedIdentifiers(p11: any, p12: string?) -- Line: 100
    -- upvalues: table_freeze_ret (copy)
    local u13 = {};

    if typeof(p11) ~= "table" then
        return u13;
    end;

    local function collect(p14: any, p15: number) -- Line: 106
        -- upvalues: u13 (copy), collect (copy)
        if typeof(p14) ~= "table" or p15 > 6 then
            return;
        end;

        for _, v in pairs(p14) do
            if typeof(v) == "string" then
                u13[v] = true;
            elseif typeof(v) == "table" then
                collect(v, p15 + 1);
            end;
        end;
    end;

    if p12 then
        collect(p11[p12], 0);

        return u13;
    end;

    for _, v in ipairs(table_freeze_ret) do
        collect(p11[v], 0);
    end;

    return u13;
end;

local function GetSkinIcon(p16) -- Line: 132
    -- upvalues: GetResolvedSkinInformation (copy), Skins (copy)
    if typeof(p16) ~= "table" or (typeof(p16.Skin) ~= "string" or p16.Skin == "") then
        return "";
    end;

    local v17 = GetResolvedSkinInformation(p16.Name, p16.Skin);

    if not v17 then
        return "";
    end;

    local v18 = typeof(p16.Float) ~= "number" and 0.9999 or p16.Float;

    return Skins.GetWearImageForFloat(v17, v18) or v17.imageAssetId or "";
end;

function u1.Get(p19: string, p20: string?) -- Line: 150
    -- upvalues: DataController (copy), LocalPlayer (copy), CollectEquippedIdentifiers (copy), GetSkinIcon (copy), GetStockIcon (copy), u2 (copy), GetWeaponProperties (copy)
    if p19 == nil or p19 == "" then
        return "";
    end;

    local v21, v22 = DataController.Get(LocalPlayer, "Inventory", "Loadout");

    if typeof(v21) == "table" and typeof(v22) == "table" then
        local v23 = CollectEquippedIdentifiers(v22, p20);

        for _, v in ipairs(v21) do
            if typeof(v) == "table" and (v.Name == p19 and v23[v._id]) then
                local v24 = GetSkinIcon(v);

                if v24 ~= "" then
                    return v24;
                end;
            end;
        end;
    end;

    local v25 = GetStockIcon(p19);

    if v25 ~= "" then
        return v25;
    end;

    local v26 = u2[p19];

    if v26 then
        return v26;
    end;

    local success, result = pcall(GetWeaponProperties, p19);
    local v27 = (not success or typeof(result) ~= "table") and "" or tostring(result.Icon or (result.ReverseIcon or ""));

    if v27 ~= "" then
        u2[p19] = v27;
    end;

    return v27;
end;

local u28 = false;
Skins.ObserveItemStockSchemas(function() -- Line: 185
    -- upvalues: u3 (copy), u28 (ref), u1 (copy)
    table.clear(u3);

    if u28 then
        u1.Changed:Fire();
    end;
end);
u28 = true;

return u1;