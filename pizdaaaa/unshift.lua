-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.unshift
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.unshift
-- Decompile time: 6.39 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 22, Name: unshift
    local v2 = { ... };

    for _, v in ipairs(p1) do
        table.insert(v2, v);
    end;

    return v2;
end;