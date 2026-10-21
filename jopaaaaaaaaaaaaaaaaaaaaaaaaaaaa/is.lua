-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.is
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.is
-- Decompile time: 3.32 ms

-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 21, Name: is
    local v2;

    if typeof(p1) == "table" and #p1 > 0 then
        v2 = next(p1, #p1) == nil;
    else
        v2 = false;
    end;

    return v2;
end;