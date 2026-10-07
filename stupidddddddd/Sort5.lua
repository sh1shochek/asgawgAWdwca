-- ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort
-- Script path: ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort
-- Decompile time: 10.10 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons)
local u34 = {
    Forbidden = 7,
    Special = 6,
    Red = 5,
    Pink = 4,
    Purple = 3,
    Blue = 2,
    Stock = 1,
}
local u35 = {
    ["Sticker Capsule"] = 14,
    ["Charm Capsule"] = 13,
    ["Music Kit"] = 8,
    Graffiti = 11,
    Grenade = 16,
    Sticker = 10,
    ["Zeus x27"] = 3,
    Charm = 9,
    Melee = 1,
    Glove = 2,
    Badge = 7,
    Case = 12,
    C4 = 15,
}
local u49 = {
    Melee = 1,
    Glove = 2,
    Case = 3,
    ["Charm Capsule"] = 4,
    ["Sticker Capsule"] = 4,
}
local u55 = {
    Miscellaneous = 18,
    Equipment = 17,
    Pistol = 3,
    Rifle = 6,
    Heavy = 5,
    SMG = 4,
}
local u62 = {Pistols = 1, ["Mid Tier"] = 2, Rifles = 3}
local u66 = {
    ["Equipped Melee"] = 1,
    ["Equipped Gloves"] = 2,
    ["Equipped Badge"] = 3,
    ["Equipped Music Kit"] = 4,
    ["Equipped Graffiti"] = 5,
    ["Equipped Zeus x27"] = 6,
}

local function IsStockSkin(a1) -- Line: 98 -- types: a1: table
    local v1 = true
    if a1.Skin ~= "Stock" then
        if not a1.MetaData then
            v1 = false
        else
            v1 = true
            if a1.MetaData.Origin ~= "Stock" then
                v1 = false
            end
        end
    end
    return v1
end

local function IsBadge(a1) -- Line: 102 -- types: a1: table
    return a1.Name == "Badge"
end

local function IsCharm(a1) -- Line: 106 -- types: a1: table
    return a1.Name == "Charm"
end

local function GetItemIdentity(a1) -- Line: 110 -- types: a1: table
    if a1.Type == "Case" then
        return a1.Skin or ""
    end
    return (a1.Name or "") .. "|" .. (a1.Skin or "")
end

local function GetCollectionNameForItem(a1, a2) -- Line: 119
    -- upvalues: Buttons (val), Cases (val), Skins (val)
    local v1
    if Buttons.IsCapsule(a1) then
        return "Capsules"
    end
    if a1.Type ~= "Case" then
        if a1.Name and a1.Skin then
            v1 = Skins.GetSkinInformation(a1.Name, a1.Skin)
            return v1 and v1.collection or nil
        end
        return nil
    end
    if not a1.Skin then
        return nil
    end
    v1 = Cases.GetCaseByName(a1.Skin)
    if not v1 then
        return nil
    end
    local v2 = a2 and a2()
    if not v2 then
        return nil
    end
    for i, v in ipairs(v2) do
        if v.cases then
            for i2, i3 in ipairs(v.cases) do
                if i3 == v1.name then
                    return v.name
                end
            end
        end
    end
    return nil
end

local function BuildEquippedPriorityMap(a1) -- Line: 165
    -- upvalues: DataController (val), u62 (val), u66 (val)
    local v1, v2, v3, v4, v5
    local u109 = {}

    local function record(a1, a2) -- Line: 167 -- upvalues: u109 (val) -- types: a2: number
        local v1 = u109[a1]
        if not v1 or a2 < v1 then
            u109[a1] = a2
        end
    end

    local v6 = DataController.Get(a1, "Loadout")
    if not v6 then
        return u109
    end
    for i, v in ipairs({"Counter-Terrorists", "Terrorists"}) do
        v5 = v6[v]
        if v5 and v5.Loadout then
            for k, i2 in pairs(u62) do
                if i2 and v5.Loadout[k] and v5.Loadout[k].Options then
                    for i3, j in ipairs(v5.Loadout[k].Options) do
                        v3 = i2 * 1000 + i3
                        v4 = u109[j]
                        if not v4 or v3 < v4 then
                            u109[j] = v3
                        end
                    end
                end
            end
            if v5.Equipped then
                for k2, k3 in pairs(v5.Equipped) do
                    v1 = u66[k2] or 99
                    v2 = u109[k3]
                    if not v2 or v1 < v2 then
                        u109[k3] = v1
                    end
                end
            end
        end
    end
    return u109
