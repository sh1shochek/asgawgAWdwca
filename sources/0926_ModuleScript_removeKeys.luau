-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table, ...) -- Line: 20, Name: removeKeys
    -- upvalues: copy (copy)
    local v2 = copy(p1);

    for _, v in ipairs({ ... }) do
        v2[v] = nil;
    end;

    return v2;
end;