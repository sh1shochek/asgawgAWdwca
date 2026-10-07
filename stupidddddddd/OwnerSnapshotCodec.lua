-- ReplicatedStorage.MovementV2.OwnerSnapshotCodec
-- Script path: ReplicatedStorage.MovementV2.OwnerSnapshotCodec
-- Decompile time: 4.20 ms

local Enums = require(script.Parent.Enums)
local Quantization = require(script.Parent.Quantization)
local Serial = require(script.Parent.Serial)
local StateCodec = require(script.Parent.StateCodec)
require(script.Parent.Types)
local u25 = {}
local u28 = 68 + StateCodec.WireSize
u25.Version = 8
u25.HeaderSize = 68
u25.WireSize = u28
local isVector3Within = Quantization.isVector3Within
local writeVector3F32 = Quantization.writeVector3F32
local readVector3F32 = Quantization.readVector3F32

local function validateTopology(a1) -- Line: 31 -- upvalues: Serial (val)
    if typeof(a1) ~= "table" then
        return false, "TopologyNotTable"
    end
    if not Serial.isNonZeroUInt16(a1.Epoch) then
        return false, "InvalidTopologyEpoch"
    end
    if not Serial.isUInt32(a1.Fingerprint) then
        return false, "InvalidTopologyFingerprint"
    end
    if not Serial.isUInt32(a1.DestructibleRevision) then
        return false, "InvalidDestructibleRevision"
    end
    if not Serial.isUInt32(a1.MoverRevision) then
        return false, "InvalidMoverRevision"
    end
    return true, nil
end

local function validateSupport(a1) -- Line: 50 -- upvalues: Enums (val), Serial (val), isVector3Within (val)
    if typeof(a1) ~= "table" then
        return false, "SupportNotTable"
    end
    if typeof(a1.Kind) == "number"
        and a1.Kind % 1 == 0
        and not (a1.Kind < Enums.SupportKind.None)
        and not (Enums.SupportKind.Max < a1.Kind) then
        if not Serial.isUInt32(a1.SourceId) then
            return false, "InvalidSupportSourceId"
        end
        if a1.Kind == Enums.SupportKind.None ~= (a1.SourceId == 0) then
            return false, "InvalidEmptySupport"
        end
        if not isVector3Within(a1.Anchor, 1000000) then
            return false, "InvalidSupportAnchor"
        end
        if not isVector3Within(a1.Velocity, 100000) then
            return false, "InvalidSupportVelocity"
        end
        if a1.Kind ~= Enums.SupportKind.None then
            return true, nil
        end
        if not (0 < a1.Anchor.Magnitude) and not (0 < a1.Velocity.Magnitude) then
            return true, nil
        end
        return false, "NonCanonicalEmptySupport"
    end
    return false, "InvalidSupportKind"
end

local function validateSnapshot(a1, a2) -- Line: 80
    -- upvalues: Serial (val), Enums (val), StateCodec (val), validateTopology (val), validateSupport (val)
    if typeof(a1) ~= "table" then
        return false, "SnapshotNotTable"
    end
    if not Serial.isNonZeroUInt16(a1.Generation) then
        return false, "InvalidGeneration"
    end
    if not Serial.isUInt32(a1.Sequence) then
        return false, "InvalidSnapshotSequence"
    end
    if not Serial.isUInt32(a1.ServerTick) then
        return false, "InvalidServerTick"
    end
    if typeof(a1.ServerTime) == "number"
        and a1.ServerTime == a1.ServerTime
        and math.abs(a1.ServerTime) ~= (1 / 0) then
        if not Serial.isUInt32(a1.LastProcessedCommand) then
            return false, "InvalidLastProcessedCommand"
        end
        if typeof(a1.Flags) == "number" and a1.Flags % 1 == 0 and not (a1.Flags < 0) then
            local Flags_2 = a1.Flags
            local v1 = bit32.bnot(Enums.OwnerSnapshotFlags.ValidMask)
            if bit32.band(Flags_2, v1) == 0 then
                if typeof(a1.BufferDepth) == "number"
                    and a1.BufferDepth % 1 == 0
                    and not (a1.BufferDepth < -128)
                    and not (127 < a1.BufferDepth) then
                    local v2, v3, v4
                    if not a2 then
                        v2, v3 = StateCodec.validate(a1.State)
                        if not v2 then
                            return false, v3
                        end
                    end
                    v2, v3 = validateTopology(a1.Topology)
                    if not v2 then
                        return false, v3
                    end
                    v1, v4 = validateSupport(a1.Support)
                    if not v1 then
                        return false, v4
                    end
                    local OnGround = a1.State.OnGround
                    if OnGround ~= (a1.Support.Kind ~= Enums.SupportKind.None) then
                        return false, "GroundSupportMismatch"
                    end
                    return true, nil
                end
                return false, "InvalidBufferDepth"
            end
        end
        return false, "InvalidSnapshotFlags"
    end
    return false, "InvalidServerTime"
end

function u25.validate(a1) -- Line: 139 -- upvalues: validateSnapshot (val)
    return validateSnapshot(a1, false)
end

function u25.canonicalizeSupport(a1) -- Line: 144
    -- upvalues: validateSupport (val), writeVector3F32 (val), readVector3F32 (val)
    local v1, v2 = validateSupport(a1)
    if not v1 then
        return nil, v2
    end
    local v3 = buffer.create(24)
    writeVector3F32(v3, writeVector3F32(v3, 0, a1.Anchor), a1.Velocity)
    local v4, v5 = readVector3F32(v3, 0)
    local v6 = v4
    v4, v5 = readVector3F32(v3, v5)
    v5 = v5 == 24
    assert(v5, "support canonicalization size drift")
    return {Kind = a1.Kind, SourceId = a1.SourceId, Anchor = v6, Velocity = v4}, nil
