-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons);
local u1 = {
    Forbidden = 7,
    Special = 6,
    Red = 5,
    Pink = 4,
    Purple = 3,
    Blue = 2,
    Stock = 1
};
local u2 = {
    ["Sticker Capsule"] = 14,
    ["Charm Capsule"] = 13,
    ["Music Kit"] = 8,
    Graffiti = 11,
    Grenade = 16,
    Sticker = 10,
    ["Zeus x27"] = 3,
    Charm = 9,
    Melee = 1,
    Glove = 2,
    Badge = 7,
    Case = 12,
    C4 = 15
};
local u3 = {
    Melee = 1,
    Glove = 2,
    Case = 3,
    ["Charm Capsule"] = 4,
    ["Sticker Capsule"] = 4
};
local u4 = {
    Miscellaneous = 18,
    Equipment = 17,
    Pistol = 3,
    Rifle = 6,
    Heavy = 5,
    SMG = 4
};
local u5 = {
    Pistols = 1,
    ["Mid Tier"] = 2,
    Rifles = 3
};
local u6 = {
    ["Equipped Melee"] = 1,
    ["Equipped Gloves"] = 2,
    ["Equipped Badge"] = 3,
    ["Equipped Music Kit"] = 4,
    ["Equipped Graffiti"] = 5,
    ["Equipped Zeus x27"] = 6
};

local function IsStockSkin(p7: table) -- Line: 98
    return (p7.Skin == "Stock" or p7.MetaData and p7.MetaData.Origin == "Stock") and true or false;
end;

local function IsBadge(p8: table) -- Line: 102
    return p8.Name == "Badge";
end;

local function IsCharm(p9: table) -- Line: 106
    return p9.Name == "Charm";
end;

local function GetItemIdentity(p10: table) -- Line: 110
    return p10.Type == "Case" and (p10.Skin or "") or (p10.Name or "") .. "|" .. (p10.Skin or "");
end;

local function GetCollectionNameForItem(p11: table, p12: function?) -- Line: 119
    -- upvalues: Buttons (copy), Cases (copy), Skins (copy)
    if Buttons.IsCapsule(p11) then
        return "Capsules";
    end;

    if p11.Type ~= "Case" then
        if not (p11.Name and p11.Skin) then
            return nil;
        end;

        local SkinInformation = Skins.GetSkinInformation(p11.Name, p11.Skin);

        return SkinInformation and SkinInformation.collection or nil;
    end;

    if not p11.Skin then
        return nil;
    end;

    local CaseByName = Cases.GetCaseByName(p11.Skin);

    if not CaseByName then
        return nil;
    end;

    if p12 then
        p12 = p12();
    end;

    if not p12 then
        return nil;
    end;

    for _, v in ipairs(p12) do
        if v.cases then
            local v13 = v;

            for _, v2 in ipairs(v.cases) do
                if v2 == CaseByName.name then
                    return v13.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function BuildEquippedPriorityMap(p14: userdata) -- Line: 165
    -- upvalues: DataController (copy), u5 (copy), u6 (copy)
    local u15 = {};

    local function record(p16: any, p17: number) -- Line: 167
        -- upvalues: u15 (copy)
        local v18 = u15[p16];

        if not v18 or p17 < v18 then
            u15[p16] = p17;
        end;
    end;

    local v19 = DataController.Get(p14, "Loadout");

    if not v19 then
        return u15;
    end;

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v20 = v19[v];

        if v20 and v20.Loadout then
            for i, v2 in pairs(u5) do
                if v2 and (v20.Loadout[i] and v20.Loadout[i].Options) then
                    local v21 = v2;

                    for i2, v3 in ipairs(v20.Loadout[i].Options) do
                        local v22 = v21 * 1000 + i2;
                        local v23 = u15[v3];

                        if not v23 or v22 < v23 then
                            u15[v3] = v22;
                        end;
                    end;
                end;
            end;

            if v20.Equipped then
                for i, v2 in pairs(v20.Equipped) do
                    local v24 = u6[i] or 99;
                    local v25 = u15[v2];

                    if not v25 or v24 < v25 then
                        u15[v2] = v24;
                    end;
                end;
            end;
        end;
    end;

    return u15;
