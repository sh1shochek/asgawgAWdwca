-- ReplicatedStorage.Shared.Blink.Types
-- Script path: ReplicatedStorage.Shared.Blink.Types
-- Decompile time: 21.09 ms

-- Decompiled with Potassium's decompiler.

local u1 = 0;
local u2 = 64;
local u3 = 0;
local u4 = 0;
local buffer_create_ret = buffer.create(64);
local u5 = {};
local u6 = {};
local u7 = 0;
local buffer_create_ret2 = buffer.create(64);
newproxy();

local function Read(p8: number) -- Line: 62
    -- upvalues: u7 (ref)
    local v9 = u7;
    u7 = u7 + p8;

    return v9;
end;

local function Save(p10: table?) -- Line: 70
    -- upvalues: u2 (ref), u4 (ref), buffer_create_ret (ref), u5 (ref), u6 (ref)
    local v11 = p10 or {};
    v11.Size = u2;
    v11.Cursor = u4;
    v11.Buffer = buffer_create_ret;
    v11.Instances = u5;
    v11.Debug = u6;

    return v11;
end;

local function Load(p12: table?) -- Line: 80
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), buffer_create_ret (ref), u5 (ref), u6 (ref)
    if p12 then
        u2 = p12.Size;
        u4 = p12.Cursor;
        u3 = p12.Cursor;
        buffer_create_ret = p12.Buffer;
        u5 = p12.Instances;
        u6 = p12.Debug;

        return;
    end;

    u2 = 64;
    u4 = 0;
    u3 = 0;
    buffer_create_ret = buffer.create(64);
    u5 = {};
    u6 = {};
end;

local u13 = false;
local u14 = 0;
local u15 = 0;
local u16 = u5;
local u17 = nil;

local function MarkSend(p18: table?) -- Line: 113
    -- upvalues: u13 (ref), u14 (ref), u4 (ref), u15 (ref), u5 (ref), u16 (ref), u17 (ref)
    u13 = true;
    u14 = u4;
    u15 = #u5;
    u16 = u5;
    u17 = p18;
end;

local function CommitSend() -- Line: 121
    -- upvalues: u13 (ref), u17 (ref)
    u13 = false;
    u17 = nil;
end;

local function RewindSend() -- Line: 126
    -- upvalues: u13 (ref), u16 (ref), u15 (ref), u17 (ref), u5 (ref), Load (copy), u4 (ref), u14 (ref), u3 (ref)
    if not u13 then
        return;
    end;

    u13 = false;
    local v19 = u16;

    for i = #v19, u15 + 1, -1 do
        v19[i] = nil;
        local _ = i;
    end;

    local v20 = u17;
    u17 = nil;

    if u5 ~= v19 then
        return;
    end;

    if v20 then
        Load(v20);

        return;
    end;

    u4 = u14;
    u3 = u14;
end;

local function Invoke() -- Line: 158
    -- upvalues: u1 (ref)
    if u1 == 255 then
        u1 = 0;
    end;

    local v21 = u1;
    u1 = u1 + 1;

    return v21;
end;

local function Allocate(p22: number) -- Line: 168
    -- upvalues: u4 (ref), u2 (ref), buffer_create_ret (ref), u3 (ref)
    local v23 = u4 + p22;

    if u2 < v23 then
        while u2 < v23 do
            u2 = math.ceil(u2 * 1.5);
        end;

        local buffer_create_ret3 = buffer.create(u2);
        buffer.copy(buffer_create_ret3, 0, buffer_create_ret, 0, u4);
        buffer_create_ret = buffer_create_ret3;
    end;

    u3 = u4;
    u4 = u4 + p22;

    return u3;
end;

