-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetWeaponProperties = require(script.Parent.GetWeaponProperties);

local function CreateFallbackStockInformation(p1: string) -- Line: 17
    -- upvalues: GetWeaponProperties (copy)
    local success, result = pcall(GetWeaponProperties, p1);

    return success and result and {
        paintId = "stock",
        skin = "Stock",
        rarity = "Stock",
        supportsStatTrak = false,
        statTrakChance = 0,
        isEnabled = true,
        isMarketplaceVisible = false,
        collection = nil,
        description = "Standard issue finish.",
        caseRarity = "Stock",
        type = result.Class,
        name = p1,
        floatRange = {
            min = 0,
            max = 0.07
        },
        floatChances = { {
                wear = "Factory New",
                chance = 100
            } },
        charmImages = {},
        wearImages = {},
        imageAssetId = result.Icon or result.ReverseIcon
    } or nil;
end;

return function(p2: string, p3: string) -- Line: 47
    -- upvalues: Skins (copy), CreateFallbackStockInformation (copy)
    local SkinInformation = Skins.GetSkinInformation(p2, p3);

    if SkinInformation or p3 ~= "Stock" then
        return SkinInformation;
    end;

    return CreateFallbackStockInformation(p2);
end;