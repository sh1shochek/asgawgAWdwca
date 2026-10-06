-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
local Util = require(Parent.Util);
require(Parent.Types);

local function compare(p1, p2) -- Line: 7
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 == p2;
    end;

    for i, v in pairs(p1) do
        if p2[i] ~= v then
            return false;
        end;
    end;

    for i, v in pairs(p2) do
        if p1[i] ~= v then
            return false;
        end;
    end;

    return true;
end;

return function(...) -- Line: 45, Name: equals
    -- upvalues: Util (copy), compare (copy)
    if Util.equalObjects(...) then
        return true;
    end;

    local v3 = select("#", ...);
    local v4 = select(1, ...);

    for i = 2, v3 do
        if not compare(v4, (select(i, ...))) then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;