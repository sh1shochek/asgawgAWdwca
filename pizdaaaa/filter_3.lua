-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.filter
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.filter
-- Decompile time: 2.13 ms

-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);

return function(p1: table, p2: function?) -- Line: 24, Name: filter
    -- upvalues: Util (copy)
    local v3 = {};

    if type(p2) ~= "function" then
        p2 = Util.func.truthy;
    end;

    for i, _ in pairs(p1) do
        if p2(i, p1) then
            v3[i] = true;
        end;
    end;

    return v3;
end;