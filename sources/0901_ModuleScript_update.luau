-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Util);
local copy = require(script.Parent.copy);

local function call(p1: function, p2: number) -- Line: 10
    if type(p1) == "function" then
        return p1(p2);
    end;
end;

return function(p3: table, p4: number, p5: function?, p6: function?) -- Line: 44, Name: update
    -- upvalues: copy (copy), Util (copy)
    local v7 = #p3;
    local v8 = copy(p3);

    if p4 < 1 then
        p4 = p4 + v7;
    end;

    if type(p5) ~= "function" then
        p5 = Util.func.returned;
    end;

    if v8[p4] ~= nil then
        v8[p4] = p5(v8[p4], p4);

        return v8;
    end;

    local v9;

    if type(p6) == "function" then
        v9 = p6(p4);
    else
        v9 = nil;
    end;

    v8[p4] = v9;

    return v8;
end;