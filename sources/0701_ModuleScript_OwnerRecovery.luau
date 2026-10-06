-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
require(script.Parent.CommandStream);
require(script.Parent.PredictionRing);
require(script.Parent.RuntimeTypes);
local u1 = {};

local function orderedAfter(p2: any, p3: any, p4: boolean) -- Line: 16
    -- upvalues: Serial (copy)
    if p3 == nil then
        return nil;
    end;

    if p2.Sequence == p3.Sequence then
        if not p4 then
            return "SnapshotNotNewer";
        end;

        if p2.ServerTick ~= p3.ServerTick or (p2.LastProcessedCommand ~= p3.LastProcessedCommand or (p2.Topology.DestructibleRevision ~= p3.Topology.DestructibleRevision or p2.Topology.MoverRevision ~= p3.Topology.MoverRevision)) then
            return "RecoverySnapshotIdentityMismatch";
        end;
    elseif not Serial.isNewerUInt32(p2.Sequence, p3.Sequence) then
        return "SnapshotNotNewer";
    end;

    return Serial.deltaUInt32(p2.ServerTick, p3.ServerTick) < 0 and "ServerTickRegressed" or (Serial.deltaUInt32(p2.LastProcessedCommand, p3.LastProcessedCommand) < 0 and "AcknowledgementRegressed" or (Serial.deltaUInt32(p2.Topology.DestructibleRevision, p3.Topology.DestructibleRevision) < 0 and "TopologyRevisionRegressed" or (Serial.deltaUInt32(p2.Topology.MoverRevision, p3.Topology.MoverRevision) < 0 and "MoverRevisionRegressed" or nil)));
end;

function u1.retirementCutoff(p5: any, p6: any, p7: any, p8: number) -- Line: 51
    -- upvalues: Serial (copy)
    local v9;

    if p5 == nil then
        v9 = nil;
    else
        v9 = p5:lastSampledCommandNumber();
    end;

    if v9 == nil or p7 == nil then
        return nil;
    end;

    local v10 = Serial.deltaUInt32(v9, p8);

    if v10 < p7.CommandLeadResyncTicks then
        return nil;
    end;

    local v11 = Serial.addUInt32(p8, 1);

    if v10 < math.min(p7.CommandHistoryTicks, p7.PredictionReplayTicks, p7.MaxPendingCommandLeadTicks) and (p5:getCommand(v11) ~= nil and (p6 ~= nil and p6:get(v11) ~= nil)) then
        return nil;
    end;

    return Serial.addUInt32(p8, (math.min(v10, p7.MaxPendingCommandLeadTicks)));
end;

function u1.prepare(p12, p13) -- Line: 75
    -- upvalues: orderedAfter (copy), Serial (copy), u1 (copy)
    local v14 = orderedAfter(p13, p12._lastAcceptedOwnerSnapshot, false) or orderedAfter(p13, p12._lastResyncOwnerSnapshot, true);

    if v14 ~= nil then
        return false, v14;
    end;

    local _pendingCommandResyncThrough = p12._pendingCommandResyncThrough;

    if _pendingCommandResyncThrough ~= nil then
        if Serial.deltaUInt32(p13.LastProcessedCommand, _pendingCommandResyncThrough) < 0 then
            return false, "CommandLeadResync";
        end;

        p12._pendingCommandResyncThrough = nil;
        p12._commandResyncRequestedAt = 0;
        p12._lastResyncOwnerSnapshot = p13;
    end;

    local v15 = u1.retirementCutoff(p12._commandStream, p12._predictionRing, p12._config, p13.LastProcessedCommand);

    if v15 == nil then
        return true, nil;
    end;

    p12._lastResyncOwnerSnapshot = p13;
    p12:_sendCommandResyncRequest(v15);

    return false, "CommandLeadResync";
end;

function u1.observe(p16, p17) -- Line: 105
    -- upvalues: Serial (copy), u1 (copy)
    local _mapping = p16._mapping;
    local _pendingCommandResyncThrough = p16._pendingCommandResyncThrough;

    if p16._pendingReconciliationInstall == nil or (_pendingCommandResyncThrough == nil or (_mapping == nil or (p17.Generation ~= _mapping.Generation or (p17.Topology.Epoch ~= _mapping.TopologyEpoch or (p17.Topology.Fingerprint ~= _mapping.TopologyFingerprint or Serial.deltaUInt32(p17.LastProcessedCommand, _pendingCommandResyncThrough) < 0))))) then
        return;
    end;

    local v18 = p16._commandStream and p16._commandStream:lastSampledCommandNumber();

    if v18 == nil or Serial.deltaUInt32(p17.LastProcessedCommand, v18) > 0 then
        return;
    end;

    u1.prepare(p16, p17);
end;

return table.freeze(u1);