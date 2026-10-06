-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Enums);
local RemoteActorIdentity = require(script.Parent.RemoteActorIdentity);
local Quantization = require(script.Parent.Quantization);
local Serial = require(script.Parent.Serial);
require(script.Parent.Types);
local u1 = {};
local buffer_create_ret = buffer.create(4);
u1.Version = 6;
u1.HeaderSize = 29;
u1.MaxRecordsPerPacket = 22;
u1.MaxWireSize = 975;

local function vectorWithin(p2: any, p3: number) -- Line: 79
    -- upvalues: Quantization (copy)
    local v4 = Quantization.isFiniteVector3(p2);

    if v4 then
        if math.abs(p2.X) <= p3 and math.abs(p2.Y) <= p3 then
            v4 = math.abs(p2.Z) <= p3;
        else
            v4 = false;
        end;
    end;

    return v4;
end;

local function validateSupport(p5, p6) -- Line: 86
    -- upvalues: Enums (copy), Serial (copy)
    local v7;

    if typeof(p5) == "number" and (p5 % 1 == 0 and (Enums.SupportKind.None <= p5 and p5 <= Enums.SupportKind.Max)) then
        v7 = Serial.isUInt32(p6) and p5 == Enums.SupportKind.None == (p6 == 0);
    else
        v7 = false;
    end;

    return v7;
end;

local function canonicalFloat32(p8: number) -- Line: 95
    -- upvalues: buffer_create_ret (copy)
    buffer.writef32(buffer_create_ret, 0, p8);

    return buffer.readf32(buffer_create_ret, 0);
end;

local function canonicalVector3(p9: vector) -- Line: 100
    -- upvalues: buffer_create_ret (copy)
    buffer.writef32(buffer_create_ret, 0, p9.X);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret, 0);
    buffer.writef32(buffer_create_ret, 0, p9.Y);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret, 0);
    buffer.writef32(buffer_create_ret, 0, p9.Z);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret, 0);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function quantizeVelocity(p10: number) -- Line: 104
    local math_round_ret = math.round(p10 * 8);

    return math.clamp(math_round_ret, -32767, 32767);
end;

local function canonicalVelocity(p11: vector) -- Line: 108
    local math_round_ret = math.round(p11.X * 8);
    local v12 = math.clamp(math_round_ret, -32767, 32767) / 8;
    local math_round_ret2 = math.round(p11.Y * 8);
    local v13 = math.clamp(math_round_ret2, -32767, 32767) / 8;
    local math_round_ret3 = math.round(p11.Z * 8);
    local v14 = math.clamp(math_round_ret3, -32767, 32767) / 8;

    return Vector3.new(v12, v13, v14);
end;

function u1.validateActor(p15) -- Line: 116
    -- upvalues: Serial (copy), Quantization (copy), Enums (copy)
    if typeof(p15) ~= "table" then
        return false, "ActorNotTable";
    end;

    if type(p15.UserId) ~= "number" or (p15.UserId % 1 ~= 0 or (p15.UserId < 0 or p15.UserId > 9007199254740991)) then
        return false, "InvalidActorUserId";
    end;

    if not Serial.isNonZeroUInt16(p15.Generation) then
        return false, "InvalidActorGeneration";
    end;

    if not Serial.isUInt32(p15.ActorId) or p15.ActorId == 0 then
        return false, "InvalidActorId";
    end;

    local Position = p15.Position;
    local v16 = Quantization.isFiniteVector3(Position);

    if v16 then
        if math.abs(Position.X) <= 1000000 and math.abs(Position.Y) <= 1000000 then
            v16 = math.abs(Position.Z) <= 1000000;
        else
            v16 = false;
        end;
    end;

    if not v16 then
        return false, "InvalidActorPosition";
    end;

    local Velocity = p15.Velocity;
    local v17 = Quantization.isFiniteVector3(Velocity);

    if v17 then
        if math.abs(Velocity.X) <= 100000 and math.abs(Velocity.Y) <= 100000 then
            v17 = math.abs(Velocity.Z) <= 100000;
        else
            v17 = false;
        end;
    end;

    if not v17 then
        return false, "InvalidActorVelocity";
    end;

    if not Quantization.isFinite(p15.LookYaw) then
        return false, "InvalidActorLookYaw";
    end;

    if not (Quantization.isFinite(p15.VerticalLook) and (p15.VerticalLook >= -1 and p15.VerticalLook <= 1)) then
        return false, "InvalidActorVerticalLook";
    end;

    if p15.MovementMode ~= "Walking" and p15.MovementMode ~= "Ladder" then
        return false, "InvalidActorMovementMode";
    end;

    if p15.Stance ~= "Standing" and p15.Stance ~= "Ducking" then
        return false, "InvalidActorStance";
    end;

    if typeof(p15.OnGround) ~= "boolean" then
        return false, "InvalidActorOnGround";
    end;

    if not (Quantization.isFinite(p15.DuckAmount) and (p15.DuckAmount >= 0 and p15.DuckAmount <= 1)) then
        return false, "InvalidActorDuckAmount";
    end;

    local SupportKind = p15.SupportKind;
    local SupportSourceId = p15.SupportSourceId;
    local v18;

    if typeof(SupportKind) == "number" and (SupportKind % 1 == 0 and (Enums.SupportKind.None <= SupportKind and SupportKind <= Enums.SupportKind.Max)) then
        v18 = Serial.isUInt32(SupportSourceId) and SupportKind == Enums.SupportKind.None == (SupportSourceId == 0);
    else
        v18 = false;
    end;

    if not v18 then
        return false, "InvalidActorSupport";
    end;

    if p15.OnGround == (p15.SupportKind ~= Enums.SupportKind.None) then
        return true, nil;
    end;

    return false, "ActorGroundSupportMismatch";
end;

