-- Decompiled with Potassium's decompiler.

local success, result = pcall(game.GetService, game, "EncodingService");

if not success then
    result = nil;
end;

local v1 = {};
local Zstd = Enum.CompressionAlgorithm.Zstd;
local u2 = game:GetService("RunService"):IsServer();
local u3 = u2 and 33554432 or 268435456;

local function ensureCapacity(p4: table, p5: number) -- Line: 43
    local v6 = p4.offset + p5;
    local buffer_len_ret = buffer.len(p4.buf);

    if v6 <= buffer_len_ret then
        return;
    end;

    local math_max_ret = math.max(buffer_len_ret * 2, v6);
    local buffer_create_ret = buffer.create(math_max_ret);
    buffer.copy(buffer_create_ret, 0, p4.buf, 0, p4.offset);
    p4.buf = buffer_create_ret;
end;

local function writeU8(p7: table, p8: number) -- Line: 56
    -- upvalues: ensureCapacity (copy)
    ensureCapacity(p7, 1);
    buffer.writeu8(p7.buf, p7.offset, p8);
    p7.offset = p7.offset + 1;
end;

local function writeU32(p9: table, p10: number) -- Line: 62
    -- upvalues: ensureCapacity (copy)
    ensureCapacity(p9, 4);
    buffer.writeu32(p9.buf, p9.offset, p10);
    p9.offset = p9.offset + 4;
end;

local function writeF64(p11: table, p12: number) -- Line: 68
    -- upvalues: ensureCapacity (copy)
    ensureCapacity(p11, 8);
    buffer.writef64(p11.buf, p11.offset, p12);
    p11.offset = p11.offset + 8;
end;

local function writeF32(p13: table, p14: number) -- Line: 74
    -- upvalues: ensureCapacity (copy)
    ensureCapacity(p13, 4);
    buffer.writef32(p13.buf, p13.offset, p14);
    p13.offset = p13.offset + 4;
end;

local function writeBytes(p15: table, p16: string) -- Line: 80
    -- upvalues: ensureCapacity (copy)
    local v17 = #p16;
    ensureCapacity(p15, 4);
    buffer.writeu32(p15.buf, p15.offset, v17);
    p15.offset = p15.offset + 4;

    if v17 == 0 then
        return;
    end;

    ensureCapacity(p15, v17);
    buffer.writestring(p15.buf, p15.offset, p16, v17);
    p15.offset = p15.offset + v17;
end;

local function isArray(p18: table) -- Line: 93
    local v19 = 0;

    for i in pairs(p18) do
        if typeof(i) ~= "number" or (i < 1 or i % 1 ~= 0) then
            return false;
        end;

        v19 = v19 + 1;
    end;

    return v19 == #p18;
end;

local function internInstance(p20: table, p21: userdata) -- Line: 105
    local v22 = p20.instanceIndex[p21];

    if v22 then
        return v22;
    end;

    local v23 = #p20.instances + 1;
    p20.instances[v23] = p21;
    p20.instanceIndex[p21] = v23;

    return v23;
end;

