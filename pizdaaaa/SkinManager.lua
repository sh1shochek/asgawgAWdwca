-- ReplicatedStorage.Shared.Managers.SkinManager
-- Script path: ReplicatedStorage.Shared.Managers.SkinManager
-- Decompile time: 8.38 ms

-- Decompiled with Potassium's decompiler.

local function BuildSkinData(p1: userdata, p2: any) -- Line: 7
    for _, child in p1:GetChildren() do
        local Name = child.Name;
        local v3 = {};
        local v4 = {};
        local Skin = child:FindFirstChild("Skin");
        local v5;

        if Skin then
            v5 = child;

            for _, child2 in Skin:GetChildren() do
                v3[child2.Name] = child2;
            end;
        else
            v5 = child;

            for _, child2 in child:GetChildren() do
                if child2.Name ~= "WorldModel" then
                    v3[child2.Name] = child2;
                end;
            end;
        end;

        local WorldModel = v5:FindFirstChild("WorldModel");

        if WorldModel then
            for _, child2 in WorldModel:GetChildren() do
                if child2:IsA("StringValue") then
                    v4[child2.Name] = child2;
                end;
            end;
        end;

        local v6 = p2[Name];

        if not v6 then
            v6 = {
                ModelName = "Weapon",
                Rarity = "Stock",
                Thumbnail = p2.Stock and (p2.Stock.Thumbnail or 0) or 0
            };
            p2[Name] = v6;
        end;

        v6.Skin = v3;
        v6.Assets = v3;
        v6.WorldModel = v4;
    end;

    return p2;
end;

local u7 = {};
local v8 = {};

for _, v in script:QueryDescendants("ModuleScript") do
    u7[v.Name] = BuildSkinData(v, require(v));
end;

local u9 = nil;
local u10 = nil;

function v8.GetWeaponSkin(p11: string, p12: string) -- Line: 68
    -- upvalues: u7 (ref)
    local v13 = u7[p11];

    if not v13 then
        return;
    end;

    local v14 = v13[p12];

    if v14 then
        return v14;
    end;
end;

function v8.GetArmsSkin(p15: string) -- Line: 84
    -- upvalues: u7 (ref)
    local v16 = u7.Arms[p15];

    if v16 then
        return v16;
    end;
end;

function v8.GetAllSkins() -- Line: 96
    -- upvalues: u7 (ref)
    return u7;
end;

function v8.Init(p17) -- Line: 102
    -- upvalues: u9 (ref), u10 (ref)
    u9 = p17:GetModule("Enums");
    u10 = p17:GetModule("Table");
end;

function v8.Start(p18) -- Line: 120
    -- upvalues: u9 (ref), u7 (ref), u10 (ref)
    local table_clone_ret = table.clone(u9.Weapons);
    local table_clone_ret2 = table.clone(u9.WeaponsNum);
    local v19 = {};

    for i in u7 do
        if not table_clone_ret2[i] then
            v19[i] = true;
        end;
    end;

    for i in u9.Items do
        if not table_clone_ret2[i] then
            v19[i] = true;
        end;
    end;

    local v20 = {};

    for i in v19 do
        table.insert(v20, i);
    end;

    table.sort(v20);

    for _, v in v20 do
        table.insert(table_clone_ret, v);
        table_clone_ret2[v] = #table_clone_ret;
    end;

    local v21 = {};
    local v22 = {};

    for i, v in table_clone_ret do
        local v23 = v;
        local v24 = {};
        local v25 = {};

        for i2 in u7[v] or {} do
            v24[i2] = true;
            table.insert(v25, i2);
        end;

        for _, v2 in u9.Items[v23] or {} do
            if not v24[v2] then
                table.insert(v25, v2);
            end;
        end;

        table.sort(v25);
        local v26 = {};
        local v27 = {};

        for i2, v2 in v25 do
            v26[v2] = i2;
            v27[i2] = v2;
        end;

        v22[v23] = v26;
        v21[i] = v27;
    end;

    u7 = u10.Freeze(u7);
    u9.Weapons = u10.Freeze(table_clone_ret);
    u9.WeaponsNum = u10.Freeze(table_clone_ret2);
    u9.Skins = u10.Freeze(v22);
    u9.SkinsNum = u10.Freeze(v21);
end;

return v8;