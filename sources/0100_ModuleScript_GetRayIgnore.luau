-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_CurrentCamera = workspace.CurrentCamera;
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Debris = workspace:WaitForChild("Debris");
local u1 = { "Cameras", "Barriers", "Ambience" };
local u2 = { "Spawns", "Sites" };

local function addChildren(p3: table, p4: userdata, p5: table) -- Line: 20
    for _, v in p5 do
        local v6 = p4:FindFirstChild(v);

        if v6 then
            table.insert(p3, v6);
        end;
    end;
end;

return function() -- Line: 32
    -- upvalues: Debris (copy), workspace_CurrentCamera (copy), u1 (copy), u2 (copy), CharacterResolver (copy)
    local v7 = { Debris, workspace_CurrentCamera };
    local Map = workspace:FindFirstChild("Map");

    if Map then
        for _, v in u1 do
            local v8 = Map:FindFirstChild(v);

            if v8 then
                table.insert(v7, v8);
            end;
        end;

        local Zones = Map:FindFirstChild("Zones");

        if Zones then
            for _, v in u2 do
                local v9 = Zones:FindFirstChild(v);

                if v9 then
                    table.insert(v7, v9);
                end;
            end;
        end;
    end;

    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter and LocalCharacter:IsDescendantOf(workspace) then
        table.insert(v7, LocalCharacter);
    end;

    return v7;
end;