-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number?, p3: number?, ...) -- Line: 22, Name: splice
    local v4 = #p1;
    local v5 = {};
    local v6 = type(p2) ~= "number" and 1 or p2;

    if type(p3) ~= "number" then
        p3 = v4;
    end;

    if v6 < 1 then
        v6 = v6 + v4;
    end;

    if p3 < 1 then
        p3 = p3 + v4;
    end;

    for i = 1, v6 - 1 do
        table.insert(v5, p1[i]);
        local _ = i;
    end;

    for _, v in ipairs({ ... }) do
        table.insert(v5, v);
    end;

    for i = p3 + 1, v4 do
        table.insert(v5, p1[i]);
        local _ = i;
    end;

    return v5;
end;