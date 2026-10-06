-- Decompiled with Potassium's decompiler.

local None = require(script.Parent.Parent.None);

return function(...) -- Line: 27, Name: merge
    -- upvalues: None (copy)
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);
        local v3;

        if type(v2) == "table" then
            v3 = i;

            for i2, v in pairs(v2) do
                local v4;

                if v == None then
                    v4 = nil;
                else
                    v4 = v;
                end;

                v1[i2] = v4;
            end;
        else
            v3 = i;
        end;
    end;

    return v1;
end;