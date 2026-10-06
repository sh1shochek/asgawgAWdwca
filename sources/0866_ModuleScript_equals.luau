-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);

local function compare(p1, p2) -- Line: 6
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 == p2;
    end;

    local v3 = #p1;

    if #p2 ~= v3 then
        return false;
    end;

    for i = 1, v3 do
        if p1[i] ~= p2[i] then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;

return function(...) -- Line: 44, Name: equals
    -- upvalues: Util (copy), compare (copy)
    if Util.equalObjects(...) then
        return true;
    end;

    local v4 = select("#", ...);
    local v5 = select(1, ...);

    for i = 2, v4 do
        if not compare(v5, (select(i, ...))) then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;