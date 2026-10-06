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