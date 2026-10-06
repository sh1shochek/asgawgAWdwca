-- Decompiled with Potassium's decompiler.

local function freezeDeep(p1: table) -- Line: 21
    -- upvalues: freezeDeep (copy)
    local v2 = {};

    for i = 1, #p1 do
        local v3 = p1[i];
        local v4;

        if type(v3) == "table" then
            table.insert(v2, freezeDeep(v3));
            v4 = i;
        else
            table.insert(v2, v3);
            v4 = i;
        end;
    end;

    table.freeze(v2);

    return v2;
end;

return freezeDeep;