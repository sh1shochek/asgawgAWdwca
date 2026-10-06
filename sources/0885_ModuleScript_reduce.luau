-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function, p3: any) -- Line: 27, Name: reduce
    local v4;

    if p3 == nil then
        p3 = p1[1];
        v4 = 2;
    else
        v4 = 1;
    end;

    for i = v4, #p1 do
        p3 = p2(p3, p1[i], i, p1);
        local _ = i;
    end;

    return p3;
end;