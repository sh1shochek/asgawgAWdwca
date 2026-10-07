-- ReplicatedStorage.Database.Security.Network.BufferCodec
-- Script path: ReplicatedStorage.Database.Security.Network.BufferCodec
-- Decompile time: 18.44 ms

local u30, u47
local success, result = pcall(game.GetService, game, "EncodingService")
local u8 = if not success then nil else result
local v1 = {}
local Zstd = Enum.CompressionAlgorithm.Zstd
local u18 = game:GetService("RunService"):IsServer()
local u20 = if not u18 then 268435456 else 33554432

local function ensureCapacity(a1, a2) -- Line: 43 -- types: a1: table, a2: number
    local v1 = a1.offset + a2
    local v2 = buffer.len(a1.buf)
    if v1 <= v2 then
        return
    end
    local v3 = math.max(v2 * 2, v1)
    local v4 = buffer.create(v3)
    buffer.copy(v4, 0, a1.buf, 0, a1.offset)
    a1.buf = v4
end

local function writeU8(a1, a2) -- Line: 56 -- upvalues: ensureCapacity (val) -- types: a1: table, a2: number
    ensureCapacity(a1, 1)
    local buf = a1.buf
    local offset = a1.offset
    buffer.writeu8(buf, offset, a2)
    a1.offset = a1.offset + 1
end

local function writeU32(a1, a2) -- Line: 62 -- upvalues: ensureCapacity (val) -- types: a1: table, a2: number
    ensureCapacity(a1, 4)
    local buf = a1.buf
    local offset = a1.offset
    buffer.writeu32(buf, offset, a2)
    a1.offset = a1.offset + 4
end

local function writeF64(a1, a2) -- Line: 68 -- upvalues: ensureCapacity (val) -- types: a1: table, a2: number
    ensureCapacity(a1, 8)
    local buf = a1.buf
    local offset = a1.offset
    buffer.writef64(buf, offset, a2)
    a1.offset = a1.offset + 8
end

local function writeF32(a1, a2) -- Line: 74 -- upvalues: ensureCapacity (val) -- types: a1: table, a2: number
    ensureCapacity(a1, 4)
    local buf = a1.buf
    local offset = a1.offset
    buffer.writef32(buf, offset, a2)
    a1.offset = a1.offset + 4
end

local function writeBytes(a1, a2) -- Line: 80 -- upvalues: ensureCapacity (val) -- types: a1: table, a2: string
    local v1 = #a2
    ensureCapacity(a1, 4)
    local buf = a1.buf
    local offset = a1.offset
    buffer.writeu32(buf, offset, v1)
    a1.offset = a1.offset + 4
    if v1 == 0 then
        return
    end
    ensureCapacity(a1, v1)
    buffer.writestring(a1.buf, a1.offset, a2, v1)
    a1.offset = a1.offset + v1
end

local function isArray(a1) -- Line: 93 -- types: a1: table
    local v1 = 0
    for k in pairs(a1) do
        if typeof(k) == "number" and not (k < 1) and k % 1 == 0 then
            v1 = v1 + 1
            continue
        end
        return false
    end
    return v1 == #a1
end

local function internInstance(a1, a2) -- Line: 105 -- types: a1: table, a2: userdata
    local v1 = a1.instanceIndex[a2]
    if v1 then
        return v1
    end
    local v2 = #a1.instances + 1
    a1.instances[v2] = a2
    a1.instanceIndex[a2] = v2
    return v2
end

