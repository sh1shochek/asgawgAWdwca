-- ReplicatedStorage.Database.Components.Libraries.Stock
-- Script path: ReplicatedStorage.Database.Components.Libraries.Stock
-- Decompile time: 1.48 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local u11 = {
    "USP-S",
    "Glock-18",
    "P250",
    "Desert Eagle",
    "Tec-9",
    "CZ75-Auto",
    "Five-SeveN",
    "Dual Berettas",
    "R8 Revolver",
    "MAC-10",
    "MP9",
    "MP7",
    "MP5-SD",
    "UMP-45",
    "P90",
    "PP-Bizon",
    "AK-47",
    "M4A1-S",
    "M4A4",
    "AUG",
    "SG 553",
    "FAMAS",
    "Galil AR",
    "AWP",
    "SSG 08",
    "SCAR-20",
    "G3SG1",
    "XM1014",
    "Nova",
    "MAG-7",
    "Sawed-Off",
    "Negev",
    "M249",
    "CT Knife",
    "T Knife",
    "CT Glove",
    "T Glove",
    "Molotov",
    "Incendiary Grenade",
    "HE Grenade",
    "Flashbang",
    "Smoke Grenade",
    "Decoy Grenade",
    "C4",
    "Zeus x27",
}
local u57 = {
    Weapon = true,
    Melee = true,
    Glove = true,
    Grenade = true,
    C4 = true,
}

local function GetInventoryItemType(a1) -- Line: 84 -- upvalues: ReplicatedStorage (val), u57 (val) -- types: a1: string
    if a1 ~= "Zeus x27" and a1 ~= "C4" then
        local v1 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1)
        if not v1 then
            return "Weapon"
        end
        local Class = require(v1).Class
        if u57[Class] then
            return Class
        end
        return "Weapon"
    end
    return a1
end

local function CreateStockItem(a1) -- Line: 101 -- upvalues: ReplicatedStorage (val), u57 (val) -- types: a1: string
    local v1
    local v2 = {
        Serial = 0,
        Skin = "Stock",
        Float = 0,
        StatTrack = false,
        IsTradeable = false,
        NameTag = false,
        Charm = false,
        _id = a1 .. "_Stock",
    }
    if a1 == "Zeus x27" then
        v1 = a1
    elseif a1 ~= "C4" then
        local v3 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1)
        if v3 then
            local Class = require(v3).Class
            v1 = if not u57[Class] then "Weapon" else Class
        else
            v1 = "Weapon"
        end
    else
        v1 = a1
    end
    v2.Type = v1
    v2.Name = a1
    v2.Stickers = {}
    v2.MetaData = {
        LastTradeAt = 0,
        CreatedAt = 0,
        OriginalOwner = 0,
        Owner = 0,
        Origin = "Stock",
        TradeHistory = {},
    }
    return v2
end

function u0.IsStockIdentifier(a1) -- Line: 128 -- types: a1: string
    return string.sub(a1, -6) == "_Stock"
end

function u0.GetWeaponNameFromStockId(a1) -- Line: 134 -- upvalues: u0 (val) -- types: a1: string
    if not u0.IsStockIdentifier(a1) then
        return nil
    end
    return (string.sub(a1, 1, -7))
end

function u0.GetStockInventoryItem(a1) -- Line: 143 -- upvalues: u11 (val), CreateStockItem (val) -- types: a1: string
    if not table.find(u11, a1) then
        return nil
    end
    return (CreateStockItem(a1))
end

function u0.GenerateStockInventoryItems() -- Line: 153 -- upvalues: u11 (val), CreateStockItem (val)
    local v1 = {}
    for i, v in ipairs(u11) do
        table.insert(v1, (CreateStockItem(v)))
    end
    return v1
end

function u0.InjectStockItems(a1) -- Line: 165 -- upvalues: u0 (val) -- types: a1: table
    local v1 = u0.GenerateStockInventoryItems()
    local v2 = {}
    local v3 = {}
    for i, v in ipairs(a1) do
        v2[v._id] = true
        if v.Skin == "Stock" then
            v3[v.Name] = true
        end
    end
    for i2, i3 in ipairs(v1) do
        if not v2[i3._id] and not v3[i3.Name] then
            table.insert(a1, i3)
        end
    end
    return a1
end

return u0