-- Decompiled with Potassium's decompiler.

return function(p1: number) -- Line: 3
    local v2;

    if p1 % 1 == 0 then
        v2 = tostring(p1);
    else
        v2 = string.format("%.2f", p1);
    end;

    return v2:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "");
end;