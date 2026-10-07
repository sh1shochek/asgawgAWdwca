-- ReplicatedStorage.Database.Custom.Finishers.Ragdoll
-- Script path: ReplicatedStorage.Database.Custom.Finishers.Ragdoll
-- Decompile time: 0.30 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 17 -- upvalues: Ragdoll (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 21 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}