local function u43(p24: table, p25: any) -- Line: 117
    -- upvalues: ensureCapacity (copy), isArray (copy), u43 (ref)
    local v26 = typeof(p25);

    if p25 == nil then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 0);
        p24.offset = p24.offset + 1;

        return;
    end;

    if v26 == "boolean" then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, p25 and 2 or 1);
        p24.offset = p24.offset + 1;

        return;
    end;

    if v26 == "number" then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 3);
        p24.offset = p24.offset + 1;
        ensureCapacity(p24, 8);
        buffer.writef64(p24.buf, p24.offset, p25);
        p24.offset = p24.offset + 8;

        return;
    end;

    if v26 == "string" then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 4);
        p24.offset = p24.offset + 1;
        local v27 = #p25;
        ensureCapacity(p24, 4);
        buffer.writeu32(p24.buf, p24.offset, v27);
        p24.offset = p24.offset + 4;

        if v27 == 0 then
            return;
        end;

        ensureCapacity(p24, v27);
        buffer.writestring(p24.buf, p24.offset, p25, v27);
        p24.offset = p24.offset + v27;

        return;
    end;

    if v26 == "Vector3" then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 7);
        p24.offset = p24.offset + 1;
        local X = p25.X;
        ensureCapacity(p24, 4);
        buffer.writef32(p24.buf, p24.offset, X);
        p24.offset = p24.offset + 4;
        local Y = p25.Y;
        ensureCapacity(p24, 4);
        buffer.writef32(p24.buf, p24.offset, Y);
        p24.offset = p24.offset + 4;
        local Z = p25.Z;
        ensureCapacity(p24, 4);
        buffer.writef32(p24.buf, p24.offset, Z);
        p24.offset = p24.offset + 4;

        return;
    end;

    if v26 == "Vector2" then
        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 8);
        p24.offset = p24.offset + 1;
        local X = p25.X;
        ensureCapacity(p24, 4);
        buffer.writef32(p24.buf, p24.offset, X);
        p24.offset = p24.offset + 4;
        local Y = p25.Y;
        ensureCapacity(p24, 4);
        buffer.writef32(p24.buf, p24.offset, Y);
        p24.offset = p24.offset + 4;

        return;
    end;

    if v26 ~= "CFrame" then
        if v26 == "Color3" then
            ensureCapacity(p24, 1);
            buffer.writeu8(p24.buf, p24.offset, 10);
            p24.offset = p24.offset + 1;
            local R = p25.R;
            ensureCapacity(p24, 4);
            buffer.writef32(p24.buf, p24.offset, R);
            p24.offset = p24.offset + 4;
            local G = p25.G;
            ensureCapacity(p24, 4);
            buffer.writef32(p24.buf, p24.offset, G);
            p24.offset = p24.offset + 4;
            local B = p25.B;
            ensureCapacity(p24, 4);
            buffer.writef32(p24.buf, p24.offset, B);
            p24.offset = p24.offset + 4;

            return;
        end;

        if v26 ~= "EnumItem" then
            if v26 == "Instance" then
                ensureCapacity(p24, 1);
                buffer.writeu8(p24.buf, p24.offset, 12);
                p24.offset = p24.offset + 1;
                local v28 = p24.instanceIndex[p25];

                if not v28 then
                    v28 = #p24.instances + 1;
                    p24.instances[v28] = p25;
                    p24.instanceIndex[p25] = v28;
                end;

                ensureCapacity(p24, 4);
                buffer.writeu32(p24.buf, p24.offset, v28);
                p24.offset = p24.offset + 4;

                return;
            end;

            if v26 == "buffer" then
                ensureCapacity(p24, 1);
                buffer.writeu8(p24.buf, p24.offset, 13);
                p24.offset = p24.offset + 1;
                local buffer_len_ret = buffer.len(p25);
                ensureCapacity(p24, 4);
                buffer.writeu32(p24.buf, p24.offset, buffer_len_ret);
                p24.offset = p24.offset + 4;
                ensureCapacity(p24, buffer_len_ret);
                buffer.copy(p24.buf, p24.offset, p25, 0, buffer_len_ret);
                p24.offset = p24.offset + buffer_len_ret;

                return;
            end;

            if v26 ~= "table" then
                ensureCapacity(p24, 1);
                buffer.writeu8(p24.buf, p24.offset, 0);
                p24.offset = p24.offset + 1;

                return;
            end;

            if p24.visited[p25] then
                ensureCapacity(p24, 1);
                buffer.writeu8(p24.buf, p24.offset, 0);
                p24.offset = p24.offset + 1;

                return;
            end;

            p24.visited[p25] = true;

            if isArray(p25) then
                ensureCapacity(p24, 1);
                buffer.writeu8(p24.buf, p24.offset, 5);
                p24.offset = p24.offset + 1;
                ensureCapacity(p24, 4);
                buffer.writeu32(p24.buf, p24.offset, #p25);
                p24.offset = p24.offset + 4;

                for i = 1, #p25 do
                    u43(p24, p25[i]);
                    local _ = i;
                end;

                return;
            end;

            local v29 = {};

            for i, v in pairs(p25) do
                table.insert(v29, i);
                table.insert(v29, v);
            end;

            ensureCapacity(p24, 1);
            buffer.writeu8(p24.buf, p24.offset, 6);
            p24.offset = p24.offset + 1;
            ensureCapacity(p24, 4);
            buffer.writeu32(p24.buf, p24.offset, #v29 // 2);
            p24.offset = p24.offset + 4;

            for i = 1, #v29, 2 do
                u43(p24, v29[i]);
                u43(p24, v29[i + 1]);
                local _ = i;
            end;

            return;
        end;

        ensureCapacity(p24, 1);
        buffer.writeu8(p24.buf, p24.offset, 11);
        p24.offset = p24.offset + 1;
        local Name = p25.EnumType.Name;
        local v30 = #Name;
        ensureCapacity(p24, 4);
        buffer.writeu32(p24.buf, p24.offset, v30);
        p24.offset = p24.offset + 4;

        if v30 ~= 0 then
            ensureCapacity(p24, v30);
            buffer.writestring(p24.buf, p24.offset, Name, v30);
            p24.offset = p24.offset + v30;
        end;

        local Name2 = p25.Name;
        local v31 = #Name2;
        ensureCapacity(p24, 4);
        buffer.writeu32(p24.buf, p24.offset, v31);
        p24.offset = p24.offset + 4;

        if v31 == 0 then
            return;
        end;

        ensureCapacity(p24, v31);
        buffer.writestring(p24.buf, p24.offset, Name2, v31);
        p24.offset = p24.offset + v31;

        return;
    end;

    ensureCapacity(p24, 1);
    buffer.writeu8(p24.buf, p24.offset, 9);
    p24.offset = p24.offset + 1;
    local Components, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42 = p25:GetComponents();
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, Components);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v32);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v33);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v34);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v35);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v36);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v37);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v38);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v39);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v40);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v41);
    p24.offset = p24.offset + 4;
    ensureCapacity(p24, 4);
    buffer.writef32(p24.buf, p24.offset, v42);
    p24.offset = p24.offset + 4;
