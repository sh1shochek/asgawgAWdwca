-- ReplicatedStorage.Shared.Managers.ItemManager
-- Script path: ReplicatedStorage.Shared.Managers.ItemManager
-- Decompile time: 5.12 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local v2 = {};
local u3 = nil;

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("Folder") then
        for _, child2 in ipairs(child:GetChildren()) do
            local Name = child2.Name;
            u1[Name] = {
                Items = {},
                Info = require(child2)
            };

            for _, child3 in ipairs(child2:GetChildren()) do
                if child3:IsA("ModuleScript") then
                    u1[Name].Items[child3.Name] = require(child3);
                end;
            end;
        end;
    else
        local Name = child.Name;
        u1[Name] = {
            Items = {},
            Info = require(child)
        };

        for _, child2 in ipairs(child:GetChildren()) do
            if child2:IsA("ModuleScript") then
                u1[Name].Items[child2.Name] = require(child2);
            end;
        end;
    end;
end;

table.freeze(u1);

function v2.GetCategory(p4) -- Line: 55
    -- upvalues: u1 (copy)
    local v5 = u1[p4];

    if v5 then
        v5 = v5.Info;
    end;

    if v5 then
        return v5;
    end;
end;

function v2.GetItem(p6, p7) -- Line: 67
    -- upvalues: u1 (copy)
    local v8 = u1[p6];

    if v8 then
        v8 = v8.Items;
    end;

    if v8 then
        v8 = v8[p7];
    end;

    if v8 then
        return v8;
    end;
end;

function v2.GetItems(p9) -- Line: 79
    -- upvalues: u1 (copy)
    local v10 = u1[p9];

    if v10 then
        v10 = v10.Items;
    end;

    if v10 then
        return v10;
    end;
end;

function v2.GetGloveCategories() -- Line: 90
    -- upvalues: u1 (copy)
    local v11 = {};

    for i, v in u1 do
        if v.Info and v.Info.Class == "Gloves" then
            v11[i] = v.Items;
        end;
    end;

    return v11;
end;

function v2.Init(p12) -- Line: 102
    -- upvalues: u3 (ref), u1 (copy)
    u3 = p12:GetModule("Enums");
    u3.Items = {};
    u3.ItemsNum = {};

    for i, v in u1 do
        local Items = v.Items;

        if next(Items) then
            local v13 = i;
            local v14 = {};
            local v15 = {};

            for i2, _ in Items do
                table.insert(v14, i2);
            end;

            table.sort(v14);

            for i2, v3 in v14 do
                v15[v3] = i2;
            end;

            u3.Items[v13] = table.freeze(v14);
            u3.ItemsNum[v13] = table.freeze(v15);
        end;
    end;

    u3.Items = table.freeze(u3.Items);
    u3.ItemsNum = table.freeze(u3.ItemsNum);
end;

return v2;