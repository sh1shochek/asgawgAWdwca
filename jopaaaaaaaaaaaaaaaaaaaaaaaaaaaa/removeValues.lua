-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeValues
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeValues
-- Decompile time: 3.13 ms

-- Decompiled with Potassium's decompiler.

local toSet = require(script.Parent.toSet);

return function(p1: table, ...) -- Line: 20, Name: removeValues
    -- upvalues: toSet (copy)
    local v2 = toSet({ ... });
    local v3 = {};

    for _, v in ipairs(p1) do
        if not v2[v] then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;