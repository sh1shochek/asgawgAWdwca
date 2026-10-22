-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.merge
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.merge
-- Decompile time: 6.65 ms

-- Decompiled with Potassium's decompiler.

return function(...) -- Line: 20, Name: merge
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);
        local v3;

        if type(v2) == "table" then
            v3 = i;

            for i2, _ in pairs(v2) do
                v1[i2] = true;
            end;
        else
            v3 = i;
        end;
    end;

    return v1;
end;