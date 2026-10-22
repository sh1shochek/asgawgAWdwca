-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.set
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.set
-- Decompile time: 6.68 ms

-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, p2: any, p3: any) -- Line: 21, Name: set
    -- upvalues: copy (copy)
    local v4 = copy(p1);
    v4[p2] = p3;

    return v4;
end;