end;

local function finishWriter(p44: table) -- Line: 237
    local buffer_create_ret = buffer.create(p44.offset);

    if p44.offset > 0 then
        buffer.copy(buffer_create_ret, 0, p44.buf, 0, p44.offset);
    end;

    return buffer_create_ret;
end;

local function compress(u45: buffer) -- Line: 245
    -- upvalues: result (copy), Zstd (copy)
    local success2, result2 = pcall(function() -- Line: 246
        -- upvalues: result (ref), u45 (copy), Zstd (ref)
        if not result then
            error("EncodingService unavailable");
        end;

        return result:CompressBuffer(u45, Zstd, 1);
    end);

    if success2 and typeof(result2) == "buffer" then
        local buffer_create_ret = buffer.create(1 + buffer.len(result2));
        buffer.writeu8(buffer_create_ret, 0, 1);
        buffer.copy(buffer_create_ret, 1, result2);

        return buffer_create_ret;
    end;

    local buffer_create_ret = buffer.create(1 + buffer.len(u45));
    buffer.writeu8(buffer_create_ret, 0, 0);
    buffer.copy(buffer_create_ret, 1, u45);

    return buffer_create_ret;
end;

local function sliceBuffer(p46: buffer, p47: number, p48: number) -- Line: 265
    local buffer_create_ret = buffer.create(p48);

    if p48 > 0 then
        buffer.copy(buffer_create_ret, 0, p46, p47, p48);
    end;

    return buffer_create_ret;
end;