end

local function MemoizePerItem(a1) -- Line: 204 -- types: a1: function
    local u1 = {}
    return function(a1_2) -- Line: 206 -- upvalues: u1 (val), a1 (val) -- types: a1_2: table
        local v1 = u1[a1_2]
        if v1 == nil then
            u1[a1_2] = (a1(a1_2))
        end
        return v1
    end
end

local function GetMetaDataNumber(a1, a2) -- Line: 217 -- types: a1: table, a2: string
    local MetaData = a1.MetaData
    return MetaData and tonumber(MetaData[a2]) or 0
end

local function GetCreatedAt(a1) -- Line: 222 -- types: a1: table
    local MetaData = a1.MetaData
    return MetaData and tonumber(MetaData.CreatedAt) or 0
end

local function GetSerial(a1) -- Line: 228 -- types: a1: table
    local v1 = tonumber(a1.Serial)
    if v1 ~= nil and not (v1 <= 0) then
        return v1
    end
    return nil
end

local function GetNewestSortTimestamp(a1) -- Line: 238 -- types: a1: table
    local MetaData = a1.MetaData
    local v1 = MetaData and tonumber(MetaData.LastTradeAt) or 0
    local MetaData_2 = a1.MetaData
    local v2 = MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0
    return v1 > 0 and v1 or v2
end

local function GetRarityRank(a1) -- Line: 247 -- upvalues: Skins (val), u34 (val) -- types: a1: table
    local v1 = a1.Name and a1.Skin and Skins.GetSkinInformation(a1.Name, a1.Skin) or nil
    return v1 and u34[v1.rarity] or 0
end

local function GetTypeSortPriority(a1) -- Line: 254
    -- upvalues: Buttons (val), u35 (val), GetWeaponProperties (val), u55 (val)
    local v1 = Buttons.GetEffectiveItemType(a1)
    local v2 = u35[v1]
    if v2 then
        return v2
    end
    if v1 == "Weapon" and a1.Name then
        local success, result = pcall(GetWeaponProperties, a1.Name)
        if success and result and result.Type then
            return u55[result.Type] or 99
        end
    end
    return 99
end

local function StockLast(a1) -- Line: 276 -- types: a1: function
    return function(a1_2, a2) -- Line: 277 -- upvalues: a1 (val)
        local v1 = true
        if a1_2.Skin ~= "Stock" then
            if not a1_2.MetaData then
                v1 = false
            else
                v1 = true
                if a1_2.MetaData.Origin ~= "Stock" then
                    v1 = false
                end
            end
        end
        local v2 = true
        if a2.Skin ~= "Stock" then
            if not a2.MetaData then
                v2 = false
            else
                v2 = true
                if a2.MetaData.Origin ~= "Stock" then
                    v2 = false
                end
            end
        end
        if v1 ~= v2 then
            return v2, true
        end
        return a1(a1_2, a2)
    end
end

