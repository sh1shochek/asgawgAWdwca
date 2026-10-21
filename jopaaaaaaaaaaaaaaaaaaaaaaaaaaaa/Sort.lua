-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.sort
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.sort
-- Decompile time: 3.43 ms

-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, p2: function?) -- Line: 22, Name: sort
    -- upvalues: copy (copy)
    local v3 = copy(p1);
    table.sort(v3, p2);

    return v3;
end;