end;

local function MemoizePerItem(u26: function) -- Line: 204
    local u27 = {};

    return function(p28: table) -- Line: 206
        -- upvalues: u27 (copy), u26 (copy)
        local v29 = u27[p28];

        if v29 == nil then
            v29 = u26(p28);
            u27[p28] = v29;
        end;

        return v29;
    end;
end;

local function GetMetaDataNumber(p30: table, p31: string) -- Line: 217
    local MetaData = p30.MetaData;

    return MetaData and tonumber(MetaData[p31]) or 0;
end;

local function GetCreatedAt(p32: table) -- Line: 222
    local MetaData = p32.MetaData;

    return MetaData and tonumber(MetaData.CreatedAt) or 0;
end;

local function GetSerial(p33: table) -- Line: 228
    local v34 = tonumber(p33.Serial);

    if v34 == nil or v34 <= 0 then
        return nil;
    end;

    return v34;
end;

local function GetNewestSortTimestamp(p35: table) -- Line: 238
    local MetaData = p35.MetaData;
    local v36 = MetaData and tonumber(MetaData.LastTradeAt) or 0;
    local MetaData2 = p35.MetaData;
    local v37 = MetaData2 and tonumber(MetaData2.CreatedAt) or 0;

    if v36 > 0 then
        v37 = v36 or v37;
    end;

    return v37;
end;

local function GetRarityRank(p38: table) -- Line: 247
    -- upvalues: Skins (copy), u1 (copy)
    local v39 = p38.Name and (p38.Skin and Skins.GetSkinInformation(p38.Name, p38.Skin)) or nil;

    return v39 and u1[v39.rarity] or 0;
end;

local function GetTypeSortPriority(p40: table) -- Line: 254
    -- upvalues: Buttons (copy), u2 (copy), GetWeaponProperties (copy), u4 (copy)
    local EffectiveItemType = Buttons.GetEffectiveItemType(p40);
    local v41 = u2[EffectiveItemType];

    if v41 then
        return v41;
    end;

    if EffectiveItemType == "Weapon" and p40.Name then
        local success, result = pcall(GetWeaponProperties, p40.Name);

        if success and (result and result.Type) then
            return u4[result.Type] or 99;
        end;
    end;

    return 99;
end;

local function StockLast(u42: function) -- Line: 276
    return function(p43, p44) -- Line: 277
        -- upvalues: u42 (copy)
        local v45 = (p44.Skin == "Stock" or p44.MetaData and p44.MetaData.Origin == "Stock") and true or false;

        if ((p43.Skin == "Stock" or p43.MetaData and p43.MetaData.Origin == "Stock") and true or false) == v45 then
            return u42(p43, p44);
        end;

        return v45, true;
    end;
end;

