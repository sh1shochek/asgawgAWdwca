-- ReplicatedStorage.Database.Components.Common.IsInBuyArea
-- Script path: ReplicatedStorage.Database.Components.Common.IsInBuyArea
-- Decompile time: 1.59 ms

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock)
local Tagged = CollectionService:GetTagged("BuyArea")
;(CollectionService:GetInstanceAddedSignal("BuyArea")):Connect(function(a1) -- Line: 11 -- upvalues: Tagged (val)
    table.insert(Tagged, a1)
end)
;(CollectionService:GetInstanceRemovedSignal("BuyArea")):Connect(function(a1) -- Line: 14 -- upvalues: Tagged (val)
    local v1 = table.find(Tagged, a1)
    if v1 then
        table.remove(Tagged, v1)
    end
end)

local function IsInZone(a1, a2) -- Line: 24 -- types: a1: vector, a2: userdata
    local Size = a2.Size
    local v1 = a2.CFrame:PointToObjectSpace(a1)
    local v2 = false
    if (math.abs(v1.X)) <= Size.X / 2 then
        v2 = false
        if (math.abs(v1.Y)) <= Size.Y / 2 then
            v2 = (math.abs(v1.Z)) <= Size.Z / 2
        end
    end
    return v2
end

local function IsInTeamBuyArea(a1, a2) -- Line: 32 -- upvalues: Tagged (val) -- types: a1: vector
    local Size, v1, v2
    local v3, v4 = a2, a1
    for i, v in ipairs(Tagged) do
        if v:GetAttribute("Team") == v3 then
            v2 = workspace
            if v:IsDescendantOf(v2) then
                Size = v.Size
                v2 = v.CFrame:PointToObjectSpace(v4)
                v1 = false
                if (math.abs(v2.X)) <= Size.X / 2 then
                    v1 = false
                    if (math.abs(v2.Y)) <= Size.Y / 2 then
                        v1 = (math.abs(v2.Z)) <= Size.Z / 2
                    end
                end
                if v1 then
                    return true
                end
            end
        end
    end
    return false
end

return function(a1, a2) -- Line: 44
    -- upvalues: TutorialPurchaseLock (val), IsInTeamBuyArea (val), CharacterResolver (val)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or TutorialPurchaseLock.getRequiredItems(a1) ~= nil then
        return true
    end
    local Attribute = a1:GetAttribute("Team")
    if not a1:IsA("Player") then
        local v1 = if not a2 then nil else a2(a1)
        local v2 = false
        if v1 ~= nil then
            v2 = IsInTeamBuyArea(v1, Attribute)
        end
        return v2
    end
    local Character = a1.Character
    if Character and Character:IsDescendantOf(workspace) then
        local Position = if not a2 then nil else a2(a1)
        if not Position then
            local PrimaryPart = Character.PrimaryPart or CharacterResolver.getRootPart(Character)
            if not PrimaryPart then
                return false
            end
            Position = PrimaryPart.Position
        end
        return (IsInTeamBuyArea(Position, Attribute))
    end
    return false
end