-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
local copyDeep = require(script.Parent.copyDeep);
local None = require(Parent.None);

return function(...) -- Line: 28, Name: concatDeep
    -- upvalues: None (copy), copyDeep (copy)
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);
        local v3;

        if type(v2) == "table" then
            v3 = i;

            for _, v in ipairs(v2) do
                if v ~= None then
                    if type(v) == "table" then
                        table.insert(v1, copyDeep(v));
                    else
                        table.insert(v1, v);
                    end;
                end;
            end;
        else
            v3 = i;
        end;
    end;

    return v1;
end;