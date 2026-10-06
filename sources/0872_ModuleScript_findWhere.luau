-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function, p3: number?) -- Line: 21, Name: findWhere
    local v4 = #p1;

    if type(p3) == "number" then
        if p3 < 1 then
            p3 = v4 + p3;
        end;
    else
        p3 = 1;
    end;

    for i = p3, #p1 do
        if p2(p1[i], i, p1) then
            return i;
        end;

        local _ = i;
    end;
end;