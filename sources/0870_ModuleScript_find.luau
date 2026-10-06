-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: any, p3: number?) -- Line: 25, Name: find
    local v4 = #p1;

    if type(p3) == "number" then
        if p3 < 1 then
            p3 = v4 + p3;
        end;
    else
        p3 = 1;
    end;

    return table.find(p1, p2, p3);
end;