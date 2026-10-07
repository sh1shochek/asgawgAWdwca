-- ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons
-- Script path: ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons
-- Decompile time: 1.08 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local v1 = {
    LayoutOrder = 0,
    Search = {
        "Badge",
        "Zeus x27",
        "C4",
        "Graffiti",
        "Charm",
        "Charm Capsule",
        "Sticker",
        "Sticker Capsule",
        "Music Kit",
        "Weapon",
        "Glove",
        "Melee",
        "Case",
        "Package",
    },
}
return ((require(ReplicatedStorage.Packages.Sift)).Dictionary.freezeDeep({
    GetEffectiveItemType = function(a1) -- Line: 62 -- types: a1: table
        local v1
        if a1.Type ~= "Case" or not a1.Name then
            v1 = false
        else
            local v2 = string.find(a1.Skin, "Sticker") ~= nil
            v1 = true
            if string.find(a1.Skin, "Charm") == nil then
                v1 = v2
            end
        end
        if not v1 then
            return a1.Type or ""
        end
        if string.find(a1.Name, "Charm") then
            return "Charm Capsule"
        end
        return "Sticker Capsule"
    end,
    IsCapsule = function(a1) -- Line: 51 -- types: a1: table
        if a1.Type == "Case" and a1.Name then
            local v1 = string.find(a1.Skin, "Sticker") ~= nil
            local v2 = true
            if string.find(a1.Skin, "Charm") == nil then
                v2 = v1
            end
            return v2
        end
        return false
    end,
    Everything = {Default = v1},
    Equipment = {
        ["All Equipment"] = v1,
        Melee = {Search = {"Melee"}, LayoutOrder = 1},
        Pistols = {Search = {"Weapon:Pistol"}, LayoutOrder = 2},
        ["Mid-Tier"] = {Search = {"Weapon:Heavy", "Weapon:SMG"}, LayoutOrder = 3},
        Rifles = {Search = {"Weapon:Rifle"}, LayoutOrder = 4},
        Misc = {Search = {"Zeus x27", "C4"}, LayoutOrder = 5},
        Gloves = {Search = {"Glove"}, LayoutOrder = 6},
        ["Music Kits"] = {Search = {"Music Kit"}, LayoutOrder = 7},
    },
    ["Graphic Art"] = {
        ["All Graphic Art"] = {Search = {"Badge", "Graffiti", "Charm", "Sticker"}, LayoutOrder = 0},
        Badges = {Search = {"Badge"}, LayoutOrder = 1},
        Stickers = {Search = {"Sticker"}, LayoutOrder = 2},
        Graffiti = {Search = {"Graffiti"}, LayoutOrder = 3},
        Charms = {Search = {"Charm"}, LayoutOrder = 4},
    },
    Display = {
        All = {Search = {"Case", "Package", "Charm Capsule", "Sticker Capsule"}, LayoutOrder = 0},
        Cases = {Search = {"Case"}, LayoutOrder = 1},
        Packages = {Search = {"Package"}, LayoutOrder = 2},
        Capsules = {Search = {"Charm Capsule", "Sticker Capsule"}, LayoutOrder = 3},
    },
}))