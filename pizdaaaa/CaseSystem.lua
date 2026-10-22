-- ReplicatedStorage.Shared.CaseSystem
-- Script path: ReplicatedStorage.Shared.CaseSystem
-- Decompile time: 12.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    RarityWeights = {
        ["Mil-Spec"] = 79,
        Restricted = 16,
        Classified = 3.8,
        Covert = 0.85,
        ["Exceeding Rare"] = 0.35
    },
    KillTrackChance = 0.1,
    StatTrakChance = 0.1,
    MaxOpen = 5
};
local u2 = {
    Fingerless = true,
    Gloves = true,
    ["CT Gloves"] = true,
    ["T Gloves"] = true,
    Stickers = true,
    Badges = true,
    Graffiti = true,
    Agents = true,
    Charms = true,
    ["Name Tags"] = true,
    KillTracks = true
};
local Random_new_ret = Random.new();
local u3 = nil;
local u4 = nil;

local function GetRarityWeight(p5, p6) -- Line: 46
    -- upvalues: u1 (copy)
    return math.max(0, p6 and p6[p5] or (u1.RarityWeights[p5] or 1));
end;

local function GetItemKey(p7) -- Line: 50
    return p7.Skin ~= "" and `{p7.Weapon}_{p7.Skin}` or p7.Weapon;
end;

local function GroupItems(p8) -- Line: 54
    local v9 = {};
    local v10 = {};
    local v11 = {};

    for _, v in p8 do
        local Rarity = v.Rarity;

        if not v9[Rarity] then
            v9[Rarity] = {};
            v10[Rarity] = 0;
            table.insert(v11, Rarity);
        end;

        table.insert(v9[Rarity], v);
        v10[Rarity] = v10[Rarity] + math.max(0, v.ItemWeight or 1);
    end;

    return v9, v11, v10;
end;

local function RollItem(p12, p13, p14, p15) -- Line: 75
    -- upvalues: u1 (copy), Random_new_ret (copy), u4 (ref)
    local v16 = u1.PickRarity(p14, p12.Chances);
    local v17 = p13[v16];
    local v18 = p15[v16];
    local v19 = v17[1];

    if v18 > 0 then
        local v20 = Random_new_ret:NextNumber(0, v18);

        for _, v in v17 do
            v20 = v20 - math.max(0, v.ItemWeight or 1);

            if v20 <= 0 then
                v19 = v;
                break;
            end;
        end;
    end;

    local v21;

    if v19.CanHaveKillTrack == false then
        v21 = false;
    else
        v21 = Random_new_ret:NextNumber() <= (p12.KillTrackChance or u1.KillTrackChance);
    end;

    local Skin = v19.Skin;

    if p12.HoloChance and (u4.GetItem(v19.Weapon, (`{Skin} Holo`)) and Random_new_ret:NextNumber() <= p12.HoloChance) then
        Skin = `{Skin} Holo`;
    end;

    local v22 = {
        Weapon = v19.Weapon,
        Skin = Skin,
        Rarity = v19.Rarity,
        HasKillTrack = v21
    };
    local v23 = {
        Weapon = v19.Weapon,
        Skin = Skin
    };
    v22.ItemKey = v23.Skin ~= "" and `{v23.Weapon}_{v23.Skin}` or v23.Weapon;
    v22.CanHaveKillTrack = v19.CanHaveKillTrack;

    return v22;
end;

