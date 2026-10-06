-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);

return function(p1: table, p2: function?) -- Line: 24, Name: filter
    -- upvalues: Util (copy)
    local v3 = {};

    if type(p2) ~= "function" then
        p2 = Util.func.truthy;
    end;

    for i, v in pairs(p1) do
        if p2(v, i, p1) then
            v3[i] = v;
        end;
    end;

    return v3;
end;