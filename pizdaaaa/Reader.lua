-- ReplicatedStorage.Shared.Utility.BufferScheme.Reader
-- Script path: ReplicatedStorage.Shared.Utility.BufferScheme.Reader
-- Decompile time: 4.85 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function ReadHalf(p2: buffer, p3: number) -- Line: 15
    local buffer_readu16_ret = buffer.readu16(p2, p3);
    local v4 = buffer_readu16_ret % 32768;
    local v5;

    if v4 == 31744 then
        v5 = buffer_readu16_ret // 32768 == 1 and (-1 / 0) or (1 / 0);
    elseif v4 == 64512 then
        v5 = (0 / 0);
    elseif v4 == 0 then
        v5 = 0;
    else
        local v6 = v4 % 1024;
        local v7 = v4 // 1024;
        local v8;

        if v7 == 0 then
            v8 = v6 / 1024;
        else
            v8 = v6 / 2048 + 0.5;
        end;

        v5 = math.ldexp(v8, v7 - 14);

        if buffer_readu16_ret // 32768 == 1 then
            v5 = -v5;
        end;
    end;

    return v5, p3 + 2;
end;

function u1.vector(p9, p10) -- Line: 37
    local buffer_readf32_ret = buffer.readf32(p9, p10);
    local v11 = p10 + 4;
    local buffer_readf32_ret2 = buffer.readf32(p9, v11);
    local v12 = v11 + 4;
    local buffer_readf32_ret3 = buffer.readf32(p9, v12);

    return vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3), v12 + 4;
end;

function u1.boolean(p13, p14) -- Line: 50
    return buffer.readu8(p13, p14) == 1, p14 + 1;
end;

function u1.float32(p15, p16) -- Line: 57
    return buffer.readf32(p15, p16), p16 + 4;
end;

function u1.i8(p17, p18) -- Line: 64
    return buffer.readu8(p17, p18), p18 + 1;
end;

function u1.u8(p19, p20) -- Line: 71
    return buffer.readu8(p19, p20), p20 + 1;
end;

function u1.u16(p21, p22) -- Line: 78
    return buffer.readu16(p21, p22), p22 + 2;
end;

function u1.u32(p23, p24) -- Line: 85
    return buffer.readu32(p23, p24), p24 + 4;
end;

function u1.string(p25, p26) -- Line: 92
    local buffer_readu16_ret = buffer.readu16(p25, p26);

    return buffer.readstring(p25, p26 + 2, buffer_readu16_ret), p26 + 2 + buffer_readu16_ret;
end;

function u1.unorm8(p27: buffer, p28: number) -- Line: 97
    return buffer.readu8(p27, p28) / 255, p28 + 1;
end;

function u1.half(p29: buffer, p30: number) -- Line: 101
    -- upvalues: ReadHalf (copy)
    return ReadHalf(p29, p30);
end;

function u1.half3(p31: buffer, p32: number) -- Line: 105
    -- upvalues: ReadHalf (copy)
    local v33, v34 = ReadHalf(p31, p32);
    local v35, v36 = ReadHalf(p31, v34);
    local v37, v38 = ReadHalf(p31, v36);

    return vector.create(v33, v35, v37), v38;
end;

function u1.fixed16_128(p39: buffer, p40: number) -- Line: 112
    return buffer.readu16(p39, p40) / 65535 * 256 - 128, p40 + 2;
end;

function u1.fixed16_128_3(p41: buffer, p42: number) -- Line: 116
    -- upvalues: u1 (copy)
    local v43, v44 = u1.fixed16_128(p41, p42);
    local v45, v46 = u1.fixed16_128(p41, v44);
    local v47, v48 = u1.fixed16_128(p41, v46);

    return vector.create(v43, v45, v47), v48;
end;

function u1.angle16(p49: buffer, p50: number) -- Line: 123
    return buffer.readu16(p49, p50) / 65535 * 6.283185307179586 - 3.141592653589793, p50 + 2;
end;

return table.freeze(u1);