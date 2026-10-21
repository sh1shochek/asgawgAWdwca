-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSubset
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSubset
-- Decompile time: 3.96 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: table) -- Line: 19, Name: isSubset
    for i, v in pairs(p1) do
        if p2[i] ~= v then
            return false;
        end;
    end;

    return true;
end;