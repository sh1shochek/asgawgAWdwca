-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Enums);
local Quantization = require(script.Parent.Quantization);
local Serial = require(script.Parent.Serial);
local StateCodec = require(script.Parent.StateCodec);
require(script.Parent.Types);
local u1 = {};
local u2 = 68 + StateCodec.WireSize;
u1.Version = 8;
u1.HeaderSize = 68;
u1.WireSize = u2;
local isVector3Within = Quantization.isVector3Within;
local writeVector3F32 = Quantization.writeVector3F32;
local readVector3F32 = Quantization.readVector3F32;

local function validateTopology(p3) -- Line: 31
    -- upvalues: Serial (copy)
    if typeof(p3) ~= "table" then
        return false, "TopologyNotTable";
    end;

    if not Serial.isNonZeroUInt16(p3.Epoch) then
        return false, "InvalidTopologyEpoch";
    end;

    if not Serial.isUInt32(p3.Fingerprint) then
        return false, "InvalidTopologyFingerprint";
    end;

    if not Serial.isUInt32(p3.DestructibleRevision) then
        return false, "InvalidDestructibleRevision";
    end;

    if Serial.isUInt32(p3.MoverRevision) then
        return true, nil;
    end;

    return false, "InvalidMoverRevision";
end;

local function validateSupport(p4) -- Line: 50
    -- upvalues: Enums (copy), Serial (copy), isVector3Within (copy)
    if typeof(p4) ~= "table" then
        return false, "SupportNotTable";
    end;

    if typeof(p4.Kind) ~= "number" or (p4.Kind % 1 ~= 0 or (p4.Kind < Enums.SupportKind.None or p4.Kind > Enums.SupportKind.Max)) then
        return false, "InvalidSupportKind";
    end;

    if not Serial.isUInt32(p4.SourceId) then
        return false, "InvalidSupportSourceId";
    end;

    if p4.Kind == Enums.SupportKind.None ~= (p4.SourceId == 0) then
        return false, "InvalidEmptySupport";
    end;

    if not isVector3Within(p4.Anchor, 1000000) then
        return false, "InvalidSupportAnchor";
    end;

    if not isVector3Within(p4.Velocity, 100000) then
        return false, "InvalidSupportVelocity";
    end;

    if p4.Kind == Enums.SupportKind.None and (p4.Anchor.Magnitude > 0 or p4.Velocity.Magnitude > 0) then
        return false, "NonCanonicalEmptySupport";
    end;

    return true, nil;
end;

local function validateSnapshot(p5: any, p6: boolean) -- Line: 80
    -- upvalues: Serial (copy), Enums (copy), StateCodec (copy), validateTopology (copy), validateSupport (copy)
    if typeof(p5) ~= "table" then
        return false, "SnapshotNotTable";
    end;

    if not Serial.isNonZeroUInt16(p5.Generation) then
        return false, "InvalidGeneration";
    end;

    if not Serial.isUInt32(p5.Sequence) then
        return false, "InvalidSnapshotSequence";
    end;

    if not Serial.isUInt32(p5.ServerTick) then
        return false, "InvalidServerTick";
    end;

    if typeof(p5.ServerTime) ~= "number" or (p5.ServerTime ~= p5.ServerTime or math.abs(p5.ServerTime) == (1 / 0)) then
        return false, "InvalidServerTime";
    end;

    if not Serial.isUInt32(p5.LastProcessedCommand) then
        return false, "InvalidLastProcessedCommand";
    end;

    if typeof(p5.Flags) == "number" and (p5.Flags % 1 == 0 and p5.Flags >= 0) then
        local Flags = p5.Flags;
        local bit32_bnot_ret = bit32.bnot(Enums.OwnerSnapshotFlags.ValidMask);

        if bit32.band(Flags, bit32_bnot_ret) == 0 then
            if typeof(p5.BufferDepth) ~= "number" or (p5.BufferDepth % 1 ~= 0 or (p5.BufferDepth < -128 or p5.BufferDepth > 127)) then
                return false, "InvalidBufferDepth";
            end;

            if not p6 then
                local v7, v8 = StateCodec.validate(p5.State);

                if not v7 then
                    return false, v8;
                end;
            end;

            local v9, v10 = validateTopology(p5.Topology);

            if not v9 then
                return false, v10;
            end;

            local v11, v12 = validateSupport(p5.Support);

            if not v11 then
                return false, v12;
            end;

            if p5.State.OnGround == (p5.Support.Kind ~= Enums.SupportKind.None) then
                return true, nil;
            end;

            return false, "GroundSupportMismatch";
        end;
    end;

    return false, "InvalidSnapshotFlags";
end;

function u1.validate(p13) -- Line: 139
    -- upvalues: validateSnapshot (copy)
    return validateSnapshot(p13, false);
end;

function u1.canonicalizeSupport(p14) -- Line: 144
    -- upvalues: validateSupport (copy), writeVector3F32 (copy), readVector3F32 (copy)
    local v15, v16 = validateSupport(p14);

    if not v15 then
        return nil, v16;
    end;

    local buffer_create_ret = buffer.create(24);
    writeVector3F32(buffer_create_ret, writeVector3F32(buffer_create_ret, 0, p14.Anchor), p14.Velocity);
    local v17, v18 = readVector3F32(buffer_create_ret, 0);
    local v19, v20 = readVector3F32(buffer_create_ret, v18);
    assert(v20 == 24, "support canonicalization size drift");

    return {
        Kind = p14.Kind,
        SourceId = p14.SourceId,
        Anchor = v17,
        Velocity = v19
    }, nil;
