-- Decompiled with Potassium's decompiler.

local function copyDeep(p1) -- Line: 20
    -- upvalues: copyDeep (copy)
    local table_clone_ret = table.clone(p1);

    for i, v in pairs(p1) do
        if type(v) == "table" then
            table_clone_ret[i] = copyDeep(v);
        end;
    end;

    return table_clone_ret;
end;

return copyDeep;