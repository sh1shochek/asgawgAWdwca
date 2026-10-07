-- ReplicatedStorage.Database.Components.Common.NormalizeInventoryItemForRemote
-- Script path: ReplicatedStorage.Database.Components.Common.NormalizeInventoryItemForRemote
-- Decompile time: 0.76 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
local u9 = {"_id", "Type", "Name", "Skin", "Rarity", "OriginalOwner"}
local u16 = {"LastTradeAt", "CreatedAt"}
local u19 = {"OriginalOwner", "Owner", "Origin", "GlobalMarketPlaceListingReference"}
return function(a1) -- Line: 9 -- upvalues: Sift (val), u9 (val), u16 (val), u19 (val)
    local v1
    if typeof(a1) ~= "table" then
        return a1
    end
    local v2 = Sift.Dictionary.copyDeep(a1)
    for i, j in u9 do
        v1 = v2[j]
        if typeof(v1) == "number" then
            v1 = v2[j]
            v2[j] = (tostring(v1))
        end
    end
    local MetaData = v2.MetaData
    if typeof(MetaData) == "table" then
        local v3
        for k, n in u16 do
            v3 = MetaData[n]
            if typeof(v3) == "string" then
                v3 = MetaData[n]
                MetaData[n] = (tonumber(v3))
            end
        end
        if MetaData.GlobalMarketPlaceListingReference == false then
            MetaData.GlobalMarketPlaceListingReference = nil
        end
        for m, i5 in u19 do
            v3 = MetaData[i5]
            if typeof(v3) == "number" then
                v3 = MetaData[i5]
                MetaData[i5] = (tostring(v3))
            end
        end
    end
    return v2
end