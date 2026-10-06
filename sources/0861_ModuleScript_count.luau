-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);

return function(p1: table, p2: function?) -- Line: 25, Name: count
    -- upvalues: Util (copy)
    local v3 = 0;

    if type(p2) ~= "function" then
        p2 = Util.func.truthy;
    end;

    for i, v in ipairs(p1) do
        if p2(v, i, p1) then
            v3 = v3 + 1;
        end;
    end;

    return v3;
end;