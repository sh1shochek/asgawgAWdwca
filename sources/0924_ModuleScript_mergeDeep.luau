-- Decompiled with Potassium's decompiler.

local None = require(script.Parent.Parent.None);
local copyDeep = require(script.Parent.copyDeep);

local function mergeDeep(...) -- Line: 28
    -- upvalues: None (copy), copyDeep (copy), mergeDeep (copy)
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);
        local v3;

        if type(v2) == "table" then
            v3 = i;

            for i2, v in pairs(v2) do
                if v == None then
                    v1[i2] = nil;
                elseif type(v) == "table" then
                    if v1[i2] == nil or type(v1[i2]) ~= "table" then
                        v1[i2] = copyDeep(v);
                    else
                        v1[i2] = mergeDeep(v1[i2], v);
                    end;
                else
                    v1[i2] = v;
                end;
            end;
        else
            v3 = i;
        end;
    end;

    return v1;
end;

return mergeDeep;