local function WriteVarint(p24: number, p25: number?) -- Line: 193
    -- upvalues: Allocate (copy), buffer_create_ret (ref)
    local v26 = p25 or 0;

    if p24 < 128 then
        local v27 = Allocate(1 + v26);
        buffer.writeu8(buffer_create_ret, v27, p24);

        return v27 + 1;
    end;

    if p24 < 16384 then
        local v28 = Allocate(2 + v26);
        local v29 = bit32.band(p24, 127) + 128;
        buffer.writeu8(buffer_create_ret, v28, v29);
        local bit32_rshift_ret = bit32.rshift(p24, 7);
        buffer.writeu8(buffer_create_ret, v28 + 1, bit32_rshift_ret);

        return v28 + 2;
    end;

    if p24 <= 65535 then
        local v30 = Allocate(3 + v26);
        local v31 = bit32.band(p24, 127) + 128;
        buffer.writeu8(buffer_create_ret, v30, v31);
        local bit32_rshift_ret = bit32.rshift(p24, 7);
        local v32 = bit32.band(bit32_rshift_ret, 127) + 128;
        buffer.writeu8(buffer_create_ret, v30 + 1, v32);
        local bit32_rshift_ret2 = bit32.rshift(p24, 14);
        buffer.writeu8(buffer_create_ret, v30 + 2, bit32_rshift_ret2);

        return v30 + 3;
    end;

    error((`Expected a length of at most 65535, got {p24} instead.`));
end;

local function WriteVarintString(p33: string) -- Line: 217
    -- upvalues: WriteVarint (copy), buffer_create_ret (ref)
    local v34 = #p33;
    local v35 = WriteVarint(v34, v34);
    buffer.writestring(buffer_create_ret, v35, p33, v34);
end;

local function WriteVarintBuffer(p36: buffer) -- Line: 223
    -- upvalues: WriteVarint (copy), buffer_create_ret (ref)
    local buffer_len_ret = buffer.len(p36);
    local v37 = WriteVarint(buffer_len_ret, buffer_len_ret);
    buffer.copy(buffer_create_ret, v37, p36, 0, buffer_len_ret);
end;

local function ReadVarint() -- Line: 229
    -- upvalues: buffer_create_ret2 (ref), u7 (ref)
    local v38 = u7;
    u7 = u7 + 1;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v38);

    if buffer_readu8_ret < 128 then
        return buffer_readu8_ret;
    end;

    local v39 = u7;
    u7 = u7 + 1;
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v39);

    if buffer_readu8_ret2 < 128 then
        if buffer_readu8_ret2 == 0 then
            error("A varint length was longer than it needs to be.");
        end;

        return buffer_readu8_ret - 128 + buffer_readu8_ret2 * 128;
    end;

    local v40 = u7;
    u7 = u7 + 1;
    local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v40);

    if buffer_readu8_ret3 == 0 or buffer_readu8_ret3 > 3 then
        error("A varint length was longer than it needs to be or past 65535.");
    end;

    return buffer_readu8_ret - 128 + (buffer_readu8_ret2 - 128) * 128 + buffer_readu8_ret3 * 16384;
end;

local function CopyOut(p41: buffer?, p42: buffer, p43: number) -- Line: 255
    if not p41 or buffer.len(p41) ~= p43 then
        p41 = buffer.create(p43);
    end;

    buffer.copy(p41, 0, p42, 0, p43);

    return p41;
end;

local u44 = nil;

local function LoadScratch() -- Line: 267
    -- upvalues: u13 (ref), u16 (ref), u15 (ref), u17 (ref), u5 (ref), Load (copy), u4 (ref), u14 (ref), u3 (ref), u2 (ref), buffer_create_ret (ref), u6 (ref)
    if u13 then
        u13 = false;
        local v45 = u16;

        for i = #v45, u15 + 1, -1 do
            v45[i] = nil;
            local _ = i;
        end;

        local v46 = u17;
        u17 = nil;

        if u5 == v45 then
            if v46 then
                Load(v46);
            else
                u4 = u14;
                u3 = u14;
            end;
        end;
    end;

    u2 = 64;
    u4 = 0;
    u3 = 0;
    buffer_create_ret = buffer.create(64);
    u5 = {};
    u6 = {};
end;

local function CreateQueue() -- Line: 280
    return {
        head = nil,
        tail = nil
    };
end;

local function Pop(p47: table) -- Line: 287
    local head = p47.head;

    if head ~= nil then
        p47.head = head.next;

        return head.value;
    end;
