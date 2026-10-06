-- Decompiled with Potassium's decompiler.

local function distanceWithin(p1: string, p2: string, p3: number) -- Line: 3
    if p3 < math.abs(#p1 - #p2) then
        return p3 + 1;
    end;

    local v4 = {};
    local v5 = {};

    for i = 0, #p2 do
        v4[i] = i;
        local _ = i;
    end;

    for i = 1, #p1 do
        v5[0] = i;
        local v6 = i;
        local v7 = v6;
        local v8 = v6;
        v6 = v7;
        v8 = v7;

        for i2 = 1, #p2 do
            local v9 = string.byte(p1, v7) == string.byte(p2, i2) and 0 or 1;
            v5[i2] = math.min(v4[i2] + 1, v5[i2 - 1] + 1, v4[i2 - 1] + v9);
            v6 = math.min(v6, v5[i2]);
            local _ = i2;
        end;

        if p3 < v6 then
            return p3 + 1;
        end;

        local v10 = v4;
        v4 = v5;
        v5 = v10;
    end;

    return v4[#p2];
end;

return function(p11: table, p12: string, p13: number) -- Line: 28
    -- upvalues: distanceWithin (copy)
    if p12 == "" then
        return nil;
    end;

    local v14 = (1 / 0);
    local v15 = (1 / 0);
    local v16 = nil;

    for _, v in p11 do
        local v17 = (1 / 0);
        local v18 = (1 / 0);
        local string_find_ret = string.find(v, p12, 1, true);

        if string_find_ret == 1 then
            string_find_ret = #v;
            v17 = 1;
        elseif string_find_ret then
            v17 = 2;
        elseif v14 >= 3 and p13 <= #p12 then
            string_find_ret = distanceWithin(p12, v, 3);

            if string_find_ret <= 3 then
                v17 = 3;
            else
                string_find_ret = v18;
            end;
        else
            string_find_ret = v18;
        end;

        if v17 < v14 or v17 == v14 and string_find_ret < v15 then
            v16 = v;
            v15 = string_find_ret;
            v14 = v17;
        end;
    end;

    return v16;
end;