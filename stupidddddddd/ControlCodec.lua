-- ReplicatedStorage.MovementV2.ControlCodec
-- Script path: ReplicatedStorage.MovementV2.ControlCodec
-- Decompile time: 15.51 ms

local DestructibleFrame = require(script.Parent.Collision.DestructibleFrame)
local DamageTag = require(script.Parent.DamageTag)
local ActionLockTimeline = require(script.Parent.ActionLockTimeline)
local Mapping = require(script.Parent.Mapping)
local MoverDescriptorCodec = require(script.Parent.MoverDescriptorCodec)
local MoverProgressCodec = require(script.Parent.MoverProgressCodec)
local OwnerSnapshotCodec = require(script.Parent.OwnerSnapshotCodec)
local Quantization = require(script.Parent.Quantization)
local Serial = require(script.Parent.Serial)
local u46 = {Version = 6}
u46.Kind = table.freeze({
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
    ActionLocks = 14,
})

local function createPayload(a1, a2) -- Line: 86 -- types: a1: number, a2: number
    local v1 = buffer.create(a2 + 2)
    buffer.writeu8(v1, 0, 6)
    buffer.writeu8(v1, 1, a1)
    return v1
end

local function copyBody(a1, a2) -- Line: 93 -- types: a1: buffer, a2: buffer
    buffer.copy(a1, 2, a2, 0, buffer.len(a2))
end

local function readBody(a1, a2) -- Line: 97 -- types: a1: buffer, a2: number
    if (buffer.len(a1)) ~= a2 + 2 then
        return nil
    end
    local v1 = buffer.create(a2)
    buffer.copy(v1, 0, a1, 2, a2)
    return v1
end

function u46.encodeActionLocks(a1, a2) -- Line: 106
    -- upvalues: Serial (val), ActionLockTimeline (val)
    if Serial.isNonZeroUInt16(a1) and ActionLockTimeline.validate(a2) then
        local ServerTime, v1, v2, v3
        local v4 = #a2.Points * 9 + 9
        local v5 = buffer.create(v4 + 2)
        buffer.writeu8(v5, 0, 6)
        buffer.writeu8(v5, 1, 14)
        buffer.writeu16(v5, 2, a1)
        local Revision = a2.Revision
        buffer.writeu32(v5, 4, Revision)
        local v6 = if not a2.Initial then 0 else 1
        buffer.writeu8(v5, 8, v6)
        v6 = #a2.Points
        buffer.writeu16(v5, 9, v6)
        local v7 = nil
        local v8 = nil
        for i, j in a2.Points, v7, v8 do
            v3 = 11 + (i - 1) * 9
            ServerTime = j.ServerTime
            buffer.writef64(v5, v3, ServerTime)
            v1 = v3 + 8
            v2 = if not j.Locked then 0 else 1
            buffer.writeu8(v5, v1, v2)
        end
        return v5, nil
    end
    return nil, "InvalidActionLocks"
end

function u46.encodeMapping(a1) -- Line: 123 -- upvalues: Mapping (val)
    local v1, v2 = Mapping.encode(a1)
    if v1 == nil then
        return nil, v2
    end
    local WireSize = Mapping.WireSize
    local v3 = buffer.create(WireSize + 2)
    buffer.writeu8(v3, 0, 6)
    buffer.writeu8(v3, 1, 1)
    buffer.copy(v3, 2, v1, 0, buffer.len(v1))
    return v3, nil
end

function u46.encodeDiscontinuity(a1) -- Line: 133 -- upvalues: OwnerSnapshotCodec (val)
    local v1, v2 = OwnerSnapshotCodec.encode(a1)
    if v1 == nil then
        return nil, v2
    end
    local WireSize = OwnerSnapshotCodec.WireSize
    local v3 = buffer.create(WireSize + 2)
    buffer.writeu8(v3, 0, 6)
    buffer.writeu8(v3, 1, 2)
    buffer.copy(v3, 2, v1, 0, buffer.len(v1))
    return v3, nil
end