end;

local function Push(p48: table, p49: any) -- Line: 297
    local v50 = {
        next = nil,
        value = p49
    };

    if p48.tail ~= nil then
        p48.tail.next = v50;
    end;

    p48.tail = v50;

    if p48.head == nil then
        p48.head = v50;
    end;
end;

table.create(256);
table.create(256);
table.create(256);
table.create(256);
table.create(256);
local table_freeze_ret = table.freeze({});

local function CreateUnreliableBatch() -- Line: 363
    return {
        Cursor = 0,
        Buffer = buffer.create(800),
        Instances = {}
    };
end;

local function BatchIsFull(p51: table) -- Line: 372
    -- upvalues: u4 (ref), u5 (ref)
    return p51.Cursor + u4 > 800 and true or #p51.Instances + #u5 > 4096;
end;

local function AppendToBatch(p52: table) -- Line: 377
    -- upvalues: buffer_create_ret (ref), u4 (ref), u5 (ref)
    buffer.copy(p52.Buffer, p52.Cursor, buffer_create_ret, 0, u4);
    p52.Cursor = p52.Cursor + u4;
    table.move(u5, 1, #u5, #p52.Instances + 1, p52.Instances);
end;

local function CopyBatch(p53: table) -- Line: 385
    -- upvalues: u44 (ref)
    local v54 = u44;
    local Buffer = p53.Buffer;
    local Cursor = p53.Cursor;

    if not v54 or buffer.len(v54) ~= Cursor then
        v54 = buffer.create(Cursor);
    end;

    buffer.copy(v54, 0, Buffer, 0, Cursor);
    u44 = v54;

    return u44;
end;

local function PackInstances(p55: table) -- Line: 390
    if #p55 > 0 then
        return p55;
    end;

    return nil;
end;

local function IsValidPayload(p56: buffer, p57: table?) -- Line: 396
    if typeof(p56) ~= "buffer" then
        return false;
    end;

    if p57 == nil then
        return true;
    end;

    local v58;

    if typeof(p57) == "table" then
        v58 = #p57 <= 4096;
    else
        v58 = false;
    end;

    return v58;
end;

local function GetMaximumFragments(p59: number) -- Line: 409
    local math_ceil_ret = math.ceil(4294967296 / p59);

    return math.min(math_ceil_ret, 65535);
end;

local u60 = 0;

local function NextPacketId() -- Line: 414
    -- upvalues: u60 (ref)
    local v61 = u60;
    u60 = (u60 + 1) % 65536;

    return v61;
end;

local function SendFragments(p62: buffer, p63: table, p64: number, p65: function) -- Line: 422
    -- upvalues: u60 (ref)
    local buffer_len_ret = buffer.len(p62);
    local math_ceil_ret = math.ceil(buffer_len_ret / p64);

    if math_ceil_ret > 65535 then
        error((`[Blink]: Packet of {buffer_len_ret} bytes exceeds the maximum fragmented packet size of {65535 * p64} bytes.`));
    end;

    local v66 = u60;
    u60 = (u60 + 1) % 65536;

    for i = 0, math_ceil_ret - 1 do
        local v67 = i * p64;
        local math_min_ret = math.min(p64, buffer_len_ret - v67);
        local buffer_create_ret3 = buffer.create(math_min_ret + 6);
        buffer.writeu16(buffer_create_ret3, 0, v66);
        buffer.writeu16(buffer_create_ret3, 2, i);
        buffer.writeu16(buffer_create_ret3, 4, math_ceil_ret);
        buffer.copy(buffer_create_ret3, 6, p62, v67, math_min_ret);
        local v68;

        if i == 0 then
            if #p63 > 0 then
                v68 = p63;
            else
                v68 = nil;
            end;
        else
            v68 = nil;
        end;

        p65(buffer_create_ret3, v68);
        local _ = i;
    end;
end;

local function ReceiveFragment(p69: table, p70: buffer, p71: table?, p72: number) -- Line: 451
    -- upvalues: table_freeze_ret (copy)
    local v73;

    if typeof(p70) == "buffer" then
        if p71 == nil then
            v73 = true;
        elseif typeof(p71) == "table" then
            v73 = #p71 <= 4096;
        else
            v73 = false;
        end;
    else
        v73 = false;
    end;

    if not v73 then
        return nil;
    end;

    local v74 = buffer.len(p70) - 6;

    if v74 < 0 then
        return nil;
    end;

    local buffer_readu16_ret = buffer.readu16(p70, 0);
    local buffer_readu16_ret2 = buffer.readu16(p70, 2);
    local buffer_readu16_ret3 = buffer.readu16(p70, 4);

    if buffer_readu16_ret3 ~= 0 then
        local math_ceil_ret = math.ceil(4294967296 / p72);

        if math.min(math_ceil_ret, 65535) >= buffer_readu16_ret3 and buffer_readu16_ret3 > buffer_readu16_ret2 then
            if buffer_readu16_ret2 < buffer_readu16_ret3 - 1 and v74 ~= p72 then
                return nil;
            end;

            local v75 = p69[buffer_readu16_ret];

            if v75 and v75.Total ~= buffer_readu16_ret3 then
                v75 = nil;
            end;

            if not v75 then
                v75 = {
                    Received = 0,
                    Total = buffer_readu16_ret3,
                    Timestamp = os.clock(),
                    Buffers = table.create(buffer_readu16_ret3),
                    Instances = table_freeze_ret
                };
                p69[buffer_readu16_ret] = v75;
            end;

            assert(v75, "Unreachable");
            local Buffers = v75.Buffers;

            if Buffers[buffer_readu16_ret2 + 1] then
                return nil;
            end;

            Buffers[buffer_readu16_ret2 + 1] = p70;
            v75.Received = v75.Received + 1;

            if buffer_readu16_ret2 == 0 then
                v75.Instances = p71 or table_freeze_ret;
            end;

            if v75.Received < buffer_readu16_ret3 then
                return nil;
            end;

            p69[buffer_readu16_ret] = nil;
            local buffer_create_ret3 = buffer.create((buffer_readu16_ret3 - 1) * p72 + (buffer.len(Buffers[buffer_readu16_ret3]) - 6));

            for i = 1, buffer_readu16_ret3 do
                local v76 = Buffers[i];
                buffer.copy(buffer_create_ret3, (i - 1) * p72, v76, 6, buffer.len(v76) - 6);
                local _ = i;
            end;

            return buffer_create_ret3, v75.Instances;
        end;
    end;

    return nil;
end;

local function ClearStaleFragments(p77: table) -- Line: 526
    local os_clock_ret = os.clock();

    for i, v in p77 do
        if os_clock_ret - v.Timestamp >= 10 then
            p77[i] = nil;
            warn((`[Blink]: Dropped an incomplete packet, received {v.Received} out of {v.Total} fragments.`));
        end;
    end;
end;

local u78 = {
    Size = 64,
    Cursor = 0,
    Buffer = buffer.create(64),
    Instances = {},
    Debug = {}
};
local u79 = setmetatable({}, {
    __mode = "k"
});
local u80 = {};
local u81 = 0;
local u82 = 0;
local u83 = 0;
local u84 = nil;

local function FindSource(p85: buffer, p86: number, p87: buffer, p88: number) -- Line: 585
    local buffer_readu32_ret = buffer.readu32(p85, p86);
    local v89 = buffer.len(p87) - 4;

    for i = 1, 512 do
        local v90 = p88 + i;
        local v91 = p88 - i;

        if v90 <= v89 and buffer.readu32(p87, v90) == buffer_readu32_ret then
            return v90;
        end;

        if v91 >= 0 and (v91 <= v89 and buffer.readu32(p87, v91) == buffer_readu32_ret) then
            return v91;
        end;

        if v89 < v90 and v91 < 0 then
            break;
        end;

        local _ = i;
    end;

    return nil;
end;

local function EncodeDelta(p92: buffer, p93: buffer?) -- Line: 607
    -- upvalues: FindSource (copy)
    local buffer_len_ret = buffer.len(p92);

    if not p93 or buffer_len_ret <= 4 then
        return nil;
    end;

    local buffer_len_ret2 = buffer.len(p93);
    local buffer_create_ret3 = buffer.create(buffer_len_ret);
    buffer.writeu32(buffer_create_ret3, 0, buffer_len_ret);
    local v94 = 0;
    local v95 = 0;
    local v96 = 16;
    local v97 = 4;

    while true do
        if v94 >= buffer_len_ret then
            local buffer_create_ret4 = buffer.create(v97);
            buffer.copy(buffer_create_ret4, 0, buffer_create_ret3, 0, v97);

            return buffer_create_ret4;
        end;

        local math_min_ret = math.min(buffer_len_ret - v94, buffer_len_ret2 - v95);
        local v98 = 0;

        while v98 + 4 <= math_min_ret and buffer.readu32(p92, v94 + v98) == buffer.readu32(p93, v95 + v98) do
            v98 = v98 + 4;
        end;

        while v98 < math_min_ret and buffer.readu8(p92, v94 + v98) == buffer.readu8(p93, v95 + v98) do
            v98 = v98 + 1;
        end;

        local math_min_ret2 = math.min(v98, 65534);
        local v99 = v94 + math_min_ret2;
        local v100 = v95 + math_min_ret2;
        local v101 = 0;
        v95 = nil;

        while v99 + v101 < buffer_len_ret and v101 < 65534 do
            local v102 = v99 + v101;
            local v103 = v100 + v101;

            if v103 < buffer_len_ret2 and buffer.readu8(p92, v102) == buffer.readu8(p93, v103) then
                break;
            end;

            if v96 > 0 and (v101 >= 16 and (v101 % 16 == 0 and v102 + 4 <= buffer_len_ret)) then
                v96 = v96 - 1;
                v95 = FindSource(p92, v102, p93, v103);

                if v95 then
                    break;
                end;
            end;

            v101 = v101 + 1;
        end;

        if buffer_len_ret <= v97 + 4 + v101 + (v95 and 6 or 0) then
            return nil;
        end;

        buffer.writeu16(buffer_create_ret3, v97, math_min_ret2);
        buffer.writeu16(buffer_create_ret3, v97 + 2, v101);
        buffer.copy(buffer_create_ret3, v97 + 4, p92, v99, v101);
        v97 = v97 + (v101 + 4);
        v94 = v99 + v101;
        local v104 = v100 + v101;

        if v95 then
            buffer.writeu16(buffer_create_ret3, v97, 65535);
            buffer.writeu32(buffer_create_ret3, v97 + 2, v95);
            v97 = v97 + 6;
        else
            v95 = v104;
        end;
    end;
end;

local function LoadDelta() -- Line: 696
    -- upvalues: u78 (copy), Load (copy)
    u78.Cursor = 0;
    table.clear(u78.Instances);
    Load(u78);
end;

local function SaveDelta() -- Line: 704
    -- upvalues: u4 (ref), buffer_create_ret (ref), u78 (copy), u2 (ref), u5 (ref)
    local buffer_create_ret3 = buffer.create(u4);
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret, 0, u4);
    u78.Size = u2;
    u78.Buffer = buffer_create_ret;

    return buffer_create_ret3, u5;
