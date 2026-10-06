-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

local function freezeDeep(p1) -- Line: 22
    -- upvalues: freezeDeep (copy)
    local v2 = {};

    for i, v in pairs(p1) do
        if type(v) == "table" then
            v2[i] = freezeDeep(v);
        else
            v2[i] = v;
        end;
    end;

    table.freeze(v2);

    return v2;
end;

return freezeDeep;