end;

function u1.encode(p21) -- Line: 165
    -- upvalues: u1 (copy), u2 (copy), writeVector3F32 (copy), StateCodec (copy)
    local v22, v23 = u1.validate(p21);

    if not v22 then
        return nil, v23;
    end;

    local buffer_create_ret = buffer.create(u2);
    local v24 = 0;
    buffer.writeu8(buffer_create_ret, v24, 8);
    local v25 = v24 + 1;
    buffer.writeu8(buffer_create_ret, v25, p21.Flags);
    local v26 = v25 + 1;
    buffer.writeu16(buffer_create_ret, v26, p21.Generation);
    local v27 = v26 + 2;
    buffer.writeu32(buffer_create_ret, v27, p21.Sequence);
    local v28 = v27 + 4;
    buffer.writeu32(buffer_create_ret, v28, p21.ServerTick);
    local v29 = v28 + 4;
    buffer.writef64(buffer_create_ret, v29, p21.ServerTime);
    local v30 = v29 + 8;
    buffer.writeu32(buffer_create_ret, v30, p21.LastProcessedCommand);
    local v31 = v30 + 4;
    buffer.writei8(buffer_create_ret, v31, p21.BufferDepth);
    local v32 = v31 + 1;
    buffer.writeu16(buffer_create_ret, v32, p21.Topology.Epoch);
    local v33 = v32 + 2;
    buffer.writeu32(buffer_create_ret, v33, p21.Topology.Fingerprint);
    local v34 = v33 + 4;
    buffer.writeu32(buffer_create_ret, v34, p21.Topology.DestructibleRevision);
    local v35 = v34 + 4;
    buffer.writeu32(buffer_create_ret, v35, p21.Topology.MoverRevision);
    local v36 = v35 + 4;
    buffer.writeu8(buffer_create_ret, v36, p21.Support.Kind);
    local v37 = v36 + 1;
    buffer.writeu32(buffer_create_ret, v37, p21.Support.SourceId);
    local v38 = writeVector3F32(buffer_create_ret, writeVector3F32(buffer_create_ret, v37 + 4, p21.Support.Anchor), p21.Support.Velocity);
    assert(v38 == 68, "MovementV2 owner snapshot header size drift");
    StateCodec.writeValidated(buffer_create_ret, v38, p21.State);

    return buffer_create_ret, nil;
end;

function u1.decode(p39) -- Line: 208
    -- upvalues: u2 (copy), readVector3F32 (copy), StateCodec (copy), validateSnapshot (copy)
    if typeof(p39) ~= "buffer" then
        return nil, "SnapshotPayloadNotBuffer";
    end;

    if buffer.len(p39) ~= u2 then
        return nil, "SnapshotPayloadSize";
    end;

    local v40 = 0;

    if buffer.readu8(p39, v40) ~= 8 then
        return nil, "SnapshotVersion";
    end;

    local v41 = v40 + 1;
    local buffer_readu8_ret = buffer.readu8(p39, v41);
    local v42 = v41 + 1;
    local buffer_readu16_ret = buffer.readu16(p39, v42);
    local v43 = v42 + 2;
    local buffer_readu32_ret = buffer.readu32(p39, v43);
    local v44 = v43 + 4;
    local buffer_readu32_ret2 = buffer.readu32(p39, v44);
    local v45 = v44 + 4;
    local buffer_readf64_ret = buffer.readf64(p39, v45);
    local v46 = v45 + 8;
    local buffer_readu32_ret3 = buffer.readu32(p39, v46);
    local v47 = v46 + 4;
    local buffer_readi8_ret = buffer.readi8(p39, v47);
    local v48 = v47 + 1;
    local v49 = {
        Epoch = buffer.readu16(p39, v48),
        Fingerprint = buffer.readu32(p39, v48 + 2),
        DestructibleRevision = buffer.readu32(p39, v48 + 6),
        MoverRevision = buffer.readu32(p39, v48 + 10)
    };
    local v50 = v48 + 14;
    local buffer_readu8_ret2 = buffer.readu8(p39, v50);
    local v51 = v50 + 1;
    local buffer_readu32_ret4 = buffer.readu32(p39, v51);
    local v52, v53 = readVector3F32(p39, v51 + 4);
    local v54, v55 = readVector3F32(p39, v53);
    local v56 = {
        Kind = buffer_readu8_ret2,
        SourceId = buffer_readu32_ret4,
        Anchor = v52,
        Velocity = v54
    };
    assert(v55 == 68, "MovementV2 owner snapshot header size drift");
    local v57, v58, v59 = StateCodec.decodeFrom(p39, v55);

    if v57 == nil then
        return nil, v59;
    end;

    assert(v58 == u2, "MovementV2 owner snapshot state size drift");
    local v60 = {
        Generation = buffer_readu16_ret,
        Sequence = buffer_readu32_ret,
        ServerTick = buffer_readu32_ret2,
        ServerTime = buffer_readf64_ret,
        LastProcessedCommand = buffer_readu32_ret3,
        Flags = buffer_readu8_ret,
        BufferDepth = buffer_readi8_ret,
        State = v57,
        Topology = v49,
        Support = v56
    };
    local v61, v62 = validateSnapshot(v60, true);

    if v61 then
        return v60, nil;
    end;

    return nil, v62;
end;

return table.freeze(u1);