end;

local function SendDelta(p105: userdata, p106: number, p107: buffer, p108: table) -- Line: 717
    -- upvalues: u79 (copy), EncodeDelta (copy), Allocate (copy), buffer_create_ret (ref), u5 (ref)
    local v109 = u79[p105];

    if not v109 then
        v109 = {};
        u79[p105] = v109;
    end;

    local v110 = EncodeDelta(p107, v109[p106]);
    local v111 = v110 or p107;
    local v112 = Allocate(2 + buffer.len(v111));
    buffer.writeu8(buffer_create_ret, v112, p106);
    buffer.writeu8(buffer_create_ret, v112 + 1, v110 and 1 or 0);
    buffer.copy(buffer_create_ret, v112 + 2, v111);
    table.move(p108, 1, #p108, #u5 + 1, u5);
    v109[p106] = p107;
end;

local function BeginDelta(p113: number) -- Line: 738
    -- upvalues: u81 (ref), buffer_create_ret2 (ref), u7 (ref), u84 (ref), u82 (ref), u80 (copy), u83 (ref)
    u81 = p113;
    local v114 = u7;
    u7 = u7 + 1;

    if buffer.readu8(buffer_create_ret2, v114) == 0 then
        u84 = nil;
        u82 = u7;

        return;
    end;

    local v115 = u80[p113];
    local v116 = u7;
    u7 = u7 + 4;
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret2, v116);

    if v115 then
        if buffer_readu32_ret > 4294967296 then
            error((`[Blink]: Received a delta for event {p113} of {buffer_readu32_ret} bytes, the maximum is {4294967296} bytes.`));
        end;
    else
        error((`[Blink]: Received a delta for event {p113} with no previous payload to apply it to.`));
    end;

    local buffer_create_ret3 = buffer.create(buffer_readu32_ret);
    local buffer_len_ret = buffer.len(v115);
    local v117 = 0;
    local v118 = 0;

    while v117 < buffer_readu32_ret do
        local v119 = u7;
        u7 = u7 + 2;
        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v119);

        if buffer_readu16_ret == 65535 then
            local v120 = u7;
            u7 = u7 + 4;
            v118 = buffer.readu32(buffer_create_ret2, v120);

            if buffer_len_ret < v118 then
                error((`[Blink]: Received a malformed delta for event {p113}.`));
            end;
        else
            local v121 = u7;
            u7 = u7 + 2;
            local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v121);

            if buffer_readu32_ret < v117 + buffer_readu16_ret + buffer_readu16_ret2 or buffer_len_ret < v118 + buffer_readu16_ret then
                error((`[Blink]: Received a malformed delta for event {p113}.`));
            end;

            buffer.copy(buffer_create_ret3, v117, v115, v118, buffer_readu16_ret);
            local v122 = v117 + buffer_readu16_ret;
            local v123 = u7;
            u7 = u7 + buffer_readu16_ret2;
            buffer.copy(buffer_create_ret3, v122, buffer_create_ret2, v123, buffer_readu16_ret2);
            v117 = v122 + buffer_readu16_ret2;
            v118 = v118 + buffer_readu16_ret + buffer_readu16_ret2;
        end;
    end;

    u84 = buffer_create_ret2;
    u83 = u7;
    buffer_create_ret2 = buffer_create_ret3;
    u7 = 0;
