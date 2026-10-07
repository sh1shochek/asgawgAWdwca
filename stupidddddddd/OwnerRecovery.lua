-- ReplicatedStorage.MovementV2.Client.OwnerRecovery
-- Script path: ReplicatedStorage.MovementV2.Client.OwnerRecovery
-- Decompile time: 1.54 ms

local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
require(script.Parent.CommandStream)
require(script.Parent.PredictionRing)
require(script.Parent.RuntimeTypes)
local u27 = {}

local function orderedAfter(a1, a2, a3) -- Line: 16 -- upvalues: Serial (val) -- types: a3: boolean
    if a2 == nil then
        return nil
    end
    if a1.Sequence ~= a2.Sequence then
        if not Serial.isNewerUInt32(a1.Sequence, a2.Sequence) then
            return "SnapshotNotNewer"
        end
        if (Serial.deltaUInt32(a1.ServerTick, a2.ServerTick)) < 0 then
            return "ServerTickRegressed"
        end
        if (Serial.deltaUInt32(a1.LastProcessedCommand, a2.LastProcessedCommand)) < 0 then
            return "AcknowledgementRegressed"
        end
        if (Serial.deltaUInt32(a1.Topology.DestructibleRevision, a2.Topology.DestructibleRevision)) < 0 then
            return "TopologyRevisionRegressed"
        end
        if (Serial.deltaUInt32(a1.Topology.MoverRevision, a2.Topology.MoverRevision)) < 0 then
            return "MoverRevisionRegressed"
        end
        return nil
    end
    if not a3 then
        return "SnapshotNotNewer"
    end
    if a1.ServerTick == a2.ServerTick
        and a1.LastProcessedCommand == a2.LastProcessedCommand
        and a1.Topology.DestructibleRevision == a2.Topology.DestructibleRevision
        and a1.Topology.MoverRevision == a2.Topology.MoverRevision then
        if (Serial.deltaUInt32(a1.ServerTick, a2.ServerTick)) < 0 then
            return "ServerTickRegressed"
        end
        if (Serial.deltaUInt32(a1.LastProcessedCommand, a2.LastProcessedCommand)) < 0 then
            return "AcknowledgementRegressed"
        end
        if (Serial.deltaUInt32(a1.Topology.DestructibleRevision, a2.Topology.DestructibleRevision)) < 0 then
            return "TopologyRevisionRegressed"
        end
        if (Serial.deltaUInt32(a1.Topology.MoverRevision, a2.Topology.MoverRevision)) < 0 then
            return "MoverRevisionRegressed"
        end
        return nil
    end
    return "RecoverySnapshotIdentityMismatch"
end

function u27.retirementCutoff(a1, a2, a3, a4) -- Line: 51 -- upvalues: Serial (val) -- types: a4: number
    local v1 = if a1 == nil then nil else a1:lastSampledCommandNumber()
    if v1 ~= nil and a3 ~= nil then
        local v2 = Serial.deltaUInt32(v1, a4)
        if v2 < a3.CommandLeadResyncTicks then
            return nil
        end
        local v3 = Serial.addUInt32(a4, 1)
        if v2 < math.min(a3.CommandHistoryTicks, a3.PredictionReplayTicks, a3.MaxPendingCommandLeadTicks)
            and a1:getCommand(v3) ~= nil
            and a2 ~= nil
            and a2:get(v3) ~= nil then
            return nil
        end
        return Serial.addUInt32(a4, (math.min(v2, a3.MaxPendingCommandLeadTicks)))
    end
    return nil
end

function u27.prepare(a1, a2) -- Line: 75 -- upvalues: orderedAfter (val), Serial (val), u27 (val)
    local v1 = orderedAfter(a2, a1._lastAcceptedOwnerSnapshot, false) or orderedAfter(a2, a1._lastResyncOwnerSnapshot, true)
    if v1 ~= nil then
        return false, v1
    end
    local _pendingCommandResyncThrough = a1._pendingCommandResyncThrough
    if _pendingCommandResyncThrough ~= nil then
        if (Serial.deltaUInt32(a2.LastProcessedCommand, _pendingCommandResyncThrough)) < 0 then
            return false, "CommandLeadResync"
        end
        a1._pendingCommandResyncThrough = nil
        a1._commandResyncRequestedAt = 0
        a1._lastResyncOwnerSnapshot = a2
    end
    local v2 = u27.retirementCutoff(a1._commandStream, a1._predictionRing, a1._config, a2.LastProcessedCommand)
    if v2 == nil then
        return true, nil
    end
    a1._lastResyncOwnerSnapshot = a2
    a1:_sendCommandResyncRequest(v2)
    return false, "CommandLeadResync"
end

function u27.observe(a1, a2) -- Line: 105 -- upvalues: Serial (val), u27 (val)
    local _mapping = a1._mapping
    local _pendingCommandResyncThrough = a1._pendingCommandResyncThrough
    if a1._pendingReconciliationInstall ~= nil
        and _pendingCommandResyncThrough ~= nil
        and _mapping ~= nil
        and a2.Generation == _mapping.Generation
        and a2.Topology.Epoch == _mapping.TopologyEpoch
        and a2.Topology.Fingerprint == _mapping.TopologyFingerprint
        and not ((Serial.deltaUInt32(a2.LastProcessedCommand, _pendingCommandResyncThrough)) < 0) then
        local _commandStream = a1._commandStream and a1._commandStream:lastSampledCommandNumber()
        if _commandStream ~= nil and not (0 < (Serial.deltaUInt32(a2.LastProcessedCommand, _commandStream))) then
            u27.prepare(a1, a2)
            return
        end
        return
    end
end

return table.freeze(u27)