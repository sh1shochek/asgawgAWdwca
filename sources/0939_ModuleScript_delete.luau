-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 20, Name: delete
    local v2 = {};

    for i, _ in pairs(p1) do
        v2[i] = true;
    end;

    for _, v in ipairs({ ... }) do
        v2[v] = nil;
    end;

    return v2;
end;