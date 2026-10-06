-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1, ...) -- Line: 21, Name: differenceSymmetric
    local table_clone_ret = table.clone(p1);

    for _, v in { ... } do
        if typeof(v) == "table" then
            for i in v do
                table_clone_ret[i] = table_clone_ret[i] == nil;
            end;
        end;
    end;

    for i, v in table_clone_ret do
        table_clone_ret[i] = v and true or nil;
    end;

    return table_clone_ret;
end;