function u1.canonicalizeActor(p19) -- Line: 167
    -- upvalues: u1 (copy), buffer_create_ret (copy), Quantization (copy)
    local v20, v21 = u1.validateActor(p19);

    if not v20 then
        return nil, v21;
    end;

    local v22 = {
        UserId = p19.UserId,
        ActorId = p19.ActorId,
        Generation = p19.Generation
    };
    local Position = p19.Position;
    buffer.writef32(buffer_create_ret, 0, Position.X);
    local buffer_readf32_ret = buffer.readf32(buffer_create_ret, 0);
    buffer.writef32(buffer_create_ret, 0, Position.Y);
    local buffer_readf32_ret2 = buffer.readf32(buffer_create_ret, 0);
    buffer.writef32(buffer_create_ret, 0, Position.Z);
    local buffer_readf32_ret3 = buffer.readf32(buffer_create_ret, 0);
    v22.Position = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local Velocity = p19.Velocity;
    local math_round_ret = math.round(Velocity.X * 8);
    local v23 = math.clamp(math_round_ret, -32767, 32767) / 8;
    local math_round_ret2 = math.round(Velocity.Y * 8);
    local v24 = math.clamp(math_round_ret2, -32767, 32767) / 8;
    local math_round_ret3 = math.round(Velocity.Z * 8);
    local v25 = math.clamp(math_round_ret3, -32767, 32767) / 8;
    v22.Velocity = Vector3.new(v23, v24, v25);
    v22.LookYaw = Quantization.dequantizeYaw(Quantization.quantizeYaw(p19.LookYaw));
    v22.VerticalLook = Quantization.dequantizeSignedUnit(Quantization.quantizeSignedUnit(p19.VerticalLook));
    v22.MovementMode = p19.MovementMode;
    v22.Stance = p19.Stance;
    v22.OnGround = p19.OnGround;
    v22.DuckAmount = Quantization.dequantizeUnitByte(Quantization.quantizeUnitByte(p19.DuckAmount));
    v22.SupportKind = p19.SupportKind;
    v22.SupportSourceId = p19.SupportSourceId;

    return v22, nil;
end;

local function optionalPresent(p26) -- Line: 190
    return p26 ~= nil;
end;

function u1.validateDelta(p27) -- Line: 194
    -- upvalues: Serial (copy), Quantization (copy), Enums (copy)
    if typeof(p27) ~= "table" then
        return false, "RemoteDeltaNotTable";
    end;

    if not Serial.isUInt32(p27.ActorId) or p27.ActorId == 0 then
        return false, "InvalidRemoteDeltaActorId";
    end;

    local FieldMask = p27.FieldMask;

    if type(FieldMask) ~= "number" or (FieldMask % 1 ~= 0 or (FieldMask == 0 or bit32.band(FieldMask, 4294967168) ~= 0)) then
        return false, "InvalidRemoteDeltaFieldMask";
    end;

    local v28 = bit32.band(FieldMask, 1) ~= 0;
    local v29 = p27.PositionDelta ~= nil;
    local v30 = p27.AbsolutePosition ~= nil;

    if v28 ~= (v29 or v30) or v29 and v30 then
        return false, "InvalidRemoteDeltaPositionPresence";
    end;

    if v29 then
        local PositionDelta = p27.PositionDelta;
        local v31 = Quantization.isFiniteVector3(PositionDelta);

        if v31 then
            if math.abs(PositionDelta.X) <= 63.998046875 and math.abs(PositionDelta.Y) <= 63.998046875 then
                v31 = math.abs(PositionDelta.Z) <= 63.998046875;
            else
                v31 = false;
            end;
        end;

        if not v31 then
            return false, "InvalidRemoteDeltaPosition";
        end;
    end;

    if v30 then
        local AbsolutePosition = p27.AbsolutePosition;
        local v32 = Quantization.isFiniteVector3(AbsolutePosition);

        if v32 then
            if math.abs(AbsolutePosition.X) <= 1000000 and math.abs(AbsolutePosition.Y) <= 1000000 then
                v32 = math.abs(AbsolutePosition.Z) <= 1000000;
            else
                v32 = false;
            end;
        end;

        if not v32 then
            return false, "InvalidRemoteDeltaAbsolutePosition";
        end;
    end;

    local v33 = bit32.band(FieldMask, 2) ~= 0;

    if v33 ~= (p27.Velocity ~= nil) then
        return false, "InvalidRemoteDeltaVelocityPresence";
    end;

    if v33 then
        local Velocity = p27.Velocity;
        local v34 = Quantization.isFiniteVector3(Velocity);

        if v34 then
            if math.abs(Velocity.X) <= 100000 and math.abs(Velocity.Y) <= 100000 then
                v34 = math.abs(Velocity.Z) <= 100000;
            else
                v34 = false;
            end;
        end;

        if not v34 then
            return false, "InvalidRemoteDeltaVelocity";
        end;
    end;

    local v35 = bit32.band(FieldMask, 4) ~= 0;

    if v35 ~= (p27.LookYaw ~= nil) then
        return false, "InvalidRemoteDeltaLookYawPresence";
    end;

    if v35 and not Quantization.isFinite(p27.LookYaw) then
        return false, "InvalidRemoteDeltaLookYaw";
    end;

    local v36 = bit32.band(FieldMask, 8) ~= 0;

    if v36 ~= (p27.VerticalLook ~= nil) then
        return false, "InvalidRemoteDeltaVerticalLookPresence";
    end;

    if v36 and not (Quantization.isFinite(p27.VerticalLook) and (p27.VerticalLook >= -1 and p27.VerticalLook <= 1)) then
        return false, "InvalidRemoteDeltaVerticalLook";
    end;

    local v37 = bit32.band(FieldMask, 16) ~= 0;

    if v37 ~= (p27.MovementMode ~= nil and p27.Stance ~= nil and p27.OnGround ~= nil) then
        return false, "InvalidRemoteDeltaMovementPresence";
    end;

    if v37 then
        if p27.MovementMode ~= "Walking" and p27.MovementMode ~= "Ladder" then
            return false, "InvalidRemoteDeltaMovementMode";
        end;

        if p27.Stance ~= "Standing" and p27.Stance ~= "Ducking" then
            return false, "InvalidRemoteDeltaStance";
        end;

        if typeof(p27.OnGround) ~= "boolean" then
            return false, "InvalidRemoteDeltaOnGround";
        end;
    elseif p27.MovementMode ~= nil or (p27.Stance ~= nil or p27.OnGround ~= nil) then
        return false, "InvalidRemoteDeltaMovementPresence";
    end;

    local v38 = bit32.band(FieldMask, 32) ~= 0;

    if v38 ~= (p27.DuckAmount ~= nil) then
        return false, "InvalidRemoteDeltaDuckPresence";
    end;

    if v38 and not (Quantization.isFinite(p27.DuckAmount) and (p27.DuckAmount >= 0 and p27.DuckAmount <= 1)) then
        return false, "InvalidRemoteDeltaDuckAmount";
    end;

    local v39 = bit32.band(FieldMask, 64) ~= 0;

    if v39 ~= (p27.SupportKind ~= nil and p27.SupportSourceId ~= nil) then
        return false, "InvalidRemoteDeltaSupportPresence";
    end;

    if v39 then
        local SupportKind = p27.SupportKind;
        local SupportSourceId = p27.SupportSourceId;
        local v40;

        if typeof(SupportKind) == "number" and (SupportKind % 1 == 0 and (Enums.SupportKind.None <= SupportKind and SupportKind <= Enums.SupportKind.Max)) then
            v40 = Serial.isUInt32(SupportSourceId) and SupportKind == Enums.SupportKind.None == (SupportSourceId == 0);
        else
            v40 = false;
        end;

        if not v40 then
            return false, "InvalidRemoteDeltaSupport";
        end;
    end;

    if v39 or p27.SupportKind == nil and p27.SupportSourceId == nil then
        return true, nil;
    end;

    return false, "InvalidRemoteDeltaSupportPresence";
