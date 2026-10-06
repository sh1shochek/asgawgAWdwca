-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number?) -- Line: 20, Name: pop
    local v3 = {};

    for i = 1, #p1 - (type(p2) ~= "number" and 1 or p2) do
        table.insert(v3, p1[i]);
        local _ = i;
    end;

    return v3;
end;