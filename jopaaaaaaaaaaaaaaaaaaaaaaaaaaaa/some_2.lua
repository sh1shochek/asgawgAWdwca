-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.some
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.some
-- Decompile time: 3.62 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 24, Name: some
    for i, v in pairs(p1) do
        if p2(v, i, p1) then
            return true;
        end;
    end;

    return false;
end;