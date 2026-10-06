-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 22, Name: push
    local v2 = {};

    for _, v in ipairs(p1) do
        table.insert(v2, v);
    end;

    for _, v in ipairs({ ... }) do
        table.insert(v2, v);
    end;

    return v2;
end;