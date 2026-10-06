-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = {};
local u3 = {};

function v1.GetMissionDefinition(p4: string) -- Line: 22
    -- upvalues: u2 (copy)
    return u2[p4];
end;

function v1.GetMissionCategory(p5: string) -- Line: 28
    -- upvalues: u2 (copy)
    local v6 = u2[p5];

    return v6 and v6.Category or nil;
end;

function v1.GetMissionDisplayName(p7: string) -- Line: 35
    -- upvalues: u2 (copy)
    local v8 = u2[p7];

    if v8 then
        p7 = v8.DisplayName or p7;
    end;

    return p7;
end;

function v1.GetMissionDefinitions() -- Line: 42
    -- upvalues: u3 (copy)
    return table.clone(u3);
end;

function v1.IsMissionAvailableForGamemode(p9: any, p10: any, p11: boolean?) -- Line: 48
    if not p9.Gamemodes then
        return true;
    end;

    if p10 then
        return table.find(p9.Gamemodes, p10) ~= nil;
    end;

    return p11 == true;
end;

for _, descendant in ipairs(script:GetDescendants()) do
    if descendant:IsA("ModuleScript") then
        local v12 = require(descendant);

        if v12 and v12.MissionId then
            u2[v12.MissionId] = v12;
            table.insert(u3, v12);
        end;
    end;
end;

return v1;