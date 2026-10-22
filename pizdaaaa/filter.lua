-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.filter
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.filter
-- Decompile time: 5.99 ms

-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);

return function(p1: table, p2: function?) -- Line: 26, Name: filter
    -- upvalues: Util (copy)
    local v3 = {};

    if type(p2) ~= "function" then
        p2 = Util.func.truthy;
    end;

    for i, v in ipairs(p1) do
        if p2(v, i, p1) then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;