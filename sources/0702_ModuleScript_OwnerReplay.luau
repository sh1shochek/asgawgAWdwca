-- Decompiled with Potassium's decompiler.

local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local OwnerRecovery = require(script.Parent.OwnerRecovery);
require(script.Parent.Reconciler);
require(script.Parent.RuntimeTypes);
local WorldReplay = require(script.Parent.WorldReplay);
local v1 = {};

local function markOwnerFailed(p2, p3, p4) -- Line: 18
    -- upvalues: WorldReplay (copy)
    p3.FailedOwnerSequence = p4.Sequence;
    p3.FailedOwnerControls = WorldReplay.controlVersion(p2);
end;

local function restoreOriginalJob(p5: any, p6: any, p7: any, p8: any, p9: number?, p10: number, p11: any) -- Line: 23
    -- upvalues: WorldReplay (copy)
    p5._reconciler = p6;
    p5._pendingReconciliationInstall = p7;
    p5._pendingCommandResyncThrough = p9;
    p5._commandResyncRequestedAt = p10;
    p5._lastResyncOwnerSnapshot = p11;
    p7.FailedOwnerSequence = p8.Sequence;
    p7.FailedOwnerControls = WorldReplay.controlVersion(p5);
end;

function v1.invalidateWorld(p12) -- Line: 38
    if p12._reconciler ~= nil then
        p12._reconciler:discardReplayContinuation();
    end;
end;

function v1.invalidateWorldFromTick(p13: any, p14: number, p15: number) -- Line: 44
    if p13._reconciler ~= nil then
        p13._reconciler:invalidateWorldReplayFromTick(p14, p15);
    end;
end;

function v1.checkWorld(p16: any, p17: any, p18: number?) -- Line: 50
    local v19 = assert(p16._reconciler):retainedReplayAnchor(p17, p18);
    local v20;

    if v19 == nil then
        v20 = p17.ServerTick;
    else
        v20 = v19.ServerTick;
    end;

    local v21;

    if v19 == nil then
        v21 = p17.Topology.DestructibleRevision;
    else
        v21 = v19.TopologyRevision;
    end;

    local v22, v23 = assert(p16._timeline):peek(v20, v21);

    if v22 == nil then
        return v23;
    end;

    local _collisionComposer = p16._collisionComposer;
    local v24;

    if v19 == nil then
        v24 = p17.Topology.MoverRevision;
    else
        v24 = nil;
    end;

    local v25;

    if _collisionComposer == nil or type(_collisionComposer.ValidationView) ~= "function" then
        v25 = nil;
    else
        v25 = _collisionComposer:ValidationView();
    end;

    local _, v26 = p16:_composeWorld(v20, v21, v24, nil, nil, nil, v25);

    return v26;
end;

