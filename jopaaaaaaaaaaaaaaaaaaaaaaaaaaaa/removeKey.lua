-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKey
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKey
-- Decompile time: 3.74 ms

-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, p2: any) -- Line: 21, Name: removeKey
    -- upvalues: copy (copy)
    local v3 = copy(p1);
    v3[p2] = nil;

    return v3;
end;