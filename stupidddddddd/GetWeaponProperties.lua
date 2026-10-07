-- ReplicatedStorage.Components.Common.GetWeaponProperties
-- Script path: ReplicatedStorage.Components.Common.GetWeaponProperties
-- Decompile time: 0.23 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
return function(a1) -- Line: 10 -- upvalues: ReplicatedStorage (val) -- types: a1: string
    local v1 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(a1)
    if not v1 then
        return nil
    end
    return require(v1)
end