function u30(a1, a2) -- Line: 117 -- upvalues: ensureCapacity (val), isArray (val), u30 (ref) -- types: a1: table
    local v1, v2
    local v3 = typeof(a2)
    if a2 == nil then
        ensureCapacity(a1, 1)
        local buf = a1.buf
        local offset = a1.offset
        buffer.writeu8(buf, offset, 0)
        a1.offset = a1.offset + 1
        return
    end
    if v3 == "boolean" then
        v1 = if not a2 then 1 else 2
        ensureCapacity(a1, 1)
        local buf_2 = a1.buf
        local offset_2 = a1.offset
        buffer.writeu8(buf_2, offset_2, v1)
        a1.offset = a1.offset + 1
        return
    end
    if v3 == "number" then
        ensureCapacity(a1, 1)
        local buf_3 = a1.buf
        local offset_3 = a1.offset
        buffer.writeu8(buf_3, offset_3, 3)
        a1.offset = a1.offset + 1
        ensureCapacity(a1, 8)
        local buf_4 = a1.buf
        local offset_4 = a1.offset
        buffer.writef64(buf_4, offset_4, a2)
        a1.offset = a1.offset + 8
        return
    end
    if v3 == "string" then
        ensureCapacity(a1, 1)
        local buf_5 = a1.buf
        local offset_5 = a1.offset
        buffer.writeu8(buf_5, offset_5, 4)
        a1.offset = a1.offset + 1
        v1 = #a2
        ensureCapacity(a1, 4)
        local buf_6 = a1.buf
        local offset_6 = a1.offset
        buffer.writeu32(buf_6, offset_6, v1)
        a1.offset = a1.offset + 4
        if v1 == 0 then
            return
        end
        ensureCapacity(a1, v1)
        buffer.writestring(a1.buf, a1.offset, a2, v1)
        a1.offset = a1.offset + v1
        return
    end
    if v3 == "Vector3" then
        ensureCapacity(a1, 1)
        local buf_7 = a1.buf
        local offset_7 = a1.offset
        buffer.writeu8(buf_7, offset_7, 7)
        a1.offset = a1.offset + 1
        local X = a2.X
        ensureCapacity(a1, 4)
        local buf_8 = a1.buf
        local offset_8 = a1.offset
        buffer.writef32(buf_8, offset_8, X)
        a1.offset = a1.offset + 4
        local Y = a2.Y
        ensureCapacity(a1, 4)
        local buf_9 = a1.buf
        local offset_9 = a1.offset
        buffer.writef32(buf_9, offset_9, Y)
        a1.offset = a1.offset + 4
        local Z = a2.Z
        ensureCapacity(a1, 4)
        local buf_10 = a1.buf
        local offset_10 = a1.offset
        buffer.writef32(buf_10, offset_10, Z)
        a1.offset = a1.offset + 4
        return
    end
    if v3 == "Vector2" then
        ensureCapacity(a1, 1)
        local buf_11 = a1.buf
        local offset_11 = a1.offset
        buffer.writeu8(buf_11, offset_11, 8)
        a1.offset = a1.offset + 1
        local X_2 = a2.X
        ensureCapacity(a1, 4)
        local buf_12 = a1.buf
        local offset_12 = a1.offset
        buffer.writef32(buf_12, offset_12, X_2)
        a1.offset = a1.offset + 4
        local Y_2 = a2.Y
        ensureCapacity(a1, 4)
        local buf_13 = a1.buf
        local offset_13 = a1.offset
        buffer.writef32(buf_13, offset_13, Y_2)
        a1.offset = a1.offset + 4
        return
    end
    if v3 == "CFrame" then
        ensureCapacity(a1, 1)
        local buf_14 = a1.buf
        local offset_14 = a1.offset
        buffer.writeu8(buf_14, offset_14, 9)
        a1.offset = a1.offset + 1
        local Components_4, Components_5, Components_6, Components_7, Components_8, Components_9, Components_10, Components_11, Components_12, Components, Components_2, Components_3 = a2:GetComponents()
        ensureCapacity(a1, 4)
        local buf_15 = a1.buf
        local offset_15 = a1.offset
        buffer.writef32(buf_15, offset_15, Components_4)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_16 = a1.buf
        local offset_16 = a1.offset
        buffer.writef32(buf_16, offset_16, Components_5)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_17 = a1.buf
        local offset_17 = a1.offset
        buffer.writef32(buf_17, offset_17, Components_6)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_18 = a1.buf
        local offset_18 = a1.offset
        buffer.writef32(buf_18, offset_18, Components_7)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_19 = a1.buf
        local offset_19 = a1.offset
        buffer.writef32(buf_19, offset_19, Components_8)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_20 = a1.buf
        local offset_20 = a1.offset
        buffer.writef32(buf_20, offset_20, Components_9)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_21 = a1.buf
        local offset_21 = a1.offset
        buffer.writef32(buf_21, offset_21, Components_10)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_22 = a1.buf
        local offset_22 = a1.offset
        buffer.writef32(buf_22, offset_22, Components_11)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_23 = a1.buf
        local offset_23 = a1.offset
        buffer.writef32(buf_23, offset_23, Components_12)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_24 = a1.buf
        local offset_24 = a1.offset
        buffer.writef32(buf_24, offset_24, Components)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_25 = a1.buf
        local offset_25 = a1.offset
        buffer.writef32(buf_25, offset_25, Components_2)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, 4)
        local buf_26 = a1.buf
        local offset_26 = a1.offset
        buffer.writef32(buf_26, offset_26, Components_3)
        a1.offset = a1.offset + 4
        return
    end
    if v3 == "Color3" then
        ensureCapacity(a1, 1)
        local buf_27 = a1.buf
        local offset_27 = a1.offset
        buffer.writeu8(buf_27, offset_27, 10)
        a1.offset = a1.offset + 1
        local R = a2.R
        ensureCapacity(a1, 4)
        local buf_28 = a1.buf
        local offset_28 = a1.offset
        buffer.writef32(buf_28, offset_28, R)
        a1.offset = a1.offset + 4
        local G = a2.G
        ensureCapacity(a1, 4)
        local buf_29 = a1.buf
        local offset_29 = a1.offset
        buffer.writef32(buf_29, offset_29, G)
        a1.offset = a1.offset + 4
        local B = a2.B
        ensureCapacity(a1, 4)
        local buf_30 = a1.buf
        local offset_30 = a1.offset
        buffer.writef32(buf_30, offset_30, B)
        a1.offset = a1.offset + 4
        return
    end
    if v3 == "EnumItem" then
        ensureCapacity(a1, 1)
        local buf_31 = a1.buf
        local offset_31 = a1.offset
        buffer.writeu8(buf_31, offset_31, 11)
        a1.offset = a1.offset + 1
        local Name = a2.EnumType.Name
        v2 = #Name
        ensureCapacity(a1, 4)
        local buf_32 = a1.buf
        local offset_32 = a1.offset
        buffer.writeu32(buf_32, offset_32, v2)
        a1.offset = a1.offset + 4
        if v2 ~= 0 then
            ensureCapacity(a1, v2)
            buffer.writestring(a1.buf, a1.offset, Name, v2)
            a1.offset = a1.offset + v2
        end
        local Name_2 = a2.Name
        v2 = #Name_2
        ensureCapacity(a1, 4)
        local buf_33 = a1.buf
        local offset_33 = a1.offset
        buffer.writeu32(buf_33, offset_33, v2)
        a1.offset = a1.offset + 4
        if v2 == 0 then
            return
        end
        ensureCapacity(a1, v2)
        buffer.writestring(a1.buf, a1.offset, Name_2, v2)
        a1.offset = a1.offset + v2
        return
    end
    if v3 == "Instance" then
        ensureCapacity(a1, 1)
        local buf_34 = a1.buf
        local offset_34 = a1.offset
        buffer.writeu8(buf_34, offset_34, 12)
        a1.offset = a1.offset + 1
        v2 = a1.instanceIndex[a2]
        if not v2 then
            local v4 = #a1.instances + 1
            a1.instances[v4] = a2
            a1.instanceIndex[a2] = v4
            v1 = v4
        else
            v1 = v2
        end
        ensureCapacity(a1, 4)
        local buf_35 = a1.buf
        local offset_35 = a1.offset
        buffer.writeu32(buf_35, offset_35, v1)
        a1.offset = a1.offset + 4
        return
    end
    if v3 == "buffer" then
        ensureCapacity(a1, 1)
        local buf_36 = a1.buf
        local offset_36 = a1.offset
        buffer.writeu8(buf_36, offset_36, 13)
        a1.offset = a1.offset + 1
        v1 = buffer.len(a2)
        ensureCapacity(a1, 4)
        local buf_37 = a1.buf
        local offset_37 = a1.offset
        buffer.writeu32(buf_37, offset_37, v1)
        a1.offset = a1.offset + 4
        ensureCapacity(a1, v1)
        buffer.copy(a1.buf, a1.offset, a2, 0, v1)
        a1.offset = a1.offset + v1
        return
    end
    if v3 ~= "table" then
        ensureCapacity(a1, 1)
        local buf_43 = a1.buf
        local offset_43 = a1.offset
        buffer.writeu8(buf_43, offset_43, 0)
        a1.offset = a1.offset + 1
        return
    end
    if a1.visited[a2] then
        ensureCapacity(a1, 1)
        local buf_38 = a1.buf
        local offset_38 = a1.offset
        buffer.writeu8(buf_38, offset_38, 0)
        a1.offset = a1.offset + 1
        return
    end
    a1.visited[a2] = true
    if isArray(a2) then
        ensureCapacity(a1, 1)
        local buf_39 = a1.buf
        local offset_39 = a1.offset
        buffer.writeu8(buf_39, offset_39, 5)
        a1.offset = a1.offset + 1
        v1 = #a2
        ensureCapacity(a1, 4)
        local buf_40 = a1.buf
        local offset_40 = a1.offset
        buffer.writeu32(buf_40, offset_40, v1)
        a1.offset = a1.offset + 4
        v1 = #a2
        for j = 1, v1 do
            u30(a1, a2[j])
        end
        return
    end
    v1 = {}
    for k, v in pairs(a2) do
        table.insert(v1, k)
        table.insert(v1, v)
    end
    ensureCapacity(a1, 1)
    local buf_41 = a1.buf
    local offset_41 = a1.offset
    buffer.writeu8(buf_41, offset_41, 6)
    a1.offset = a1.offset + 1
    v2 = #v1 // 2
    ensureCapacity(a1, 4)
    local buf_42 = a1.buf
    local offset_42 = a1.offset
    buffer.writeu32(buf_42, offset_42, v2)
    a1.offset = a1.offset + 4
    v2 = #v1
    for i = 1, v2, 2 do
        u30(a1, v1[i])
        u30(a1, v1[i + 1])
    end
