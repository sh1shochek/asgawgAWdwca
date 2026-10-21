-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromEntries
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromEntries
-- Decompile time: 3.72 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: fromEntries
    local v2 = {};

    for _, v in ipairs(p1) do
        v2[v[1]] = v[2];
    end;

    return v2;
end;