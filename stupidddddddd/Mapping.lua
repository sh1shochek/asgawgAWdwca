-- ReplicatedStorage.MovementV2.Mapping
-- Script path: ReplicatedStorage.MovementV2.Mapping
-- Decompile time: 1.55 ms

local Config = require(script.Parent.Config)
local Serial = require(script.Parent.Serial)
require(script.Parent.Types)
local u15 = {Version = 2, WireSize = 16}

function u15.clone(a1) -- Line: 17
    return {
        Generation = a1.Generation,
        ActorId = a1.ActorId,
        SimulationHz = a1.SimulationHz,
        TopologyEpoch = a1.TopologyEpoch,
        TopologyFingerprint = a1.TopologyFingerprint,
        PlayerCollisionsEnabled = a1.PlayerCollisionsEnabled,
    }
end

function u15.validate(a1) -- Line: 28 -- upvalues: Serial (val), Config (val)
    if typeof(a1) ~= "table" then
        return false, "MappingNotTable"
    end
    if not Serial.isNonZeroUInt16(a1.Generation) then
        return false, "InvalidGeneration"
    end
    if Serial.isUInt32(a1.ActorId) and a1.ActorId ~= 0 then
        if typeof(a1.SimulationHz) == "number"
            and a1.SimulationHz % 1 == 0
            and not (a1.SimulationHz < Config.MinSimulationHz)
            and not (Config.MaxSimulationHz < a1.SimulationHz) then
            if not Serial.isNonZeroUInt16(a1.TopologyEpoch) then
                return false, "InvalidTopologyEpoch"
            end
            if not Serial.isUInt32(a1.TopologyFingerprint) then
                return false, "InvalidTopologyFingerprint"
            end
            if typeof(a1.PlayerCollisionsEnabled) ~= "boolean" then
                return false, "InvalidPlayerCollisionsEnabled"
            end
            return true, nil
        end
        return false, "InvalidSimulationHz"
    end
    return false, "InvalidActorId"
end

function u15.encode(a1) -- Line: 58 -- upvalues: u15 (val)
    local v1, v2 = u15.validate(a1)
    if not v1 then
        return nil, v2
    end
    local v3 = buffer.create(16)
    buffer.writeu8(v3, 0, 2)
    local Generation = a1.Generation
    buffer.writeu16(v3, 1, Generation)
    local ActorId = a1.ActorId
    buffer.writeu32(v3, 3, ActorId)
    local SimulationHz = a1.SimulationHz
    buffer.writeu16(v3, 7, SimulationHz)
    local TopologyEpoch = a1.TopologyEpoch
    buffer.writeu16(v3, 9, TopologyEpoch)
    local TopologyFingerprint = a1.TopologyFingerprint
    buffer.writeu32(v3, 11, TopologyFingerprint)
    local v4 = if not a1.PlayerCollisionsEnabled then 0 else 1
    buffer.writeu8(v3, 15, v4)
    return v3, nil
end

function u15.decode(a1) -- Line: 75 -- upvalues: u15 (val)
    if typeof(a1) ~= "buffer" then
        return nil, "MappingPayloadNotBuffer"
    end
    if buffer.len(a1) ~= 16 then
        return nil, "MappingPayloadSize"
    end
    if buffer.readu8(a1, 0) ~= 2 then
        return nil, "MappingVersion"
    end
    local v1 = buffer.readu8(a1, 15)
    if v1 > 1 then
        return nil, "InvalidPlayerCollisionsEnabled"
    end
    local v2 = {
        Generation = buffer.readu16(a1, 1),
        ActorId = buffer.readu32(a1, 3),
        SimulationHz = buffer.readu16(a1, 7),
        TopologyEpoch = buffer.readu16(a1, 9),
        TopologyFingerprint = buffer.readu32(a1, 11),
        PlayerCollisionsEnabled = v1 == 1,
    }
    local v3, v4 = u15.validate(v2)
    if not v3 then
        return nil, v4
    end
    return v2, nil
end

return table.freeze(u15)