end

local function finishWriter(a1) -- Line: 237 -- types: a1: table
    local v1 = buffer.create(a1.offset)
    if 0 < a1.offset then
        buffer.copy(v1, 0, a1.buf, 0, a1.offset)
    end
    return v1
end

local function compress(a1) -- Line: 245 -- upvalues: u8 (val), Zstd (val) -- types: a1: buffer
    local v1
    local success, result = pcall(function() -- Line: 246 -- upvalues: u8 (upval), a1 (val), Zstd (upval)
        if not u8 then
            error("EncodingService unavailable")
        end
        return u8:CompressBuffer(a1, Zstd, 1)
    end)
    if success and typeof(result) == "buffer" then
        v1 = buffer.create(1 + buffer.len(result))
        buffer.writeu8(v1, 0, 1)
        buffer.copy(v1, 1, result)
        return v1
    end
    v1 = buffer.create(1 + buffer.len(a1))
    buffer.writeu8(v1, 0, 0)
    buffer.copy(v1, 1, a1)
    return v1
end

local function sliceBuffer(a1, a2, a3) -- Line: 265 -- types: a1: buffer, a2: number, a3: number
    local v1 = buffer.create(a3)
    if a3 > 0 then
        buffer.copy(v1, 0, a1, a2, a3)
    end
    return v1
