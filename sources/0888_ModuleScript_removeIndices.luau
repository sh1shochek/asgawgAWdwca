-- Decompiled with Potassium's decompiler.

return function(p1: table, ...) -- Line: 19, Name: removeIndices
    local v2 = #p1;
    local v3 = {};
    local v4 = {};

    for _, v in ipairs({ ... }) do
        local v5;

        if v < 1 then
            v5 = v + v2;
        else
            v5 = v;
        end;

        v3[v5] = true;
    end;

    for i, v in ipairs(p1) do
        if not v3[i] then
            table.insert(v4, v);
        end;
    end;

    return v4;
end;