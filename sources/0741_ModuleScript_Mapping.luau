-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Config);
local Serial = require(script.Parent.Serial);
require(script.Parent.Types);
local u3 = {
    Version = 2,
    WireSize = 16,

    clone = function(p1) -- Line: 17, Name: clone
        return {
            Generation = p1.Generation,
            ActorId = p1.ActorId,
            SimulationHz = p1.SimulationHz,
            TopologyEpoch = p1.TopologyEpoch,
            TopologyFingerprint = p1.TopologyFingerprint,
            PlayerCollisionsEnabled = p1.PlayerCollisionsEnabled
        };
    end,

    validate = function(p2) -- Line: 28, Name: validate
        -- upvalues: Serial (copy), Config (copy)
        if typeof(p2) ~= "table" then
            return false, "MappingNotTable";
        end;

        if not Serial.isNonZeroUInt16(p2.Generation) then
            return false, "InvalidGeneration";
        end;

        if not Serial.isUInt32(p2.ActorId) or p2.ActorId == 0 then
            return false, "InvalidActorId";
        end;

        if typeof(p2.SimulationHz) ~= "number" or (p2.SimulationHz % 1 ~= 0 or (p2.SimulationHz < Config.MinSimulationHz or p2.SimulationHz > Config.MaxSimulationHz)) then
            return false, "InvalidSimulationHz";
        end;

        if not Serial.isNonZeroUInt16(p2.TopologyEpoch) then
            return false, "InvalidTopologyEpoch";
        end;

        if not Serial.isUInt32(p2.TopologyFingerprint) then
            return false, "InvalidTopologyFingerprint";
        end;

        if typeof(p2.PlayerCollisionsEnabled) == "boolean" then
            return true, nil;
        end;

        return false, "InvalidPlayerCollisionsEnabled";
    end
};

function u3.encode(p4) -- Line: 58
    -- upvalues: u3 (copy)
    local v5, v6 = u3.validate(p4);

    if not v5 then
        return nil, v6;
    end;

    local buffer_create_ret = buffer.create(16);
    buffer.writeu8(buffer_create_ret, 0, 2);
    buffer.writeu16(buffer_create_ret, 1, p4.Generation);
    buffer.writeu32(buffer_create_ret, 3, p4.ActorId);
    buffer.writeu16(buffer_create_ret, 7, p4.SimulationHz);
    buffer.writeu16(buffer_create_ret, 9, p4.TopologyEpoch);
    buffer.writeu32(buffer_create_ret, 11, p4.TopologyFingerprint);
    buffer.writeu8(buffer_create_ret, 15, p4.PlayerCollisionsEnabled and 1 or 0);

    return buffer_create_ret, nil;
end;

function u3.decode(p7) -- Line: 75
    -- upvalues: u3 (copy)
    if typeof(p7) ~= "buffer" then
        return nil, "MappingPayloadNotBuffer";
    end;

    if buffer.len(p7) ~= 16 then
        return nil, "MappingPayloadSize";
    end;

    if buffer.readu8(p7, 0) ~= 2 then
        return nil, "MappingVersion";
    end;

    local buffer_readu8_ret = buffer.readu8(p7, 15);

    if buffer_readu8_ret > 1 then
        return nil, "InvalidPlayerCollisionsEnabled";
    end;

    local v8 = {
        Generation = buffer.readu16(p7, 1),
        ActorId = buffer.readu32(p7, 3),
        SimulationHz = buffer.readu16(p7, 7),
        TopologyEpoch = buffer.readu16(p7, 9),
        TopologyFingerprint = buffer.readu32(p7, 11),
        PlayerCollisionsEnabled = buffer_readu8_ret == 1
    };
    local v9, v10 = u3.validate(v8);

    if v9 then
        return v8, nil;
    end;

    return nil, v10;
end;

return table.freeze(u3);