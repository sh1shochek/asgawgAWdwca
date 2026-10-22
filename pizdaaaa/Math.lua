-- ReplicatedStorage.Shared.Utility.Math
-- Script path: ReplicatedStorage.Shared.Utility.Math
-- Decompile time: 6.86 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function AngleAbs(p2) -- Line: 10
    while p2 < 0 do
        p2 = p2 + 6.283185307179586;
    end;

    while p2 > 6.283185307179586 do
        p2 = p2 - 6.283185307179586;
    end;

    return p2;
end;

local function AngleShortest(p3, p4) -- Line: 20
    local v5 = p4 - p3;

    while v5 < 0 do
        v5 = v5 + 6.283185307179586;
    end;

    while v5 > 6.283185307179586 do
        v5 = v5 - 6.283185307179586;
    end;

    local v6 = p3 - p4;

    while v6 < 0 do
        v6 = v6 + 6.283185307179586;
    end;

    while v6 > 6.283185307179586 do
        v6 = v6 - 6.283185307179586;
    end;

    local v7 = -v6;

    if math.abs(v5) > math.abs(v7) then
        v5 = v7 or v5;
    end;

    return v5;
end;

local buffer_create_ret = buffer.create(4);

function u1.f32(p8: number) -- Line: 32
    -- upvalues: buffer_create_ret (copy)
    buffer.writef32(buffer_create_ret, 0, p8);

    return buffer.readf32(buffer_create_ret, 0);
end;

local u9 = u1.f32(0.99999988);

function u1.UniformRandomStream(p10: number) -- Line: 52
    -- upvalues: u1 (copy), u9 (copy)
    local u11 = p10 < 0 and p10 or -p10;
    local u12 = 0;
    local table_create_ret = table.create(32, 0);

    local function Generate() -- Line: 57
        -- upvalues: u11 (ref), u12 (ref), table_create_ret (copy)
        if u11 <= 0 or u12 == 0 then
            u11 = -u11 < 1 and 1 or -u11;

            for i = 39, 0, -1 do
                local v13 = u11 // 127773;
                u11 = 16807 * (u11 - v13 * 127773) - 2836 * v13;

                if u11 < 0 then
                    u11 = u11 + 2147483647;
                end;

                local v14;

                if i < 32 then
                    table_create_ret[i + 1] = u11;
                    v14 = i;
                else
                    v14 = i;
                end;
            end;

            u12 = table_create_ret[1];
        end;

        local v15 = u11 // 127773;
        u11 = 16807 * (u11 - v15 * 127773) - 2836 * v15;

        if u11 < 0 then
            u11 = u11 + 2147483647;
        end;

        local v16 = u12 // 67108864;
        u12 = table_create_ret[v16 + 1];
        table_create_ret[v16 + 1] = u11;

        return u12;
    end;

    return function(p17: number, p18: number) -- Line: 91
        -- upvalues: u1 (ref), Generate (copy), u9 (ref)
        local v19 = u1.f32(Generate() * 4.656612875245797e-10);

        if v19 > 0.99999988 then
            v19 = u9;
        end;

        return u1.f32(u1.f32(v19 * u1.f32(p18 - p17)) + p17);
    end;
end;

function u1.DeltaAngle(p20, p21) -- Line: 104
    local v22 = p21 - p20;

    while v22 < 0 do
        v22 = v22 + 6.283185307179586;
    end;

    while v22 > 6.283185307179586 do
        v22 = v22 - 6.283185307179586;
    end;

    local v23 = p20 - p21;

    while v23 < 0 do
        v23 = v23 + 6.283185307179586;
    end;

    while v23 > 6.283185307179586 do
        v23 = v23 - 6.283185307179586;
    end;

    local v24 = -v23;

    if math.abs(v22) > math.abs(v24) then
        v22 = v24 or v22;
    end;

    return v22;
end;

function u1.LerpAngle(p25, p26, p27) -- Line: 108
    local v28 = p26 - p25;

    while v28 < 0 do
        v28 = v28 + 6.283185307179586;
    end;

    while v28 > 6.283185307179586 do
        v28 = v28 - 6.283185307179586;
    end;

    local v29 = p25 - p26;

    while v29 < 0 do
        v29 = v29 + 6.283185307179586;
    end;

    while v29 > 6.283185307179586 do
        v29 = v29 - 6.283185307179586;
    end;

    local v30 = -v29;

    if math.abs(v28) > math.abs(v30) then
        v28 = v30 or v28;
    end;

    return p25 + v28 * p27;
end;

function u1.Friction(p31: number, p32: number, p33: number) -- Line: 112
    return 1 / (p33 / p32 + 1) * p31;
end;

function u1.Approach(p34: number, p35: number, p36: number) -- Line: 116
    local v37 = p34 - p35;

    if p36 < v37 then
        return p35 + p36;
    end;

    if v37 < -p36 then
        return p35 - p36;
    end;

    return p34;
end;

function u1.CalculateRoll(p38: number, p39: vector, p40: number, p41: number) -- Line: 132
    local math_cos_ret = math.cos(p38);
    local v42 = -math.sin(p38);
    local vector_create_ret = vector.create(math_cos_ret, 0, v42);
    local vector_dot_ret = vector.dot(p39, vector_create_ret);
    local math_abs_ret = math.abs(vector_dot_ret);

    if math_abs_ret < p41 then
        p40 = math_abs_ret * p40 / p41 or p40;
    end;

    return p40 * math.sign(vector_dot_ret);
end;

function u1.DecayAngles(p43: vector, p44: number, p45: number, p46: number) -- Line: 145
    local v47 = p45 * p46;
    local v48 = p43 * math.exp(-p44 * p46);
    local vector_magnitude_ret = vector.magnitude(v48);

    return vector_magnitude_ret <= v47 and Vector3.new(0, 0, 0) or v48 * (1 - v47 / vector_magnitude_ret);
end;

function u1.RemapValueClamped(p49: number, p50: number, p51: number, p52: number, p53: number) -- Line: 158
    local math_map_ret = math.map(p49, p50, p51, p52, p53);

    return math.clamp(math_map_ret, p52, p53);
end;

function u1.VelocityFriction(p54: vector, p55: number, p56: number) -- Line: 166
    -- upvalues: u1 (copy)
    local v57 = u1.Friction(vector.magnitude(p54), p55, p56);

    return v57 < 0.001 and Vector3.new(0, 0, 0) or vector.normalize(p54) * v57;
end;

function u1.SimpleSpline(p58: number) -- Line: 175
    local v59 = p58 * p58;

    return v59 * 3 - v59 * 2 * p58;
end;

function u1.SmoothLerp(p60, p61, p62, p63) -- Line: 183
    local v64 = 1 - (1 - p62) ^ p63;

    if type(p60) == "number" then
        return (1 - v64) * p60 + p61 * v64;
    end;

    return p60 + (p61 - p60) * v64;
end;

return u1;