end;

local function quantizedPositionDelta(p41: vector, p42: vector) -- Line: 292
    local v43 = p41 - p42;
    local math_round_ret = math.round(v43.X * 512);
    local math_round_ret2 = math.round(v43.Y * 512);
    local math_round_ret3 = math.round(v43.Z * 512);

    if math.abs(math_round_ret) <= 32767 and (math.abs(math_round_ret2) <= 32767 and math.abs(math_round_ret3) <= 32767) then
        return Vector3.new(math_round_ret / 512, math_round_ret2 / 512, math_round_ret3 / 512), nil;
    end;

    return nil, p41;
end;

function u1.deltaFromCanonicalBaseline(p44, p45) -- Line: 307
    -- upvalues: quantizedPositionDelta (copy), u1 (copy)
    if p44.UserId ~= p45.UserId or (p44.ActorId ~= p45.ActorId or p44.Generation ~= p45.Generation) then
        return nil, "RemoteDeltaIdentityMismatch";
    end;

    local v46 = {
        FieldMask = 0,
        PositionDelta = nil,
        AbsolutePosition = nil,
        Velocity = nil,
        LookYaw = nil,
        VerticalLook = nil,
        MovementMode = nil,
        Stance = nil,
        OnGround = nil,
        DuckAmount = nil,
        SupportKind = nil,
        SupportSourceId = nil,
        ActorId = p44.ActorId
    };

    if p44.Position ~= p45.Position then
        local v47, v48 = quantizedPositionDelta(p44.Position, p45.Position);

        if v48 ~= nil or v47 ~= Vector3.new(0, 0, 0) then
            v46.FieldMask = bit32.bor(v46.FieldMask, 1);
            v46.PositionDelta = v47;
            v46.AbsolutePosition = v48;
        end;
    end;

    if p44.Velocity ~= p45.Velocity then
        v46.FieldMask = bit32.bor(v46.FieldMask, 2);
        v46.Velocity = p44.Velocity;
    end;

    if p44.LookYaw ~= p45.LookYaw then
        v46.FieldMask = bit32.bor(v46.FieldMask, 4);
        v46.LookYaw = p44.LookYaw;
    end;

    if p44.VerticalLook ~= p45.VerticalLook then
        v46.FieldMask = bit32.bor(v46.FieldMask, 8);
        v46.VerticalLook = p44.VerticalLook;
    end;

    if p44.MovementMode ~= p45.MovementMode or (p44.Stance ~= p45.Stance or p44.OnGround ~= p45.OnGround) then
        v46.FieldMask = bit32.bor(v46.FieldMask, 16);
        v46.MovementMode = p44.MovementMode;
        v46.Stance = p44.Stance;
        v46.OnGround = p44.OnGround;
    end;

    if p44.DuckAmount ~= p45.DuckAmount then
        v46.FieldMask = bit32.bor(v46.FieldMask, 32);
        v46.DuckAmount = p44.DuckAmount;
    end;

    if p44.SupportKind ~= p45.SupportKind or p44.SupportSourceId ~= p45.SupportSourceId then
        v46.FieldMask = bit32.bor(v46.FieldMask, 64);
        v46.SupportKind = p44.SupportKind;
        v46.SupportSourceId = p44.SupportSourceId;
    end;

    if v46.FieldMask == 0 then
        return nil, nil;
    end;

    local v49, v50 = u1.validateDelta(v46);

    if v49 then
        return v46, nil;
    end;

    return nil, v50;
end;

function u1.applyDeltaToCanonicalBaseline(p51: any, p52: any, p53: boolean?) -- Line: 385
    -- upvalues: u1 (copy)
    if not p53 then
        local v54, v55 = u1.validateDelta(p52);

        if not v54 then
            return nil, v55;
        end;
    end;

    if p52.ActorId ~= p51.ActorId then
        return nil, "RemoteDeltaIdentityMismatch";
    end;

    local v56 = {
        UserId = p51.UserId,
        ActorId = p51.ActorId,
        Generation = p51.Generation,
        Position = p51.Position,
        Velocity = p51.Velocity,
        LookYaw = p51.LookYaw,
        VerticalLook = p51.VerticalLook,
        MovementMode = p51.MovementMode,
        Stance = p51.Stance,
        OnGround = p51.OnGround,
        DuckAmount = p51.DuckAmount,
        SupportKind = p51.SupportKind,
        SupportSourceId = p51.SupportSourceId
    };

    if bit32.band(p52.FieldMask, 1) ~= 0 then
        local v57;

        if p52.AbsolutePosition == nil then
            v57 = p51.Position + assert(p52.PositionDelta);
        else
            v57 = p52.AbsolutePosition;
        end;

        v56.Position = v57;
    end;

    if bit32.band(p52.FieldMask, 2) ~= 0 then
        v56.Velocity = assert(p52.Velocity);
    end;

    if bit32.band(p52.FieldMask, 4) ~= 0 then
        v56.LookYaw = assert(p52.LookYaw);
    end;

    if bit32.band(p52.FieldMask, 8) ~= 0 then
        v56.VerticalLook = assert(p52.VerticalLook);
    end;

    if bit32.band(p52.FieldMask, 16) ~= 0 then
        v56.MovementMode = assert(p52.MovementMode);
        v56.Stance = assert(p52.Stance);
        v56.OnGround = p52.OnGround == true;
    end;

    if bit32.band(p52.FieldMask, 32) ~= 0 then
        v56.DuckAmount = assert(p52.DuckAmount);
    end;

    if bit32.band(p52.FieldMask, 64) ~= 0 then
        v56.SupportKind = assert(p52.SupportKind);
        v56.SupportSourceId = assert(p52.SupportSourceId);
    end;

    local v58, v59 = u1.validateActor(v56);

    if v58 then
        return v56, nil;
    end;

    return nil, v59;
end;