return {
    GetSortComparisonFunction = function(p46: string, p47: userdata, u48: function?) -- Line: 291, Name: GetSortComparisonFunction
        -- upvalues: GetItemIdentity (copy), GetRarityRank (copy), GetCollectionNameForItem (copy), u3 (copy), Buttons (copy), BuildEquippedPriorityMap (copy), GetTypeSortPriority (copy)
        local u49 = GetItemIdentity;
        local u50 = {};

        local function u53(p51: table) -- Line: 206
            -- upvalues: u50 (copy), u49 (copy)
            local v52 = u50[p51];

            if v52 == nil then
                v52 = u49(p51);
                u50[p51] = v52;
            end;

            return v52;
        end;

        local u54 = GetRarityRank;
        local u55 = {};

        local function u58(p56: table) -- Line: 206
            -- upvalues: u55 (copy), u54 (copy)
            local v57 = u55[p56];

            if v57 == nil then
                v57 = u54(p56);
                u55[p56] = v57;
            end;

            return v57;
        end;

        local function CompareIdentityThenNewest(p59: table, p60: table) -- Line: 301
            -- upvalues: u53 (copy)
            local v61 = u53(p59);
            local v62 = u53(p60);

            if v61 ~= v62 then
                return v61 < v62;
            end;

            local MetaData = p59.MetaData;
            local v63 = MetaData and tonumber(MetaData.CreatedAt) or 0;
            local MetaData2 = p60.MetaData;

            return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v63;
        end;

        if p46 == "Alphabetical" then
            local function u70(p64, p65) -- Line: 311
                -- upvalues: u53 (copy)
                local v66 = u53(p64);
                local v67 = u53(p65);

                if v66 ~= v67 then
                    return v66 < v67;
                end;

                local MetaData = p64.MetaData;
                local v68 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                local MetaData2 = p65.MetaData;
                local v69 = MetaData2 and tonumber(MetaData2.CreatedAt) or 0;

                if v68 == v69 then
                    return (p64._id or "") < (p65._id or "");
                end;

                return v69 < v68;
            end;

            return function(p71, p72) -- Line: 277
                -- upvalues: u70 (copy)
                local v73 = (p72.Skin == "Stock" or p72.MetaData and p72.MetaData.Origin == "Stock") and true or false;

                if ((p71.Skin == "Stock" or p71.MetaData and p71.MetaData.Origin == "Stock") and true or false) == v73 then
                    return u70(p71, p72);
                end;

                return v73, true;
            end;
        end;

        if p46 == "Collection" then
            local function u75(p74: table) -- Line: 329
                -- upvalues: GetCollectionNameForItem (ref), u48 (copy)
                return GetCollectionNameForItem(p74, u48) or "";
            end;

            local u76 = {};

            local function u79(p77: table) -- Line: 206
                -- upvalues: u76 (copy), u75 (copy)
                local v78 = u76[p77];

                if v78 == nil then
                    v78 = u75(p77);
                    u76[p77] = v78;
                end;

                return v78;
            end;

            local function u81(p80: table) -- Line: 332
                -- upvalues: u3 (ref), Buttons (ref)
                return u3[Buttons.GetEffectiveItemType(p80)] or 4;
            end;

            local u82 = {};

            local function u85(p83: table) -- Line: 206
                -- upvalues: u82 (copy), u81 (copy)
                local v84 = u82[p83];

                if v84 == nil then
                    v84 = u81(p83);
                    u82[p83] = v84;
                end;

                return v84;
            end;

            local function u97(p86, p87) -- Line: 335
                -- upvalues: u79 (copy), u85 (copy), u58 (copy), u53 (copy)
                local v88 = u79(p86);
                local v89 = u79(p87);

                if v88 ~= v89 then
                    return v88 < v89;
                end;

                local v90 = u85(p86);
                local v91 = u85(p87);

                if v90 ~= v91 then
                    return v90 < v91;
                end;

                local v92 = u58(p86);
                local v93 = u58(p87);

                if v92 ~= v93 then
                    return v93 < v92;
                end;

                local v94 = u53(p86);
                local v95 = u53(p87);

                if v94 ~= v95 then
                    return v94 < v95;
                end;

                local MetaData = p86.MetaData;
                local v96 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                local MetaData2 = p87.MetaData;

                return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v96;
            end;

            return function(p98, p99) -- Line: 277
                -- upvalues: u97 (copy)
                local v100 = (p99.Skin == "Stock" or p99.MetaData and p99.MetaData.Origin == "Stock") and true or false;

                if ((p98.Skin == "Stock" or p98.MetaData and p98.MetaData.Origin == "Stock") and true or false) == v100 then
                    return u97(p98, p99);
                end;

                return v100, true;
            end;
        end;

        if p46 == "Equipped" then
            local u101 = BuildEquippedPriorityMap(p47);

            local function u109(p102, p103) -- Line: 358
                -- upvalues: u101 (copy), u53 (copy)
                local v104;

                if p102._id then
                    v104 = u101[p102._id] or nil;
                else
                    v104 = nil;
                end;

                local v105;

                if p103._id then
                    v105 = u101[p103._id] or nil;
                else
                    v105 = nil;
                end;

                if v104 ~= nil ~= (v105 ~= nil) then
                    return v104 ~= nil;
                end;

                if v104 and (v105 and v104 ~= v105) then
                    return v104 < v105;
                end;

                local v106 = u53(p102);
                local v107 = u53(p103);

                if v106 ~= v107 then
                    return v106 < v107;
                end;

                local MetaData = p102.MetaData;
                local v108 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                local MetaData2 = p103.MetaData;

                return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v108;
            end;

            return function(p110, p111) -- Line: 277
                -- upvalues: u109 (copy)
                local v112 = (p111.Skin == "Stock" or p111.MetaData and p111.MetaData.Origin == "Stock") and true or false;

                if ((p110.Skin == "Stock" or p110.MetaData and p110.MetaData.Origin == "Stock") and true or false) == v112 then
                    return u109(p110, p111);
                end;

                return v112, true;
            end;
        end;

        if p46 == "Newest" then
            local function u121(p113, p114) -- Line: 372
                -- upvalues: u53 (copy)
                local MetaData = p113.MetaData;
                local v115 = MetaData and tonumber(MetaData.LastTradeAt) or 0;
                local MetaData2 = p113.MetaData;
                local v116 = MetaData2 and tonumber(MetaData2.CreatedAt) or 0;

                if v115 > 0 then
                    v116 = v115 or v116;
                end;

                local MetaData3 = p114.MetaData;
                local v117 = MetaData3 and tonumber(MetaData3.LastTradeAt) or 0;
                local MetaData4 = p114.MetaData;
                local v118 = MetaData4 and tonumber(MetaData4.CreatedAt) or 0;

                if v117 > 0 then
                    v118 = v117 or v118;
                end;

                if v116 ~= v118 then
                    return v118 < v116;
                end;

                local v119 = u53(p113);
                local v120 = u53(p114);

                if v119 == v120 then
                    return (p113._id or "") < (p114._id or "");
                end;

                return v119 < v120;
            end;

            return function(p122, p123) -- Line: 277
                -- upvalues: u121 (copy)
                local v124 = (p123.Skin == "Stock" or p123.MetaData and p123.MetaData.Origin == "Stock") and true or false;

                if ((p122.Skin == "Stock" or p122.MetaData and p122.MetaData.Origin == "Stock") and true or false) == v124 then
                    return u121(p122, p123);
                end;

                return v124, true;
            end;
        end;

        if p46 == "Quality" then
            local function u132(p125, p126) -- Line: 387
                -- upvalues: u58 (copy), u53 (copy)
                local v127 = u58(p125);
                local v128 = u58(p126);

                if v127 ~= v128 then
                    return v128 < v127;
                end;

                local v129 = u53(p125);
                local v130 = u53(p126);

                if v129 ~= v130 then
                    return v129 < v130;
                end;

                local MetaData = p125.MetaData;
                local v131 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                local MetaData2 = p126.MetaData;

                return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v131;
            end;

            return function(p133, p134) -- Line: 277
                -- upvalues: u132 (copy)
                local v135 = (p134.Skin == "Stock" or p134.MetaData and p134.MetaData.Origin == "Stock") and true or false;

                if ((p133.Skin == "Stock" or p133.MetaData and p133.MetaData.Origin == "Stock") and true or false) == v135 then
                    return u132(p133, p134);
                end;

                return v135, true;
            end;
        end;

        if p46 ~= "Type" then
            if p46 == "Float" then
                local function u143(p136, p137) -- Line: 406
                    -- upvalues: u53 (copy)
                    local v138 = p137.Name == "Badge";

                    if p136.Name == "Badge" ~= v138 then
                        return v138, true;
                    end;

                    local v139 = p137.Name == "Charm";

                    if p136.Name == "Charm" ~= v139 then
                        return v139, true;
                    end;

                    local Float = p136.Float;
                    local Float2 = p137.Float;

                    if Float ~= nil and (Float2 ~= nil and Float ~= Float2) then
                        return Float < Float2;
                    end;

                    if Float ~= nil and Float2 == nil then
                        return true;
                    end;

                    if Float == nil and Float2 ~= nil then
                        return false;
                    end;

                    local v140 = u53(p136);
                    local v141 = u53(p137);

                    if v140 ~= v141 then
                        return v140 < v141;
                    end;

                    local MetaData = p136.MetaData;
                    local v142 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                    local MetaData2 = p137.MetaData;

                    return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v142;
                end;

                return function(p144, p145) -- Line: 277
                    -- upvalues: u143 (copy)
                    local v146 = (p145.Skin == "Stock" or p145.MetaData and p145.MetaData.Origin == "Stock") and true or false;

                    if ((p144.Skin == "Stock" or p144.MetaData and p144.MetaData.Origin == "Stock") and true or false) == v146 then
                        return u143(p144, p145);
                    end;

                    return v146, true;
                end;
            end;

            if p46 ~= "Serial" then
                return nil;
            end;

            local function u154(p147, p148) -- Line: 432
                -- upvalues: u53 (copy)
                local v149 = tonumber(p147.Serial);

                if v149 == nil or v149 <= 0 then
                    v149 = nil;
                end;

                local v150 = tonumber(p148.Serial);

                if v150 == nil or v150 <= 0 then
                    v150 = nil;
                end;

                if v149 == nil or v150 == nil then
                    if v149 ~= nil then
                        return true, true;
                    end;

                    if v150 ~= nil then
                        return false, true;
                    end;
                elseif v149 ~= v150 then
                    return v149 < v150;
                end;

                local v151 = u53(p147);
                local v152 = u53(p148);

                if v151 ~= v152 then
                    return v151 < v152;
                end;

                local MetaData = p147.MetaData;
                local v153 = MetaData and tonumber(MetaData.CreatedAt) or 0;
                local MetaData2 = p148.MetaData;

                return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v153;
            end;

            return function(p155, p156) -- Line: 277
                -- upvalues: u154 (copy)
                local v157 = (p156.Skin == "Stock" or p156.MetaData and p156.MetaData.Origin == "Stock") and true or false;

                if ((p155.Skin == "Stock" or p155.MetaData and p155.MetaData.Origin == "Stock") and true or false) == v157 then
                    return u154(p155, p156);
                end;

                return v157, true;
            end;
        end;

        local u158 = GetTypeSortPriority;
        local u159 = {};

        local function u162(p160: table) -- Line: 206
            -- upvalues: u159 (copy), u158 (copy)
            local v161 = u159[p160];

            if v161 == nil then
                v161 = u158(p160);
                u159[p160] = v161;
            end;

            return v161;
        end;

        local function u170(p163, p164) -- Line: 397
            -- upvalues: u162 (copy), u53 (copy)
            local v165 = u162(p163);
            local v166 = u162(p164);

            if v165 ~= v166 then
                return v165 < v166;
            end;

            local v167 = u53(p163);
            local v168 = u53(p164);

            if v167 ~= v168 then
                return v167 < v168;
            end;

            local MetaData = p163.MetaData;
            local v169 = MetaData and tonumber(MetaData.CreatedAt) or 0;
            local MetaData2 = p164.MetaData;

            return (MetaData2 and tonumber(MetaData2.CreatedAt) or 0) < v169;
        end;

        return function(p171, p172) -- Line: 277
            -- upvalues: u170 (copy)
            local v173 = (p172.Skin == "Stock" or p172.MetaData and p172.MetaData.Origin == "Stock") and true or false;

            if ((p171.Skin == "Stock" or p171.MetaData and p171.MetaData.Origin == "Stock") and true or false) == v173 then
                return u170(p171, p172);
            end;

            return v173, true;
        end;
    end
};