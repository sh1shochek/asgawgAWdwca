-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number?) -- Line: 20, Name: shift
    local v3 = {};

    for i = type(p2) ~= "number" and 2 or p2 + 1, #p1 do
        table.insert(v3, p1[i]);
        local _ = i;
    end;

    return v3;
end;