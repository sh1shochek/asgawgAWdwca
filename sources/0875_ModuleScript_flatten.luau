-- Decompiled with Potassium's decompiler.

local function flatten(p1: table, p2: number?) -- Line: 24
    -- upvalues: flatten (copy)
    local v3 = type(p2) ~= "number" and (1 / 0) or p2;
    local v4 = {};

    for _, v in ipairs(p1) do
        if type(v) == "table" and v3 > 0 then
            local v5 = flatten(v, v3 - 1);

            for _, v2 in ipairs(v5) do
                table.insert(v4, v2);
            end;
        else
            table.insert(v4, v);
        end;
    end;

    return v4;
end;

return flatten;