return {
    GetSortComparisonFunction = function(a1, a2, a3) -- Line: 291
        -- upvalues: GetItemIdentity (val), GetRarityRank (val), GetCollectionNameForItem (val), u49 (val)
        -- upvalues: Buttons (val), BuildEquippedPriorityMap (val), GetTypeSortPriority (val)
        local u3 = GetItemIdentity
        local u4 = {}

        local function u5(a1) -- Line: 206 -- upvalues: u4 (val), u3 (val) -- types: a1: table
            local v1 = u4[a1]
            if v1 == nil then
                u4[a1] = (u3(a1))
            end
            return v1
        end

        local u6 = GetRarityRank
        local u7 = {}

        local function u8(a1) -- Line: 206 -- upvalues: u7 (val), u6 (val) -- types: a1: table
            local v1 = u7[a1]
            if v1 == nil then
                u7[a1] = (u6(a1))
            end
            return v1
        end

        local function CompareIdentityThenNewest(a1, a2) -- Line: 301
            -- upvalues: u5 (val)
            local v1 = u5(a1)
            local v2 = u5(a2)
            if v1 ~= v2 then
                return v1 < v2
            end
            local MetaData = a1.MetaData
            local v3 = MetaData and tonumber(MetaData.CreatedAt) or 0
            local MetaData_2 = a2.MetaData
            return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v3
        end

        if a1 == "Alphabetical" then
            local function u10(a1, a2) -- Line: 311 -- upvalues: u5 (val)
                local v1 = u5(a1)
                local v2 = u5(a2)
                if v1 ~= v2 then
                    return v1 < v2
                end
                local MetaData = a1.MetaData
                local v3 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                local v4 = MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0
                if v3 ~= v4 then
                    return v4 < v3
                end
                return (a1._id or "") < (a2._id or "")
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u10 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u10(a1, a2)
            end
        end
        if a1 == "Collection" then
            local function u12(a1) -- Line: 329
                -- upvalues: GetCollectionNameForItem (upval), a3 (val)
                return GetCollectionNameForItem(a1, a3) or ""
            end

            local u13 = {}

            local function u14(a1) -- Line: 206 -- upvalues: u13 (val), u12 (val) -- types: a1: table
                local v1 = u13[a1]
                if v1 == nil then
                    u13[a1] = (u12(a1))
                end
                return v1
            end

            local function u15(a1) -- Line: 332 -- upvalues: u49 (upval), Buttons (upval) -- types: a1: table
                return u49[Buttons.GetEffectiveItemType(a1)] or 4
            end

            local u16 = {}

            local function u17(a1) -- Line: 206 -- upvalues: u16 (val), u15 (val) -- types: a1: table
                local v1 = u16[a1]
                if v1 == nil then
                    u16[a1] = (u15(a1))
                end
                return v1
            end

            local function u18(a1, a2) -- Line: 335 -- upvalues: u14 (val), u17 (val), u8 (val), u5 (val)
                local v1 = u14(a1)
                local v2 = u14(a2)
                if v1 ~= v2 then
                    return v1 < v2
                end
                local v3 = u17(a1)
                local v4 = u17(a2)
                if v3 ~= v4 then
                    return v3 < v4
                end
                local v5 = u8(a1)
                local v6 = u8(a2)
                if v5 ~= v6 then
                    return v6 < v5
                end
                local v7 = u5(a1)
                local v8 = u5(a2)
                if v7 ~= v8 then
                    return v7 < v8
                end
                local MetaData = a1.MetaData
                local v9 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v9
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u18 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u18(a1, a2)
            end
        end
        if a1 == "Equipped" then
            local u22 = BuildEquippedPriorityMap(a2)

            local function u23(a1, a2) -- Line: 358 -- upvalues: u22 (val), u5 (val)
                local v1 = a1._id and u22[a1._id] or nil
                local v2 = a2._id and u22[a2._id] or nil
                if v1 ~= nil ~= (v2 ~= nil) then
                    return v1 ~= nil
                end
                if v1 and v2 and v1 ~= v2 then
                    return v1 < v2
                end
                local v3 = u5(a1)
                local v4 = u5(a2)
                if v3 ~= v4 then
                    return v3 < v4
                end
                local MetaData = a1.MetaData
                local v5 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v5
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u23 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u23(a1, a2)
            end
        end
        if a1 == "Newest" then
            local function u25(a1, a2) -- Line: 372 -- upvalues: u5 (val)
                local MetaData = a1.MetaData
                local v1 = MetaData and tonumber(MetaData.LastTradeAt) or 0
                local MetaData_2 = a1.MetaData
                local v2 = MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0
                local v3 = v1 > 0 and v1 or v2
                local MetaData_3 = a2.MetaData
                v2 = MetaData_3 and tonumber(MetaData_3.LastTradeAt) or 0
                local MetaData_4 = a2.MetaData
                local v4 = MetaData_4 and tonumber(MetaData_4.CreatedAt) or 0
                v1 = v2 > 0 and v2 or v4
                if v3 ~= v1 then
                    return v1 < v3
                end
                v2 = u5(a1)
                v4 = u5(a2)
                if v2 ~= v4 then
                    return v2 < v4
                end
                return (a1._id or "") < (a2._id or "")
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u25 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u25(a1, a2)
            end
        end
        if a1 == "Quality" then
            local function u27(a1, a2) -- Line: 387 -- upvalues: u8 (val), u5 (val)
                local v1 = u8(a1)
                local v2 = u8(a2)
                if v1 ~= v2 then
                    return v2 < v1
                end
                local v3 = u5(a1)
                local v4 = u5(a2)
                if v3 ~= v4 then
                    return v3 < v4
                end
                local MetaData = a1.MetaData
                local v5 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v5
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u27 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u27(a1, a2)
            end
        end
        if a1 == "Type" then
            local u29 = GetTypeSortPriority
            local u30 = {}

            local function u31(a1) -- Line: 206 -- upvalues: u30 (val), u29 (val) -- types: a1: table
                local v1 = u30[a1]
                if v1 == nil then
                    u30[a1] = (u29(a1))
                end
                return v1
            end

            local function u32(a1, a2) -- Line: 397 -- upvalues: u31 (val), u5 (val)
                local v1 = u31(a1)
                local v2 = u31(a2)
                if v1 ~= v2 then
                    return v1 < v2
                end
                local v3 = u5(a1)
                local v4 = u5(a2)
                if v3 ~= v4 then
                    return v3 < v4
                end
                local MetaData = a1.MetaData
                local v5 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v5
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u32 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u32(a1, a2)
            end
        end
        if a1 == "Float" then
            local function u34(a1, a2) -- Line: 406 -- upvalues: u5 (val)
                local v1 = a1.Name == "Badge"
                local v2 = a2.Name == "Badge"
                if v1 ~= v2 then
                    return v2, true
                end
                local v3 = a1.Name == "Charm"
                local v4 = a2.Name == "Charm"
                if v3 ~= v4 then
                    return v4, true
                end
                local Float = a1.Float
                local Float_2 = a2.Float
                if Float ~= nil and Float_2 ~= nil and Float ~= Float_2 then
                    return Float < Float_2
                end
                if Float ~= nil and Float_2 == nil then
                    return true
                end
                if Float == nil and Float_2 ~= nil then
                    return false
                end
                local v5 = u5(a1)
                local v6 = u5(a2)
                if v5 ~= v6 then
                    return v5 < v6
                end
                local MetaData = a1.MetaData
                local v7 = MetaData and tonumber(MetaData.CreatedAt) or 0
                local MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v7
            end

            return function(a1, a2) -- Line: 277 -- upvalues: u34 (val)
                local v1 = true
                if a1.Skin ~= "Stock" then
                    if not a1.MetaData then
                        v1 = false
                    else
                        v1 = true
                        if a1.MetaData.Origin ~= "Stock" then
                            v1 = false
                        end
                    end
                end
                local v2 = true
                if a2.Skin ~= "Stock" then
                    if not a2.MetaData then
                        v2 = false
                    else
                        v2 = true
                        if a2.MetaData.Origin ~= "Stock" then
                            v2 = false
                        end
                    end
                end
                if v1 ~= v2 then
                    return v2, true
                end
                return u34(a1, a2)
            end
        end
        if a1 ~= "Serial" then
            return nil
        end

        local function u36(a1, a2) -- Line: 432 -- upvalues: u5 (val)
            local MetaData, MetaData_2, v1, v2, v3
            local v4 = tonumber(a1.Serial)
            local v5 = if v4 == nil then nil else if not (v4 <= 0) then v4 else nil
            local v6 = tonumber(a2.Serial)
            v4 = if v6 == nil then nil else if not (v6 <= 0) then v6 else nil
            if v5 ~= nil and v4 ~= nil then
                if v5 ~= v4 then
                    return v5 < v4
                end
                v1 = u5(a1)
                v2 = u5(a2)
                if v1 ~= v2 then
                    return v1 < v2
                end
                MetaData = a1.MetaData
                v3 = MetaData and tonumber(MetaData.CreatedAt) or 0
                MetaData_2 = a2.MetaData
                return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v3
            end
            if v5 ~= nil then
                return true, true
            end
            if v4 ~= nil then
                return false, true
            end
            v1 = u5(a1)
            v2 = u5(a2)
            if v1 ~= v2 then
                return v1 < v2
            end
            MetaData = a1.MetaData
            v3 = MetaData and tonumber(MetaData.CreatedAt) or 0
            MetaData_2 = a2.MetaData
            return (MetaData_2 and tonumber(MetaData_2.CreatedAt) or 0) < v3
        end

        return function(a1, a2) -- Line: 277 -- upvalues: u36 (val)
            local v1 = true
            if a1.Skin ~= "Stock" then
                if not a1.MetaData then
                    v1 = false
                else
                    v1 = true
                    if a1.MetaData.Origin ~= "Stock" then
                        v1 = false
                    end
                end
            end
            local v2 = true
            if a2.Skin ~= "Stock" then
                if not a2.MetaData then
                    v2 = false
                else
                    v2 = true
                    if a2.MetaData.Origin ~= "Stock" then
                        v2 = false
                    end
                end
            end
            if v1 ~= v2 then
                return v2, true
            end
            return u36(a1, a2)
        end
    end,
}