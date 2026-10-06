-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: any, p3: number?) -- Line: 20, Name: findLast
    local v4 = #p1;

    if type(p3) == "number" then
        if p3 < 1 then
            p3 = v4 + p3;
        end;
    else
        p3 = v4;
    end;

    for i = p3, 1, -1 do
        if p1[i] == p2 then
            return i;
        end;

        local _ = i;
    end;
end;