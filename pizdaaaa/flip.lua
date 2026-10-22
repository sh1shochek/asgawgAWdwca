-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flip
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flip
-- Decompile time: 7.86 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: flip
    local v2 = {};

    for i, v in pairs(p1) do
        v2[v] = i;
    end;

    return v2;
end;