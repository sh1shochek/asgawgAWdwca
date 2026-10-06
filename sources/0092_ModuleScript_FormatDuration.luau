-- Decompiled with Potassium's decompiler.

return function(p1: number, p2: string?) -- Line: 5
    local v3 = p2 or "Never";
    local math_floor_ret = math.floor(p1);
    local math_max_ret = math.max(0, math_floor_ret);
    local math_floor_ret2 = math.floor(math_max_ret / 86400);
    local v4;

    if v3 == "Never" then
        v4 = math.floor(math_max_ret / 3600);
    else
        v4 = math.floor(math_max_ret % 86400 / 3600);
    end;

    local math_floor_ret3 = math.floor(math_max_ret % 3600 / 60);
    local v5 = math_max_ret % 60;

    if v3 == "Always" or v3 == "IfNeeded" and math_floor_ret2 > 0 then
        return string.format("%02d:%02d:%02d:%02d", math_floor_ret2, v4, math_floor_ret3, v5);
    end;

    return string.format("%02d:%02d:%02d", v4, math_floor_ret3, v5);
end;