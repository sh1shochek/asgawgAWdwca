-- Decompiled with Potassium's decompiler.

local DestructibleFrame = require(script.Parent.Collision.DestructibleFrame);
local DamageTag = require(script.Parent.DamageTag);
local ActionLockTimeline = require(script.Parent.ActionLockTimeline);
local Mapping = require(script.Parent.Mapping);
local MoverDescriptorCodec = require(script.Parent.MoverDescriptorCodec);
local MoverProgressCodec = require(script.Parent.MoverProgressCodec);
local OwnerSnapshotCodec = require(script.Parent.OwnerSnapshotCodec);
local Quantization = require(script.Parent.Quantization);
local Serial = require(script.Parent.Serial);
local u1 = {
    Version = 6,
    Kind = table.freeze({
        Mapping = 1,
        Discontinuity = 2,
        DestructibleBaseline = 3,
        DestructibleDelta = 4,
        BaselineRequest = 5,
        MappingRequest = 6,
        MoverBaseline = 7,
        MoverDelta = 8,
        MoverProgress = 9,
        CommandResyncRequest = 10,
        GenerationUnbound = 11,
        DamageTag = 12,
        GrenadeTransitionRequest = 13,
        ActionLocks = 14
    })
};

local function createPayload(p2: number, p3: number) -- Line: 86
    local buffer_create_ret = buffer.create(p3 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, p2);

    return buffer_create_ret;
end;

local function copyBody(p4: buffer, p5: buffer) -- Line: 93
    buffer.copy(p4, 2, p5, 0, buffer.len(p5));
end;

local function readBody(p6: buffer, p7: number) -- Line: 97
    if buffer.len(p6) ~= p7 + 2 then
        return nil;
    end;

    local buffer_create_ret = buffer.create(p7);
    buffer.copy(buffer_create_ret, 0, p6, 2, p7);

    return buffer_create_ret;
end;