end

local function decompress(a1) -- Line: 273 -- upvalues: u8 (val), Zstd (val), u20 (val), u18 (val) -- types: a1: buffer
    if (buffer.len(a1)) < 1 then
        return nil
    end
    local v1 = buffer.readu8(a1, 0)
    local v2 = buffer.len(a1) - 1
    local u17 = buffer.create(v2)
    if v2 > 0 then
        buffer.copy(u17, 0, a1, 1, v2)
    end
    if v1 == 0 then
        return u17
    end
    if v1 ~= 1 or not u8 then
        return nil
    end
    local success, result = pcall(function() -- Line: 292 -- upvalues: u8 (upval), u17 (val), Zstd (upval)
        return u8:GetDecompressedBufferSize(u17, Zstd)
    end)
    if success and typeof(result) == "number" and not (u20 < result) then
        local success_2, result_2 = pcall(function() -- Line: 302 -- upvalues: u8 (upval), u17 (val), Zstd (upval)
            return u8:DecompressBuffer(u17, Zstd)
        end)
        if success_2 and typeof(result_2) == "buffer" then
            return result_2
        end
        return nil
    end
    if not u18 and success and typeof(result) == "number" then
        warn((("[BufferCodec] Dropped %* byte packet (cap %*)"):format(result, u20)))
    end
    return nil
end

local function remaining(a1) -- Line: 319 -- types: a1: table
    return a1.length - a1.offset
end

