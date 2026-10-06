-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, p2: any, p3: function?, p4: function?) -- Line: 30, Name: update
    -- upvalues: copy (copy)
    local v5 = copy(p1);

    if v5[p2] then
        if p3 then
            v5[p2] = p3(v5[p2], p2);

            return v5;
        end;
    elseif typeof(p4) == "function" then
        v5[p2] = p4(p2);
    end;

    return v5;
end;