-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: function) -- Line: 20, Name: map
    local v3 = {};

    for i, v in ipairs(p1) do
        local v4 = p2(v, i, p1);

        if v4 ~= nil then
            table.insert(v3, v4);
        end;
    end;

    return v3;
end;