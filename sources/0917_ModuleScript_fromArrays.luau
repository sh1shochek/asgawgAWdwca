-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: table) -- Line: 20, Name: fromArrays
    local v3 = {};

    for i = 1, #p1 do
        v3[p1[i]] = p2[i];
        local _ = i;
    end;

    return v3;
end;