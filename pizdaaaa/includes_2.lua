-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.includes
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.includes
-- Decompile time: 7.25 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: any) -- Line: 19, Name: includes
    for _, v in pairs(p1) do
        if v == p2 then
            return true;
        end;
    end;

    return false;
end;