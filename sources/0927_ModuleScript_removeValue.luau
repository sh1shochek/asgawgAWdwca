-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: any) -- Line: 19, Name: removeValue
    local v3 = {};

    for i, v in pairs(p1) do
        if v ~= p2 then
            v3[i] = v;
        end;
    end;

    return v3;
end;