-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number, p3: any) -- Line: 20, Name: set
    local v4 = #p1;
    local v5 = {};

    if p2 < 1 then
        p2 = p2 + v4;
    end;

    for i, v in ipairs(p1) do
        if i == p2 then
            table.insert(v5, p3);
        else
            table.insert(v5, v);
        end;
    end;

    return v5;
end;