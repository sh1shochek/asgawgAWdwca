-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: any) -- Line: 18, Name: removeValue
    local v3 = {};

    for _, v in ipairs(p1) do
        if v ~= p2 then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;