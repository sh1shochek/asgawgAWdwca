-- ReplicatedStorage.Components.Common.TutorialPurchaseLock
-- Script path: ReplicatedStorage.Components.Common.TutorialPurchaseLock
-- Decompile time: 3.71 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock)
local u27 = table.freeze({
    BuyWeapons = table.freeze({"AK-47"}),
    BuyCTWeapons = table.freeze({"M4A4", "M4A1-S"}),
})
local u30 = table.freeze({
    GoToRange = true,
    PracticeAK = true,
    KillCTs = true,
    PlantBomb = true,
    WaitExplode = true,
    GoToCTBuy = true,
    KillTs = true,
    DefuseB = true,
})
local u35 = table.freeze({Terrorists = u27.BuyWeapons, ["Counter-Terrorists"] = u27.BuyCTWeapons})
local u36 = {}

function u36.getRequiredItems(a1) -- Line: 56 -- upvalues: IsTutorialMode (val), u27 (val) -- types: a1: userdata
    if not IsTutorialMode() then
        return nil
    end
    local Attribute = a1:GetAttribute("TutorialStep")
    if typeof(Attribute) ~= "string" then
        return nil
    end
    return u27[Attribute]
end

function u36.isBuyMenuLocked(a1) -- Line: 70 -- upvalues: IsTutorialMode (val), u30 (val) -- types: a1: userdata
    if not IsTutorialMode() then
        return false
    end
    local Attribute = a1:GetAttribute("TutorialStep")
    if typeof(Attribute) ~= "string" then
        return false
    end
    return u30[Attribute] == true
end

function u36.isPurchaseAllowed(a1, a2) -- Line: 84 -- upvalues: u36 (val) -- types: a1: userdata, a2: string
    if u36.isBuyMenuLocked(a1) then
        return false
    end
    local v1 = u36.getRequiredItems(a1)
    if not v1 then
        return true
    end
    return table.find(v1, a2) ~= nil
end

function u36.isWaitingOnPurchase(a1, a2) -- Line: 102 -- upvalues: u36 (val) -- types: a1: userdata, a2: function
    local v1 = u36.getRequiredItems(a1)
    if not v1 then
        return false
    end
    for i, v in ipairs(v1) do
        if a2(v) then
            return false
        end
    end
    return true
end

function u36.getForcedLoadoutItem(a1, a2, a3, a4) -- Line: 118
    -- upvalues: IsTutorialMode (val), u35 (val), Stock (val)
    if a2 == "Loadout.Rifles.Options.1" and IsTutorialMode() then
        local v1 = u35[a1]
        if not v1 then
            return nil
        end
        local v2 = if typeof(a3) ~= "table" then nil else a3[a1]
        local Rifles = if typeof(v2) ~= "table" then nil else if typeof(v2.Loadout) ~= "table" then nil else v2.Loadout.Rifles
        local Options = if typeof(Rifles) ~= "table" then nil else Rifles.Options
        if typeof(Options) == "table" then
            local Name, v3
            local v4 = nil
            local v5 = nil
            for i, j in Options, v4, v5 do
                Name = if typeof(j) ~= "string" then nil else Stock.GetWeaponNameFromStockId(j)
                if not Name and typeof(v3) == "table" then
                    for k, n in v3 do
                        if n._id == j then
                            Name = n.Name
                            break
                        end
                    end
                end
                if Name and table.find(v1, Name) then
                    return nil
                end
            end
        end
        return Stock.GetStockInventoryItem(v1[1])
    end
    return nil
end

return u36