function v1.tryAdvance(u27) -- Line: 74
    -- upvalues: Serial (copy), WorldReplay (copy), OwnerRecovery (copy)
    local _pendingReconciliationInstall = u27._pendingReconciliationInstall;
    local _pendingOwnerSnapshot = u27._pendingOwnerSnapshot;
    local _pendingDiscontinuity = u27._pendingDiscontinuity;

    if _pendingDiscontinuity == nil or _pendingOwnerSnapshot ~= nil and not Serial.isNewerUInt32(_pendingDiscontinuity.Sequence, _pendingOwnerSnapshot.Sequence) then
        _pendingDiscontinuity = _pendingOwnerSnapshot;
    end;

    local _reconciler = u27._reconciler;
    local _config = u27._config;
    local _mapping = u27._mapping;
    local _commandStream = u27._commandStream;

    if _pendingReconciliationInstall == nil or (_pendingDiscontinuity == nil or (_reconciler == nil or (_config == nil or (_mapping == nil or (_commandStream == nil or _pendingReconciliationInstall.FailedOwnerSequence == _pendingDiscontinuity.Sequence and WorldReplay.controlsUnchanged(u27, _pendingReconciliationInstall.FailedOwnerControls)))))) then
        return false;
    end;

    if _commandStream:lastSampledCommandNumber() == nil or OwnerRecovery.retirementCutoff(_commandStream, u27._predictionRing, _config, _pendingDiscontinuity.LastProcessedCommand) ~= nil then
        return false;
    end;

    if _mapping.PlayerCollisionsEnabled then
        local v28 = assert(u27._remoteBuffer):latestCompleteServerTick();

        if v28 == nil or Serial.deltaUInt32(v28, _pendingDiscontinuity.ServerTick) < 0 then
            return false;
        end;
    end;

    local v29 = _reconciler:forkForNewerOwner(_pendingDiscontinuity);

    if v29 == nil then
        return false;
    end;

    local u30, v31 = WorldReplay.prepare(u27);

    if v31 ~= nil then
        _pendingReconciliationInstall.FailedOwnerSequence = _pendingDiscontinuity.Sequence;
        _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(u27);

        return false;
    end;

    local _pendingCommandResyncThrough = u27._pendingCommandResyncThrough;
    local _commandResyncRequestedAt = u27._commandResyncRequestedAt;
    local _lastResyncOwnerSnapshot = u27._lastResyncOwnerSnapshot;
    u27._reconciler = v29;
    u27._pendingReconciliationInstall = nil;

    if u30 ~= nil then
        u30:bind();
    end;

    local v32, v33, v34 = pcall(function() -- Line: 131
        -- upvalues: u27 (copy), _pendingDiscontinuity (ref), u30 (copy)
        return u27:_installSnapshot(_pendingDiscontinuity, false, nil, true, u30 ~= nil and function() -- Line: 138
            -- upvalues: u30 (ref)
            u30:commit();
        end or nil);
    end);

    if u30 ~= nil then
        u30:destroy();
    end;

    if not v32 then
        if v29:lastAcceptedSequence() ~= _pendingDiscontinuity.Sequence then
            u27._reconciler = _reconciler;
            u27._pendingReconciliationInstall = _pendingReconciliationInstall;
            u27._pendingCommandResyncThrough = _pendingCommandResyncThrough;
            u27._commandResyncRequestedAt = _commandResyncRequestedAt;
            u27._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot;
            _pendingReconciliationInstall.FailedOwnerSequence = _pendingDiscontinuity.Sequence;
            _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(u27);
        end;

        error(v33, 0);
    end;

    if v33 or v34 == "ReplayPending" then
        u27._pendingOwnerSnapshot = nil;
        local MoverRevisionToValidate = _pendingReconciliationInstall.MoverRevisionToValidate;

        if u30 then
            u30 = u30.MoverRevisionToValidate;
        end;

        if u30 == nil or MoverRevisionToValidate ~= nil and Serial.deltaUInt32(u30, MoverRevisionToValidate) <= 0 then
            u30 = MoverRevisionToValidate;
        end;

        local _pendingReconciliationInstall2 = u27._pendingReconciliationInstall;

        if _pendingReconciliationInstall2 == nil then
            if u30 ~= nil then
                u27:_markMoverRevisionValidated(u30);
            end;
        else
            _pendingReconciliationInstall2.MoverRevisionToValidate = u30;
        end;

        local _pendingDiscontinuity2 = u27._pendingDiscontinuity;

        if _pendingDiscontinuity2 ~= nil and (_pendingDiscontinuity2.Generation == _pendingDiscontinuity.Generation and not Serial.isNewerUInt32(_pendingDiscontinuity2.Sequence, _pendingDiscontinuity.Sequence)) then
            local v35;

            if v33 then
                v35 = nil;
            else
                v35 = _pendingDiscontinuity;
            end;

            u27._pendingDiscontinuity = v35;
        end;

        return true, v33, v34;
    end;

    u27._reconciler = _reconciler;
    u27._pendingReconciliationInstall = _pendingReconciliationInstall;
    u27._pendingCommandResyncThrough = _pendingCommandResyncThrough;
    u27._commandResyncRequestedAt = _commandResyncRequestedAt;
    u27._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot;
    _pendingReconciliationInstall.FailedOwnerSequence = _pendingDiscontinuity.Sequence;
    _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(u27);

    return false;
end;

return table.freeze(v1);