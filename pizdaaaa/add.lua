-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.add
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.add
-- Decompile time: 5.27 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 18, Name: add
    local v2 = {};

    for i, _ in pairs(p1) do
        v2[i] = true;
    end;

    for _, v in ipairs({ ... }) do
        v2[v] = true;
    end;

    return v2;
end;