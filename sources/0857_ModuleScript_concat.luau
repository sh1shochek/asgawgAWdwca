-- Decompiled with Potassium's decompiler.

local None = require(script.Parent.Parent.None);

return function(...) -- Line: 26, Name: concat
    -- upvalues: None (copy)
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);
        local v3;

        if type(v2) == "table" then
            v3 = i;

            for _, v in ipairs(v2) do
                if v ~= None then
                    table.insert(v1, v);
                end;
            end;
        else
            v3 = i;
        end;
    end;

    return v1;
end;