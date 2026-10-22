-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.map
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.map
-- Decompile time: 9.65 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 26, Name: map
    local v3 = {};

    for i, v in pairs(p1) do
        local v4, v5 = p2(v, i, p1);
        v3[v5 or i] = v4;
    end;

    return v3;
end;