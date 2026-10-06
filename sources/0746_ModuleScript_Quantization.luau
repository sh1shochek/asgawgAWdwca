-- Decompiled with Potassium's decompiler.

local u7 = {
    isFinite = function(p1) -- Line: 10, Name: isFinite
        local v2;

        if typeof(p1) == "number" then
            v2 = p1 - p1 == 0;
        else
            v2 = false;
        end;

        return v2;
    end,

    isFiniteVector2 = function(p3) -- Line: 14, Name: isFiniteVector2
        if typeof(p3) ~= "Vector2" then
            return false;
        end;

        local X = p3.X;
        local Y = p3.Y;
        local v4;

        if X - X == 0 then
            v4 = Y - Y == 0;
        else
            v4 = false;
        end;

        return v4;
    end,

    isFiniteVector3 = function(p5) -- Line: 22, Name: isFiniteVector3
        if typeof(p5) ~= "Vector3" then
            return false;
        end;

        local X = p5.X;
        local Y = p5.Y;
        local Z = p5.Z;
        local v6;

        if X - X == 0 and Y - Y == 0 then
            v6 = Z - Z == 0;
        else
            v6 = false;
        end;

        return v6;
    end
};

function u7.isVector3Within(p8: any, p9: number) -- Line: 30
    -- upvalues: u7 (copy)
    local v10 = u7.isFiniteVector3(p8);

    if v10 then
        if math.abs(p8.X) <= p9 and math.abs(p8.Y) <= p9 then
            v10 = math.abs(p8.Z) <= p9;
        else
            v10 = false;
        end;
    end;

    return v10;
end;

function u7.writeVector3F32(p11: buffer, p12: number, p13: vector) -- Line: 38
    buffer.writef32(p11, p12, p13.X);
    buffer.writef32(p11, p12 + 4, p13.Y);
    buffer.writef32(p11, p12 + 8, p13.Z);

    return p12 + 12;
end;

function u7.readVector3F32(p14: buffer, p15: number) -- Line: 45
    local buffer_readf32_ret = buffer.readf32(p14, p15);
    local buffer_readf32_ret2 = buffer.readf32(p14, p15 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p14, p15 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3), p15 + 12;
end;

function u7.canonicalMove(p16) -- Line: 54
    return Vector2.new(math.clamp(p16.X, -1, 1), (math.clamp(p16.Y, -1, 1)));
end;

function u7.quantizeSignedUnit(p17: number) -- Line: 59
    local v18 = math.clamp(p17, -1, 1) * 127;
    local math_round_ret = math.round(v18);

    return math.clamp(math_round_ret, -127, 127);
end;

function u7.dequantizeSignedUnit(p19: number) -- Line: 63
    return math.clamp(p19 / 127, -1, 1);
end;

function u7.quantizeYaw(p20: number) -- Line: 67
    return math.round(p20 % 6.283185307179586 / 6.283185307179586 * 65536) % 65536;
end;

function u7.dequantizeYaw(p21: number) -- Line: 72
    local v22 = p21 / 65536 * 6.283185307179586;

    if v22 >= 3.141592653589793 then
        return v22 - 6.283185307179586;
    end;

    return v22;
end;

function u7.quantizeUnitByte(p23: number) -- Line: 77
    local v24 = math.clamp(p23, 0, 1) * 255;
    local math_round_ret = math.round(v24);

    return math.clamp(math_round_ret, 0, 255);
end;

function u7.dequantizeUnitByte(p25: number) -- Line: 81
    return math.clamp(p25 / 255, 0, 1);
end;

function u7.quantizeNormal(p26: vector) -- Line: 85
    local v27 = p26.Magnitude <= 1e-8 and Vector3.new(0, 0, 0) or p26.Unit;

    return math.round(v27.X * 32767), math.round(v27.Y * 32767), math.round(v27.Z * 32767);
end;

function u7.dequantizeNormal(p28: number, p29: number, p30: number) -- Line: 90
    local Vector3_new_ret = Vector3.new(p28 / 32767, p29 / 32767, p30 / 32767);

    return Vector3_new_ret.Magnitude <= 1e-8 and Vector3.new(0, 0, 0) or Vector3_new_ret.Unit;
end;

return table.freeze(u7);