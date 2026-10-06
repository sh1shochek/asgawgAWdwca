-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = {
    IsCharmItem = function(p1) -- Line: 14, Name: IsCharmItem
        return p1.Type == "Charm" and true or p1.Name == "Charm";
    end
};

local function getCharmReference(p3) -- Line: 18
    local Charm = p3.Charm;

    if typeof(Charm) == "table" then
        return Charm;
    end;

    return nil;
end;

local function getEquippedCharmId(p4) -- Line: 23
    local Charm = p4.Charm;

    if typeof(Charm) ~= "table" then
        Charm = nil;
    end;

    if Charm then
        return Charm._id;
    end;

    return nil;
end;

local function isValidCharmItem(p5) -- Line: 28
    -- upvalues: u2 (copy)
    local v6;

    if p5 == nil then
        v6 = false;
    else
        v6 = u2.IsCharmItem(p5) and p5.IsTradeable ~= false;
    end;

    return v6;
end;

function u2.GetTradeContext(p7: table) -- Line: 32
    local v8 = {
        itemsById = {},
        attachedCharmIds = {}
    };

    for _, v in p7 do
        v8.itemsById[v._id] = v;
        local Charm = v.Charm;

        if typeof(Charm) ~= "table" then
            Charm = nil;
        end;

        local v9;

        if Charm then
            v9 = Charm._id;
        else
            v9 = nil;
        end;

        if v9 then
            v8.attachedCharmIds[v9] = true;
        end;
    end;

    return v8;
end;

function u2.IsTradeableItem(p10: any, p11: table) -- Line: 50
    -- upvalues: u2 (copy)
    if p10.IsTradeable == false then
        return false;
    end;

    if u2.IsCharmItem(p10) then
        return p11.attachedCharmIds[p10._id] ~= true;
    end;

    local Charm = p10.Charm;

    if typeof(Charm) ~= "table" then
        Charm = nil;
    end;

    local v12;

    if Charm then
        v12 = Charm._id;
    else
        v12 = nil;
    end;

    if not v12 then
        return true;
    end;

    local v13 = p11.itemsById[v12];
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = u2.IsCharmItem(v13) and v13.IsTradeable ~= false;
    end;

    return v14;
end;

function u2.ResolveCharmReferences(p15: table, p16: table?) -- Line: 70
    -- upvalues: u2 (copy)
    local v17 = p16 or u2.GetTradeContext(p15);
    local table_create_ret = table.create(#p15);

    for i, v in p15 do
        local Charm = v.Charm;

        if typeof(Charm) ~= "table" then
            Charm = nil;
        end;

        local v18;

        if Charm then
            v18 = v17.itemsById[Charm._id];
        else
            v18 = nil;
        end;

        local v19;

        if Charm and not (Charm.Skin and (Charm.Skin ~= "" and Charm.Pattern)) and (v18 and u2.IsCharmItem(v18)) then
            local table_clone_ret = table.clone(Charm);

            if not table_clone_ret.Skin or table_clone_ret.Skin == "" then
                table_clone_ret.Skin = v18.Skin;
            end;

            table_clone_ret.Pattern = table_clone_ret.Pattern or (v18.Pattern or 1);
            v19 = table.clone(v);
            v19.Charm = table_clone_ret;
        else
            v19 = v;
        end;

        table_create_ret[i] = v19;
    end;

    return table_create_ret;
end;

return u2;