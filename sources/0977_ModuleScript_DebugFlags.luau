-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    IsEnabled = function(p1: string) -- Line: 11, Name: IsEnabled
        -- upvalues: ReplicatedStorage (copy)
        return ReplicatedStorage:GetAttribute("Debug_" .. p1) == true;
    end
};