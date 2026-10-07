-- ReplicatedStorage.Components.Common.GetInventoryItemIcon
-- Script path: ReplicatedStorage.Components.Common.GetInventoryItemIcon
-- Decompile time: 0.65 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local u11 = {["Counter-Terrorists"] = "rbxassetid://120553709154808", Terrorists = "rbxassetid://76834532512077"}
local u14 = {Weapon = true, Melee = true}

local function GetSkinRender(a1) -- Line: 27 -- upvalues: Skins (val)
    if typeof(a1.Name) ~= "string" then
        return nil
    end
    local v1 = Skins.GetSkinInformation(a1.Name, if typeof(a1.Skin) ~= "string" then "Stock" else if a1.Skin == "" then "Stock" else a1.Skin)
    if not v1 then
        return nil
    end
    if v1.wearImages and v1.wearImages[1] then
        return v1.wearImages[1].assetId
    end
    return v1.imageAssetId
end

return function(a1, a2) -- Line: 45 -- upvalues: u11 (val), u14 (val), GetSkinRender (val)
    if a1 and a1.Properties then
        local v1
        if a1.Name == "Smoke Grenade" and typeof(a2) == "string" then
            v1 = u11[a2]
            if v1 then
                return v1
            end
        end
        if u14[a1.Properties.Class] then
            v1 = GetSkinRender(a1)
            if v1 then
                return v1
            end
        end
        return a1.Properties.Icon
    end
    return nil
end