end

function u25.encode(a1) -- Line: 165 -- upvalues: u25 (val), u28 (val), writeVector3F32 (val), StateCodec (val)
    local v1, v2 = u25.validate(a1)
    if not v1 then
        return nil, v2
    end
    local v3 = buffer.create(u28)
    local v4 = 0
    buffer.writeu8(v3, v4, 8)
    v4 = v4 + 1
    local Flags = a1.Flags
    buffer.writeu8(v3, v4, Flags)
    v4 = v4 + 1
    local Generation = a1.Generation
    buffer.writeu16(v3, v4, Generation)
    v4 = v4 + 2
    local Sequence = a1.Sequence
    buffer.writeu32(v3, v4, Sequence)
    v4 = v4 + 4
    local ServerTick = a1.ServerTick
    buffer.writeu32(v3, v4, ServerTick)
    v4 = v4 + 4
    local ServerTime = a1.ServerTime
    buffer.writef64(v3, v4, ServerTime)
    v4 = v4 + 8
    local LastProcessedCommand = a1.LastProcessedCommand
    buffer.writeu32(v3, v4, LastProcessedCommand)
    v4 = v4 + 4
    local BufferDepth = a1.BufferDepth
    buffer.writei8(v3, v4, BufferDepth)
    v4 = v4 + 1
    local Epoch = a1.Topology.Epoch
    buffer.writeu16(v3, v4, Epoch)
    v4 = v4 + 2
    local Fingerprint = a1.Topology.Fingerprint
    buffer.writeu32(v3, v4, Fingerprint)
    v4 = v4 + 4
    local DestructibleRevision = a1.Topology.DestructibleRevision
    buffer.writeu32(v3, v4, DestructibleRevision)
    v4 = v4 + 4
    local MoverRevision = a1.Topology.MoverRevision
    buffer.writeu32(v3, v4, MoverRevision)
    v4 = v4 + 4
    local Kind = a1.Support.Kind
    buffer.writeu8(v3, v4, Kind)
    v4 = v4 + 1
    local SourceId = a1.Support.SourceId
    buffer.writeu32(v3, v4, SourceId)
    v4 = v4 + 4
    v4 = writeVector3F32(v3, v4, a1.Support.Anchor)
    v4 = writeVector3F32(v3, v4, a1.Support.Velocity)
    assert(v4 == 68, "MovementV2 owner snapshot header size drift")
    StateCodec.writeValidated(v3, v4, a1.State)
    return v3, nil
end

function u25.decode(a1) -- Line: 208
    -- upvalues: u28 (val), readVector3F32 (val), StateCodec (val), validateSnapshot (val)
    local v1, v2
    if typeof(a1) ~= "buffer" then
        return nil, "SnapshotPayloadNotBuffer"
    end
    if (buffer.len(a1)) ~= u28 then
        return nil, "SnapshotPayloadSize"
    end
    local v3 = 0
    if buffer.readu8(a1, v3) ~= 8 then
        return nil, "SnapshotVersion"
    end
    v3 = v3 + 1
    local v4 = buffer.readu8(a1, v3)
    v3 = v3 + 1
    local v5 = buffer.readu16(a1, v3)
    v3 = v3 + 2
    local v6 = buffer.readu32(a1, v3)
    v3 = v3 + 4
    local v7 = buffer.readu32(a1, v3)
    v3 = v3 + 4
    local v8 = buffer.readf64(a1, v3)
    v3 = v3 + 8
    local v9 = buffer.readu32(a1, v3)
    v3 = v3 + 4
    local v10 = buffer.readi8(a1, v3)
    v3 = v3 + 1
    local v11 = {Epoch = buffer.readu16(a1, v3)}
    local v12 = v3 + 2
    v11.Fingerprint = buffer.readu32(a1, v12)
    v12 = v3 + 6
    v11.DestructibleRevision = buffer.readu32(a1, v12)
    v12 = v3 + 10
    v11.MoverRevision = buffer.readu32(a1, v12)
    v3 = v3 + 14
    local v13 = buffer.readu8(a1, v3)
    v3 = v3 + 1
    local v14 = buffer.readu32(a1, v3)
    v3 = v3 + 4
    local v15, v16 = readVector3F32(a1, v3)
    v12 = v15
    v15, v16 = readVector3F32(a1, v16)
    v3 = v16
    v15 = {Kind = v13, SourceId = v14, Anchor = v12, Velocity = v15}
    assert(v3 == 68, "MovementV2 owner snapshot header size drift")
    v16, v1, v2 = StateCodec.decodeFrom(a1, v3)
    if v16 == nil then
        return nil, v2
    end
    assert(v1 == u28, "MovementV2 owner snapshot state size drift")
    local v17 = {
        Generation = v5,
        Sequence = v6,
        ServerTick = v7,
        ServerTime = v8,
        LastProcessedCommand = v9,
        Flags = v4,
        BufferDepth = v10,
        State = v16,
        Topology = v11,
        Support = v15,
    }
    local v18, v19 = validateSnapshot(v17, true)
    if not v18 then
        return nil, v19
    end
    return v17, nil
end

return table.freeze(u25)