-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.freeze
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.freeze
-- Decompile time: 5.24 ms

-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table) -- Line: 22, Name: freeze
    -- upvalues: copy (copy)
    local v2 = copy(p1);
    table.freeze(v2);

    return v2;
end;