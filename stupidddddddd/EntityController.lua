-- ReplicatedStorage.Controllers.EntityController
-- Script path: ReplicatedStorage.Controllers.EntityController
-- Decompile time: 0.58 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Entities = script:WaitForChild("Entities")
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u16 = {}
local u17 = {}

function v1.Initialize() -- Line: 30 -- upvalues: Entities (val), u17 (val), Remotes (val), u16 (val)
    for i, j in Entities:GetChildren() do
        if j:IsA("ModuleScript") then
            u17[j.Name] = (require(j))
        end
    end
    Remotes.Entity.CreateEntity.Listen(function(a1) -- Line: 38 -- upvalues: u17 (upval), u16 (upval)
        local v1 = u17[a1.EntityName]
        if not v1 then
            return
        end
        u16[a1.EntityId] = (v1.new(a1.EntityId, a1.EntityName, a1.EntityPosition))
    end)
    Remotes.Entity.DestroyEntity.Listen(function(a1) -- Line: 47 -- upvalues: u16 (upval)
        local v1 = u16[a1.EntityId]
        if not v1 then
            return
        end
        u16[a1.EntityId] = nil
        v1:Destroy(a1.ClaimedBy)
    end)
end

return v1