-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Entities = script:WaitForChild("Entities");
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = {};
local u3 = {};

function v1.Initialize() -- Line: 30
    -- upvalues: Entities (copy), u3 (copy), Remotes (copy), u2 (copy)
    for _, child in Entities:GetChildren() do
        if child:IsA("ModuleScript") then
            u3[child.Name] = require(child);
        end;
    end;

    Remotes.Entity.CreateEntity.Listen(function(p4) -- Line: 38
        -- upvalues: u3 (ref), u2 (ref)
        local v5 = u3[p4.EntityName];

        if not v5 then
            return;
        end;

        u2[p4.EntityId] = v5.new(p4.EntityId, p4.EntityName, p4.EntityPosition);
    end);
    Remotes.Entity.DestroyEntity.Listen(function(p6) -- Line: 47
        -- upvalues: u2 (ref)
        local v7 = u2[p6.EntityId];

        if not v7 then
            return;
        end;

        u2[p6.EntityId] = nil;
        v7:Destroy(p6.ClaimedBy);
    end);
end;

return v1;