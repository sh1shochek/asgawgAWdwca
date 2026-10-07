-- ReplicatedStorage.Components.Common.GetResolvedSkinInformation
-- Script path: ReplicatedStorage.Components.Common.GetResolvedSkinInformation
-- Decompile time: 0.79 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local GetWeaponProperties = require(script.Parent.GetWeaponProperties)

local function CreateFallbackStockInformation(a1) -- Line: 17
    -- upvalues: GetWeaponProperties (val)
    local success, result = pcall(GetWeaponProperties, a1)
    if success and result then
        local v1 = {
            paintId = "stock",
            skin = "Stock",
            rarity = "Stock",
            supportsStatTrak = false,
            statTrakChance = 0,
            isEnabled = true,
            isMarketplaceVisible = false,
            description = "Standard issue finish.",
            caseRarity = "Stock",
            type = result.Class,
            name = a1,
            floatRange = {min = 0, max = 0.07},
            floatChances = {{wear = "Factory New", chance = 100}},
            charmImages = {},
            wearImages = {},
        }
        local Icon = result.Icon or result.ReverseIcon
        v1.imageAssetId = Icon
        return v1
    end
    return nil
end

return function(a1, a2) -- Line: 47
    -- upvalues: Skins (val), CreateFallbackStockInformation (val)
    local v1 = Skins.GetSkinInformation(a1, a2)
    if not v1 and a2 == "Stock" then
        return (CreateFallbackStockInformation(a1))
    end
    return v1
end