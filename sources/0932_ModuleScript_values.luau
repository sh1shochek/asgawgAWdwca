-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: values
    local v2 = {};

    for _, v in pairs(p1) do
        table.insert(v2, v);
    end;

    return v2;
end;