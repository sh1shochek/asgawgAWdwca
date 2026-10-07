-- ReplicatedStorage.MovementV2.Client.OwnerCommandFeedback
-- Script path: ReplicatedStorage.MovementV2.Client.OwnerCommandFeedback
-- Decompile time: 0.95 ms

local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
require(script.Parent.RuntimeTypes)
local v1 = {}

local function newerFeedback(a1, a2) -- Line: 11 -- upvalues: Serial (val)
    local v1 = true
    if a2 ~= nil then
        v1 = true
        if a2.Generation == a1.Generation then
            v1 = Serial.isNewerUInt32(a1.Sequence, a2.Sequence)
            if v1 then
                v1 = false
                if 0 <= (Serial.deltaUInt32(a1.ServerTick, a2.ServerTick)) then
                    v1 = false
                    if 0 <= (Serial.deltaUInt32(a1.LastProcessedCommand, a2.LastProcessedCommand)) then
                        v1 = false
                        if 0 <= (Serial.deltaUInt32(a1.Topology.DestructibleRevision, a2.Topology.DestructibleRevision)) then
                            v1 = 0 <= (Serial.deltaUInt32(a1.Topology.MoverRevision, a2.Topology.MoverRevision))
                        end
                    end
                end
            end
        end
    end
    return v1
end

function v1:observe(a2, a3) -- Line: 24 -- upvalues: newerFeedback (val) -- types: a3: number
    local _mapping = self._mapping
    if _mapping ~= nil
        and a2.Generation == _mapping.Generation
        and a2.Topology.Epoch == _mapping.TopologyEpoch
        and a2.Topology.Fingerprint == _mapping.TopologyFingerprint
        and newerFeedback(a2, self._lastAcceptedOwnerSnapshot)
        and newerFeedback(a2, self._lastOwnerCommandFeedback) then
        self._lastOwnerCommandFeedback = a2
        local _commandClock = self._commandClock
        if _commandClock ~= nil then
            _commandClock:observe(a2.BufferDepth, a3)
        end
        self._diagnostics:recordOwnerFeedback(a2)
        return
    end
end

local function consider(a1, a2) -- Line: 44 -- upvalues: Serial (val)
    if a2 ~= nil
        and a2.Generation == a1.Generation
        and a2.LastProcessedCommand == a1.LastProcessedCommand
        and a2.Topology.Epoch == a1.Topology.Epoch
        and a2.Topology.Fingerprint == a1.Topology.Fingerprint
        and Serial.isNewerUInt32(a2.Sequence, a1.Sequence)
        and 0 <= (Serial.deltaUInt32(a2.ServerTick, a1.ServerTick)) then
        return a2
    end
    return a1
end

function v1.choose(a1, a2, a3) -- Line: 60 -- upvalues: consider (val)
    if a1 == nil then
        return nil
    end
    return (consider(consider(a1, a3), a2))
end

return table.freeze(v1)