function u46.encodeDestructibleBaseline(a1, a2) -- Line: 143 -- upvalues: DestructibleFrame (val), Serial (val)
    local v1, v2 = DestructibleFrame.Validate(a1.Epoch, a1.Revision, a1.Count, a1.ActiveBits)
    if not v1 then
        return nil, v2
    end
    if not (Serial.UInt16Max < a1.Epoch) and not (Serial.UInt16Max < a1.Count) and Serial.isUInt32(a2) then
        local v3 = #a1.ActiveBits + 12
        local v4 = buffer.create(v3 + 2)
        buffer.writeu8(v4, 0, 6)
        buffer.writeu8(v4, 1, 3)
        local Epoch_2 = a1.Epoch
        buffer.writeu16(v4, 2, Epoch_2)
        local Revision = a1.Revision
        buffer.writeu32(v4, 4, Revision)
        buffer.writeu32(v4, 8, a2)
        local Count_2 = a1.Count
        buffer.writeu16(v4, 12, Count_2)
        if #a1.ActiveBits > 0 then
            buffer.writestring(v4, 14, a1.ActiveBits)
        end
        return v4, nil
    end
    return nil, "DestructibleBaselineRange"
end

local function validateDelta(a1, a2, a3) -- Line: 163 -- upvalues: Serial (val)
    if not Serial.isNonZeroUInt16(a1) then
        return false, "InvalidDeltaEpoch"
    end
    if Serial.isUInt32(a2) and a2 ~= 0 then
        if type(a3) == "table" and not (#a3 < 1) and not (#a3 > 1024) then
            local v1 = 0
            for i, j in a3 do
                if Serial.isNonZeroUInt16(j) and not (j <= v1) then
                    continue
                end
                return false, "DeltaIndicesNotStrictlySorted"
            end
            return true, nil
        end
        return false, "InvalidDeltaCount"
    end
    return false, "InvalidDeltaRevision"
end

function u46.encodeDestructibleDelta(a1, a2, a3, a4) -- Line: 184 -- upvalues: validateDelta (val), Serial (val)
    local v1, v2 = validateDelta(a1, a2, a4)
    if not v1 then
        return nil, v2
    end
    if not Serial.isUInt32(a3) then
        return nil, "InvalidDeltaServerTick"
    end
    local v3 = #a4 * 2 + 12
    local v4 = buffer.create(v3 + 2)
    buffer.writeu8(v4, 0, 6)
    buffer.writeu8(v4, 1, 4)
    buffer.writeu16(v4, 2, a1)
    buffer.writeu32(v4, 4, a2)
    buffer.writeu32(v4, 8, a3)
    local v5 = #a4
    buffer.writeu16(v4, 12, v5)
    v3 = 14
    for i, j in a4 do
        buffer.writeu16(v4, v3, j)
        v3 = v3 + 2
    end
    return v4, nil
end

function u46.encodeBaselineRequest(a1, a2) -- Line: 211 -- upvalues: Serial (val)
    if Serial.isNonZeroUInt16(a1) and Serial.isUInt32(a2) then
        local v1 = buffer.create(8)
        buffer.writeu8(v1, 0, 6)
        buffer.writeu8(v1, 1, 5)
        buffer.writeu16(v1, 2, a1)
        buffer.writeu32(v1, 4, a2)
        return v1, nil
    end
    return nil, "InvalidBaselineRequest"
end

function u46.encodeMappingRequest(a1) -- Line: 221 -- upvalues: Serial (val)
    if not Serial.isNonZeroUInt16(a1) then
        return nil, "InvalidMappingRequest"
    end
    local v1 = buffer.create(4)
    buffer.writeu8(v1, 0, 6)
    buffer.writeu8(v1, 1, 6)
    buffer.writeu16(v1, 2, a1)
    return v1, nil
end

function u46.encodeCommandResyncRequest(a1, a2) -- Line: 230 -- upvalues: Serial (val)
    if Serial.isNonZeroUInt16(a1) and Serial.isUInt32(a2) then
        local v1 = buffer.create(8)
        buffer.writeu8(v1, 0, 6)
        buffer.writeu8(v1, 1, 10)
        buffer.writeu16(v1, 2, a1)
        buffer.writeu32(v1, 4, a2)
        return v1, nil
    end
    return nil, "InvalidCommandResyncRequest"
end

function u46.encodeGenerationUnbound(a1) -- Line: 240 -- upvalues: Serial (val)
    if not Serial.isNonZeroUInt16(a1) then
        return nil, "InvalidGenerationUnbound"
    end
    local v1 = buffer.create(4)
    buffer.writeu8(v1, 0, 6)
    buffer.writeu8(v1, 1, 11)
    buffer.writeu16(v1, 2, a1)
    return v1, nil
end

function u46.encodeGrenadeTransitionRequest(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 250
    -- upvalues: Serial (val), Quantization (val)
    if Serial.isNonZeroUInt16(a1)
        and Serial.isUInt32(a2)
        and Serial.isUInt32(a3)
        and a3 ~= 0
        and type(a4) == "string"
        and not (#a4 > 96)
        and type(a5) == "string"
        and not (#a5 < 1)
        and not (#a5 > 96) then
        if a6 ~= "Far" and a6 ~= "Near" then
            return nil, "InvalidGrenadeTransitionRequest"
        end
        if Quantization.isFinite(a7) and Quantization.isFinite(a8) then
            local v1 = #a4 + 16 + #a5
            local v2 = buffer.create(v1 + 2)
            buffer.writeu8(v2, 0, 6)
            buffer.writeu8(v2, 1, 13)
            buffer.writeu16(v2, 2, a1)
            buffer.writeu32(v2, 4, a2)
            buffer.writeu32(v2, 8, a3)
            local v3 = #a4
            buffer.writeu8(v2, 12, v3)
            v3 = #a5
            buffer.writeu8(v2, 13, v3)
            v3 = if a6 ~= "Far" then 2 else 1
            buffer.writeu8(v2, 14, v3)
            v3 = Quantization.quantizeYaw(a7)
            buffer.writeu16(v2, 15, v3)
            v3 = Quantization.quantizeSignedUnit(a8)
            buffer.writei8(v2, 17, v3)
            buffer.writestring(v2, 18, a4)
            buffer.writestring(v2, #a4 + 18, a5)
            return v2, nil
        end
    end
    return nil, "InvalidGrenadeTransitionRequest"
end

function u46.encodeDamageTag(a1, a2, a3) -- Line: 291 -- upvalues: Serial (val), DamageTag (val)
    if Serial.isNonZeroUInt16(a1) and Serial.isUInt32(a2) and DamageTag.isValidModifier(a3) then
        local v1 = buffer.create(12)
        buffer.writeu8(v1, 0, 6)
        buffer.writeu8(v1, 1, 12)
        buffer.writeu16(v1, 2, a1)
        buffer.writeu32(v1, 4, a2)
        buffer.writef32(v1, 8, a3)
        return v1, nil
    end
    return nil, "InvalidDamageTag"
end

local function validateMoverHeader(a1, a2, a3) -- Line: 310 -- upvalues: Serial (val)
    if Serial.isNonZeroUInt16(a1) and Serial.isUInt32(a2) and Serial.isUInt32(a3) then
        return true, nil
    end
    return false, "InvalidMoverControlHeader"
end

local function encodeMoverDescriptors(a1, a2, a3, a4, a5, a6) -- Line: 317
    -- upvalues: Serial (val), MoverDescriptorCodec (val)
    local v1, v2
    if not Serial.isNonZeroUInt16(a2) or not Serial.isUInt32(a3) then
        v1 = false
        v2 = "InvalidMoverControlHeader"
    elseif Serial.isUInt32(a4) then
        v1 = true
        v2 = nil
    else
        v1 = false
        v2 = "InvalidMoverControlHeader"
    end
    if not v1 then
        return nil, v2
    end
    local v3, v4 = MoverDescriptorCodec.validateList(a5, a6)
    if not v3 then
        return nil, v4
    end
    local v5 = #a5
    local v6 = 12 + v5 * MoverDescriptorCodec.DescriptorWireSize
    local v7 = buffer.create(v6 + 2)
    buffer.writeu8(v7, 0, 6)
    buffer.writeu8(v7, 1, a1)
    buffer.writeu16(v7, 2, a2)
    buffer.writeu32(v7, 4, a3)
    buffer.writeu32(v7, 8, a4)
    buffer.writeu16(v7, 12, v5)
    assert((MoverDescriptorCodec.writeValidated(v7, 14, a5)) == buffer.len(v7), "mover control size drift")
    return v7, nil
end

function u46.encodeMoverBaseline(a1, a2, a3, a4, a5) -- Line: 344
    -- upvalues: Serial (val), MoverDescriptorCodec (val), MoverProgressCodec (val)
    local v1, v2
    if not Serial.isNonZeroUInt16(a1) or not Serial.isUInt32(a2) then
        v1 = false
        v2 = "InvalidMoverControlHeader"
    elseif Serial.isUInt32(a3) then
        v1 = true
        v2 = nil
    else
        v1 = false
        v2 = "InvalidMoverControlHeader"
    end
    if not v1 then
        return nil, v2
    end
    local v3, v4 = MoverDescriptorCodec.validateList(a4, true)
    if not v3 then
        return nil, v4
    end
    local v5 = a5 or {}
    local v6, v7 = MoverProgressCodec.validateAnchors(v5, true)
    if not v6 then
        return nil, v7
    end
    local v8 = #a4
    local v9 = 13 + v8 * MoverDescriptorCodec.DescriptorWireSize + #v5 * MoverProgressCodec.AnchorWireSize
    local v10 = buffer.create(v9 + 2)
    buffer.writeu8(v10, 0, 6)
    buffer.writeu8(v10, 1, 7)
    buffer.writeu16(v10, 2, a1)
    buffer.writeu32(v10, 4, a2)
    buffer.writeu32(v10, 8, a3)
    buffer.writeu16(v10, 12, v8)
    v9 = MoverDescriptorCodec.writeValidated(v10, 14, a4)
    local v11 = #v5
    buffer.writeu8(v10, v9, v11)
    v9 = v9 + 1
    assert((MoverProgressCodec.writeAnchorsValidated(v10, v9, v5)) == buffer.len(v10), "mover baseline control size drift")
    return v10, nil
end

function u46.encodeMoverDelta(a1, a2, a3, a4) -- Line: 380 -- upvalues: encodeMoverDescriptors (val)
    return encodeMoverDescriptors(8, a1, a2, a3, a4, false)
end

function u46.encodeMoverProgress(a1, a2, a3, a4) -- Line: 384 -- upvalues: Serial (val), MoverProgressCodec (val)
    local v1, v2
    if not Serial.isNonZeroUInt16(a1) or not Serial.isUInt32(a2) then
        v1 = false
        v2 = "InvalidMoverControlHeader"
    elseif Serial.isUInt32(a3) then
        v1 = true
        v2 = nil
    else
        v1 = false
        v2 = "InvalidMoverControlHeader"
    end
    if not v1 then
        return nil, v2
    end
    local v3, v4 = MoverProgressCodec.validateStreams(a4)
    if not v3 then
        return nil, v4
    end
    local v5 = 11 + MoverProgressCodec.streamsWireSize(a4)
    local v6 = buffer.create(v5 + 2)
    buffer.writeu8(v6, 0, 6)
    buffer.writeu8(v6, 1, 9)
    buffer.writeu16(v6, 2, a1)
    buffer.writeu32(v6, 4, a2)
    buffer.writeu32(v6, 8, a3)
    local v7 = #a4
    buffer.writeu8(v6, 12, v7)
    assert((MoverProgressCodec.writeStreamsValidated(v6, 13, a4)) == buffer.len(v6), "mover progress control size drift")
    return v6, nil
end

function u46.decodeRequest(a1) -- Line: 404 -- upvalues: Serial (val), Quantization (val)
    if typeof(a1) ~= "buffer" then
        return nil, "ControlRequestPayload"
    end
    local v1 = buffer.len(a1)
    if not (v1 < 2) and buffer.readu8(a1, 0) == 6 then
        local v2, v3
        local v4 = buffer.readu8(a1, 1)
        if v4 == 5 then
            if v1 ~= 8 then
                return nil, "BaselineRequestSize"
            end
            v2 = buffer.readu16(a1, 2)
            v3 = buffer.readu32(a1, 4)
            if not Serial.isNonZeroUInt16(v2) then
                return nil, "InvalidBaselineRequest"
            end
            return {Kind = "BaselineRequest", Epoch = v2, KnownRevision = v3}, nil
        end
        if v4 == 6 then
            if v1 ~= 4 then
                return nil, "MappingRequestSize"
            end
            v2 = buffer.readu16(a1, 2)
            if not Serial.isNonZeroUInt16(v2) then
                return nil, "InvalidMappingRequest"
            end
            return {Kind = "MappingRequest", Generation = v2}, nil
        end
        if v4 == 10 then
            if v1 ~= 8 then
                return nil, "CommandResyncRequestSize"
            end
            v2 = buffer.readu16(a1, 2)
            v3 = buffer.readu32(a1, 4)
            if not Serial.isNonZeroUInt16(v2) then
                return nil, "InvalidCommandResyncRequest"
            end
            return {Kind = "CommandResyncRequest", Generation = v2, DiscardThroughCommand = v3}, nil
        end
        if v4 ~= 13 then
            return nil, "ControlRequestKind"
        end
        if v1 < 19 then
            return nil, "GrenadeTransitionRequestSize"
        end
        v2 = buffer.readu16(a1, 2)
        v3 = buffer.readu32(a1, 4)
        local v5 = buffer.readu32(a1, 8)
        local v6 = buffer.readu8(a1, 12)
        local v7 = buffer.readu8(a1, 13)
        local v8 = buffer.readu8(a1, 14)
        local v9 = Quantization.dequantizeYaw((buffer.readu16(a1, 15)))
        local v10 = Quantization.dequantizeSignedUnit((buffer.readi8(a1, 17)))
        if Serial.isNonZeroUInt16(v2) and v5 ~= 0 and not (v6 > 96) and not (v7 < 1) and not (v7 > 96) then
            if v8 ~= 1 and v8 ~= 2 then
                return nil, "InvalidGrenadeTransitionRequest"
            end
            if v1 == v6 + 18 + v7 then
                return {
                    Kind = "GrenadeTransitionRequest",
                    Generation = v2,
                    CommandNumber = v3,
                    RequestId = v5,
                    TargetIdentifier = buffer.readstring(a1, 18, v6),
                    GrenadeIdentifier = buffer.readstring(a1, v6 + 18, v7),
                    Animation = if v8 ~= 1 then "Near" else "Far",
                    LookYaw = v9,
                    VerticalLook = v10,
                }, nil
            end
        end
        return nil, "InvalidGrenadeTransitionRequest"
    end
    return nil, "ControlRequestHeader"
end

function u46.decode(a1) -- Line: 489
    -- upvalues: Mapping (val), OwnerSnapshotCodec (val), DestructibleFrame (val), validateDelta (val), u46 (val)
    -- upvalues: Serial (val), ActionLockTimeline (val), DamageTag (val), MoverDescriptorCodec (val)
    -- upvalues: MoverProgressCodec (val)
    if typeof(a1) == "buffer" then
        local v1 = buffer.len(a1)
        if not (v1 < 2) then
            local v2, v3, v4, v5, v6, v7, v8, v9
            if buffer.readu8(a1, 0) ~= 6 then
                return nil, "ControlVersion"
            end
            v1 = buffer.readu8(a1, 1)
            if v1 == 1 then
                local WireSize = Mapping.WireSize
                v4 = buffer.len(a1)
                if v4 == WireSize + 2 then
                    v4 = buffer.create(WireSize)
                    buffer.copy(v4, 0, a1, 2, WireSize)
                    v2 = v4
                else
                    v2 = nil
                end
                if v2 == nil then
                    return nil, "MappingControlSize"
                end
                v3, v4 = Mapping.decode(v2)
                if v3 == nil then
                    return nil, v4
                end
                return {Kind = "Mapping", Mapping = v3}, nil
            end
            if v1 == 2 then
                local WireSize_2 = OwnerSnapshotCodec.WireSize
                v4 = buffer.len(a1)
                if v4 == WireSize_2 + 2 then
                    v4 = buffer.create(WireSize_2)
                    buffer.copy(v4, 0, a1, 2, WireSize_2)
                    v2 = v4
                else
                    v2 = nil
                end
                if v2 == nil then
                    return nil, "DiscontinuityControlSize"
                end
                v3, v4 = OwnerSnapshotCodec.decode(v2)
                if v3 == nil then
                    return nil, v4
                end
                return {Kind = "Discontinuity", Snapshot = v3}, nil
            end
            if v1 == 3 then
                if (buffer.len(a1)) < 14 then
                    return nil, "BaselineControlSize"
                end
                v2 = buffer.readu16(a1, 2)
                v3 = buffer.readu32(a1, 4)
                v4 = buffer.readu32(a1, 8)
                v5 = buffer.readu16(a1, 12)
                v6 = math.ceil(v5 / 8)
                if (buffer.len(a1)) ~= v6 + 14 then
                    return nil, "BaselineControlSize"
                end
                v8, v9 = DestructibleFrame.Validate(v2, v3, v5, if not (v6 > 0) then "" else buffer.readstring(a1, 14, v6))
                if not v8 then
                    return nil, v9
                end
                return {
                    Kind = "DestructibleBaseline",
                    ServerTick = v4,
                    Frame = DestructibleFrame.New(v2, v3, v5, v7),
                }, nil
            end
            if v1 == 4 then
                if (buffer.len(a1)) < 14 then
                    return nil, "DeltaControlSize"
                end
                v2 = buffer.readu16(a1, 2)
                v3 = buffer.readu32(a1, 4)
                v4 = buffer.readu32(a1, 8)
                v5 = buffer.readu16(a1, 12)
                if not (v5 < 1) and not (v5 > 1024) then
                    v6 = buffer.len(a1)
                    if v6 == v5 * 2 + 14 then
                        v6 = table.create(v5)
                        v7 = 14
                        for j = 1, v5 do
                            v6[j] = (buffer.readu16(a1, v7))
                            v7 = v7 + 2
                        end
                        v8, v9 = validateDelta(v2, v3, v6)
                        if not v8 then
                            return nil, v9
                        end
                        return {
                            Kind = "DestructibleDelta",
                            Epoch = v2,
                            Revision = v3,
                            ServerTick = v4,
                            Indices = v6,
                        }, nil
                    end
                end
                return nil, "DeltaControlSize"
            end
            if v1 ~= 5 and v1 ~= 6 and v1 ~= 10 and v1 ~= 13 then
                local v10, v11, v12
                if v1 == 11 then
                    if buffer.len(a1) ~= 4 then
                        return nil, "GenerationUnboundSize"
                    end
                    v2 = buffer.readu16(a1, 2)
                    if not Serial.isNonZeroUInt16(v2) then
                        return nil, "InvalidGenerationUnbound"
                    end
                    return {Kind = "GenerationUnbound", Generation = v2}, nil
                end
                if v1 == 14 then
                    if (buffer.len(a1)) < 11 then
                        return nil, "ActionLocksSize"
                    end
                    v2 = buffer.readu16(a1, 2)
                    v3 = buffer.readu8(a1, 8)
                    v4 = buffer.readu16(a1, 9)
                    if Serial.isNonZeroUInt16(v2) and not (v3 > 1) and not (ActionLockTimeline.MaxPoints < v4) then
                        if (buffer.len(a1)) ~= v4 * 9 + 11 then
                            return nil, "ActionLocksSize"
                        end
                        v5 = table.create(v4)
                        for i = 1, v4 do
                            v9 = (i - 1) * 9 + 11
                            v12 = v9 + 8
                            v10 = buffer.readu8(a1, v12)
                            if v10 > 1 then
                                return nil, "InvalidActionLocks"
                            end
                            v11 = {ServerTime = buffer.readf64(a1, v9), Locked = v10 == 1}
                            v5[i] = v11
                        end
                        v6 = {
                            Revision = buffer.readu32(a1, 4),
                            Initial = v3 == 1,
                            Points = v5,
                        }
                        if not ActionLockTimeline.validate(v6) then
                            return nil, "InvalidActionLocks"
                        end
                        return {Kind = "ActionLocks", Generation = v2, History = v6}, nil
                    end
                    return nil, "InvalidActionLocks"
                end
                if v1 == 12 then
                    if buffer.len(a1) ~= 12 then
                        return nil, "DamageTagSize"
                    end
                    v2 = buffer.readu16(a1, 2)
                    v3 = buffer.readu32(a1, 4)
                    v4 = buffer.readf32(a1, 8)
                    if Serial.isNonZeroUInt16(v2) and DamageTag.isValidModifier(v4) then
                        return {
                            Kind = "DamageTag",
                            Generation = v2,
                            ApplyMovementTick = v3,
                            VelocityModifier = v4,
                        }, nil
                    end
                    return nil, "InvalidDamageTag"
                end
                if v1 == 7 then
                    if (buffer.len(a1)) < 15 then
                        return nil, "MoverControlSize"
                    end
                    v2 = buffer.readu16(a1, 2)
                    v3 = buffer.readu32(a1, 4)
                    v4 = buffer.readu32(a1, 8)
                    v5 = buffer.readu16(a1, 12)
                    v6 = v5 * MoverDescriptorCodec.DescriptorWireSize
                    v7 = 14 + v6
                    if (if not Serial.isNonZeroUInt16(v2) then false else if not Serial.isUInt32(v3) then false else if Serial.isUInt32(v4) then true else false)
                        and not (buffer.len(a1) <= v7) then
                        v9 = buffer.create(v6)
                        if v6 > 0 then
                            buffer.copy(v9, 0, a1, 14, v6)
                        end
                        v10, v11, v12 = MoverDescriptorCodec.readList(v9, 0, v5)
                        if v10 == nil then
                            return nil, v12
                        end
                        assert(v11 == v6, "mover baseline descriptor decode size drift")
                        local v13 = buffer.readu8(a1, v7)
                        local v14 = v7 + 1 + v13 * MoverProgressCodec.AnchorWireSize
                        if buffer.len(a1) ~= v14 then
                            return nil, "MoverProgressAnchorPayloadSize"
                        end
                        local v15, v16, v17 = MoverProgressCodec.readAnchors(a1, v7 + 1, v13)
                        if v15 == nil then
                            return nil, v17
                        end
                        assert(v16 == buffer.len(a1), "mover baseline control decode size drift")
                        return {
                            Kind = "MoverBaseline",
                            Epoch = v2,
                            Revision = v3,
                            ServerTick = v4,
                            Descriptors = v10,
                            ProgressAnchors = v15,
                        }, nil
                    end
                    return nil, "MoverControlSize"
                end
                if v1 == 8 then
                    if (buffer.len(a1)) < 14 then
                        return nil, "MoverControlSize"
                    end
                    v2 = buffer.readu16(a1, 2)
                    v3 = buffer.readu32(a1, 4)
                    v4 = buffer.readu32(a1, 8)
                    v5 = buffer.readu16(a1, 12)
                    v6 = if not Serial.isNonZeroUInt16(v2) then false else if not Serial.isUInt32(v3) then false else if Serial.isUInt32(v4) then true else false
                    if v6 and v5 ~= 0 then
                        v6 = buffer.len(a1)
                        if v6 == 14 + v5 * MoverDescriptorCodec.DescriptorWireSize then
                            v6, v7, v8 = MoverDescriptorCodec.readList(a1, 14, v5)
                            if v6 == nil then
                                return nil, v8
                            end
                            assert(v7 == buffer.len(a1), "mover control decode size drift")
                            return {
                                Kind = "MoverDelta",
                                Epoch = v2,
                                Revision = v3,
                                ServerTick = v4,
                                Descriptors = v6,
                            }, nil
                        end
                    end
                    return nil, "MoverControlSize"
                end
                if v1 ~= 9 then
                    return nil, "ControlKind"
                end
                if (buffer.len(a1)) < 21 then
                    return nil, "MoverProgressPayloadSize"
                end
                v2 = buffer.readu16(a1, 2)
                v3 = buffer.readu32(a1, 4)
                v4 = buffer.readu32(a1, 8)
                v5 = buffer.readu8(a1, 12)
                if not (if not Serial.isNonZeroUInt16(v2) then false else if not Serial.isUInt32(v3) then false else if Serial.isUInt32(v4) then true else false) then
                    return nil, "InvalidMoverControlHeader"
                end
                v6, v7, v8 = MoverProgressCodec.readStreams(a1, 13, v5)
                if v6 == nil then
                    return nil, v8
                end
                if v7 ~= buffer.len(a1) then
                    return nil, "MoverProgressPayloadSize"
                end
                return {
                    Kind = "MoverProgress",
                    Epoch = v2,
                    Revision = v3,
                    ServerTick = v4,
                    Streams = v6,
                }, nil
            end
            return u46.decodeRequest(a1)
        end
    end
    return nil, "ControlPayload"
end

return table.freeze(u46)