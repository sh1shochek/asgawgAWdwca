-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: toArray
    local v2 = {};

    for i, _ in pairs(p1) do
        table.insert(v2, i);
    end;

    return v2;
end;