end;

local function EndDelta() -- Line: 798
    -- upvalues: u84 (ref), u80 (copy), u81 (ref), buffer_create_ret2 (ref), u7 (ref), u83 (ref), u82 (ref)
    local v124 = u84;

    if v124 then
        u80[u81] = buffer_create_ret2;
        buffer_create_ret2 = v124;
        u7 = u83;
        u84 = nil;

        return;
    end;

    local v125 = u7 - u82;
    local buffer_create_ret3 = buffer.create(v125);
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret2, u82, v125);
    u80[u81] = buffer_create_ret3;
end;

local function CreateRateBucket() -- Line: 819
    return {
        Window = 0,
        Warned = 0,
        Counts = {}
    };
end;

local function CheckRateLimit(p126: table, p127: string, p128: number) -- Line: 828
    local v129 = os.clock() // 1;

    if p126.Window ~= v129 then
        p126.Window = v129;
        table.clear(p126.Counts);
    end;

    local v130 = (p126.Counts[p127] or 0) + 1;
    p126.Counts[p127] = v130;

    return v130 <= p128;
end;

local function DebugFlush(p131: table, p132: number) -- Line: 844
    if #p131 == 0 then
        return;
    end;

    warn((`[Blink]: Flushed {p132} bytes this frame across {#p131} packet(s): {table.concat(p131, ", ")}`));
    table.clear(p131);
end;

return {
    Player = {},
    Character = {},
    Weapon = {},
    Gui = {},
    Entity = {},
    Particles = {},
    Spectate = {},
    Debug = {},
    Anticheat = {}
};