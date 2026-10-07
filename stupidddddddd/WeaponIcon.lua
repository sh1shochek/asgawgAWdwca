-- ReplicatedStorage.Interface.Screens.Menu.Career.WeaponIcon
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.WeaponIcon
-- Decompile time: 3.98 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = (game:GetService("Players")).LocalPlayer
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Signal = require(ReplicatedStorage.Packages.Signal)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local u40 = table.freeze({"Counter-Terrorists", "Terrorists"})
local u45 = table.freeze({"Vanilla", "Stock"})
u0.Changed = Signal.new()
local u48 = {}
local u49 = {}

local function GetPlainIcon(a1) -- Line: 47 -- upvalues: u48 (val), GetWeaponProperties (val) -- types: a1: string
    local v1 = u48[a1]
    if v1 then
        return v1
    end
    local success, result = pcall(GetWeaponProperties, a1)
    local v2 = ""
    if success and typeof(result) == "table" then
        v2 = tostring(result.Icon or result.ReverseIcon or "")
    end
    if v2 ~= "" then
        u48[a1] = v2
    end
    return v2
end

local function GetStockIcon(a1) -- Line: 69 -- upvalues: u49 (val), Skins (val), u45 (val) -- types: a1: string
    local imageAssetId
    local v1 = u49[a1]
    if v1 then
        return v1
    end
    local v2 = Skins.GetAllSkinsForWeapon(a1)
    if not v2 then
        return ""
    end
    for i, v in ipairs(u45) do
        for i2, i3 in ipairs(v2) do
            if i3.skin == v then
                imageAssetId = Skins.GetWearImageForFloat(i3, 0) or i3.imageAssetId or ""
                if imageAssetId ~= "" then
                    u49[a1] = imageAssetId
                    return imageAssetId
                end
            end
        end
    end
    return ""
end

local function CollectEquippedIdentifiers(a1, a2) -- Line: 100 -- upvalues: u40 (val) -- types: a2: string?
    local collect
    local u2 = {}
    if typeof(a1) ~= "table" then
        return u2
    end

    function collect(a1, a2) -- Line: 106 -- upvalues: u2 (val), collect (val) -- types: a2: number
        if typeof(a1) == "table" and not (a2 > 6) then
            for k, v in pairs(a1) do
                if typeof(v) == "string" then
                    u2[v] = true
                elseif typeof(v) == "table" then
                    collect(v, a2 + 1)
                end
            end
            return
        end
    end

    if a2 then
        collect(a1[a2], 0)
        return u2
    end
    for i, v in ipairs(u40) do
        collect(a1[v], 0)
    end
    return u2
end

local function GetSkinIcon(a1) -- Line: 132 -- upvalues: GetResolvedSkinInformation (val), Skins (val)
    if typeof(a1) == "table" and typeof(a1.Skin) == "string" and a1.Skin ~= "" then
        local v1 = GetResolvedSkinInformation(a1.Name, a1.Skin)
        if not v1 then
            return ""
        end
        return Skins.GetWearImageForFloat(v1, if typeof(a1.Float) ~= "number" then 0.9999 else a1.Float) or v1.imageAssetId or ""
    end
    return ""
end

function u0.Get(a1, a2) -- Line: 150
    -- upvalues: DataController (val), LocalPlayer (val), CollectEquippedIdentifiers (val), GetSkinIcon (val)
    -- upvalues: GetStockIcon (val), u48 (val), GetWeaponProperties (val)
    if a1 ~= nil and a1 ~= "" then
        local v1
        local v2, v3 = DataController.Get(LocalPlayer, "Inventory", "Loadout")
        if typeof(v2) == "table" and typeof(v3) == "table" then
            local v4
            v1 = CollectEquippedIdentifiers(v3, a2)
            for i, v in ipairs(v2) do
                if typeof(v) == "table" and v.Name == a1 and v1[v._id] then
                    v4 = GetSkinIcon(v)
                    if v4 ~= "" then
                        return v4
                    end
                end
            end
        end
        v1 = GetStockIcon(a1)
        if v1 ~= "" then
            return v1
        end
        local v5 = u48[a1]
        if v5 then
            return v5
        end
        local success, result = pcall(GetWeaponProperties, a1)
        local v6 = ""
        if success and typeof(result) == "table" then
            v6 = tostring(result.Icon or result.ReverseIcon or "")
        end
        if v6 ~= "" then
            u48[a1] = v6
        end
        return v6
    end
    return ""
end

local u55 = false
Skins.ObserveItemStockSchemas(function() -- Line: 185 -- upvalues: u49 (val), u55 (ref), u0 (val)
    table.clear(u49)
    if u55 then
        u0.Changed:Fire()
    end
end)
return u0