local function readU8(a1) -- Line: 323 -- types: a1: table
    if a1.length - a1.offset < 1 then
        error("truncated u8")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v1 = buffer.readu8(buf, offset)
    a1.offset = a1.offset + 1
    return v1
end

local function readU32(a1) -- Line: 332 -- types: a1: table
    if a1.length - a1.offset < 4 then
        error("truncated u32")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v1 = buffer.readu32(buf, offset)
    a1.offset = a1.offset + 4
    return v1
end

local function readF64(a1) -- Line: 341 -- types: a1: table
    if a1.length - a1.offset < 8 then
        error("truncated f64")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v1 = buffer.readf64(buf, offset)
    a1.offset = a1.offset + 8
    return v1
end

local function readF32(a1) -- Line: 350 -- types: a1: table
    if a1.length - a1.offset < 4 then
        error("truncated f32")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v1 = buffer.readf32(buf, offset)
    a1.offset = a1.offset + 4
    return v1
end

local function readBytes(a1) -- Line: 359 -- types: a1: table
    if a1.length - a1.offset < 4 then
        error("truncated u32")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v1 = buffer.readu32(buf, offset)
    a1.offset = a1.offset + 4
    if v1 < 0 or a1.length - a1.offset < v1 then
        error("truncated string")
    end
    if v1 == 0 then
        return ""
    end
    local v2 = buffer.readstring(a1.buf, a1.offset, v1)
    a1.offset = a1.offset + v1
    return v2
end

