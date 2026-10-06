-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: number, ...) -- Line: 21, Name: insert
    local v3 = #p1;

    if p2 < 1 then
        p2 = p2 + (v3 + 1);
    end;

    if v3 < p2 then
        if v3 + 1 < p2 then
            return p1;
        end;

        p2 = v3 + 1;
        v3 = v3 + 1;
    end;

    local v4 = {};

    for i = 1, v3 do
        local v5;

        if i == p2 then
            v5 = i;

            for _, v in ipairs({ ... }) do
                table.insert(v4, v);
            end;
        else
            v5 = i;
        end;

        table.insert(v4, p1[v5]);
    end;

    return v4;
end;