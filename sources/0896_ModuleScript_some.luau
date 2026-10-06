-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 24, Name: some
    for i, v in ipairs(p1) do
        if p2(v, i, p1) then
            return true;
        end;
    end;

    return false;
end;