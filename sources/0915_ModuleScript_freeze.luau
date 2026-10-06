-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local copy = require(script.Parent.copy);

return function(p1) -- Line: 23, Name: freeze
    -- upvalues: copy (copy)
    local v2 = copy(p1);
    table.freeze(v2);

    return v2;
end;