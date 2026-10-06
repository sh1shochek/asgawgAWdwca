-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function, p3: any) -- Line: 28, Name: reduceRight
    local v4 = #p1;

    if p3 == nil then
        p3 = p1[v4];
        v4 = v4 - 1;
    end;

    for i = v4, 1, -1 do
        p3 = p2(p3, p1[i], i, p1);
        local _ = i;
    end;

    return p3;
end;