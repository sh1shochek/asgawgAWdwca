-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.withKeys
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.withKeys
-- Decompile time: 3.56 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 19, Name: withKeys
    local v2 = {};

    for _, v in ipairs({ ... }) do
        v2[v] = p1[v];
    end;

    return v2;
end;