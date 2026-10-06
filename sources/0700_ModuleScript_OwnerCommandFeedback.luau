-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
require(script.Parent.RuntimeTypes);
local v1 = {};

local function newerFeedback(p2, p3) -- Line: 11
    -- upvalues: Serial (copy)
    local v4;

    if p3 == nil or p3.Generation ~= p2.Generation then
        v4 = true;
    else
        v4 = Serial.isNewerUInt32(p2.Sequence, p3.Sequence);

        if v4 then
            if Serial.deltaUInt32(p2.ServerTick, p3.ServerTick) >= 0 and (Serial.deltaUInt32(p2.LastProcessedCommand, p3.LastProcessedCommand) >= 0 and Serial.deltaUInt32(p2.Topology.DestructibleRevision, p3.Topology.DestructibleRevision) >= 0) then
                v4 = Serial.deltaUInt32(p2.Topology.MoverRevision, p3.Topology.MoverRevision) >= 0;
            else
                v4 = false;
            end;
        end;
    end;

    return v4;
end;

function v1.observe(p5: any, p6: any, p7: number) -- Line: 24
    -- upvalues: newerFeedback (copy)
    local _mapping = p5._mapping;

    if _mapping == nil or (p6.Generation ~= _mapping.Generation or (p6.Topology.Epoch ~= _mapping.TopologyEpoch or (p6.Topology.Fingerprint ~= _mapping.TopologyFingerprint or not (newerFeedback(p6, p5._lastAcceptedOwnerSnapshot) and newerFeedback(p6, p5._lastOwnerCommandFeedback))))) then
        return;
    end;

    p5._lastOwnerCommandFeedback = p6;
    local _commandClock = p5._commandClock;

    if _commandClock ~= nil then
        _commandClock:observe(p6.BufferDepth, p7);
    end;

    p5._diagnostics:recordOwnerFeedback(p6);
end;

local function consider(p8, p9) -- Line: 44
    -- upvalues: Serial (copy)
    if p9 == nil or (p9.Generation ~= p8.Generation or (p9.LastProcessedCommand ~= p8.LastProcessedCommand or (p9.Topology.Epoch ~= p8.Topology.Epoch or (p9.Topology.Fingerprint ~= p8.Topology.Fingerprint or (not Serial.isNewerUInt32(p9.Sequence, p8.Sequence) or Serial.deltaUInt32(p9.ServerTick, p8.ServerTick) < 0))))) then
        return p8;
    end;

    return p9;
end;

function v1.choose(p10, p11, p12) -- Line: 60
    -- upvalues: consider (copy)
    if p10 == nil then
        return nil;
    end;

    return consider(consider(p10, p12), p11);
end;

return table.freeze(v1);