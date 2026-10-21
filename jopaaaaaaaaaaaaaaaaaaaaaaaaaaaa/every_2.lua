-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.every
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.every
-- Decompile time: 3.86 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 24, Name: every
    for i, v in pairs(p1) do
        if not p2(v, i, p1) then
            return false;
        end;
    end;

    return true;
end;