-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = { "USP-S", "Glock-18", "P250", "Desert Eagle", "Tec-9", "CZ75-Auto", "Five-SeveN", "Dual Berettas", "R8 Revolver", "MAC-10", "MP9", "MP7", "MP5-SD", "UMP-45", "P90", "PP-Bizon", "AK-47", "M4A1-S", "M4A4", "AUG", "SG 553", "FAMAS", "Galil AR", "AWP", "SSG 08", "SCAR-20", "G3SG1", "XM1014", "Nova", "MAG-7", "Sawed-Off", "Negev", "M249", "CT Knife", "T Knife", "CT Glove", "T Glove", "Molotov", "Incendiary Grenade", "HE Grenade", "Flashbang", "Smoke Grenade", "Decoy Grenade", "C4", "Zeus x27" };
local u3 = {
    Weapon = true,
    Melee = true,
    Glove = true,
    Grenade = true,
    C4 = true
};

local function GetInventoryItemType(p4: string) -- Line: 84
    -- upvalues: ReplicatedStorage (copy), u3 (copy)
    if p4 == "Zeus x27" or p4 == "C4" then
        return p4;
    end;

    local v5 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p4);

    if not v5 then
        return "Weapon";
    end;

    local Class = require(v5).Class;

    return not u3[Class] and "Weapon" or Class;
end;

local function CreateStockItem(p6: string) -- Line: 101
    -- upvalues: ReplicatedStorage (copy), u3 (copy)
    local v7 = {
        Serial = 0,
        Skin = "Stock",
        Float = 0,
        StatTrack = false,
        IsTradeable = false,
        NameTag = false,
        Charm = false,
        _id = p6 .. "_Stock"
    };
    local v8;

    if p6 == "Zeus x27" or p6 == "C4" then
        v8 = p6;
    else
        local v9 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p6);

        if v9 then
            local Class = require(v9).Class;
            v8 = not u3[Class] and "Weapon" or Class;
        else
            v8 = "Weapon";
        end;
    end;

    v7.Type = v8;
    v7.Name = p6;
    v7.Stickers = {};
    v7.MetaData = {
        LastTradeAt = 0,
        CreatedAt = 0,
        OriginalOwner = 0,
        Owner = 0,
        Origin = "Stock",
        TradeHistory = {}
    };

    return v7;
end;

function u1.IsStockIdentifier(p10: string) -- Line: 128
    return string.sub(p10, -6) == "_Stock";
end;

function u1.GetWeaponNameFromStockId(p11: string) -- Line: 134
    -- upvalues: u1 (copy)
    if u1.IsStockIdentifier(p11) then
        return string.sub(p11, 1, -7);
    end;

    return nil;
end;

function u1.GetStockInventoryItem(p12: string) -- Line: 143
    -- upvalues: u2 (copy), CreateStockItem (copy)
    if table.find(u2, p12) then
        return CreateStockItem(p12);
    end;

    return nil;
end;

function u1.GenerateStockInventoryItems() -- Line: 153
    -- upvalues: u2 (copy), CreateStockItem (copy)
    local v13 = {};

    for _, v in ipairs(u2) do
        local v14 = CreateStockItem(v);
        table.insert(v13, v14);
    end;

    return v13;
end;

function u1.InjectStockItems(p15: table) -- Line: 165
    -- upvalues: u1 (copy)
    local v16 = u1.GenerateStockInventoryItems();
    local v17 = {};
    local v18 = {};

    for _, v in ipairs(p15) do
        v17[v._id] = true;

        if v.Skin == "Stock" then
            v18[v.Name] = true;
        end;
    end;

    for _, v in ipairs(v16) do
        if not (v17[v._id] or v18[v.Name]) then
            table.insert(p15, v);
        end;
    end;

    return p15;
end;

return u1;