-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock);
local Tagged = CollectionService:GetTagged("BuyArea");
CollectionService:GetInstanceAddedSignal("BuyArea"):Connect(function(p1) -- Line: 11
    -- upvalues: Tagged (copy)
    table.insert(Tagged, p1);
end);
CollectionService:GetInstanceRemovedSignal("BuyArea"):Connect(function(p2) -- Line: 14
    -- upvalues: Tagged (copy)
    local table_find_ret = table.find(Tagged, p2);

    if table_find_ret then
        table.remove(Tagged, table_find_ret);
    end;
end);

local function IsInZone(p3: vector, p4: userdata) -- Line: 24
    local Size = p4.Size;
    local v5 = p4.CFrame:PointToObjectSpace(p3);
    local v6;

    if math.abs(v5.X) <= Size.X / 2 and math.abs(v5.Y) <= Size.Y / 2 then
        v6 = math.abs(v5.Z) <= Size.Z / 2;
    else
        v6 = false;
    end;

    return v6;
end;

local function IsInTeamBuyArea(p7: vector, p8: any) -- Line: 32
    -- upvalues: Tagged (copy)
    for _, v in ipairs(Tagged) do
        if v:GetAttribute("Team") == p8 and v:IsDescendantOf(workspace) then
            local Size = v.Size;
            local v9 = v.CFrame:PointToObjectSpace(p7);
            local v10;

            if math.abs(v9.X) <= Size.X / 2 and math.abs(v9.Y) <= Size.Y / 2 then
                v10 = math.abs(v9.Z) <= Size.Z / 2;
            else
                v10 = false;
            end;

            if v10 then
                return true;
            end;
        end;
    end;

    return false;
end;

return function(p11: userdata, p12: function?) -- Line: 44
    -- upvalues: TutorialPurchaseLock (copy), IsInTeamBuyArea (copy), CharacterResolver (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    if TutorialPurchaseLock.getRequiredItems(p11) ~= nil then
        return true;
    end;

    local Attribute = p11:GetAttribute("Team");

    if not p11:IsA("Player") then
        local v13;

        if p12 then
            v13 = p12(p11);
        else
            v13 = nil;
        end;

        local v14;

        if v13 == nil then
            v14 = false;
        else
            v14 = IsInTeamBuyArea(v13, Attribute);
        end;

        return v14;
    end;

    local Character = p11.Character;

    if not (Character and Character:IsDescendantOf(workspace)) then
        return false;
    end;

    local v15;

    if p12 then
        v15 = p12(p11);
    else
        v15 = nil;
    end;

    if not v15 then
        local v16 = Character.PrimaryPart or CharacterResolver.getRootPart(Character);

        if not v16 then
            return false;
        end;

        v15 = v16.Position;
    end;

    return IsInTeamBuyArea(v15, Attribute);
end;