function u1.validate(p60) -- Line: 449
    -- upvalues: Serial (copy), u1 (copy), RemoteActorIdentity (copy)
    if typeof(p60) ~= "table" then
        return false, "RemoteSnapshotNotTable";
    end;

    if not Serial.isUInt32(p60.Sequence) then
        return false, "InvalidRemoteSequence";
    end;

    if p60.Kind ~= "Baseline" and p60.Kind ~= "Delta" then
        return false, "InvalidRemoteSnapshotKind";
    end;

    if not Serial.isUInt32(p60.BaselineSequence) then
        return false, "InvalidRemoteBaselineSequence";
    end;

    if p60.Kind == "Baseline" and p60.BaselineSequence ~= p60.Sequence then
        return false, "RemoteBaselineIdentityMismatch";
    end;

    if p60.Kind == "Delta" and Serial.deltaUInt32(p60.Sequence, p60.BaselineSequence) <= 0 then
        return false, "RemoteDeltaBaselineOrder";
    end;

    if not Serial.isUInt32(p60.ServerTick) then
        return false, "InvalidRemoteServerTick";
    end;

    if typeof(p60.Topology) ~= "table" or not (Serial.isNonZeroUInt16(p60.Topology.Epoch) and (Serial.isUInt32(p60.Topology.Fingerprint) and Serial.isUInt32(p60.Topology.DestructibleRevision))) then
        return false, "InvalidRemoteTopology";
    end;

    if type(p60.ChunkIndex) ~= "number" or (p60.ChunkIndex % 1 ~= 0 or (type(p60.ChunkCount) ~= "number" or (p60.ChunkCount % 1 ~= 0 or (p60.ChunkCount < 1 or (p60.ChunkCount > 255 or (p60.ChunkIndex < 0 or p60.ChunkIndex >= p60.ChunkCount)))))) then
        return false, "InvalidRemoteChunk";
    end;

    if type(p60.Actors) ~= "table" or (type(p60.Deltas) ~= "table" or type(p60.RemovedActorIds) ~= "table") then
        return false, "InvalidRemoteRecords";
    end;

    local v61 = #p60.Actors + #p60.Deltas + #p60.RemovedActorIds;

    if v61 > 22 then
        return false, "InvalidRemoteActorCount";
    end;

    if v61 == 0 and (p60.ChunkIndex ~= 0 or p60.ChunkCount ~= 1) then
        return false, "InvalidEmptyRemoteFrame";
    end;

    if p60.Kind == "Baseline" and (#p60.Deltas > 0 or #p60.RemovedActorIds > 0) then
        return false, "RemoteBaselineHasDeltaRecords";
    end;

    local v62 = nil;
    local v63 = {};

    for i, v in p60.Actors do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or #p60.Actors < i)) then
            return false, "RemoteActorsNotDenseArray";
        end;

        local v64, v65 = u1.validateActor(v);

        if not v64 then
            return false, v65;
        end;

        if v62 ~= nil and not RemoteActorIdentity.wireLess(v62, v) then
            return false, "RemoteActorsNotStrictlySorted";
        end;

        if v63[v.ActorId] then
            return false, "DuplicateActorId";
        end;

        v63[v.ActorId] = true;
        v62 = v;
    end;

    local v66 = 0;

    for i, v in p60.Deltas do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or #p60.Deltas < i)) then
            return false, "RemoteDeltasNotDenseArray";
        end;

        local v67, v68 = u1.validateDelta(v);

        if not v67 then
            return false, v68;
        end;

        if v.ActorId <= v66 then
            return false, "RemoteDeltasNotStrictlySorted";
        end;

        if v63[v.ActorId] then
            return false, "DuplicateActorId";
        end;

        v63[v.ActorId] = true;
        v66 = v.ActorId;
    end;

    local v69 = 0;

    for i, v in p60.RemovedActorIds do
        if type(i) ~= "number" or (i % 1 ~= 0 or (i < 1 or (#p60.RemovedActorIds < i or not (Serial.isUInt32(v) and (v ~= 0 and v > v69))))) then
            return false, "InvalidRemovedRemoteActorId";
        end;

        if v63[v] then
            return false, "RemoteActorAlsoRemoved";
        end;

        v63[v] = true;
        v69 = v;
    end;

    return true, nil;
end;

local function writeVector3(p70: buffer, p71: number, p72: vector) -- Line: 564
    buffer.writef32(p70, p71, p72.X);
    buffer.writef32(p70, p71 + 4, p72.Y);
    buffer.writef32(p70, p71 + 8, p72.Z);

    return p71 + 12;
end;

local function readVector3(p73: buffer, p74: number) -- Line: 571
    local buffer_readf32_ret = buffer.readf32(p73, p74);
    local buffer_readf32_ret2 = buffer.readf32(p73, p74 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p73, p74 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3), p74 + 12;
end;

local function writeVelocity(p75: buffer, p76: number, p77: vector) -- Line: 580
    local math_round_ret = math.round(p77.X * 8);
    local math_clamp_ret = math.clamp(math_round_ret, -32767, 32767);
    buffer.writei16(p75, p76, math_clamp_ret);
    local math_round_ret2 = math.round(p77.Y * 8);
    local math_clamp_ret2 = math.clamp(math_round_ret2, -32767, 32767);
    buffer.writei16(p75, p76 + 2, math_clamp_ret2);
    local math_round_ret3 = math.round(p77.Z * 8);
    local math_clamp_ret3 = math.clamp(math_round_ret3, -32767, 32767);
    buffer.writei16(p75, p76 + 4, math_clamp_ret3);

    return p76 + 6;
end;

local function readVelocity(p78: buffer, p79: number) -- Line: 587
    local v80 = buffer.readi16(p78, p79) / 8;
    local v81 = buffer.readi16(p78, p79 + 2) / 8;
    local v82 = buffer.readi16(p78, p79 + 4) / 8;

    return Vector3.new(v80, v81, v82), p79 + 6;
end;

local function actorFlags(p83) -- Line: 596
    local v84 = 0;

    if p83.OnGround then
        v84 = bit32.bor(v84, 1);
    end;

    if p83.MovementMode == "Ladder" then
        v84 = bit32.bor(v84, 2);
    end;

    if p83.Stance == "Ducking" then
        v84 = bit32.bor(v84, 4);
    end;

    local bit32_lshift_ret = bit32.lshift(p83.SupportKind, 3);

    return bit32.bor(v84, bit32_lshift_ret);
end;

local function unsignedVarintSize(p85: number) -- Line: 610
    local v86 = 1;

    while p85 >= 128 do
        p85 = math.floor(p85 / 128);
        v86 = v86 + 1;
    end;

    return v86;
end;

local function writeUnsignedVarint(p87: buffer, p88: number, p89: number) -- Line: 619
    while true do
        local v90 = p89 % 128;
        p89 = math.floor(p89 / 128);

        if p89 > 0 then
            v90 = v90 + 128;
        end;

        buffer.writeu8(p87, p88, v90);
        p88 = p88 + 1;

        if p89 == 0 then
            return p88;
        end;
    end;
end;

local function readUnsignedVarint(p91: buffer, p92: number, p93: number, p94: number) -- Line: 632
    local v95 = 0;
    local v96 = 1;

    for i = 1, p93 do
        if buffer.len(p91) <= p92 then
            return nil, p92, "RemoteActorVarintTruncated";
        end;

        local buffer_readu8_ret = buffer.readu8(p91, p92);
        p92 = p92 + 1;
        local bit32_band_ret = bit32.band(buffer_readu8_ret, 127);

        if math.floor((p94 - v95) / v96) < bit32_band_ret then
            return nil, p92, "RemoteActorVarintOverflow";
        end;

        v95 = v95 + bit32_band_ret * v96;

        if buffer_readu8_ret < 128 then
            local v97 = v95;
            local v98 = 1;

            while v95 >= 128 do
                v95 = math.floor(v95 / 128);
                v98 = v98 + 1;
            end;

            if v98 == i then
                return v97, p92, nil;
            end;

            return nil, p92, "RemoteActorVarintNonCanonical";
        end;

        v96 = v96 * 128;
        local _ = i;
    end;

    return nil, p92, "RemoteActorVarintTooLong";
end;

local function fullActorWireSize(p99) -- Line: 662
    -- upvalues: Enums (copy)
    local UserId = p99.UserId;
    local v100 = 1;

    while UserId >= 128 do
        UserId = math.floor(UserId / 128);
        v100 = v100 + 1;
    end;

    local ActorId = p99.ActorId;
    local v101 = 1;

    while ActorId >= 128 do
        ActorId = math.floor(ActorId / 128);
        v101 = v101 + 1;
    end;

    local Generation = p99.Generation;
    local v102 = 1;

    while Generation >= 128 do
        Generation = math.floor(Generation / 128);
        v102 = v102 + 1;
    end;

    return v100 + v101 + v102 + 23 + (p99.SupportKind == Enums.SupportKind.None and 0 or 4);
end;

local function deltaActorWireSize(p103) -- Line: 670
    -- upvalues: Enums (copy)
    local ActorId = p103.ActorId;
    local v104 = 1;

    while ActorId >= 128 do
        ActorId = math.floor(ActorId / 128);
        v104 = v104 + 1;
    end;

    local v105 = v104 + 1;

    if bit32.band(p103.FieldMask, 1) ~= 0 then
        v105 = v105 + (p103.AbsolutePosition == nil and 6 or 14);
    end;

    if bit32.band(p103.FieldMask, 2) ~= 0 then
        v105 = v105 + 6;
    end;

    if bit32.band(p103.FieldMask, 4) ~= 0 then
        v105 = v105 + 2;
    end;

    if bit32.band(p103.FieldMask, 8) ~= 0 then
        v105 = v105 + 1;
    end;

    if bit32.band(p103.FieldMask, 16) ~= 0 then
        v105 = v105 + 1;
    end;

    if bit32.band(p103.FieldMask, 32) ~= 0 then
        v105 = v105 + 1;
    end;

    if bit32.band(p103.FieldMask, 64) ~= 0 then
        v105 = v105 + ((p103.SupportKind == Enums.SupportKind.None and 0 or 4) + 1);
    end;

    return v105;
end;

local function writeFullActor(p106: buffer, p107: number, p108: any) -- Line: 696
    -- upvalues: writeUnsignedVarint (copy), Quantization (copy), Enums (copy)
    local v109 = writeUnsignedVarint(p106, writeUnsignedVarint(p106, writeUnsignedVarint(p106, p107, p108.UserId), p108.ActorId), p108.Generation);
    local Position = p108.Position;
    buffer.writef32(p106, v109, Position.X);
    buffer.writef32(p106, v109 + 4, Position.Y);
    buffer.writef32(p106, v109 + 8, Position.Z);
    local v110 = v109 + 12;
    local Velocity = p108.Velocity;
    local math_round_ret = math.round(Velocity.X * 8);
    local math_clamp_ret = math.clamp(math_round_ret, -32767, 32767);
    buffer.writei16(p106, v110, math_clamp_ret);
    local math_round_ret2 = math.round(Velocity.Y * 8);
    local math_clamp_ret2 = math.clamp(math_round_ret2, -32767, 32767);
    buffer.writei16(p106, v110 + 2, math_clamp_ret2);
    local math_round_ret3 = math.round(Velocity.Z * 8);
    local math_clamp_ret3 = math.clamp(math_round_ret3, -32767, 32767);
    buffer.writei16(p106, v110 + 4, math_clamp_ret3);
    local v111 = v110 + 6;
    local v112 = Quantization.quantizeYaw(p108.LookYaw);
    buffer.writeu16(p106, v111, v112);
    local v113 = v111 + 2;
    local v114 = Quantization.quantizeSignedUnit(p108.VerticalLook);
    buffer.writei8(p106, v113, v114);
    local v115 = v113 + 1;
    local v116 = 0;

    if p108.OnGround then
        v116 = bit32.bor(v116, 1);
    end;

    if p108.MovementMode == "Ladder" then
        v116 = bit32.bor(v116, 2);
    end;

    if p108.Stance == "Ducking" then
        v116 = bit32.bor(v116, 4);
    end;

    local bit32_lshift_ret = bit32.lshift(p108.SupportKind, 3);
    local bit32_bor_ret = bit32.bor(v116, bit32_lshift_ret);
    buffer.writeu8(p106, v115, bit32_bor_ret);
    local v117 = v115 + 1;
    local v118 = Quantization.quantizeUnitByte(p108.DuckAmount);
    buffer.writeu8(p106, v117, v118);
    local v119 = v117 + 1;

    if p108.SupportKind ~= Enums.SupportKind.None then
        buffer.writeu32(p106, v119, p108.SupportSourceId);
        v119 = v119 + 4;
    end;

    return v119;
end;

local function writeDeltaActor(p120: buffer, p121: number, p122: any) -- Line: 717
    -- upvalues: writeUnsignedVarint (copy), Quantization (copy), Enums (copy)
    local v123 = writeUnsignedVarint(p120, p121, p122.ActorId);
    buffer.writeu8(p120, v123, p122.FieldMask);
    local v124 = v123 + 1;

    if bit32.band(p122.FieldMask, 1) ~= 0 then
        if p122.AbsolutePosition == nil then
            local v125 = assert(p122.PositionDelta);
            local math_round_ret = math.round(v125.X * 512);
            buffer.writei16(p120, v124, math_round_ret);
            local math_round_ret2 = math.round(v125.Y * 512);
            buffer.writei16(p120, v124 + 2, math_round_ret2);
            local math_round_ret3 = math.round(v125.Z * 512);
            buffer.writei16(p120, v124 + 4, math_round_ret3);
            v124 = v124 + 6;
        else
            buffer.writei16(p120, v124, -32768);
            local v126 = v124 + 2;
            local AbsolutePosition = p122.AbsolutePosition;
            buffer.writef32(p120, v126, AbsolutePosition.X);
            buffer.writef32(p120, v126 + 4, AbsolutePosition.Y);
            buffer.writef32(p120, v126 + 8, AbsolutePosition.Z);
            v124 = v126 + 12;
        end;
    end;

    if bit32.band(p122.FieldMask, 2) ~= 0 then
        local v127 = assert(p122.Velocity);
        local math_round_ret = math.round(v127.X * 8);
        local math_clamp_ret = math.clamp(math_round_ret, -32767, 32767);
        buffer.writei16(p120, v124, math_clamp_ret);
        local math_round_ret2 = math.round(v127.Y * 8);
        local math_clamp_ret2 = math.clamp(math_round_ret2, -32767, 32767);
        buffer.writei16(p120, v124 + 2, math_clamp_ret2);
        local math_round_ret3 = math.round(v127.Z * 8);
        local math_clamp_ret3 = math.clamp(math_round_ret3, -32767, 32767);
        buffer.writei16(p120, v124 + 4, math_clamp_ret3);
        v124 = v124 + 6;
    end;

    if bit32.band(p122.FieldMask, 4) ~= 0 then
        local v128 = Quantization.quantizeYaw(assert(p122.LookYaw));
        buffer.writeu16(p120, v124, v128);
        v124 = v124 + 2;
    end;

    if bit32.band(p122.FieldMask, 8) ~= 0 then
        local v129 = Quantization.quantizeSignedUnit(assert(p122.VerticalLook));
        buffer.writei8(p120, v124, v129);
        v124 = v124 + 1;
    end;

    if bit32.band(p122.FieldMask, 16) ~= 0 then
        local v130 = 0;

        if p122.OnGround == true then
            v130 = bit32.bor(v130, 1);
        end;

        if p122.MovementMode == "Ladder" then
            v130 = bit32.bor(v130, 2);
        end;

        if p122.Stance == "Ducking" then
            v130 = bit32.bor(v130, 4);
        end;

        buffer.writeu8(p120, v124, v130);
        v124 = v124 + 1;
    end;

    if bit32.band(p122.FieldMask, 32) ~= 0 then
        local v131 = Quantization.quantizeUnitByte(assert(p122.DuckAmount));
        buffer.writeu8(p120, v124, v131);
        v124 = v124 + 1;
    end;

    if bit32.band(p122.FieldMask, 64) ~= 0 then
        local v132 = assert(p122.SupportKind);
        buffer.writeu8(p120, v124, v132);
        v124 = v124 + 1;

        if v132 ~= Enums.SupportKind.None then
            local v133 = assert(p122.SupportSourceId);
            buffer.writeu32(p120, v124, v133);
            v124 = v124 + 4;
        end;
    end;

    return v124;
end;

local function encodeValidated(p134) -- Line: 774
    -- upvalues: Enums (copy), deltaActorWireSize (copy), writeFullActor (copy), writeDeltaActor (copy), writeUnsignedVarint (copy)
    local v135 = 29;

    for _, v in p134.Actors do
        local UserId = v.UserId;
        local v136 = v;
        local v137 = 1;

        while UserId >= 128 do
            UserId = math.floor(UserId / 128);
            v137 = v137 + 1;
        end;

        local ActorId = v136.ActorId;
        local v138 = 1;

        while ActorId >= 128 do
            ActorId = math.floor(ActorId / 128);
            v138 = v138 + 1;
        end;

        local Generation = v136.Generation;
        local v139 = 1;

        while Generation >= 128 do
            Generation = math.floor(Generation / 128);
            v139 = v139 + 1;
        end;

        v135 = v135 + (v137 + v138 + v139 + 23 + (v136.SupportKind == Enums.SupportKind.None and 0 or 4));
    end;

    for _, v in p134.Deltas do
        v135 = v135 + deltaActorWireSize(v);
    end;

    for _, v in p134.RemovedActorIds do
        local v140 = v;
        local v141 = 1;

        while v140 >= 128 do
            v140 = math.floor(v140 / 128);
            v141 = v141 + 1;
        end;

        v135 = v135 + v141;
    end;

    local buffer_create_ret2 = buffer.create(v135);
    local v142 = 0;
    buffer.writeu8(buffer_create_ret2, v142, 6);
    local v143 = v142 + 1;
    buffer.writeu8(buffer_create_ret2, v143, p134.Kind == "Baseline" and 0 or 1);
    local v144 = v143 + 1;
    buffer.writeu32(buffer_create_ret2, v144, p134.Sequence);
    local v145 = v144 + 4;
    buffer.writeu32(buffer_create_ret2, v145, p134.BaselineSequence);
    local v146 = v145 + 4;
    buffer.writeu32(buffer_create_ret2, v146, p134.ServerTick);
    local v147 = v146 + 4;
    buffer.writeu16(buffer_create_ret2, v147, p134.Topology.Epoch);
    local v148 = v147 + 2;
    buffer.writeu32(buffer_create_ret2, v148, p134.Topology.Fingerprint);
    local v149 = v148 + 4;
    buffer.writeu32(buffer_create_ret2, v149, p134.Topology.DestructibleRevision);
    local v150 = v149 + 4;
    buffer.writeu8(buffer_create_ret2, v150, p134.ChunkIndex);
    local v151 = v150 + 1;
    buffer.writeu8(buffer_create_ret2, v151, p134.ChunkCount);
    local v152 = v151 + 1;
    buffer.writeu8(buffer_create_ret2, v152, #p134.Actors);
    local v153 = v152 + 1;
    buffer.writeu8(buffer_create_ret2, v153, #p134.Deltas);
    local v154 = v153 + 1;
    buffer.writeu8(buffer_create_ret2, v154, #p134.RemovedActorIds);
    local v155 = v154 + 1;
    assert(v155 == 29, "MovementV2 remote header size drift");

    for _, v in p134.Actors do
        v155 = writeFullActor(buffer_create_ret2, v155, v);
    end;

    for _, v in p134.Deltas do
        v155 = writeDeltaActor(buffer_create_ret2, v155, v);
    end;

    for _, v in p134.RemovedActorIds do
        v155 = writeUnsignedVarint(buffer_create_ret2, v155, v);
    end;

    local v156 = v155 == buffer.len(buffer_create_ret2);
    assert(v156, "MovementV2 remote payload size drift");

    return buffer_create_ret2;
end;

function u1.encodeValidated(p157) -- Line: 828
    -- upvalues: encodeValidated (copy)
    return encodeValidated(p157);
end;

function u1.encode(p158) -- Line: 832
    -- upvalues: u1 (copy), encodeValidated (copy)
    local v159, v160 = u1.validate(p158);

    if v159 then
        return encodeValidated(p158), nil;
    end;

    return nil, v160;
end;

local function readFullActor(p161: buffer, p162: number) -- Line: 840
    -- upvalues: readUnsignedVarint (copy), Serial (copy), Quantization (copy), Enums (copy)
    local v163, v164, v165 = readUnsignedVarint(p161, p162, 8, 9007199254740991);

    if v163 == nil then
        return nil, v164, v165;
    end;

    local v166, v167, v168 = readUnsignedVarint(p161, v164, 5, Serial.UInt32Max);

    if v166 == nil then
        return nil, v167, v168;
    end;

    local v169, v170, v171 = readUnsignedVarint(p161, v167, 3, Serial.UInt16Max);

    if v169 == nil then
        return nil, v170, v171;
    end;

    if buffer.len(p161) - v170 < 23 then
        return nil, v170, "RemotePayloadSize";
    end;

    local buffer_readf32_ret = buffer.readf32(p161, v170);
    local buffer_readf32_ret2 = buffer.readf32(p161, v170 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p161, v170 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v172 = v170 + 12;
    local v173 = buffer.readi16(p161, v172) / 8;
    local v174 = buffer.readi16(p161, v172 + 2) / 8;
    local v175 = buffer.readi16(p161, v172 + 4) / 8;
    local Vector3_new_ret2 = Vector3.new(v173, v174, v175);
    local v176 = v172 + 6;
    local v177 = Quantization.dequantizeYaw((buffer.readu16(p161, v176)));
    local v178 = v176 + 2;
    local v179 = Quantization.dequantizeSignedUnit((buffer.readi8(p161, v178)));
    local v180 = v178 + 1;
    local buffer_readu8_ret = buffer.readu8(p161, v180);
    local v181 = v180 + 1;

    if bit32.band(buffer_readu8_ret, 4294967232) ~= 0 then
        return nil, v181, "InvalidRemoteActorFlags";
    end;

    local v182 = Quantization.dequantizeUnitByte((buffer.readu8(p161, v181)));
    local v183 = v181 + 1;
    local v184 = bit32.band(buffer_readu8_ret, 56) / 8;

    if Enums.SupportKind.Max < v184 then
        return nil, v183, "InvalidActorSupport";
    end;

    local v185;

    if v184 == Enums.SupportKind.None then
        v185 = 0;
    else
        if buffer.len(p161) - v183 < 4 then
            return nil, v183, "RemotePayloadSize";
        end;

        v185 = buffer.readu32(p161, v183);
        v183 = v183 + 4;
    end;

    return {
        UserId = v163,
        ActorId = v166,
        Generation = v169,
        Position = Vector3_new_ret,
        Velocity = Vector3_new_ret2,
        LookYaw = v177,
        VerticalLook = v179,
        MovementMode = bit32.band(buffer_readu8_ret, 2) == 0 and "Walking" or "Ladder",
        Stance = bit32.band(buffer_readu8_ret, 4) == 0 and "Standing" or "Ducking",
        OnGround = bit32.band(buffer_readu8_ret, 1) ~= 0,
        DuckAmount = v182,
        SupportKind = v184,
        SupportSourceId = v185
    }, v183, nil;
end;

local function readDeltaActor(p186: buffer, p187: number) -- Line: 902
    -- upvalues: readUnsignedVarint (copy), Serial (copy), Quantization (copy), Enums (copy), u1 (copy)
    local v188, v189, v190 = readUnsignedVarint(p186, p187, 5, Serial.UInt32Max);

    if v188 == nil then
        return nil, v189, v190;
    end;

    if buffer.len(p186) <= v189 then
        return nil, v189, "RemotePayloadSize";
    end;

    local buffer_readu8_ret = buffer.readu8(p186, v189);
    local v191 = v189 + 1;

    if buffer_readu8_ret == 0 or bit32.band(buffer_readu8_ret, 4294967168) ~= 0 then
        return nil, v191, "InvalidRemoteDeltaFieldMask";
    end;

    local v192 = {
        PositionDelta = nil,
        AbsolutePosition = nil,
        Velocity = nil,
        LookYaw = nil,
        VerticalLook = nil,
        MovementMode = nil,
        Stance = nil,
        OnGround = nil,
        DuckAmount = nil,
        SupportKind = nil,
        SupportSourceId = nil,
        ActorId = v188,
        FieldMask = buffer_readu8_ret
    };

    if bit32.band(buffer_readu8_ret, 1) ~= 0 then
        if buffer.len(p186) - v191 < 2 then
            return nil, v191, "RemotePayloadSize";
        end;

        local buffer_readi16_ret = buffer.readi16(p186, v191);

        if buffer_readi16_ret == -32768 then
            if buffer.len(p186) - v191 < 14 then
                return nil, v191, "RemotePayloadSize";
            end;

            local v193 = v191 + 2;
            local buffer_readf32_ret = buffer.readf32(p186, v193);
            local buffer_readf32_ret2 = buffer.readf32(p186, v193 + 4);
            local buffer_readf32_ret3 = buffer.readf32(p186, v193 + 8);
            local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
            v191 = v193 + 12;
            v192.AbsolutePosition = Vector3_new_ret;
        else
            if buffer.len(p186) - v191 < 6 then
                return nil, v191, "RemotePayloadSize";
            end;

            local v194 = buffer.readi16(p186, v191 + 2) / 512;
            local v195 = buffer.readi16(p186, v191 + 4) / 512;
            v192.PositionDelta = Vector3.new(buffer_readi16_ret / 512, v194, v195);
            v191 = v191 + 6;
        end;
    end;

    if bit32.band(buffer_readu8_ret, 2) ~= 0 then
        if buffer.len(p186) - v191 < 6 then
            return nil, v191, "RemotePayloadSize";
        end;

        local v196 = buffer.readi16(p186, v191) / 8;
        local v197 = buffer.readi16(p186, v191 + 2) / 8;
        local v198 = buffer.readi16(p186, v191 + 4) / 8;
        local Vector3_new_ret = Vector3.new(v196, v197, v198);
        v191 = v191 + 6;
        v192.Velocity = Vector3_new_ret;
    end;

    if bit32.band(buffer_readu8_ret, 4) ~= 0 then
        if buffer.len(p186) - v191 < 2 then
            return nil, v191, "RemotePayloadSize";
        end;

        v192.LookYaw = Quantization.dequantizeYaw((buffer.readu16(p186, v191)));
        v191 = v191 + 2;
    end;

    if bit32.band(buffer_readu8_ret, 8) ~= 0 then
        if buffer.len(p186) <= v191 then
            return nil, v191, "RemotePayloadSize";
        end;

        v192.VerticalLook = Quantization.dequantizeSignedUnit((buffer.readi8(p186, v191)));
        v191 = v191 + 1;
    end;

    if bit32.band(buffer_readu8_ret, 16) ~= 0 then
        if buffer.len(p186) <= v191 then
            return nil, v191, "RemotePayloadSize";
        end;

        local buffer_readu8_ret2 = buffer.readu8(p186, v191);
        v191 = v191 + 1;

        if bit32.band(buffer_readu8_ret2, 4294967288) ~= 0 then
            return nil, v191, "InvalidRemoteDeltaMovementFlags";
        end;

        v192.MovementMode = bit32.band(buffer_readu8_ret2, 2) == 0 and "Walking" or "Ladder";
        v192.Stance = bit32.band(buffer_readu8_ret2, 4) == 0 and "Standing" or "Ducking";
        v192.OnGround = bit32.band(buffer_readu8_ret2, 1) ~= 0;
    end;

    if bit32.band(buffer_readu8_ret, 32) ~= 0 then
        if buffer.len(p186) <= v191 then
            return nil, v191, "RemotePayloadSize";
        end;

        v192.DuckAmount = Quantization.dequantizeUnitByte((buffer.readu8(p186, v191)));
        v191 = v191 + 1;
    end;

    if bit32.band(buffer_readu8_ret, 64) ~= 0 then
        if buffer.len(p186) <= v191 then
            return nil, v191, "RemotePayloadSize";
        end;

        local buffer_readu8_ret2 = buffer.readu8(p186, v191);
        v191 = v191 + 1;

        if Enums.SupportKind.Max < buffer_readu8_ret2 then
            return nil, v191, "InvalidRemoteDeltaSupport";
        end;

        local v199;

        if buffer_readu8_ret2 == Enums.SupportKind.None then
            v199 = 0;
        else
            if buffer.len(p186) - v191 < 4 then
                return nil, v191, "RemotePayloadSize";
            end;

            v199 = buffer.readu32(p186, v191);
            v191 = v191 + 4;
        end;

        v192.SupportKind = buffer_readu8_ret2;
        v192.SupportSourceId = v199;
    end;

    local v200, v201 = u1.validateDelta(v192);

    if v200 then
        return v192, v191, nil;
    end;

    return nil, v191, v201;
end;

function u1.decode(p202) -- Line: 1020
    -- upvalues: u1 (copy), readFullActor (copy), readDeltaActor (copy), readUnsignedVarint (copy), Serial (copy)
    if typeof(p202) ~= "buffer" then
        return nil, "RemotePayloadNotBuffer";
    end;

    if buffer.len(p202) < 29 or buffer.len(p202) > u1.MaxWireSize then
        return nil, "RemotePayloadSize";
    end;

    local v203 = 0;

    if buffer.readu8(p202, v203) ~= 6 then
        return nil, "RemoteVersion";
    end;

    local v204 = v203 + 1;
    local buffer_readu8_ret = buffer.readu8(p202, v204);
    local v205 = v204 + 1;

    if buffer_readu8_ret > 1 then
        return nil, "InvalidRemoteSnapshotKind";
    end;

    local buffer_readu32_ret = buffer.readu32(p202, v205);
    local v206 = v205 + 4;
    local buffer_readu32_ret2 = buffer.readu32(p202, v206);
    local v207 = v206 + 4;
    local buffer_readu32_ret3 = buffer.readu32(p202, v207);
    local v208 = v207 + 4;
    local buffer_readu16_ret = buffer.readu16(p202, v208);
    local v209 = v208 + 2;
    local buffer_readu32_ret4 = buffer.readu32(p202, v209);
    local v210 = v209 + 4;
    local buffer_readu32_ret5 = buffer.readu32(p202, v210);
    local v211 = v210 + 4;
    local buffer_readu8_ret2 = buffer.readu8(p202, v211);
    local v212 = v211 + 1;
    local buffer_readu8_ret3 = buffer.readu8(p202, v212);
    local v213 = v212 + 1;
    local buffer_readu8_ret4 = buffer.readu8(p202, v213);
    local v214 = v213 + 1;
    local buffer_readu8_ret5 = buffer.readu8(p202, v214);
    local v215 = v214 + 1;
    local buffer_readu8_ret6 = buffer.readu8(p202, v215);
    local v216 = v215 + 1;

    if buffer_readu8_ret4 + buffer_readu8_ret5 + buffer_readu8_ret6 > 22 then
        return nil, "InvalidRemoteActorCount";
    end;

    if buffer.len(p202) < buffer_readu8_ret4 * 26 + 29 + buffer_readu8_ret5 * 3 + buffer_readu8_ret6 or buffer_readu8_ret4 * 43 + 29 + buffer_readu8_ret5 * 36 + buffer_readu8_ret6 * 5 < buffer.len(p202) then
        return nil, "RemotePayloadSize";
    end;

    local table_create_ret = table.create(buffer_readu8_ret4);

    for i = 1, buffer_readu8_ret4 do
        local v217, v218;
        v217, v216, v218 = readFullActor(p202, v216);

        if v217 == nil then
            return nil, v218;
        end;

        table_create_ret[i] = v217;
        local _ = i;
    end;

    local table_create_ret2 = table.create(buffer_readu8_ret5);

    for i = 1, buffer_readu8_ret5 do
        local v219, v220;
        v219, v216, v220 = readDeltaActor(p202, v216);

        if v219 == nil then
            return nil, v220;
        end;

        table_create_ret2[i] = v219;
        local _ = i;
    end;

    local table_create_ret3 = table.create(buffer_readu8_ret6);

    for i = 1, buffer_readu8_ret6 do
        local v221, v222;
        v221, v216, v222 = readUnsignedVarint(p202, v216, 5, Serial.UInt32Max);

        if v221 == nil then
            return nil, v222;
        end;

        table_create_ret3[i] = v221;
        local _ = i;
    end;

    if v216 ~= buffer.len(p202) then
        return nil, "RemotePayloadSize";
    end;

    local v223 = {
        Kind = buffer_readu8_ret == 0 and "Baseline" or "Delta",
        Sequence = buffer_readu32_ret,
        BaselineSequence = buffer_readu32_ret2,
        ServerTick = buffer_readu32_ret3,
        Topology = {
            Epoch = buffer_readu16_ret,
            Fingerprint = buffer_readu32_ret4,
            DestructibleRevision = buffer_readu32_ret5
        },
        ChunkIndex = buffer_readu8_ret2,
        ChunkCount = buffer_readu8_ret3,
        Actors = table_create_ret,
        Deltas = table_create_ret2,
        RemovedActorIds = table_create_ret3
    };
    local v224, v225 = u1.validate(v223);

    if v224 then
        return v223, nil;
    end;

    return nil, v225;
end;

return table.freeze(u1);