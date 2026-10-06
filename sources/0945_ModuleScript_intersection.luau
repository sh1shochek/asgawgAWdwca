-- Decompiled with Potassium's decompiler.

return function(...) -- Line: 20, Name: intersection
    local v1 = select("#", ...);
    local v2 = select(1, ...);
    local v3 = {};

    for i, _ in pairs(v2) do
        local v4 = i;
        local v5 = true;

        for i2 = 2, v1 do
            if select(i2, ...)[v4] ~= true then
                v5 = false;
                break;
            end;

            local _ = i2;
        end;

        if v5 then
            v3[v4] = true;
        end;
    end;

    return v3;
end;