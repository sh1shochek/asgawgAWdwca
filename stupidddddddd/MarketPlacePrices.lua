-- ReplicatedStorage.Database.Components.MarketPlacePrices
-- Script path: ReplicatedStorage.Database.Components.MarketPlacePrices
-- Decompile time: 1.44 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
require(ReplicatedStorage.Database.Custom.Types)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local u22 = false
local u23 = nil
local u24 = {}

local function GetWearNameFromFloat(a1, a2, a3) -- Line: 25
    -- upvalues: Skins (val)
    local v1 = Skins.GetSkinInformation(a1, a2)
    return v1 and Skins.GetWearNameForFloat(v1, a3)
end

local function WaitForMarketPlacePrices() -- Line: 32 -- upvalues: u22 (ref), ReplicatedStorage (val)
    while not u22 do
        ReplicatedStorage:GetAttributeChangedSignal("MarketPlacePrices"):Wait()
    end
end

local function GetItemKey(a1, a2) -- Line: 38 -- types: a1: string, a2: string
    return (("%*\000%*"):format(a1, a2))
end

local function UpdateMarketPlacePrices(a1) -- Line: 42
    -- upvalues: u23 (ref), HttpService (val), u24 (val), u22 (ref)
    local itemName, itemSkin, v1
    u23 = HttpService:JSONDecode(a1)
    table.clear(u24)
    for i, j in u23.items do
        v1 = u24
        itemName = j.itemName
        itemSkin = j.itemSkin
        v1[("%*\000%*"):format(itemName, itemSkin)] = j
    end
    u22 = true
end

function u0.GetItemPrice(a1, a2, a3, a4) -- Line: 54
    -- upvalues: Skins (val), u0 (val)
    local v1 = Skins.GetSkinInformation(a1, a2)
    local v2 = v1 and Skins.GetWearNameForFloat(v1, a3)
    v1 = u0.GetMarketPlaceItem(a1, a2)
    if v1 and v2 then
        local statTrack = a4 and v1.statTrack or v1.standard
        return statTrack[v2]
    end
    return nil
end

function u0.GetMarketPlaceItem(a1, a2) -- Line: 70
    -- upvalues: WaitForMarketPlacePrices (val), u24 (val)
    WaitForMarketPlacePrices()
    return u24[("%*\000%*"):format(a1, a2)]
end

local Attribute = ReplicatedStorage:GetAttribute("MarketPlacePrices")
if typeof(Attribute) == "string" then
    UpdateMarketPlacePrices(Attribute)
end
;(ReplicatedStorage:GetAttributeChangedSignal("MarketPlacePrices")):Connect(function() -- Line: 78 -- upvalues: ReplicatedStorage (val), UpdateMarketPlacePrices (val)
    local Attribute = ReplicatedStorage:GetAttribute("MarketPlacePrices")
    if typeof(Attribute) == "string" then
        UpdateMarketPlacePrices(Attribute)
    end
end)
return u0