local function decompress(p49: buffer) -- Line: 273
    -- upvalues: result (copy), Zstd (copy), u3 (copy), u2 (copy)
    if buffer.len(p49) < 1 then
        return nil;
    end;

    local buffer_readu8_ret = buffer.readu8(p49, 0);
    local v50 = buffer.len(p49) - 1;
    local buffer_create_ret = buffer.create(v50);

    if v50 > 0 then
        buffer.copy(buffer_create_ret, 0, p49, 1, v50);
    end;

    if buffer_readu8_ret == 0 then
        return buffer_create_ret;
    end;

    if buffer_readu8_ret ~= 1 then
        return nil;
    end;

    if not result then
        return nil;
    end;

    local success2, result2 = pcall(function() -- Line: 292
        -- upvalues: result (ref), buffer_create_ret (copy), Zstd (ref)
        return result:GetDecompressedBufferSize(buffer_create_ret, Zstd);
    end);

    if not (success2 and (typeof(result2) == "number" and u3 >= result2)) then
        if not (u2 or (not success2 or typeof(result2) ~= "number")) then
            warn((`[BufferCodec] Dropped {result2} byte packet (cap {u3})`));
        end;

        return nil;
    end;

    local success3, result3 = pcall(function() -- Line: 302
        -- upvalues: result (ref), buffer_create_ret (copy), Zstd (ref)
        return result:DecompressBuffer(buffer_create_ret, Zstd);
    end);

    if success3 and typeof(result3) == "buffer" then
        return result3;
    end;

    return nil;
end;

local function remaining(p51: table) -- Line: 319
    return p51.length - p51.offset;
end;

local function readU8(p52: table) -- Line: 323
    if p52.length - p52.offset < 1 then
        error("truncated u8");
    end;

    local buffer_readu8_ret = buffer.readu8(p52.buf, p52.offset);
    p52.offset = p52.offset + 1;

    return buffer_readu8_ret;
end;

local function readU32(p53: table) -- Line: 332
    if p53.length - p53.offset < 4 then
        error("truncated u32");
    end;

    local buffer_readu32_ret = buffer.readu32(p53.buf, p53.offset);
    p53.offset = p53.offset + 4;

    return buffer_readu32_ret;
end;

local function readF64(p54: table) -- Line: 341
    if p54.length - p54.offset < 8 then
        error("truncated f64");
    end;

    local buffer_readf64_ret = buffer.readf64(p54.buf, p54.offset);
    p54.offset = p54.offset + 8;

    return buffer_readf64_ret;
end;

local function readF32(p55: table) -- Line: 350
    if p55.length - p55.offset < 4 then
        error("truncated f32");
    end;

    local buffer_readf32_ret = buffer.readf32(p55.buf, p55.offset);
    p55.offset = p55.offset + 4;

    return buffer_readf32_ret;
end;

local function readBytes(p56: table) -- Line: 359
    if p56.length - p56.offset < 4 then
        error("truncated u32");
    end;

    local buffer_readu32_ret = buffer.readu32(p56.buf, p56.offset);
    p56.offset = p56.offset + 4;

    if buffer_readu32_ret < 0 or p56.length - p56.offset < buffer_readu32_ret then
        error("truncated string");
    end;

    if buffer_readu32_ret == 0 then
        return "";
    end;

    local buffer_readstring_ret = buffer.readstring(p56.buf, p56.offset, buffer_readu32_ret);
    p56.offset = p56.offset + buffer_readu32_ret;

    return buffer_readstring_ret;
end;

