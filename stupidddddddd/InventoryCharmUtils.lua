-- ReplicatedStorage.Shared.InventoryCharmUtils
-- Script path: ReplicatedStorage.Shared.InventoryCharmUtils
-- Decompile time: 1.87 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local u10 = {}

function u10.IsCharmItem(a1) -- Line: 14
    local v1 = true
    if a1.Type ~= "Charm" then
        v1 = a1.Name == "Charm"
    end
    return v1
end

local function getCharmReference(a1) -- Line: 18
    local Charm = a1.Charm
    if typeof(Charm) == "table" then
        return Charm
    end
    return nil
end

local function getEquippedCharmId(a1) -- Line: 23
    local Charm = a1.Charm
    local v1 = if typeof(Charm) ~= "table" then nil else Charm
    if v1 then
        return v1._id
    end
    return nil
end

local function isValidCharmItem(a1) -- Line: 28 -- upvalues: u10 (val)
    local v1 = false
    if a1 ~= nil then
        v1 = u10.IsCharmItem(a1) and a1.IsTradeable ~= false
    end
    return v1
end

function u10.GetTradeContext(a1) -- Line: 32 -- types: a1: table
    local Charm, _id, v1
    local v2 = {itemsById = {}, attachedCharmIds = {}}
    local v3 = nil
    local v4 = nil
    for i, j in a1, v3, v4 do
        v2.itemsById[j._id] = j
        Charm = j.Charm
        v1 = if typeof(Charm) ~= "table" then nil else Charm
        _id = if not v1 then nil else v1._id
        if _id then
            v2.attachedCharmIds[_id] = true
        end
    end
    return v2
end

function u10.IsTradeableItem(a1, a2) -- Line: 50 -- upvalues: u10 (val) -- types: a2: table
    local _id
    if a1.IsTradeable == false then
        return false
    end
    if u10.IsCharmItem(a1) then
        return a2.attachedCharmIds[a1._id] ~= true
    end
    local Charm = a1.Charm
    local v1 = if typeof(Charm) ~= "table" then nil else Charm
    if not (if not v1 then nil else v1._id) then
        return true
    end
    v1 = a2.itemsById[_id]
    local v2 = false
    if v1 ~= nil then
        v2 = u10.IsCharmItem(v1) and v1.IsTradeable ~= false
    end
    return v2
end

function u10.ResolveCharmReferences(a1, a2) -- Line: 70 -- upvalues: u10 (val) -- types: a1: table, a2: table?
    local Charm, Pattern, v1, v2, v3
    local v4 = a2 or u10.GetTradeContext(a1)
    local v5 = table.create(#a1)
    local v6 = nil
    local v7 = nil
    for i, j in a1, v6, v7 do
        Charm = j.Charm
        v3 = if typeof(Charm) ~= "table" then nil else Charm
        v1 = if not v3 then nil else v4.itemsById[v3._id]
        if v3 then
            if not v3.Skin or v3.Skin == "" then
                if v1 and u10.IsCharmItem(v1) then
                    v2 = table.clone(v3)
                    if not v2.Skin or v2.Skin == "" then
                        v2.Skin = v1.Skin
                    end
                    Pattern = v2.Pattern or v1.Pattern or 1
                    v2.Pattern = Pattern
                    j = table.clone(j)
                    j.Charm = v2
                end
            elseif not v3.Pattern and v1 and u10.IsCharmItem(v1) then
                v2 = table.clone(v3)
                if not v2.Skin or v2.Skin == "" then
                    v2.Skin = v1.Skin
                end
                Pattern = v2.Pattern or v1.Pattern or 1
                v2.Pattern = Pattern
                j = table.clone(j)
                j.Charm = v2
            end
        end
        v5[i] = j
    end
    return v5
end

return u10