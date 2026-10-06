-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 6
    local v3 = {};

    for i = 1, #p1 do
        local v4;

        if p2(i, p1[i]) then
            table.insert(v3, i);
            v4 = i;
        else
            v4 = i;
        end;
    end;

    for i = #v3, 1, -1 do
        table.remove(p1, v3[i]);
        local _ = i;
    end;

    return p1;
end;