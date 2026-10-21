-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.entries
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.entries
-- Decompile time: 3.79 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: entries
    local v2 = {};

    for i, v in pairs(p1) do
        table.insert(v2, { i, v });
    end;

    return v2;
end;