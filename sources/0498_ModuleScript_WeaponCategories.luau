-- Decompiled with Potassium's decompiler.

local table_freeze_ret = table.freeze({
    Rifle = "RIFLE",
    SMG = "SMG",
    Pistol = "PISTOL",
    Shotgun = "HEAVY",
    Sniper = "SNIPER",
    Melee = "MELEE",
    Special = "SPECIAL"
});
local table_freeze_ret2 = table.freeze({
    Rifle = table.freeze({ "AK-47", "M4A4", "M4A1-S", "AUG", "SG 553", "FAMAS", "Galil AR" }),
    SMG = table.freeze({ "MP9", "MAC-10", "P90" }),
    Pistol = table.freeze({ "Glock-18", "USP-S", "P250", "Five-SeveN", "Tec-9", "Dual Berettas", "Desert Eagle", "R8 Revolver" }),
    Shotgun = table.freeze({ "Nova", "XM1014", "MAG-7", "Sawed-Off", "Negev" }),
    Sniper = table.freeze({ "AWP", "SSG 08" }),
    Melee = table.freeze({ "CT Knife", "T Knife", "Karambit", "M9 Bayonet", "Butterfly Knife", "Flip Knife", "Gut Knife", "Skeleton Knife", "Stiletto Knife", "LightSaber" }),
    Special = table.freeze({ "HE Grenade", "Molotov", "Incendiary Grenade", "Zeus x27" })
});
local u1 = {};
local u2 = {};
local u3 = {
    ["Zeus x27"] = true
};
local u4 = {};

for _, v in ipairs({ "Rifle", "SMG", "Pistol", "Shotgun", "Sniper", "Melee", "Special" }) do
    local v5 = v;

    for _, v2 in ipairs(table_freeze_ret2[v]) do
        u1[v2] = v5;
        table.insert(u2, v2);
    end;
end;

for _, v in ipairs({ "Melee", "Special" }) do
    for _, v2 in ipairs(table_freeze_ret2[v]) do
        u3[v2] = true;
    end;
end;

table.freeze(u1);
table.freeze(u2);
table.freeze(u3);

function u4.GetWeapons() -- Line: 118
    -- upvalues: u2 (copy)
    return u2;
end;

function u4.GetCategory(p6: string) -- Line: 125
    -- upvalues: u1 (copy)
    return u1[p6] or "Special";
end;

function u4.GetLabel(p7: string) -- Line: 131
    -- upvalues: table_freeze_ret (copy), u4 (copy)
    return table_freeze_ret[u4.GetCategory(p7)] or "SPECIAL";
end;

function u4.CountsTowardsAccuracy(p8: string?) -- Line: 137
    -- upvalues: u3 (copy)
    if p8 == nil or p8 == "" then
        return false;
    end;

    return not u3[p8];
end;

return table.freeze(u4);