function u1.encodeActionLocks(p8: number, p9: any) -- Line: 106
    -- upvalues: Serial (copy), ActionLockTimeline (copy)
    if not (Serial.isNonZeroUInt16(p8) and ActionLockTimeline.validate(p9)) then
        return nil, "InvalidActionLocks";
    end;

    local buffer_create_ret = buffer.create(#p9.Points * 9 + 9 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 14);
    buffer.writeu16(buffer_create_ret, 2, p8);
    buffer.writeu32(buffer_create_ret, 4, p9.Revision);
    buffer.writeu8(buffer_create_ret, 8, p9.Initial and 1 or 0);
    buffer.writeu16(buffer_create_ret, 9, #p9.Points);

    for i, v in p9.Points do
        local v10 = 11 + (i - 1) * 9;
        buffer.writef64(buffer_create_ret, v10, v.ServerTime);
        buffer.writeu8(buffer_create_ret, v10 + 8, v.Locked and 1 or 0);
    end;

    return buffer_create_ret, nil;
end;

function u1.encodeMapping(p11) -- Line: 123
    -- upvalues: Mapping (copy)
    local v12, v13 = Mapping.encode(p11);

    if v12 == nil then
        return nil, v13;
    end;

    local buffer_create_ret = buffer.create(Mapping.WireSize + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 1);
    buffer.copy(buffer_create_ret, 2, v12, 0, buffer.len(v12));

    return buffer_create_ret, nil;
end;

function u1.encodeDiscontinuity(p14) -- Line: 133
    -- upvalues: OwnerSnapshotCodec (copy)
    local v15, v16 = OwnerSnapshotCodec.encode(p14);

    if v15 == nil then
        return nil, v16;
    end;

    local buffer_create_ret = buffer.create(OwnerSnapshotCodec.WireSize + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 2);
    buffer.copy(buffer_create_ret, 2, v15, 0, buffer.len(v15));

    return buffer_create_ret, nil;
end;

function u1.encodeDestructibleBaseline(p17, p18) -- Line: 143
    -- upvalues: DestructibleFrame (copy), Serial (copy)
    local v19, v20 = DestructibleFrame.Validate(p17.Epoch, p17.Revision, p17.Count, p17.ActiveBits);

    if not v19 then
        return nil, v20;
    end;

    if p17.Epoch > Serial.UInt16Max or (p17.Count > Serial.UInt16Max or not Serial.isUInt32(p18)) then
        return nil, "DestructibleBaselineRange";
    end;

    local buffer_create_ret = buffer.create(#p17.ActiveBits + 12 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 3);
    buffer.writeu16(buffer_create_ret, 2, p17.Epoch);
    buffer.writeu32(buffer_create_ret, 4, p17.Revision);
    buffer.writeu32(buffer_create_ret, 8, p18);
    buffer.writeu16(buffer_create_ret, 12, p17.Count);

    if #p17.ActiveBits > 0 then
        buffer.writestring(buffer_create_ret, 14, p17.ActiveBits);
    end;

    return buffer_create_ret, nil;
end;

local function validateDelta(p21, p22, p23) -- Line: 163
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p21) then
        return false, "InvalidDeltaEpoch";
    end;

    if not Serial.isUInt32(p22) or p22 == 0 then
        return false, "InvalidDeltaRevision";
    end;

    if type(p23) ~= "table" or (#p23 < 1 or #p23 > 1024) then
        return false, "InvalidDeltaCount";
    end;

    local v24 = 0;

    for _, v in p23 do
        if not Serial.isNonZeroUInt16(v) or v <= v24 then
            return false, "DeltaIndicesNotStrictlySorted";
        end;

        v24 = v;
    end;

    return true, nil;
end;

function u1.encodeDestructibleDelta(p25, p26, p27, p28) -- Line: 184
    -- upvalues: validateDelta (copy), Serial (copy)
    local v29, v30 = validateDelta(p25, p26, p28);

    if not v29 then
        return nil, v30;
    end;

    if not Serial.isUInt32(p27) then
        return nil, "InvalidDeltaServerTick";
    end;

    local buffer_create_ret = buffer.create(#p28 * 2 + 12 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 4);
    buffer.writeu16(buffer_create_ret, 2, p25);
    buffer.writeu32(buffer_create_ret, 4, p26);
    buffer.writeu32(buffer_create_ret, 8, p27);
    buffer.writeu16(buffer_create_ret, 12, #p28);
    local v31 = 14;

    for _, v in p28 do
        buffer.writeu16(buffer_create_ret, v31, v);
        v31 = v31 + 2;
    end;

    return buffer_create_ret, nil;
end;

function u1.encodeBaselineRequest(p32, p33) -- Line: 211
    -- upvalues: Serial (copy)
    if not (Serial.isNonZeroUInt16(p32) and Serial.isUInt32(p33)) then
        return nil, "InvalidBaselineRequest";
    end;

    local buffer_create_ret = buffer.create(8);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 5);
    buffer.writeu16(buffer_create_ret, 2, p32);
    buffer.writeu32(buffer_create_ret, 4, p33);

    return buffer_create_ret, nil;
end;

function u1.encodeMappingRequest(p34) -- Line: 221
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p34) then
        return nil, "InvalidMappingRequest";
    end;

    local buffer_create_ret = buffer.create(4);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 6);
    buffer.writeu16(buffer_create_ret, 2, p34);

    return buffer_create_ret, nil;
end;

function u1.encodeCommandResyncRequest(p35, p36) -- Line: 230
    -- upvalues: Serial (copy)
    if not (Serial.isNonZeroUInt16(p35) and Serial.isUInt32(p36)) then
        return nil, "InvalidCommandResyncRequest";
    end;

    local buffer_create_ret = buffer.create(8);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 10);
    buffer.writeu16(buffer_create_ret, 2, p35);
    buffer.writeu32(buffer_create_ret, 4, p36);

    return buffer_create_ret, nil;
end;

function u1.encodeGenerationUnbound(p37) -- Line: 240
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p37) then
        return nil, "InvalidGenerationUnbound";
    end;

    local buffer_create_ret = buffer.create(4);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 11);
    buffer.writeu16(buffer_create_ret, 2, p37);

    return buffer_create_ret, nil;