local function u62(p57: table) -- Line: 374
    -- upvalues: readBytes (copy), u62 (ref)
    if p57.length - p57.offset < 1 then
        error("truncated u8");
    end;

    local buffer_readu8_ret = buffer.readu8(p57.buf, p57.offset);
    p57.offset = p57.offset + 1;

    if buffer_readu8_ret == 0 then
        return nil;
    end;

    if buffer_readu8_ret == 1 then
        return false;
    end;

    if buffer_readu8_ret == 2 then
        return true;
    end;

    if buffer_readu8_ret == 3 then
        if p57.length - p57.offset < 8 then
            error("truncated f64");
        end;

        local buffer_readf64_ret = buffer.readf64(p57.buf, p57.offset);
        p57.offset = p57.offset + 8;

        return buffer_readf64_ret;
    end;

    if buffer_readu8_ret == 4 then
        return readBytes(p57);
    end;

    if buffer_readu8_ret == 7 then
        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret2 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret3 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    end;

    if buffer_readu8_ret == 8 then
        local Vector2_new = Vector2.new;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret2 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        return Vector2_new(buffer_readf32_ret, buffer_readf32_ret2);
    end;

    if buffer_readu8_ret == 9 then
        local CFrame_new = CFrame.new;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret2 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret3 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret4 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret5 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret6 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret7 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret8 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret9 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret10 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret11 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret12 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        return CFrame_new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3, buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6, buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9, buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    end;

    if buffer_readu8_ret == 10 then
        local Color3_new = Color3.new;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret2 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < 4 then
            error("truncated f32");
        end;

        local buffer_readf32_ret3 = buffer.readf32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        return Color3_new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    end;

    if buffer_readu8_ret == 11 then
        local v58 = readBytes(p57);
        local u59 = readBytes(p57);
        local u60 = Enum[v58];

        if typeof(u60) ~= "Enum" then
            return nil;
        end;

        local success2, result2 = pcall(function() -- Line: 423
            -- upvalues: u60 (copy), u59 (copy)
            return u60[u59];
        end);

        if success2 then
            return result2;
        end;

        return nil;
    end;

    if buffer_readu8_ret == 12 then
        local instances = p57.instances;

        if p57.length - p57.offset < 4 then
            error("truncated u32");
        end;

        local buffer_readu32_ret = buffer.readu32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        return instances[buffer_readu32_ret];
    end;

    if buffer_readu8_ret == 13 then
        if p57.length - p57.offset < 4 then
            error("truncated u32");
        end;

        local buffer_readu32_ret = buffer.readu32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;

        if p57.length - p57.offset < buffer_readu32_ret then
            error("truncated nested buffer");
        end;

        local buffer_create_ret = buffer.create(buffer_readu32_ret);

        if buffer_readu32_ret > 0 then
            buffer.copy(buffer_create_ret, 0, p57.buf, p57.offset, buffer_readu32_ret);
        end;

        p57.offset = p57.offset + buffer_readu32_ret;

        return buffer_create_ret;
    end;

    if buffer_readu8_ret == 5 then
        if p57.length - p57.offset < 4 then
            error("truncated u32");
        end;

        local buffer_readu32_ret = buffer.readu32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;
        local table_create_ret = table.create(buffer_readu32_ret);

        for i = 1, buffer_readu32_ret do
            table_create_ret[i] = u62(p57);
            local _ = i;
        end;

        return table_create_ret;
    end;

    if buffer_readu8_ret == 6 then
        if p57.length - p57.offset < 4 then
            error("truncated u32");
        end;

        local buffer_readu32_ret = buffer.readu32(p57.buf, p57.offset);
        p57.offset = p57.offset + 4;
        local v61 = {};

        for i = 1, buffer_readu32_ret do
            v61[u62(p57)] = u62(p57);
            local _ = i;
        end;

        return v61;
    end;

    error("unknown type tag");
end;

function v1.Encode(p63) -- Line: 467
    -- upvalues: u43 (ref), compress (copy)
    local v64 = {
        offset = 0,
        buf = buffer.create(256),
        instances = {},
        instanceIndex = {},
        visited = {}
    };
    u43(v64, p63);
    local buffer_create_ret = buffer.create(v64.offset);

    if v64.offset > 0 then
        buffer.copy(buffer_create_ret, 0, v64.buf, 0, v64.offset);
    end;

    return compress(buffer_create_ret), v64.instances;
end;

function v1.Decode(p65, p66) -- Line: 479
    -- upvalues: decompress (copy), u62 (ref)
    if typeof(p65) ~= "buffer" then
        return false, nil;
    end;

    local v67 = decompress(p65);

    if not v67 then
        return false, nil;
    end;

    local v68 = {
        offset = 0,
        buf = v67,
        length = buffer.len(v67),
        instances = typeof(p66) ~= "table" and {} or p66
    };
    local success2, result2 = pcall(u62, v68);

    if success2 then
        return true, result2;
    end;

    return false, nil;
end;

return v1;