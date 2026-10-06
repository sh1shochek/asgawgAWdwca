-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock);
local table_freeze_ret = table.freeze({
    BuyWeapons = table.freeze({ "AK-47" }),
    BuyCTWeapons = table.freeze({ "M4A4", "M4A1-S" })
});
local table_freeze_ret2 = table.freeze({
    GoToRange = true,
    PracticeAK = true,
    KillCTs = true,
    PlantBomb = true,
    WaitExplode = true,
    GoToCTBuy = true,
    KillTs = true,
    DefuseB = true
});
local table_freeze_ret3 = table.freeze({
    Terrorists = table_freeze_ret.BuyWeapons,
    ["Counter-Terrorists"] = table_freeze_ret.BuyCTWeapons
});
local u3 = {
    getRequiredItems = function(p1: userdata) -- Line: 56, Name: getRequiredItems
        -- upvalues: IsTutorialMode (copy), table_freeze_ret (copy)
        if not IsTutorialMode() then
            return nil;
        end;

        local Attribute = p1:GetAttribute("TutorialStep");

        if typeof(Attribute) == "string" then
            return table_freeze_ret[Attribute];
        end;

        return nil;
    end,

    isBuyMenuLocked = function(p2: userdata) -- Line: 70, Name: isBuyMenuLocked
        -- upvalues: IsTutorialMode (copy), table_freeze_ret2 (copy)
        if not IsTutorialMode() then
            return false;
        end;

        local Attribute = p2:GetAttribute("TutorialStep");

        if typeof(Attribute) == "string" then
            return table_freeze_ret2[Attribute] == true;
        end;

        return false;
    end
};

function u3.isPurchaseAllowed(p4: userdata, p5: string) -- Line: 84
    -- upvalues: u3 (copy)
    if u3.isBuyMenuLocked(p4) then
        return false;
    end;

    local RequiredItems = u3.getRequiredItems(p4);

    return not RequiredItems and true or table.find(RequiredItems, p5) ~= nil;
end;

function u3.isWaitingOnPurchase(p6: userdata, p7: function) -- Line: 102
    -- upvalues: u3 (copy)
    local RequiredItems = u3.getRequiredItems(p6);

    if not RequiredItems then
        return false;
    end;

    for _, v in ipairs(RequiredItems) do
        if p7(v) then
            return false;
        end;
    end;

    return true;
end;

function u3.getForcedLoadoutItem(p8: string, p9: string, p10: any, p11: any) -- Line: 118
    -- upvalues: IsTutorialMode (copy), table_freeze_ret3 (copy), Stock (copy)
    if p9 ~= "Loadout.Rifles.Options.1" or not IsTutorialMode() then
        return nil;
    end;

    local v12 = table_freeze_ret3[p8];

    if not v12 then
        return nil;
    end;

    local v13;

    if typeof(p10) == "table" then
        v13 = p10[p8];
    else
        v13 = nil;
    end;

    local v14;

    if typeof(v13) == "table" and typeof(v13.Loadout) == "table" then
        v14 = v13.Loadout.Rifles;
    else
        v14 = nil;
    end;

    local v15;

    if typeof(v14) == "table" then
        v15 = v14.Options;
    else
        v15 = nil;
    end;

    if typeof(v15) == "table" then
        for _, v in v15 do
            local v16;

            if typeof(v) == "string" then
                v16 = Stock.GetWeaponNameFromStockId(v);
            else
                v16 = nil;
            end;

            if not v16 and typeof(p11) == "table" then
                local v17 = v;

                for _, v2 in p11 do
                    if v2._id == v17 then
                        v16 = v2.Name;
                        break;
                    end;
                end;
            end;

            if v16 and table.find(v12, v16) then
                return nil;
            end;
        end;
    end;

    return Stock.GetStockInventoryItem(v12[1]);
end;

return u3;