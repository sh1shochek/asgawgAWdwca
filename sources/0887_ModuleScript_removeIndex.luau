-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number) -- Line: 19, Name: removeIndex
    local v3 = #p1;
    local v4 = {};

    if p2 < 1 then
        p2 = p2 + v3;
    end;

    for i, v in ipairs(p1) do
        if i ~= p2 then
            table.insert(v4, v);
        end;
    end;

    return v4;
end;