function u47(a1) -- Line: 374 -- upvalues: readBytes (val), u47 (ref) -- types: a1: table
    local v1, v2, v3, v4, v5
    if a1.length - a1.offset < 1 then
        error("truncated u8")
    end
    local buf = a1.buf
    local offset = a1.offset
    local v6 = buffer.readu8(buf, offset)
    a1.offset = a1.offset + 1
    if v6 == 0 then
        return nil
    end
    if v6 == 1 then
        return false
    end
    if v6 == 2 then
        return true
    end
    if v6 == 3 then
        if a1.length - a1.offset < 8 then
            error("truncated f64")
        end
        local buf_2 = a1.buf
        local offset_2 = a1.offset
        v1 = buffer.readf64(buf_2, offset_2)
        a1.offset = a1.offset + 8
        return v1
    end
    if v6 == 4 then
        return (readBytes(a1))
    end
    if v6 == 7 then
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_3 = a1.buf
        local offset_3 = a1.offset
        v2 = buffer.readf32(buf_3, offset_3)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_4 = a1.buf
        local offset_4 = a1.offset
        v3 = buffer.readf32(buf_4, offset_4)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_5 = a1.buf
        local offset_5 = a1.offset
        v4 = buffer.readf32(buf_5, offset_5)
        a1.offset = a1.offset + 4
        return (Vector3.new(v2, v3, v4))
    end
    if v6 == 8 then
        local new = Vector2.new
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_6 = a1.buf
        local offset_6 = a1.offset
        v2 = buffer.readf32(buf_6, offset_6)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_7 = a1.buf
        local offset_7 = a1.offset
        v3 = buffer.readf32(buf_7, offset_7)
        a1.offset = a1.offset + 4
        return new(v2, v3)
    end
    if v6 == 9 then
        local new_2 = CFrame.new
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_8 = a1.buf
        local offset_8 = a1.offset
        v2 = buffer.readf32(buf_8, offset_8)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_9 = a1.buf
        local offset_9 = a1.offset
        v3 = buffer.readf32(buf_9, offset_9)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_10 = a1.buf
        local offset_10 = a1.offset
        v4 = buffer.readf32(buf_10, offset_10)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_11 = a1.buf
        local offset_11 = a1.offset
        local v7 = buffer.readf32(buf_11, offset_11)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_12 = a1.buf
        local offset_12 = a1.offset
        v5 = buffer.readf32(buf_12, offset_12)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_13 = a1.buf
        local offset_13 = a1.offset
        local v8 = buffer.readf32(buf_13, offset_13)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_14 = a1.buf
        local offset_14 = a1.offset
        local v9 = buffer.readf32(buf_14, offset_14)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_15 = a1.buf
        local offset_15 = a1.offset
        local v10 = buffer.readf32(buf_15, offset_15)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_16 = a1.buf
        local offset_16 = a1.offset
        local v11 = buffer.readf32(buf_16, offset_16)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_17 = a1.buf
        local offset_17 = a1.offset
        local v12 = buffer.readf32(buf_17, offset_17)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_18 = a1.buf
        local offset_18 = a1.offset
        local v13 = buffer.readf32(buf_18, offset_18)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_19 = a1.buf
        local offset_19 = a1.offset
        local v14 = buffer.readf32(buf_19, offset_19)
        a1.offset = a1.offset + 4
        return new_2(v2, v3, v4, v7, v5, v8, v9, v10, v11, v12, v13, v14)
    end
    if v6 == 10 then
        local new_3 = Color3.new
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_20 = a1.buf
        local offset_20 = a1.offset
        v2 = buffer.readf32(buf_20, offset_20)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_21 = a1.buf
        local offset_21 = a1.offset
        v3 = buffer.readf32(buf_21, offset_21)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < 4 then
            error("truncated f32")
        end
        local buf_22 = a1.buf
        local offset_22 = a1.offset
        v4 = buffer.readf32(buf_22, offset_22)
        a1.offset = a1.offset + 4
        return new_3(v2, v3, v4)
    end
    if v6 == 11 then
        v1 = readBytes(a1)
        local u418 = readBytes(a1)
        local u420 = Enum[v1]
        if typeof(u420) ~= "Enum" then
            return nil
        end
        local success, result = pcall(function() -- Line: 423 -- upvalues: u420 (val), u418 (val)
            return u420[u418]
        end)
        if success then
            return result
        end
        return nil
    end
    if v6 == 12 then
        local instances = a1.instances
        if a1.length - a1.offset < 4 then
            error("truncated u32")
        end
        local buf_23 = a1.buf
        local offset_23 = a1.offset
        v3 = buffer.readu32(buf_23, offset_23)
        a1.offset = a1.offset + 4
        return instances[v3]
    end
    if v6 == 13 then
        if a1.length - a1.offset < 4 then
            error("truncated u32")
        end
        local buf_24 = a1.buf
        local offset_24 = a1.offset
        v1 = buffer.readu32(buf_24, offset_24)
        a1.offset = a1.offset + 4
        if a1.length - a1.offset < v1 then
            error("truncated nested buffer")
        end
        v2 = buffer.create(v1)
        if v1 > 0 then
            buffer.copy(v2, 0, a1.buf, a1.offset, v1)
        end
        a1.offset = a1.offset + v1
        return v2
    end
    if v6 == 5 then
        if a1.length - a1.offset < 4 then
            error("truncated u32")
        end
        local buf_25 = a1.buf
        local offset_25 = a1.offset
        v1 = buffer.readu32(buf_25, offset_25)
        a1.offset = a1.offset + 4
        v2 = table.create(v1)
        for j = 1, v1 do
            v2[j] = (u47(a1))
        end
        return v2
    end
    if v6 ~= 6 then
        error("unknown type tag")
        return
    end
    if a1.length - a1.offset < 4 then
        error("truncated u32")
    end
    local buf_26 = a1.buf
    local offset_26 = a1.offset
    v1 = buffer.readu32(buf_26, offset_26)
    a1.offset = a1.offset + 4
    v2 = {}
    for i = 1, v1 do
        v5 = u47(a1)
        v2[v5] = (u47(a1))
    end
    return v2
end

function v1.Encode(a1) -- Line: 467 -- upvalues: u30 (ref), compress (val)
    local v1 = {
        offset = 0,
        buf = buffer.create(256),
        instances = {},
        instanceIndex = {},
        visited = {},
    }
    u30(v1, a1)
    local v2 = buffer.create(v1.offset)
    if 0 < v1.offset then
        buffer.copy(v2, 0, v1.buf, 0, v1.offset)
    end
    return (compress(v2)), v1.instances
end

function v1.Decode(a1, a2) -- Line: 479 -- upvalues: decompress (val), u47 (ref)
    if typeof(a1) ~= "buffer" then
        return false, nil
    end
    local v1 = decompress(a1)
    if not v1 then
        return false, nil
    end
    local v2 = {
        offset = 0,
        buf = v1,
        length = buffer.len(v1),
        instances = if typeof(a2) ~= "table" then {} else a2,
    }
    local success, result = pcall(u47, v2)
    if not success then
        return false, nil
    end
    return true, result
end

return v1