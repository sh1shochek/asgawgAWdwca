-- ReplicatedStorage.Components.Common.GetWeaponProperties
-- Script path: ReplicatedStorage.Components.Common.GetWeaponProperties
-- Decompile time: 3.35 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);

return function(p1: string) -- Line: 10
    -- upvalues: ReplicatedStorage (copy)
    local v2 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p1);

    if v2 then
        return require(v2);
    end;

    return nil;
end;