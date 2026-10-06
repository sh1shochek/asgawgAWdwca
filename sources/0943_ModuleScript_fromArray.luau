-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 20, Name: fromArray
    local table_create_ret = table.create(#p1);

    for _, v in ipairs(p1) do
        table_create_ret[v] = true;
    end;

    return table_create_ret;
end;