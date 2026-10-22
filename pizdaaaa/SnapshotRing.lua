-- ReplicatedStorage.Shared.Utility.SnapshotRing
-- Script path: ReplicatedStorage.Shared.Utility.SnapshotRing
-- Decompile time: 5.96 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};

local function PadByTick(p2: any, p3: number) -- Line: 20
    local math_log_ret = math.log(p3, 2);

    for i = 1, 2 ^ math.ceil(math_log_ret) * 1.5 - p3 do
        p2["pad" .. i] = false;
        local _ = i;
    end;
end;

local function Push(p4: any, p5: number, p6: number?, p7: any) -- Line: 28
    local v8 = p4.ByTick[p5];

    if v8 then
        v8.Time = p6;
        v8.Snapshot = p7;

        return v8;
    end;

    local Size = p4.Size;
    local v9;

    if p4.Count < Size then
        p4.Count = p4.Count + 1;
        v9 = (p4.Head - 1 + p4.Count - 1) % Size + 1;
    else
        v9 = p4.Head;
        p4.Head = p4.Head % Size + 1;
    end;

    local v10 = p4.Items[v9];

    if v10 then
        p4.ByTick[v10.Tick] = nil;
        v10.Tick = p5;
        v10.Time = p6;
        v10.Snapshot = p7;
    else
        v10 = {
            Tick = p5,
            Time = p6,
            Snapshot = p7
        };
        p4.Items[v9] = v10;
    end;

    p4.ByTick[p5] = v10;

    return v10;
end;

local function PushFilled(p11: any, p12: number, p13: number?, p14: any, p15: any, p16: any) -- Line: 72
    local v17 = p11.ByTick[p12];

    if v17 then
        local v18;

        if v17.Snapshot == p16 then
            v18 = nil;
        else
            v18 = v17.Snapshot or nil;
        end;

        v17.Time = p13;
        v17.Snapshot = p14(p15, v18);

        return v17;
    end;

    local Size = p11.Size;
    local v19;

    if p11.Count < Size then
        p11.Count = p11.Count + 1;
        v19 = (p11.Head - 1 + p11.Count - 1) % Size + 1;
    else
        v19 = p11.Head;
        p11.Head = p11.Head % Size + 1;
    end;

    local v20 = p11.Items[v19];

    if v20 then
        p11.ByTick[v20.Tick] = nil;
        local v21;

        if v20.Snapshot == p16 then
            v21 = nil;
        else
            v21 = v20.Snapshot or nil;
        end;

        v20.Tick = p12;
        v20.Time = p13;
        v20.Snapshot = p14(p15, v21);
    else
        v20 = {
            Tick = p12,
            Time = p13,
            Snapshot = p14(p15, nil)
        };
        p11.Items[v19] = v20;
    end;

    p11.ByTick[p12] = v20;

    return v20;
end;

local function GetByTick(p22: any, p23: number) -- Line: 116
    return p22.ByTick[p23];
end;

local function Get(p24: any, p25: number) -- Line: 120
    return p24.Items[(p24.Head - 1 + p25 - 1) % p24.Size + 1];
end;

local function Newest(p26) -- Line: 126
    local v27;

    if p26.Count > 0 then
        v27 = p26.Items[(p26.Head - 1 + p26.Count - 1) % p26.Size + 1] or nil;
    else
        v27 = nil;
    end;

    return v27;
end;

local function Clear(p28) -- Line: 130
    table.clear(p28.Items);
    table.clear(p28.ByTick);
    local ByTick = p28.ByTick;
    local Size = p28.Size;
    local math_log_ret = math.log(Size, 2);

    for i = 1, 2 ^ math.ceil(math_log_ret) * 1.5 - Size do
        ByTick["pad" .. i] = false;
        local _ = i;
    end;

    p28.Head = 1;
    p28.Count = 0;
end;

function v1.new(p29: number) -- Line: 140
    -- upvalues: Push (copy), PushFilled (copy), GetByTick (copy), Get (copy), Newest (copy), Clear (copy)
    local math_log_ret = math.log(p29, 2);
    local v30 = {};

    for i = 1, 2 ^ math.ceil(math_log_ret) * 1.5 - p29 do
        v30["pad" .. i] = false;
        local _ = i;
    end;

    return {
        Head = 1,
        Count = 0,
        Size = p29,
        Items = table.create(p29),
        ByTick = v30,
        Push = Push,
        PushFilled = PushFilled,
        GetByTick = GetByTick,
        Get = Get,
        Newest = Newest,
        Clear = Clear
    };
end;

return v1;