function u1.PickRarity(p24, p25) -- Line: 116
    -- upvalues: u1 (copy), Random_new_ret (copy)
    local v26 = 0;

    for _, v in p24 do
        v26 = v26 + math.max(0, p25 and p25[v] or (u1.RarityWeights[v] or 1));
    end;

    if v26 <= 0 then
        return p24[1];
    end;

    local v27 = Random_new_ret:NextNumber(0, v26);

    for _, v in p24 do
        v27 = v27 - math.max(0, p25 and p25[v] or (u1.RarityWeights[v] or 1));

        if v27 <= 0 then
            return v;
        end;
    end;

    return p24[#p24];
end;

function u1.NormalizeCaseData(p28) -- Line: 140
    -- upvalues: u2 (copy)
    if p28.Items then
        return {
            Name = p28.Name or "Container",
            Items = p28.Items,
            Chances = p28.Chances,
            KillTrackChance = p28.KillTrackChance,
            HoloChance = p28.HoloChance
        };
    end;

    local v29 = p28.Category == "Capsules";
    local v30 = {};

    for i, v in p28.Data or p28 do
        local v31 = i;

        for i2, v2 in v do
            local v32 = type(i2) == "string" and i2 and i2 or "";
            local v33, v34;

            if v32 == "" then
                v33 = "";
                v34 = "";
            else
                local string_find_ret = string.find(v32, "_", 1, true);

                if string_find_ret then
                    local string_find_ret2 = string.find(v32, "_", string_find_ret + 1, true);
                    v33 = string.sub(v32, 1, string_find_ret - 1);
                    v34 = string.sub(v32, string_find_ret + 1, string_find_ret2 and string_find_ret2 - 1 or #v32);
                else
                    v33 = v32;
                    v34 = "";
                end;
            end;

            local v35 = v2.Weapon or (v2.Name or (v33 or ""));
            local CanHaveKillTrack = v2.CanHaveKillTrack;

            if CanHaveKillTrack == nil then
                CanHaveKillTrack = not v29 and not u2[v35];
            end;

            table.insert(v30, {
                Weapon = v35,
                Skin = v2.Skin or (v2.SkinName or (v34 or "")),
                Rarity = v2.Rarity or v31,
                CanHaveKillTrack = CanHaveKillTrack,
                ItemWeight = v2.ItemWeight or 1
            });
        end;
    end;

    return {
        Name = p28.Name or "Container",
        Items = v30,
        Chances = p28.Chances,
        KillTrackChance = p28.KillTrackChance,
        HoloChance = p28.HoloChance
    };
end;

function u1.OpenCase(p36) -- Line: 204
    -- upvalues: u1 (copy)
    local v37 = u1.OpenCases(p36, 1);

    if v37 then
        v37 = v37[1];
    end;

    return v37;
end;

function u1.OpenCases(p38, p39) -- Line: 210
    -- upvalues: u1 (copy), GroupItems (copy), RollItem (copy)
    local v40 = u1.NormalizeCaseData(p38);

    if #v40.Items == 0 then
        return nil;
    end;

    local v41, v42, v43 = GroupItems(v40.Items);
    local v44 = {};

    for i = 1, p39 do
        v44[i] = RollItem(v40, v41, v42, v43);
        local _ = i;
    end;

    return v44;
end;

function u1.GetMaxOpen(p45) -- Line: 230
    -- upvalues: u3 (ref)
    local v46 = 1;

    for _, v in u3.Gamepasses do
        if v.MaxOpen and p45[v.Name] then
            v46 = math.max(v46, v.MaxOpen);
        end;
    end;

    return v46;
end;

function u1.GetOpenPass(p47, p48) -- Line: 242
    -- upvalues: u3 (ref)
    local v49 = nil;
    local v50 = nil;

    for i, v in u3.Gamepasses do
        if v.MaxOpen and (p47 <= v.MaxOpen and not (v.Requires or v49 and v.MaxOpen >= v49.MaxOpen)) then
            v50 = i;
            v49 = v;
        end;
    end;

    local v51 = v49.Upgrade and u3.Gamepasses[v49.Upgrade];

    if v51 and p48[u3.Gamepasses[v51.Requires].Name] then
        return v49.Upgrade, v51;
    end;

    return v50, v49;
end;

function u1.GetRarityOdds(p52, p53, p54) -- Line: 260
    -- upvalues: u1 (copy)
    local v55 = 0;

    for _, v in p52 do
        v55 = v55 + math.max(0, p53 and p53[v] or (u1.RarityWeights[v] or 1));
    end;

    local v56 = {};

    for _, v in p52 do
        v56[v] = v55 > 0 and (math.max(0, p53 and p53[v] or (u1.RarityWeights[v] or 1)) / v55 * 100 or 0) or 0;
    end;

    local v57 = (p54 or (u1.KillTrackChance or 0.1)) * 100;
    v56.StatTrak = v57;
    v56.KillTrack = v57;

    return v56;
end;

function u1.GetItemOdds(p58) -- Line: 280
    -- upvalues: u1 (copy), GroupItems (copy)
    local v59 = u1.NormalizeCaseData(p58);
    local v60, v61, v62 = GroupItems(v59.Items);
    local RarityOdds = u1.GetRarityOdds(v61, v59.Chances, v59.KillTrackChance);
    local v63 = {};

    for i, v in v60 do
        local v64 = v62[i];
        local v65 = i;

        for _, v2 in v do
            local v66 = v64 > 0 and (RarityOdds[v65] * math.max(0, v2.ItemWeight or 1) / v64 or 0) or 0;
            v63[v2.Skin ~= "" and `{v2.Weapon}_{v2.Skin}` or v2.Weapon] = math.round(v66 * 10000) / 10000;
        end;
    end;

    return v63;
end;

function u1.Init(p67) -- Line: 300
    -- upvalues: u3 (ref), u4 (ref)
    u3 = p67:GetModule("GamepassesData");
    u4 = p67:GetModule("ItemManager");
end;

return u1;