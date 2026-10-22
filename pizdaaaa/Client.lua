-- ReplicatedStorage.Shared.Blink.Client
-- Script path: ReplicatedStorage.Shared.Blink.Client
-- Decompile time: 301.54 ms

-- Decompiled with Potassium's decompiler.

_G._BLINK = _G._BLINK or {};

if _G._BLINK.BLINK then
    error("[Blink]: An instance of blink is already running with the remote scope \"BLINK\". Change the remote scope of either instance to avoid conflicts.");
end;

_G._BLINK.BLINK = true;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local u1 = {};
local u2 = 0;
local u3 = 64;
local u4 = 0;
local u5 = 0;
local buffer_create_ret = buffer.create(64);
local u6 = {};
local u7 = {};
local u8 = 0;
local buffer_create_ret2 = buffer.create(64);
local u9 = {};
local u10 = 0;
local u11 = newproxy();

local function Read(p12: number) -- Line: 72
    -- upvalues: u8 (ref)
    local v13 = u8;
    u8 = u8 + p12;

    return v13;
end;

local function Save(p14: table?) -- Line: 80
    -- upvalues: u3 (ref), u5 (ref), buffer_create_ret (ref), u6 (ref), u7 (ref)
    local v15 = p14 or {};
    v15.Size = u3;
    v15.Cursor = u5;
    v15.Buffer = buffer_create_ret;
    v15.Instances = u6;
    v15.Debug = u7;

    return v15;
end;

local function Load(p16: table?) -- Line: 90
    -- upvalues: u3 (ref), u5 (ref), u4 (ref), buffer_create_ret (ref), u6 (ref), u7 (ref)
    if p16 then
        u3 = p16.Size;
        u5 = p16.Cursor;
        u4 = p16.Cursor;
        buffer_create_ret = p16.Buffer;
        u6 = p16.Instances;
        u7 = p16.Debug;

        return;
    end;

    u3 = 64;
    u5 = 0;
    u4 = 0;
    buffer_create_ret = buffer.create(64);
    u6 = {};
    u7 = {};
end;

local u17 = false;
local u18 = 0;
local u19 = 0;
local u20 = u6;
local u21 = nil;

local function MarkSend(p22: table?) -- Line: 123
    -- upvalues: u17 (ref), u18 (ref), u5 (ref), u19 (ref), u6 (ref), u20 (ref), u21 (ref)
    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p22;
end;

local function CommitSend() -- Line: 131
    -- upvalues: u17 (ref), u21 (ref)
    u17 = false;
    u21 = nil;
end;

local function RewindSend() -- Line: 136
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref)
    if not u17 then
        return;
    end;

    u17 = false;
    local v23 = u20;

    for i = #v23, u19 + 1, -1 do
        v23[i] = nil;
        local _ = i;
    end;

    local v24 = u21;
    u21 = nil;

    if u6 ~= v23 then
        return;
    end;

    if v24 then
        Load(v24);

        return;
    end;

    u5 = u18;
    u4 = u18;
end;

local function Invoke() -- Line: 168
    -- upvalues: u2 (ref)
    if u2 == 255 then
        u2 = 0;
    end;

    local v25 = u2;
    u2 = u2 + 1;

    return v25;
end;

local function Allocate(p26: number) -- Line: 178
    -- upvalues: u5 (ref), u3 (ref), buffer_create_ret (ref), u4 (ref)
    local v27 = u5 + p26;

    if u3 < v27 then
        while u3 < v27 do
            u3 = math.ceil(u3 * 1.5);
        end;

        local buffer_create_ret3 = buffer.create(u3);
        buffer.copy(buffer_create_ret3, 0, buffer_create_ret, 0, u5);
        buffer_create_ret = buffer_create_ret3;
    end;

    u4 = u5;
    u5 = u5 + p26;

    return u4;
end;

local function WriteVarint(p28: number, p29: number?) -- Line: 203
    -- upvalues: Allocate (copy), buffer_create_ret (ref)
    local v30 = p29 or 0;

    if p28 < 128 then
        local v31 = Allocate(1 + v30);
        buffer.writeu8(buffer_create_ret, v31, p28);

        return v31 + 1;
    end;

    if p28 < 16384 then
        local v32 = Allocate(2 + v30);
        local v33 = bit32.band(p28, 127) + 128;
        buffer.writeu8(buffer_create_ret, v32, v33);
        local bit32_rshift_ret = bit32.rshift(p28, 7);
        buffer.writeu8(buffer_create_ret, v32 + 1, bit32_rshift_ret);

        return v32 + 2;
    end;

    if p28 <= 65535 then
        local v34 = Allocate(3 + v30);
        local v35 = bit32.band(p28, 127) + 128;
        buffer.writeu8(buffer_create_ret, v34, v35);
        local bit32_rshift_ret = bit32.rshift(p28, 7);
        local v36 = bit32.band(bit32_rshift_ret, 127) + 128;
        buffer.writeu8(buffer_create_ret, v34 + 1, v36);
        local bit32_rshift_ret2 = bit32.rshift(p28, 14);
        buffer.writeu8(buffer_create_ret, v34 + 2, bit32_rshift_ret2);

        return v34 + 3;
    end;

    error((`Expected a length of at most 65535, got {p28} instead.`));
end;

local function WriteVarintString(p37: string) -- Line: 227
    -- upvalues: WriteVarint (copy), buffer_create_ret (ref)
    local v38 = #p37;
    local v39 = WriteVarint(v38, v38);
    buffer.writestring(buffer_create_ret, v39, p37, v38);
end;

local function WriteVarintBuffer(p40: buffer) -- Line: 233
    -- upvalues: WriteVarint (copy), buffer_create_ret (ref)
    local buffer_len_ret = buffer.len(p40);
    local v41 = WriteVarint(buffer_len_ret, buffer_len_ret);
    buffer.copy(buffer_create_ret, v41, p40, 0, buffer_len_ret);
end;

local function ReadVarint() -- Line: 239
    -- upvalues: buffer_create_ret2 (ref), u8 (ref)
    local v42 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v42);

    if buffer_readu8_ret < 128 then
        return buffer_readu8_ret;
    end;

    local v43 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v43);

    if buffer_readu8_ret2 < 128 then
        if buffer_readu8_ret2 == 0 then
            error("A varint length was longer than it needs to be.");
        end;

        return buffer_readu8_ret - 128 + buffer_readu8_ret2 * 128;
    end;

    local v44 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v44);

    if buffer_readu8_ret3 == 0 or buffer_readu8_ret3 > 3 then
        error("A varint length was longer than it needs to be or past 65535.");
    end;

    return buffer_readu8_ret - 128 + (buffer_readu8_ret2 - 128) * 128 + buffer_readu8_ret3 * 16384;
end;

local function CopyOut(p45: buffer?, p46: buffer, p47: number) -- Line: 265
    if not p45 or buffer.len(p45) ~= p47 then
        p45 = buffer.create(p47);
    end;

    buffer.copy(p45, 0, p46, 0, p47);

    return p45;
end;

local u48 = nil;
local u49 = nil;
local u50 = {};

local function LoadScratch() -- Line: 277
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u48 (ref)
    if u17 then
        u17 = false;
        local v51 = u20;

        for i = #v51, u19 + 1, -1 do
            v51[i] = nil;
            local _ = i;
        end;

        local v52 = u21;
        u21 = nil;

        if u6 == v51 then
            if v52 then
                Load(v52);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    local v53 = u48;

    if v53 then
        v53.Cursor = 0;
        table.clear(v53.Instances);
        table.clear(v53.Debug);
    end;

    Load(v53);
end;

local function CreateQueue() -- Line: 290
    return {
        head = nil,
        tail = nil
    };
end;

local function Pop(p54: table) -- Line: 297
    local head = p54.head;

    if head ~= nil then
        p54.head = head.next;

        return head.value;
    end;
end;

local function Push(p55: table, p56: any) -- Line: 307
    local v57 = {
        next = nil,
        value = p56
    };

    if p55.tail ~= nil then
        p55.tail.next = v57;
    end;

    p55.tail = v57;

    if p55.head == nil then
        p55.head = v57;
    end;
end;

table.create(256);
local table_create_ret = table.create(256);
local table_create_ret2 = table.create(256);
local table_create_ret3 = table.create(256);
local table_create_ret4 = table.create(256);
local table_freeze_ret = table.freeze({});

local function CreateUnreliableBatch() -- Line: 373
    return {
        Cursor = 0,
        Buffer = buffer.create(800),
        Instances = {}
    };
end;

local function BatchIsFull(p58: table) -- Line: 382
    -- upvalues: u5 (ref), u6 (ref)
    return p58.Cursor + u5 > 800 and true or #p58.Instances + #u6 > 4096;
end;

local function AppendToBatch(p59: table) -- Line: 387
    -- upvalues: buffer_create_ret (ref), u5 (ref), u6 (ref)
    buffer.copy(p59.Buffer, p59.Cursor, buffer_create_ret, 0, u5);
    p59.Cursor = p59.Cursor + u5;
    table.move(u6, 1, #u6, #p59.Instances + 1, p59.Instances);
end;

local function CopyBatch(p60: table) -- Line: 395
    -- upvalues: u49 (ref)
    local v61 = u49;
    local Buffer = p60.Buffer;
    local Cursor = p60.Cursor;

    if not v61 or buffer.len(v61) ~= Cursor then
        v61 = buffer.create(Cursor);
    end;

    buffer.copy(v61, 0, Buffer, 0, Cursor);
    u49 = v61;

    return u49;
end;

local function PackInstances(p62: table) -- Line: 400
    if #p62 > 0 then
        return p62;
    end;

    return nil;
end;

local function IsValidPayload(p63: buffer, p64: table?) -- Line: 406
    if typeof(p63) ~= "buffer" then
        return false;
    end;

    if p64 == nil then
        return true;
    end;

    local v65;

    if typeof(p64) == "table" then
        v65 = #p64 <= 4096;
    else
        v65 = false;
    end;

    return v65;
end;

local function GetMaximumFragments(p66: number) -- Line: 419
    local math_ceil_ret = math.ceil(4294967296 / p66);

    return math.min(math_ceil_ret, 65535);
end;

local u67 = 0;

local function NextPacketId() -- Line: 424
    -- upvalues: u67 (ref)
    local v68 = u67;
    u67 = (u67 + 1) % 65536;

    return v68;
end;

local function SendFragments(p69: buffer, p70: table, p71: number, p72: function) -- Line: 432
    -- upvalues: u67 (ref)
    local buffer_len_ret = buffer.len(p69);
    local math_ceil_ret = math.ceil(buffer_len_ret / p71);

    if math_ceil_ret > 65535 then
        error((`[Blink]: Packet of {buffer_len_ret} bytes exceeds the maximum fragmented packet size of {65535 * p71} bytes.`));
    end;

    local v73 = u67;
    u67 = (u67 + 1) % 65536;

    for i = 0, math_ceil_ret - 1 do
        local v74 = i * p71;
        local math_min_ret = math.min(p71, buffer_len_ret - v74);
        local buffer_create_ret3 = buffer.create(math_min_ret + 6);
        buffer.writeu16(buffer_create_ret3, 0, v73);
        buffer.writeu16(buffer_create_ret3, 2, i);
        buffer.writeu16(buffer_create_ret3, 4, math_ceil_ret);
        buffer.copy(buffer_create_ret3, 6, p69, v74, math_min_ret);
        local v75;

        if i == 0 then
            if #p70 > 0 then
                v75 = p70;
            else
                v75 = nil;
            end;
        else
            v75 = nil;
        end;

        p72(buffer_create_ret3, v75);
        local _ = i;
    end;
end;

local function ReceiveFragment(p76: table, p77: buffer, p78: table?, p79: number) -- Line: 461
    -- upvalues: table_freeze_ret (copy)
    local v80;

    if typeof(p77) == "buffer" then
        if p78 == nil then
            v80 = true;
        elseif typeof(p78) == "table" then
            v80 = #p78 <= 4096;
        else
            v80 = false;
        end;
    else
        v80 = false;
    end;

    if not v80 then
        return nil;
    end;

    local v81 = buffer.len(p77) - 6;

    if v81 < 0 then
        return nil;
    end;

    local buffer_readu16_ret = buffer.readu16(p77, 0);
    local buffer_readu16_ret2 = buffer.readu16(p77, 2);
    local buffer_readu16_ret3 = buffer.readu16(p77, 4);

    if buffer_readu16_ret3 ~= 0 then
        local math_ceil_ret = math.ceil(4294967296 / p79);

        if math.min(math_ceil_ret, 65535) >= buffer_readu16_ret3 and buffer_readu16_ret3 > buffer_readu16_ret2 then
            if buffer_readu16_ret2 < buffer_readu16_ret3 - 1 and v81 ~= p79 then
                return nil;
            end;

            local v82 = p76[buffer_readu16_ret];

            if v82 and v82.Total ~= buffer_readu16_ret3 then
                v82 = nil;
            end;

            if not v82 then
                v82 = {
                    Received = 0,
                    Total = buffer_readu16_ret3,
                    Timestamp = os.clock(),
                    Buffers = table.create(buffer_readu16_ret3),
                    Instances = table_freeze_ret
                };
                p76[buffer_readu16_ret] = v82;
            end;

            assert(v82, "Unreachable");
            local Buffers = v82.Buffers;

            if Buffers[buffer_readu16_ret2 + 1] then
                return nil;
            end;

            Buffers[buffer_readu16_ret2 + 1] = p77;
            v82.Received = v82.Received + 1;

            if buffer_readu16_ret2 == 0 then
                v82.Instances = p78 or table_freeze_ret;
            end;

            if v82.Received < buffer_readu16_ret3 then
                return nil;
            end;

            p76[buffer_readu16_ret] = nil;
            local buffer_create_ret3 = buffer.create((buffer_readu16_ret3 - 1) * p79 + (buffer.len(Buffers[buffer_readu16_ret3]) - 6));

            for i = 1, buffer_readu16_ret3 do
                local v83 = Buffers[i];
                buffer.copy(buffer_create_ret3, (i - 1) * p79, v83, 6, buffer.len(v83) - 6);
                local _ = i;
            end;

            return buffer_create_ret3, v82.Instances;
        end;
    end;

    return nil;
end;

local function ClearStaleFragments(p84: table) -- Line: 536
    local os_clock_ret = os.clock();

    for i, v in p84 do
        if os_clock_ret - v.Timestamp >= 10 then
            p84[i] = nil;
            warn((`[Blink]: Dropped an incomplete packet, received {v.Received} out of {v.Total} fragments.`));
        end;
    end;
end;

local u85 = {
    Size = 64,
    Cursor = 0,
    Buffer = buffer.create(64),
    Instances = {},
    Debug = {}
};
local u86 = setmetatable({}, {
    __mode = "k"
});
local u87 = {};
local u88 = 0;
local u89 = 0;
local u90 = 0;
local u91 = nil;

local function FindSource(p92: buffer, p93: number, p94: buffer, p95: number) -- Line: 595
    local buffer_readu32_ret = buffer.readu32(p92, p93);
    local v96 = buffer.len(p94) - 4;

    for i = 1, 512 do
        local v97 = p95 + i;
        local v98 = p95 - i;

        if v97 <= v96 and buffer.readu32(p94, v97) == buffer_readu32_ret then
            return v97;
        end;

        if v98 >= 0 and (v98 <= v96 and buffer.readu32(p94, v98) == buffer_readu32_ret) then
            return v98;
        end;

        if v96 < v97 and v98 < 0 then
            break;
        end;

        local _ = i;
    end;

    return nil;
end;

local function EncodeDelta(p99: buffer, p100: buffer?) -- Line: 617
    -- upvalues: FindSource (copy)
    local buffer_len_ret = buffer.len(p99);

    if not p100 or buffer_len_ret <= 4 then
        return nil;
    end;

    local buffer_len_ret2 = buffer.len(p100);
    local buffer_create_ret3 = buffer.create(buffer_len_ret);
    buffer.writeu32(buffer_create_ret3, 0, buffer_len_ret);
    local v101 = 0;
    local v102 = 0;
    local v103 = 16;
    local v104 = 4;

    while true do
        if v101 >= buffer_len_ret then
            local buffer_create_ret4 = buffer.create(v104);
            buffer.copy(buffer_create_ret4, 0, buffer_create_ret3, 0, v104);

            return buffer_create_ret4;
        end;

        local math_min_ret = math.min(buffer_len_ret - v101, buffer_len_ret2 - v102);
        local v105 = 0;

        while v105 + 4 <= math_min_ret and buffer.readu32(p99, v101 + v105) == buffer.readu32(p100, v102 + v105) do
            v105 = v105 + 4;
        end;

        while v105 < math_min_ret and buffer.readu8(p99, v101 + v105) == buffer.readu8(p100, v102 + v105) do
            v105 = v105 + 1;
        end;

        local math_min_ret2 = math.min(v105, 65534);
        local v106 = v101 + math_min_ret2;
        local v107 = v102 + math_min_ret2;
        local v108 = 0;
        v102 = nil;

        while v106 + v108 < buffer_len_ret and v108 < 65534 do
            local v109 = v106 + v108;
            local v110 = v107 + v108;

            if v110 < buffer_len_ret2 and buffer.readu8(p99, v109) == buffer.readu8(p100, v110) then
                break;
            end;

            if v103 > 0 and (v108 >= 16 and (v108 % 16 == 0 and v109 + 4 <= buffer_len_ret)) then
                v103 = v103 - 1;
                v102 = FindSource(p99, v109, p100, v110);

                if v102 then
                    break;
                end;
            end;

            v108 = v108 + 1;
        end;

        if buffer_len_ret <= v104 + 4 + v108 + (v102 and 6 or 0) then
            return nil;
        end;

        buffer.writeu16(buffer_create_ret3, v104, math_min_ret2);
        buffer.writeu16(buffer_create_ret3, v104 + 2, v108);
        buffer.copy(buffer_create_ret3, v104 + 4, p99, v106, v108);
        v104 = v104 + (v108 + 4);
        v101 = v106 + v108;
        local v111 = v107 + v108;

        if v102 then
            buffer.writeu16(buffer_create_ret3, v104, 65535);
            buffer.writeu32(buffer_create_ret3, v104 + 2, v102);
            v104 = v104 + 6;
        else
            v102 = v111;
        end;
    end;
end;

local function LoadDelta() -- Line: 706
    -- upvalues: u85 (copy), Load (copy)
    u85.Cursor = 0;
    table.clear(u85.Instances);
    Load(u85);
end;

local function SaveDelta() -- Line: 714
    -- upvalues: u5 (ref), buffer_create_ret (ref), u85 (copy), u3 (ref), u6 (ref)
    local buffer_create_ret3 = buffer.create(u5);
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret, 0, u5);
    u85.Size = u3;
    u85.Buffer = buffer_create_ret;

    return buffer_create_ret3, u6;
end;

local function SendDelta(p112: userdata, p113: number, p114: buffer, p115: table) -- Line: 727
    -- upvalues: u86 (copy), EncodeDelta (copy), Allocate (copy), buffer_create_ret (ref), u6 (ref)
    local v116 = u86[p112];

    if not v116 then
        v116 = {};
        u86[p112] = v116;
    end;

    local v117 = EncodeDelta(p114, v116[p113]);
    local v118 = v117 or p114;
    local v119 = Allocate(2 + buffer.len(v118));
    buffer.writeu8(buffer_create_ret, v119, p113);
    buffer.writeu8(buffer_create_ret, v119 + 1, v117 and 1 or 0);
    buffer.copy(buffer_create_ret, v119 + 2, v118);
    table.move(p115, 1, #p115, #u6 + 1, u6);
    v116[p113] = p114;
end;

local function BeginDelta(p120: number) -- Line: 748
    -- upvalues: u88 (ref), buffer_create_ret2 (ref), u8 (ref), u91 (ref), u89 (ref), u87 (copy), u90 (ref)
    u88 = p120;
    local v121 = u8;
    u8 = u8 + 1;

    if buffer.readu8(buffer_create_ret2, v121) == 0 then
        u91 = nil;
        u89 = u8;

        return;
    end;

    local v122 = u87[p120];
    local v123 = u8;
    u8 = u8 + 4;
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret2, v123);

    if v122 then
        if buffer_readu32_ret > 4294967296 then
            error((`[Blink]: Received a delta for event {p120} of {buffer_readu32_ret} bytes, the maximum is {4294967296} bytes.`));
        end;
    else
        error((`[Blink]: Received a delta for event {p120} with no previous payload to apply it to.`));
    end;

    local buffer_create_ret3 = buffer.create(buffer_readu32_ret);
    local buffer_len_ret = buffer.len(v122);
    local v124 = 0;
    local v125 = 0;

    while v124 < buffer_readu32_ret do
        local v126 = u8;
        u8 = u8 + 2;
        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v126);

        if buffer_readu16_ret == 65535 then
            local v127 = u8;
            u8 = u8 + 4;
            v125 = buffer.readu32(buffer_create_ret2, v127);

            if buffer_len_ret < v125 then
                error((`[Blink]: Received a malformed delta for event {p120}.`));
            end;
        else
            local v128 = u8;
            u8 = u8 + 2;
            local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v128);

            if buffer_readu32_ret < v124 + buffer_readu16_ret + buffer_readu16_ret2 or buffer_len_ret < v125 + buffer_readu16_ret then
                error((`[Blink]: Received a malformed delta for event {p120}.`));
            end;

            buffer.copy(buffer_create_ret3, v124, v122, v125, buffer_readu16_ret);
            local v129 = v124 + buffer_readu16_ret;
            local v130 = u8;
            u8 = u8 + buffer_readu16_ret2;
            buffer.copy(buffer_create_ret3, v129, buffer_create_ret2, v130, buffer_readu16_ret2);
            v124 = v129 + buffer_readu16_ret2;
            v125 = v125 + buffer_readu16_ret + buffer_readu16_ret2;
        end;
    end;

    u91 = buffer_create_ret2;
    u90 = u8;
    buffer_create_ret2 = buffer_create_ret3;
    u8 = 0;
end;

local function EndDelta() -- Line: 808
    -- upvalues: u91 (ref), u87 (copy), u88 (ref), buffer_create_ret2 (ref), u8 (ref), u90 (ref), u89 (ref)
    local v131 = u91;

    if v131 then
        u87[u88] = buffer_create_ret2;
        buffer_create_ret2 = v131;
        u8 = u90;
        u91 = nil;

        return;
    end;

    local v132 = u8 - u89;
    local buffer_create_ret3 = buffer.create(v132);
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret2, u89, v132);
    u87[u88] = buffer_create_ret3;
end;

local function CreateRateBucket() -- Line: 829
    return {
        Window = 0,
        Warned = 0,
        Counts = {}
    };
end;

local function CheckRateLimit(p133: table, p134: string, p135: number) -- Line: 838
    local v136 = os.clock() // 1;

    if p133.Window ~= v136 then
        p133.Window = v136;
        table.clear(p133.Counts);
    end;

    local v137 = (p133.Counts[p134] or 0) + 1;
    p133.Counts[p134] = v137;

    return v137 <= p135;
end;

local function DebugFlush(p138: table, p139: number) -- Line: 854
    if #p138 == 0 then
        return;
    end;

    warn((`[Blink]: Flushed {p139} bytes this frame across {#p138} packet(s): {table.concat(p138, ", ")}`));
    table.clear(p138);
end;

local u140 = "?";
local u141 = nil;
table_create_ret[1] = {};
table_create_ret3[1] = table.create(256);
table_create_ret[2] = {};
table_create_ret3[2] = table.create(256);
table_create_ret[3] = {};
table_create_ret3[3] = table.create(256);
table_create_ret[4] = {};
table_create_ret3[4] = table.create(256);
table_create_ret[5] = {};
table_create_ret3[5] = table.create(256);
table_create_ret4[3] = table.create(256);
table_create_ret3[6] = table.create(256);
table_create_ret3[7] = table.create(256);
table_create_ret3[8] = table.create(256);
table_create_ret3[12] = table.create(256);
table_create_ret3[13] = table.create(256);
table_create_ret3[14] = table.create(256);
table_create_ret3[15] = table.create(256);
table_create_ret3[16] = table.create(256);
table_create_ret3[17] = table.create(256);
table_create_ret[21] = {};
table_create_ret3[21] = table.create(256);
table_create_ret[23] = {};
table_create_ret3[23] = table.create(256);
table_create_ret3[25] = table.create(256);
table_create_ret3[26] = table.create(256);
table_create_ret3[28] = table.create(256);
table_create_ret[32] = {};
table_create_ret3[32] = table.create(256);
table_create_ret3[35] = table.create(256);
table_create_ret3[37] = table.create(256);
table_create_ret3[38] = table.create(256);
table_create_ret3[39] = table.create(256);
table_create_ret3[40] = table.create(256);
table_create_ret3[41] = table.create(256);
table_create_ret3[42] = table.create(256);
table_create_ret3[43] = table.create(256);
table_create_ret3[46] = table.create(256);
table_create_ret3[48] = table.create(256);
table_create_ret4[6] = table.create(256);
table_create_ret3[69] = table.create(256);
table_create_ret3[82] = table.create(256);
table_create_ret3[84] = table.create(256);
table_create_ret[85] = {};
table_create_ret3[85] = table.create(256);
table_create_ret3[86] = table.create(256);
table_create_ret[87] = {};
table_create_ret3[87] = table.create(256);
table_create_ret3[88] = table.create(256);
table_create_ret3[89] = table.create(256);
table_create_ret3[90] = table.create(256);
table_create_ret3[91] = table.create(256);
table_create_ret3[92] = table.create(256);
table_create_ret3[93] = table.create(256);
table_create_ret3[94] = table.create(256);
table_create_ret3[95] = table.create(256);
table_create_ret3[96] = table.create(256);
table_create_ret3[97] = table.create(256);
table_create_ret3[98] = table.create(256);
table_create_ret3[99] = table.create(256);
table_create_ret3[101] = table.create(256);
table_create_ret3[102] = table.create(256);
table_create_ret3[103] = table.create(256);
table_create_ret3[104] = table.create(256);
table_create_ret4[9] = table.create(256);
table_create_ret3[105] = table.create(256);
table_create_ret3[106] = table.create(256);
table_create_ret4[10] = table.create(256);
table_create_ret3[107] = table.create(256);
table_create_ret4[11] = table.create(256);
table_create_ret4[12] = table.create(256);
table_create_ret3[108] = table.create(256);
table_create_ret3[110] = table.create(256);
table_create_ret4[13] = table.create(256);
table_create_ret3[112] = table.create(256);
table_create_ret3[113] = table.create(256);
table_create_ret3[115] = table.create(256);
table_create_ret3[116] = table.create(256);
table_create_ret3[118] = table.create(256);
table_create_ret2[15] = {};
table_create_ret4[15] = table.create(256);
table_create_ret4[17] = table.create(256);
table_create_ret3[119] = table.create(256);
table_create_ret3[120] = table.create(256);
table_create_ret3[121] = table.create(256);
table_create_ret4[18] = table.create(256);
table_create_ret4[19] = table.create(256);
table_create_ret4[20] = table.create(256);
table_create_ret4[21] = table.create(256);
table_create_ret4[22] = table.create(256);
table_create_ret3[123] = table.create(256);

function u1.Player_WriteEVENT_PlayerLoaded(p142: any, p143: table?) -- Line: 1021
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v144 = u20;

        for i = #v144, u19 + 1, -1 do
            v144[i] = nil;
            local _ = i;
        end;

        local v145 = u21;
        u21 = nil;

        if u6 == v144 then
            if v145 then
                Load(v145);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p143;
    local v146 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v146, 0);

    if p142 == nil then
        p142 = u11;
    end;

    table.insert(u6, p142);
    u17 = false;
    u21 = nil;
end;

function u1.Player_ReadEVENT_StartGameRunning() -- Line: 1031
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.Character_ReadEVENT_CharacterConstantBalls() -- Line: 1037
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v147 = {
        Key = false,
        Value = false
    };
    local v148 = ReadVarint();
    local v149 = u8;
    u8 = u8 + v148;
    v147.Key = buffer.readstring(buffer_create_ret2, v149, v148);
    local v150 = ReadVarint();
    local v151 = u8;
    u8 = u8 + v150;
    v147.Value = buffer.readstring(buffer_create_ret2, v151, v150);

    return v147;
end;

function u1.Character_ReadEVENT_CharacterTemplateBalls() -- Line: 1046
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v152 = ReadVarint();
    local table_create_ret5 = table.create(v152);

    for i = 1, v152 do
        local v153 = {
            Key = false,
            Value = false
        };
        local v154 = ReadVarint();
        local v155 = u8;
        u8 = u8 + v154;
        v153.Key = buffer.readstring(buffer_create_ret2, v155, v154);
        local v156 = ReadVarint();
        local v157 = u8;
        u8 = u8 + v156;
        v153.Value = buffer.readstring(buffer_create_ret2, v157, v156);
        table_create_ret5[i] = v153;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.Character_ReadEVENT_CreateCharacter() -- Line: 1062
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v158 = u8;
    u8 = u8 + 18;
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v158 + 0);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v158 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v158 + 8);
    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if vector_create_ret.Magnitude <= (-1 / 0) or vector_create_ret.Magnitude >= (1 / 0) then
        error((`Expected "Value1" to be a finite number, got {vector_create_ret.Magnitude} instead.`));
    end;

    return vector_create_ret, buffer.readu16(buffer_create_ret2, v158 + 12), buffer.readu32(buffer_create_ret2, v158 + 14);
end;

function u1.Character_ReadEVENT_DestroyCharacter() -- Line: 1075
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.Character_WriteEVENT_Command(p159: table, p160: table?) -- Line: 1081
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v161 = u20;

        for i = #v161, u19 + 1, -1 do
            v161[i] = nil;
            local _ = i;
        end;

        local v162 = u21;
        u21 = nil;

        if u6 == v161 then
            if v162 then
                Load(v162);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p160;
    local v163 = Allocate(27);
    buffer.writeu8(buffer_create_ret, v163 + 0, 0);
    local v164 = 0;

    if p159.Inputs.Forward == true then
        v164 = v164 + 1;
    end;

    if p159.Inputs.Backward == true then
        v164 = v164 + 2;
    end;

    if p159.Inputs.Left == true then
        v164 = v164 + 4;
    end;

    if p159.Inputs.Right == true then
        v164 = v164 + 8;
    end;

    buffer.writeu8(buffer_create_ret, v163 + 1, v164);
    local v165 = 0;

    if p159.AdditionalInputs.Duck == true then
        v165 = v165 + 1;
    end;

    if p159.AdditionalInputs.Walk == true then
        v165 = v165 + 2;
    end;

    if p159.AdditionalInputs.Jump == true then
        v165 = v165 + 4;
    end;

    if p159.AdditionalInputs.PressE == true then
        v165 = v165 + 8;
    end;

    if p159.AdditionalInputs.Ping == true then
        v165 = v165 + 16;
    end;

    buffer.writeu8(buffer_create_ret, v163 + 2, v165);

    if typeof(p159.Yaw) ~= "number" then
        error((`Expected Value.Yaw to be of type number, got {type(p159.Yaw)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v163 + 3, p159.Yaw);

    if typeof(p159.Pitch) ~= "number" then
        error((`Expected Value.Pitch to be of type number, got {type(p159.Pitch)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v163 + 5, p159.Pitch);

    if typeof(p159.ClientTick) ~= "number" then
        error((`Expected Value.ClientTick to be of type number, got {type(p159.ClientTick)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v163 + 7, p159.ClientTick);

    if typeof(p159.ServerTick) ~= "number" then
        error((`Expected Value.ServerTick to be of type number, got {type(p159.ServerTick)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v163 + 11, p159.ServerTick);

    if typeof(p159.WishEquip) ~= "number" then
        error((`Expected Value.WishEquip to be of type number, got {type(p159.WishEquip)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v163 + 15, p159.WishEquip);
    local v166 = 0;

    if p159.WishBooleans.WishInspect == true then
        v166 = v166 + 1;
    end;

    if p159.WishBooleans.WishFire == true then
        v166 = v166 + 2;
    end;

    if p159.WishBooleans.WishFire2 == true then
        v166 = v166 + 4;
    end;

    if p159.WishBooleans.WishReload == true then
        v166 = v166 + 8;
    end;

    if p159.WishBooleans.WishDrop == true then
        v166 = v166 + 16;
    end;

    buffer.writeu8(buffer_create_ret, v163 + 16, v166);

    if typeof(p159.ReceivedMask) ~= "number" then
        error((`Expected Value.ReceivedMask to be of type number, got {type(p159.ReceivedMask)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v163 + 17, p159.ReceivedMask);

    if typeof(p159.RenderTime) ~= "number" then
        error((`Expected Value.RenderTime to be of type number, got {type(p159.RenderTime)} instead.`));
    end;

    if p159.RenderTime <= (-1 / 0) or p159.RenderTime >= (1 / 0) then
        error((`Expected "Value.RenderTime" to be a finite number, got {p159.RenderTime} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v163 + 19, p159.RenderTime);
    u17 = false;
    u21 = nil;
end;

function u1.Character_WriteEVENT_CommandIdle(p167: table, p168: table?) -- Line: 1139
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v169 = u20;

        for i = #v169, u19 + 1, -1 do
            v169[i] = nil;
            local _ = i;
        end;

        local v170 = u21;
        u21 = nil;

        if u6 == v169 then
            if v170 then
                Load(v170);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p168;
    local v171 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v171 + 0, 1);

    if typeof(p167.ClientTick) ~= "number" then
        error((`Expected Value.ClientTick to be of type number, got {type(p167.ClientTick)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v171 + 1, p167.ClientTick);

    if typeof(p167.ServerTick) ~= "number" then
        error((`Expected Value.ServerTick to be of type number, got {type(p167.ServerTick)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v171 + 5, p167.ServerTick);
    u17 = false;
    u21 = nil;
end;

function u1.Character_WriteEVENT_CommandArray(p172: table, p173: table?) -- Line: 1156
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v174 = u20;

        for i = #v174, u19 + 1, -1 do
            v174[i] = nil;
            local _ = i;
        end;

        local v175 = u21;
        u21 = nil;

        if u6 == v174 then
            if v175 then
                Load(v175);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p173;
    local v176 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v176, 2);
    local v177 = #p172;
    WriteVarint(v177);
    local v178 = Allocate(v177 * 26);

    for i = 1, v177 do
        local v179 = p172[i];
        local v180 = 0;

        if v179.Inputs.Forward == true then
            v180 = v180 + 1;
        end;

        if v179.Inputs.Backward == true then
            v180 = v180 + 2;
        end;

        if v179.Inputs.Left == true then
            v180 = v180 + 4;
        end;

        if v179.Inputs.Right == true then
            v180 = v180 + 8;
        end;

        buffer.writeu8(buffer_create_ret, v178 + 0, v180);
        local v181 = 0;

        if v179.AdditionalInputs.Duck == true then
            v181 = v181 + 1;
        end;

        if v179.AdditionalInputs.Walk == true then
            v181 = v181 + 2;
        end;

        if v179.AdditionalInputs.Jump == true then
            v181 = v181 + 4;
        end;

        if v179.AdditionalInputs.PressE == true then
            v181 = v181 + 8;
        end;

        if v179.AdditionalInputs.Ping == true then
            v181 = v181 + 16;
        end;

        buffer.writeu8(buffer_create_ret, v178 + 1, v181);
        buffer.writeu16(buffer_create_ret, v178 + 2, v179.Yaw);
        buffer.writeu16(buffer_create_ret, v178 + 4, v179.Pitch);
        buffer.writeu32(buffer_create_ret, v178 + 6, v179.ClientTick);
        buffer.writeu32(buffer_create_ret, v178 + 10, v179.ServerTick);
        buffer.writeu8(buffer_create_ret, v178 + 14, v179.WishEquip);
        local v182 = 0;

        if v179.WishBooleans.WishInspect == true then
            v182 = v182 + 1;
        end;

        if v179.WishBooleans.WishFire == true then
            v182 = v182 + 2;
        end;

        if v179.WishBooleans.WishFire2 == true then
            v182 = v182 + 4;
        end;

        if v179.WishBooleans.WishReload == true then
            v182 = v182 + 8;
        end;

        if v179.WishBooleans.WishDrop == true then
            v182 = v182 + 16;
        end;

        buffer.writeu8(buffer_create_ret, v178 + 15, v182);
        buffer.writeu16(buffer_create_ret, v178 + 16, v179.ReceivedMask);
        buffer.writef64(buffer_create_ret, v178 + 18, v179.RenderTime);
        v178 = v178 + 26;
        local _ = i;
    end;

    u17 = false;
    u21 = nil;
end;

function u1.Character_ReadEVENT_HandleNewState() -- Line: 1202
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v183 = u8;
    u8 = u8 + 12;
    local v184 = {
        LastClientTick = false,
        LastServerTick = false,
        CurrentServerTick = false,
        State = false,
        WeaponState = false,
        LastClientTick = buffer.readu32(buffer_create_ret2, v183 + 0),
        LastServerTick = buffer.readu32(buffer_create_ret2, v183 + 4),
        CurrentServerTick = buffer.readu32(buffer_create_ret2, v183 + 8)
    };
    local v185 = ReadVarint();
    v184.State = buffer.create(v185);
    local v186 = u8;
    u8 = u8 + v185;
    buffer.copy(v184.State, 0, buffer_create_ret2, v186, v185);
    local v187 = ReadVarint();
    v184.WeaponState = buffer.create(v187);
    local v188 = u8;
    u8 = u8 + v187;
    buffer.copy(v184.WeaponState, 0, buffer_create_ret2, v188, v187);

    return v184;
end;

function u1.Character_ReadEVENT_SimulationProperty() -- Line: 1218
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v189 = u8;
    u8 = u8 + 1;
    local v190 = ReadVarint();
    local v191 = u8;
    u8 = u8 + v190;

    return buffer.readstring(buffer_create_ret2, v191, v190), buffer.readu8(buffer_create_ret2, v189 + 0) == 1;
end;

function u1.Weapon_ReadEVENT_CreateWeapon() -- Line: 1227
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v192 = u8;
    u8 = u8 + 8;
    local v193 = {
        ID = false,
        Slot = false,
        Skin = false,
        Owner = false,
        Ammo = false,
        ReserveAmmo = false,
        Mode = false,
        RefundAvailable = false,
        SkinId = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v192 + 0);
    v193.ID = buffer.readu8(buffer_create_ret2, v192 + 1);
    v193.Slot = buffer.readu8(buffer_create_ret2, v192 + 2);
    v193.Skin = buffer.readu8(buffer_create_ret2, v192 + 3);
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v192 + 4);
    local v194 = u8;
    u8 = u8 + buffer_readu8_ret2;
    v193.Owner = buffer.readstring(buffer_create_ret2, v194, buffer_readu8_ret2);
    v193.Ammo = buffer.readu8(buffer_create_ret2, v192 + 5);
    v193.ReserveAmmo = buffer.readu8(buffer_create_ret2, v192 + 6);
    v193.Mode = buffer.readu8(buffer_create_ret2, v192 + 7);
    v193.RefundAvailable = bit32.btest(buffer_readu8_ret, 1);

    if bit32.btest(buffer_readu8_ret, 2) == true then
        local v195 = u8;
        u8 = u8 + 7;
        local v196 = {
            Tint = false,
            Strength = false
        };
        v193.Emissive = v196;
        v196.Tint = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v195 + 0), buffer.readu8(buffer_create_ret2, v195 + 1), (buffer.readu8(buffer_create_ret2, v195 + 2)));
        v196.Strength = buffer.readf32(buffer_create_ret2, v195 + 3);

        if v196.Strength <= (-1 / 0) or v196.Strength >= (1 / 0) then
            error((`Expected "Struct_2.Strength" to be a finite number, got {v196.Strength} instead.`));
        end;
    end;

    local v197 = ReadVarint();
    local v198 = u8;
    u8 = u8 + v197;
    v193.SkinId = buffer.readstring(buffer_create_ret2, v198, v197);

    if bit32.btest(buffer_readu8_ret, 4) == true then
        local v199 = u8;
        u8 = u8 + 4;
        v193.KillTrack = buffer.readu32(buffer_create_ret2, v199 + 0);
    end;

    if bit32.btest(buffer_readu8_ret, 8) == true then
        local v200 = u8;
        u8 = u8 + 2;
        v193.KillTrackColor = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v200 + 0) do
            local v201 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v201);
            local v202 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v202);
            v193.KillTrackColor[buffer_readu8_ret3] = buffer_readu8_ret4;
            local _ = i;
        end;
    end;

    if bit32.btest(buffer_readu8_ret, 16) == true then
        local v203 = ReadVarint();
        local v204 = u8;
        u8 = u8 + v203;
        v193.NameTag = buffer.readstring(buffer_create_ret2, v204, v203);
    end;

    if bit32.btest(buffer_readu8_ret, 32) == true then
        local v205 = u8;
        u8 = u8 + 2;
        v193.Stickers = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v205 + 0) do
            local v206 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v206);
            local v207 = {
                StickerName = false,
                Position = false,
                Rotation = false
            };
            local v208 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v208);
            local v209 = ReadVarint();
            local v210 = u8;
            u8 = u8 + v209;
            v207.StickerName = buffer.readstring(buffer_create_ret2, v210, v209);
            v207.Position = {};
            local v211 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v211) do
                local v212 = u8;
                u8 = u8 + 1;
                local buffer_readu8_ret5 = buffer.readu8(buffer_create_ret2, v212);
                local v213 = u8;
                u8 = u8 + 4;
                local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v213);

                if buffer_readf32_ret <= (-1 / 0) or buffer_readf32_ret >= (1 / 0) then
                    error((`Expected "Element_3" to be a finite number, got {buffer_readf32_ret} instead.`));
                end;

                v207.Position[buffer_readu8_ret5] = buffer_readf32_ret;
                local _ = i2;
            end;

            local v214 = u8;
            u8 = u8 + 4;
            v207.Rotation = buffer.readf32(buffer_create_ret2, v214);

            if v207.Rotation <= (-1 / 0) or v207.Rotation >= (1 / 0) then
                error((`Expected "Element_2.Rotation" to be a finite number, got {v207.Rotation} instead.`));
            end;

            if bit32.btest(buffer_readu8_ret4, 1) == true then
                local v215 = u8;
                u8 = u8 + 1;
                v207.Size = buffer.readu8(buffer_create_ret2, v215 + 0);
            end;

            v193.Stickers[buffer_readu8_ret3] = v207;
        end;
    end;

    return v193;
end;

function u1.Weapon_ReadEVENT_DestroyWeapon() -- Line: 1312
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v216 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v216 + 0);
end;

function u1.Weapon_WriteEVENT_BuyWeapon(p217: table, p218: table?) -- Line: 1319
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v219 = u20;

        for i = #v219, u19 + 1, -1 do
            v219[i] = nil;
            local _ = i;
        end;

        local v220 = u21;
        u21 = nil;

        if u6 == v219 then
            if v220 then
                Load(v220);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p218;
    local v221 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v221 + 0, 9);
    local v222 = 0;

    if typeof(p217.Drop) ~= "boolean" then
        error((`Expected Value.Drop to be of type boolean, got {type(p217.Drop)} instead.`));
    end;

    if p217.Drop then
        v222 = v222 + 1;
    end;

    buffer.writeu8(buffer_create_ret, v221 + 1, v222);

    if typeof(p217.Enum) ~= "number" then
        error((`Expected Value.Enum to be of type number, got {type(p217.Enum)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v221 + 2, p217.Enum);
    u17 = false;
    u21 = nil;
end;

function u1.Weapon_WriteEVENT_PickUpWeapon(p223: number, p224: table?) -- Line: 1338
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v225 = u20;

        for i = #v225, u19 + 1, -1 do
            v225[i] = nil;
            local _ = i;
        end;

        local v226 = u21;
        u21 = nil;

        if u6 == v225 then
            if v226 then
                Load(v226);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p224;
    local v227 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v227 + 0, 10);

    if typeof(p223) ~= "number" then
        error((`Expected Value to be of type number, got {type(p223)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v227 + 1, p223);
    u17 = false;
    u21 = nil;
end;

function u1.Weapon_WriteEVENT_RefundWeapon(p228: table, p229: table?) -- Line: 1351
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v230 = u20;

        for i = #v230, u19 + 1, -1 do
            v230[i] = nil;
            local _ = i;
        end;

        local v231 = u21;
        u21 = nil;

        if u6 == v230 then
            if v231 then
                Load(v231);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p229;
    local v232 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v232 + 0, 11);
    local v233 = 0;

    if p228.Slot ~= nil then
        v233 = v233 + 1;
    end;

    buffer.writeu8(buffer_create_ret, v232 + 1, v233);

    if typeof(p228.Type) ~= "string" then
        error((`Expected Value.Type to be of type string, got {type(p228.Type)} instead.`));
    end;

    local Type = p228.Type;
    local v234 = #Type;
    local v235 = WriteVarint(v234, v234);
    buffer.writestring(buffer_create_ret, v235, Type, v234);

    if p228.Slot ~= nil then
        local v236 = Allocate(1);

        if typeof(p228.Slot) ~= "number" then
            error((`Expected Value.Slot to be of type number, got {type(p228.Slot)} instead.`));
        end;

        buffer.writeu8(buffer_create_ret, v236 + 0, p228.Slot);
    end;

    u17 = false;
    u21 = nil;
end;

function u1.Weapon_ReadEVENT_ForceEquip() -- Line: 1375
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v237 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v237 + 0);
end;

function u1.Weapon_ReadEVENT_OnWeaponPickup() -- Line: 1382
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v238 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v238 + 0);
end;

function u1.Weapon_ReadEVENT_WeaponReset() -- Line: 1389
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.Weapon_ReadEVENT_Constant() -- Line: 1395
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v239 = u8;
    u8 = u8 + 2;
    local v240 = {
        Slot = false,
        All = false,
        Key = false,
        Value = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v239 + 0);
    v240.Slot = buffer.readu8(buffer_create_ret2, v239 + 1);
    v240.All = bit32.btest(buffer_readu8_ret, 1);
    local v241 = ReadVarint();
    local v242 = u8;
    u8 = u8 + v241;
    v240.Key = buffer.readstring(buffer_create_ret2, v242, v241);
    local v243 = ReadVarint();
    local v244 = u8;
    u8 = u8 + v243;
    v240.Value = buffer.readstring(buffer_create_ret2, v244, v243);

    return v240;
end;

function u1.Weapon_ReadEVENT_Template() -- Line: 1409
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v245 = {
        Weapon = false,
        Entries = false
    };
    local v246 = ReadVarint();
    local v247 = u8;
    u8 = u8 + v246;
    v245.Weapon = buffer.readstring(buffer_create_ret2, v247, v246);
    local v248 = ReadVarint();
    v245.Entries = table.create(v248);

    for i = 1, v248 do
        local v249 = {
            Key = false,
            Value = false
        };
        local v250 = ReadVarint();
        local v251 = u8;
        u8 = u8 + v250;
        v249.Key = buffer.readstring(buffer_create_ret2, v251, v250);
        local v252 = ReadVarint();
        local v253 = u8;
        u8 = u8 + v252;
        v249.Value = buffer.readstring(buffer_create_ret2, v253, v252);
        v245.Entries[i] = v249;
        local _ = i;
    end;

    return v245;
end;

function u1.Gui_ReadEVENT_BuyRejected() -- Line: 1428
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v254 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v254 + 0);
end;

function u1.Gui_WriteEVENT_ViewmodelPreset(p255: string, p256: table?) -- Line: 1435
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v257 = u20;

        for i = #v257, u19 + 1, -1 do
            v257[i] = nil;
            local _ = i;
        end;

        local v258 = u21;
        u21 = nil;

        if u6 == v257 then
            if v258 then
                Load(v258);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p256;
    local v259 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v259 + 0, 18);

    if p255 == "Remove" then
        buffer.writeu8(buffer_create_ret, v259 + 1, 0);
    elseif p255 == "Reset" then
        buffer.writeu8(buffer_create_ret, v259 + 1, 1);
    else
        error((`Unexpected enum: {p255}, expected one of "Remove" or "Reset".`));
    end;

    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_WatchAdReward(p260: number, p261: table?) -- Line: 1451
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v262 = u20;

        for i = #v262, u19 + 1, -1 do
            v262[i] = nil;
            local _ = i;
        end;

        local v263 = u21;
        u21 = nil;

        if u6 == v262 then
            if v263 then
                Load(v263);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p261;
    local v264 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v264 + 0, 19);

    if typeof(p260) ~= "number" then
        error((`Expected Value to be of type number, got {type(p260)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v264 + 1, p260);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_UseStarCode(p265: string, p266: table?) -- Line: 1464
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v267 = u20;

        for i = #v267, u19 + 1, -1 do
            v267[i] = nil;
            local _ = i;
        end;

        local v268 = u21;
        u21 = nil;

        if u6 == v267 then
            if v268 then
                Load(v268);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p266;
    local v269 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v269, 20);

    if typeof(p265) ~= "string" then
        error((`Expected Value to be of type string, got {type(p265)} instead.`));
    end;

    local v270 = #p265;
    local v271 = WriteVarint(v270, v270);
    buffer.writestring(buffer_create_ret, v271, p265, v270);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_UsedStarCodeUpdate() -- Line: 1477
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v272 = ReadVarint();
    local v273 = u8;
    u8 = u8 + v272;

    return buffer.readstring(buffer_create_ret2, v273, v272);
end;

function u1.Gui_WriteEVENT_ApplyKillTrackColor(p274: table, p275: table?) -- Line: 1483
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v276 = u20;

        for i = #v276, u19 + 1, -1 do
            v276[i] = nil;
            local _ = i;
        end;

        local v277 = u21;
        u21 = nil;

        if u6 == v276 then
            if v277 then
                Load(v277);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p275;
    local v278 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v278 + 0, 22);

    if typeof(p274.WeaponName) ~= "number" then
        error((`Expected Value.WeaponName to be of type number, got {type(p274.WeaponName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v278 + 1, p274.WeaponName);

    if typeof(p274.SkinName) ~= "number" then
        error((`Expected Value.SkinName to be of type number, got {type(p274.SkinName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v278 + 2, p274.SkinName);

    if typeof(p274.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p274.SkinId)} instead.`));
    end;

    local SkinId = p274.SkinId;
    local v279 = #SkinId;
    local v280 = WriteVarint(v279, v279);
    buffer.writestring(buffer_create_ret, v280, SkinId, v279);
    local v281 = 0;

    for i, v in p274.Color do
        v281 = v281 + 1;

        if typeof(i) ~= "number" then
            error((`Expected Key_1 to be of type number, got {type(i)} instead.`));
        end;

        local v282 = Allocate(1);
        buffer.writeu8(buffer_create_ret, v282, i);

        if typeof(v) ~= "number" then
            error((`Expected Element_1 to be of type number, got {type(v)} instead.`));
        end;

        local v283 = Allocate(1);
        buffer.writeu8(buffer_create_ret, v283, v);
    end;

    if v281 > 65535 then
        error((`Expected "Elements_1" to be smaller than 65535, got {v281} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v278 + 3, v281);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_KillTrackColorUpdate() -- Line: 1520
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v284 = u8;
    u8 = u8 + 4;
    local v285 = {
        WeaponName = false,
        SkinName = false,
        SkinId = false,
        Color = false,
        WeaponName = buffer.readu8(buffer_create_ret2, v284 + 0),
        SkinName = buffer.readu8(buffer_create_ret2, v284 + 1)
    };
    local v286 = ReadVarint();
    local v287 = u8;
    u8 = u8 + v286;
    v285.SkinId = buffer.readstring(buffer_create_ret2, v287, v286);
    v285.Color = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v284 + 2) do
        local v288 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v288);
        local v289 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v289);
        v285.Color[buffer_readu8_ret] = buffer_readu8_ret2;
        local _ = i;
    end;

    return v285;
end;

function u1.Gui_WriteEVENT_BuyFuserScroll(p290: table, p291: table?) -- Line: 1540
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v292 = u20;

        for i = #v292, u19 + 1, -1 do
            v292[i] = nil;
            local _ = i;
        end;

        local v293 = u21;
        u21 = nil;

        if u6 == v292 then
            if v293 then
                Load(v293);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p291;
    local v294 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v294 + 0, 24);

    if typeof(p290.Amount) ~= "number" then
        error((`Expected Value.Amount to be of type number, got {type(p290.Amount)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v294 + 1, p290.Amount);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_FuserScrollsUpdate() -- Line: 1553
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v295 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v295 + 0);
end;

function u1.Gui_ReadEVENT_AnalyticsUpdate() -- Line: 1560
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v296 = ReadVarint();
    local buffer_create_ret3 = buffer.create(v296);
    local v297 = u8;
    u8 = u8 + v296;
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret2, v297, v296);

    return buffer_create_ret3;
end;

function u1.Gui_WriteEVENT_RequestMatch(p298: number, p299: table?) -- Line: 1567
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v300 = u20;

        for i = #v300, u19 + 1, -1 do
            v300[i] = nil;
            local _ = i;
        end;

        local v301 = u21;
        u21 = nil;

        if u6 == v300 then
            if v301 then
                Load(v301);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p299;
    local v302 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v302 + 0, 27);

    if typeof(p298) ~= "number" then
        error((`Expected Value to be of type number, got {type(p298)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v302 + 1, p298);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_MatchData() -- Line: 1580
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v303 = u8;
    u8 = u8 + 4;
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret2, v303 + 0);
    local v304 = ReadVarint();
    local buffer_create_ret3 = buffer.create(v304);
    local v305 = u8;
    u8 = u8 + v304;
    buffer.copy(buffer_create_ret3, 0, buffer_create_ret2, v305, v304);

    return buffer_readu32_ret, buffer_create_ret3;
end;

function u1.Gui_WriteEVENT_ApplyNameTag(p306: table, p307: table?) -- Line: 1590
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v308 = u20;

        for i = #v308, u19 + 1, -1 do
            v308[i] = nil;
            local _ = i;
        end;

        local v309 = u21;
        u21 = nil;

        if u6 == v308 then
            if v309 then
                Load(v309);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p307;
    local v310 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v310 + 0, 29);

    if typeof(p306.WeaponName) ~= "number" then
        error((`Expected Value.WeaponName to be of type number, got {type(p306.WeaponName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v310 + 1, p306.WeaponName);

    if typeof(p306.SkinName) ~= "number" then
        error((`Expected Value.SkinName to be of type number, got {type(p306.SkinName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v310 + 2, p306.SkinName);

    if typeof(p306.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p306.SkinId)} instead.`));
    end;

    local SkinId = p306.SkinId;
    local v311 = #SkinId;
    local v312 = WriteVarint(v311, v311);
    buffer.writestring(buffer_create_ret, v312, SkinId, v311);

    if typeof(p306.NameTag) ~= "string" then
        error((`Expected Value.NameTag to be of type string, got {type(p306.NameTag)} instead.`));
    end;

    local NameTag = p306.NameTag;
    local v313 = #NameTag;
    local v314 = WriteVarint(v313, v313);
    buffer.writestring(buffer_create_ret, v314, NameTag, v313);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_RemoveNameTag(p315: table, p316: table?) -- Line: 1615
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v317 = u20;

        for i = #v317, u19 + 1, -1 do
            v317[i] = nil;
            local _ = i;
        end;

        local v318 = u21;
        u21 = nil;

        if u6 == v317 then
            if v318 then
                Load(v318);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p316;
    local v319 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v319 + 0, 30);

    if typeof(p315.WeaponName) ~= "number" then
        error((`Expected Value.WeaponName to be of type number, got {type(p315.WeaponName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v319 + 1, p315.WeaponName);

    if typeof(p315.SkinName) ~= "number" then
        error((`Expected Value.SkinName to be of type number, got {type(p315.SkinName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v319 + 2, p315.SkinName);

    if typeof(p315.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p315.SkinId)} instead.`));
    end;

    local SkinId = p315.SkinId;
    local v320 = #SkinId;
    local v321 = WriteVarint(v320, v320);
    buffer.writestring(buffer_create_ret, v321, SkinId, v320);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ApplyKillTrack(p322: table, p323: table?) -- Line: 1636
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v324 = u20;

        for i = #v324, u19 + 1, -1 do
            v324[i] = nil;
            local _ = i;
        end;

        local v325 = u21;
        u21 = nil;

        if u6 == v324 then
            if v325 then
                Load(v325);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p323;
    local v326 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v326 + 0, 31);

    if typeof(p322.WeaponName) ~= "number" then
        error((`Expected Value.WeaponName to be of type number, got {type(p322.WeaponName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v326 + 1, p322.WeaponName);

    if typeof(p322.SkinName) ~= "number" then
        error((`Expected Value.SkinName to be of type number, got {type(p322.SkinName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v326 + 2, p322.SkinName);

    if typeof(p322.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p322.SkinId)} instead.`));
    end;

    local SkinId = p322.SkinId;
    local v327 = #SkinId;
    local v328 = WriteVarint(v327, v327);
    buffer.writestring(buffer_create_ret, v328, SkinId, v327);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_KillTrackUpdate() -- Line: 1657
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v329 = u8;
    u8 = u8 + 6;
    local v330 = {
        WeaponName = false,
        SkinName = false,
        SkinId = false,
        KillTrack = false,
        WeaponName = buffer.readu8(buffer_create_ret2, v329 + 0),
        SkinName = buffer.readu8(buffer_create_ret2, v329 + 1)
    };
    local v331 = ReadVarint();
    local v332 = u8;
    u8 = u8 + v331;
    v330.SkinId = buffer.readstring(buffer_create_ret2, v332, v331);
    v330.KillTrack = buffer.readu32(buffer_create_ret2, v329 + 2);

    return v330;
end;

function u1.Gui_WriteEVENT_RemoveKillTrack(p333: table, p334: table?) -- Line: 1669
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v335 = u20;

        for i = #v335, u19 + 1, -1 do
            v335[i] = nil;
            local _ = i;
        end;

        local v336 = u21;
        u21 = nil;

        if u6 == v335 then
            if v336 then
                Load(v336);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p334;
    local v337 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v337 + 0, 33);

    if typeof(p333.WeaponName) ~= "number" then
        error((`Expected Value.WeaponName to be of type number, got {type(p333.WeaponName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v337 + 1, p333.WeaponName);

    if typeof(p333.SkinName) ~= "number" then
        error((`Expected Value.SkinName to be of type number, got {type(p333.SkinName)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v337 + 2, p333.SkinName);

    if typeof(p333.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p333.SkinId)} instead.`));
    end;

    local SkinId = p333.SkinId;
    local v338 = #SkinId;
    local v339 = WriteVarint(v338, v338);
    buffer.writestring(buffer_create_ret, v339, SkinId, v338);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_RequestServerList(p340: any, p341: table?) -- Line: 1690
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v342 = u20;

        for i = #v342, u19 + 1, -1 do
            v342[i] = nil;
            local _ = i;
        end;

        local v343 = u21;
        u21 = nil;

        if u6 == v342 then
            if v343 then
                Load(v343);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p341;
    local v344 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v344, 34);

    if p340 == nil then
        p340 = u11;
    end;

    table.insert(u6, p340);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_ServerListResult() -- Line: 1700
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v345 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v345 + 0);

    if buffer_readu8_ret > 100 then
        error((`Expected "Length" to be smaller than 100, got {buffer_readu8_ret} instead.`));
    end;

    local table_create_ret5 = table.create(buffer_readu8_ret);
    local v346 = u8;
    u8 = u8 + buffer_readu8_ret * 5;

    for i = 1, buffer_readu8_ret do
        local v347 = {
            JobId = false,
            Mode = false,
            Map = false,
            Amount = false,
            MaxPlayers = false
        };
        local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v346 + 0);
        local v348 = ReadVarint();
        local v349 = u8;
        u8 = u8 + v348;
        v347.JobId = buffer.readstring(buffer_create_ret2, v349, v348);
        v347.Mode = buffer.readu8(buffer_create_ret2, v346 + 1);
        v347.Map = buffer.readu8(buffer_create_ret2, v346 + 2);
        v347.Amount = buffer.readu8(buffer_create_ret2, v346 + 3);
        v347.MaxPlayers = buffer.readu8(buffer_create_ret2, v346 + 4);

        if bit32.btest(buffer_readu8_ret2, 1) == true then
            local v350 = u8;
            u8 = u8 + 1;
            v347.Country = buffer.readu8(buffer_create_ret2, v350 + 0);
        end;

        table_create_ret5[i] = v347;
        v346 = v346 + 5;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.Gui_WriteEVENT_RequestProfileBadges(p351: number, p352: table?) -- Line: 1730
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v353 = u20;

        for i = #v353, u19 + 1, -1 do
            v353[i] = nil;
            local _ = i;
        end;

        local v354 = u21;
        u21 = nil;

        if u6 == v353 then
            if v354 then
                Load(v354);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p352;
    local v355 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v355 + 0, 36);

    if typeof(p351) ~= "number" then
        error((`Expected Value to be of type number, got {type(p351)} instead.`));
    end;

    if p351 <= (-1 / 0) or p351 >= (1 / 0) then
        error((`Expected "Value" to be a finite number, got {p351} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v355 + 1, p351);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_ProfileBadges() -- Line: 1744
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v356 = u8;
    u8 = u8 + 10;
    local buffer_readf64_ret = buffer.readf64(buffer_create_ret2, v356 + 0);

    if buffer_readf64_ret <= (-1 / 0) or buffer_readf64_ret >= (1 / 0) then
        error((`Expected "Value1" to be a finite number, got {buffer_readf64_ret} instead.`));
    end;

    local v357 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v356 + 8) do
        local v358 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v358);
        local v359 = u8;
        u8 = u8 + 1;
        v357[buffer_readu8_ret] = buffer.readu8(buffer_create_ret2, v359);
        local _ = i;
    end;

    return buffer_readf64_ret, v357;
end;

function u1.Gui_ReadEVENT_MatchEndStats() -- Line: 1761
    -- upvalues: ReadVarint (copy), u8 (ref), buffer_create_ret2 (ref)
    local v360 = ReadVarint();
    local table_create_ret5 = table.create(v360);
    local v361 = u8;
    u8 = u8 + v360 * 13;

    for i = 1, v360 do
        local v362 = {
            UserId = false,
            MatchADR = false,
            MatchHSP = false,
            MatchClass = false,
            MatchClassInfo = false,
            UserId = buffer.readf64(buffer_create_ret2, v361 + 0)
        };

        if v362.UserId <= (-1 / 0) or v362.UserId >= (1 / 0) then
            error((`Expected "Item_1.UserId" to be a finite number, got {v362.UserId} instead.`));
        end;

        v362.MatchADR = buffer.readu16(buffer_create_ret2, v361 + 8);
        v362.MatchHSP = buffer.readu8(buffer_create_ret2, v361 + 10);
        v362.MatchClass = buffer.readu8(buffer_create_ret2, v361 + 11);
        v362.MatchClassInfo = buffer.readu8(buffer_create_ret2, v361 + 12);
        table_create_ret5[i] = v362;
        v361 = v361 + 13;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.Gui_ReadEVENT_NewContainerMessage() -- Line: 1782
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v363 = {
        Sender = false,
        Text = false
    };
    local v364 = ReadVarint();
    local v365 = u8;
    u8 = u8 + v364;
    v363.Sender = buffer.readstring(buffer_create_ret2, v365, v364);
    local v366 = ReadVarint();
    local v367 = u8;
    u8 = u8 + v366;
    v363.Text = buffer.readstring(buffer_create_ret2, v367, v366);

    return v363;
end;

function u1.Gui_ReadEVENT_GlobalMessage() -- Line: 1791
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v368 = u8;
    u8 = u8 + 8;
    local v369 = {
        Sender = false,
        SenderID = false,
        Text = false
    };
    local v370 = ReadVarint();
    local v371 = u8;
    u8 = u8 + v370;
    v369.Sender = buffer.readstring(buffer_create_ret2, v371, v370);
    v369.SenderID = buffer.readf64(buffer_create_ret2, v368 + 0);

    if v369.SenderID <= (-1 / 0) or v369.SenderID >= (1 / 0) then
        error((`Expected "Value.SenderID" to be a finite number, got {v369.SenderID} instead.`));
    end;

    local v372 = ReadVarint();
    local v373 = u8;
    u8 = u8 + v372;
    v369.Text = buffer.readstring(buffer_create_ret2, v373, v372);

    return v369;
end;

function u1.Gui_ReadEVENT_NewMessage() -- Line: 1804
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v374 = u8;
    u8 = u8 + 1;
    local v375 = {
        Sender = false,
        Team = false,
        Text = false
    };
    local v376 = ReadVarint();
    local v377 = u8;
    u8 = u8 + v376;
    v375.Sender = buffer.readstring(buffer_create_ret2, v377, v376);
    v375.Team = buffer.readu8(buffer_create_ret2, v374 + 0);
    local v378 = ReadVarint();
    local v379 = u8;
    u8 = u8 + v378;
    v375.Text = buffer.readstring(buffer_create_ret2, v379, v378);

    return v375;
end;

function u1.Gui_ReadEVENT_NewMessageTeam() -- Line: 1816
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v380 = u8;
    u8 = u8 + 1;
    local v381 = {
        Sender = false,
        Team = false,
        Text = false
    };
    local v382 = ReadVarint();
    local v383 = u8;
    u8 = u8 + v382;
    v381.Sender = buffer.readstring(buffer_create_ret2, v383, v382);
    v381.Team = buffer.readu8(buffer_create_ret2, v380 + 0);
    local v384 = ReadVarint();
    local v385 = u8;
    u8 = u8 + v384;
    v381.Text = buffer.readstring(buffer_create_ret2, v385, v384);

    return v381;
end;

function u1.Gui_ReadEVENT_NewAwardMessage() -- Line: 1828
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v386 = u8;
    u8 = u8 + 3;
    local v387;

    if buffer.readu8(buffer_create_ret2, v386 + 0) == 1 then
        local v388 = u8;
        u8 = u8 + 2;
        v387 = buffer.readu16(buffer_create_ret2, v388 + 0);
    else
        v387 = nil;
    end;

    local v389;

    if buffer.readu8(buffer_create_ret2, v386 + 1) == 1 then
        local v390 = u8;
        u8 = u8 + 1;
        v389 = buffer.readu8(buffer_create_ret2, v390 + 0);
    else
        v389 = nil;
    end;

    local v391;

    if buffer.readu8(buffer_create_ret2, v386 + 2) == 1 then
        local v392 = u8;
        u8 = u8 + 1;
        v391 = buffer.readu8(buffer_create_ret2, v392 + 0);
    else
        v391 = nil;
    end;

    return v387, v389, v391;
end;

function u1.Gui_WriteEVENT_GiftGamepass(p393: table, p394: table?) -- Line: 1852
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v395 = u20;

        for i = #v395, u19 + 1, -1 do
            v395[i] = nil;
            local _ = i;
        end;

        local v396 = u21;
        u21 = nil;

        if u6 == v395 then
            if v396 then
                Load(v396);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p394;
    local v397 = Allocate(17);
    buffer.writeu8(buffer_create_ret, v397 + 0, 44);

    if typeof(p393.GamepassId) ~= "number" then
        error((`Expected Value.GamepassId to be of type number, got {type(p393.GamepassId)} instead.`));
    end;

    if p393.GamepassId <= (-1 / 0) or p393.GamepassId >= (1 / 0) then
        error((`Expected "Value.GamepassId" to be a finite number, got {p393.GamepassId} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v397 + 1, p393.GamepassId);

    if typeof(p393.UserId) ~= "number" then
        error((`Expected Value.UserId to be of type number, got {type(p393.UserId)} instead.`));
    end;

    if p393.UserId <= (-1 / 0) or p393.UserId >= (1 / 0) then
        error((`Expected "Value.UserId" to be a finite number, got {p393.UserId} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v397 + 9, p393.UserId);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_LeftArm(p398: boolean, p399: table?) -- Line: 1871
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v400 = u20;

        for i = #v400, u19 + 1, -1 do
            v400[i] = nil;
            local _ = i;
        end;

        local v401 = u21;
        u21 = nil;

        if u6 == v400 then
            if v401 then
                Load(v401);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p399;
    local v402 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v402 + 0, 45);

    if typeof(p398) ~= "boolean" then
        error((`Expected Value to be of type boolean, got {type(p398)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v402 + 1, p398 and 1 or 0);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_DamageIndicator() -- Line: 1884
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v403 = u8;
    u8 = u8 + 12;
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v403 + 0);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v403 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v403 + 8);
    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if vector_create_ret.Magnitude <= (-1 / 0) or vector_create_ret.Magnitude >= (1 / 0) then
        error((`Expected "Value" to be a finite number, got {vector_create_ret.Magnitude} instead.`));
    end;

    return vector_create_ret;
end;

function u1.Gui_WriteEVENT_BuyGamepass(p404: number, p405: table?) -- Line: 1895
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v406 = u20;

        for i = #v406, u19 + 1, -1 do
            v406[i] = nil;
            local _ = i;
        end;

        local v407 = u21;
        u21 = nil;

        if u6 == v406 then
            if v407 then
                Load(v407);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p405;
    local v408 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v408 + 0, 47);

    if typeof(p404) ~= "number" then
        error((`Expected Value to be of type number, got {type(p404)} instead.`));
    end;

    if p404 <= (-1 / 0) or p404 >= (1 / 0) then
        error((`Expected "Value" to be a finite number, got {p404} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v408 + 1, p404);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_MenuNotification() -- Line: 1909
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref), u10 (ref), u9 (ref)
    local v409 = {
        Message = false,
        Color = false
    };
    local v410 = ReadVarint();
    local v411 = u8;
    u8 = u8 + v410;
    v409.Message = buffer.readstring(buffer_create_ret2, v411, v410);
    u10 = u10 + 1;
    v409.Color = u9[u10];

    return v409;
end;

function u1.Gui_WriteEVENT_VotekickPlayer(p412: table, p413: table?) -- Line: 1918
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v414 = u20;

        for i = #v414, u19 + 1, -1 do
            v414[i] = nil;
            local _ = i;
        end;

        local v415 = u21;
        u21 = nil;

        if u6 == v414 then
            if v415 then
                Load(v415);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p413;
    local v416 = Allocate(10);
    buffer.writeu8(buffer_create_ret, v416 + 0, 49);

    if typeof(p412.UserId) ~= "number" then
        error((`Expected Value.UserId to be of type number, got {type(p412.UserId)} instead.`));
    end;

    if p412.UserId <= (-1 / 0) or p412.UserId >= (1 / 0) then
        error((`Expected "Value.UserId" to be a finite number, got {p412.UserId} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v416 + 1, p412.UserId);

    if typeof(p412.Reason) ~= "number" then
        error((`Expected Value.Reason to be of type number, got {type(p412.Reason)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v416 + 9, p412.Reason);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_Votekick(p417: boolean, p418: table?) -- Line: 1936
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v419 = u20;

        for i = #v419, u19 + 1, -1 do
            v419[i] = nil;
            local _ = i;
        end;

        local v420 = u21;
        u21 = nil;

        if u6 == v419 then
            if v420 then
                Load(v420);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p418;
    local v421 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v421 + 0, 50);

    if typeof(p417) ~= "boolean" then
        error((`Expected Value to be of type boolean, got {type(p417)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v421 + 1, p417 and 1 or 0);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_CopyViewmodel(p422: number, p423: table?) -- Line: 1949
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v424 = u20;

        for i = #v424, u19 + 1, -1 do
            v424[i] = nil;
            local _ = i;
        end;

        local v425 = u21;
        u21 = nil;

        if u6 == v424 then
            if v425 then
                Load(v425);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p423;
    local v426 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v426 + 0, 51);

    if typeof(p422) ~= "number" then
        error((`Expected Value to be of type number, got {type(p422)} instead.`));
    end;

    if p422 <= (-1 / 0) or p422 >= (1 / 0) then
        error((`Expected "Value" to be a finite number, got {p422} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v426 + 1, p422);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_CopyCrosshair2(p427: string, p428: table?) -- Line: 1963
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v429 = u20;

        for i = #v429, u19 + 1, -1 do
            v429[i] = nil;
            local _ = i;
        end;

        local v430 = u21;
        u21 = nil;

        if u6 == v429 then
            if v430 then
                Load(v430);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p428;
    local v431 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v431, 52);

    if typeof(p427) ~= "string" then
        error((`Expected Value to be of type string, got {type(p427)} instead.`));
    end;

    local v432 = #p427;
    local v433 = WriteVarint(v432, v432);
    buffer.writestring(buffer_create_ret, v433, p427, v432);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_CopyViewmodel2(p434: string, p435: table?) -- Line: 1976
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v436 = u20;

        for i = #v436, u19 + 1, -1 do
            v436[i] = nil;
            local _ = i;
        end;

        local v437 = u21;
        u21 = nil;

        if u6 == v436 then
            if v437 then
                Load(v437);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p435;
    local v438 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v438, 53);

    if typeof(p434) ~= "string" then
        error((`Expected Value to be of type string, got {type(p434)} instead.`));
    end;

    local v439 = #p434;
    local v440 = WriteVarint(v439, v439);
    buffer.writestring(buffer_create_ret, v440, p434, v439);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_CopyCrosshair(p441: number, p442: table?) -- Line: 1989
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v443 = u20;

        for i = #v443, u19 + 1, -1 do
            v443[i] = nil;
            local _ = i;
        end;

        local v444 = u21;
        u21 = nil;

        if u6 == v443 then
            if v444 then
                Load(v444);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p442;
    local v445 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v445 + 0, 54);

    if typeof(p441) ~= "number" then
        error((`Expected Value to be of type number, got {type(p441)} instead.`));
    end;

    if p441 <= (-1 / 0) or p441 >= (1 / 0) then
        error((`Expected "Value" to be a finite number, got {p441} instead.`));
    end;

    buffer.writef64(buffer_create_ret, v445 + 1, p441);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_SelectTeam(p446: number, p447: table?) -- Line: 2003
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v448 = u20;

        for i = #v448, u19 + 1, -1 do
            v448[i] = nil;
            local _ = i;
        end;

        local v449 = u21;
        u21 = nil;

        if u6 == v448 then
            if v449 then
                Load(v449);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p447;
    local v450 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v450 + 0, 55);

    if typeof(p446) ~= "number" then
        error((`Expected Value to be of type number, got {type(p446)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v450 + 1, p446);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_SendMessage(p451: string, p452: table?) -- Line: 2016
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v453 = u20;

        for i = #v453, u19 + 1, -1 do
            v453[i] = nil;
            local _ = i;
        end;

        local v454 = u21;
        u21 = nil;

        if u6 == v453 then
            if v454 then
                Load(v454);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p452;
    local v455 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v455, 4);

    if typeof(p451) ~= "string" then
        error((`Expected Value to be of type string, got {type(p451)} instead.`));
    end;

    local v456 = #p451;
    local v457 = WriteVarint(v456, v456);
    buffer.writestring(buffer_create_ret, v457, p451, v456);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_VoteForMap(p458: string, p459: table?) -- Line: 2029
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v460 = u20;

        for i = #v460, u19 + 1, -1 do
            v460[i] = nil;
            local _ = i;
        end;

        local v461 = u21;
        u21 = nil;

        if u6 == v460 then
            if v461 then
                Load(v461);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p459;
    local v462 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v462, 5);

    if typeof(p458) ~= "string" then
        error((`Expected Value to be of type string, got {type(p458)} instead.`));
    end;

    local v463 = #p458;
    local v464 = WriteVarint(v463, v463);
    buffer.writestring(buffer_create_ret, v464, p458, v463);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_Ping() -- Line: 2042
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v465 = u8;
    u8 = u8 + 19;
    local v466 = {
        Sender = false,
        Team = false,
        Position = false,
        Type = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v465 + 0);
    v466.Sender = buffer.readu32(buffer_create_ret2, v465 + 1);
    v466.Team = buffer.readu8(buffer_create_ret2, v465 + 5);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v465 + 6);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v465 + 10);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v465 + 14);
    v466.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v466.Position.Magnitude <= (-1 / 0) or v466.Position.Magnitude >= (1 / 0) then
        error((`Expected "Value.Position" to be a finite number, got {v466.Position.Magnitude} instead.`));
    end;

    v466.Type = buffer.readu8(buffer_create_ret2, v465 + 18);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v467 = u8;
        u8 = u8 + 4;
        v466.Weapon = buffer.readu32(buffer_create_ret2, v467 + 0);
    end;

    return v466;
end;

function u1.Gui_WriteEVENT_SendTeamMessage(p468: string, p469: table?) -- Line: 2063
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v470 = u20;

        for i = #v470, u19 + 1, -1 do
            v470[i] = nil;
            local _ = i;
        end;

        local v471 = u21;
        u21 = nil;

        if u6 == v470 then
            if v471 then
                Load(v471);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p469;
    local v472 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v472, 7);

    if typeof(p468) ~= "string" then
        error((`Expected Value to be of type string, got {type(p468)} instead.`));
    end;

    local v473 = #p468;
    local v474 = WriteVarint(v473, v473);
    buffer.writestring(buffer_create_ret, v474, p468, v473);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_SelectMapPreset(p475: table, p476: table?) -- Line: 2076
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v477 = u20;

        for i = #v477, u19 + 1, -1 do
            v477[i] = nil;
            local _ = i;
        end;

        local v478 = u21;
        u21 = nil;

        if u6 == v477 then
            if v478 then
                Load(v478);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p476;
    local v479 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v479 + 0, 56);

    if typeof(p475.M) ~= "string" then
        error((`Expected Value.M to be of type string, got {type(p475.M)} instead.`));
    end;

    if #p475.M < 1 or #p475.M > 32 then
        error((`Expected length of "Value.M" to be within [1, 32], got {#p475.M} instead.`));
    end;

    local v480 = #p475.M;
    buffer.writeu8(buffer_create_ret, v479 + 1, v480);
    Allocate(v480);
    buffer.writestring(buffer_create_ret, u4, p475.M, v480);

    if typeof(p475.P) ~= "string" then
        error((`Expected Value.P to be of type string, got {type(p475.P)} instead.`));
    end;

    if #p475.P < 7 or #p475.P > 13 then
        error((`Expected length of "Value.P" to be within [7, 13], got {#p475.P} instead.`));
    end;

    local v481 = #p475.P;
    buffer.writeu8(buffer_create_ret, v479 + 2, v481);
    Allocate(v481);
    buffer.writestring(buffer_create_ret, u4, p475.P, v481);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_MobileControls(p482: table, p483: table?) -- Line: 2101
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v484 = u20;

        for i = #v484, u19 + 1, -1 do
            v484[i] = nil;
            local _ = i;
        end;

        local v485 = u21;
        u21 = nil;

        if u6 == v484 then
            if v485 then
                Load(v485);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p483;
    local v486 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v486 + 0, 57);
    local v487 = 0;

    for i, v in p482 do
        v487 = v487 + 1;

        if typeof(i) ~= "string" then
            error((`Expected Key_1 to be of type string, got {type(i)} instead.`));
        end;

        local v488 = #i;
        local v489 = WriteVarint(v488, v488);
        buffer.writestring(buffer_create_ret, v489, i, v488);
        local v490 = 0;

        if typeof(v.Hidden) ~= "boolean" then
            error((`Expected Element_1.Hidden to be of type boolean, got {type(v.Hidden)} instead.`));
        end;

        if v.Hidden then
            v490 = v490 + 1;
        end;

        local v491 = Allocate(1);
        buffer.writeu8(buffer_create_ret, v491, v490);

        if typeof(v.Size) ~= "number" then
            error((`Expected Element_1.Size to be of type number, got {type(v.Size)} instead.`));
        end;

        if v.Size <= (-1 / 0) or v.Size >= (1 / 0) then
            error((`Expected "Element_1.Size" to be a finite number, got {v.Size} instead.`));
        end;

        local v492 = Allocate(2);

        if v.Size > 65504 then
            buffer.writeu16(buffer_create_ret, v492, 31744);
        elseif v.Size < -65504 then
            buffer.writeu16(buffer_create_ret, v492, 64512);
        elseif v.Size == v.Size then
            if v.Size == 0 then
                buffer.writeu16(buffer_create_ret, v492, 0);
            else
                local Size = v.Size;
                local math_abs_ret = math.abs(Size);
                local math_log_ret = math.log(math_abs_ret, 2);
                local v493 = math.floor(math_log_ret) - 10;
                local math_ldexp_ret = math.ldexp(1, v493);
                local math_frexp_ret, v494 = math.frexp(math_abs_ret // math_ldexp_ret * math_ldexp_ret);
                local v495 = v494 + 14;
                local v496;

                if v495 <= 0 then
                    local math_abs_ret2 = math.abs(v495);
                    v496 = math_frexp_ret * 1024 / math.ldexp(1, math_abs_ret2);
                else
                    v496 = math_frexp_ret * 2048;
                end;

                local v497 = math.round(v496) % 1024 + math.max(v495, 0) * 1024;
                buffer.writeu16(buffer_create_ret, v492, v497 + (Size < 0 and 32768 or 0));
            end;
        else
            buffer.writeu16(buffer_create_ret, v492, 64513);
        end;

        local v498 = Allocate(2);
        local v499 = v;
        local v500 = 0;

        for i2, v2 in v.Position do
            v500 = v500 + 1;

            if typeof(i2) ~= "number" then
                error((`Expected Key_2 to be of type number, got {type(i2)} instead.`));
            end;

            local v501 = Allocate(1);
            buffer.writeu8(buffer_create_ret, v501, i2);

            if typeof(v2) ~= "number" then
                error((`Expected Element_2 to be of type number, got {type(v2)} instead.`));
            end;

            if v2 <= (-1 / 0) or v2 >= (1 / 0) then
                error((`Expected "Element_2" to be a finite number, got {v2} instead.`));
            end;

            local v502 = Allocate(2);

            if v2 > 65504 then
                buffer.writeu16(buffer_create_ret, v502, 31744);
            elseif v2 < -65504 then
                buffer.writeu16(buffer_create_ret, v502, 64512);
            elseif v2 == v2 then
                if v2 == 0 then
                    buffer.writeu16(buffer_create_ret, v502, 0);
                else
                    local math_abs_ret = math.abs(v2);
                    local math_log_ret = math.log(math_abs_ret, 2);
                    local v503 = math.floor(math_log_ret) - 10;
                    local math_ldexp_ret = math.ldexp(1, v503);
                    local math_frexp_ret, v504 = math.frexp(math_abs_ret // math_ldexp_ret * math_ldexp_ret);
                    local v505 = v504 + 14;
                    local v506;

                    if v505 <= 0 then
                        local math_abs_ret2 = math.abs(v505);
                        v506 = math_frexp_ret * 1024 / math.ldexp(1, math_abs_ret2);
                    else
                        v506 = math_frexp_ret * 2048;
                    end;

                    local v507 = math.round(v506) % 1024 + math.max(v505, 0) * 1024;
                    buffer.writeu16(buffer_create_ret, v502, v507 + (v2 < 0 and 32768 or 0));
                end;
            else
                buffer.writeu16(buffer_create_ret, v502, 64513);
            end;
        end;

        if v500 > 65535 then
            error((`Expected "Elements_2" to be smaller than 65535, got {v500} instead.`));
        end;

        buffer.writeu16(buffer_create_ret, v498, v500);

        if typeof(v499.Transparency) ~= "number" then
            error((`Expected Element_1.Transparency to be of type number, got {type(v499.Transparency)} instead.`));
        end;

        if v499.Transparency <= (-1 / 0) or v499.Transparency >= (1 / 0) then
            error((`Expected "Element_1.Transparency" to be a finite number, got {v499.Transparency} instead.`));
        end;

        local v508 = Allocate(2);

        if v499.Transparency > 65504 then
            buffer.writeu16(buffer_create_ret, v508, 31744);
        elseif v499.Transparency < -65504 then
            buffer.writeu16(buffer_create_ret, v508, 64512);
        elseif v499.Transparency == v499.Transparency then
            if v499.Transparency == 0 then
                buffer.writeu16(buffer_create_ret, v508, 0);
            else
                local Transparency = v499.Transparency;
                local math_abs_ret = math.abs(Transparency);
                local math_log_ret = math.log(math_abs_ret, 2);
                local v509 = math.floor(math_log_ret) - 10;
                local math_ldexp_ret = math.ldexp(1, v509);
                local math_frexp_ret, v510 = math.frexp(math_abs_ret // math_ldexp_ret * math_ldexp_ret);
                local v511 = v510 + 14;
                local v512;

                if v511 <= 0 then
                    local math_abs_ret2 = math.abs(v511);
                    v512 = math_frexp_ret * 1024 / math.ldexp(1, math_abs_ret2);
                else
                    v512 = math_frexp_ret * 2048;
                end;

                local v513 = math.round(v512) % 1024 + math.max(v511, 0) * 1024;
                buffer.writeu16(buffer_create_ret, v508, v513 + (Transparency < 0 and 32768 or 0));
            end;
        else
            buffer.writeu16(buffer_create_ret, v508, 64513);
        end;
    end;

    if v487 > 65535 then
        error((`Expected "Elements_1" to be smaller than 65535, got {v487} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v486 + 1, v487);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ClaimBattlepassReward(p514: table, p515: table?) -- Line: 2223
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v516 = u20;

        for i = #v516, u19 + 1, -1 do
            v516[i] = nil;
            local _ = i;
        end;

        local v517 = u21;
        u21 = nil;

        if u6 == v516 then
            if v517 then
                Load(v517);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p515;
    local v518 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v518 + 0, 58);
    local v519 = 0;

    if typeof(p514.P) ~= "boolean" then
        error((`Expected Value.P to be of type boolean, got {type(p514.P)} instead.`));
    end;

    if p514.P then
        v519 = v519 + 1;
    end;

    buffer.writeu8(buffer_create_ret, v518 + 1, v519);

    if typeof(p514.I) ~= "number" then
        error((`Expected Value.I to be of type number, got {type(p514.I)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v518 + 2, p514.I);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ClaimAllBattlepassRewards(p520: any, p521: table?) -- Line: 2242
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v522 = u20;

        for i = #v522, u19 + 1, -1 do
            v522[i] = nil;
            local _ = i;
        end;

        local v523 = u21;
        u21 = nil;

        if u6 == v522 then
            if v523 then
                Load(v523);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p521;
    local v524 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v524, 59);

    if p520 == nil then
        p520 = u11;
    end;

    table.insert(u6, p520);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyBattlepass(p525: number, p526: table?) -- Line: 2252
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v527 = u20;

        for i = #v527, u19 + 1, -1 do
            v527[i] = nil;
            local _ = i;
        end;

        local v528 = u21;
        u21 = nil;

        if u6 == v527 then
            if v528 then
                Load(v528);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p526;
    local v529 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v529 + 0, 60);

    if typeof(p525) ~= "number" then
        error((`Expected Value to be of type number, got {type(p525)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v529 + 1, p525);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyBundle(p530: number, p531: table?) -- Line: 2265
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v532 = u20;

        for i = #v532, u19 + 1, -1 do
            v532[i] = nil;
            local _ = i;
        end;

        local v533 = u21;
        u21 = nil;

        if u6 == v532 then
            if v533 then
                Load(v533);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p531;
    local v534 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v534 + 0, 61);

    if typeof(p530) ~= "number" then
        error((`Expected Value to be of type number, got {type(p530)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v534 + 1, p530);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyBundleItem(p535: table, p536: table?) -- Line: 2278
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v537 = u20;

        for i = #v537, u19 + 1, -1 do
            v537[i] = nil;
            local _ = i;
        end;

        local v538 = u21;
        u21 = nil;

        if u6 == v537 then
            if v538 then
                Load(v538);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p536;
    local v539 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v539 + 0, 62);

    if typeof(p535.ItemName) ~= "string" then
        error((`Expected Value.ItemName to be of type string, got {type(p535.ItemName)} instead.`));
    end;

    local ItemName = p535.ItemName;
    local v540 = #ItemName;
    local v541 = WriteVarint(v540, v540);
    buffer.writestring(buffer_create_ret, v541, ItemName, v540);

    if typeof(p535.BundleIndex) ~= "number" then
        error((`Expected Value.BundleIndex to be of type number, got {type(p535.BundleIndex)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v539 + 1, p535.BundleIndex);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyBattlepassTiers(p542: number, p543: table?) -- Line: 2295
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v544 = u20;

        for i = #v544, u19 + 1, -1 do
            v544[i] = nil;
            local _ = i;
        end;

        local v545 = u21;
        u21 = nil;

        if u6 == v544 then
            if v545 then
                Load(v545);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p543;
    local v546 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v546 + 0, 63);

    if typeof(p542) ~= "number" then
        error((`Expected Value to be of type number, got {type(p542)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v546 + 1, p542);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ClaimChallengeReward(p547: table, p548: table?) -- Line: 2308
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v549 = u20;

        for i = #v549, u19 + 1, -1 do
            v549[i] = nil;
            local _ = i;
        end;

        local v550 = u21;
        u21 = nil;

        if u6 == v549 then
            if v550 then
                Load(v550);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p548;
    local v551 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v551 + 0, 64);

    if typeof(p547.Category) ~= "string" then
        error((`Expected Value.Category to be of type string, got {type(p547.Category)} instead.`));
    end;

    local Category = p547.Category;
    local v552 = #Category;
    local v553 = WriteVarint(v552, v552);
    buffer.writestring(buffer_create_ret, v553, Category, v552);

    if typeof(p547.Index) ~= "number" then
        error((`Expected Value.Index to be of type number, got {type(p547.Index)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v551 + 1, p547.Index);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_StartChallenge(p554: table, p555: table?) -- Line: 2325
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v556 = u20;

        for i = #v556, u19 + 1, -1 do
            v556[i] = nil;
            local _ = i;
        end;

        local v557 = u21;
        u21 = nil;

        if u6 == v556 then
            if v557 then
                Load(v557);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p555;
    local v558 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v558 + 0, 65);

    if typeof(p554.Category) ~= "string" then
        error((`Expected Value.Category to be of type string, got {type(p554.Category)} instead.`));
    end;

    local Category = p554.Category;
    local v559 = #Category;
    local v560 = WriteVarint(v559, v559);
    buffer.writestring(buffer_create_ret, v560, Category, v559);

    if typeof(p554.Index) ~= "number" then
        error((`Expected Value.Index to be of type number, got {type(p554.Index)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v558 + 1, p554.Index);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_AbandonChallenge(p561: table, p562: table?) -- Line: 2342
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v563 = u20;

        for i = #v563, u19 + 1, -1 do
            v563[i] = nil;
            local _ = i;
        end;

        local v564 = u21;
        u21 = nil;

        if u6 == v563 then
            if v564 then
                Load(v564);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p562;
    local v565 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v565 + 0, 66);

    if typeof(p561.Category) ~= "string" then
        error((`Expected Value.Category to be of type string, got {type(p561.Category)} instead.`));
    end;

    local Category = p561.Category;
    local v566 = #Category;
    local v567 = WriteVarint(v566, v566);
    buffer.writestring(buffer_create_ret, v567, Category, v566);

    if typeof(p561.Index) ~= "number" then
        error((`Expected Value.Index to be of type number, got {type(p561.Index)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v565 + 1, p561.Index);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_TradeUp(p568: table, p569: table?) -- Line: 2359
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v570 = u20;

        for i = #v570, u19 + 1, -1 do
            v570[i] = nil;
            local _ = i;
        end;

        local v571 = u21;
        u21 = nil;

        if u6 == v570 then
            if v571 then
                Load(v571);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p569;
    local v572 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v572 + 0, 67);
    local v573 = 0;

    for i, v in p568 do
        v573 = v573 + 1;

        if typeof(i) ~= "number" then
            error((`Expected Key_1 to be of type number, got {type(i)} instead.`));
        end;

        local v574 = Allocate(1);
        buffer.writeu8(buffer_create_ret, v574, i);

        if typeof(v.WeaponName) ~= "string" then
            error((`Expected Element_1.WeaponName to be of type string, got {type(v.WeaponName)} instead.`));
        end;

        local WeaponName = v.WeaponName;
        local v575 = #WeaponName;
        local v576 = WriteVarint(v575, v575);
        buffer.writestring(buffer_create_ret, v576, WeaponName, v575);

        if typeof(v.SkinName) ~= "string" then
            error((`Expected Element_1.SkinName to be of type string, got {type(v.SkinName)} instead.`));
        end;

        local SkinName = v.SkinName;
        local v577 = #SkinName;
        local v578 = WriteVarint(v577, v577);
        buffer.writestring(buffer_create_ret, v578, SkinName, v577);

        if typeof(v.SkinId) ~= "string" then
            error((`Expected Element_1.SkinId to be of type string, got {type(v.SkinId)} instead.`));
        end;

        local SkinId = v.SkinId;
        local v579 = #SkinId;
        local v580 = WriteVarint(v579, v579);
        buffer.writestring(buffer_create_ret, v580, SkinId, v579);
    end;

    if v573 > 65535 then
        error((`Expected "Elements_1" to be smaller than 65535, got {v573} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v572 + 1, v573);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_Upgrade(p581: table, p582: table?) -- Line: 2391
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v583 = u20;

        for i = #v583, u19 + 1, -1 do
            v583[i] = nil;
            local _ = i;
        end;

        local v584 = u21;
        u21 = nil;

        if u6 == v583 then
            if v584 then
                Load(v584);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p582;
    local v585 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v585, 68);
    local Inventory = p581.Inventory;

    if typeof(Inventory.WeaponName) ~= "string" then
        error((`Expected Struct_11.WeaponName to be of type string, got {type(Inventory.WeaponName)} instead.`));
    end;

    local WeaponName = Inventory.WeaponName;
    local v586 = #WeaponName;
    local v587 = WriteVarint(v586, v586);
    buffer.writestring(buffer_create_ret, v587, WeaponName, v586);

    if typeof(Inventory.SkinName) ~= "string" then
        error((`Expected Struct_11.SkinName to be of type string, got {type(Inventory.SkinName)} instead.`));
    end;

    local SkinName = Inventory.SkinName;
    local v588 = #SkinName;
    local v589 = WriteVarint(v588, v588);
    buffer.writestring(buffer_create_ret, v589, SkinName, v588);

    if typeof(Inventory.SkinId) ~= "string" then
        error((`Expected Struct_11.SkinId to be of type string, got {type(Inventory.SkinId)} instead.`));
    end;

    local SkinId = Inventory.SkinId;
    local v590 = #SkinId;
    local v591 = WriteVarint(v590, v590);
    buffer.writestring(buffer_create_ret, v591, SkinId, v590);
    local Exchange = p581.Exchange;

    if typeof(Exchange.WeaponName) ~= "string" then
        error((`Expected Struct_12.WeaponName to be of type string, got {type(Exchange.WeaponName)} instead.`));
    end;

    local WeaponName2 = Exchange.WeaponName;
    local v592 = #WeaponName2;
    local v593 = WriteVarint(v592, v592);
    buffer.writestring(buffer_create_ret, v593, WeaponName2, v592);

    if typeof(Exchange.SkinName) ~= "string" then
        error((`Expected Struct_12.SkinName to be of type string, got {type(Exchange.SkinName)} instead.`));
    end;

    local SkinName2 = Exchange.SkinName;
    local v594 = #SkinName2;
    local v595 = WriteVarint(v594, v594);
    buffer.writestring(buffer_create_ret, v595, SkinName2, v594);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_UpgradeResult() -- Line: 2422
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v596 = u8;
    u8 = u8 + 1;

    return buffer.readu8(buffer_create_ret2, v596 + 0) == 1;
end;

function u1.Gui_WriteEVENT_ApplySticker(p597: table, p598: table?) -- Line: 2429
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v599 = u20;

        for i = #v599, u19 + 1, -1 do
            v599[i] = nil;
            local _ = i;
        end;

        local v600 = u21;
        u21 = nil;

        if u6 == v599 then
            if v600 then
                Load(v600);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p598;
    local v601 = Allocate(4);
    buffer.writeu8(buffer_create_ret, v601 + 0, 70);
    local v602 = 0;

    if p597.Position ~= nil then
        v602 = v602 + 1;
    end;

    if p597.Size ~= nil then
        v602 = v602 + 2;
    end;

    buffer.writeu8(buffer_create_ret, v601 + 1, v602);

    if typeof(p597.WeaponName) ~= "string" then
        error((`Expected Value.WeaponName to be of type string, got {type(p597.WeaponName)} instead.`));
    end;

    local WeaponName = p597.WeaponName;
    local v603 = #WeaponName;
    local v604 = WriteVarint(v603, v603);
    buffer.writestring(buffer_create_ret, v604, WeaponName, v603);

    if typeof(p597.SkinName) ~= "string" then
        error((`Expected Value.SkinName to be of type string, got {type(p597.SkinName)} instead.`));
    end;

    local SkinName = p597.SkinName;
    local v605 = #SkinName;
    local v606 = WriteVarint(v605, v605);
    buffer.writestring(buffer_create_ret, v606, SkinName, v605);

    if typeof(p597.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p597.SkinId)} instead.`));
    end;

    local SkinId = p597.SkinId;
    local v607 = #SkinId;
    local v608 = WriteVarint(v607, v607);
    buffer.writestring(buffer_create_ret, v608, SkinId, v607);

    if typeof(p597.StickerName) ~= "string" then
        error((`Expected Value.StickerName to be of type string, got {type(p597.StickerName)} instead.`));
    end;

    local StickerName = p597.StickerName;
    local v609 = #StickerName;
    local v610 = WriteVarint(v609, v609);
    buffer.writestring(buffer_create_ret, v610, StickerName, v609);

    if p597.Position ~= nil then
        local v611 = Allocate(12);

        if typeof(p597.Position) ~= "Vector3" then
            error((`Expected Value.Position to be of type Vector3, got {type(p597.Position)} instead.`));
        end;

        if p597.Position.Magnitude <= (-1 / 0) or p597.Position.Magnitude >= (1 / 0) then
            error((`Expected "Value.Position" to be a finite number, got {p597.Position.Magnitude} instead.`));
        end;

        local Position = p597.Position;
        buffer.writef32(buffer_create_ret, v611 + 0, Position.X);
        buffer.writef32(buffer_create_ret, v611 + 4, Position.Y);
        buffer.writef32(buffer_create_ret, v611 + 8, Position.Z);
    end;

    if typeof(p597.Rotation) ~= "number" then
        error((`Expected Value.Rotation to be of type number, got {type(p597.Rotation)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v601 + 2, p597.Rotation);

    if p597.Size ~= nil then
        local v612 = Allocate(1);

        if typeof(p597.Size) ~= "number" then
            error((`Expected Value.Size to be of type number, got {type(p597.Size)} instead.`));
        end;

        buffer.writeu8(buffer_create_ret, v612 + 0, p597.Size);
    end;

    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_RemoveSticker(p613: table, p614: table?) -- Line: 2482
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v615 = u20;

        for i = #v615, u19 + 1, -1 do
            v615[i] = nil;
            local _ = i;
        end;

        local v616 = u21;
        u21 = nil;

        if u6 == v615 then
            if v616 then
                Load(v616);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p614;
    local v617 = Allocate(4);
    buffer.writeu8(buffer_create_ret, v617 + 0, 71);
    local v618 = 0;

    if p613.Position ~= nil then
        v618 = v618 + 1;
    end;

    if p613.Size ~= nil then
        v618 = v618 + 2;
    end;

    buffer.writeu8(buffer_create_ret, v617 + 1, v618);

    if typeof(p613.WeaponName) ~= "string" then
        error((`Expected Value.WeaponName to be of type string, got {type(p613.WeaponName)} instead.`));
    end;

    local WeaponName = p613.WeaponName;
    local v619 = #WeaponName;
    local v620 = WriteVarint(v619, v619);
    buffer.writestring(buffer_create_ret, v620, WeaponName, v619);

    if typeof(p613.SkinName) ~= "string" then
        error((`Expected Value.SkinName to be of type string, got {type(p613.SkinName)} instead.`));
    end;

    local SkinName = p613.SkinName;
    local v621 = #SkinName;
    local v622 = WriteVarint(v621, v621);
    buffer.writestring(buffer_create_ret, v622, SkinName, v621);

    if typeof(p613.SkinId) ~= "string" then
        error((`Expected Value.SkinId to be of type string, got {type(p613.SkinId)} instead.`));
    end;

    local SkinId = p613.SkinId;
    local v623 = #SkinId;
    local v624 = WriteVarint(v623, v623);
    buffer.writestring(buffer_create_ret, v624, SkinId, v623);

    if typeof(p613.StickerName) ~= "string" then
        error((`Expected Value.StickerName to be of type string, got {type(p613.StickerName)} instead.`));
    end;

    local StickerName = p613.StickerName;
    local v625 = #StickerName;
    local v626 = WriteVarint(v625, v625);
    buffer.writestring(buffer_create_ret, v626, StickerName, v625);

    if p613.Position ~= nil then
        local v627 = Allocate(12);

        if typeof(p613.Position) ~= "Vector3" then
            error((`Expected Value.Position to be of type Vector3, got {type(p613.Position)} instead.`));
        end;

        if p613.Position.Magnitude <= (-1 / 0) or p613.Position.Magnitude >= (1 / 0) then
            error((`Expected "Value.Position" to be a finite number, got {p613.Position.Magnitude} instead.`));
        end;

        local Position = p613.Position;
        buffer.writef32(buffer_create_ret, v627 + 0, Position.X);
        buffer.writef32(buffer_create_ret, v627 + 4, Position.Y);
        buffer.writef32(buffer_create_ret, v627 + 8, Position.Z);
    end;

    if typeof(p613.Rotation) ~= "number" then
        error((`Expected Value.Rotation to be of type number, got {type(p613.Rotation)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v617 + 2, p613.Rotation);

    if p613.Size ~= nil then
        local v628 = Allocate(1);

        if typeof(p613.Size) ~= "number" then
            error((`Expected Value.Size to be of type number, got {type(p613.Size)} instead.`));
        end;

        buffer.writeu8(buffer_create_ret, v628 + 0, p613.Size);
    end;

    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ClaimCarePackageItems(p629: table, p630: table?) -- Line: 2535
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v631 = u20;

        for i = #v631, u19 + 1, -1 do
            v631[i] = nil;
            local _ = i;
        end;

        local v632 = u21;
        u21 = nil;

        if u6 == v631 then
            if v632 then
                Load(v632);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p630;
    local v633 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v633 + 0, 72);
    local v634 = 0;

    if p629.Index1 == true then
        v634 = v634 + 1;
    end;

    if p629.Index2 == true then
        v634 = v634 + 2;
    end;

    if p629.Index3 == true then
        v634 = v634 + 4;
    end;

    if p629.Index4 == true then
        v634 = v634 + 8;
    end;

    buffer.writeu8(buffer_create_ret, v633 + 1, v634);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_UsePromocode(p635: string, p636: table?) -- Line: 2550
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v637 = u20;

        for i = #v637, u19 + 1, -1 do
            v637[i] = nil;
            local _ = i;
        end;

        local v638 = u21;
        u21 = nil;

        if u6 == v637 then
            if v638 then
                Load(v638);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p636;
    local v639 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v639, 73);

    if typeof(p635) ~= "string" then
        error((`Expected Value to be of type string, got {type(p635)} instead.`));
    end;

    local v640 = #p635;
    local v641 = WriteVarint(v640, v640);
    buffer.writestring(buffer_create_ret, v641, p635, v640);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyDailyMarketItem(p642: string, p643: table?) -- Line: 2563
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v644 = u20;

        for i = #v644, u19 + 1, -1 do
            v644[i] = nil;
            local _ = i;
        end;

        local v645 = u21;
        u21 = nil;

        if u6 == v644 then
            if v645 then
                Load(v645);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p643;
    local v646 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v646, 74);

    if typeof(p642) ~= "string" then
        error((`Expected Value to be of type string, got {type(p642)} instead.`));
    end;

    local v647 = #p642;
    local v648 = WriteVarint(v647, v647);
    buffer.writestring(buffer_create_ret, v648, p642, v647);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_RevealMarketItem(p649: string, p650: table?) -- Line: 2576
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v651 = u20;

        for i = #v651, u19 + 1, -1 do
            v651[i] = nil;
            local _ = i;
        end;

        local v652 = u21;
        u21 = nil;

        if u6 == v651 then
            if v652 then
                Load(v652);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p650;
    local v653 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v653, 75);

    if typeof(p649) ~= "string" then
        error((`Expected Value to be of type string, got {type(p649)} instead.`));
    end;

    local v654 = #p649;
    local v655 = WriteVarint(v654, v654);
    buffer.writestring(buffer_create_ret, v655, p649, v654);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ClaimAchievementReward(p656: string, p657: table?) -- Line: 2589
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v658 = u20;

        for i = #v658, u19 + 1, -1 do
            v658[i] = nil;
            local _ = i;
        end;

        local v659 = u21;
        u21 = nil;

        if u6 == v658 then
            if v659 then
                Load(v659);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p657;
    local v660 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v660, 76);

    if typeof(p656) ~= "string" then
        error((`Expected Value to be of type string, got {type(p656)} instead.`));
    end;

    local v661 = #p656;
    local v662 = WriteVarint(v661, v661);
    buffer.writestring(buffer_create_ret, v662, p656, v661);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ChangePlayerSetting(p663: table, p664: table?) -- Line: 2602
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v665 = u20;

        for i = #v665, u19 + 1, -1 do
            v665[i] = nil;
            local _ = i;
        end;

        local v666 = u21;
        u21 = nil;

        if u6 == v665 then
            if v666 then
                Load(v666);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p664;
    local v667 = Allocate(7);
    buffer.writeu8(buffer_create_ret, v667 + 0, 77);

    if typeof(p663.A) ~= "number" then
        error((`Expected Value.A to be of type number, got {type(p663.A)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v667 + 1, p663.A);

    if typeof(p663.B) ~= "number" then
        error((`Expected Value.B to be of type number, got {type(p663.B)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v667 + 3, p663.B);

    if typeof(p663.I) ~= "number" then
        error((`Expected Value.I to be of type number, got {type(p663.I)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v667 + 5, p663.I);
    local v668;

    if p663.V == nil then
        v668 = u11;
    else
        v668 = p663.V;
    end;

    table.insert(u6, v668);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ResetPlayerSettings(p669: any, p670: table?) -- Line: 2624
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v671 = u20;

        for i = #v671, u19 + 1, -1 do
            v671[i] = nil;
            local _ = i;
        end;

        local v672 = u21;
        u21 = nil;

        if u6 == v671 then
            if v672 then
                Load(v672);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p670;
    local v673 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v673, 78);

    if p669 == nil then
        p669 = u11;
    end;

    table.insert(u6, p669);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_ChangeLoadoutWeapon(p674: table, p675: table?) -- Line: 2634
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v676 = u20;

        for i = #v676, u19 + 1, -1 do
            v676[i] = nil;
            local _ = i;
        end;

        local v677 = u21;
        u21 = nil;

        if u6 == v676 then
            if v677 then
                Load(v677);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p675;
    local v678 = Allocate(4);
    buffer.writeu8(buffer_create_ret, v678 + 0, 79);

    if typeof(p674.A) ~= "number" then
        error((`Expected Value.A to be of type number, got {type(p674.A)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v678 + 1, p674.A);

    if typeof(p674.B) ~= "number" then
        error((`Expected Value.B to be of type number, got {type(p674.B)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v678 + 2, p674.B);

    if typeof(p674.C) ~= "string" then
        error((`Expected Value.C to be of type string, got {type(p674.C)} instead.`));
    end;

    local C = p674.C;
    local v679 = #C;
    local v680 = WriteVarint(v679, v679);
    buffer.writestring(buffer_create_ret, v680, C, v679);

    if typeof(p674.D) ~= "string" then
        error((`Expected Value.D to be of type string, got {type(p674.D)} instead.`));
    end;

    local D = p674.D;
    local v681 = #D;
    local v682 = WriteVarint(v681, v681);
    buffer.writestring(buffer_create_ret, v682, D, v681);

    if typeof(p674.E) ~= "string" then
        error((`Expected Value.E to be of type string, got {type(p674.E)} instead.`));
    end;

    local E = p674.E;
    local v683 = #E;
    local v684 = WriteVarint(v683, v683);
    buffer.writestring(buffer_create_ret, v684, E, v683);

    if typeof(p674.T) ~= "number" then
        error((`Expected Value.T to be of type number, got {type(p674.T)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v678 + 3, p674.T);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_BuyStoreItem(p685: table, p686: table?) -- Line: 2667
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v687 = u20;

        for i = #v687, u19 + 1, -1 do
            v687[i] = nil;
            local _ = i;
        end;

        local v688 = u21;
        u21 = nil;

        if u6 == v687 then
            if v688 then
                Load(v688);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p686;
    local v689 = Allocate(3);
    buffer.writeu8(buffer_create_ret, v689 + 0, 80);

    if typeof(p685.C) ~= "number" then
        error((`Expected Value.C to be of type number, got {type(p685.C)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v689 + 1, p685.C);

    if typeof(p685.I) ~= "string" then
        error((`Expected Value.I to be of type string, got {type(p685.I)} instead.`));
    end;

    local I = p685.I;
    local v690 = #I;
    local v691 = WriteVarint(v690, v690);
    buffer.writestring(buffer_create_ret, v691, I, v690);

    if typeof(p685.A) ~= "number" then
        error((`Expected Value.A to be of type number, got {type(p685.A)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v689 + 2, p685.A);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_WriteEVENT_OpenContainer(p692: table, p693: table?) -- Line: 2688
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), WriteVarint (copy)
    if u17 then
        u17 = false;
        local v694 = u20;

        for i = #v694, u19 + 1, -1 do
            v694[i] = nil;
            local _ = i;
        end;

        local v695 = u21;
        u21 = nil;

        if u6 == v694 then
            if v695 then
                Load(v695);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p693;
    local v696 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v696, 81);

    if typeof(p692.C) ~= "string" then
        error((`Expected Value.C to be of type string, got {type(p692.C)} instead.`));
    end;

    local C = p692.C;
    local v697 = #C;
    local v698 = WriteVarint(v697, v697);
    buffer.writestring(buffer_create_ret, v698, C, v697);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_OpenContainerResult() -- Line: 2701
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref)
    local v699 = ReadVarint();
    local v700 = u8;
    u8 = u8 + v699;

    return buffer.readstring(buffer_create_ret2, v700, v699);
end;

function u1.Gui_WriteEVENT_ClaimPlaytimeReward(p701: number, p702: table?) -- Line: 2707
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v703 = u20;

        for i = #v703, u19 + 1, -1 do
            v703[i] = nil;
            local _ = i;
        end;

        local v704 = u21;
        u21 = nil;

        if u6 == v703 then
            if v704 then
                Load(v704);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p702;
    local v705 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v705 + 0, 83);

    if typeof(p701) ~= "number" then
        error((`Expected Value to be of type number, got {type(p701)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v705 + 1, p701);
    u17 = false;
    u21 = nil;
end;

function u1.Gui_ReadEVENT_KillfeedUpdate() -- Line: 2720
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v706 = u8;
    u8 = u8 + 3;
    local v707 = {
        Killer = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v706 + 0);
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v706 + 1);
    local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v706 + 2);
    local v708 = u8;
    u8 = u8 + buffer_readu8_ret3;
    v707.Killer = buffer.readstring(buffer_create_ret2, v708, buffer_readu8_ret3);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v709 = u8;
        u8 = u8 + 1;
        v707.KillerTeam = buffer.readu8(buffer_create_ret2, v709 + 0);
    end;

    if bit32.btest(buffer_readu8_ret, 2) == true then
        local v710 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v710 + 0);
        local v711 = u8;
        u8 = u8 + buffer_readu8_ret4;
        v707.Assist = buffer.readstring(buffer_create_ret2, v711, buffer_readu8_ret4);
    end;

    if bit32.btest(buffer_readu8_ret, 4) == true then
        local v712 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v712 + 0);
        local v713 = u8;
        u8 = u8 + buffer_readu8_ret4;
        v707.Victim = buffer.readstring(buffer_create_ret2, v713, buffer_readu8_ret4);
    end;

    if bit32.btest(buffer_readu8_ret, 8) == true then
        local v714 = u8;
        u8 = u8 + 1;
        v707.WeaponEnum = buffer.readu8(buffer_create_ret2, v714 + 0);
    end;

    if bit32.btest(buffer_readu8_ret, 16) == true then
        local v715 = u8;
        u8 = u8 + 1;
        v707.VictimTeam = buffer.readu8(buffer_create_ret2, v715 + 0);
    end;

    if bit32.btest(buffer_readu8_ret, 32) == true then
        local v716 = u8;
        u8 = u8 + 1;
        v707.Headshot = buffer.readu8(buffer_create_ret2, v716 + 0) == 1;
    end;

    if bit32.btest(buffer_readu8_ret, 64) == true then
        local v717 = u8;
        u8 = u8 + 1;
        v707.NoScope = buffer.readu8(buffer_create_ret2, v717 + 0) == 1;
    end;

    if bit32.btest(buffer_readu8_ret, 128) == true then
        local v718 = u8;
        u8 = u8 + 1;
        v707.Freefall = buffer.readu8(buffer_create_ret2, v718 + 0) == 1;
    end;

    if bit32.btest(buffer_readu8_ret2, 1) == true then
        local v719 = u8;
        u8 = u8 + 1;
        v707.Penetration = buffer.readu8(buffer_create_ret2, v719 + 0) == 1;
    end;

    return v707;
end;

function u1.Gui_ReadEVENT_DiedUpdate() -- Line: 2778
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v720 = u8;
    u8 = u8 + 29;
    local v721 = {
        Killer = false,
        Reason = false,
        WeaponSkin = false,
        DeathPosition = false,
        KillerIdentifier = false,
        DamageTaken = false,
        HitsTaken = false,
        DamageGiven = false,
        HitsGiven = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v720 + 0);
    v721.Killer = buffer.readf64(buffer_create_ret2, v720 + 1);

    if v721.Killer <= (-1 / 0) or v721.Killer >= (1 / 0) then
        error((`Expected "Value.Killer" to be a finite number, got {v721.Killer} instead.`));
    end;

    v721.Reason = buffer.readu8(buffer_create_ret2, v720 + 9);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v722 = u8;
        u8 = u8 + 1;
        v721.Weapon = buffer.readu8(buffer_create_ret2, v722 + 0);
    end;

    local v723 = ReadVarint();
    local v724 = u8;
    u8 = u8 + v723;
    v721.WeaponSkin = buffer.readstring(buffer_create_ret2, v724, v723);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v720 + 10);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v720 + 14);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v720 + 18);
    v721.DeathPosition = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v721.DeathPosition.Magnitude <= (-1 / 0) or v721.DeathPosition.Magnitude >= (1 / 0) then
        error((`Expected "Value.DeathPosition" to be a finite number, got {v721.DeathPosition.Magnitude} instead.`));
    end;

    v721.KillerIdentifier = buffer.readu8(buffer_create_ret2, v720 + 22);
    v721.DamageTaken = buffer.readu16(buffer_create_ret2, v720 + 23);
    v721.HitsTaken = buffer.readu8(buffer_create_ret2, v720 + 25);
    v721.DamageGiven = buffer.readu16(buffer_create_ret2, v720 + 26);
    v721.HitsGiven = buffer.readu8(buffer_create_ret2, v720 + 28);

    return v721;
end;

function u1.Gui_ReadEVENT_MVPUpdate() -- Line: 2806
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v725 = u8;
    u8 = u8 + 10;
    local v726 = {
        MVPUserid = false,
        MVPReason = false,
        FunFact = false,
        WinningTeam = false,
        MVPUserid = buffer.readf64(buffer_create_ret2, v725 + 0)
    };

    if v726.MVPUserid <= (-1 / 0) or v726.MVPUserid >= (1 / 0) then
        error((`Expected "Value.MVPUserid" to be a finite number, got {v726.MVPUserid} instead.`));
    end;

    v726.MVPReason = buffer.readu8(buffer_create_ret2, v725 + 8);
    local v727 = ReadVarint();
    local v728 = u8;
    u8 = u8 + v727;
    v726.FunFact = buffer.readstring(buffer_create_ret2, v728, v727);
    v726.WinningTeam = buffer.readu8(buffer_create_ret2, v725 + 9);

    return v726;
end;

function u1.Gui_ReadEVENT_InventoryUpdate() -- Line: 2819
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v729 = u8;
    u8 = u8 + 1;
    local v730;

    if buffer.readu8(buffer_create_ret2, v729 + 0) == 1 then
        local v731 = u8;
        u8 = u8 + 14;
        v730 = {
            Containers = false,
            Equipment = false,
            Graphic_Art = false,
            Containers = {}
        };

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 0) do
            local v732 = ReadVarint();
            local v733 = u8;
            u8 = u8 + v732;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v733, v732);
            local v734 = {};
            local v735 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v735) do
                local v736 = ReadVarint();
                local v737 = u8;
                u8 = u8 + v736;
                local buffer_readstring_ret2 = buffer.readstring(buffer_create_ret2, v737, v736);
                local v738 = u8;
                u8 = u8 + 1;
                v734[buffer_readstring_ret2] = buffer.readu8(buffer_create_ret2, v738) == 1;
                local _ = i2;
            end;

            v730.Containers[buffer_readstring_ret] = v734;
        end;

        v730.Equipment = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 2) do
            local v739 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v739);
            local v740 = {};
            local v741 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v741) do
                local v742 = u8;
                u8 = u8 + 2;
                local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v742);
                local v743 = {};
                local v744 = u8;
                u8 = u8 + 2;
                local _ = i2;

                for i3 = 1, buffer.readu16(buffer_create_ret2, v744) do
                    local v745 = ReadVarint();
                    local v746 = u8;
                    u8 = u8 + v745;
                    local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v746, v745);
                    local v747 = {
                        EquippedCT = false,
                        EquippedT = false,
                        Date = false,
                        Stickers = false
                    };
                    local v748 = u8;
                    u8 = u8 + 1;
                    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v748);
                    v747.EquippedCT = bit32.btest(buffer_readu8_ret2, 1);
                    v747.EquippedT = bit32.btest(buffer_readu8_ret2, 2);
                    local v749 = u8;
                    u8 = u8 + 4;
                    v747.Date = buffer.readu32(buffer_create_ret2, v749);

                    if bit32.btest(buffer_readu8_ret2, 4) == true then
                        local v750 = ReadVarint();
                        local v751 = u8;
                        u8 = u8 + v750;
                        v747.NameTag = buffer.readstring(buffer_create_ret2, v751, v750);
                    end;

                    if bit32.btest(buffer_readu8_ret2, 8) == true then
                        local v752 = u8;
                        u8 = u8 + 4;
                        v747.KillTrack = buffer.readu32(buffer_create_ret2, v752 + 0);
                    end;

                    local v753;

                    if bit32.btest(buffer_readu8_ret2, 16) == true then
                        local v754 = u8;
                        u8 = u8 + 2;
                        v747.KillTrackColor = {};
                        v753 = i3;

                        for i4 = 1, buffer.readu16(buffer_create_ret2, v754 + 0) do
                            local v755 = u8;
                            u8 = u8 + 1;
                            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v755);
                            local v756 = u8;
                            u8 = u8 + 1;
                            local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v756);
                            v747.KillTrackColor[buffer_readu8_ret3] = buffer_readu8_ret4;
                            local _ = i4;
                        end;
                    else
                        v753 = i3;
                    end;

                    if bit32.btest(buffer_readu8_ret2, 32) == true then
                        local v757 = u8;
                        u8 = u8 + 5;
                        local v758 = {
                            Tint = false,
                            Strength = false
                        };
                        v747.Emissive = v758;
                        v758.Tint = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v757 + 0), buffer.readu8(buffer_create_ret2, v757 + 1), (buffer.readu8(buffer_create_ret2, v757 + 2)));
                        local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v757 + 3);
                        local v759 = buffer_readu16_ret2 % 32768;

                        if v759 == 31744 then
                            if buffer_readu16_ret2 // 32768 == 1 then
                                v758.Strength = (-1 / 0);
                            else
                                v758.Strength = (1 / 0);
                            end;
                        elseif v759 == 64512 then
                            v758.Strength = (0 / 0);
                        elseif v759 == 0 then
                            v758.Strength = 0;
                        else
                            local v760 = v759 % 1024;
                            local v761 = v759 // 1024;
                            local v762;

                            if v761 == 0 then
                                v762 = v760 / 1024;
                            else
                                v762 = v760 / 2048 + 0.5;
                            end;

                            local math_ldexp_ret = math.ldexp(v762, v761 - 14);

                            if buffer_readu16_ret2 // 32768 == 1 then
                                math_ldexp_ret = -math_ldexp_ret;
                            end;

                            v758.Strength = math_ldexp_ret;
                        end;

                        if v758.Strength <= (-1 / 0) or v758.Strength >= (1 / 0) then
                            error((`Expected "Struct_18.Strength" to be a finite number, got {v758.Strength} instead.`));
                        end;
                    end;

                    v747.Stickers = {};
                    local v763 = u8;
                    u8 = u8 + 2;

                    for i4 = 1, buffer.readu16(buffer_create_ret2, v763) do
                        local v764 = u8;
                        u8 = u8 + 1;
                        local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v764);
                        local v765 = {
                            StickerName = false,
                            Position = false,
                            Rotation = false
                        };
                        local v766 = u8;
                        u8 = u8 + 1;
                        local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v766);
                        local v767 = ReadVarint();
                        local v768 = u8;
                        u8 = u8 + v767;
                        v765.StickerName = buffer.readstring(buffer_create_ret2, v768, v767);
                        v765.Position = {};
                        local v769 = u8;
                        u8 = u8 + 2;
                        local _ = i4;

                        for i5 = 1, buffer.readu16(buffer_create_ret2, v769) do
                            local v770 = u8;
                            u8 = u8 + 1;
                            local buffer_readu8_ret5 = buffer.readu8(buffer_create_ret2, v770);
                            local v771 = u8;
                            u8 = u8 + 4;
                            local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v771);

                            if buffer_readf32_ret <= (-1 / 0) or buffer_readf32_ret >= (1 / 0) then
                                error((`Expected "Element_6" to be a finite number, got {buffer_readf32_ret} instead.`));
                            end;

                            v765.Position[buffer_readu8_ret5] = buffer_readf32_ret;
                            local _ = i5;
                        end;

                        local v772 = u8;
                        u8 = u8 + 4;
                        v765.Rotation = buffer.readf32(buffer_create_ret2, v772);

                        if v765.Rotation <= (-1 / 0) or v765.Rotation >= (1 / 0) then
                            error((`Expected "Element_5.Rotation" to be a finite number, got {v765.Rotation} instead.`));
                        end;

                        if bit32.btest(buffer_readu8_ret4, 1) == true then
                            local v773 = u8;
                            u8 = u8 + 1;
                            v765.Size = buffer.readu8(buffer_create_ret2, v773 + 0);
                        end;

                        v747.Stickers[buffer_readu8_ret3] = v765;
                    end;

                    v743[buffer_readstring_ret] = v747;
                end;

                v740[buffer_readu16_ret] = v743;
            end;

            v730.Equipment[buffer_readu8_ret] = v740;
        end;

        local v774 = {
            Badges = false,
            Graffiti = false,
            Stickers = false,
            NameTags = false,
            KillTracks = false
        };
        v730.Graphic_Art = v774;
        v774.Badges = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 4) do
            local v775 = ReadVarint();
            local v776 = u8;
            u8 = u8 + v775;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v776, v775);
            local v777 = {};
            local v778 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v778) do
                local v779 = ReadVarint();
                local v780 = u8;
                u8 = u8 + v779;
                local buffer_readstring_ret2 = buffer.readstring(buffer_create_ret2, v780, v779);
                local v781 = {
                    EquippedCT = false,
                    EquippedT = false
                };
                local v782 = u8;
                u8 = u8 + 1;
                local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v782);
                v781.EquippedCT = bit32.btest(buffer_readu8_ret, 1);
                v781.EquippedT = bit32.btest(buffer_readu8_ret, 2);
                v777[buffer_readstring_ret2] = v781;
                local _ = i2;
            end;

            v774.Badges[buffer_readstring_ret] = v777;
        end;

        v774.Graffiti = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 6) do
            local v783 = ReadVarint();
            local v784 = u8;
            u8 = u8 + v783;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v784, v783);
            local v785 = {};
            local v786 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v786) do
                local v787 = ReadVarint();
                local v788 = u8;
                u8 = u8 + v787;
                local buffer_readstring_ret2 = buffer.readstring(buffer_create_ret2, v788, v787);
                local v789 = {};
                local v790 = u8;
                u8 = u8 + 1;
                local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v790);

                if bit32.btest(buffer_readu8_ret, 1) == true then
                    local v791 = u8;
                    u8 = u8 + 1;
                    v789.EquippedCT = buffer.readu8(buffer_create_ret2, v791 + 0) == 1;
                end;

                if bit32.btest(buffer_readu8_ret, 2) == true then
                    local v792 = u8;
                    u8 = u8 + 1;
                    v789.EquippedT = buffer.readu8(buffer_create_ret2, v792 + 0) == 1;
                end;

                v785[buffer_readstring_ret2] = v789;
                local _ = i2;
            end;

            v774.Graffiti[buffer_readstring_ret] = v785;
        end;

        v774.Stickers = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 8) do
            local v793 = ReadVarint();
            local v794 = u8;
            u8 = u8 + v793;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v794, v793);
            local v795 = {};
            local v796 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v796) do
                local v797 = ReadVarint();
                local v798 = u8;
                u8 = u8 + v797;
                v795[buffer.readstring(buffer_create_ret2, v798, v797)] = {};
                local _ = i2;
            end;

            v774.Stickers[buffer_readstring_ret] = v795;
        end;

        v774.NameTags = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 10) do
            local v799 = ReadVarint();
            local v800 = u8;
            u8 = u8 + v799;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v800, v799);
            local v801 = {};
            local v802 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v802) do
                local v803 = ReadVarint();
                local v804 = u8;
                u8 = u8 + v803;
                v801[buffer.readstring(buffer_create_ret2, v804, v803)] = {};
                local _ = i2;
            end;

            v774.NameTags[buffer_readstring_ret] = v801;
        end;

        v774.KillTracks = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v731 + 12) do
            local v805 = ReadVarint();
            local v806 = u8;
            u8 = u8 + v805;
            local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v806, v805);
            local v807 = {};
            local v808 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v808) do
                local v809 = ReadVarint();
                local v810 = u8;
                u8 = u8 + v809;
                v807[buffer.readstring(buffer_create_ret2, v810, v809)] = {};
                local _ = i2;
            end;

            v774.KillTracks[buffer_readstring_ret] = v807;
        end;
    else
        v730 = nil;
    end;

    return v730;
end;

function u1.Gui_ReadEVENT_InventoryAdd() -- Line: 3062
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v811 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v811 + 0);
    local v812 = true;

    if buffer_readu8_ret ~= 0 then
        if buffer_readu8_ret == 1 then
            local v813 = {
                ItemName = false,
                ItemId = false
            };
            local v814 = ReadVarint();
            local v815 = u8;
            u8 = u8 + v814;
            v813.ItemName = buffer.readstring(buffer_create_ret2, v815, v814);
            local v816 = ReadVarint();
            local v817 = u8;
            u8 = u8 + v816;
            v813.ItemId = buffer.readstring(buffer_create_ret2, v817, v816);
            v813.Type = "Container";

            return v813;
        end;

        if buffer_readu8_ret ~= 2 then
            error((`Unexpected variant: {buffer_readu8_ret}`));

            return v812;
        end;

        local v818 = {
            Category = false,
            ItemName = false,
            ItemId = false
        };
        local v819 = ReadVarint();
        local v820 = u8;
        u8 = u8 + v819;
        v818.Category = buffer.readstring(buffer_create_ret2, v820, v819);
        local v821 = ReadVarint();
        local v822 = u8;
        u8 = u8 + v821;
        v818.ItemName = buffer.readstring(buffer_create_ret2, v822, v821);
        local v823 = ReadVarint();
        local v824 = u8;
        u8 = u8 + v823;
        v818.ItemId = buffer.readstring(buffer_create_ret2, v824, v823);
        v818.Type = "GraphicArt";

        return v818;
    end;

    local v825 = u8;
    u8 = u8 + 1;
    local v826 = {
        WeaponName = false,
        SkinName = false,
        SkinId = false
    };
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v825 + 0);
    local v827 = ReadVarint();
    local v828 = u8;
    u8 = u8 + v827;
    v826.WeaponName = buffer.readstring(buffer_create_ret2, v828, v827);
    local v829 = ReadVarint();
    local v830 = u8;
    u8 = u8 + v829;
    v826.SkinName = buffer.readstring(buffer_create_ret2, v830, v829);
    local v831 = ReadVarint();
    local v832 = u8;
    u8 = u8 + v831;
    v826.SkinId = buffer.readstring(buffer_create_ret2, v832, v831);

    if bit32.btest(buffer_readu8_ret2, 1) == true then
        local v833 = u8;
        u8 = u8 + 8;
        v826.Date = buffer.readf64(buffer_create_ret2, v833 + 0);

        if v826.Date <= (-1 / 0) or v826.Date >= (1 / 0) then
            error((`Expected "Value.Date" to be a finite number, got {v826.Date} instead.`));
        end;
    end;

    if bit32.btest(buffer_readu8_ret2, 2) == true then
        local v834 = ReadVarint();
        local v835 = u8;
        u8 = u8 + v834;
        v826.NameTag = buffer.readstring(buffer_create_ret2, v835, v834);
    end;

    if bit32.btest(buffer_readu8_ret2, 4) == true then
        local v836 = u8;
        u8 = u8 + 4;
        v826.KillTrack = buffer.readu32(buffer_create_ret2, v836 + 0);
    end;

    if bit32.btest(buffer_readu8_ret2, 8) == true then
        local v837 = u8;
        u8 = u8 + 2;
        v826.KillTrackColor = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v837 + 0) do
            local v838 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v838);
            local v839 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v839);
            v826.KillTrackColor[buffer_readu8_ret3] = buffer_readu8_ret4;
            local _ = i;
        end;
    end;

    v826.Type = "Equipment";

    return v826;
end;

function u1.Gui_ReadEVENT_InventoryRemove() -- Line: 3129
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v840 = u8;
    u8 = u8 + 1;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v840 + 0);
    local v841 = true;

    if buffer_readu8_ret ~= 0 then
        if buffer_readu8_ret == 1 then
            local v842 = {
                ItemName = false,
                ItemId = false
            };
            local v843 = ReadVarint();
            local v844 = u8;
            u8 = u8 + v843;
            v842.ItemName = buffer.readstring(buffer_create_ret2, v844, v843);
            local v845 = ReadVarint();
            local v846 = u8;
            u8 = u8 + v845;
            v842.ItemId = buffer.readstring(buffer_create_ret2, v846, v845);
            v842.Type = "Container";

            return v842;
        end;

        if buffer_readu8_ret ~= 2 then
            error((`Unexpected variant: {buffer_readu8_ret}`));

            return v841;
        end;

        local v847 = {
            Category = false,
            ItemName = false,
            ItemId = false
        };
        local v848 = ReadVarint();
        local v849 = u8;
        u8 = u8 + v848;
        v847.Category = buffer.readstring(buffer_create_ret2, v849, v848);
        local v850 = ReadVarint();
        local v851 = u8;
        u8 = u8 + v850;
        v847.ItemName = buffer.readstring(buffer_create_ret2, v851, v850);
        local v852 = ReadVarint();
        local v853 = u8;
        u8 = u8 + v852;
        v847.ItemId = buffer.readstring(buffer_create_ret2, v853, v852);
        v847.Type = "GraphicArt";

        return v847;
    end;

    local v854 = u8;
    u8 = u8 + 1;
    local v855 = {
        WeaponName = false,
        SkinName = false,
        SkinId = false
    };
    local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v854 + 0);
    local v856 = ReadVarint();
    local v857 = u8;
    u8 = u8 + v856;
    v855.WeaponName = buffer.readstring(buffer_create_ret2, v857, v856);
    local v858 = ReadVarint();
    local v859 = u8;
    u8 = u8 + v858;
    v855.SkinName = buffer.readstring(buffer_create_ret2, v859, v858);
    local v860 = ReadVarint();
    local v861 = u8;
    u8 = u8 + v860;
    v855.SkinId = buffer.readstring(buffer_create_ret2, v861, v860);

    if bit32.btest(buffer_readu8_ret2, 1) == true then
        local v862 = u8;
        u8 = u8 + 8;
        v855.Date = buffer.readf64(buffer_create_ret2, v862 + 0);

        if v855.Date <= (-1 / 0) or v855.Date >= (1 / 0) then
            error((`Expected "Value.Date" to be a finite number, got {v855.Date} instead.`));
        end;
    end;

    if bit32.btest(buffer_readu8_ret2, 2) == true then
        local v863 = ReadVarint();
        local v864 = u8;
        u8 = u8 + v863;
        v855.NameTag = buffer.readstring(buffer_create_ret2, v864, v863);
    end;

    if bit32.btest(buffer_readu8_ret2, 4) == true then
        local v865 = u8;
        u8 = u8 + 4;
        v855.KillTrack = buffer.readu32(buffer_create_ret2, v865 + 0);
    end;

    if bit32.btest(buffer_readu8_ret2, 8) == true then
        local v866 = u8;
        u8 = u8 + 2;
        v855.KillTrackColor = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v866 + 0) do
            local v867 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v867);
            local v868 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v868);
            v855.KillTrackColor[buffer_readu8_ret3] = buffer_readu8_ret4;
            local _ = i;
        end;
    end;

    v855.Type = "Equipment";

    return v855;
end;

function u1.Gui_ReadEVENT_InventoryEquip() -- Line: 3196
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v869 = u8;
    u8 = u8 + 1;
    local v870 = {
        Team = false,
        Changes = false,
        Team = buffer.readu8(buffer_create_ret2, v869 + 0)
    };
    local v871 = ReadVarint();
    v870.Changes = table.create(v871);
    local v872 = u8;
    u8 = u8 + v871 * 1;

    for i = 1, v871 do
        local v873 = {
            WeaponName = false,
            SkinName = false,
            SkinId = false,
            Equipped = false
        };
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v872 + 0);
        local v874 = ReadVarint();
        local v875 = u8;
        u8 = u8 + v874;
        v873.WeaponName = buffer.readstring(buffer_create_ret2, v875, v874);
        local v876 = ReadVarint();
        local v877 = u8;
        u8 = u8 + v876;
        v873.SkinName = buffer.readstring(buffer_create_ret2, v877, v876);
        local v878 = ReadVarint();
        local v879 = u8;
        u8 = u8 + v878;
        v873.SkinId = buffer.readstring(buffer_create_ret2, v879, v878);
        v873.Equipped = bit32.btest(buffer_readu8_ret, 1);
        v870.Changes[i] = v873;
        v872 = v872 + 1;
        local _ = i;
    end;

    return v870;
end;

function u1.Gui_ReadEVENT_PlayerStatsUpdate() -- Line: 3223
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v880 = u8;
    u8 = u8 + 2;
    local v881 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v880 + 0) do
        local v882 = ReadVarint();
        local v883 = u8;
        u8 = u8 + v882;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v883, v882);
        local v884 = u8;
        u8 = u8 + 8;
        local buffer_readf64_ret = buffer.readf64(buffer_create_ret2, v884);

        if buffer_readf64_ret <= (-1 / 0) or buffer_readf64_ret >= (1 / 0) then
            error((`Expected "Element_1" to be a finite number, got {buffer_readf64_ret} instead.`));
        end;

        v881[buffer_readstring_ret] = buffer_readf64_ret;
        local _ = i;
    end;

    return v881;
end;

function u1.Gui_ReadEVENT_PlaytimeUpdate() -- Line: 3239
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v885 = u8;
    u8 = u8 + 4;

    return buffer.readu32(buffer_create_ret2, v885 + 0);
end;

function u1.Gui_ReadEVENT_PlaytimeRewardsCollectedUpdate() -- Line: 3246
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v886 = u8;
    u8 = u8 + 2;
    local v887 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v886 + 0) do
        local v888 = ReadVarint();
        local v889 = u8;
        u8 = u8 + v888;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v889, v888);
        local v890 = u8;
        u8 = u8 + 1;
        v887[buffer_readstring_ret] = buffer.readu8(buffer_create_ret2, v890) == 1;
        local _ = i;
    end;

    return v887;
end;

function u1.Gui_ReadEVENT_UsedCodesUpdate() -- Line: 3261
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v891 = u8;
    u8 = u8 + 2;
    local v892 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v891 + 0) do
        local v893 = ReadVarint();
        local v894 = u8;
        u8 = u8 + v893;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v894, v893);
        local v895 = u8;
        u8 = u8 + 1;
        v892[buffer_readstring_ret] = buffer.readu8(buffer_create_ret2, v895) == 1;
        local _ = i;
    end;

    return v892;
end;

function u1.Gui_ReadEVENT_CollectedAchievementsUpdate() -- Line: 3276
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v896 = u8;
    u8 = u8 + 2;
    local v897 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v896 + 0) do
        local v898 = ReadVarint();
        local v899 = u8;
        u8 = u8 + v898;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v899, v898);
        local v900 = u8;
        u8 = u8 + 1;
        v897[buffer_readstring_ret] = buffer.readu8(buffer_create_ret2, v900) == 1;
        local _ = i;
    end;

    return v897;
end;

function u1.Gui_ReadEVENT_GamepassesUpdate() -- Line: 3291
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v901 = u8;
    u8 = u8 + 2;
    local v902 = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v901 + 0) do
        local v903 = ReadVarint();
        local v904 = u8;
        u8 = u8 + v903;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v904, v903);
        local v905 = u8;
        u8 = u8 + 8;
        local buffer_readf64_ret = buffer.readf64(buffer_create_ret2, v905);

        if buffer_readf64_ret <= (-1 / 0) or buffer_readf64_ret >= (1 / 0) then
            error((`Expected "Element_1" to be a finite number, got {buffer_readf64_ret} instead.`));
        end;

        v902[buffer_readstring_ret] = buffer_readf64_ret;
        local _ = i;
    end;

    return v902;
end;

function u1.Gui_ReadEVENT_ChallengesUpdate() -- Line: 3307
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v906 = u8;
    u8 = u8 + 20;
    local v907 = {
        Hour = false,
        Week = false,
        WeekDay = false,
        Month = false,
        Hourly = false,
        Daily = false,
        Weekly = false,
        Monthly = false,
        Hour = buffer.readu32(buffer_create_ret2, v906 + 0),
        Week = buffer.readu32(buffer_create_ret2, v906 + 4)
    };
    local v908 = ReadVarint();
    local v909 = u8;
    u8 = u8 + v908;
    v907.WeekDay = buffer.readstring(buffer_create_ret2, v909, v908);
    v907.Month = buffer.readu32(buffer_create_ret2, v906 + 8);
    v907.Hourly = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v906 + 12) do
        local v910 = ReadVarint();
        local v911 = u8;
        u8 = u8 + v910;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v911, v910);
        local v912 = {
            name = false,
            progress = false,
            isPremium = false
        };
        local v913 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v913);
        local v914 = ReadVarint();
        local v915 = u8;
        u8 = u8 + v914;
        v912.name = buffer.readstring(buffer_create_ret2, v915, v914);
        local v916 = u8;
        u8 = u8 + 4;
        v912.progress = buffer.readu32(buffer_create_ret2, v916);
        v912.isPremium = bit32.btest(buffer_readu8_ret, 1);

        if bit32.btest(buffer_readu8_ret, 2) == true then
            local v917 = u8;
            u8 = u8 + 1;
            v912.chosen = buffer.readu8(buffer_create_ret2, v917 + 0) == 1;
        end;

        if bit32.btest(buffer_readu8_ret, 4) == true then
            local v918 = u8;
            u8 = u8 + 1;
            v912.completed = buffer.readu8(buffer_create_ret2, v918 + 0) == 1;
        end;

        v907.Hourly[buffer_readstring_ret] = v912;
        local _ = i;
    end;

    v907.Daily = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v906 + 14) do
        local v919 = ReadVarint();
        local v920 = u8;
        u8 = u8 + v919;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v920, v919);
        local v921 = {
            name = false,
            progress = false,
            isPremium = false
        };
        local v922 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v922);
        local v923 = ReadVarint();
        local v924 = u8;
        u8 = u8 + v923;
        v921.name = buffer.readstring(buffer_create_ret2, v924, v923);
        local v925 = u8;
        u8 = u8 + 4;
        v921.progress = buffer.readu32(buffer_create_ret2, v925);
        v921.isPremium = bit32.btest(buffer_readu8_ret, 1);

        if bit32.btest(buffer_readu8_ret, 2) == true then
            local v926 = u8;
            u8 = u8 + 1;
            v921.chosen = buffer.readu8(buffer_create_ret2, v926 + 0) == 1;
        end;

        if bit32.btest(buffer_readu8_ret, 4) == true then
            local v927 = u8;
            u8 = u8 + 1;
            v921.completed = buffer.readu8(buffer_create_ret2, v927 + 0) == 1;
        end;

        v907.Daily[buffer_readstring_ret] = v921;
        local _ = i;
    end;

    v907.Weekly = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v906 + 16) do
        local v928 = ReadVarint();
        local v929 = u8;
        u8 = u8 + v928;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v929, v928);
        local v930 = {
            name = false,
            progress = false,
            isPremium = false
        };
        local v931 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v931);
        local v932 = ReadVarint();
        local v933 = u8;
        u8 = u8 + v932;
        v930.name = buffer.readstring(buffer_create_ret2, v933, v932);
        local v934 = u8;
        u8 = u8 + 4;
        v930.progress = buffer.readu32(buffer_create_ret2, v934);
        v930.isPremium = bit32.btest(buffer_readu8_ret, 1);

        if bit32.btest(buffer_readu8_ret, 2) == true then
            local v935 = u8;
            u8 = u8 + 1;
            v930.chosen = buffer.readu8(buffer_create_ret2, v935 + 0) == 1;
        end;

        if bit32.btest(buffer_readu8_ret, 4) == true then
            local v936 = u8;
            u8 = u8 + 1;
            v930.completed = buffer.readu8(buffer_create_ret2, v936 + 0) == 1;
        end;

        v907.Weekly[buffer_readstring_ret] = v930;
        local _ = i;
    end;

    v907.Monthly = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v906 + 18) do
        local v937 = ReadVarint();
        local v938 = u8;
        u8 = u8 + v937;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v938, v937);
        local v939 = {
            name = false,
            progress = false,
            isPremium = false
        };
        local v940 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v940);
        local v941 = ReadVarint();
        local v942 = u8;
        u8 = u8 + v941;
        v939.name = buffer.readstring(buffer_create_ret2, v942, v941);
        local v943 = u8;
        u8 = u8 + 4;
        v939.progress = buffer.readu32(buffer_create_ret2, v943);
        v939.isPremium = bit32.btest(buffer_readu8_ret, 1);

        if bit32.btest(buffer_readu8_ret, 2) == true then
            local v944 = u8;
            u8 = u8 + 1;
            v939.chosen = buffer.readu8(buffer_create_ret2, v944 + 0) == 1;
        end;

        if bit32.btest(buffer_readu8_ret, 4) == true then
            local v945 = u8;
            u8 = u8 + 1;
            v939.completed = buffer.readu8(buffer_create_ret2, v945 + 0) == 1;
        end;

        v907.Monthly[buffer_readstring_ret] = v939;
        local _ = i;
    end;

    return v907;
end;

function u1.Gui_ReadEVENT_BattlepassUpdate() -- Line: 3419
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v946 = u8;
    u8 = u8 + 13;
    local v947 = {
        Season = false,
        Premium = false,
        XP = false,
        Rewards = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v946 + 0);
    v947.Season = buffer.readu32(buffer_create_ret2, v946 + 1);
    v947.Premium = bit32.btest(buffer_readu8_ret, 1);
    v947.XP = buffer.readu32(buffer_create_ret2, v946 + 5);
    local v948 = {
        Free = false,
        Premium = false
    };
    v947.Rewards = v948;
    v948.Free = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v946 + 9) do
        local v949 = ReadVarint();
        local v950 = u8;
        u8 = u8 + v949;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v950, v949);
        local v951 = u8;
        u8 = u8 + 1;
        local v952 = buffer.readu8(buffer_create_ret2, v951) == 1;
        v948.Free[buffer_readstring_ret] = v952;
        local _ = i;
    end;

    v948.Premium = {};

    for i = 1, buffer.readu16(buffer_create_ret2, v946 + 11) do
        local v953 = ReadVarint();
        local v954 = u8;
        u8 = u8 + v953;
        local buffer_readstring_ret = buffer.readstring(buffer_create_ret2, v954, v953);
        local v955 = u8;
        u8 = u8 + 1;
        local v956 = buffer.readu8(buffer_create_ret2, v955) == 1;
        v948.Premium[buffer_readstring_ret] = v956;
        local _ = i;
    end;

    return v947;
end;

function u1.Gui_ReadEVENT_CreditsUpdate() -- Line: 3450
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v957 = u8;
    u8 = u8 + 4;

    return buffer.readu32(buffer_create_ret2, v957 + 0);
end;

function u1.Entity_WriteEVENT_RequestFullUpdate(p958: number, p959: table?) -- Line: 3457
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v960 = u20;

        for i = #v960, u19 + 1, -1 do
            v960[i] = nil;
            local _ = i;
        end;

        local v961 = u21;
        u21 = nil;

        if u6 == v960 then
            if v961 then
                Load(v961);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p959;
    local v962 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v962 + 0, 100);

    if typeof(p958) ~= "number" then
        error((`Expected Value to be of type number, got {type(p958)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v962 + 1, p958);
    u17 = false;
    u21 = nil;
end;

function u1.Entity_WriteEVENT_AckSnapshot(p963: number, p964: table?) -- Line: 3470
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v965 = u20;

        for i = #v965, u19 + 1, -1 do
            v965[i] = nil;
            local _ = i;
        end;

        local v966 = u21;
        u21 = nil;

        if u6 == v965 then
            if v966 then
                Load(v966);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p964;
    local v967 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v967 + 0, 8);

    if typeof(p963) ~= "number" then
        error((`Expected Value to be of type number, got {type(p963)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v967 + 1, p963);
    u17 = false;
    u21 = nil;
end;

function u1.Entity_ReadEVENT_EntityVisibility() -- Line: 3483
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v968 = u8;
    u8 = u8 + 2;

    return buffer.readu8(buffer_create_ret2, v968 + 0), buffer.readu8(buffer_create_ret2, v968 + 1) == 1;
end;

function u1.Entity_ReadEVENT_CreateEntity() -- Line: 3491
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v969 = u8;
    u8 = u8 + 3;
    local v970 = {
        Type = false,
        Identifier = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v969 + 0);
    v970.Type = buffer.readu8(buffer_create_ret2, v969 + 1);
    v970.Identifier = buffer.readu8(buffer_create_ret2, v969 + 2);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v971 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v971 + 0);
        v970.Data = true;

        if buffer_readu8_ret2 == 0 then
            local v972 = u8;
            u8 = u8 + 3;
            local v973 = {
                Team = false,
                Agent = false,
                State = false
            };
            v970.Data = v973;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v972 + 0);
            v973.Team = buffer.readu8(buffer_create_ret2, v972 + 1);
            v973.Agent = buffer.readu8(buffer_create_ret2, v972 + 2);

            if bit32.btest(buffer_readu8_ret3, 1) == true then
                local v974 = u8;
                u8 = u8 + 8;
                v973.UserId = buffer.readf64(buffer_create_ret2, v974 + 0);

                if v973.UserId <= (-1 / 0) or v973.UserId >= (1 / 0) then
                    error((`Expected "Struct_33.UserId" to be a finite number, got {v973.UserId} instead.`));
                end;
            end;

            local v975 = ReadVarint();
            v973.State = buffer.create(v975);
            local v976 = u8;
            u8 = u8 + v975;
            buffer.copy(v973.State, 0, buffer_create_ret2, v976, v975);
            v970.Data.Type = "Character";

            return v970;
        end;

        if buffer_readu8_ret2 == 1 then
            local v977 = u8;
            u8 = u8 + 3;
            local v978 = {
                PlayerName = false,
                WeaponName = false,
                WeaponSkin = false,
                State = false
            };
            v970.Data = v978;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v977 + 0);
            local v979 = ReadVarint();
            local v980 = u8;
            u8 = u8 + v979;
            v978.PlayerName = buffer.readstring(buffer_create_ret2, v980, v979);
            v978.WeaponName = buffer.readu8(buffer_create_ret2, v977 + 1);
            v978.WeaponSkin = buffer.readu8(buffer_create_ret2, v977 + 2);

            if bit32.btest(buffer_readu8_ret3, 1) == true then
                local v981 = u8;
                u8 = u8 + 5;
                local v982 = {
                    Tint = false,
                    Strength = false
                };
                v978.Emissive = v982;
                v982.Tint = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v981 + 0), buffer.readu8(buffer_create_ret2, v981 + 1), (buffer.readu8(buffer_create_ret2, v981 + 2)));
                local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v981 + 3);
                local v983 = buffer_readu16_ret % 32768;

                if v983 == 31744 then
                    if buffer_readu16_ret // 32768 == 1 then
                        v982.Strength = (-1 / 0);
                    else
                        v982.Strength = (1 / 0);
                    end;
                elseif v983 == 64512 then
                    v982.Strength = (0 / 0);
                elseif v983 == 0 then
                    v982.Strength = 0;
                else
                    local v984 = v983 % 1024;
                    local v985 = v983 // 1024;
                    local v986;

                    if v985 == 0 then
                        v986 = v984 / 1024;
                    else
                        v986 = v984 / 2048 + 0.5;
                    end;

                    local math_ldexp_ret = math.ldexp(v986, v985 - 14);

                    if buffer_readu16_ret // 32768 == 1 then
                        math_ldexp_ret = -math_ldexp_ret;
                    end;

                    v982.Strength = math_ldexp_ret;
                end;

                if v982.Strength <= (-1 / 0) or v982.Strength >= (1 / 0) then
                    error((`Expected "Struct_37.Strength" to be a finite number, got {v982.Strength} instead.`));
                end;
            end;

            local v987 = ReadVarint();
            v978.State = buffer.create(v987);
            local v988 = u8;
            u8 = u8 + v987;
            buffer.copy(v978.State, 0, buffer_create_ret2, v988, v987);
            v970.Data.Type = "DroppedWeapon";

            return v970;
        end;

        if buffer_readu8_ret2 == 2 then
            local v989 = u8;
            u8 = u8 + 20;
            local v990 = {
                Position = false,
                Yaw = false,
                Roll = false,
                State = false
            };
            v970.Data = v990;
            local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v989 + 0);
            local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v989 + 4);
            local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v989 + 8);
            v990.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

            if v990.Position.Magnitude <= (-1 / 0) or v990.Position.Magnitude >= (1 / 0) then
                error((`Expected "Struct_38.Position" to be a finite number, got {v990.Position.Magnitude} instead.`));
            end;

            v990.Yaw = buffer.readf32(buffer_create_ret2, v989 + 12);

            if v990.Yaw <= (-1 / 0) or v990.Yaw >= (1 / 0) then
                error((`Expected "Struct_38.Yaw" to be a finite number, got {v990.Yaw} instead.`));
            end;

            v990.Roll = buffer.readf32(buffer_create_ret2, v989 + 16);

            if v990.Roll <= (-1 / 0) or v990.Roll >= (1 / 0) then
                error((`Expected "Struct_38.Roll" to be a finite number, got {v990.Roll} instead.`));
            end;

            local v991 = ReadVarint();
            v990.State = buffer.create(v991);
            local v992 = u8;
            u8 = u8 + v991;
            buffer.copy(v990.State, 0, buffer_create_ret2, v992, v991);
            v970.Data.Type = "Bomb";

            return v970;
        end;

        if buffer_readu8_ret2 == 3 then
            local v993 = u8;
            u8 = u8 + 41;
            local v994 = {
                ClassName = false,
                DoorLeaf = false,
                HingeCFrame = false,
                Breakable = false,
                Health = false,
                DoorState = false,
                OpenAngle = false,
                Speed = false,
                AutoCloseDelay = false,
                Locked = false
            };
            v970.Data = v994;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v993 + 0);
            local v995 = ReadVarint();
            local v996 = u8;
            u8 = u8 + v995;
            v994.ClassName = buffer.readstring(buffer_create_ret2, v996, v995);
            local v997 = ReadVarint();
            local v998 = u8;
            u8 = u8 + v997;
            v994.DoorLeaf = buffer.readstring(buffer_create_ret2, v998, v997);
            local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v993 + 1);
            local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v993 + 5);
            local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v993 + 9);
            local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
            local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v993 + 13);
            local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v993 + 17);
            local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v993 + 21);
            v994.HingeCFrame = CFrame.new(vector_create_ret) * CFrame.fromOrientation(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

            if v994.HingeCFrame.Position.Magnitude <= (-1 / 0) or v994.HingeCFrame.Position.Magnitude >= (1 / 0) then
                error((`Expected "Struct_39.HingeCFrame" to be a finite number, got {v994.HingeCFrame.Position.Magnitude} instead.`));
            end;

            if v994.HingeCFrame.LookVector.Magnitude <= (-1 / 0) or v994.HingeCFrame.LookVector.Magnitude >= (1 / 0) then
                error((`Expected "Struct_39.HingeCFrame" to be a finite number, got {v994.HingeCFrame.LookVector.Magnitude} instead.`));
            end;

            v994.Breakable = bit32.btest(buffer_readu8_ret3, 1);
            v994.Health = buffer.readf32(buffer_create_ret2, v993 + 25);

            if v994.Health <= (-1 / 0) or v994.Health >= (1 / 0) then
                error((`Expected "Struct_39.Health" to be a finite number, got {v994.Health} instead.`));
            end;

            local v999 = ReadVarint();
            local v1000 = u8;
            u8 = u8 + v999;
            v994.DoorState = buffer.readstring(buffer_create_ret2, v1000, v999);
            v994.OpenAngle = buffer.readf32(buffer_create_ret2, v993 + 29);

            if v994.OpenAngle <= (-1 / 0) or v994.OpenAngle >= (1 / 0) then
                error((`Expected "Struct_39.OpenAngle" to be a finite number, got {v994.OpenAngle} instead.`));
            end;

            v994.Speed = buffer.readf32(buffer_create_ret2, v993 + 33);

            if v994.Speed <= (-1 / 0) or v994.Speed >= (1 / 0) then
                error((`Expected "Struct_39.Speed" to be a finite number, got {v994.Speed} instead.`));
            end;

            v994.AutoCloseDelay = buffer.readf32(buffer_create_ret2, v993 + 37);

            if v994.AutoCloseDelay <= (-1 / 0) or v994.AutoCloseDelay >= (1 / 0) then
                error((`Expected "Struct_39.AutoCloseDelay" to be a finite number, got {v994.AutoCloseDelay} instead.`));
            end;

            v994.Locked = bit32.btest(buffer_readu8_ret3, 2);
            v970.Data.Type = "Door";

            return v970;
        end;

        error((`Unexpected variant: {buffer_readu8_ret2}`));
    end;

    return v970;
end;

function u1.Entity_ReadEVENT_DestroyEntity() -- Line: 3625
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1001 = u8;
    u8 = u8 + 2;

    return {
        Type = false,
        Identifier = false,
        Type = buffer.readu8(buffer_create_ret2, v1001 + 0),
        Identifier = buffer.readu8(buffer_create_ret2, v1001 + 1)
    };
end;

function u1.Entity_ReadEVENT_OnPlayerConnected() -- Line: 3634
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1002 = u8;
    u8 = u8 + 1;
    local v1003 = {};

    for i = 1, buffer.readu8(buffer_create_ret2, v1002 + 0) do
        local v1004 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1004);
        local v1005 = {};
        local v1006 = u8;
        u8 = u8 + 1;
        local _ = i;

        for i2 = 1, buffer.readu8(buffer_create_ret2, v1006) do
            local v1007 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v1007);
            local v1008 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v1008);
            local v1009 = true;

            if buffer_readu8_ret3 == 0 then
                local v1010 = u8;
                u8 = u8 + 3;
                v1009 = {
                    Team = false,
                    Agent = false,
                    State = false
                };
                local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v1010 + 0);
                v1009.Team = buffer.readu8(buffer_create_ret2, v1010 + 1);
                v1009.Agent = buffer.readu8(buffer_create_ret2, v1010 + 2);

                if bit32.btest(buffer_readu8_ret4, 1) == true then
                    local v1011 = u8;
                    u8 = u8 + 8;
                    v1009.UserId = buffer.readf64(buffer_create_ret2, v1011 + 0);

                    if v1009.UserId <= (-1 / 0) or v1009.UserId >= (1 / 0) then
                        error((`Expected "Element_2.UserId" to be a finite number, got {v1009.UserId} instead.`));
                    end;
                end;

                local v1012 = ReadVarint();
                v1009.State = buffer.create(v1012);
                local v1013 = u8;
                u8 = u8 + v1012;
                buffer.copy(v1009.State, 0, buffer_create_ret2, v1013, v1012);
                v1009.Type = "Character";
            elseif buffer_readu8_ret3 == 1 then
                local v1014 = u8;
                u8 = u8 + 3;
                v1009 = {
                    PlayerName = false,
                    WeaponName = false,
                    WeaponSkin = false,
                    State = false
                };
                local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v1014 + 0);
                local v1015 = ReadVarint();
                local v1016 = u8;
                u8 = u8 + v1015;
                v1009.PlayerName = buffer.readstring(buffer_create_ret2, v1016, v1015);
                v1009.WeaponName = buffer.readu8(buffer_create_ret2, v1014 + 1);
                v1009.WeaponSkin = buffer.readu8(buffer_create_ret2, v1014 + 2);

                if bit32.btest(buffer_readu8_ret4, 1) == true then
                    local v1017 = u8;
                    u8 = u8 + 5;
                    local v1018 = {
                        Tint = false,
                        Strength = false
                    };
                    v1009.Emissive = v1018;
                    v1018.Tint = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v1017 + 0), buffer.readu8(buffer_create_ret2, v1017 + 1), (buffer.readu8(buffer_create_ret2, v1017 + 2)));
                    local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1017 + 3);
                    local v1019 = buffer_readu16_ret % 32768;

                    if v1019 == 31744 then
                        if buffer_readu16_ret // 32768 == 1 then
                            v1018.Strength = (-1 / 0);
                        else
                            v1018.Strength = (1 / 0);
                        end;
                    elseif v1019 == 64512 then
                        v1018.Strength = (0 / 0);
                    elseif v1019 == 0 then
                        v1018.Strength = 0;
                    else
                        local v1020 = v1019 % 1024;
                        local v1021 = v1019 // 1024;
                        local v1022;

                        if v1021 == 0 then
                            v1022 = v1020 / 1024;
                        else
                            v1022 = v1020 / 2048 + 0.5;
                        end;

                        local math_ldexp_ret = math.ldexp(v1022, v1021 - 14);

                        if buffer_readu16_ret // 32768 == 1 then
                            math_ldexp_ret = -math_ldexp_ret;
                        end;

                        v1018.Strength = math_ldexp_ret;
                    end;

                    if v1018.Strength <= (-1 / 0) or v1018.Strength >= (1 / 0) then
                        error((`Expected "Struct_43.Strength" to be a finite number, got {v1018.Strength} instead.`));
                    end;
                end;

                local v1023 = ReadVarint();
                v1009.State = buffer.create(v1023);
                local v1024 = u8;
                u8 = u8 + v1023;
                buffer.copy(v1009.State, 0, buffer_create_ret2, v1024, v1023);
                v1009.Type = "DroppedWeapon";
            elseif buffer_readu8_ret3 == 2 then
                local v1025 = u8;
                u8 = u8 + 20;
                v1009 = {
                    Position = false,
                    Yaw = false,
                    Roll = false,
                    State = false
                };
                local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1025 + 0);
                local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1025 + 4);
                local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1025 + 8);
                v1009.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

                if v1009.Position.Magnitude <= (-1 / 0) or v1009.Position.Magnitude >= (1 / 0) then
                    error((`Expected "Element_2.Position" to be a finite number, got {v1009.Position.Magnitude} instead.`));
                end;

                v1009.Yaw = buffer.readf32(buffer_create_ret2, v1025 + 12);

                if v1009.Yaw <= (-1 / 0) or v1009.Yaw >= (1 / 0) then
                    error((`Expected "Element_2.Yaw" to be a finite number, got {v1009.Yaw} instead.`));
                end;

                v1009.Roll = buffer.readf32(buffer_create_ret2, v1025 + 16);

                if v1009.Roll <= (-1 / 0) or v1009.Roll >= (1 / 0) then
                    error((`Expected "Element_2.Roll" to be a finite number, got {v1009.Roll} instead.`));
                end;

                local v1026 = ReadVarint();
                v1009.State = buffer.create(v1026);
                local v1027 = u8;
                u8 = u8 + v1026;
                buffer.copy(v1009.State, 0, buffer_create_ret2, v1027, v1026);
                v1009.Type = "Bomb";
            elseif buffer_readu8_ret3 == 3 then
                local v1028 = u8;
                u8 = u8 + 41;
                v1009 = {
                    ClassName = false,
                    DoorLeaf = false,
                    HingeCFrame = false,
                    Breakable = false,
                    Health = false,
                    DoorState = false,
                    OpenAngle = false,
                    Speed = false,
                    AutoCloseDelay = false,
                    Locked = false
                };
                local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v1028 + 0);
                local v1029 = ReadVarint();
                local v1030 = u8;
                u8 = u8 + v1029;
                v1009.ClassName = buffer.readstring(buffer_create_ret2, v1030, v1029);
                local v1031 = ReadVarint();
                local v1032 = u8;
                u8 = u8 + v1031;
                v1009.DoorLeaf = buffer.readstring(buffer_create_ret2, v1032, v1031);
                local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1028 + 1);
                local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1028 + 5);
                local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1028 + 9);
                local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1028 + 13);
                local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1028 + 17);
                local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1028 + 21);
                v1009.HingeCFrame = CFrame.new(vector_create_ret) * CFrame.fromOrientation(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

                if v1009.HingeCFrame.Position.Magnitude <= (-1 / 0) or v1009.HingeCFrame.Position.Magnitude >= (1 / 0) then
                    error((`Expected "Element_2.HingeCFrame" to be a finite number, got {v1009.HingeCFrame.Position.Magnitude} instead.`));
                end;

                if v1009.HingeCFrame.LookVector.Magnitude <= (-1 / 0) or v1009.HingeCFrame.LookVector.Magnitude >= (1 / 0) then
                    error((`Expected "Element_2.HingeCFrame" to be a finite number, got {v1009.HingeCFrame.LookVector.Magnitude} instead.`));
                end;

                v1009.Breakable = bit32.btest(buffer_readu8_ret4, 1);
                v1009.Health = buffer.readf32(buffer_create_ret2, v1028 + 25);

                if v1009.Health <= (-1 / 0) or v1009.Health >= (1 / 0) then
                    error((`Expected "Element_2.Health" to be a finite number, got {v1009.Health} instead.`));
                end;

                local v1033 = ReadVarint();
                local v1034 = u8;
                u8 = u8 + v1033;
                v1009.DoorState = buffer.readstring(buffer_create_ret2, v1034, v1033);
                v1009.OpenAngle = buffer.readf32(buffer_create_ret2, v1028 + 29);

                if v1009.OpenAngle <= (-1 / 0) or v1009.OpenAngle >= (1 / 0) then
                    error((`Expected "Element_2.OpenAngle" to be a finite number, got {v1009.OpenAngle} instead.`));
                end;

                v1009.Speed = buffer.readf32(buffer_create_ret2, v1028 + 33);

                if v1009.Speed <= (-1 / 0) or v1009.Speed >= (1 / 0) then
                    error((`Expected "Element_2.Speed" to be a finite number, got {v1009.Speed} instead.`));
                end;

                v1009.AutoCloseDelay = buffer.readf32(buffer_create_ret2, v1028 + 37);

                if v1009.AutoCloseDelay <= (-1 / 0) or v1009.AutoCloseDelay >= (1 / 0) then
                    error((`Expected "Element_2.AutoCloseDelay" to be a finite number, got {v1009.AutoCloseDelay} instead.`));
                end;

                v1009.Locked = bit32.btest(buffer_readu8_ret4, 2);
                v1009.Type = "Door";
            else
                error((`Unexpected variant: {buffer_readu8_ret3}`));
            end;

            v1005[buffer_readu8_ret2] = v1009;
            local _ = i2;
        end;

        v1003[buffer_readu8_ret] = v1005;
    end;

    return v1003;
end;

function u1.Entity_ReadEVENT_EntitySnapshot() -- Line: 3772
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1035 = u8;
    u8 = u8 + 9;
    local buffer_readu32_ret = buffer.readu32(buffer_create_ret2, v1035 + 0);
    local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret2, v1035 + 4);
    local v1036;

    if buffer.readu8(buffer_create_ret2, v1035 + 8) == 1 then
        local v1037 = u8;
        u8 = u8 + 1;
        v1036 = {};

        for i = 1, buffer.readu8(buffer_create_ret2, v1037 + 0) do
            local v1038 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1038);
            local v1039 = {};
            local v1040 = u8;
            u8 = u8 + 1;
            local _ = i;

            for i2 = 1, buffer.readu8(buffer_create_ret2, v1040) do
                local v1041 = u8;
                u8 = u8 + 1;
                local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v1041);
                local v1042 = ReadVarint();
                local buffer_create_ret3 = buffer.create(v1042);
                local v1043 = u8;
                u8 = u8 + v1042;
                buffer.copy(buffer_create_ret3, 0, buffer_create_ret2, v1043, v1042);
                v1039[buffer_readu8_ret2] = buffer_create_ret3;
                local _ = i2;
            end;

            v1036[buffer_readu8_ret] = v1039;
        end;
    else
        v1036 = nil;
    end;

    return buffer_readu32_ret, buffer_readu32_ret2, v1036;
end;

function u1.Entity_ReadEVENT_CharacterCurrentWeapon() -- Line: 3803
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1044 = u8;
    u8 = u8 + 2;
    local v1045 = {
        Identifier = false,
        Data = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1044 + 0);
    v1045.Identifier = buffer.readu8(buffer_create_ret2, v1044 + 1);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v1046 = u8;
        u8 = u8 + 5;
        local v1047 = {
            Tint = false,
            Strength = false
        };
        v1045.Emissive = v1047;
        v1047.Tint = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v1046 + 0), buffer.readu8(buffer_create_ret2, v1046 + 1), (buffer.readu8(buffer_create_ret2, v1046 + 2)));
        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1046 + 3);
        local v1048 = buffer_readu16_ret % 32768;

        if v1048 == 31744 then
            if buffer_readu16_ret // 32768 == 1 then
                v1047.Strength = (-1 / 0);
            else
                v1047.Strength = (1 / 0);
            end;
        elseif v1048 == 64512 then
            v1047.Strength = (0 / 0);
        elseif v1048 == 0 then
            v1047.Strength = 0;
        else
            local v1049 = v1048 % 1024;
            local v1050 = v1048 // 1024;
            local v1051;

            if v1050 == 0 then
                v1051 = v1049 / 1024;
            else
                v1051 = v1049 / 2048 + 0.5;
            end;

            local math_ldexp_ret = math.ldexp(v1051, v1050 - 14);

            if buffer_readu16_ret // 32768 == 1 then
                math_ldexp_ret = -math_ldexp_ret;
            end;

            v1047.Strength = math_ldexp_ret;
        end;

        if v1047.Strength <= (-1 / 0) or v1047.Strength >= (1 / 0) then
            error((`Expected "Struct_46.Strength" to be a finite number, got {v1047.Strength} instead.`));
        end;
    end;

    if bit32.btest(buffer_readu8_ret, 2) == true then
        local v1052 = u8;
        u8 = u8 + 4;
        v1045.KillTrack = buffer.readu32(buffer_create_ret2, v1052 + 0);
    end;

    if bit32.btest(buffer_readu8_ret, 4) == true then
        local v1053 = u8;
        u8 = u8 + 2;
        v1045.KillTrackColor = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v1053 + 0) do
            local v1054 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v1054);
            local v1055 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v1055);
            v1045.KillTrackColor[buffer_readu8_ret2] = buffer_readu8_ret3;
            local _ = i;
        end;
    end;

    local v1056 = ReadVarint();
    v1045.Data = buffer.create(v1056);
    local v1057 = u8;
    u8 = u8 + v1056;
    buffer.copy(v1045.Data, 0, buffer_create_ret2, v1057, v1056);

    if bit32.btest(buffer_readu8_ret, 8) == true then
        local v1058 = u8;
        u8 = u8 + 2;
        v1045.Stickers = {};

        for i = 1, buffer.readu16(buffer_create_ret2, v1058 + 0) do
            local v1059 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret2 = buffer.readu8(buffer_create_ret2, v1059);
            local v1060 = {
                StickerName = false,
                Position = false,
                Rotation = false
            };
            local v1061 = u8;
            u8 = u8 + 1;
            local buffer_readu8_ret3 = buffer.readu8(buffer_create_ret2, v1061);
            local v1062 = ReadVarint();
            local v1063 = u8;
            u8 = u8 + v1062;
            v1060.StickerName = buffer.readstring(buffer_create_ret2, v1063, v1062);
            v1060.Position = {};
            local v1064 = u8;
            u8 = u8 + 2;
            local _ = i;

            for i2 = 1, buffer.readu16(buffer_create_ret2, v1064) do
                local v1065 = u8;
                u8 = u8 + 1;
                local buffer_readu8_ret4 = buffer.readu8(buffer_create_ret2, v1065);
                local v1066 = u8;
                u8 = u8 + 4;
                local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1066);

                if buffer_readf32_ret <= (-1 / 0) or buffer_readf32_ret >= (1 / 0) then
                    error((`Expected "Element_3" to be a finite number, got {buffer_readf32_ret} instead.`));
                end;

                v1060.Position[buffer_readu8_ret4] = buffer_readf32_ret;
                local _ = i2;
            end;

            local v1067 = u8;
            u8 = u8 + 4;
            v1060.Rotation = buffer.readf32(buffer_create_ret2, v1067);

            if v1060.Rotation <= (-1 / 0) or v1060.Rotation >= (1 / 0) then
                error((`Expected "Element_2.Rotation" to be a finite number, got {v1060.Rotation} instead.`));
            end;

            if bit32.btest(buffer_readu8_ret3, 1) == true then
                local v1068 = u8;
                u8 = u8 + 1;
                v1060.Size = buffer.readu8(buffer_create_ret2, v1068 + 0);
            end;

            v1045.Stickers[buffer_readu8_ret2] = v1060;
        end;
    end;

    return v1045;
end;

function u1.Entity_ReadEVENT_CharacterWeaponInventorySlot() -- Line: 3900
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1069 = u8;
    u8 = u8 + 1;
    local v1070 = {
        Identifier = false,
        Data = false,
        Identifier = buffer.readu8(buffer_create_ret2, v1069 + 0)
    };
    local v1071 = ReadVarint();
    v1070.Data = buffer.create(v1071);
    local v1072 = u8;
    u8 = u8 + v1071;
    buffer.copy(v1070.Data, 0, buffer_create_ret2, v1072, v1071);

    return v1070;
end;

function u1.Entity_ReadEVENT_CharacterCurrentWeaponInventoryData() -- Line: 3911
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1073 = u8;
    u8 = u8 + 2;
    local v1074 = {
        Identifier = false,
        Slot = false,
        State = false,
        Identifier = buffer.readu8(buffer_create_ret2, v1073 + 0),
        Slot = buffer.readu8(buffer_create_ret2, v1073 + 1)
    };
    local v1075 = ReadVarint();
    v1074.State = buffer.create(v1075);
    local v1076 = u8;
    u8 = u8 + v1075;
    buffer.copy(v1074.State, 0, buffer_create_ret2, v1076, v1075);

    return v1074;
end;

function u1.Entity_ReadEVENT_CharacterDeath() -- Line: 3923
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1077 = u8;
    u8 = u8 + 38;
    local v1078 = {
        Identifier = false,
        Force = false,
        ForceLimb = false,
        Velocity = false,
        Origin = false,
        Identifier = buffer.readu8(buffer_create_ret2, v1077 + 0)
    };
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1077 + 1);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1077 + 5);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1077 + 9);
    v1078.Force = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v1078.Force.Magnitude <= (-1 / 0) or v1078.Force.Magnitude >= (1 / 0) then
        error((`Expected "Value.Force" to be a finite number, got {v1078.Force.Magnitude} instead.`));
    end;

    v1078.ForceLimb = buffer.readu8(buffer_create_ret2, v1077 + 13);
    local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1077 + 14);
    local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1077 + 18);
    local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1077 + 22);
    v1078.Velocity = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

    if v1078.Velocity.Magnitude <= (-1 / 0) or v1078.Velocity.Magnitude >= (1 / 0) then
        error((`Expected "Value.Velocity" to be a finite number, got {v1078.Velocity.Magnitude} instead.`));
    end;

    local buffer_readf32_ret7 = buffer.readf32(buffer_create_ret2, v1077 + 26);
    local buffer_readf32_ret8 = buffer.readf32(buffer_create_ret2, v1077 + 30);
    local buffer_readf32_ret9 = buffer.readf32(buffer_create_ret2, v1077 + 34);
    v1078.Origin = vector.create(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);

    if v1078.Origin.Magnitude <= (-1 / 0) or v1078.Origin.Magnitude >= (1 / 0) then
        error((`Expected "Value.Origin" to be a finite number, got {v1078.Origin.Magnitude} instead.`));
    end;

    return v1078;
end;

function u1.Particles_ReadEVENT_CreateBulletHole() -- Line: 3947
    -- upvalues: ReadVarint (copy), u8 (ref), buffer_create_ret2 (ref)
    local v1079 = ReadVarint();
    local table_create_ret5 = table.create(v1079);
    local v1080 = u8;
    u8 = u8 + v1079 * 24;

    for i = 1, v1079 do
        local v1081 = {
            Knife = false,
            IsCharacter = false,
            HasHelmet = false,
            Material = false,
            Position = false,
            Normal = false,
            Color = false
        };
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1080 + 0);
        v1081.Knife = bit32.btest(buffer_readu8_ret, 1);
        v1081.IsCharacter = bit32.btest(buffer_readu8_ret, 2);
        v1081.HasHelmet = bit32.btest(buffer_readu8_ret, 4);
        v1081.Material = buffer.readu16(buffer_create_ret2, v1080 + 1);
        local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1080 + 3);
        local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1080 + 7);
        local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1080 + 11);
        v1081.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

        if v1081.Position.Magnitude <= (-1 / 0) or v1081.Position.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.Position" to be a finite number, got {v1081.Position.Magnitude} instead.`));
        end;

        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1080 + 15);
        local v1082 = buffer_readu16_ret % 32768;
        local v1083;

        if v1082 == 31744 then
            v1083 = buffer_readu16_ret // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1082 == 64512 then
            v1083 = (0 / 0);
        elseif v1082 == 0 then
            v1083 = 0;
        else
            local v1084 = v1082 % 1024;
            local v1085 = v1082 // 1024;
            local v1086;

            if v1085 == 0 then
                v1086 = v1084 / 1024;
            else
                v1086 = v1084 / 2048 + 0.5;
            end;

            v1083 = math.ldexp(v1086, v1085 - 14);

            if buffer_readu16_ret // 32768 == 1 then
                v1083 = -v1083;
            end;
        end;

        local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v1080 + 17);
        local v1087 = buffer_readu16_ret2 % 32768;
        local v1088;

        if v1087 == 31744 then
            v1088 = buffer_readu16_ret2 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1087 == 64512 then
            v1088 = (0 / 0);
        elseif v1087 == 0 then
            v1088 = 0;
        else
            local v1089 = v1087 % 1024;
            local v1090 = v1087 // 1024;
            local v1091;

            if v1090 == 0 then
                v1091 = v1089 / 1024;
            else
                v1091 = v1089 / 2048 + 0.5;
            end;

            v1088 = math.ldexp(v1091, v1090 - 14);

            if buffer_readu16_ret2 // 32768 == 1 then
                v1088 = -v1088;
            end;
        end;

        local buffer_readu16_ret3 = buffer.readu16(buffer_create_ret2, v1080 + 19);
        local v1092 = buffer_readu16_ret3 % 32768;
        local v1093;

        if v1092 == 31744 then
            v1093 = buffer_readu16_ret3 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1092 == 64512 then
            v1093 = (0 / 0);
        elseif v1092 == 0 then
            v1093 = 0;
        else
            local v1094 = v1092 % 1024;
            local v1095 = v1092 // 1024;
            local v1096;

            if v1095 == 0 then
                v1096 = v1094 / 1024;
            else
                v1096 = v1094 / 2048 + 0.5;
            end;

            v1093 = math.ldexp(v1096, v1095 - 14);

            if buffer_readu16_ret3 // 32768 == 1 then
                v1093 = -v1093;
            end;
        end;

        v1081.Normal = vector.create(v1083, v1088, v1093);

        if v1081.Normal.Magnitude <= (-1 / 0) or v1081.Normal.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.Normal" to be a finite number, got {v1081.Normal.Magnitude} instead.`));
        end;

        v1081.Color = Color3.fromRGB(buffer.readu8(buffer_create_ret2, v1080 + 21), buffer.readu8(buffer_create_ret2, v1080 + 22), (buffer.readu8(buffer_create_ret2, v1080 + 23)));
        table_create_ret5[i] = v1081;
        v1080 = v1080 + 24;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.Particles_ReadEVENT_CreateTracer() -- Line: 4047
    -- upvalues: ReadVarint (copy), u8 (ref), buffer_create_ret2 (ref)
    local v1097 = ReadVarint();
    local table_create_ret5 = table.create(v1097);
    local v1098 = u8;
    u8 = u8 + v1097 * 19;

    for i = 1, v1097 do
        local v1099 = {
            StartPosition = false,
            EndPosition = false,
            Identifier = false
        };
        local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1098 + 0);
        local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1098 + 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1098 + 8);
        v1099.StartPosition = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

        if v1099.StartPosition.Magnitude <= (-1 / 0) or v1099.StartPosition.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.StartPosition" to be a finite number, got {v1099.StartPosition.Magnitude} instead.`));
        end;

        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1098 + 12);
        local v1100 = buffer_readu16_ret % 32768;
        local v1101;

        if v1100 == 31744 then
            v1101 = buffer_readu16_ret // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1100 == 64512 then
            v1101 = (0 / 0);
        elseif v1100 == 0 then
            v1101 = 0;
        else
            local v1102 = v1100 % 1024;
            local v1103 = v1100 // 1024;
            local v1104;

            if v1103 == 0 then
                v1104 = v1102 / 1024;
            else
                v1104 = v1102 / 2048 + 0.5;
            end;

            v1101 = math.ldexp(v1104, v1103 - 14);

            if buffer_readu16_ret // 32768 == 1 then
                v1101 = -v1101;
            end;
        end;

        local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v1098 + 14);
        local v1105 = buffer_readu16_ret2 % 32768;
        local v1106;

        if v1105 == 31744 then
            v1106 = buffer_readu16_ret2 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1105 == 64512 then
            v1106 = (0 / 0);
        elseif v1105 == 0 then
            v1106 = 0;
        else
            local v1107 = v1105 % 1024;
            local v1108 = v1105 // 1024;
            local v1109;

            if v1108 == 0 then
                v1109 = v1107 / 1024;
            else
                v1109 = v1107 / 2048 + 0.5;
            end;

            v1106 = math.ldexp(v1109, v1108 - 14);

            if buffer_readu16_ret2 // 32768 == 1 then
                v1106 = -v1106;
            end;
        end;

        local buffer_readu16_ret3 = buffer.readu16(buffer_create_ret2, v1098 + 16);
        local v1110 = buffer_readu16_ret3 % 32768;
        local v1111;

        if v1110 == 31744 then
            v1111 = buffer_readu16_ret3 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1110 == 64512 then
            v1111 = (0 / 0);
        elseif v1110 == 0 then
            v1111 = 0;
        else
            local v1112 = v1110 % 1024;
            local v1113 = v1110 // 1024;
            local v1114;

            if v1113 == 0 then
                v1114 = v1112 / 1024;
            else
                v1114 = v1112 / 2048 + 0.5;
            end;

            v1111 = math.ldexp(v1114, v1113 - 14);

            if buffer_readu16_ret3 // 32768 == 1 then
                v1111 = -v1111;
            end;
        end;

        v1099.EndPosition = vector.create(v1101, v1106, v1111);

        if v1099.EndPosition.Magnitude <= (-1 / 0) or v1099.EndPosition.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.EndPosition" to be a finite number, got {v1099.EndPosition.Magnitude} instead.`));
        end;

        v1099.Identifier = buffer.readu8(buffer_create_ret2, v1098 + 18);
        table_create_ret5[i] = v1099;
        v1098 = v1098 + 19;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.Particles_ReadEVENT_CreateRagdoll() -- Line: 4142
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1115 = u8;
    u8 = u8 + 30;
    local v1116 = {
        Identifier = false,
        Position = false,
        LookVector = false,
        Yaw = false,
        Agent = false,
        Identifier = buffer.readu8(buffer_create_ret2, v1115 + 0)
    };
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1115 + 1);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1115 + 5);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1115 + 9);
    v1116.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v1116.Position.Magnitude <= (-1 / 0) or v1116.Position.Magnitude >= (1 / 0) then
        error((`Expected "Value.Position" to be a finite number, got {v1116.Position.Magnitude} instead.`));
    end;

    local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1115 + 13);
    local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1115 + 17);
    local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1115 + 21);
    v1116.LookVector = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

    if v1116.LookVector.Magnitude <= (-1 / 0) or v1116.LookVector.Magnitude >= (1 / 0) then
        error((`Expected "Value.LookVector" to be a finite number, got {v1116.LookVector.Magnitude} instead.`));
    end;

    v1116.Yaw = buffer.readf32(buffer_create_ret2, v1115 + 25);

    if v1116.Yaw <= (-1 / 0) or v1116.Yaw >= (1 / 0) then
        error((`Expected "Value.Yaw" to be a finite number, got {v1116.Yaw} instead.`));
    end;

    v1116.Agent = buffer.readu8(buffer_create_ret2, v1115 + 29);

    return v1116;
end;

function u1.Spectate_WriteEVENT_SpectatePosition(p1117: number, p1118: table?) -- Line: 4163
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1119 = u20;

        for i = #v1119, u19 + 1, -1 do
            v1119[i] = nil;
            local _ = i;
        end;

        local v1120 = u21;
        u21 = nil;

        if u6 == v1119 then
            if v1120 then
                Load(v1120);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1118;
    local v1121 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v1121 + 0, 109);

    if typeof(p1117) ~= "number" then
        error((`Expected Value to be of type number, got {type(p1117)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v1121 + 1, p1117);
    u17 = false;
    u21 = nil;
end;

function u1.Spectate_ReadEVENT_SpectateIdentifier() -- Line: 4176
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1122 = u8;
    u8 = u8 + 9;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1122 + 0);
    local buffer_readf64_ret = buffer.readf64(buffer_create_ret2, v1122 + 1);

    if buffer_readf64_ret <= (-1 / 0) or buffer_readf64_ret >= (1 / 0) then
        error((`Expected "Value2" to be a finite number, got {buffer_readf64_ret} instead.`));
    end;

    return buffer_readu8_ret, buffer_readf64_ret;
end;

function u1.Spectate_ReadEVENT_SpectateData() -- Line: 4185
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1123 = u8;
    u8 = u8 + 5;
    local v1124 = {
        CurrentServerTick = false,
        LastServerTick = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1123 + 0);
    v1124.CurrentServerTick = buffer.readu16(buffer_create_ret2, v1123 + 1);
    v1124.LastServerTick = buffer.readu16(buffer_create_ret2, v1123 + 3);

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v1125 = ReadVarint();
        v1124.State = buffer.create(v1125);
        local v1126 = u8;
        u8 = u8 + v1125;
        buffer.copy(v1124.State, 0, buffer_create_ret2, v1126, v1125);
    end;

    if bit32.btest(buffer_readu8_ret, 2) == true then
        local v1127 = u8;
        u8 = u8 + 6;
        local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1127 + 0);
        local v1128 = buffer_readu16_ret % 32768;
        local v1129;

        if v1128 == 31744 then
            v1129 = buffer_readu16_ret // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1128 == 64512 then
            v1129 = (0 / 0);
        elseif v1128 == 0 then
            v1129 = 0;
        else
            local v1130 = v1128 % 1024;
            local v1131 = v1128 // 1024;
            local v1132;

            if v1131 == 0 then
                v1132 = v1130 / 1024;
            else
                v1132 = v1130 / 2048 + 0.5;
            end;

            v1129 = math.ldexp(v1132, v1131 - 14);

            if buffer_readu16_ret // 32768 == 1 then
                v1129 = -v1129;
            end;
        end;

        local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v1127 + 2);
        local v1133 = buffer_readu16_ret2 % 32768;
        local v1134;

        if v1133 == 31744 then
            v1134 = buffer_readu16_ret2 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1133 == 64512 then
            v1134 = (0 / 0);
        elseif v1133 == 0 then
            v1134 = 0;
        else
            local v1135 = v1133 % 1024;
            local v1136 = v1133 // 1024;
            local v1137;

            if v1136 == 0 then
                v1137 = v1135 / 1024;
            else
                v1137 = v1135 / 2048 + 0.5;
            end;

            v1134 = math.ldexp(v1137, v1136 - 14);

            if buffer_readu16_ret2 // 32768 == 1 then
                v1134 = -v1134;
            end;
        end;

        local buffer_readu16_ret3 = buffer.readu16(buffer_create_ret2, v1127 + 4);
        local v1138 = buffer_readu16_ret3 % 32768;
        local v1139;

        if v1138 == 31744 then
            v1139 = buffer_readu16_ret3 // 32768 == 1 and (-1 / 0) or (1 / 0);
        elseif v1138 == 64512 then
            v1139 = (0 / 0);
        elseif v1138 == 0 then
            v1139 = 0;
        else
            local v1140 = v1138 % 1024;
            local v1141 = v1138 // 1024;
            local v1142;

            if v1141 == 0 then
                v1142 = v1140 / 1024;
            else
                v1142 = v1140 / 2048 + 0.5;
            end;

            v1139 = math.ldexp(v1142, v1141 - 14);

            if buffer_readu16_ret3 // 32768 == 1 then
                v1139 = -v1139;
            end;
        end;

        v1124.EndPosition = vector.create(v1129, v1134, v1139);

        if v1124.EndPosition.Magnitude <= (-1 / 0) or v1124.EndPosition.Magnitude >= (1 / 0) then
            error((`Expected "Value.EndPosition" to be a finite number, got {v1124.EndPosition.Magnitude} instead.`));
        end;
    end;

    return v1124;
end;

function u1.Spectate_WriteEVENT_AckSpectate(p1143: number, p1144: table?) -- Line: 4281
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1145 = u20;

        for i = #v1145, u19 + 1, -1 do
            v1145[i] = nil;
            local _ = i;
        end;

        local v1146 = u21;
        u21 = nil;

        if u6 == v1145 then
            if v1146 then
                Load(v1146);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1144;
    local v1147 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v1147 + 0, 14);

    if typeof(p1143) ~= "number" then
        error((`Expected Value to be of type number, got {type(p1143)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v1147 + 1, p1143);
    u17 = false;
    u21 = nil;
end;

function u1.Spectate_WriteEVENT_SpectateTarget(p1148: number, p1149: table?) -- Line: 4294
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1150 = u20;

        for i = #v1150, u19 + 1, -1 do
            v1150[i] = nil;
            local _ = i;
        end;

        local v1151 = u21;
        u21 = nil;

        if u6 == v1150 then
            if v1151 then
                Load(v1151);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1149;
    local v1152 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v1152 + 0, 111);

    if typeof(p1148) ~= "number" then
        error((`Expected Value to be of type number, got {type(p1148)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v1152 + 1, p1148);
    u17 = false;
    u21 = nil;
end;

function u1.Debug_ReadEVENT_ShotMarker() -- Line: 4307
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v1153 = u8;
    u8 = u8 + 12;
    local v1154 = {
        Kind = false,
        Position = false
    };
    local v1155 = ReadVarint();
    local v1156 = u8;
    u8 = u8 + v1155;
    v1154.Kind = buffer.readstring(buffer_create_ret2, v1156, v1155);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1153 + 0);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1153 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1153 + 8);
    v1154.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v1154.Position.Magnitude <= (-1 / 0) or v1154.Position.Magnitude >= (1 / 0) then
        error((`Expected "Value.Position" to be a finite number, got {v1154.Position.Magnitude} instead.`));
    end;

    return v1154;
end;

function u1.Debug_ReadEVENT_ServerShot() -- Line: 4321
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1157 = u8;
    u8 = u8 + 12;
    local v1158 = {
        Hit = false,
        Boxes = false
    };
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1157 + 0);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1157 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1157 + 8);
    v1158.Hit = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if v1158.Hit.Magnitude <= (-1 / 0) or v1158.Hit.Magnitude >= (1 / 0) then
        error((`Expected "Value.Hit" to be a finite number, got {v1158.Hit.Magnitude} instead.`));
    end;

    local v1159 = ReadVarint();
    v1158.Boxes = table.create(v1159);
    local v1160 = u8;
    u8 = u8 + v1159 * 37;

    for i = 1, v1159 do
        local v1161 = {
            CFrame = false,
            Size = false,
            Hit = false
        };
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1160 + 0);
        local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1160 + 1);
        local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1160 + 5);
        local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1160 + 9);
        local vector_create_ret = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
        local buffer_readf32_ret7 = buffer.readf32(buffer_create_ret2, v1160 + 13);
        local buffer_readf32_ret8 = buffer.readf32(buffer_create_ret2, v1160 + 17);
        local buffer_readf32_ret9 = buffer.readf32(buffer_create_ret2, v1160 + 21);
        v1161.CFrame = CFrame.new(vector_create_ret) * CFrame.fromOrientation(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);

        if v1161.CFrame.Position.Magnitude <= (-1 / 0) or v1161.CFrame.Position.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.CFrame" to be a finite number, got {v1161.CFrame.Position.Magnitude} instead.`));
        end;

        if v1161.CFrame.LookVector.Magnitude <= (-1 / 0) or v1161.CFrame.LookVector.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.CFrame" to be a finite number, got {v1161.CFrame.LookVector.Magnitude} instead.`));
        end;

        local buffer_readf32_ret10 = buffer.readf32(buffer_create_ret2, v1160 + 25);
        local buffer_readf32_ret11 = buffer.readf32(buffer_create_ret2, v1160 + 29);
        local buffer_readf32_ret12 = buffer.readf32(buffer_create_ret2, v1160 + 33);
        v1161.Size = vector.create(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);

        if v1161.Size.Magnitude <= (-1 / 0) or v1161.Size.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.Size" to be a finite number, got {v1161.Size.Magnitude} instead.`));
        end;

        v1161.Hit = bit32.btest(buffer_readu8_ret, 1);
        v1158.Boxes[i] = v1161;
        v1160 = v1160 + 37;
        local _ = i;
    end;

    return v1158;
end;

function u1.Anticheat_WriteEVENT_Tattle(p1162: table, p1163: table?) -- Line: 4361
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1164 = u20;

        for i = #v1164, u19 + 1, -1 do
            v1164[i] = nil;
            local _ = i;
        end;

        local v1165 = u21;
        u21 = nil;

        if u6 == v1164 then
            if v1165 then
                Load(v1165);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1163;
    local v1166 = Allocate(9);
    buffer.writeu8(buffer_create_ret, v1166 + 0, 114);

    if typeof(p1162.Mask) ~= "number" then
        error((`Expected Value.Mask to be of type number, got {type(p1162.Mask)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v1166 + 1, p1162.Mask);

    if typeof(p1162.Shots) ~= "number" then
        error((`Expected Value.Shots to be of type number, got {type(p1162.Shots)} instead.`));
    end;

    buffer.writeu16(buffer_create_ret, v1166 + 3, p1162.Shots);

    if typeof(p1162.Echo) ~= "number" then
        error((`Expected Value.Echo to be of type number, got {type(p1162.Echo)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v1166 + 5, p1162.Echo);
    u17 = false;
    u21 = nil;
end;

function u1.ReadEVENT_GenerateCollision() -- Line: 4382
    -- upvalues: ReadVarint (copy), u8 (ref), buffer_create_ret2 (ref)
    local v1167 = ReadVarint();
    local table_create_ret5 = table.create(v1167);
    local v1168 = u8;
    u8 = u8 + v1167 * 26;

    for i = 1, v1167 do
        local v1169 = {
            Position = false,
            Size = false,
            Shape = false
        };
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1168 + 0);
        local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1168 + 1);
        local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1168 + 5);
        local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1168 + 9);
        v1169.Position = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

        if v1169.Position.Magnitude <= (-1 / 0) or v1169.Position.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.Position" to be a finite number, got {v1169.Position.Magnitude} instead.`));
        end;

        if bit32.btest(buffer_readu8_ret, 1) == true then
            local v1170 = u8;
            u8 = u8 + 12;
            local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1170 + 0);
            local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1170 + 4);
            local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1170 + 8);
            v1169.Orientation = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

            if v1169.Orientation.Magnitude <= (-1 / 0) or v1169.Orientation.Magnitude >= (1 / 0) then
                error((`Expected "Item_1.Orientation" to be a finite number, got {v1169.Orientation.Magnitude} instead.`));
            end;
        end;

        local buffer_readf32_ret4 = buffer.readf32(buffer_create_ret2, v1168 + 13);
        local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret2, v1168 + 17);
        local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret2, v1168 + 21);
        v1169.Size = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);

        if v1169.Size.Magnitude <= (-1 / 0) or v1169.Size.Magnitude >= (1 / 0) then
            error((`Expected "Item_1.Size" to be a finite number, got {v1169.Size.Magnitude} instead.`));
        end;

        v1169.Shape = buffer.readu8(buffer_create_ret2, v1168 + 25);
        table_create_ret5[i] = v1169;
        v1168 = v1168 + 26;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.ReadEVENT_ConfigChanged() -- Line: 4418
    -- upvalues: ReadVarint (copy), buffer_create_ret2 (ref), u8 (ref), u10 (ref), u9 (ref)
    local v1171 = ReadVarint();
    local table_create_ret5 = table.create(v1171);

    for i = 1, v1171 do
        local v1172 = {
            Category = false,
            Key = false,
            Value = false
        };
        local v1173 = ReadVarint();
        local v1174 = u8;
        u8 = u8 + v1173;
        v1172.Category = buffer.readstring(buffer_create_ret2, v1174, v1173);
        local v1175 = ReadVarint();
        local v1176 = u8;
        u8 = u8 + v1175;
        v1172.Key = buffer.readstring(buffer_create_ret2, v1176, v1175);
        u10 = u10 + 1;
        v1172.Value = u9[u10];
        table_create_ret5[i] = v1172;
        local _ = i;
    end;

    return table_create_ret5;
end;

function u1.WriteEVENT_Console(p1177: any, p1178: table?) -- Line: 4436
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref), u11 (copy)
    if u17 then
        u17 = false;
        local v1179 = u20;

        for i = #v1179, u19 + 1, -1 do
            v1179[i] = nil;
            local _ = i;
        end;

        local v1180 = u21;
        u21 = nil;

        if u6 == v1179 then
            if v1180 then
                Load(v1180);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1178;
    local v1181 = Allocate(1) + 0;
    buffer.writeu8(buffer_create_ret, v1181, 117);

    if p1177 == nil then
        p1177 = u11;
    end;

    table.insert(u6, p1177);
    u17 = false;
    u21 = nil;
end;

function u1.ReadEVENT_ConsoleServer() -- Line: 4446
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.ReadEVENT_ServerTick() -- Line: 4452
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1182 = u8;
    u8 = u8 + 4;

    return buffer.readu32(buffer_create_ret2, v1182 + 0);
end;

function u1.WriteEVENT_ClientPing(p1183: number, p1184: table?) -- Line: 4459
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1185 = u20;

        for i = #v1185, u19 + 1, -1 do
            v1185[i] = nil;
            local _ = i;
        end;

        local v1186 = u21;
        u21 = nil;

        if u6 == v1185 then
            if v1186 then
                Load(v1186);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1184;
    local v1187 = Allocate(5);
    buffer.writeu8(buffer_create_ret, v1187 + 0, 16);

    if typeof(p1183) ~= "number" then
        error((`Expected Value to be of type number, got {type(p1183)} instead.`));
    end;

    buffer.writeu32(buffer_create_ret, v1187 + 1, p1183);
    u17 = false;
    u21 = nil;
end;

function u1.ReadEVENT_ServerPing() -- Line: 4472
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1188 = u8;
    u8 = u8 + 1;
    local v1189 = {};

    for i = 1, buffer.readu8(buffer_create_ret2, v1188 + 0) do
        local v1190 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1190);
        local v1191 = u8;
        u8 = u8 + 2;
        v1189[buffer_readu8_ret] = buffer.readu16(buffer_create_ret2, v1191);
        local _ = i;
    end;

    return v1189;
end;

function u1.ReadEVENT_OnMapAdded() -- Line: 4487
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.ReadEVENT_OnMapRemoving() -- Line: 4493
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.ReadEVENT_RoundReset() -- Line: 4499
    -- upvalues: u10 (ref), u9 (ref)
    u10 = u10 + 1;

    return u9[u10];
end;

function u1.ReadEVENT_RadarLeak() -- Line: 4505
    -- upvalues: u8 (ref), ReadVarint (copy), buffer_create_ret2 (ref)
    local v1192 = u8;
    u8 = u8 + 1;
    local v1193 = ReadVarint();
    local table_create_ret5 = table.create(v1193);
    local v1194 = u8;
    u8 = u8 + v1193 * 1;

    for i = 1, v1193 do
        table_create_ret5[i] = buffer.readu8(buffer_create_ret2, v1194 + 0);
        v1194 = v1194 + 1;
        local _ = i;
    end;

    local v1195 = ReadVarint();
    local table_create_ret6 = table.create(v1195);
    local v1196 = u8;
    u8 = u8 + v1195 * 12;

    for i = 1, v1195 do
        local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1196 + 0);
        local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1196 + 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1196 + 8);
        local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

        if vector_create_ret.Magnitude <= (-1 / 0) or vector_create_ret.Magnitude >= (1 / 0) then
            error((`Expected "Item_1" to be a finite number, got {vector_create_ret.Magnitude} instead.`));
        end;

        table_create_ret6[i] = vector_create_ret;
        v1196 = v1196 + 12;
        local _ = i;
    end;

    return table_create_ret5, table_create_ret6, buffer.readu8(buffer_create_ret2, v1192 + 0) == 1;
end;

function u1.ReadEVENT_PlaySoundOnPosition() -- Line: 4538
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1197 = u8;
    u8 = u8 + 8;
    local v1198 = {
        Category = false,
        Sound = false,
        Category = buffer.readu8(buffer_create_ret2, v1197 + 0),
        Sound = buffer.readu8(buffer_create_ret2, v1197 + 1)
    };
    local buffer_readu16_ret = buffer.readu16(buffer_create_ret2, v1197 + 2);
    local v1199 = buffer_readu16_ret % 32768;
    local v1200;

    if v1199 == 31744 then
        v1200 = buffer_readu16_ret // 32768 == 1 and (-1 / 0) or (1 / 0);
    elseif v1199 == 64512 then
        v1200 = (0 / 0);
    elseif v1199 == 0 then
        v1200 = 0;
    else
        local v1201 = v1199 % 1024;
        local v1202 = v1199 // 1024;
        local v1203;

        if v1202 == 0 then
            v1203 = v1201 / 1024;
        else
            v1203 = v1201 / 2048 + 0.5;
        end;

        v1200 = math.ldexp(v1203, v1202 - 14);

        if buffer_readu16_ret // 32768 == 1 then
            v1200 = -v1200;
        end;
    end;

    local buffer_readu16_ret2 = buffer.readu16(buffer_create_ret2, v1197 + 4);
    local v1204 = buffer_readu16_ret2 % 32768;
    local v1205;

    if v1204 == 31744 then
        v1205 = buffer_readu16_ret2 // 32768 == 1 and (-1 / 0) or (1 / 0);
    elseif v1204 == 64512 then
        v1205 = (0 / 0);
    elseif v1204 == 0 then
        v1205 = 0;
    else
        local v1206 = v1204 % 1024;
        local v1207 = v1204 // 1024;
        local v1208;

        if v1207 == 0 then
            v1208 = v1206 / 1024;
        else
            v1208 = v1206 / 2048 + 0.5;
        end;

        v1205 = math.ldexp(v1208, v1207 - 14);

        if buffer_readu16_ret2 // 32768 == 1 then
            v1205 = -v1205;
        end;
    end;

    local buffer_readu16_ret3 = buffer.readu16(buffer_create_ret2, v1197 + 6);
    local v1209 = buffer_readu16_ret3 % 32768;
    local v1210;

    if v1209 == 31744 then
        v1210 = buffer_readu16_ret3 // 32768 == 1 and (-1 / 0) or (1 / 0);
    elseif v1209 == 64512 then
        v1210 = (0 / 0);
    elseif v1209 == 0 then
        v1210 = 0;
    else
        local v1211 = v1209 % 1024;
        local v1212 = v1209 // 1024;
        local v1213;

        if v1212 == 0 then
            v1213 = v1211 / 1024;
        else
            v1213 = v1211 / 2048 + 0.5;
        end;

        v1210 = math.ldexp(v1213, v1212 - 14);

        if buffer_readu16_ret3 // 32768 == 1 then
            v1210 = -v1210;
        end;
    end;

    local vector_create_ret = vector.create(v1200, v1205, v1210);

    if vector_create_ret.Magnitude <= (-1 / 0) or vector_create_ret.Magnitude >= (1 / 0) then
        error((`Expected "Value2" to be a finite number, got {vector_create_ret.Magnitude} instead.`));
    end;

    return v1198, vector_create_ret;
end;

function u1.ReadEVENT_PlayFootstepSoundOnPosition() -- Line: 4624
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1214 = u8;
    u8 = u8 + 15;
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1214 + 0);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret2, v1214 + 1);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret2, v1214 + 5);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret2, v1214 + 9);
    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);

    if vector_create_ret.Magnitude <= (-1 / 0) or vector_create_ret.Magnitude >= (1 / 0) then
        error((`Expected "Value2" to be a finite number, got {vector_create_ret.Magnitude} instead.`));
    end;

    return buffer_readu8_ret, vector_create_ret, buffer.readu8(buffer_create_ret2, v1214 + 13), buffer.readu8(buffer_create_ret2, v1214 + 14);
end;

function u1.ReadEVENT_NetworkDebugStats() -- Line: 4638
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1215 = u8;
    u8 = u8 + 48;
    local v1216 = {
        LostCommandPercent = false,
        FakeCommandCount = false,
        Jitter = false,
        InputQueueDelayMs = false,
        ShotRewindMs = false,
        ShotRenderTime = false,
        ShotPingMs = false,
        ShotJitterMs = false,
        ShotHit = false,
        ShotTargetIdentifier = false,
        ShotHitbox = false,
        ShotAppliedDamage = false,
        ShotHealthBefore = false,
        ShotHealthAfter = false,
        ShotRejected = false,
        ShotRejectReason = false,
        ShotLethal = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1215 + 0);
    v1216.LostCommandPercent = buffer.readf32(buffer_create_ret2, v1215 + 1);

    if v1216.LostCommandPercent <= (-1 / 0) or v1216.LostCommandPercent >= (1 / 0) then
        error((`Expected "Value.LostCommandPercent" to be a finite number, got {v1216.LostCommandPercent} instead.`));
    end;

    v1216.FakeCommandCount = buffer.readu32(buffer_create_ret2, v1215 + 5);
    v1216.Jitter = buffer.readf32(buffer_create_ret2, v1215 + 9);

    if v1216.Jitter <= (-1 / 0) or v1216.Jitter >= (1 / 0) then
        error((`Expected "Value.Jitter" to be a finite number, got {v1216.Jitter} instead.`));
    end;

    v1216.InputQueueDelayMs = buffer.readf32(buffer_create_ret2, v1215 + 13);

    if v1216.InputQueueDelayMs <= (-1 / 0) or v1216.InputQueueDelayMs >= (1 / 0) then
        error((`Expected "Value.InputQueueDelayMs" to be a finite number, got {v1216.InputQueueDelayMs} instead.`));
    end;

    v1216.ShotRewindMs = buffer.readf32(buffer_create_ret2, v1215 + 17);

    if v1216.ShotRewindMs <= (-1 / 0) or v1216.ShotRewindMs >= (1 / 0) then
        error((`Expected "Value.ShotRewindMs" to be a finite number, got {v1216.ShotRewindMs} instead.`));
    end;

    v1216.ShotRenderTime = buffer.readf32(buffer_create_ret2, v1215 + 21);

    if v1216.ShotRenderTime <= (-1 / 0) or v1216.ShotRenderTime >= (1 / 0) then
        error((`Expected "Value.ShotRenderTime" to be a finite number, got {v1216.ShotRenderTime} instead.`));
    end;

    v1216.ShotPingMs = buffer.readf32(buffer_create_ret2, v1215 + 25);

    if v1216.ShotPingMs <= (-1 / 0) or v1216.ShotPingMs >= (1 / 0) then
        error((`Expected "Value.ShotPingMs" to be a finite number, got {v1216.ShotPingMs} instead.`));
    end;

    v1216.ShotJitterMs = buffer.readf32(buffer_create_ret2, v1215 + 29);

    if v1216.ShotJitterMs <= (-1 / 0) or v1216.ShotJitterMs >= (1 / 0) then
        error((`Expected "Value.ShotJitterMs" to be a finite number, got {v1216.ShotJitterMs} instead.`));
    end;

    v1216.ShotHit = bit32.btest(buffer_readu8_ret, 1);
    v1216.ShotTargetIdentifier = buffer.readu8(buffer_create_ret2, v1215 + 33);
    v1216.ShotHitbox = buffer.readu8(buffer_create_ret2, v1215 + 34);
    v1216.ShotAppliedDamage = buffer.readf32(buffer_create_ret2, v1215 + 35);

    if v1216.ShotAppliedDamage <= (-1 / 0) or v1216.ShotAppliedDamage >= (1 / 0) then
        error((`Expected "Value.ShotAppliedDamage" to be a finite number, got {v1216.ShotAppliedDamage} instead.`));
    end;

    v1216.ShotHealthBefore = buffer.readf32(buffer_create_ret2, v1215 + 39);

    if v1216.ShotHealthBefore <= (-1 / 0) or v1216.ShotHealthBefore >= (1 / 0) then
        error((`Expected "Value.ShotHealthBefore" to be a finite number, got {v1216.ShotHealthBefore} instead.`));
    end;

    v1216.ShotHealthAfter = buffer.readf32(buffer_create_ret2, v1215 + 43);

    if v1216.ShotHealthAfter <= (-1 / 0) or v1216.ShotHealthAfter >= (1 / 0) then
        error((`Expected "Value.ShotHealthAfter" to be a finite number, got {v1216.ShotHealthAfter} instead.`));
    end;

    v1216.ShotRejected = bit32.btest(buffer_readu8_ret, 2);
    v1216.ShotRejectReason = buffer.readu8(buffer_create_ret2, v1215 + 47);
    v1216.ShotLethal = bit32.btest(buffer_readu8_ret, 4);

    return v1216;
end;

function u1.ReadEVENT_ServerPerformanceStats() -- Line: 4673
    -- upvalues: u8 (ref), buffer_create_ret2 (ref)
    local v1217 = u8;
    u8 = u8 + 16;
    local v1218 = {
        ServerFrameTimeMs = false,
        ServerFrameStdDevMs = false,
        ServerTickVarMs = false,
        TickRate = false,
        ServerFrameTimeMs = buffer.readf32(buffer_create_ret2, v1217 + 0)
    };

    if v1218.ServerFrameTimeMs <= (-1 / 0) or v1218.ServerFrameTimeMs >= (1 / 0) then
        error((`Expected "Value.ServerFrameTimeMs" to be a finite number, got {v1218.ServerFrameTimeMs} instead.`));
    end;

    v1218.ServerFrameStdDevMs = buffer.readf32(buffer_create_ret2, v1217 + 4);

    if v1218.ServerFrameStdDevMs <= (-1 / 0) or v1218.ServerFrameStdDevMs >= (1 / 0) then
        error((`Expected "Value.ServerFrameStdDevMs" to be a finite number, got {v1218.ServerFrameStdDevMs} instead.`));
    end;

    v1218.ServerTickVarMs = buffer.readf32(buffer_create_ret2, v1217 + 8);

    if v1218.ServerTickVarMs <= (-1 / 0) or v1218.ServerTickVarMs >= (1 / 0) then
        error((`Expected "Value.ServerTickVarMs" to be a finite number, got {v1218.ServerTickVarMs} instead.`));
    end;

    v1218.TickRate = buffer.readf32(buffer_create_ret2, v1217 + 12);

    if v1218.TickRate <= (-1 / 0) or v1218.TickRate >= (1 / 0) then
        error((`Expected "Value.TickRate" to be a finite number, got {v1218.TickRate} instead.`));
    end;

    return v1218;
end;

function u1.WriteEVENT_NetworkDebugEnabled(p1219: boolean, p1220: table?) -- Line: 4688
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), Allocate (copy), buffer_create_ret (ref)
    if u17 then
        u17 = false;
        local v1221 = u20;

        for i = #v1221, u19 + 1, -1 do
            v1221[i] = nil;
            local _ = i;
        end;

        local v1222 = u21;
        u21 = nil;

        if u6 == v1221 then
            if v1222 then
                Load(v1222);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    u17 = true;
    u18 = u5;
    u19 = #u6;
    u20 = u6;
    u21 = p1220;
    local v1223 = Allocate(2);
    buffer.writeu8(buffer_create_ret, v1223 + 0, 122);

    if typeof(p1219) ~= "boolean" then
        error((`Expected Value to be of type boolean, got {type(p1219)} instead.`));
    end;

    buffer.writeu8(buffer_create_ret, v1223 + 1, p1219 and 1 or 0);
    u17 = false;
    u21 = nil;
end;

function u1.ReadEVENT_SimulationConstants() -- Line: 4701
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), ReadVarint (copy)
    local v1224 = u8;
    u8 = u8 + 1;
    local v1225 = {
        Constants = false
    };
    local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1224 + 0);
    local v1226 = ReadVarint();
    v1225.Constants = table.create(v1226);
    local v1227 = u8;
    u8 = u8 + v1226 * 8;

    for i = 1, v1226 do
        local v1228 = {
            Key = false,
            Value = false
        };
        local v1229 = ReadVarint();
        local v1230 = u8;
        u8 = u8 + v1229;
        v1228.Key = buffer.readstring(buffer_create_ret2, v1230, v1229);
        v1228.Value = buffer.readf64(buffer_create_ret2, v1227 + 0);

        if v1228.Value <= (-1 / 0) or v1228.Value >= (1 / 0) then
            error((`Expected "Item_1.Value" to be a finite number, got {v1228.Value} instead.`));
        end;

        v1225.Constants[i] = v1228;
        v1227 = v1227 + 8;
        local _ = i;
    end;

    if bit32.btest(buffer_readu8_ret, 1) == true then
        local v1231 = u8;
        u8 = u8 + 1;
        v1225.Noclip = buffer.readu8(buffer_create_ret2, v1231 + 0) == 1;
    end;

    return v1225;
end;

if not RunService:IsRunning() then
    local function v1232() -- Line: 4730
    end;

    return table.freeze({
        Player = {
            PlayerLoaded = {
                Fire = v1232
            },
            StartGameRunning = {
                On = v1232
            }
        },
        Character = {
            CharacterConstantBalls = {
                On = v1232
            },
            CharacterTemplateBalls = {
                On = v1232
            },
            CreateCharacter = {
                On = v1232
            },
            DestroyCharacter = {
                On = v1232
            },
            Command = {
                Fire = v1232
            },
            CommandIdle = {
                Fire = v1232
            },
            CommandArray = {
                Fire = v1232
            },
            HandleNewState = {
                On = v1232
            },
            SimulationProperty = {
                On = v1232
            }
        },
        Weapon = {
            CreateWeapon = {
                On = v1232
            },
            DestroyWeapon = {
                On = v1232
            },
            BuyWeapon = {
                Fire = v1232
            },
            PickUpWeapon = {
                Fire = v1232
            },
            RefundWeapon = {
                Fire = v1232
            },
            ForceEquip = {
                On = v1232
            },
            OnWeaponPickup = {
                On = v1232
            },
            WeaponReset = {
                On = v1232
            },
            Constant = {
                On = v1232
            },
            Template = {
                On = v1232
            }
        },
        Gui = {
            BuyRejected = {
                On = v1232
            },
            ViewmodelPreset = {
                Fire = v1232
            },
            WatchAdReward = {
                Fire = v1232
            },
            UseStarCode = {
                Fire = v1232
            },
            UsedStarCodeUpdate = {
                On = v1232
            },
            ApplyKillTrackColor = {
                Fire = v1232
            },
            KillTrackColorUpdate = {
                On = v1232
            },
            BuyFuserScroll = {
                Fire = v1232
            },
            FuserScrollsUpdate = {
                On = v1232
            },
            AnalyticsUpdate = {
                On = v1232
            },
            RequestMatch = {
                Fire = v1232
            },
            MatchData = {
                On = v1232
            },
            ApplyNameTag = {
                Fire = v1232
            },
            RemoveNameTag = {
                Fire = v1232
            },
            ApplyKillTrack = {
                Fire = v1232
            },
            KillTrackUpdate = {
                On = v1232
            },
            RemoveKillTrack = {
                Fire = v1232
            },
            RequestServerList = {
                Fire = v1232
            },
            ServerListResult = {
                On = v1232
            },
            RequestProfileBadges = {
                Fire = v1232
            },
            ProfileBadges = {
                On = v1232
            },
            MatchEndStats = {
                On = v1232
            },
            NewContainerMessage = {
                On = v1232
            },
            GlobalMessage = {
                On = v1232
            },
            NewMessage = {
                On = v1232
            },
            NewMessageTeam = {
                On = v1232
            },
            NewAwardMessage = {
                On = v1232
            },
            GiftGamepass = {
                Fire = v1232
            },
            LeftArm = {
                Fire = v1232
            },
            DamageIndicator = {
                On = v1232
            },
            BuyGamepass = {
                Fire = v1232
            },
            MenuNotification = {
                On = v1232
            },
            VotekickPlayer = {
                Fire = v1232
            },
            Votekick = {
                Fire = v1232
            },
            CopyViewmodel = {
                Fire = v1232
            },
            CopyCrosshair2 = {
                Fire = v1232
            },
            CopyViewmodel2 = {
                Fire = v1232
            },
            CopyCrosshair = {
                Fire = v1232
            },
            SelectTeam = {
                Fire = v1232
            },
            SendMessage = {
                Fire = v1232
            },
            VoteForMap = {
                Fire = v1232
            },
            Ping = {
                On = v1232
            },
            SendTeamMessage = {
                Fire = v1232
            },
            SelectMapPreset = {
                Fire = v1232
            },
            MobileControls = {
                Fire = v1232
            },
            ClaimBattlepassReward = {
                Fire = v1232
            },
            ClaimAllBattlepassRewards = {
                Fire = v1232
            },
            BuyBattlepass = {
                Fire = v1232
            },
            BuyBundle = {
                Fire = v1232
            },
            BuyBundleItem = {
                Fire = v1232
            },
            BuyBattlepassTiers = {
                Fire = v1232
            },
            ClaimChallengeReward = {
                Fire = v1232
            },
            StartChallenge = {
                Fire = v1232
            },
            AbandonChallenge = {
                Fire = v1232
            },
            TradeUp = {
                Fire = v1232
            },
            Upgrade = {
                Fire = v1232
            },
            UpgradeResult = {
                On = v1232
            },
            ApplySticker = {
                Fire = v1232
            },
            RemoveSticker = {
                Fire = v1232
            },
            ClaimCarePackageItems = {
                Fire = v1232
            },
            UsePromocode = {
                Fire = v1232
            },
            BuyDailyMarketItem = {
                Fire = v1232
            },
            RevealMarketItem = {
                Fire = v1232
            },
            ClaimAchievementReward = {
                Fire = v1232
            },
            ChangePlayerSetting = {
                Fire = v1232
            },
            ResetPlayerSettings = {
                Fire = v1232
            },
            ChangeLoadoutWeapon = {
                Fire = v1232
            },
            BuyStoreItem = {
                Fire = v1232
            },
            OpenContainer = {
                Fire = v1232
            },
            OpenContainerResult = {
                On = v1232
            },
            ClaimPlaytimeReward = {
                Fire = v1232
            },
            KillfeedUpdate = {
                On = v1232
            },
            DiedUpdate = {
                On = v1232
            },
            MVPUpdate = {
                On = v1232
            },
            InventoryUpdate = {
                On = v1232
            },
            InventoryAdd = {
                On = v1232
            },
            InventoryRemove = {
                On = v1232
            },
            InventoryEquip = {
                On = v1232
            },
            PlayerStatsUpdate = {
                On = v1232
            },
            PlaytimeUpdate = {
                On = v1232
            },
            PlaytimeRewardsCollectedUpdate = {
                On = v1232
            },
            UsedCodesUpdate = {
                On = v1232
            },
            CollectedAchievementsUpdate = {
                On = v1232
            },
            GamepassesUpdate = {
                On = v1232
            },
            ChallengesUpdate = {
                On = v1232
            },
            BattlepassUpdate = {
                On = v1232
            },
            CreditsUpdate = {
                On = v1232
            }
        },
        Entity = {
            RequestFullUpdate = {
                Fire = v1232
            },
            AckSnapshot = {
                Fire = v1232
            },
            EntityVisibility = {
                On = v1232
            },
            CreateEntity = {
                On = v1232
            },
            DestroyEntity = {
                On = v1232
            },
            OnPlayerConnected = {
                On = v1232
            },
            EntitySnapshot = {
                On = v1232
            },
            CharacterCurrentWeapon = {
                On = v1232
            },
            CharacterWeaponInventorySlot = {
                On = v1232
            },
            CharacterCurrentWeaponInventoryData = {
                On = v1232
            },
            CharacterDeath = {
                On = v1232
            }
        },
        Particles = {
            CreateBulletHole = {
                On = v1232
            },
            CreateTracer = {
                On = v1232
            },
            CreateRagdoll = {
                On = v1232
            }
        },
        Spectate = {
            SpectatePosition = {
                Fire = v1232
            },
            SpectateIdentifier = {
                On = v1232
            },
            SpectateData = {
                On = v1232
            },
            AckSpectate = {
                Fire = v1232
            },
            SpectateTarget = {
                Fire = v1232
            }
        },
        Debug = {
            ShotMarker = {
                On = v1232
            },
            ServerShot = {
                On = v1232
            }
        },
        Anticheat = {
            Tattle = {
                Fire = v1232
            }
        },
        GenerateCollision = {
            On = v1232
        },
        ConfigChanged = {
            On = v1232
        },
        Console = {
            Fire = v1232
        },
        ConsoleServer = {
            On = v1232
        },
        ServerTick = {
            On = v1232
        },
        ClientPing = {
            Fire = v1232
        },
        ServerPing = {
            On = v1232
        },
        OnMapAdded = {
            On = v1232
        },
        OnMapRemoving = {
            On = v1232
        },
        RoundReset = {
            On = v1232
        },
        RadarLeak = {
            On = v1232
        },
        PlaySoundOnPosition = {
            On = v1232
        },
        PlayFootstepSoundOnPosition = {
            On = v1232
        },
        NetworkDebugStats = {
            On = v1232
        },
        ServerPerformanceStats = {
            On = v1232
        },
        NetworkDebugEnabled = {
            Fire = v1232
        },
        SimulationConstants = {
            On = v1232
        }
    });
end;

if not RunService:IsClient() then
    error("Client network module can only be required from the client.");
end;

local BLINK_RELIABLE_REMOTE = ReplicatedStorage:WaitForChild("BLINK_RELIABLE_REMOTE");
local BLINK_UNRELIABLE_REMOTE = ReplicatedStorage:WaitForChild("BLINK_UNRELIABLE_REMOTE");
local BLINK_RELIABLE_FRAGMENT_REMOTE = ReplicatedStorage:WaitForChild("BLINK_RELIABLE_FRAGMENT_REMOTE");
local BLINK_UNRELIABLE_FRAGMENT_REMOTE = ReplicatedStorage:WaitForChild("BLINK_UNRELIABLE_FRAGMENT_REMOTE");
local u1233 = {};
local u1234 = {};
local u1235 = {
    Window = 0,
    Warned = 0,
    Counts = {}
};

local function CheckSendRateLimit(p1236: string, p1237: number) -- Line: 5211
    -- upvalues: u1235 (copy)
    local v1238 = u1235;
    local v1239 = os.clock() // 1;

    if v1238.Window ~= v1239 then
        v1238.Window = v1239;
        table.clear(v1238.Counts);
    end;

    local v1240 = (v1238.Counts[p1236] or 0) + 1;
    v1238.Counts[p1236] = v1240;

    return v1240 <= p1237;
end;

local function FireFragment(p1241: buffer, p1242: table?) -- Line: 5215
    -- upvalues: BLINK_RELIABLE_FRAGMENT_REMOTE (copy)
    BLINK_RELIABLE_FRAGMENT_REMOTE:FireServer(p1241, p1242);
end;

local function FireUnreliableFragment(p1243: buffer, p1244: table?) -- Line: 5219
    -- upvalues: BLINK_UNRELIABLE_FRAGMENT_REMOTE (copy)
    BLINK_UNRELIABLE_FRAGMENT_REMOTE:FireServer(p1243, p1244);
end;

local function FireUnreliable(p1245: buffer, p1246: table) -- Line: 5225
    -- upvalues: SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
    if buffer.len(p1245) > 800 then
        SendFragments(p1245, p1246, 800, FireUnreliableFragment);

        return;
    end;

    if #p1246 <= 0 then
        p1246 = nil;
    end;

    BLINK_UNRELIABLE_REMOTE:FireServer(p1245, p1246);
end;

local u1247 = nil;
local u1248 = nil;

local function SendUnreliableBatch(p1249: table) -- Line: 5236
    -- upvalues: BLINK_UNRELIABLE_REMOTE (copy), u49 (ref)
    local v1250 = u49;
    local Buffer = p1249.Buffer;
    local Cursor = p1249.Cursor;

    if not v1250 or buffer.len(v1250) ~= Cursor then
        v1250 = buffer.create(Cursor);
    end;

    buffer.copy(v1250, 0, Buffer, 0, Cursor);
    u49 = v1250;
    local Instances = p1249.Instances;

    if #Instances <= 0 then
        Instances = nil;
    end;

    BLINK_UNRELIABLE_REMOTE:FireServer(u49, Instances);
    p1249.Cursor = 0;
    table.clear(p1249.Instances);
end;

local function QueueUnreliable() -- Line: 5243
    -- upvalues: u5 (ref), u1248 (ref), CreateUnreliableBatch (copy), u6 (ref), BLINK_UNRELIABLE_REMOTE (copy), u49 (ref), buffer_create_ret (ref)
    if u5 > 800 then
        return false;
    end;

    local v1251 = u1248;

    if not v1251 then
        v1251 = CreateUnreliableBatch();
        u1248 = v1251;
    end;

    if v1251.Cursor + u5 > 800 and true or #v1251.Instances + #u6 > 4096 then
        local v1252 = u49;
        local Buffer = v1251.Buffer;
        local Cursor = v1251.Cursor;

        if not v1252 or buffer.len(v1252) ~= Cursor then
            v1252 = buffer.create(Cursor);
        end;

        buffer.copy(v1252, 0, Buffer, 0, Cursor);
        u49 = v1252;
        local Instances = v1251.Instances;

        if #Instances <= 0 then
            Instances = nil;
        end;

        BLINK_UNRELIABLE_REMOTE:FireServer(u49, Instances);
        v1251.Cursor = 0;
        table.clear(v1251.Instances);
    end;

    buffer.copy(v1251.Buffer, v1251.Cursor, buffer_create_ret, 0, u5);
    v1251.Cursor = v1251.Cursor + u5;
    table.move(u6, 1, #u6, #v1251.Instances + 1, v1251.Instances);

    return true;
end;

local function StepReplication() -- Line: 5262
    -- upvalues: u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), ClearStaleFragments (copy), u1233 (copy), u1234 (copy), u1248 (ref), BLINK_UNRELIABLE_REMOTE (copy), u49 (ref), u7 (ref), u1247 (ref), buffer_create_ret (ref), SendFragments (copy), FireFragment (copy), BLINK_RELIABLE_REMOTE (copy)
    if u17 then
        u17 = false;
        local v1253 = u20;

        for i = #v1253, u19 + 1, -1 do
            v1253[i] = nil;
            local _ = i;
        end;

        local v1254 = u21;
        u21 = nil;

        if u6 == v1253 then
            if v1254 then
                Load(v1254);
            else
                u5 = u18;
                u4 = u18;
            end;
        end;
    end;

    ClearStaleFragments(u1233);
    ClearStaleFragments(u1234);

    if u1248 and u1248.Cursor > 0 then
        local v1255 = u1248;
        local v1256 = u49;
        local Buffer = v1255.Buffer;
        local Cursor = v1255.Cursor;

        if not v1256 or buffer.len(v1256) ~= Cursor then
            v1256 = buffer.create(Cursor);
        end;

        buffer.copy(v1256, 0, Buffer, 0, Cursor);
        u49 = v1256;
        local Instances = v1255.Instances;

        if #Instances <= 0 then
            Instances = nil;
        end;

        BLINK_UNRELIABLE_REMOTE:FireServer(u49, Instances);
        v1255.Cursor = 0;
        table.clear(v1255.Instances);
    end;

    if u5 <= 0 then
        return;
    end;

    local v1257 = u7;
    local v1258 = u5;

    if #v1257 ~= 0 then
        warn((`[Blink]: Flushed {v1258} bytes this frame across {#v1257} packet(s): {table.concat(v1257, ", ")}`));
        table.clear(v1257);
    end;

    local v1259 = u1247;
    local v1260 = u5;

    if not v1259 or buffer.len(v1259) ~= v1260 then
        v1259 = buffer.create(v1260);
    end;

    buffer.copy(v1259, 0, buffer_create_ret, 0, v1260);
    u1247 = v1259;
    local v1261 = u1247;

    if u5 > 750 then
        SendFragments(v1261, u6, 750, FireFragment);
    else
        local v1262 = u6;

        if #v1262 <= 0 then
            v1262 = nil;
        end;

        BLINK_RELIABLE_REMOTE:FireServer(v1261, v1262);
    end;

    u5 = 0;
    u4 = 0;
    table.clear(u6);
end;

RunService.Heartbeat:Connect(StepReplication);

function ProcessReliable(p1263: buffer, p1264: table?)
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), u9 (ref), table_freeze_ret (copy), u10 (ref), u141 (ref), u140 (ref), u1 (copy), table_create_ret (copy), table_create_ret3 (copy)
    local v1265;

    if typeof(p1263) == "buffer" then
        if p1264 == nil then
            v1265 = true;
        elseif typeof(p1264) == "table" then
            v1265 = #p1264 <= 4096;
        else
            v1265 = false;
        end;
    else
        v1265 = false;
    end;

    if not v1265 then
        return;
    end;

    if buffer.len(p1263) > 4294967296 then
        warn((`[Blink]: Dropped an incoming packet of {buffer.len(p1263)} bytes, the maximum is {4294967296} bytes.`));

        return;
    end;

    u8 = 0;
    buffer_create_ret2 = p1263;
    u9 = p1264 or table_freeze_ret;
    u10 = 0;
    local buffer_len_ret = buffer.len(buffer_create_ret2);

    if u141 and coroutine.status(u141) == "suspended" then
        warn((`[Blink]: Yielded in a Sync call. Event "{u140}" uses a Sync call, consider using an Async call instead.`));
        coroutine.close(u141);
    end;

    u141 = coroutine.running();

    while u8 < buffer_len_ret do
        local v1266 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1266 + 0);

        if buffer_readu8_ret < 85 then
            if buffer_readu8_ret < 25 then
                if buffer_readu8_ret < 12 then
                    if buffer_readu8_ret == 1 then
                        local v1267 = u1.Player_ReadEVENT_StartGameRunning();

                        if #table_create_ret[1] > 0 then
                            for _, v in table_create_ret[1] do
                                task.spawn(v, v1267);
                            end;
                        else
                            if #table_create_ret3[1] > 256 then
                                warn("[Blink]: Event queue of \"StartGameRunning\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[1], { v1267 });
                        end;
                    elseif buffer_readu8_ret == 2 then
                        local v1268 = u1.Character_ReadEVENT_CharacterConstantBalls();

                        if #table_create_ret[2] > 0 then
                            for _, v in table_create_ret[2] do
                                u140 = "CharacterConstantBalls";
                                v(v1268);
                            end;
                        else
                            if #table_create_ret3[2] > 256 then
                                warn("[Blink]: Event queue of \"CharacterConstantBalls\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[2], { v1268 });
                        end;
                    elseif buffer_readu8_ret == 3 then
                        local v1269 = u1.Character_ReadEVENT_CharacterTemplateBalls();

                        if #table_create_ret[3] > 0 then
                            for _, v in table_create_ret[3] do
                                u140 = "CharacterTemplateBalls";
                                v(v1269);
                            end;
                        else
                            if #table_create_ret3[3] > 256 then
                                warn("[Blink]: Event queue of \"CharacterTemplateBalls\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[3], { v1269 });
                        end;
                    elseif buffer_readu8_ret == 4 then
                        local v1270, v1271, v1272 = u1.Character_ReadEVENT_CreateCharacter();

                        if #table_create_ret[4] > 0 then
                            for _, v in table_create_ret[4] do
                                u140 = "CreateCharacter";
                                v(v1270, v1271, v1272);
                            end;
                        else
                            if #table_create_ret3[4] > 256 then
                                warn("[Blink]: Event queue of \"CreateCharacter\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[4], { v1270, v1271, v1272 });
                        end;
                    elseif buffer_readu8_ret == 5 then
                        local v1273 = u1.Character_ReadEVENT_DestroyCharacter();

                        if #table_create_ret[5] > 0 then
                            for _, v in table_create_ret[5] do
                                u140 = "DestroyCharacter";
                                v(v1273);
                            end;
                        else
                            if #table_create_ret3[5] > 256 then
                                warn("[Blink]: Event queue of \"DestroyCharacter\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[5], { v1273 });
                        end;
                    elseif buffer_readu8_ret == 6 then
                        local v1274, v1275 = u1.Character_ReadEVENT_SimulationProperty();
                        local v1276 = table_create_ret[6];

                        if v1276 == nil then
                            if #table_create_ret3[6] > 256 then
                                warn("[Blink]: Event queue of \"SimulationProperty\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[6], { v1274, v1275 });
                        else
                            u140 = "SimulationProperty";
                            v1276(v1274, v1275);
                        end;
                    elseif buffer_readu8_ret == 7 then
                        local v1277 = u1.Weapon_ReadEVENT_CreateWeapon();
                        local v1278 = table_create_ret[7];

                        if v1278 == nil then
                            if #table_create_ret3[7] > 256 then
                                warn("[Blink]: Event queue of \"CreateWeapon\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[7], { v1277 });
                        else
                            u140 = "CreateWeapon";
                            v1278(v1277);
                        end;
                    else
                        if buffer_readu8_ret ~= 8 then
                            break;
                        end;

                        local v1279 = u1.Weapon_ReadEVENT_DestroyWeapon();
                        local v1280 = table_create_ret[8];

                        if v1280 == nil then
                            if #table_create_ret3[8] > 256 then
                                warn("[Blink]: Event queue of \"DestroyWeapon\" exceeded 256, did you forget to implement a listener?");
                            end;

                            table.insert(table_create_ret3[8], { v1279 });
                        else
                            u140 = "DestroyWeapon";
                            v1280(v1279);
                        end;
                    end;
                elseif buffer_readu8_ret == 12 then
                    local v1281 = u1.Weapon_ReadEVENT_ForceEquip();
                    local v1282 = table_create_ret[12];

                    if v1282 == nil then
                        if #table_create_ret3[12] > 256 then
                            warn("[Blink]: Event queue of \"ForceEquip\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[12], { v1281 });
                    else
                        u140 = "ForceEquip";
                        v1282(v1281);
                    end;
                elseif buffer_readu8_ret == 13 then
                    local v1283 = u1.Weapon_ReadEVENT_OnWeaponPickup();
                    local v1284 = table_create_ret[13];

                    if v1284 == nil then
                        if #table_create_ret3[13] > 256 then
                            warn("[Blink]: Event queue of \"OnWeaponPickup\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[13], { v1283 });
                    else
                        u140 = "OnWeaponPickup";
                        v1284(v1283);
                    end;
                elseif buffer_readu8_ret == 14 then
                    local v1285 = u1.Weapon_ReadEVENT_WeaponReset();
                    local v1286 = table_create_ret[14];

                    if v1286 == nil then
                        if #table_create_ret3[14] > 256 then
                            warn("[Blink]: Event queue of \"WeaponReset\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[14], { v1285 });
                    else
                        u140 = "WeaponReset";
                        v1286(v1285);
                    end;
                elseif buffer_readu8_ret == 15 then
                    local v1287 = u1.Weapon_ReadEVENT_Constant();
                    local v1288 = table_create_ret[15];

                    if v1288 == nil then
                        if #table_create_ret3[15] > 256 then
                            warn("[Blink]: Event queue of \"Constant\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[15], { v1287 });
                    else
                        u140 = "Constant";
                        v1288(v1287);
                    end;
                elseif buffer_readu8_ret == 16 then
                    local v1289 = u1.Weapon_ReadEVENT_Template();
                    local v1290 = table_create_ret[16];

                    if v1290 == nil then
                        if #table_create_ret3[16] > 256 then
                            warn("[Blink]: Event queue of \"Template\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[16], { v1289 });
                    else
                        u140 = "Template";
                        v1290(v1289);
                    end;
                elseif buffer_readu8_ret == 17 then
                    local v1291 = u1.Gui_ReadEVENT_BuyRejected();
                    local v1292 = table_create_ret[17];

                    if v1292 == nil then
                        if #table_create_ret3[17] > 256 then
                            warn("[Blink]: Event queue of \"BuyRejected\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[17], { v1291 });
                    else
                        u140 = "BuyRejected";
                        v1292(v1291);
                    end;
                elseif buffer_readu8_ret == 21 then
                    local v1293 = u1.Gui_ReadEVENT_UsedStarCodeUpdate();

                    if #table_create_ret[21] > 0 then
                        for _, v in table_create_ret[21] do
                            task.spawn(v, v1293);
                        end;
                    else
                        if #table_create_ret3[21] > 256 then
                            warn("[Blink]: Event queue of \"UsedStarCodeUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[21], { v1293 });
                    end;
                else
                    if buffer_readu8_ret ~= 23 then
                        break;
                    end;

                    local v1294 = u1.Gui_ReadEVENT_KillTrackColorUpdate();

                    if #table_create_ret[23] > 0 then
                        for _, v in table_create_ret[23] do
                            task.spawn(v, v1294);
                        end;
                    else
                        if #table_create_ret3[23] > 256 then
                            warn("[Blink]: Event queue of \"KillTrackColorUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[23], { v1294 });
                    end;
                end;
            elseif buffer_readu8_ret < 40 then
                if buffer_readu8_ret == 25 then
                    local v1295 = u1.Gui_ReadEVENT_FuserScrollsUpdate();
                    local v1296 = table_create_ret[25];

                    if v1296 == nil then
                        if #table_create_ret3[25] > 256 then
                            warn("[Blink]: Event queue of \"FuserScrollsUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[25], { v1295 });
                    else
                        task.spawn(v1296, v1295);
                    end;
                elseif buffer_readu8_ret == 26 then
                    local v1297 = u1.Gui_ReadEVENT_AnalyticsUpdate();
                    local v1298 = table_create_ret[26];

                    if v1298 == nil then
                        if #table_create_ret3[26] > 256 then
                            warn("[Blink]: Event queue of \"AnalyticsUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[26], { v1297 });
                    else
                        u140 = "AnalyticsUpdate";
                        v1298(v1297);
                    end;
                elseif buffer_readu8_ret == 28 then
                    local v1299, v1300 = u1.Gui_ReadEVENT_MatchData();
                    local v1301 = table_create_ret[28];

                    if v1301 == nil then
                        if #table_create_ret3[28] > 256 then
                            warn("[Blink]: Event queue of \"MatchData\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[28], { v1299, v1300 });
                    else
                        u140 = "MatchData";
                        v1301(v1299, v1300);
                    end;
                elseif buffer_readu8_ret == 32 then
                    local v1302 = u1.Gui_ReadEVENT_KillTrackUpdate();

                    if #table_create_ret[32] > 0 then
                        for _, v in table_create_ret[32] do
                            task.spawn(v, v1302);
                        end;
                    else
                        if #table_create_ret3[32] > 256 then
                            warn("[Blink]: Event queue of \"KillTrackUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[32], { v1302 });
                    end;
                elseif buffer_readu8_ret == 35 then
                    local v1303 = u1.Gui_ReadEVENT_ServerListResult();
                    local v1304 = table_create_ret[35];

                    if v1304 == nil then
                        if #table_create_ret3[35] > 256 then
                            warn("[Blink]: Event queue of \"ServerListResult\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[35], { v1303 });
                    else
                        task.spawn(v1304, v1303);
                    end;
                elseif buffer_readu8_ret == 37 then
                    local v1305, v1306 = u1.Gui_ReadEVENT_ProfileBadges();
                    local v1307 = table_create_ret[37];

                    if v1307 == nil then
                        if #table_create_ret3[37] > 256 then
                            warn("[Blink]: Event queue of \"ProfileBadges\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[37], { v1305, v1306 });
                    else
                        u140 = "ProfileBadges";
                        v1307(v1305, v1306);
                    end;
                elseif buffer_readu8_ret == 38 then
                    local v1308 = u1.Gui_ReadEVENT_MatchEndStats();
                    local v1309 = table_create_ret[38];

                    if v1309 == nil then
                        if #table_create_ret3[38] > 256 then
                            warn("[Blink]: Event queue of \"MatchEndStats\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[38], { v1308 });
                    else
                        task.spawn(v1309, v1308);
                    end;
                else
                    if buffer_readu8_ret ~= 39 then
                        break;
                    end;

                    local v1310 = u1.Gui_ReadEVENT_NewContainerMessage();
                    local v1311 = table_create_ret[39];

                    if v1311 == nil then
                        if #table_create_ret3[39] > 256 then
                            warn("[Blink]: Event queue of \"NewContainerMessage\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[39], { v1310 });
                    else
                        u140 = "NewContainerMessage";
                        v1311(v1310);
                    end;
                end;
            elseif buffer_readu8_ret < 46 then
                if buffer_readu8_ret == 40 then
                    local v1312 = u1.Gui_ReadEVENT_GlobalMessage();
                    local v1313 = table_create_ret[40];

                    if v1313 == nil then
                        if #table_create_ret3[40] > 256 then
                            warn("[Blink]: Event queue of \"GlobalMessage\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[40], { v1312 });
                    else
                        u140 = "GlobalMessage";
                        v1313(v1312);
                    end;
                elseif buffer_readu8_ret == 41 then
                    local v1314 = u1.Gui_ReadEVENT_NewMessage();
                    local v1315 = table_create_ret[41];

                    if v1315 == nil then
                        if #table_create_ret3[41] > 256 then
                            warn("[Blink]: Event queue of \"NewMessage\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[41], { v1314 });
                    else
                        u140 = "NewMessage";
                        v1315(v1314);
                    end;
                elseif buffer_readu8_ret == 42 then
                    local v1316 = u1.Gui_ReadEVENT_NewMessageTeam();
                    local v1317 = table_create_ret[42];

                    if v1317 == nil then
                        if #table_create_ret3[42] > 256 then
                            warn("[Blink]: Event queue of \"NewMessageTeam\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[42], { v1316 });
                    else
                        u140 = "NewMessageTeam";
                        v1317(v1316);
                    end;
                else
                    if buffer_readu8_ret ~= 43 then
                        break;
                    end;

                    local v1318, v1319, v1320 = u1.Gui_ReadEVENT_NewAwardMessage();
                    local v1321 = table_create_ret[43];

                    if v1321 == nil then
                        if #table_create_ret3[43] > 256 then
                            warn("[Blink]: Event queue of \"NewAwardMessage\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[43], { v1318, v1319, v1320 });
                    else
                        u140 = "NewAwardMessage";
                        v1321(v1318, v1319, v1320);
                    end;
                end;
            elseif buffer_readu8_ret == 46 then
                local v1322 = u1.Gui_ReadEVENT_DamageIndicator();
                local v1323 = table_create_ret[46];

                if v1323 == nil then
                    if #table_create_ret3[46] > 256 then
                        warn("[Blink]: Event queue of \"DamageIndicator\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[46], { v1322 });
                else
                    task.spawn(v1323, v1322);
                end;
            elseif buffer_readu8_ret == 48 then
                local v1324 = u1.Gui_ReadEVENT_MenuNotification();
                local v1325 = table_create_ret[48];

                if v1325 == nil then
                    if #table_create_ret3[48] > 256 then
                        warn("[Blink]: Event queue of \"MenuNotification\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[48], { v1324 });
                else
                    task.spawn(v1325, v1324);
                end;
            elseif buffer_readu8_ret == 69 then
                local v1326 = u1.Gui_ReadEVENT_UpgradeResult();
                local v1327 = table_create_ret[69];

                if v1327 == nil then
                    if #table_create_ret3[69] > 256 then
                        warn("[Blink]: Event queue of \"UpgradeResult\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[69], { v1326 });
                else
                    u140 = "UpgradeResult";
                    v1327(v1326);
                end;
            elseif buffer_readu8_ret == 82 then
                local v1328 = u1.Gui_ReadEVENT_OpenContainerResult();
                local v1329 = table_create_ret[82];

                if v1329 == nil then
                    if #table_create_ret3[82] > 256 then
                        warn("[Blink]: Event queue of \"OpenContainerResult\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[82], { v1328 });
                else
                    task.spawn(v1329, v1328);
                end;
            else
                if buffer_readu8_ret ~= 84 then
                    break;
                end;

                local v1330 = u1.Gui_ReadEVENT_KillfeedUpdate();
                local v1331 = table_create_ret[84];

                if v1331 == nil then
                    if #table_create_ret3[84] > 256 then
                        warn("[Blink]: Event queue of \"KillfeedUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[84], { v1330 });
                else
                    u140 = "KillfeedUpdate";
                    v1331(v1330);
                end;
            end;
        elseif buffer_readu8_ret < 102 then
            if buffer_readu8_ret < 93 then
                if buffer_readu8_ret == 85 then
                    local v1332 = u1.Gui_ReadEVENT_DiedUpdate();

                    if #table_create_ret[85] > 0 then
                        for _, v in table_create_ret[85] do
                            u140 = "DiedUpdate";
                            v(v1332);
                        end;
                    else
                        if #table_create_ret3[85] > 256 then
                            warn("[Blink]: Event queue of \"DiedUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[85], { v1332 });
                    end;
                elseif buffer_readu8_ret == 86 then
                    local v1333 = u1.Gui_ReadEVENT_MVPUpdate();
                    local v1334 = table_create_ret[86];

                    if v1334 == nil then
                        if #table_create_ret3[86] > 256 then
                            warn("[Blink]: Event queue of \"MVPUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[86], { v1333 });
                    else
                        u140 = "MVPUpdate";
                        v1334(v1333);
                    end;
                elseif buffer_readu8_ret == 87 then
                    local v1335 = u1.Gui_ReadEVENT_InventoryUpdate();

                    if #table_create_ret[87] > 0 then
                        for _, v in table_create_ret[87] do
                            u140 = "InventoryUpdate";
                            v(v1335);
                        end;
                    else
                        if #table_create_ret3[87] > 256 then
                            warn("[Blink]: Event queue of \"InventoryUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[87], { v1335 });
                    end;
                elseif buffer_readu8_ret == 88 then
                    local v1336 = u1.Gui_ReadEVENT_InventoryAdd();
                    local v1337 = table_create_ret[88];

                    if v1337 == nil then
                        if #table_create_ret3[88] > 256 then
                            warn("[Blink]: Event queue of \"InventoryAdd\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[88], { v1336 });
                    else
                        u140 = "InventoryAdd";
                        v1337(v1336);
                    end;
                elseif buffer_readu8_ret == 89 then
                    local v1338 = u1.Gui_ReadEVENT_InventoryRemove();
                    local v1339 = table_create_ret[89];

                    if v1339 == nil then
                        if #table_create_ret3[89] > 256 then
                            warn("[Blink]: Event queue of \"InventoryRemove\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[89], { v1338 });
                    else
                        u140 = "InventoryRemove";
                        v1339(v1338);
                    end;
                elseif buffer_readu8_ret == 90 then
                    local v1340 = u1.Gui_ReadEVENT_InventoryEquip();
                    local v1341 = table_create_ret[90];

                    if v1341 == nil then
                        if #table_create_ret3[90] > 256 then
                            warn("[Blink]: Event queue of \"InventoryEquip\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[90], { v1340 });
                    else
                        u140 = "InventoryEquip";
                        v1341(v1340);
                    end;
                elseif buffer_readu8_ret == 91 then
                    local v1342 = u1.Gui_ReadEVENT_PlayerStatsUpdate();
                    local v1343 = table_create_ret[91];

                    if v1343 == nil then
                        if #table_create_ret3[91] > 256 then
                            warn("[Blink]: Event queue of \"PlayerStatsUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[91], { v1342 });
                    else
                        task.spawn(v1343, v1342);
                    end;
                else
                    if buffer_readu8_ret ~= 92 then
                        break;
                    end;

                    local v1344 = u1.Gui_ReadEVENT_PlaytimeUpdate();
                    local v1345 = table_create_ret[92];

                    if v1345 == nil then
                        if #table_create_ret3[92] > 256 then
                            warn("[Blink]: Event queue of \"PlaytimeUpdate\" exceeded 256, did you forget to implement a listener?");
                        end;

                        table.insert(table_create_ret3[92], { v1344 });
                    else
                        task.spawn(v1345, v1344);
                    end;
                end;
            elseif buffer_readu8_ret == 93 then
                local v1346 = u1.Gui_ReadEVENT_PlaytimeRewardsCollectedUpdate();
                local v1347 = table_create_ret[93];

                if v1347 == nil then
                    if #table_create_ret3[93] > 256 then
                        warn("[Blink]: Event queue of \"PlaytimeRewardsCollectedUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[93], { v1346 });
                else
                    task.spawn(v1347, v1346);
                end;
            elseif buffer_readu8_ret == 94 then
                local v1348 = u1.Gui_ReadEVENT_UsedCodesUpdate();
                local v1349 = table_create_ret[94];

                if v1349 == nil then
                    if #table_create_ret3[94] > 256 then
                        warn("[Blink]: Event queue of \"UsedCodesUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[94], { v1348 });
                else
                    task.spawn(v1349, v1348);
                end;
            elseif buffer_readu8_ret == 95 then
                local v1350 = u1.Gui_ReadEVENT_CollectedAchievementsUpdate();
                local v1351 = table_create_ret[95];

                if v1351 == nil then
                    if #table_create_ret3[95] > 256 then
                        warn("[Blink]: Event queue of \"CollectedAchievementsUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[95], { v1350 });
                else
                    task.spawn(v1351, v1350);
                end;
            elseif buffer_readu8_ret == 96 then
                local v1352 = u1.Gui_ReadEVENT_GamepassesUpdate();
                local v1353 = table_create_ret[96];

                if v1353 == nil then
                    if #table_create_ret3[96] > 256 then
                        warn("[Blink]: Event queue of \"GamepassesUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[96], { v1352 });
                else
                    task.spawn(v1353, v1352);
                end;
            elseif buffer_readu8_ret == 97 then
                local v1354 = u1.Gui_ReadEVENT_ChallengesUpdate();
                local v1355 = table_create_ret[97];

                if v1355 == nil then
                    if #table_create_ret3[97] > 256 then
                        warn("[Blink]: Event queue of \"ChallengesUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[97], { v1354 });
                else
                    task.spawn(v1355, v1354);
                end;
            elseif buffer_readu8_ret == 98 then
                local v1356 = u1.Gui_ReadEVENT_BattlepassUpdate();
                local v1357 = table_create_ret[98];

                if v1357 == nil then
                    if #table_create_ret3[98] > 256 then
                        warn("[Blink]: Event queue of \"BattlepassUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[98], { v1356 });
                else
                    task.spawn(v1357, v1356);
                end;
            elseif buffer_readu8_ret == 99 then
                local v1358 = u1.Gui_ReadEVENT_CreditsUpdate();
                local v1359 = table_create_ret[99];

                if v1359 == nil then
                    if #table_create_ret3[99] > 256 then
                        warn("[Blink]: Event queue of \"CreditsUpdate\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[99], { v1358 });
                else
                    task.spawn(v1359, v1358);
                end;
            else
                if buffer_readu8_ret ~= 101 then
                    break;
                end;

                local v1360, v1361 = u1.Entity_ReadEVENT_EntityVisibility();
                local v1362 = table_create_ret[101];

                if v1362 == nil then
                    if #table_create_ret3[101] > 256 then
                        warn("[Blink]: Event queue of \"EntityVisibility\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[101], { v1360, v1361 });
                else
                    u140 = "EntityVisibility";
                    v1362(v1360, v1361);
                end;
            end;
        elseif buffer_readu8_ret < 112 then
            if buffer_readu8_ret == 102 then
                local v1363 = u1.Entity_ReadEVENT_CreateEntity();
                local v1364 = table_create_ret[102];

                if v1364 == nil then
                    if #table_create_ret3[102] > 256 then
                        warn("[Blink]: Event queue of \"CreateEntity\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[102], { v1363 });
                else
                    task.spawn(v1364, v1363);
                end;
            elseif buffer_readu8_ret == 103 then
                local v1365 = u1.Entity_ReadEVENT_DestroyEntity();
                local v1366 = table_create_ret[103];

                if v1366 == nil then
                    if #table_create_ret3[103] > 256 then
                        warn("[Blink]: Event queue of \"DestroyEntity\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[103], { v1365 });
                else
                    task.spawn(v1366, v1365);
                end;
            elseif buffer_readu8_ret == 104 then
                local v1367 = u1.Entity_ReadEVENT_OnPlayerConnected();
                local v1368 = table_create_ret[104];

                if v1368 == nil then
                    if #table_create_ret3[104] > 256 then
                        warn("[Blink]: Event queue of \"OnPlayerConnected\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[104], { v1367 });
                else
                    task.spawn(v1368, v1367);
                end;
            elseif buffer_readu8_ret == 105 then
                local v1369 = u1.Entity_ReadEVENT_CharacterCurrentWeapon();
                local v1370 = table_create_ret[105];

                if v1370 == nil then
                    if #table_create_ret3[105] > 256 then
                        warn("[Blink]: Event queue of \"CharacterCurrentWeapon\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[105], { v1369 });
                else
                    u140 = "CharacterCurrentWeapon";
                    v1370(v1369);
                end;
            elseif buffer_readu8_ret == 106 then
                local v1371 = u1.Entity_ReadEVENT_CharacterWeaponInventorySlot();
                local v1372 = table_create_ret[106];

                if v1372 == nil then
                    if #table_create_ret3[106] > 256 then
                        warn("[Blink]: Event queue of \"CharacterWeaponInventorySlot\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[106], { v1371 });
                else
                    u140 = "CharacterWeaponInventorySlot";
                    v1372(v1371);
                end;
            elseif buffer_readu8_ret == 107 then
                local v1373 = u1.Entity_ReadEVENT_CharacterDeath();
                local v1374 = table_create_ret[107];

                if v1374 == nil then
                    if #table_create_ret3[107] > 256 then
                        warn("[Blink]: Event queue of \"CharacterDeath\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[107], { v1373 });
                else
                    u140 = "CharacterDeath";
                    v1374(v1373);
                end;
            elseif buffer_readu8_ret == 108 then
                local v1375 = u1.Particles_ReadEVENT_CreateRagdoll();
                local v1376 = table_create_ret[108];

                if v1376 == nil then
                    if #table_create_ret3[108] > 256 then
                        warn("[Blink]: Event queue of \"CreateRagdoll\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[108], { v1375 });
                else
                    task.spawn(v1376, v1375);
                end;
            else
                if buffer_readu8_ret ~= 110 then
                    break;
                end;

                local v1377, v1378 = u1.Spectate_ReadEVENT_SpectateIdentifier();
                local v1379 = table_create_ret[110];

                if v1379 == nil then
                    if #table_create_ret3[110] > 256 then
                        warn("[Blink]: Event queue of \"SpectateIdentifier\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[110], { v1377, v1378 });
                else
                    u140 = "SpectateIdentifier";
                    v1379(v1377, v1378);
                end;
            end;
        elseif buffer_readu8_ret < 118 then
            if buffer_readu8_ret == 112 then
                local v1380 = u1.Debug_ReadEVENT_ShotMarker();
                local v1381 = table_create_ret[112];

                if v1381 == nil then
                    if #table_create_ret3[112] > 256 then
                        warn("[Blink]: Event queue of \"ShotMarker\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[112], { v1380 });
                else
                    u140 = "ShotMarker";
                    v1381(v1380);
                end;
            elseif buffer_readu8_ret == 113 then
                local v1382 = u1.Debug_ReadEVENT_ServerShot();
                local v1383 = table_create_ret[113];

                if v1383 == nil then
                    if #table_create_ret3[113] > 256 then
                        warn("[Blink]: Event queue of \"ServerShot\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[113], { v1382 });
                else
                    u140 = "ServerShot";
                    v1383(v1382);
                end;
            elseif buffer_readu8_ret == 115 then
                local v1384 = u1.ReadEVENT_GenerateCollision();
                local v1385 = table_create_ret[115];

                if v1385 == nil then
                    if #table_create_ret3[115] > 256 then
                        warn("[Blink]: Event queue of \"GenerateCollision\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[115], { v1384 });
                else
                    task.spawn(v1385, v1384);
                end;
            else
                if buffer_readu8_ret ~= 116 then
                    break;
                end;

                local v1386 = u1.ReadEVENT_ConfigChanged();
                local v1387 = table_create_ret[116];

                if v1387 == nil then
                    if #table_create_ret3[116] > 256 then
                        warn("[Blink]: Event queue of \"ConfigChanged\" exceeded 256, did you forget to implement a listener?");
                    end;

                    table.insert(table_create_ret3[116], { v1386 });
                else
                    u140 = "ConfigChanged";
                    v1387(v1386);
                end;
            end;
        elseif buffer_readu8_ret == 118 then
            local v1388 = u1.ReadEVENT_ConsoleServer();
            local v1389 = table_create_ret[118];

            if v1389 == nil then
                if #table_create_ret3[118] > 256 then
                    warn("[Blink]: Event queue of \"ConsoleServer\" exceeded 256, did you forget to implement a listener?");
                end;

                table.insert(table_create_ret3[118], { v1388 });
            else
                task.spawn(v1389, v1388);
            end;
        elseif buffer_readu8_ret == 119 then
            local v1390 = u1.ReadEVENT_OnMapAdded();
            local v1391 = table_create_ret[119];

            if v1391 == nil then
                if #table_create_ret3[119] > 256 then
                    warn("[Blink]: Event queue of \"OnMapAdded\" exceeded 256, did you forget to implement a listener?");
                end;

                table.insert(table_create_ret3[119], { v1390 });
            else
                task.spawn(v1391, v1390);
            end;
        elseif buffer_readu8_ret == 120 then
            local v1392 = u1.ReadEVENT_OnMapRemoving();
            local v1393 = table_create_ret[120];

            if v1393 == nil then
                if #table_create_ret3[120] > 256 then
                    warn("[Blink]: Event queue of \"OnMapRemoving\" exceeded 256, did you forget to implement a listener?");
                end;

                table.insert(table_create_ret3[120], { v1392 });
            else
                task.spawn(v1393, v1392);
            end;
        elseif buffer_readu8_ret == 121 then
            local v1394 = u1.ReadEVENT_RoundReset();
            local v1395 = table_create_ret[121];

            if v1395 == nil then
                if #table_create_ret3[121] > 256 then
                    warn("[Blink]: Event queue of \"RoundReset\" exceeded 256, did you forget to implement a listener?");
                end;

                table.insert(table_create_ret3[121], { v1394 });
            else
                u140 = "RoundReset";
                v1395(v1394);
            end;
        else
            if buffer_readu8_ret ~= 123 then
                break;
            end;

            local v1396 = u1.ReadEVENT_SimulationConstants();
            local v1397 = table_create_ret[123];

            if v1397 == nil then
                if #table_create_ret3[123] > 256 then
                    warn("[Blink]: Event queue of \"SimulationConstants\" exceeded 256, did you forget to implement a listener?");
                end;

                table.insert(table_create_ret3[123], { v1396 });
            else
                u140 = "SimulationConstants";
                v1397(v1396);
            end;
        end;
    end;
end;

BLINK_RELIABLE_REMOTE.OnClientEvent:Connect(ProcessReliable);

function ProcessUnreliable(p1398: buffer, p1399: table?)
    -- upvalues: u8 (ref), buffer_create_ret2 (ref), u9 (ref), table_freeze_ret (copy), u10 (ref), u141 (ref), u140 (ref), u1 (copy), table_create_ret2 (copy)
    local v1400;

    if typeof(p1398) == "buffer" then
        if p1399 == nil then
            v1400 = true;
        elseif typeof(p1399) == "table" then
            v1400 = #p1399 <= 4096;
        else
            v1400 = false;
        end;
    else
        v1400 = false;
    end;

    if not v1400 then
        return;
    end;

    if buffer.len(p1398) > 4294967296 then
        warn((`[Blink]: Dropped an incoming packet of {buffer.len(p1398)} bytes, the maximum is {4294967296} bytes.`));

        return;
    end;

    u8 = 0;
    buffer_create_ret2 = p1398;
    u9 = p1399 or table_freeze_ret;
    u10 = 0;
    local buffer_len_ret = buffer.len(buffer_create_ret2);

    if u141 and coroutine.status(u141) == "suspended" then
        warn((`[Blink]: Yielded in a Sync call. Event "{u140}" uses a Sync call, consider using an Async call instead.`));
        coroutine.close(u141);
    end;

    u141 = coroutine.running();

    while u8 < buffer_len_ret do
        local v1401 = u8;
        u8 = u8 + 1;
        local buffer_readu8_ret = buffer.readu8(buffer_create_ret2, v1401 + 0);

        if buffer_readu8_ret < 15 then
            if buffer_readu8_ret == 3 then
                local v1402 = u1.Character_ReadEVENT_HandleNewState();
                local v1403 = table_create_ret2[3];

                if v1403 ~= nil then
                    u140 = "HandleNewState";
                    v1403(v1402);
                end;
            elseif buffer_readu8_ret == 6 then
                local v1404 = u1.Gui_ReadEVENT_Ping();
                local v1405 = table_create_ret2[6];

                if v1405 ~= nil then
                    task.spawn(v1405, v1404);
                end;
            elseif buffer_readu8_ret == 9 then
                local v1406, v1407, v1408 = u1.Entity_ReadEVENT_EntitySnapshot();
                local v1409 = table_create_ret2[9];

                if v1409 ~= nil then
                    task.spawn(v1409, v1406, v1407, v1408);
                end;
            elseif buffer_readu8_ret == 10 then
                local v1410 = u1.Entity_ReadEVENT_CharacterCurrentWeaponInventoryData();
                local v1411 = table_create_ret2[10];

                if v1411 ~= nil then
                    u140 = "CharacterCurrentWeaponInventoryData";
                    v1411(v1410);
                end;
            elseif buffer_readu8_ret == 11 then
                local v1412 = u1.Particles_ReadEVENT_CreateBulletHole();
                local v1413 = table_create_ret2[11];

                if v1413 ~= nil then
                    u140 = "CreateBulletHole";
                    v1413(v1412);
                end;
            elseif buffer_readu8_ret == 12 then
                local v1414 = u1.Particles_ReadEVENT_CreateTracer();
                local v1415 = table_create_ret2[12];

                if v1415 ~= nil then
                    u140 = "CreateTracer";
                    v1415(v1414);
                end;
            else
                if buffer_readu8_ret ~= 13 then
                    break;
                end;

                local v1416 = u1.Spectate_ReadEVENT_SpectateData();
                local v1417 = table_create_ret2[13];

                if v1417 ~= nil then
                    u140 = "SpectateData";
                    v1417(v1416);
                end;
            end;
        elseif buffer_readu8_ret == 15 then
            local v1418 = u1.ReadEVENT_ServerTick();

            for _, v in table_create_ret2[15] do
                task.spawn(v, v1418);
            end;
        elseif buffer_readu8_ret == 17 then
            local v1419 = u1.ReadEVENT_ServerPing();
            local v1420 = table_create_ret2[17];

            if v1420 ~= nil then
                task.spawn(v1420, v1419);
            end;
        elseif buffer_readu8_ret == 18 then
            local v1421, v1422, v1423 = u1.ReadEVENT_RadarLeak();
            local v1424 = table_create_ret2[18];

            if v1424 ~= nil then
                u140 = "RadarLeak";
                v1424(v1421, v1422, v1423);
            end;
        elseif buffer_readu8_ret == 19 then
            local v1425, v1426 = u1.ReadEVENT_PlaySoundOnPosition();
            local v1427 = table_create_ret2[19];

            if v1427 ~= nil then
                u140 = "PlaySoundOnPosition";
                v1427(v1425, v1426);
            end;
        elseif buffer_readu8_ret == 20 then
            local v1428, v1429, v1430, v1431 = u1.ReadEVENT_PlayFootstepSoundOnPosition();
            local v1432 = table_create_ret2[20];

            if v1432 ~= nil then
                u140 = "PlayFootstepSoundOnPosition";
                v1432(v1428, v1429, v1430, v1431);
            end;
        elseif buffer_readu8_ret == 21 then
            local v1433 = u1.ReadEVENT_NetworkDebugStats();
            local v1434 = table_create_ret2[21];

            if v1434 ~= nil then
                u140 = "NetworkDebugStats";
                v1434(v1433);
            end;
        else
            if buffer_readu8_ret ~= 22 then
                break;
            end;

            local v1435 = u1.ReadEVENT_ServerPerformanceStats();
            local v1436 = table_create_ret2[22];

            if v1436 ~= nil then
                u140 = "ServerPerformanceStats";
                v1436(v1435);
            end;
        end;
    end;
end;

BLINK_UNRELIABLE_REMOTE.OnClientEvent:Connect(ProcessUnreliable);
BLINK_RELIABLE_FRAGMENT_REMOTE.OnClientEvent:Connect(function(p1437: buffer, p1438: table?) -- Line: 6281
    -- upvalues: ReceiveFragment (copy), u1233 (copy)
    local v1439, v1440 = ReceiveFragment(u1233, p1437, p1438, 750);

    if v1439 ~= nil then
        ProcessReliable(v1439, v1440);
    end;
end);
BLINK_UNRELIABLE_FRAGMENT_REMOTE.OnClientEvent:Connect(function(p1441: buffer, p1442: table?) -- Line: 6287
    -- upvalues: ReceiveFragment (copy), u1234 (copy)
    local v1443, v1444 = ReceiveFragment(u1234, p1441, p1442, 800);

    if v1443 ~= nil then
        ProcessUnreliable(v1443, v1444);
    end;
end);

return table.freeze({
    StepReplication = StepReplication,
    Player = {
        PlayerLoaded = {
            Fire = function(p1445) -- Line: 6300, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1446 = u1235;
                local v1447 = os.clock() // 1;

                if v1446.Window ~= v1447 then
                    v1446.Window = v1447;
                    table.clear(v1446.Counts);
                end;

                local v1448 = (v1446.Counts.PlayerLoaded or 0) + 1;
                v1446.Counts.PlayerLoaded = v1448;

                if v1448 > 1 then
                    return;
                end;

                u1.Player_WriteEVENT_PlayerLoaded(p1445);
            end
        },
        StartGameRunning = {
            On = function(u1449: function) -- Line: 6306, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[1], u1449);

                for _, v in table_create_ret3[1] do
                    task.spawn(u1449, table.unpack(v));
                end;

                table_create_ret3[1] = {};

                return function() -- Line: 6312
                    -- upvalues: table_create_ret (ref), u1449 (copy)
                    local table_find_ret = table.find(table_create_ret[1], u1449);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[1], table_find_ret);
                    end;
                end;
            end
        }
    },
    Character = {
        CharacterConstantBalls = {
            On = function(u1450: function) -- Line: 6323, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[2], u1450);

                for _, v in table_create_ret3[2] do
                    u1450(table.unpack(v));
                end;

                table_create_ret3[2] = {};

                return function() -- Line: 6329
                    -- upvalues: table_create_ret (ref), u1450 (copy)
                    local table_find_ret = table.find(table_create_ret[2], u1450);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[2], table_find_ret);
                    end;
                end;
            end
        },
        CharacterTemplateBalls = {
            On = function(u1451: function) -- Line: 6338, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[3], u1451);

                for _, v in table_create_ret3[3] do
                    u1451(table.unpack(v));
                end;

                table_create_ret3[3] = {};

                return function() -- Line: 6344
                    -- upvalues: table_create_ret (ref), u1451 (copy)
                    local table_find_ret = table.find(table_create_ret[3], u1451);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[3], table_find_ret);
                    end;
                end;
            end
        },
        CreateCharacter = {
            On = function(u1452: function) -- Line: 6353, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[4], u1452);

                for _, v in table_create_ret3[4] do
                    u1452(table.unpack(v));
                end;

                table_create_ret3[4] = {};

                return function() -- Line: 6359
                    -- upvalues: table_create_ret (ref), u1452 (copy)
                    local table_find_ret = table.find(table_create_ret[4], u1452);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[4], table_find_ret);
                    end;
                end;
            end
        },
        DestroyCharacter = {
            On = function(u1453: function) -- Line: 6368, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[5], u1453);

                for _, v in table_create_ret3[5] do
                    u1453(table.unpack(v));
                end;

                table_create_ret3[5] = {};

                return function() -- Line: 6374
                    -- upvalues: table_create_ret (ref), u1453 (copy)
                    local table_find_ret = table.find(table_create_ret[5], u1453);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[5], table_find_ret);
                    end;
                end;
            end
        },
        Command = {
            Fire = function(p1454: table) -- Line: 6383, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1455 = u1235;
                local v1456 = os.clock() // 1;

                if v1455.Window ~= v1456 then
                    v1455.Window = v1456;
                    table.clear(v1455.Counts);
                end;

                local v1457 = (v1455.Counts.Command or 0) + 1;
                v1455.Counts.Command = v1457;

                if v1457 > 300 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1458 = u20;

                    for i = #v1458, u19 + 1, -1 do
                        v1458[i] = nil;
                        local _ = i;
                    end;

                    local v1459 = u21;
                    u21 = nil;

                    if u6 == v1458 then
                        if v1459 then
                            Load(v1459);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1460 = u50 or {};
                v1460.Size = u3;
                v1460.Cursor = u5;
                v1460.Buffer = buffer_create_ret;
                v1460.Instances = u6;
                v1460.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1461 = u20;

                    for i = #v1461, u19 + 1, -1 do
                        v1461[i] = nil;
                        local _ = i;
                    end;

                    local v1462 = u21;
                    u21 = nil;

                    if u6 == v1461 then
                        if v1462 then
                            Load(v1462);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1463 = u48;

                if v1463 then
                    v1463.Cursor = 0;
                    table.clear(v1463.Instances);
                    table.clear(v1463.Debug);
                end;

                Load(v1463);
                u1.Character_WriteEVENT_Command(p1454, v1460);
                local v1464 = u48 or {};
                v1464.Size = u3;
                v1464.Cursor = u5;
                v1464.Buffer = buffer_create_ret;
                v1464.Instances = u6;
                v1464.Debug = u7;
                u48 = v1464;
                local v1465 = u49;
                local v1466 = u5;

                if not v1465 or buffer.len(v1465) ~= v1466 then
                    v1465 = buffer.create(v1466);
                end;

                buffer.copy(v1465, 0, buffer_create_ret, 0, v1466);
                u49 = v1465;
                local v1467 = u49;
                local v1468 = u6;

                if buffer.len(v1467) > 800 then
                    SendFragments(v1467, v1468, 800, FireUnreliableFragment);
                else
                    if #v1468 <= 0 then
                        v1468 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1467, v1468);
                end;

                Load(v1460);
            end
        },
        CommandIdle = {
            Fire = function(p1469: table) -- Line: 6397, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1470 = u1235;
                local v1471 = os.clock() // 1;

                if v1470.Window ~= v1471 then
                    v1470.Window = v1471;
                    table.clear(v1470.Counts);
                end;

                local v1472 = (v1470.Counts.CommandIdle or 0) + 1;
                v1470.Counts.CommandIdle = v1472;

                if v1472 > 300 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1473 = u20;

                    for i = #v1473, u19 + 1, -1 do
                        v1473[i] = nil;
                        local _ = i;
                    end;

                    local v1474 = u21;
                    u21 = nil;

                    if u6 == v1473 then
                        if v1474 then
                            Load(v1474);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1475 = u50 or {};
                v1475.Size = u3;
                v1475.Cursor = u5;
                v1475.Buffer = buffer_create_ret;
                v1475.Instances = u6;
                v1475.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1476 = u20;

                    for i = #v1476, u19 + 1, -1 do
                        v1476[i] = nil;
                        local _ = i;
                    end;

                    local v1477 = u21;
                    u21 = nil;

                    if u6 == v1476 then
                        if v1477 then
                            Load(v1477);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1478 = u48;

                if v1478 then
                    v1478.Cursor = 0;
                    table.clear(v1478.Instances);
                    table.clear(v1478.Debug);
                end;

                Load(v1478);
                u1.Character_WriteEVENT_CommandIdle(p1469, v1475);
                local v1479 = u48 or {};
                v1479.Size = u3;
                v1479.Cursor = u5;
                v1479.Buffer = buffer_create_ret;
                v1479.Instances = u6;
                v1479.Debug = u7;
                u48 = v1479;
                local v1480 = u49;
                local v1481 = u5;

                if not v1480 or buffer.len(v1480) ~= v1481 then
                    v1480 = buffer.create(v1481);
                end;

                buffer.copy(v1480, 0, buffer_create_ret, 0, v1481);
                u49 = v1480;
                local v1482 = u49;
                local v1483 = u6;

                if buffer.len(v1482) > 800 then
                    SendFragments(v1482, v1483, 800, FireUnreliableFragment);
                else
                    if #v1483 <= 0 then
                        v1483 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1482, v1483);
                end;

                Load(v1475);
            end
        },
        CommandArray = {
            Fire = function(p1484: table) -- Line: 6411, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1485 = u1235;
                local v1486 = os.clock() // 1;

                if v1485.Window ~= v1486 then
                    v1485.Window = v1486;
                    table.clear(v1485.Counts);
                end;

                local v1487 = (v1485.Counts.CommandArray or 0) + 1;
                v1485.Counts.CommandArray = v1487;

                if v1487 > 300 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1488 = u20;

                    for i = #v1488, u19 + 1, -1 do
                        v1488[i] = nil;
                        local _ = i;
                    end;

                    local v1489 = u21;
                    u21 = nil;

                    if u6 == v1488 then
                        if v1489 then
                            Load(v1489);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1490 = u50 or {};
                v1490.Size = u3;
                v1490.Cursor = u5;
                v1490.Buffer = buffer_create_ret;
                v1490.Instances = u6;
                v1490.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1491 = u20;

                    for i = #v1491, u19 + 1, -1 do
                        v1491[i] = nil;
                        local _ = i;
                    end;

                    local v1492 = u21;
                    u21 = nil;

                    if u6 == v1491 then
                        if v1492 then
                            Load(v1492);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1493 = u48;

                if v1493 then
                    v1493.Cursor = 0;
                    table.clear(v1493.Instances);
                    table.clear(v1493.Debug);
                end;

                Load(v1493);
                u1.Character_WriteEVENT_CommandArray(p1484, v1490);
                local v1494 = u48 or {};
                v1494.Size = u3;
                v1494.Cursor = u5;
                v1494.Buffer = buffer_create_ret;
                v1494.Instances = u6;
                v1494.Debug = u7;
                u48 = v1494;
                local v1495 = u49;
                local v1496 = u5;

                if not v1495 or buffer.len(v1495) ~= v1496 then
                    v1495 = buffer.create(v1496);
                end;

                buffer.copy(v1495, 0, buffer_create_ret, 0, v1496);
                u49 = v1495;
                local v1497 = u49;
                local v1498 = u6;

                if buffer.len(v1497) > 800 then
                    SendFragments(v1497, v1498, 800, FireUnreliableFragment);
                else
                    if #v1498 <= 0 then
                        v1498 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1497, v1498);
                end;

                Load(v1490);
            end
        },
        HandleNewState = {
            On = function(u1499: function) -- Line: 6425, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[3] = u1499;

                return function() -- Line: 6427
                    -- upvalues: table_create_ret2 (ref), u1499 (copy)
                    if table_create_ret2[3] == u1499 then
                        table_create_ret2[3] = nil;
                    end;
                end;
            end
        },
        SimulationProperty = {
            On = function(u1500: function) -- Line: 6435, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[6] = u1500;

                for _, v in table_create_ret3[6] do
                    u1500(table.unpack(v));
                end;

                table_create_ret3[6] = {};

                return function() -- Line: 6441
                    -- upvalues: table_create_ret (ref), u1500 (copy)
                    if table_create_ret[6] == u1500 then
                        table_create_ret[6] = nil;
                    end;
                end;
            end
        }
    },
    Weapon = {
        CreateWeapon = {
            On = function(u1501: function) -- Line: 6451, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[7] = u1501;

                for _, v in table_create_ret3[7] do
                    u1501(table.unpack(v));
                end;

                table_create_ret3[7] = {};

                return function() -- Line: 6457
                    -- upvalues: table_create_ret (ref), u1501 (copy)
                    if table_create_ret[7] == u1501 then
                        table_create_ret[7] = nil;
                    end;
                end;
            end
        },
        DestroyWeapon = {
            On = function(u1502: function) -- Line: 6465, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[8] = u1502;

                for _, v in table_create_ret3[8] do
                    u1502(table.unpack(v));
                end;

                table_create_ret3[8] = {};

                return function() -- Line: 6471
                    -- upvalues: table_create_ret (ref), u1502 (copy)
                    if table_create_ret[8] == u1502 then
                        table_create_ret[8] = nil;
                    end;
                end;
            end
        },
        BuyWeapon = {
            Fire = function(p1503: table) -- Line: 6479, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1504 = u1235;
                local v1505 = os.clock() // 1;

                if v1504.Window ~= v1505 then
                    v1504.Window = v1505;
                    table.clear(v1504.Counts);
                end;

                local v1506 = (v1504.Counts.BuyWeapon or 0) + 1;
                v1504.Counts.BuyWeapon = v1506;

                if v1506 > 5 then
                    return;
                end;

                u1.Weapon_WriteEVENT_BuyWeapon(p1503);
            end
        },
        PickUpWeapon = {
            Fire = function(p1507: number) -- Line: 6485, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1508 = u1235;
                local v1509 = os.clock() // 1;

                if v1508.Window ~= v1509 then
                    v1508.Window = v1509;
                    table.clear(v1508.Counts);
                end;

                local v1510 = (v1508.Counts.PickUpWeapon or 0) + 1;
                v1508.Counts.PickUpWeapon = v1510;

                if v1510 > 5 then
                    return;
                end;

                u1.Weapon_WriteEVENT_PickUpWeapon(p1507);
            end
        },
        RefundWeapon = {
            Fire = function(p1511: table) -- Line: 6491, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1512 = u1235;
                local v1513 = os.clock() // 1;

                if v1512.Window ~= v1513 then
                    v1512.Window = v1513;
                    table.clear(v1512.Counts);
                end;

                local v1514 = (v1512.Counts.RefundWeapon or 0) + 1;
                v1512.Counts.RefundWeapon = v1514;

                if v1514 > 5 then
                    return;
                end;

                u1.Weapon_WriteEVENT_RefundWeapon(p1511);
            end
        },
        ForceEquip = {
            On = function(u1515: function) -- Line: 6497, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[12] = u1515;

                for _, v in table_create_ret3[12] do
                    u1515(table.unpack(v));
                end;

                table_create_ret3[12] = {};

                return function() -- Line: 6503
                    -- upvalues: table_create_ret (ref), u1515 (copy)
                    if table_create_ret[12] == u1515 then
                        table_create_ret[12] = nil;
                    end;
                end;
            end
        },
        OnWeaponPickup = {
            On = function(u1516: function) -- Line: 6511, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[13] = u1516;

                for _, v in table_create_ret3[13] do
                    u1516(table.unpack(v));
                end;

                table_create_ret3[13] = {};

                return function() -- Line: 6517
                    -- upvalues: table_create_ret (ref), u1516 (copy)
                    if table_create_ret[13] == u1516 then
                        table_create_ret[13] = nil;
                    end;
                end;
            end
        },
        WeaponReset = {
            On = function(u1517: function) -- Line: 6525, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[14] = u1517;

                for _, v in table_create_ret3[14] do
                    u1517(table.unpack(v));
                end;

                table_create_ret3[14] = {};

                return function() -- Line: 6531
                    -- upvalues: table_create_ret (ref), u1517 (copy)
                    if table_create_ret[14] == u1517 then
                        table_create_ret[14] = nil;
                    end;
                end;
            end
        },
        Constant = {
            On = function(u1518: function) -- Line: 6539, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[15] = u1518;

                for _, v in table_create_ret3[15] do
                    u1518(table.unpack(v));
                end;

                table_create_ret3[15] = {};

                return function() -- Line: 6545
                    -- upvalues: table_create_ret (ref), u1518 (copy)
                    if table_create_ret[15] == u1518 then
                        table_create_ret[15] = nil;
                    end;
                end;
            end
        },
        Template = {
            On = function(u1519: function) -- Line: 6553, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[16] = u1519;

                for _, v in table_create_ret3[16] do
                    u1519(table.unpack(v));
                end;

                table_create_ret3[16] = {};

                return function() -- Line: 6559
                    -- upvalues: table_create_ret (ref), u1519 (copy)
                    if table_create_ret[16] == u1519 then
                        table_create_ret[16] = nil;
                    end;
                end;
            end
        }
    },
    Gui = {
        BuyRejected = {
            On = function(u1520: function) -- Line: 6569, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[17] = u1520;

                for _, v in table_create_ret3[17] do
                    u1520(table.unpack(v));
                end;

                table_create_ret3[17] = {};

                return function() -- Line: 6575
                    -- upvalues: table_create_ret (ref), u1520 (copy)
                    if table_create_ret[17] == u1520 then
                        table_create_ret[17] = nil;
                    end;
                end;
            end
        },
        ViewmodelPreset = {
            Fire = function(p1521: string) -- Line: 6583, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1522 = u1235;
                local v1523 = os.clock() // 1;

                if v1522.Window ~= v1523 then
                    v1522.Window = v1523;
                    table.clear(v1522.Counts);
                end;

                local v1524 = (v1522.Counts.ViewmodelPreset or 0) + 1;
                v1522.Counts.ViewmodelPreset = v1524;

                if v1524 > 240 then
                    return;
                end;

                u1.Gui_WriteEVENT_ViewmodelPreset(p1521);
            end
        },
        WatchAdReward = {
            Fire = function(p1525: number) -- Line: 6589, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1526 = u1235;
                local v1527 = os.clock() // 1;

                if v1526.Window ~= v1527 then
                    v1526.Window = v1527;
                    table.clear(v1526.Counts);
                end;

                local v1528 = (v1526.Counts.WatchAdReward or 0) + 1;
                v1526.Counts.WatchAdReward = v1528;

                if v1528 > 240 then
                    return;
                end;

                u1.Gui_WriteEVENT_WatchAdReward(p1525);
            end
        },
        UseStarCode = {
            Fire = function(p1529: string) -- Line: 6595, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1530 = u1235;
                local v1531 = os.clock() // 1;

                if v1530.Window ~= v1531 then
                    v1530.Window = v1531;
                    table.clear(v1530.Counts);
                end;

                local v1532 = (v1530.Counts.UseStarCode or 0) + 1;
                v1530.Counts.UseStarCode = v1532;

                if v1532 > 240 then
                    return;
                end;

                u1.Gui_WriteEVENT_UseStarCode(p1529);
            end
        },
        UsedStarCodeUpdate = {
            On = function(u1533: function) -- Line: 6601, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[21], u1533);

                for _, v in table_create_ret3[21] do
                    task.spawn(u1533, table.unpack(v));
                end;

                table_create_ret3[21] = {};

                return function() -- Line: 6607
                    -- upvalues: table_create_ret (ref), u1533 (copy)
                    local table_find_ret = table.find(table_create_ret[21], u1533);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[21], table_find_ret);
                    end;
                end;
            end
        },
        ApplyKillTrackColor = {
            Fire = function(p1534: table) -- Line: 6616, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1535 = u1235;
                local v1536 = os.clock() // 1;

                if v1535.Window ~= v1536 then
                    v1535.Window = v1536;
                    table.clear(v1535.Counts);
                end;

                local v1537 = (v1535.Counts.ApplyKillTrackColor or 0) + 1;
                v1535.Counts.ApplyKillTrackColor = v1537;

                if v1537 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ApplyKillTrackColor(p1534);
            end
        },
        KillTrackColorUpdate = {
            On = function(u1538: function) -- Line: 6622, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[23], u1538);

                for _, v in table_create_ret3[23] do
                    task.spawn(u1538, table.unpack(v));
                end;

                table_create_ret3[23] = {};

                return function() -- Line: 6628
                    -- upvalues: table_create_ret (ref), u1538 (copy)
                    local table_find_ret = table.find(table_create_ret[23], u1538);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[23], table_find_ret);
                    end;
                end;
            end
        },
        BuyFuserScroll = {
            Fire = function(p1539: table) -- Line: 6637, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1540 = u1235;
                local v1541 = os.clock() // 1;

                if v1540.Window ~= v1541 then
                    v1540.Window = v1541;
                    table.clear(v1540.Counts);
                end;

                local v1542 = (v1540.Counts.BuyFuserScroll or 0) + 1;
                v1540.Counts.BuyFuserScroll = v1542;

                if v1542 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyFuserScroll(p1539);
            end
        },
        FuserScrollsUpdate = {
            On = function(u1543: function) -- Line: 6643, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[25] = u1543;

                for _, v in table_create_ret3[25] do
                    task.spawn(u1543, table.unpack(v));
                end;

                table_create_ret3[25] = {};

                return function() -- Line: 6649
                    -- upvalues: table_create_ret (ref), u1543 (copy)
                    if table_create_ret[25] == u1543 then
                        table_create_ret[25] = nil;
                    end;
                end;
            end
        },
        AnalyticsUpdate = {
            On = function(u1544: function) -- Line: 6657, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[26] = u1544;

                for _, v in table_create_ret3[26] do
                    u1544(table.unpack(v));
                end;

                table_create_ret3[26] = {};

                return function() -- Line: 6663
                    -- upvalues: table_create_ret (ref), u1544 (copy)
                    if table_create_ret[26] == u1544 then
                        table_create_ret[26] = nil;
                    end;
                end;
            end
        },
        RequestMatch = {
            Fire = function(p1545: number) -- Line: 6671, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1546 = u1235;
                local v1547 = os.clock() // 1;

                if v1546.Window ~= v1547 then
                    v1546.Window = v1547;
                    table.clear(v1546.Counts);
                end;

                local v1548 = (v1546.Counts.RequestMatch or 0) + 1;
                v1546.Counts.RequestMatch = v1548;

                if v1548 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RequestMatch(p1545);
            end
        },
        MatchData = {
            On = function(u1549: function) -- Line: 6677, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[28] = u1549;

                for _, v in table_create_ret3[28] do
                    u1549(table.unpack(v));
                end;

                table_create_ret3[28] = {};

                return function() -- Line: 6683
                    -- upvalues: table_create_ret (ref), u1549 (copy)
                    if table_create_ret[28] == u1549 then
                        table_create_ret[28] = nil;
                    end;
                end;
            end
        },
        ApplyNameTag = {
            Fire = function(p1550: table) -- Line: 6691, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1551 = u1235;
                local v1552 = os.clock() // 1;

                if v1551.Window ~= v1552 then
                    v1551.Window = v1552;
                    table.clear(v1551.Counts);
                end;

                local v1553 = (v1551.Counts.ApplyNameTag or 0) + 1;
                v1551.Counts.ApplyNameTag = v1553;

                if v1553 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ApplyNameTag(p1550);
            end
        },
        RemoveNameTag = {
            Fire = function(p1554: table) -- Line: 6697, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1555 = u1235;
                local v1556 = os.clock() // 1;

                if v1555.Window ~= v1556 then
                    v1555.Window = v1556;
                    table.clear(v1555.Counts);
                end;

                local v1557 = (v1555.Counts.RemoveNameTag or 0) + 1;
                v1555.Counts.RemoveNameTag = v1557;

                if v1557 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RemoveNameTag(p1554);
            end
        },
        ApplyKillTrack = {
            Fire = function(p1558: table) -- Line: 6703, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1559 = u1235;
                local v1560 = os.clock() // 1;

                if v1559.Window ~= v1560 then
                    v1559.Window = v1560;
                    table.clear(v1559.Counts);
                end;

                local v1561 = (v1559.Counts.ApplyKillTrack or 0) + 1;
                v1559.Counts.ApplyKillTrack = v1561;

                if v1561 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ApplyKillTrack(p1558);
            end
        },
        KillTrackUpdate = {
            On = function(u1562: function) -- Line: 6709, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[32], u1562);

                for _, v in table_create_ret3[32] do
                    task.spawn(u1562, table.unpack(v));
                end;

                table_create_ret3[32] = {};

                return function() -- Line: 6715
                    -- upvalues: table_create_ret (ref), u1562 (copy)
                    local table_find_ret = table.find(table_create_ret[32], u1562);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[32], table_find_ret);
                    end;
                end;
            end
        },
        RemoveKillTrack = {
            Fire = function(p1563: table) -- Line: 6724, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1564 = u1235;
                local v1565 = os.clock() // 1;

                if v1564.Window ~= v1565 then
                    v1564.Window = v1565;
                    table.clear(v1564.Counts);
                end;

                local v1566 = (v1564.Counts.RemoveKillTrack or 0) + 1;
                v1564.Counts.RemoveKillTrack = v1566;

                if v1566 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RemoveKillTrack(p1563);
            end
        },
        RequestServerList = {
            Fire = function(p1567) -- Line: 6730, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1568 = u1235;
                local v1569 = os.clock() // 1;

                if v1568.Window ~= v1569 then
                    v1568.Window = v1569;
                    table.clear(v1568.Counts);
                end;

                local v1570 = (v1568.Counts.RequestServerList or 0) + 1;
                v1568.Counts.RequestServerList = v1570;

                if v1570 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RequestServerList(p1567);
            end
        },
        ServerListResult = {
            On = function(u1571: function) -- Line: 6736, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[35] = u1571;

                for _, v in table_create_ret3[35] do
                    task.spawn(u1571, table.unpack(v));
                end;

                table_create_ret3[35] = {};

                return function() -- Line: 6742
                    -- upvalues: table_create_ret (ref), u1571 (copy)
                    if table_create_ret[35] == u1571 then
                        table_create_ret[35] = nil;
                    end;
                end;
            end
        },
        RequestProfileBadges = {
            Fire = function(p1572: number) -- Line: 6750, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1573 = u1235;
                local v1574 = os.clock() // 1;

                if v1573.Window ~= v1574 then
                    v1573.Window = v1574;
                    table.clear(v1573.Counts);
                end;

                local v1575 = (v1573.Counts.RequestProfileBadges or 0) + 1;
                v1573.Counts.RequestProfileBadges = v1575;

                if v1575 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RequestProfileBadges(p1572);
            end
        },
        ProfileBadges = {
            On = function(u1576: function) -- Line: 6756, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[37] = u1576;

                for _, v in table_create_ret3[37] do
                    u1576(table.unpack(v));
                end;

                table_create_ret3[37] = {};

                return function() -- Line: 6762
                    -- upvalues: table_create_ret (ref), u1576 (copy)
                    if table_create_ret[37] == u1576 then
                        table_create_ret[37] = nil;
                    end;
                end;
            end
        },
        MatchEndStats = {
            On = function(u1577: function) -- Line: 6770, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[38] = u1577;

                for _, v in table_create_ret3[38] do
                    task.spawn(u1577, table.unpack(v));
                end;

                table_create_ret3[38] = {};

                return function() -- Line: 6776
                    -- upvalues: table_create_ret (ref), u1577 (copy)
                    if table_create_ret[38] == u1577 then
                        table_create_ret[38] = nil;
                    end;
                end;
            end
        },
        NewContainerMessage = {
            On = function(u1578: function) -- Line: 6784, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[39] = u1578;

                for _, v in table_create_ret3[39] do
                    u1578(table.unpack(v));
                end;

                table_create_ret3[39] = {};

                return function() -- Line: 6790
                    -- upvalues: table_create_ret (ref), u1578 (copy)
                    if table_create_ret[39] == u1578 then
                        table_create_ret[39] = nil;
                    end;
                end;
            end
        },
        GlobalMessage = {
            On = function(u1579: function) -- Line: 6798, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[40] = u1579;

                for _, v in table_create_ret3[40] do
                    u1579(table.unpack(v));
                end;

                table_create_ret3[40] = {};

                return function() -- Line: 6804
                    -- upvalues: table_create_ret (ref), u1579 (copy)
                    if table_create_ret[40] == u1579 then
                        table_create_ret[40] = nil;
                    end;
                end;
            end
        },
        NewMessage = {
            On = function(u1580: function) -- Line: 6812, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[41] = u1580;

                for _, v in table_create_ret3[41] do
                    u1580(table.unpack(v));
                end;

                table_create_ret3[41] = {};

                return function() -- Line: 6818
                    -- upvalues: table_create_ret (ref), u1580 (copy)
                    if table_create_ret[41] == u1580 then
                        table_create_ret[41] = nil;
                    end;
                end;
            end
        },
        NewMessageTeam = {
            On = function(u1581: function) -- Line: 6826, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[42] = u1581;

                for _, v in table_create_ret3[42] do
                    u1581(table.unpack(v));
                end;

                table_create_ret3[42] = {};

                return function() -- Line: 6832
                    -- upvalues: table_create_ret (ref), u1581 (copy)
                    if table_create_ret[42] == u1581 then
                        table_create_ret[42] = nil;
                    end;
                end;
            end
        },
        NewAwardMessage = {
            On = function(u1582: function) -- Line: 6840, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[43] = u1582;

                for _, v in table_create_ret3[43] do
                    u1582(table.unpack(v));
                end;

                table_create_ret3[43] = {};

                return function() -- Line: 6846
                    -- upvalues: table_create_ret (ref), u1582 (copy)
                    if table_create_ret[43] == u1582 then
                        table_create_ret[43] = nil;
                    end;
                end;
            end
        },
        GiftGamepass = {
            Fire = function(p1583: table) -- Line: 6854, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1584 = u1235;
                local v1585 = os.clock() // 1;

                if v1584.Window ~= v1585 then
                    v1584.Window = v1585;
                    table.clear(v1584.Counts);
                end;

                local v1586 = (v1584.Counts.GiftGamepass or 0) + 1;
                v1584.Counts.GiftGamepass = v1586;

                if v1586 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_GiftGamepass(p1583);
            end
        },
        LeftArm = {
            Fire = function(p1587: boolean) -- Line: 6860, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1588 = u1235;
                local v1589 = os.clock() // 1;

                if v1588.Window ~= v1589 then
                    v1588.Window = v1589;
                    table.clear(v1588.Counts);
                end;

                local v1590 = (v1588.Counts.LeftArm or 0) + 1;
                v1588.Counts.LeftArm = v1590;

                if v1590 > 30 then
                    return;
                end;

                u1.Gui_WriteEVENT_LeftArm(p1587);
            end
        },
        DamageIndicator = {
            On = function(u1591: function) -- Line: 6866, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[46] = u1591;

                for _, v in table_create_ret3[46] do
                    task.spawn(u1591, table.unpack(v));
                end;

                table_create_ret3[46] = {};

                return function() -- Line: 6872
                    -- upvalues: table_create_ret (ref), u1591 (copy)
                    if table_create_ret[46] == u1591 then
                        table_create_ret[46] = nil;
                    end;
                end;
            end
        },
        BuyGamepass = {
            Fire = function(p1592: number) -- Line: 6880, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1593 = u1235;
                local v1594 = os.clock() // 1;

                if v1593.Window ~= v1594 then
                    v1593.Window = v1594;
                    table.clear(v1593.Counts);
                end;

                local v1595 = (v1593.Counts.BuyGamepass or 0) + 1;
                v1593.Counts.BuyGamepass = v1595;

                if v1595 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyGamepass(p1592);
            end
        },
        MenuNotification = {
            On = function(u1596: function) -- Line: 6886, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[48] = u1596;

                for _, v in table_create_ret3[48] do
                    task.spawn(u1596, table.unpack(v));
                end;

                table_create_ret3[48] = {};

                return function() -- Line: 6892
                    -- upvalues: table_create_ret (ref), u1596 (copy)
                    if table_create_ret[48] == u1596 then
                        table_create_ret[48] = nil;
                    end;
                end;
            end
        },
        VotekickPlayer = {
            Fire = function(p1597: table) -- Line: 6900, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1598 = u1235;
                local v1599 = os.clock() // 1;

                if v1598.Window ~= v1599 then
                    v1598.Window = v1599;
                    table.clear(v1598.Counts);
                end;

                local v1600 = (v1598.Counts.VotekickPlayer or 0) + 1;
                v1598.Counts.VotekickPlayer = v1600;

                if v1600 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_VotekickPlayer(p1597);
            end
        },
        Votekick = {
            Fire = function(p1601: boolean) -- Line: 6906, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1602 = u1235;
                local v1603 = os.clock() // 1;

                if v1602.Window ~= v1603 then
                    v1602.Window = v1603;
                    table.clear(v1602.Counts);
                end;

                local v1604 = (v1602.Counts.Votekick or 0) + 1;
                v1602.Counts.Votekick = v1604;

                if v1604 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_Votekick(p1601);
            end
        },
        CopyViewmodel = {
            Fire = function(p1605: number) -- Line: 6912, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1606 = u1235;
                local v1607 = os.clock() // 1;

                if v1606.Window ~= v1607 then
                    v1606.Window = v1607;
                    table.clear(v1606.Counts);
                end;

                local v1608 = (v1606.Counts.CopyViewmodel or 0) + 1;
                v1606.Counts.CopyViewmodel = v1608;

                if v1608 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_CopyViewmodel(p1605);
            end
        },
        CopyCrosshair2 = {
            Fire = function(p1609: string) -- Line: 6918, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1610 = u1235;
                local v1611 = os.clock() // 1;

                if v1610.Window ~= v1611 then
                    v1610.Window = v1611;
                    table.clear(v1610.Counts);
                end;

                local v1612 = (v1610.Counts.CopyCrosshair2 or 0) + 1;
                v1610.Counts.CopyCrosshair2 = v1612;

                if v1612 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_CopyCrosshair2(p1609);
            end
        },
        CopyViewmodel2 = {
            Fire = function(p1613: string) -- Line: 6924, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1614 = u1235;
                local v1615 = os.clock() // 1;

                if v1614.Window ~= v1615 then
                    v1614.Window = v1615;
                    table.clear(v1614.Counts);
                end;

                local v1616 = (v1614.Counts.CopyViewmodel2 or 0) + 1;
                v1614.Counts.CopyViewmodel2 = v1616;

                if v1616 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_CopyViewmodel2(p1613);
            end
        },
        CopyCrosshair = {
            Fire = function(p1617: number) -- Line: 6930, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1618 = u1235;
                local v1619 = os.clock() // 1;

                if v1618.Window ~= v1619 then
                    v1618.Window = v1619;
                    table.clear(v1618.Counts);
                end;

                local v1620 = (v1618.Counts.CopyCrosshair or 0) + 1;
                v1618.Counts.CopyCrosshair = v1620;

                if v1620 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_CopyCrosshair(p1617);
            end
        },
        SelectTeam = {
            Fire = function(p1621: number) -- Line: 6936, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1622 = u1235;
                local v1623 = os.clock() // 1;

                if v1622.Window ~= v1623 then
                    v1622.Window = v1623;
                    table.clear(v1622.Counts);
                end;

                local v1624 = (v1622.Counts.SelectTeam or 0) + 1;
                v1622.Counts.SelectTeam = v1624;

                if v1624 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_SelectTeam(p1621);
            end
        },
        SendMessage = {
            Fire = function(p1625: string) -- Line: 6942, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1626 = u1235;
                local v1627 = os.clock() // 1;

                if v1626.Window ~= v1627 then
                    v1626.Window = v1627;
                    table.clear(v1626.Counts);
                end;

                local v1628 = (v1626.Counts.SendMessage or 0) + 1;
                v1626.Counts.SendMessage = v1628;

                if v1628 > 15 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1629 = u20;

                    for i = #v1629, u19 + 1, -1 do
                        v1629[i] = nil;
                        local _ = i;
                    end;

                    local v1630 = u21;
                    u21 = nil;

                    if u6 == v1629 then
                        if v1630 then
                            Load(v1630);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1631 = u50 or {};
                v1631.Size = u3;
                v1631.Cursor = u5;
                v1631.Buffer = buffer_create_ret;
                v1631.Instances = u6;
                v1631.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1632 = u20;

                    for i = #v1632, u19 + 1, -1 do
                        v1632[i] = nil;
                        local _ = i;
                    end;

                    local v1633 = u21;
                    u21 = nil;

                    if u6 == v1632 then
                        if v1633 then
                            Load(v1633);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1634 = u48;

                if v1634 then
                    v1634.Cursor = 0;
                    table.clear(v1634.Instances);
                    table.clear(v1634.Debug);
                end;

                Load(v1634);
                u1.Gui_WriteEVENT_SendMessage(p1625, v1631);
                local v1635 = u48 or {};
                v1635.Size = u3;
                v1635.Cursor = u5;
                v1635.Buffer = buffer_create_ret;
                v1635.Instances = u6;
                v1635.Debug = u7;
                u48 = v1635;
                local v1636 = u49;
                local v1637 = u5;

                if not v1636 or buffer.len(v1636) ~= v1637 then
                    v1636 = buffer.create(v1637);
                end;

                buffer.copy(v1636, 0, buffer_create_ret, 0, v1637);
                u49 = v1636;
                local v1638 = u49;
                local v1639 = u6;

                if buffer.len(v1638) > 800 then
                    SendFragments(v1638, v1639, 800, FireUnreliableFragment);
                else
                    if #v1639 <= 0 then
                        v1639 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1638, v1639);
                end;

                Load(v1631);
            end
        },
        VoteForMap = {
            Fire = function(p1640: string) -- Line: 6956, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1641 = u1235;
                local v1642 = os.clock() // 1;

                if v1641.Window ~= v1642 then
                    v1641.Window = v1642;
                    table.clear(v1641.Counts);
                end;

                local v1643 = (v1641.Counts.VoteForMap or 0) + 1;
                v1641.Counts.VoteForMap = v1643;

                if v1643 > 15 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1644 = u20;

                    for i = #v1644, u19 + 1, -1 do
                        v1644[i] = nil;
                        local _ = i;
                    end;

                    local v1645 = u21;
                    u21 = nil;

                    if u6 == v1644 then
                        if v1645 then
                            Load(v1645);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1646 = u50 or {};
                v1646.Size = u3;
                v1646.Cursor = u5;
                v1646.Buffer = buffer_create_ret;
                v1646.Instances = u6;
                v1646.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1647 = u20;

                    for i = #v1647, u19 + 1, -1 do
                        v1647[i] = nil;
                        local _ = i;
                    end;

                    local v1648 = u21;
                    u21 = nil;

                    if u6 == v1647 then
                        if v1648 then
                            Load(v1648);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1649 = u48;

                if v1649 then
                    v1649.Cursor = 0;
                    table.clear(v1649.Instances);
                    table.clear(v1649.Debug);
                end;

                Load(v1649);
                u1.Gui_WriteEVENT_VoteForMap(p1640, v1646);
                local v1650 = u48 or {};
                v1650.Size = u3;
                v1650.Cursor = u5;
                v1650.Buffer = buffer_create_ret;
                v1650.Instances = u6;
                v1650.Debug = u7;
                u48 = v1650;
                local v1651 = u49;
                local v1652 = u5;

                if not v1651 or buffer.len(v1651) ~= v1652 then
                    v1651 = buffer.create(v1652);
                end;

                buffer.copy(v1651, 0, buffer_create_ret, 0, v1652);
                u49 = v1651;
                local v1653 = u49;
                local v1654 = u6;

                if buffer.len(v1653) > 800 then
                    SendFragments(v1653, v1654, 800, FireUnreliableFragment);
                else
                    if #v1654 <= 0 then
                        v1654 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1653, v1654);
                end;

                Load(v1646);
            end
        },
        Ping = {
            On = function(u1655: function) -- Line: 6970, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[6] = u1655;

                return function() -- Line: 6972
                    -- upvalues: table_create_ret2 (ref), u1655 (copy)
                    if table_create_ret2[6] == u1655 then
                        table_create_ret2[6] = nil;
                    end;
                end;
            end
        },
        SendTeamMessage = {
            Fire = function(p1656: string) -- Line: 6980, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1657 = u1235;
                local v1658 = os.clock() // 1;

                if v1657.Window ~= v1658 then
                    v1657.Window = v1658;
                    table.clear(v1657.Counts);
                end;

                local v1659 = (v1657.Counts.SendTeamMessage or 0) + 1;
                v1657.Counts.SendTeamMessage = v1659;

                if v1659 > 5 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1660 = u20;

                    for i = #v1660, u19 + 1, -1 do
                        v1660[i] = nil;
                        local _ = i;
                    end;

                    local v1661 = u21;
                    u21 = nil;

                    if u6 == v1660 then
                        if v1661 then
                            Load(v1661);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1662 = u50 or {};
                v1662.Size = u3;
                v1662.Cursor = u5;
                v1662.Buffer = buffer_create_ret;
                v1662.Instances = u6;
                v1662.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1663 = u20;

                    for i = #v1663, u19 + 1, -1 do
                        v1663[i] = nil;
                        local _ = i;
                    end;

                    local v1664 = u21;
                    u21 = nil;

                    if u6 == v1663 then
                        if v1664 then
                            Load(v1664);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1665 = u48;

                if v1665 then
                    v1665.Cursor = 0;
                    table.clear(v1665.Instances);
                    table.clear(v1665.Debug);
                end;

                Load(v1665);
                u1.Gui_WriteEVENT_SendTeamMessage(p1656, v1662);
                local v1666 = u48 or {};
                v1666.Size = u3;
                v1666.Cursor = u5;
                v1666.Buffer = buffer_create_ret;
                v1666.Instances = u6;
                v1666.Debug = u7;
                u48 = v1666;
                local v1667 = u49;
                local v1668 = u5;

                if not v1667 or buffer.len(v1667) ~= v1668 then
                    v1667 = buffer.create(v1668);
                end;

                buffer.copy(v1667, 0, buffer_create_ret, 0, v1668);
                u49 = v1667;
                local v1669 = u49;
                local v1670 = u6;

                if buffer.len(v1669) > 800 then
                    SendFragments(v1669, v1670, 800, FireUnreliableFragment);
                else
                    if #v1670 <= 0 then
                        v1670 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1669, v1670);
                end;

                Load(v1662);
            end
        },
        SelectMapPreset = {
            Fire = function(p1671: table) -- Line: 6994, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1672 = u1235;
                local v1673 = os.clock() // 1;

                if v1672.Window ~= v1673 then
                    v1672.Window = v1673;
                    table.clear(v1672.Counts);
                end;

                local v1674 = (v1672.Counts.SelectMapPreset or 0) + 1;
                v1672.Counts.SelectMapPreset = v1674;

                if v1674 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_SelectMapPreset(p1671);
            end
        },
        MobileControls = {
            Fire = function(p1675: table) -- Line: 7000, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1676 = u1235;
                local v1677 = os.clock() // 1;

                if v1676.Window ~= v1677 then
                    v1676.Window = v1677;
                    table.clear(v1676.Counts);
                end;

                local v1678 = (v1676.Counts.MobileControls or 0) + 1;
                v1676.Counts.MobileControls = v1678;

                if v1678 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_MobileControls(p1675);
            end
        },
        ClaimBattlepassReward = {
            Fire = function(p1679: table) -- Line: 7006, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1680 = u1235;
                local v1681 = os.clock() // 1;

                if v1680.Window ~= v1681 then
                    v1680.Window = v1681;
                    table.clear(v1680.Counts);
                end;

                local v1682 = (v1680.Counts.ClaimBattlepassReward or 0) + 1;
                v1680.Counts.ClaimBattlepassReward = v1682;

                if v1682 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimBattlepassReward(p1679);
            end
        },
        ClaimAllBattlepassRewards = {
            Fire = function(p1683) -- Line: 7012, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1684 = u1235;
                local v1685 = os.clock() // 1;

                if v1684.Window ~= v1685 then
                    v1684.Window = v1685;
                    table.clear(v1684.Counts);
                end;

                local v1686 = (v1684.Counts.ClaimAllBattlepassRewards or 0) + 1;
                v1684.Counts.ClaimAllBattlepassRewards = v1686;

                if v1686 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimAllBattlepassRewards(p1683);
            end
        },
        BuyBattlepass = {
            Fire = function(p1687: number) -- Line: 7018, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1688 = u1235;
                local v1689 = os.clock() // 1;

                if v1688.Window ~= v1689 then
                    v1688.Window = v1689;
                    table.clear(v1688.Counts);
                end;

                local v1690 = (v1688.Counts.BuyBattlepass or 0) + 1;
                v1688.Counts.BuyBattlepass = v1690;

                if v1690 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyBattlepass(p1687);
            end
        },
        BuyBundle = {
            Fire = function(p1691: number) -- Line: 7024, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1692 = u1235;
                local v1693 = os.clock() // 1;

                if v1692.Window ~= v1693 then
                    v1692.Window = v1693;
                    table.clear(v1692.Counts);
                end;

                local v1694 = (v1692.Counts.BuyBundle or 0) + 1;
                v1692.Counts.BuyBundle = v1694;

                if v1694 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyBundle(p1691);
            end
        },
        BuyBundleItem = {
            Fire = function(p1695: table) -- Line: 7030, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1696 = u1235;
                local v1697 = os.clock() // 1;

                if v1696.Window ~= v1697 then
                    v1696.Window = v1697;
                    table.clear(v1696.Counts);
                end;

                local v1698 = (v1696.Counts.BuyBundleItem or 0) + 1;
                v1696.Counts.BuyBundleItem = v1698;

                if v1698 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyBundleItem(p1695);
            end
        },
        BuyBattlepassTiers = {
            Fire = function(p1699: number) -- Line: 7036, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1700 = u1235;
                local v1701 = os.clock() // 1;

                if v1700.Window ~= v1701 then
                    v1700.Window = v1701;
                    table.clear(v1700.Counts);
                end;

                local v1702 = (v1700.Counts.BuyBattlepassTiers or 0) + 1;
                v1700.Counts.BuyBattlepassTiers = v1702;

                if v1702 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyBattlepassTiers(p1699);
            end
        },
        ClaimChallengeReward = {
            Fire = function(p1703: table) -- Line: 7042, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1704 = u1235;
                local v1705 = os.clock() // 1;

                if v1704.Window ~= v1705 then
                    v1704.Window = v1705;
                    table.clear(v1704.Counts);
                end;

                local v1706 = (v1704.Counts.ClaimChallengeReward or 0) + 1;
                v1704.Counts.ClaimChallengeReward = v1706;

                if v1706 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimChallengeReward(p1703);
            end
        },
        StartChallenge = {
            Fire = function(p1707: table) -- Line: 7048, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1708 = u1235;
                local v1709 = os.clock() // 1;

                if v1708.Window ~= v1709 then
                    v1708.Window = v1709;
                    table.clear(v1708.Counts);
                end;

                local v1710 = (v1708.Counts.StartChallenge or 0) + 1;
                v1708.Counts.StartChallenge = v1710;

                if v1710 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_StartChallenge(p1707);
            end
        },
        AbandonChallenge = {
            Fire = function(p1711: table) -- Line: 7054, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1712 = u1235;
                local v1713 = os.clock() // 1;

                if v1712.Window ~= v1713 then
                    v1712.Window = v1713;
                    table.clear(v1712.Counts);
                end;

                local v1714 = (v1712.Counts.AbandonChallenge or 0) + 1;
                v1712.Counts.AbandonChallenge = v1714;

                if v1714 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_AbandonChallenge(p1711);
            end
        },
        TradeUp = {
            Fire = function(p1715: table) -- Line: 7060, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1716 = u1235;
                local v1717 = os.clock() // 1;

                if v1716.Window ~= v1717 then
                    v1716.Window = v1717;
                    table.clear(v1716.Counts);
                end;

                local v1718 = (v1716.Counts.TradeUp or 0) + 1;
                v1716.Counts.TradeUp = v1718;

                if v1718 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_TradeUp(p1715);
            end
        },
        Upgrade = {
            Fire = function(p1719: table) -- Line: 7066, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1720 = u1235;
                local v1721 = os.clock() // 1;

                if v1720.Window ~= v1721 then
                    v1720.Window = v1721;
                    table.clear(v1720.Counts);
                end;

                local v1722 = (v1720.Counts.Upgrade or 0) + 1;
                v1720.Counts.Upgrade = v1722;

                if v1722 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_Upgrade(p1719);
            end
        },
        UpgradeResult = {
            On = function(u1723: function) -- Line: 7072, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[69] = u1723;

                for _, v in table_create_ret3[69] do
                    u1723(table.unpack(v));
                end;

                table_create_ret3[69] = {};

                return function() -- Line: 7078
                    -- upvalues: table_create_ret (ref), u1723 (copy)
                    if table_create_ret[69] == u1723 then
                        table_create_ret[69] = nil;
                    end;
                end;
            end
        },
        ApplySticker = {
            Fire = function(p1724: table) -- Line: 7086, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1725 = u1235;
                local v1726 = os.clock() // 1;

                if v1725.Window ~= v1726 then
                    v1725.Window = v1726;
                    table.clear(v1725.Counts);
                end;

                local v1727 = (v1725.Counts.ApplySticker or 0) + 1;
                v1725.Counts.ApplySticker = v1727;

                if v1727 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ApplySticker(p1724);
            end
        },
        RemoveSticker = {
            Fire = function(p1728: table) -- Line: 7092, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1729 = u1235;
                local v1730 = os.clock() // 1;

                if v1729.Window ~= v1730 then
                    v1729.Window = v1730;
                    table.clear(v1729.Counts);
                end;

                local v1731 = (v1729.Counts.RemoveSticker or 0) + 1;
                v1729.Counts.RemoveSticker = v1731;

                if v1731 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RemoveSticker(p1728);
            end
        },
        ClaimCarePackageItems = {
            Fire = function(p1732: table) -- Line: 7098, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1733 = u1235;
                local v1734 = os.clock() // 1;

                if v1733.Window ~= v1734 then
                    v1733.Window = v1734;
                    table.clear(v1733.Counts);
                end;

                local v1735 = (v1733.Counts.ClaimCarePackageItems or 0) + 1;
                v1733.Counts.ClaimCarePackageItems = v1735;

                if v1735 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimCarePackageItems(p1732);
            end
        },
        UsePromocode = {
            Fire = function(p1736: string) -- Line: 7104, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1737 = u1235;
                local v1738 = os.clock() // 1;

                if v1737.Window ~= v1738 then
                    v1737.Window = v1738;
                    table.clear(v1737.Counts);
                end;

                local v1739 = (v1737.Counts.UsePromocode or 0) + 1;
                v1737.Counts.UsePromocode = v1739;

                if v1739 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_UsePromocode(p1736);
            end
        },
        BuyDailyMarketItem = {
            Fire = function(p1740: string) -- Line: 7110, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1741 = u1235;
                local v1742 = os.clock() // 1;

                if v1741.Window ~= v1742 then
                    v1741.Window = v1742;
                    table.clear(v1741.Counts);
                end;

                local v1743 = (v1741.Counts.BuyDailyMarketItem or 0) + 1;
                v1741.Counts.BuyDailyMarketItem = v1743;

                if v1743 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyDailyMarketItem(p1740);
            end
        },
        RevealMarketItem = {
            Fire = function(p1744: string) -- Line: 7116, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1745 = u1235;
                local v1746 = os.clock() // 1;

                if v1745.Window ~= v1746 then
                    v1745.Window = v1746;
                    table.clear(v1745.Counts);
                end;

                local v1747 = (v1745.Counts.RevealMarketItem or 0) + 1;
                v1745.Counts.RevealMarketItem = v1747;

                if v1747 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_RevealMarketItem(p1744);
            end
        },
        ClaimAchievementReward = {
            Fire = function(p1748: string) -- Line: 7122, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1749 = u1235;
                local v1750 = os.clock() // 1;

                if v1749.Window ~= v1750 then
                    v1749.Window = v1750;
                    table.clear(v1749.Counts);
                end;

                local v1751 = (v1749.Counts.ClaimAchievementReward or 0) + 1;
                v1749.Counts.ClaimAchievementReward = v1751;

                if v1751 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimAchievementReward(p1748);
            end
        },
        ChangePlayerSetting = {
            Fire = function(p1752: table) -- Line: 7128, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1753 = u1235;
                local v1754 = os.clock() // 1;

                if v1753.Window ~= v1754 then
                    v1753.Window = v1754;
                    table.clear(v1753.Counts);
                end;

                local v1755 = (v1753.Counts.ChangePlayerSetting or 0) + 1;
                v1753.Counts.ChangePlayerSetting = v1755;

                if v1755 > 30 then
                    return;
                end;

                u1.Gui_WriteEVENT_ChangePlayerSetting(p1752);
            end
        },
        ResetPlayerSettings = {
            Fire = function(p1756) -- Line: 7134, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1757 = u1235;
                local v1758 = os.clock() // 1;

                if v1757.Window ~= v1758 then
                    v1757.Window = v1758;
                    table.clear(v1757.Counts);
                end;

                local v1759 = (v1757.Counts.ResetPlayerSettings or 0) + 1;
                v1757.Counts.ResetPlayerSettings = v1759;

                if v1759 > 240 then
                    return;
                end;

                u1.Gui_WriteEVENT_ResetPlayerSettings(p1756);
            end
        },
        ChangeLoadoutWeapon = {
            Fire = function(p1760: table) -- Line: 7140, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1761 = u1235;
                local v1762 = os.clock() // 1;

                if v1761.Window ~= v1762 then
                    v1761.Window = v1762;
                    table.clear(v1761.Counts);
                end;

                local v1763 = (v1761.Counts.ChangeLoadoutWeapon or 0) + 1;
                v1761.Counts.ChangeLoadoutWeapon = v1763;

                if v1763 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ChangeLoadoutWeapon(p1760);
            end
        },
        BuyStoreItem = {
            Fire = function(p1764: table) -- Line: 7146, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1765 = u1235;
                local v1766 = os.clock() // 1;

                if v1765.Window ~= v1766 then
                    v1765.Window = v1766;
                    table.clear(v1765.Counts);
                end;

                local v1767 = (v1765.Counts.BuyStoreItem or 0) + 1;
                v1765.Counts.BuyStoreItem = v1767;

                if v1767 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_BuyStoreItem(p1764);
            end
        },
        OpenContainer = {
            Fire = function(p1768: table) -- Line: 7152, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1769 = u1235;
                local v1770 = os.clock() // 1;

                if v1769.Window ~= v1770 then
                    v1769.Window = v1770;
                    table.clear(v1769.Counts);
                end;

                local v1771 = (v1769.Counts.OpenContainer or 0) + 1;
                v1769.Counts.OpenContainer = v1771;

                if v1771 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_OpenContainer(p1768);
            end
        },
        OpenContainerResult = {
            On = function(u1772: function) -- Line: 7158, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[82] = u1772;

                for _, v in table_create_ret3[82] do
                    task.spawn(u1772, table.unpack(v));
                end;

                table_create_ret3[82] = {};

                return function() -- Line: 7164
                    -- upvalues: table_create_ret (ref), u1772 (copy)
                    if table_create_ret[82] == u1772 then
                        table_create_ret[82] = nil;
                    end;
                end;
            end
        },
        ClaimPlaytimeReward = {
            Fire = function(p1773: number) -- Line: 7172, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1774 = u1235;
                local v1775 = os.clock() // 1;

                if v1774.Window ~= v1775 then
                    v1774.Window = v1775;
                    table.clear(v1774.Counts);
                end;

                local v1776 = (v1774.Counts.ClaimPlaytimeReward or 0) + 1;
                v1774.Counts.ClaimPlaytimeReward = v1776;

                if v1776 > 5 then
                    return;
                end;

                u1.Gui_WriteEVENT_ClaimPlaytimeReward(p1773);
            end
        },
        KillfeedUpdate = {
            On = function(u1777: function) -- Line: 7178, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[84] = u1777;

                for _, v in table_create_ret3[84] do
                    u1777(table.unpack(v));
                end;

                table_create_ret3[84] = {};

                return function() -- Line: 7184
                    -- upvalues: table_create_ret (ref), u1777 (copy)
                    if table_create_ret[84] == u1777 then
                        table_create_ret[84] = nil;
                    end;
                end;
            end
        },
        DiedUpdate = {
            On = function(u1778: function) -- Line: 7192, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[85], u1778);

                for _, v in table_create_ret3[85] do
                    u1778(table.unpack(v));
                end;

                table_create_ret3[85] = {};

                return function() -- Line: 7198
                    -- upvalues: table_create_ret (ref), u1778 (copy)
                    local table_find_ret = table.find(table_create_ret[85], u1778);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[85], table_find_ret);
                    end;
                end;
            end
        },
        MVPUpdate = {
            On = function(u1779: function) -- Line: 7207, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[86] = u1779;

                for _, v in table_create_ret3[86] do
                    u1779(table.unpack(v));
                end;

                table_create_ret3[86] = {};

                return function() -- Line: 7213
                    -- upvalues: table_create_ret (ref), u1779 (copy)
                    if table_create_ret[86] == u1779 then
                        table_create_ret[86] = nil;
                    end;
                end;
            end
        },
        InventoryUpdate = {
            On = function(u1780: function) -- Line: 7221, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table.insert(table_create_ret[87], u1780);

                for _, v in table_create_ret3[87] do
                    u1780(table.unpack(v));
                end;

                table_create_ret3[87] = {};

                return function() -- Line: 7227
                    -- upvalues: table_create_ret (ref), u1780 (copy)
                    local table_find_ret = table.find(table_create_ret[87], u1780);

                    if table_find_ret ~= nil then
                        table.remove(table_create_ret[87], table_find_ret);
                    end;
                end;
            end
        },
        InventoryAdd = {
            On = function(u1781: function) -- Line: 7236, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[88] = u1781;

                for _, v in table_create_ret3[88] do
                    u1781(table.unpack(v));
                end;

                table_create_ret3[88] = {};

                return function() -- Line: 7242
                    -- upvalues: table_create_ret (ref), u1781 (copy)
                    if table_create_ret[88] == u1781 then
                        table_create_ret[88] = nil;
                    end;
                end;
            end
        },
        InventoryRemove = {
            On = function(u1782: function) -- Line: 7250, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[89] = u1782;

                for _, v in table_create_ret3[89] do
                    u1782(table.unpack(v));
                end;

                table_create_ret3[89] = {};

                return function() -- Line: 7256
                    -- upvalues: table_create_ret (ref), u1782 (copy)
                    if table_create_ret[89] == u1782 then
                        table_create_ret[89] = nil;
                    end;
                end;
            end
        },
        InventoryEquip = {
            On = function(u1783: function) -- Line: 7264, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[90] = u1783;

                for _, v in table_create_ret3[90] do
                    u1783(table.unpack(v));
                end;

                table_create_ret3[90] = {};

                return function() -- Line: 7270
                    -- upvalues: table_create_ret (ref), u1783 (copy)
                    if table_create_ret[90] == u1783 then
                        table_create_ret[90] = nil;
                    end;
                end;
            end
        },
        PlayerStatsUpdate = {
            On = function(u1784: function) -- Line: 7278, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[91] = u1784;

                for _, v in table_create_ret3[91] do
                    task.spawn(u1784, table.unpack(v));
                end;

                table_create_ret3[91] = {};

                return function() -- Line: 7284
                    -- upvalues: table_create_ret (ref), u1784 (copy)
                    if table_create_ret[91] == u1784 then
                        table_create_ret[91] = nil;
                    end;
                end;
            end
        },
        PlaytimeUpdate = {
            On = function(u1785: function) -- Line: 7292, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[92] = u1785;

                for _, v in table_create_ret3[92] do
                    task.spawn(u1785, table.unpack(v));
                end;

                table_create_ret3[92] = {};

                return function() -- Line: 7298
                    -- upvalues: table_create_ret (ref), u1785 (copy)
                    if table_create_ret[92] == u1785 then
                        table_create_ret[92] = nil;
                    end;
                end;
            end
        },
        PlaytimeRewardsCollectedUpdate = {
            On = function(u1786: function) -- Line: 7306, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[93] = u1786;

                for _, v in table_create_ret3[93] do
                    task.spawn(u1786, table.unpack(v));
                end;

                table_create_ret3[93] = {};

                return function() -- Line: 7312
                    -- upvalues: table_create_ret (ref), u1786 (copy)
                    if table_create_ret[93] == u1786 then
                        table_create_ret[93] = nil;
                    end;
                end;
            end
        },
        UsedCodesUpdate = {
            On = function(u1787: function) -- Line: 7320, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[94] = u1787;

                for _, v in table_create_ret3[94] do
                    task.spawn(u1787, table.unpack(v));
                end;

                table_create_ret3[94] = {};

                return function() -- Line: 7326
                    -- upvalues: table_create_ret (ref), u1787 (copy)
                    if table_create_ret[94] == u1787 then
                        table_create_ret[94] = nil;
                    end;
                end;
            end
        },
        CollectedAchievementsUpdate = {
            On = function(u1788: function) -- Line: 7334, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[95] = u1788;

                for _, v in table_create_ret3[95] do
                    task.spawn(u1788, table.unpack(v));
                end;

                table_create_ret3[95] = {};

                return function() -- Line: 7340
                    -- upvalues: table_create_ret (ref), u1788 (copy)
                    if table_create_ret[95] == u1788 then
                        table_create_ret[95] = nil;
                    end;
                end;
            end
        },
        GamepassesUpdate = {
            On = function(u1789: function) -- Line: 7348, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[96] = u1789;

                for _, v in table_create_ret3[96] do
                    task.spawn(u1789, table.unpack(v));
                end;

                table_create_ret3[96] = {};

                return function() -- Line: 7354
                    -- upvalues: table_create_ret (ref), u1789 (copy)
                    if table_create_ret[96] == u1789 then
                        table_create_ret[96] = nil;
                    end;
                end;
            end
        },
        ChallengesUpdate = {
            On = function(u1790: function) -- Line: 7362, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[97] = u1790;

                for _, v in table_create_ret3[97] do
                    task.spawn(u1790, table.unpack(v));
                end;

                table_create_ret3[97] = {};

                return function() -- Line: 7368
                    -- upvalues: table_create_ret (ref), u1790 (copy)
                    if table_create_ret[97] == u1790 then
                        table_create_ret[97] = nil;
                    end;
                end;
            end
        },
        BattlepassUpdate = {
            On = function(u1791: function) -- Line: 7376, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[98] = u1791;

                for _, v in table_create_ret3[98] do
                    task.spawn(u1791, table.unpack(v));
                end;

                table_create_ret3[98] = {};

                return function() -- Line: 7382
                    -- upvalues: table_create_ret (ref), u1791 (copy)
                    if table_create_ret[98] == u1791 then
                        table_create_ret[98] = nil;
                    end;
                end;
            end
        },
        CreditsUpdate = {
            On = function(u1792: function) -- Line: 7390, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[99] = u1792;

                for _, v in table_create_ret3[99] do
                    task.spawn(u1792, table.unpack(v));
                end;

                table_create_ret3[99] = {};

                return function() -- Line: 7396
                    -- upvalues: table_create_ret (ref), u1792 (copy)
                    if table_create_ret[99] == u1792 then
                        table_create_ret[99] = nil;
                    end;
                end;
            end
        }
    },
    Entity = {
        RequestFullUpdate = {
            Fire = function(p1793: number) -- Line: 7406, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1794 = u1235;
                local v1795 = os.clock() // 1;

                if v1794.Window ~= v1795 then
                    v1794.Window = v1795;
                    table.clear(v1794.Counts);
                end;

                local v1796 = (v1794.Counts.RequestFullUpdate or 0) + 1;
                v1794.Counts.RequestFullUpdate = v1796;

                if v1796 > 500 then
                    return;
                end;

                u1.Entity_WriteEVENT_RequestFullUpdate(p1793);
            end
        },
        AckSnapshot = {
            Fire = function(p1797: number) -- Line: 7412, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1798 = u1235;
                local v1799 = os.clock() // 1;

                if v1798.Window ~= v1799 then
                    v1798.Window = v1799;
                    table.clear(v1798.Counts);
                end;

                local v1800 = (v1798.Counts.AckSnapshot or 0) + 1;
                v1798.Counts.AckSnapshot = v1800;

                if v1800 > 500 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1801 = u20;

                    for i = #v1801, u19 + 1, -1 do
                        v1801[i] = nil;
                        local _ = i;
                    end;

                    local v1802 = u21;
                    u21 = nil;

                    if u6 == v1801 then
                        if v1802 then
                            Load(v1802);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1803 = u50 or {};
                v1803.Size = u3;
                v1803.Cursor = u5;
                v1803.Buffer = buffer_create_ret;
                v1803.Instances = u6;
                v1803.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1804 = u20;

                    for i = #v1804, u19 + 1, -1 do
                        v1804[i] = nil;
                        local _ = i;
                    end;

                    local v1805 = u21;
                    u21 = nil;

                    if u6 == v1804 then
                        if v1805 then
                            Load(v1805);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1806 = u48;

                if v1806 then
                    v1806.Cursor = 0;
                    table.clear(v1806.Instances);
                    table.clear(v1806.Debug);
                end;

                Load(v1806);
                u1.Entity_WriteEVENT_AckSnapshot(p1797, v1803);
                local v1807 = u48 or {};
                v1807.Size = u3;
                v1807.Cursor = u5;
                v1807.Buffer = buffer_create_ret;
                v1807.Instances = u6;
                v1807.Debug = u7;
                u48 = v1807;
                local v1808 = u49;
                local v1809 = u5;

                if not v1808 or buffer.len(v1808) ~= v1809 then
                    v1808 = buffer.create(v1809);
                end;

                buffer.copy(v1808, 0, buffer_create_ret, 0, v1809);
                u49 = v1808;
                local v1810 = u49;
                local v1811 = u6;

                if buffer.len(v1810) > 800 then
                    SendFragments(v1810, v1811, 800, FireUnreliableFragment);
                else
                    if #v1811 <= 0 then
                        v1811 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1810, v1811);
                end;

                Load(v1803);
            end
        },
        EntityVisibility = {
            On = function(u1812: function) -- Line: 7426, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[101] = u1812;

                for _, v in table_create_ret3[101] do
                    u1812(table.unpack(v));
                end;

                table_create_ret3[101] = {};

                return function() -- Line: 7432
                    -- upvalues: table_create_ret (ref), u1812 (copy)
                    if table_create_ret[101] == u1812 then
                        table_create_ret[101] = nil;
                    end;
                end;
            end
        },
        CreateEntity = {
            On = function(u1813: function) -- Line: 7440, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[102] = u1813;

                for _, v in table_create_ret3[102] do
                    task.spawn(u1813, table.unpack(v));
                end;

                table_create_ret3[102] = {};

                return function() -- Line: 7446
                    -- upvalues: table_create_ret (ref), u1813 (copy)
                    if table_create_ret[102] == u1813 then
                        table_create_ret[102] = nil;
                    end;
                end;
            end
        },
        DestroyEntity = {
            On = function(u1814: function) -- Line: 7454, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[103] = u1814;

                for _, v in table_create_ret3[103] do
                    task.spawn(u1814, table.unpack(v));
                end;

                table_create_ret3[103] = {};

                return function() -- Line: 7460
                    -- upvalues: table_create_ret (ref), u1814 (copy)
                    if table_create_ret[103] == u1814 then
                        table_create_ret[103] = nil;
                    end;
                end;
            end
        },
        OnPlayerConnected = {
            On = function(u1815: function) -- Line: 7468, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[104] = u1815;

                for _, v in table_create_ret3[104] do
                    task.spawn(u1815, table.unpack(v));
                end;

                table_create_ret3[104] = {};

                return function() -- Line: 7474
                    -- upvalues: table_create_ret (ref), u1815 (copy)
                    if table_create_ret[104] == u1815 then
                        table_create_ret[104] = nil;
                    end;
                end;
            end
        },
        EntitySnapshot = {
            On = function(u1816: function) -- Line: 7482, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[9] = u1816;

                return function() -- Line: 7484
                    -- upvalues: table_create_ret2 (ref), u1816 (copy)
                    if table_create_ret2[9] == u1816 then
                        table_create_ret2[9] = nil;
                    end;
                end;
            end
        },
        CharacterCurrentWeapon = {
            On = function(u1817: function) -- Line: 7492, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[105] = u1817;

                for _, v in table_create_ret3[105] do
                    u1817(table.unpack(v));
                end;

                table_create_ret3[105] = {};

                return function() -- Line: 7498
                    -- upvalues: table_create_ret (ref), u1817 (copy)
                    if table_create_ret[105] == u1817 then
                        table_create_ret[105] = nil;
                    end;
                end;
            end
        },
        CharacterWeaponInventorySlot = {
            On = function(u1818: function) -- Line: 7506, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[106] = u1818;

                for _, v in table_create_ret3[106] do
                    u1818(table.unpack(v));
                end;

                table_create_ret3[106] = {};

                return function() -- Line: 7512
                    -- upvalues: table_create_ret (ref), u1818 (copy)
                    if table_create_ret[106] == u1818 then
                        table_create_ret[106] = nil;
                    end;
                end;
            end
        },
        CharacterCurrentWeaponInventoryData = {
            On = function(u1819: function) -- Line: 7520, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[10] = u1819;

                return function() -- Line: 7522
                    -- upvalues: table_create_ret2 (ref), u1819 (copy)
                    if table_create_ret2[10] == u1819 then
                        table_create_ret2[10] = nil;
                    end;
                end;
            end
        },
        CharacterDeath = {
            On = function(u1820: function) -- Line: 7530, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[107] = u1820;

                for _, v in table_create_ret3[107] do
                    u1820(table.unpack(v));
                end;

                table_create_ret3[107] = {};

                return function() -- Line: 7536
                    -- upvalues: table_create_ret (ref), u1820 (copy)
                    if table_create_ret[107] == u1820 then
                        table_create_ret[107] = nil;
                    end;
                end;
            end
        }
    },
    Particles = {
        CreateBulletHole = {
            On = function(u1821: function) -- Line: 7546, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[11] = u1821;

                return function() -- Line: 7548
                    -- upvalues: table_create_ret2 (ref), u1821 (copy)
                    if table_create_ret2[11] == u1821 then
                        table_create_ret2[11] = nil;
                    end;
                end;
            end
        },
        CreateTracer = {
            On = function(u1822: function) -- Line: 7556, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[12] = u1822;

                return function() -- Line: 7558
                    -- upvalues: table_create_ret2 (ref), u1822 (copy)
                    if table_create_ret2[12] == u1822 then
                        table_create_ret2[12] = nil;
                    end;
                end;
            end
        },
        CreateRagdoll = {
            On = function(u1823: function) -- Line: 7566, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[108] = u1823;

                for _, v in table_create_ret3[108] do
                    task.spawn(u1823, table.unpack(v));
                end;

                table_create_ret3[108] = {};

                return function() -- Line: 7572
                    -- upvalues: table_create_ret (ref), u1823 (copy)
                    if table_create_ret[108] == u1823 then
                        table_create_ret[108] = nil;
                    end;
                end;
            end
        }
    },
    Spectate = {
        SpectatePosition = {
            Fire = function(p1824: number) -- Line: 7582, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1825 = u1235;
                local v1826 = os.clock() // 1;

                if v1825.Window ~= v1826 then
                    v1825.Window = v1826;
                    table.clear(v1825.Counts);
                end;

                local v1827 = (v1825.Counts.SpectatePosition or 0) + 1;
                v1825.Counts.SpectatePosition = v1827;

                if v1827 > 20 then
                    return;
                end;

                u1.Spectate_WriteEVENT_SpectatePosition(p1824);
            end
        },
        SpectateIdentifier = {
            On = function(u1828: function) -- Line: 7588, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[110] = u1828;

                for _, v in table_create_ret3[110] do
                    u1828(table.unpack(v));
                end;

                table_create_ret3[110] = {};

                return function() -- Line: 7594
                    -- upvalues: table_create_ret (ref), u1828 (copy)
                    if table_create_ret[110] == u1828 then
                        table_create_ret[110] = nil;
                    end;
                end;
            end
        },
        SpectateData = {
            On = function(u1829: function) -- Line: 7602, Name: On
                -- upvalues: table_create_ret2 (copy)
                table_create_ret2[13] = u1829;

                return function() -- Line: 7604
                    -- upvalues: table_create_ret2 (ref), u1829 (copy)
                    if table_create_ret2[13] == u1829 then
                        table_create_ret2[13] = nil;
                    end;
                end;
            end
        },
        AckSpectate = {
            Fire = function(p1830: number) -- Line: 7612, Name: Fire
                -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
                local v1831 = u1235;
                local v1832 = os.clock() // 1;

                if v1831.Window ~= v1832 then
                    v1831.Window = v1832;
                    table.clear(v1831.Counts);
                end;

                local v1833 = (v1831.Counts.AckSpectate or 0) + 1;
                v1831.Counts.AckSpectate = v1833;

                if v1833 > 500 then
                    return;
                end;

                if u17 then
                    u17 = false;
                    local v1834 = u20;

                    for i = #v1834, u19 + 1, -1 do
                        v1834[i] = nil;
                        local _ = i;
                    end;

                    local v1835 = u21;
                    u21 = nil;

                    if u6 == v1834 then
                        if v1835 then
                            Load(v1835);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1836 = u50 or {};
                v1836.Size = u3;
                v1836.Cursor = u5;
                v1836.Buffer = buffer_create_ret;
                v1836.Instances = u6;
                v1836.Debug = u7;

                if u17 then
                    u17 = false;
                    local v1837 = u20;

                    for i = #v1837, u19 + 1, -1 do
                        v1837[i] = nil;
                        local _ = i;
                    end;

                    local v1838 = u21;
                    u21 = nil;

                    if u6 == v1837 then
                        if v1838 then
                            Load(v1838);
                        else
                            u5 = u18;
                            u4 = u18;
                        end;
                    end;
                end;

                local v1839 = u48;

                if v1839 then
                    v1839.Cursor = 0;
                    table.clear(v1839.Instances);
                    table.clear(v1839.Debug);
                end;

                Load(v1839);
                u1.Spectate_WriteEVENT_AckSpectate(p1830, v1836);
                local v1840 = u48 or {};
                v1840.Size = u3;
                v1840.Cursor = u5;
                v1840.Buffer = buffer_create_ret;
                v1840.Instances = u6;
                v1840.Debug = u7;
                u48 = v1840;
                local v1841 = u49;
                local v1842 = u5;

                if not v1841 or buffer.len(v1841) ~= v1842 then
                    v1841 = buffer.create(v1842);
                end;

                buffer.copy(v1841, 0, buffer_create_ret, 0, v1842);
                u49 = v1841;
                local v1843 = u49;
                local v1844 = u6;

                if buffer.len(v1843) > 800 then
                    SendFragments(v1843, v1844, 800, FireUnreliableFragment);
                else
                    if #v1844 <= 0 then
                        v1844 = nil;
                    end;

                    BLINK_UNRELIABLE_REMOTE:FireServer(v1843, v1844);
                end;

                Load(v1836);
            end
        },
        SpectateTarget = {
            Fire = function(p1845: number) -- Line: 7626, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1846 = u1235;
                local v1847 = os.clock() // 1;

                if v1846.Window ~= v1847 then
                    v1846.Window = v1847;
                    table.clear(v1846.Counts);
                end;

                local v1848 = (v1846.Counts.SpectateTarget or 0) + 1;
                v1846.Counts.SpectateTarget = v1848;

                if v1848 > 5 then
                    return;
                end;

                u1.Spectate_WriteEVENT_SpectateTarget(p1845);
            end
        }
    },
    Debug = {
        ShotMarker = {
            On = function(u1849: function) -- Line: 7634, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[112] = u1849;

                for _, v in table_create_ret3[112] do
                    u1849(table.unpack(v));
                end;

                table_create_ret3[112] = {};

                return function() -- Line: 7640
                    -- upvalues: table_create_ret (ref), u1849 (copy)
                    if table_create_ret[112] == u1849 then
                        table_create_ret[112] = nil;
                    end;
                end;
            end
        },
        ServerShot = {
            On = function(u1850: function) -- Line: 7648, Name: On
                -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
                table_create_ret[113] = u1850;

                for _, v in table_create_ret3[113] do
                    u1850(table.unpack(v));
                end;

                table_create_ret3[113] = {};

                return function() -- Line: 7654
                    -- upvalues: table_create_ret (ref), u1850 (copy)
                    if table_create_ret[113] == u1850 then
                        table_create_ret[113] = nil;
                    end;
                end;
            end
        }
    },
    Anticheat = {
        Tattle = {
            Fire = function(p1851: table) -- Line: 7664, Name: Fire
                -- upvalues: u1235 (copy), u1 (copy)
                local v1852 = u1235;
                local v1853 = os.clock() // 1;

                if v1852.Window ~= v1853 then
                    v1852.Window = v1853;
                    table.clear(v1852.Counts);
                end;

                local v1854 = (v1852.Counts.Tattle or 0) + 1;
                v1852.Counts.Tattle = v1854;

                if v1854 > 5 then
                    return;
                end;

                u1.Anticheat_WriteEVENT_Tattle(p1851);
            end
        }
    },
    GenerateCollision = {
        On = function(u1855: function) -- Line: 7671, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[115] = u1855;

            for _, v in table_create_ret3[115] do
                task.spawn(u1855, table.unpack(v));
            end;

            table_create_ret3[115] = {};

            return function() -- Line: 7677
                -- upvalues: table_create_ret (ref), u1855 (copy)
                if table_create_ret[115] == u1855 then
                    table_create_ret[115] = nil;
                end;
            end;
        end
    },
    ConfigChanged = {
        On = function(u1856: function) -- Line: 7685, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[116] = u1856;

            for _, v in table_create_ret3[116] do
                u1856(table.unpack(v));
            end;

            table_create_ret3[116] = {};

            return function() -- Line: 7691
                -- upvalues: table_create_ret (ref), u1856 (copy)
                if table_create_ret[116] == u1856 then
                    table_create_ret[116] = nil;
                end;
            end;
        end
    },
    Console = {
        Fire = function(p1857) -- Line: 7699, Name: Fire
            -- upvalues: u1235 (copy), u1 (copy)
            local v1858 = u1235;
            local v1859 = os.clock() // 1;

            if v1858.Window ~= v1859 then
                v1858.Window = v1859;
                table.clear(v1858.Counts);
            end;

            local v1860 = (v1858.Counts.Console or 0) + 1;
            v1858.Counts.Console = v1860;

            if v1860 > 5 then
                return;
            end;

            u1.WriteEVENT_Console(p1857);
        end
    },
    ConsoleServer = {
        On = function(u1861: function) -- Line: 7705, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[118] = u1861;

            for _, v in table_create_ret3[118] do
                task.spawn(u1861, table.unpack(v));
            end;

            table_create_ret3[118] = {};

            return function() -- Line: 7711
                -- upvalues: table_create_ret (ref), u1861 (copy)
                if table_create_ret[118] == u1861 then
                    table_create_ret[118] = nil;
                end;
            end;
        end
    },
    ServerTick = {
        On = function(u1862: function) -- Line: 7719, Name: On
            -- upvalues: table_create_ret2 (copy)
            table.insert(table_create_ret2[15], u1862);

            return function() -- Line: 7721
                -- upvalues: table_create_ret2 (ref), u1862 (copy)
                local table_find_ret = table.find(table_create_ret2[15], u1862);

                if table_find_ret ~= nil then
                    table.remove(table_create_ret2[15], table_find_ret);
                end;
            end;
        end
    },
    ClientPing = {
        Fire = function(p1863: number) -- Line: 7730, Name: Fire
            -- upvalues: u1235 (copy), u17 (ref), u20 (ref), u19 (ref), u21 (ref), u6 (ref), Load (copy), u5 (ref), u18 (ref), u4 (ref), u50 (copy), u3 (ref), buffer_create_ret (ref), u7 (ref), u48 (ref), u1 (copy), u49 (ref), SendFragments (copy), FireUnreliableFragment (copy), BLINK_UNRELIABLE_REMOTE (copy)
            local v1864 = u1235;
            local v1865 = os.clock() // 1;

            if v1864.Window ~= v1865 then
                v1864.Window = v1865;
                table.clear(v1864.Counts);
            end;

            local v1866 = (v1864.Counts.ClientPing or 0) + 1;
            v1864.Counts.ClientPing = v1866;

            if v1866 > 500 then
                return;
            end;

            if u17 then
                u17 = false;
                local v1867 = u20;

                for i = #v1867, u19 + 1, -1 do
                    v1867[i] = nil;
                    local _ = i;
                end;

                local v1868 = u21;
                u21 = nil;

                if u6 == v1867 then
                    if v1868 then
                        Load(v1868);
                    else
                        u5 = u18;
                        u4 = u18;
                    end;
                end;
            end;

            local v1869 = u50 or {};
            v1869.Size = u3;
            v1869.Cursor = u5;
            v1869.Buffer = buffer_create_ret;
            v1869.Instances = u6;
            v1869.Debug = u7;

            if u17 then
                u17 = false;
                local v1870 = u20;

                for i = #v1870, u19 + 1, -1 do
                    v1870[i] = nil;
                    local _ = i;
                end;

                local v1871 = u21;
                u21 = nil;

                if u6 == v1870 then
                    if v1871 then
                        Load(v1871);
                    else
                        u5 = u18;
                        u4 = u18;
                    end;
                end;
            end;

            local v1872 = u48;

            if v1872 then
                v1872.Cursor = 0;
                table.clear(v1872.Instances);
                table.clear(v1872.Debug);
            end;

            Load(v1872);
            u1.WriteEVENT_ClientPing(p1863, v1869);
            local v1873 = u48 or {};
            v1873.Size = u3;
            v1873.Cursor = u5;
            v1873.Buffer = buffer_create_ret;
            v1873.Instances = u6;
            v1873.Debug = u7;
            u48 = v1873;
            local v1874 = u49;
            local v1875 = u5;

            if not v1874 or buffer.len(v1874) ~= v1875 then
                v1874 = buffer.create(v1875);
            end;

            buffer.copy(v1874, 0, buffer_create_ret, 0, v1875);
            u49 = v1874;
            local v1876 = u49;
            local v1877 = u6;

            if buffer.len(v1876) > 800 then
                SendFragments(v1876, v1877, 800, FireUnreliableFragment);
            else
                if #v1877 <= 0 then
                    v1877 = nil;
                end;

                BLINK_UNRELIABLE_REMOTE:FireServer(v1876, v1877);
            end;

            Load(v1869);
        end
    },
    ServerPing = {
        On = function(u1878: function) -- Line: 7744, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[17] = u1878;

            return function() -- Line: 7746
                -- upvalues: table_create_ret2 (ref), u1878 (copy)
                if table_create_ret2[17] == u1878 then
                    table_create_ret2[17] = nil;
                end;
            end;
        end
    },
    OnMapAdded = {
        On = function(u1879: function) -- Line: 7754, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[119] = u1879;

            for _, v in table_create_ret3[119] do
                task.spawn(u1879, table.unpack(v));
            end;

            table_create_ret3[119] = {};

            return function() -- Line: 7760
                -- upvalues: table_create_ret (ref), u1879 (copy)
                if table_create_ret[119] == u1879 then
                    table_create_ret[119] = nil;
                end;
            end;
        end
    },
    OnMapRemoving = {
        On = function(u1880: function) -- Line: 7768, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[120] = u1880;

            for _, v in table_create_ret3[120] do
                task.spawn(u1880, table.unpack(v));
            end;

            table_create_ret3[120] = {};

            return function() -- Line: 7774
                -- upvalues: table_create_ret (ref), u1880 (copy)
                if table_create_ret[120] == u1880 then
                    table_create_ret[120] = nil;
                end;
            end;
        end
    },
    RoundReset = {
        On = function(u1881: function) -- Line: 7782, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[121] = u1881;

            for _, v in table_create_ret3[121] do
                u1881(table.unpack(v));
            end;

            table_create_ret3[121] = {};

            return function() -- Line: 7788
                -- upvalues: table_create_ret (ref), u1881 (copy)
                if table_create_ret[121] == u1881 then
                    table_create_ret[121] = nil;
                end;
            end;
        end
    },
    RadarLeak = {
        On = function(u1882: function) -- Line: 7796, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[18] = u1882;

            return function() -- Line: 7798
                -- upvalues: table_create_ret2 (ref), u1882 (copy)
                if table_create_ret2[18] == u1882 then
                    table_create_ret2[18] = nil;
                end;
            end;
        end
    },
    PlaySoundOnPosition = {
        On = function(u1883: function) -- Line: 7806, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[19] = u1883;

            return function() -- Line: 7808
                -- upvalues: table_create_ret2 (ref), u1883 (copy)
                if table_create_ret2[19] == u1883 then
                    table_create_ret2[19] = nil;
                end;
            end;
        end
    },
    PlayFootstepSoundOnPosition = {
        On = function(u1884: function) -- Line: 7816, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[20] = u1884;

            return function() -- Line: 7818
                -- upvalues: table_create_ret2 (ref), u1884 (copy)
                if table_create_ret2[20] == u1884 then
                    table_create_ret2[20] = nil;
                end;
            end;
        end
    },
    NetworkDebugStats = {
        On = function(u1885: function) -- Line: 7826, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[21] = u1885;

            return function() -- Line: 7828
                -- upvalues: table_create_ret2 (ref), u1885 (copy)
                if table_create_ret2[21] == u1885 then
                    table_create_ret2[21] = nil;
                end;
            end;
        end
    },
    ServerPerformanceStats = {
        On = function(u1886: function) -- Line: 7836, Name: On
            -- upvalues: table_create_ret2 (copy)
            table_create_ret2[22] = u1886;

            return function() -- Line: 7838
                -- upvalues: table_create_ret2 (ref), u1886 (copy)
                if table_create_ret2[22] == u1886 then
                    table_create_ret2[22] = nil;
                end;
            end;
        end
    },
    NetworkDebugEnabled = {
        Fire = function(p1887: boolean) -- Line: 7846, Name: Fire
            -- upvalues: u1235 (copy), u1 (copy)
            local v1888 = u1235;
            local v1889 = os.clock() // 1;

            if v1888.Window ~= v1889 then
                v1888.Window = v1889;
                table.clear(v1888.Counts);
            end;

            local v1890 = (v1888.Counts.NetworkDebugEnabled or 0) + 1;
            v1888.Counts.NetworkDebugEnabled = v1890;

            if v1890 > 10 then
                return;
            end;

            u1.WriteEVENT_NetworkDebugEnabled(p1887);
        end
    },
    SimulationConstants = {
        On = function(u1891: function) -- Line: 7852, Name: On
            -- upvalues: table_create_ret (copy), table_create_ret3 (copy)
            table_create_ret[123] = u1891;

            for _, v in table_create_ret3[123] do
                u1891(table.unpack(v));
            end;

            table_create_ret3[123] = {};

            return function() -- Line: 7858
                -- upvalues: table_create_ret (ref), u1891 (copy)
                if table_create_ret[123] == u1891 then
                    table_create_ret[123] = nil;
                end;
            end;
        end
    }
});