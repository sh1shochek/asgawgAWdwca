-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Serial);
local u1 = {
    AnchorWireSize = 8
};

local function isUInt8(p2) -- Line: 32
    local v3;

    if type(p2) == "number" and (p2 % 1 == 0 and p2 >= 0) then
        v3 = p2 <= 255;
    else
        v3 = false;
    end;

    return v3;
end;

local function isUInt16(p4) -- Line: 36
    -- upvalues: Serial (copy)
    local v5;

    if type(p4) == "number" and (p4 % 1 == 0 and p4 >= 0) then
        v5 = p4 <= Serial.UInt16Max;
    else
        v5 = false;
    end;

    return v5;
end;

local function isDenseArray(p6: any, p7: number, p8: boolean?) -- Line: 40
    if type(p6) ~= "table" or (p7 < #p6 or #p6 == 0 and p8 ~= true) then
        return false;
    end;

    for i in p6 do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or #p6 < i)) then
            return false;
        end;
    end;

    return true;
end;

function u1.validateStreams(p9) -- Line: 52
    -- upvalues: isDenseArray (copy), Serial (copy)
    if not isDenseArray(p9, 64) then
        return false, "InvalidMoverProgressStreamCount";
    end;

    local v10 = 0;
    local v11 = 0;

    for _, v in p9 do
        if type(v) ~= "table" or not (Serial.isUInt32(v.Id) and (v.Id ~= 0 and v.Id > v10)) then
            return false, "MoverProgressStreamsNotStrictlySorted";
        end;

        v10 = v.Id;

        if not isDenseArray(v.Samples, 255) then
            return false, "InvalidMoverProgressSampleCount";
        end;

        v11 = v11 + #v.Samples;

        if v11 > 1024 then
            return false, "MoverProgressSampleLimit";
        end;

        local v12 = 256;

        for _, v2 in v.Samples do
            if type(v2) ~= "table" then
                return false, "InvalidMoverProgressTickAge";
            end;

            local TickAge = v2.TickAge;
            local v13;

            if type(TickAge) == "number" and (TickAge % 1 == 0 and TickAge >= 0) then
                v13 = TickAge <= 255;
            else
                v13 = false;
            end;

            if not v13 then
                return false, "InvalidMoverProgressTickAge";
            end;

            if v12 <= v2.TickAge then
                return false, "MoverProgressSamplesNotChronological";
            end;

            v12 = v2.TickAge;
            local ProgressQ = v2.ProgressQ;
            local v14;

            if type(ProgressQ) == "number" and (ProgressQ % 1 == 0 and ProgressQ >= 0) then
                v14 = ProgressQ <= Serial.UInt16Max;
            else
                v14 = false;
            end;

            if not v14 then
                return false, "InvalidMoverProgressValue";
            end;
        end;
    end;

    return true, nil;
end;

function u1.streamsWireSize(p15: table) -- Line: 88
    -- upvalues: u1 (copy)
    local v16, v17 = u1.validateStreams(p15);
    assert(v16, v17);
    local v18 = 0;

    for _, v in p15 do
        v18 = v18 + (#v.Samples * 3 + 5);
    end;

    return v18;
end;

function u1.writeStreamsValidated(p19: buffer, p20: number, p21: table) -- Line: 98
    for _, v in p21 do
        buffer.writeu32(p19, p20, v.Id);
        buffer.writeu8(p19, p20 + 4, #v.Samples);
        p20 = p20 + 5;

        for _, v2 in v.Samples do
            buffer.writeu8(p19, p20, v2.TickAge);
            buffer.writeu16(p19, p20 + 1, v2.ProgressQ);
            p20 = p20 + 3;
        end;
    end;

    return p20;
end;

function u1.readStreams(p22: buffer, p23: number, p24: number) -- Line: 112
    -- upvalues: u1 (copy)
    if p24 < 1 or p24 > 64 then
        return nil, p23, "InvalidMoverProgressStreamCount";
    end;

    local table_create_ret = table.create(p24);
    local v25 = 0;

    for i = 1, p24 do
        if buffer.len(p22) - p23 < 5 then
            return nil, p23, "MoverProgressPayloadSize";
        end;

        local buffer_readu32_ret = buffer.readu32(p22, p23);
        local buffer_readu8_ret = buffer.readu8(p22, p23 + 4);
        p23 = p23 + 5;

        if buffer_readu8_ret < 1 or buffer_readu8_ret > 255 then
            return nil, p23, "InvalidMoverProgressSampleCount";
        end;

        v25 = v25 + buffer_readu8_ret;

        if v25 > 1024 or buffer.len(p22) - p23 < buffer_readu8_ret * 3 then
            return nil, p23, "MoverProgressPayloadSize";
        end;

        local table_create_ret2 = table.create(buffer_readu8_ret);

        for i2 = 1, buffer_readu8_ret do
            table_create_ret2[i2] = {
                TickAge = buffer.readu8(p22, p23),
                ProgressQ = buffer.readu16(p22, p23 + 1)
            };
            p23 = p23 + 3;
            local _ = i2;
        end;

        table_create_ret[i] = {
            Id = buffer_readu32_ret,
            Samples = table_create_ret2
        };
    end;

    local v26, v27 = u1.validateStreams(table_create_ret);

    if v26 then
        return table_create_ret, p23, nil;
    end;

    return nil, p23, v27;
end;

function u1.validateAnchors(p28: any, p29: boolean?) -- Line: 152
    -- upvalues: isDenseArray (copy), Serial (copy)
    if not isDenseArray(p28, 64, p29) then
        return false, "InvalidMoverProgressAnchorCount";
    end;

    local v30 = 0;

    for _, v in p28 do
        if type(v) ~= "table" or not (Serial.isUInt32(v.Id) and (v.Id ~= 0 and v.Id > v30)) then
            return false, "MoverProgressAnchorsNotStrictlySorted";
        end;

        v30 = v.Id;
        local PreviousProgressQ = v.PreviousProgressQ;
        local v31;

        if type(PreviousProgressQ) == "number" and (PreviousProgressQ % 1 == 0 and PreviousProgressQ >= 0) then
            v31 = PreviousProgressQ <= Serial.UInt16Max;
        else
            v31 = false;
        end;

        if not v31 then
            return false, "InvalidMoverProgressAnchorValue";
        end;

        local CurrentProgressQ = v.CurrentProgressQ;
        local v32;

        if type(CurrentProgressQ) == "number" and (CurrentProgressQ % 1 == 0 and CurrentProgressQ >= 0) then
            v32 = CurrentProgressQ <= Serial.UInt16Max;
        else
            v32 = false;
        end;

        if not v32 then
            return false, "InvalidMoverProgressAnchorValue";
        end;
    end;

    return true, nil;
end;

function u1.writeAnchorsValidated(p33: buffer, p34: number, p35: table) -- Line: 169
    for _, v in p35 do
        buffer.writeu32(p33, p34, v.Id);
        buffer.writeu16(p33, p34 + 4, v.PreviousProgressQ);
        buffer.writeu16(p33, p34 + 6, v.CurrentProgressQ);
        p34 = p34 + 8;
    end;

    return p34;
end;

function u1.readAnchors(p36: buffer, p37: number, p38: number) -- Line: 179
    -- upvalues: u1 (copy)
    if p38 < 0 or (p38 > 64 or buffer.len(p36) - p37 < p38 * 8) then
        return nil, p37, "MoverProgressAnchorPayloadSize";
    end;

    local table_create_ret = table.create(p38);

    for i = 1, p38 do
        table_create_ret[i] = {
            Id = buffer.readu32(p36, p37),
            PreviousProgressQ = buffer.readu16(p36, p37 + 4),
            CurrentProgressQ = buffer.readu16(p36, p37 + 6)
        };
        p37 = p37 + 8;
        local _ = i;
    end;

    local v39, v40 = u1.validateAnchors(table_create_ret, true);

    if v39 then
        return table_create_ret, p37, nil;
    end;

    return nil, p37, v40;
end;

return table.freeze(u1);