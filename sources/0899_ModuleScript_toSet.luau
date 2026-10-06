-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1: table) -- Line: 20, Name: toSet
    local v2 = {};

    for _, v in ipairs(p1) do
        v2[v] = true;
    end;

    return v2;
end;