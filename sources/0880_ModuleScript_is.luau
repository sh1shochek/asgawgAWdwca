-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 21, Name: is
    local v2;

    if typeof(p1) == "table" and #p1 > 0 then
        v2 = next(p1, #p1) == nil;
    else
        v2 = false;
    end;

    return v2;
end;