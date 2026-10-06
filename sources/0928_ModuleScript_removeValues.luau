-- Decompiled with Potassium's decompiler.

local toSet = require(script.Parent.Parent.Array.toSet);

return function(p1: table, ...) -- Line: 23, Name: removeValues
    -- upvalues: toSet (copy)
    local v2 = toSet({ ... });
    local v3 = {};

    for i, v in pairs(p1) do
        if not v2[v] then
            v3[i] = v;
        end;
    end;

    return v3;
end;