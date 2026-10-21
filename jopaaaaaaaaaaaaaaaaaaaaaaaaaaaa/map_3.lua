-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.map
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.map
-- Decompile time: 3.53 ms

-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 20, Name: map
    local v3 = {};

    for i, _ in pairs(p1) do
        local v4 = p2(i, p1);

        if v4 ~= nil then
            v3[v4] = true;
        end;
    end;

    return v3;
end;