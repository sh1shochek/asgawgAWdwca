-- Decompiled with Potassium's decompiler.

local function format(p1: number) -- Line: 2
    return string.format("%02i", p1);
end;

return function(p2: number) -- Line: 9
    local math_floor_ret = math.floor(p2 / 60);

    return string.format("%02i", math_floor_ret) .. ":" .. string.format("%02i", p2 % 60);
end;