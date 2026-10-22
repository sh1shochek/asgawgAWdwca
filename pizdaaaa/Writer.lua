-- ReplicatedStorage.Shared.Utility.BufferScheme.Writer
-- Script path: ReplicatedStorage.Shared.Utility.BufferScheme.Writer
-- Decompile time: 7.17 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function WriteHalf(p2: buffer, p3: number, p4: number) -- Line: 15
    if p4 > 65504 then
        buffer.writeu16(p2, p3, 31744);
    elseif p4 < -65504 then
        buffer.writeu16(p2, p3, 64512);
    elseif p4 == p4 then
        if p4 == 0 then
            buffer.writeu16(p2, p3, 0);
        else
            local math_abs_ret = math.abs(p4);
            local math_log_ret = math.log(math_abs_ret, 2);
            local v5 = math.floor(math_log_ret) - 10;
            local math_ldexp_ret = math.ldexp(1, v5);
            local math_frexp_ret, v6 = math.frexp(math_abs_ret // math_ldexp_ret * math_ldexp_ret);
            local v7 = v6 + 14;
            local v8;

            if v7 <= 0 then
                local math_abs_ret2 = math.abs(v7);
                v8 = math_frexp_ret * 1024 / math.ldexp(1, math_abs_ret2);
            else
                v8 = math_frexp_ret * 2048;
            end;

            local v9 = math.round(v8) % 1024 + math.max(v7, 0) * 1024;
            buffer.writeu16(p2, p3, v9 + (p4 < 0 and 32768 or 0));
        end;
    else
        buffer.writeu16(p2, p3, 64513);
    end;

    return p3 + 2;
end;

function u1.vector(p10, p11, p12) -- Line: 44
    buffer.writef32(p10, p11, p12.X);
    local v13 = p11 + 4;
    buffer.writef32(p10, v13, p12.Y);
    local v14 = v13 + 4;
    buffer.writef32(p10, v14, p12.Z);

    return v14 + 4;
end;

function u1.boolean(p15, p16, p17) -- Line: 57
    buffer.writeu8(p15, p16, p17 and 1 or 0);

    return p16 + 1;
end;

function u1.float32(p18, p19, p20) -- Line: 64
    buffer.writef32(p18, p19, p20);

    return p19 + 4;
end;

function u1.i8(p21, p22, p23) -- Line: 71
    buffer.writei8(p21, p22, p23);

    return p22 + 1;
end;

function u1.u8(p24, p25, p26) -- Line: 78
    buffer.writeu8(p24, p25, p26);

    return p25 + 1;
end;

function u1.u16(p27, p28, p29) -- Line: 85
    buffer.writeu16(p27, p28, p29);

    return p28 + 2;
end;

function u1.u32(p30, p31, p32) -- Line: 92
    buffer.writeu32(p30, p31, p32);

    return p31 + 4;
end;

function u1.string(p33, p34, p35) -- Line: 99
    if typeof(p35) ~= "string" then
        p35 = tostring(p35);
    end;

    local v36 = #p35;
    assert(v36 <= 65535, "[BufferScheme] string exceeds u16 length");
    buffer.writeu16(p33, p34, v36);
    buffer.writestring(p33, p34 + 2, p35, v36);

    return p34 + 2 + v36;
end;

function u1.unorm8(p37: buffer, p38: number, p39: number) -- Line: 108
    local math_round_ret = math.round(p39 * 255);
    local math_clamp_ret = math.clamp(math_round_ret, 0, 255);
    buffer.writeu8(p37, p38, math_clamp_ret);

    return p38 + 1;
end;

function u1.half(p40: buffer, p41: number, p42: number) -- Line: 113
    -- upvalues: WriteHalf (copy)
    return WriteHalf(p40, p41, p42);
end;

function u1.half3(p43: buffer, p44: number, p45: vector) -- Line: 117
    -- upvalues: WriteHalf (copy)
    local v46 = p45.Y or (p45.y or 0);
    local v47 = p45.Z or (p45.z or 0);

    return WriteHalf(p43, WriteHalf(p43, WriteHalf(p43, p44, p45.X or (p45.x or 0)), v46), v47);
end;

function u1.fixed16_128(p48: buffer, p49: number, p50: number) -- Line: 127
    local math_round_ret = math.round((p50 + 128) / 256 * 65535);
    local math_clamp_ret = math.clamp(math_round_ret, 0, 65535);
    buffer.writeu16(p48, p49, math_clamp_ret);

    return p49 + 2;
end;

function u1.fixed16_128_3(p51: buffer, p52: number, p53: vector) -- Line: 133
    -- upvalues: u1 (copy)
    local v54 = p53.Y or (p53.y or 0);
    local v55 = p53.Z or (p53.z or 0);
    local v56 = u1.fixed16_128(p51, p52, p53.X or (p53.x or 0));
    local v57 = u1.fixed16_128(p51, v56, v54);

    return u1.fixed16_128(p51, v57, v55);
end;

function u1.angle16(p58: buffer, p59: number, p60: number) -- Line: 146
    local v61 = math.round((p60 + 3.141592653589793) % 6.283185307179586 / 6.283185307179586 * 65535) % 65536;
    buffer.writeu16(p58, p59, v61);

    return p59 + 2;
end;

return table.freeze(u1);