end;

function u1.encodeGrenadeTransitionRequest(p38, p39, p40, p41, p42, p43, p44, p45) -- Line: 250
    -- upvalues: Serial (copy), Quantization (copy)
    if not (Serial.isNonZeroUInt16(p38) and (Serial.isUInt32(p39) and (Serial.isUInt32(p40) and (p40 ~= 0 and (type(p41) == "string" and (#p41 <= 96 and (type(p42) == "string" and (#p42 >= 1 and (#p42 <= 96 and (p43 == "Far" or p43 == "Near"))))))))) and (Quantization.isFinite(p44) and Quantization.isFinite(p45))) then
        return nil, "InvalidGrenadeTransitionRequest";
    end;

    local buffer_create_ret = buffer.create(#p41 + 16 + #p42 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 13);
    buffer.writeu16(buffer_create_ret, 2, p38);
    buffer.writeu32(buffer_create_ret, 4, p39);
    buffer.writeu32(buffer_create_ret, 8, p40);
    buffer.writeu8(buffer_create_ret, 12, #p41);
    buffer.writeu8(buffer_create_ret, 13, #p42);
    buffer.writeu8(buffer_create_ret, 14, p43 == "Far" and 1 or 2);
    local v46 = Quantization.quantizeYaw(p44);
    buffer.writeu16(buffer_create_ret, 15, v46);
    local v47 = Quantization.quantizeSignedUnit(p45);
    buffer.writei8(buffer_create_ret, 17, v47);
    buffer.writestring(buffer_create_ret, 18, p41);
    buffer.writestring(buffer_create_ret, #p41 + 18, p42);

    return buffer_create_ret, nil;
end;

function u1.encodeDamageTag(p48, p49, p50) -- Line: 291
    -- upvalues: Serial (copy), DamageTag (copy)
    if not (Serial.isNonZeroUInt16(p48) and (Serial.isUInt32(p49) and DamageTag.isValidModifier(p50))) then
        return nil, "InvalidDamageTag";
    end;

    local buffer_create_ret = buffer.create(12);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 12);
    buffer.writeu16(buffer_create_ret, 2, p48);
    buffer.writeu32(buffer_create_ret, 4, p49);
    buffer.writef32(buffer_create_ret, 8, p50);

    return buffer_create_ret, nil;
end;

local function validateMoverHeader(p51, p52, p53) -- Line: 310
    -- upvalues: Serial (copy)
    if Serial.isNonZeroUInt16(p51) and (Serial.isUInt32(p52) and Serial.isUInt32(p53)) then
        return true, nil;
    end;

    return false, "InvalidMoverControlHeader";
end;

local function encodeMoverDescriptors(p54: number, p55: any, p56: any, p57: any, p58: any, p59: boolean) -- Line: 317
    -- upvalues: Serial (copy), MoverDescriptorCodec (copy)
    local v60, v61;

    if Serial.isNonZeroUInt16(p55) and (Serial.isUInt32(p56) and Serial.isUInt32(p57)) then
        v60 = true;
        v61 = nil;
    else
        v60 = false;
        v61 = "InvalidMoverControlHeader";
    end;

    if not v60 then
        return nil, v61;
    end;

    local v62, v63 = MoverDescriptorCodec.validateList(p58, p59);

    if not v62 then
        return nil, v63;
    end;

    local v64 = #p58;
    local buffer_create_ret = buffer.create(12 + v64 * MoverDescriptorCodec.DescriptorWireSize + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, p54);
    buffer.writeu16(buffer_create_ret, 2, p55);
    buffer.writeu32(buffer_create_ret, 4, p56);
    buffer.writeu32(buffer_create_ret, 8, p57);
    buffer.writeu16(buffer_create_ret, 12, v64);
    local v65 = MoverDescriptorCodec.writeValidated(buffer_create_ret, 14, p58) == buffer.len(buffer_create_ret);
    assert(v65, "mover control size drift");

    return buffer_create_ret, nil;
end;

function u1.encodeMoverBaseline(p66, p67, p68, p69, p70) -- Line: 344
    -- upvalues: Serial (copy), MoverDescriptorCodec (copy), MoverProgressCodec (copy)
    local v71, v72;

    if Serial.isNonZeroUInt16(p66) and (Serial.isUInt32(p67) and Serial.isUInt32(p68)) then
        v71 = true;
        v72 = nil;
    else
        v71 = false;
        v72 = "InvalidMoverControlHeader";
    end;

    if not v71 then
        return nil, v72;
    end;

    local v73, v74 = MoverDescriptorCodec.validateList(p69, true);

    if not v73 then
        return nil, v74;
    end;

    local v75 = p70 or {};
    local v76, v77 = MoverProgressCodec.validateAnchors(v75, true);

    if not v76 then
        return nil, v77;
    end;

    local v78 = #p69;
    local buffer_create_ret = buffer.create(13 + v78 * MoverDescriptorCodec.DescriptorWireSize + #v75 * MoverProgressCodec.AnchorWireSize + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 7);
    buffer.writeu16(buffer_create_ret, 2, p66);
    buffer.writeu32(buffer_create_ret, 4, p67);
    buffer.writeu32(buffer_create_ret, 8, p68);
    buffer.writeu16(buffer_create_ret, 12, v78);
    local v79 = MoverDescriptorCodec.writeValidated(buffer_create_ret, 14, p69);
    buffer.writeu8(buffer_create_ret, v79, #v75);
    local v80 = MoverProgressCodec.writeAnchorsValidated(buffer_create_ret, v79 + 1, v75) == buffer.len(buffer_create_ret);
    assert(v80, "mover baseline control size drift");

    return buffer_create_ret, nil;
end;

function u1.encodeMoverDelta(p81, p82, p83, p84) -- Line: 380
    -- upvalues: encodeMoverDescriptors (copy)
    return encodeMoverDescriptors(8, p81, p82, p83, p84, false);
end;

function u1.encodeMoverProgress(p85, p86, p87, p88) -- Line: 384
    -- upvalues: Serial (copy), MoverProgressCodec (copy)
    local v89, v90;

    if Serial.isNonZeroUInt16(p85) and (Serial.isUInt32(p86) and Serial.isUInt32(p87)) then
        v89 = true;
        v90 = nil;
    else
        v89 = false;
        v90 = "InvalidMoverControlHeader";
    end;

    if not v89 then
        return nil, v90;
    end;

    local v91, v92 = MoverProgressCodec.validateStreams(p88);

    if not v91 then
        return nil, v92;
    end;

    local v93 = 11 + MoverProgressCodec.streamsWireSize(p88);
    local buffer_create_ret = buffer.create(v93 + 2);
    buffer.writeu8(buffer_create_ret, 0, 6);
    buffer.writeu8(buffer_create_ret, 1, 9);
    buffer.writeu16(buffer_create_ret, 2, p85);
    buffer.writeu32(buffer_create_ret, 4, p86);
    buffer.writeu32(buffer_create_ret, 8, p87);
    buffer.writeu8(buffer_create_ret, 12, #p88);
    local v94 = MoverProgressCodec.writeStreamsValidated(buffer_create_ret, 13, p88) == buffer.len(buffer_create_ret);
    assert(v94, "mover progress control size drift");

    return buffer_create_ret, nil;
end;

function u1.decodeRequest(p95) -- Line: 404
    -- upvalues: Serial (copy), Quantization (copy)
    if typeof(p95) ~= "buffer" then
        return nil, "ControlRequestPayload";
    end;

    local buffer_len_ret = buffer.len(p95);

    if buffer_len_ret < 2 or buffer.readu8(p95, 0) ~= 6 then
        return nil, "ControlRequestHeader";
    end;

    local buffer_readu8_ret = buffer.readu8(p95, 1);

    if buffer_readu8_ret == 5 then
        if buffer_len_ret ~= 8 then
            return nil, "BaselineRequestSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p95, 2);
        local buffer_readu32_ret = buffer.readu32(p95, 4);

        if Serial.isNonZeroUInt16(buffer_readu16_ret) then
            return {
                Kind = "BaselineRequest",
                Epoch = buffer_readu16_ret,
                KnownRevision = buffer_readu32_ret
            }, nil;
        end;

        return nil, "InvalidBaselineRequest";
    end;

    if buffer_readu8_ret == 6 then
        if buffer_len_ret ~= 4 then
            return nil, "MappingRequestSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p95, 2);

        if Serial.isNonZeroUInt16(buffer_readu16_ret) then
            return {
                Kind = "MappingRequest",
                Generation = buffer_readu16_ret
            }, nil;
        end;

        return nil, "InvalidMappingRequest";
    end;

    if buffer_readu8_ret == 10 then
        if buffer_len_ret ~= 8 then
            return nil, "CommandResyncRequestSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p95, 2);
        local buffer_readu32_ret = buffer.readu32(p95, 4);

        if Serial.isNonZeroUInt16(buffer_readu16_ret) then
            return {
                Kind = "CommandResyncRequest",
                Generation = buffer_readu16_ret,
                DiscardThroughCommand = buffer_readu32_ret
            }, nil;
        end;

        return nil, "InvalidCommandResyncRequest";
    end;

    if buffer_readu8_ret ~= 13 then
        return nil, "ControlRequestKind";
    end;

    if buffer_len_ret < 19 then
        return nil, "GrenadeTransitionRequestSize";
    end;

    local buffer_readu16_ret = buffer.readu16(p95, 2);
    local buffer_readu32_ret = buffer.readu32(p95, 4);
    local buffer_readu32_ret2 = buffer.readu32(p95, 8);
    local buffer_readu8_ret2 = buffer.readu8(p95, 12);
    local buffer_readu8_ret3 = buffer.readu8(p95, 13);
    local buffer_readu8_ret4 = buffer.readu8(p95, 14);
    local v96 = Quantization.dequantizeYaw((buffer.readu16(p95, 15)));
    local v97 = Quantization.dequantizeSignedUnit((buffer.readi8(p95, 17)));

    if Serial.isNonZeroUInt16(buffer_readu16_ret) and (buffer_readu32_ret2 ~= 0 and (buffer_readu8_ret2 <= 96 and (buffer_readu8_ret3 >= 1 and (buffer_readu8_ret3 <= 96 and (buffer_readu8_ret4 == 1 or buffer_readu8_ret4 == 2))))) and buffer_len_ret == buffer_readu8_ret2 + 18 + buffer_readu8_ret3 then
        return {
            Kind = "GrenadeTransitionRequest",
            Generation = buffer_readu16_ret,
            CommandNumber = buffer_readu32_ret,
            RequestId = buffer_readu32_ret2,
            TargetIdentifier = buffer.readstring(p95, 18, buffer_readu8_ret2),
            GrenadeIdentifier = buffer.readstring(p95, buffer_readu8_ret2 + 18, buffer_readu8_ret3),
            Animation = buffer_readu8_ret4 == 1 and "Far" or "Near",
            LookYaw = v96,
            VerticalLook = v97
        }, nil;
    end;

    return nil, "InvalidGrenadeTransitionRequest";
end;

function u1.decode(p98) -- Line: 489
    -- upvalues: Mapping (copy), OwnerSnapshotCodec (copy), DestructibleFrame (copy), validateDelta (copy), u1 (copy), Serial (copy), ActionLockTimeline (copy), DamageTag (copy), MoverDescriptorCodec (copy), MoverProgressCodec (copy)
    if typeof(p98) ~= "buffer" or buffer.len(p98) < 2 then
        return nil, "ControlPayload";
    end;

    if buffer.readu8(p98, 0) ~= 6 then
        return nil, "ControlVersion";
    end;

    local buffer_readu8_ret = buffer.readu8(p98, 1);

    if buffer_readu8_ret == 1 then
        local WireSize = Mapping.WireSize;
        local v99;

        if buffer.len(p98) == WireSize + 2 then
            v99 = buffer.create(WireSize);
            buffer.copy(v99, 0, p98, 2, WireSize);
        else
            v99 = nil;
        end;

        if v99 == nil then
            return nil, "MappingControlSize";
        end;

        local v100, v101 = Mapping.decode(v99);

        if v100 == nil then
            return nil, v101;
        end;

        return {
            Kind = "Mapping",
            Mapping = v100
        }, nil;
    end;

    if buffer_readu8_ret == 2 then
        local WireSize = OwnerSnapshotCodec.WireSize;
        local v102;

        if buffer.len(p98) == WireSize + 2 then
            v102 = buffer.create(WireSize);
            buffer.copy(v102, 0, p98, 2, WireSize);
        else
            v102 = nil;
        end;

        if v102 == nil then
            return nil, "DiscontinuityControlSize";
        end;

        local v103, v104 = OwnerSnapshotCodec.decode(v102);

        if v103 == nil then
            return nil, v104;
        end;

        return {
            Kind = "Discontinuity",
            Snapshot = v103
        }, nil;
    end;

    if buffer_readu8_ret == 3 then
        if buffer.len(p98) < 14 then
            return nil, "BaselineControlSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);
        local buffer_readu32_ret = buffer.readu32(p98, 4);
        local buffer_readu32_ret2 = buffer.readu32(p98, 8);
        local buffer_readu16_ret2 = buffer.readu16(p98, 12);
        local math_ceil_ret = math.ceil(buffer_readu16_ret2 / 8);

        if buffer.len(p98) ~= math_ceil_ret + 14 then
            return nil, "BaselineControlSize";
        end;

        local v105 = math_ceil_ret <= 0 and "" or buffer.readstring(p98, 14, math_ceil_ret);
        local v106, v107 = DestructibleFrame.Validate(buffer_readu16_ret, buffer_readu32_ret, buffer_readu16_ret2, v105);

        if v106 then
            return {
                Kind = "DestructibleBaseline",
                ServerTick = buffer_readu32_ret2,
                Frame = DestructibleFrame.New(buffer_readu16_ret, buffer_readu32_ret, buffer_readu16_ret2, v105)
            }, nil;
        end;

        return nil, v107;
    end;

    if buffer_readu8_ret == 4 then
        if buffer.len(p98) < 14 then
            return nil, "DeltaControlSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);
        local buffer_readu32_ret = buffer.readu32(p98, 4);
        local buffer_readu32_ret2 = buffer.readu32(p98, 8);
        local buffer_readu16_ret2 = buffer.readu16(p98, 12);

        if buffer_readu16_ret2 < 1 or (buffer_readu16_ret2 > 1024 or buffer.len(p98) ~= buffer_readu16_ret2 * 2 + 14) then
            return nil, "DeltaControlSize";
        end;

        local table_create_ret = table.create(buffer_readu16_ret2);
        local v108 = 14;

        for i = 1, buffer_readu16_ret2 do
            table_create_ret[i] = buffer.readu16(p98, v108);
            v108 = v108 + 2;
            local _ = i;
        end;

        local v109, v110 = validateDelta(buffer_readu16_ret, buffer_readu32_ret, table_create_ret);

        if v109 then
            return {
                Kind = "DestructibleDelta",
                Epoch = buffer_readu16_ret,
                Revision = buffer_readu32_ret,
                ServerTick = buffer_readu32_ret2,
                Indices = table_create_ret
            }, nil;
        end;

        return nil, v110;
    end;

    if buffer_readu8_ret == 5 or (buffer_readu8_ret == 6 or (buffer_readu8_ret == 10 or buffer_readu8_ret == 13)) then
        return u1.decodeRequest(p98);
    end;

    if buffer_readu8_ret == 11 then
        if buffer.len(p98) ~= 4 then
            return nil, "GenerationUnboundSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);

        if Serial.isNonZeroUInt16(buffer_readu16_ret) then
            return {
                Kind = "GenerationUnbound",
                Generation = buffer_readu16_ret
            }, nil;
        end;

        return nil, "InvalidGenerationUnbound";
    end;

    if buffer_readu8_ret == 14 then
        if buffer.len(p98) < 11 then
            return nil, "ActionLocksSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);
        local buffer_readu8_ret2 = buffer.readu8(p98, 8);
        local buffer_readu16_ret2 = buffer.readu16(p98, 9);

        if not (Serial.isNonZeroUInt16(buffer_readu16_ret) and (buffer_readu8_ret2 <= 1 and ActionLockTimeline.MaxPoints >= buffer_readu16_ret2)) then
            return nil, "InvalidActionLocks";
        end;

        if buffer.len(p98) ~= buffer_readu16_ret2 * 9 + 11 then
            return nil, "ActionLocksSize";
        end;

        local table_create_ret = table.create(buffer_readu16_ret2);

        for i = 1, buffer_readu16_ret2 do
            local v111 = (i - 1) * 9 + 11;
            local buffer_readu8_ret3 = buffer.readu8(p98, v111 + 8);

            if buffer_readu8_ret3 > 1 then
                return nil, "InvalidActionLocks";
            end;

            table_create_ret[i] = {
                ServerTime = buffer.readf64(p98, v111),
                Locked = buffer_readu8_ret3 == 1
            };
            local _ = i;
        end;

        local v112 = {
            Revision = buffer.readu32(p98, 4),
            Initial = buffer_readu8_ret2 == 1,
            Points = table_create_ret
        };

        if ActionLockTimeline.validate(v112) then
            return {
                Kind = "ActionLocks",
                Generation = buffer_readu16_ret,
                History = v112
            }, nil;
        end;

        return nil, "InvalidActionLocks";
    end;

    if buffer_readu8_ret == 12 then
        if buffer.len(p98) ~= 12 then
            return nil, "DamageTagSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);
        local buffer_readu32_ret = buffer.readu32(p98, 4);
        local buffer_readf32_ret = buffer.readf32(p98, 8);

        if Serial.isNonZeroUInt16(buffer_readu16_ret) and DamageTag.isValidModifier(buffer_readf32_ret) then
            return {
                Kind = "DamageTag",
                Generation = buffer_readu16_ret,
                ApplyMovementTick = buffer_readu32_ret,
                VelocityModifier = buffer_readf32_ret
            }, nil;
        end;

        return nil, "InvalidDamageTag";
    end;

    if buffer_readu8_ret ~= 7 then
        if buffer_readu8_ret == 8 then
            if buffer.len(p98) < 14 then
                return nil, "MoverControlSize";
            end;

            local buffer_readu16_ret = buffer.readu16(p98, 2);
            local buffer_readu32_ret = buffer.readu32(p98, 4);
            local buffer_readu32_ret2 = buffer.readu32(p98, 8);
            local buffer_readu16_ret2 = buffer.readu16(p98, 12);

            if not (Serial.isNonZeroUInt16(buffer_readu16_ret) and (Serial.isUInt32(buffer_readu32_ret) and Serial.isUInt32(buffer_readu32_ret2)) and (buffer_readu16_ret2 ~= 0 and buffer.len(p98) == 14 + buffer_readu16_ret2 * MoverDescriptorCodec.DescriptorWireSize)) then
                return nil, "MoverControlSize";
            end;

            local v113, v114, v115 = MoverDescriptorCodec.readList(p98, 14, buffer_readu16_ret2);

            if v113 == nil then
                return nil, v115;
            end;

            local v116 = v114 == buffer.len(p98);
            assert(v116, "mover control decode size drift");

            return {
                Kind = "MoverDelta",
                Epoch = buffer_readu16_ret,
                Revision = buffer_readu32_ret,
                ServerTick = buffer_readu32_ret2,
                Descriptors = v113
            }, nil;
        end;

        if buffer_readu8_ret ~= 9 then
            return nil, "ControlKind";
        end;

        if buffer.len(p98) < 21 then
            return nil, "MoverProgressPayloadSize";
        end;

        local buffer_readu16_ret = buffer.readu16(p98, 2);
        local buffer_readu32_ret = buffer.readu32(p98, 4);
        local buffer_readu32_ret2 = buffer.readu32(p98, 8);
        local buffer_readu8_ret2 = buffer.readu8(p98, 12);

        if not (Serial.isNonZeroUInt16(buffer_readu16_ret) and (Serial.isUInt32(buffer_readu32_ret) and Serial.isUInt32(buffer_readu32_ret2))) then
            return nil, "InvalidMoverControlHeader";
        end;

        local v117, v118, v119 = MoverProgressCodec.readStreams(p98, 13, buffer_readu8_ret2);

        if v117 == nil then
            return nil, v119;
        end;

        if v118 == buffer.len(p98) then
            return {
                Kind = "MoverProgress",
                Epoch = buffer_readu16_ret,
                Revision = buffer_readu32_ret,
                ServerTick = buffer_readu32_ret2,
                Streams = v117
            }, nil;
        end;

        return nil, "MoverProgressPayloadSize";
    end;

    if buffer.len(p98) < 15 then
        return nil, "MoverControlSize";
    end;

    local buffer_readu16_ret = buffer.readu16(p98, 2);
    local buffer_readu32_ret = buffer.readu32(p98, 4);
    local buffer_readu32_ret2 = buffer.readu32(p98, 8);
    local buffer_readu16_ret2 = buffer.readu16(p98, 12);
    local v120 = buffer_readu16_ret2 * MoverDescriptorCodec.DescriptorWireSize;
    local v121 = 14 + v120;

    if not (Serial.isNonZeroUInt16(buffer_readu16_ret) and (Serial.isUInt32(buffer_readu32_ret) and Serial.isUInt32(buffer_readu32_ret2))) or buffer.len(p98) <= v121 then
        return nil, "MoverControlSize";
    end;

    local buffer_create_ret = buffer.create(v120);

    if v120 > 0 then
        buffer.copy(buffer_create_ret, 0, p98, 14, v120);
    end;

    local v122, v123, v124 = MoverDescriptorCodec.readList(buffer_create_ret, 0, buffer_readu16_ret2);

    if v122 == nil then
        return nil, v124;
    end;

    assert(v123 == v120, "mover baseline descriptor decode size drift");
    local buffer_readu8_ret2 = buffer.readu8(p98, v121);

    if v121 + 1 + buffer_readu8_ret2 * MoverProgressCodec.AnchorWireSize ~= buffer.len(p98) then
        return nil, "MoverProgressAnchorPayloadSize";
    end;

    local v125, v126, v127 = MoverProgressCodec.readAnchors(p98, v121 + 1, buffer_readu8_ret2);

    if v125 == nil then
        return nil, v127;
    end;

    local v128 = v126 == buffer.len(p98);
    assert(v128, "mover baseline control decode size drift");

    return {
        Kind = "MoverBaseline",
        Epoch = buffer_readu16_ret,
        Revision = buffer_readu32_ret,
        ServerTick = buffer_readu32_ret2,
        Descriptors = v122,
        ProgressAnchors = v125
    }, nil;
end;

return table.freeze(u1);