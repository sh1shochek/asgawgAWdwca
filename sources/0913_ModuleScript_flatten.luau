-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

local function flatten(p1: any, p2: number?) -- Line: 30
    -- upvalues: flatten (copy)
    local v3 = type(p2) ~= "number" and (1 / 0) or p2;
    local v4 = {};

    for i, v in pairs(p1) do
        if type(v) == "table" and v3 > 0 then
            local v5 = flatten(v, v3 - 1);

            for i2, v2 in pairs(v4) do
                v5[i2] = v2;
            end;

            v4 = v5;
        else
            v4[i] = v;
        end;
    end;

    return v4;
end;

return flatten;