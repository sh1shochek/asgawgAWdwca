-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKeys
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKeys
-- Decompile time: 8.02 ms

-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, ...) -- Line: 20, Name: removeKeys
    -- upvalues: copy (copy)
    local v2 = copy(p1);

    for _, v in ipairs({ ... }) do
        v2[v] = nil;
    end;

    return v2;
end;