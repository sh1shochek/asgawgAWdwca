-- ReplicatedStorage.MovementV2.Client.OwnerReplay
-- Script path: ReplicatedStorage.MovementV2.Client.OwnerReplay
-- Decompile time: 4.99 ms

local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local OwnerRecovery = require(script.Parent.OwnerRecovery)
require(script.Parent.Reconciler)
require(script.Parent.RuntimeTypes)
local WorldReplay = require(script.Parent.WorldReplay)
local v1 = {}

local function markOwnerFailed(a1, a2, a3) -- Line: 18 -- upvalues: WorldReplay (val)
    a2.FailedOwnerSequence = a3.Sequence
    a2.FailedOwnerControls = WorldReplay.controlVersion(a1)
end

local function restoreOriginalJob(a1, a2, a3, a4, a5, a6, a7) -- Line: 23
    -- upvalues: WorldReplay (val)
    a1._reconciler = a2
    a1._pendingReconciliationInstall = a3
    a1._pendingCommandResyncThrough = a5
    a1._commandResyncRequestedAt = a6
    a1._lastResyncOwnerSnapshot = a7
    a3.FailedOwnerSequence = a4.Sequence
    a3.FailedOwnerControls = WorldReplay.controlVersion(a1)
end

function v1.invalidateWorld(a1) -- Line: 38
    if a1._reconciler ~= nil then
        a1._reconciler:discardReplayContinuation()
    end
end

function v1.invalidateWorldFromTick(a1, a2, a3) -- Line: 44 -- types: a2: number, a3: number
    if a1._reconciler ~= nil then
        a1._reconciler:invalidateWorldReplayFromTick(a2, a3)
    end
end

function v1.checkWorld(a1, a2, a3) -- Line: 50 -- types: a3: number?
    local v1
    local v2 = assert(a1._reconciler):retainedReplayAnchor(a2, a3)
    local ServerTick = if v2 ~= nil then v2.ServerTick else a2.ServerTick
    local DestructibleRevision = if v2 ~= nil then v2.TopologyRevision else a2.Topology.DestructibleRevision
    local v3, v4 = assert(a1._timeline):peek(ServerTick, DestructibleRevision)
    if v3 == nil then
        return v4
    end
    local _collisionComposer = a1._collisionComposer
    _, v1 = a1:_composeWorld(
        ServerTick,
        DestructibleRevision,
        if v2 ~= nil then nil else a2.Topology.MoverRevision,
        nil,
        nil,
        nil,
        if _collisionComposer == nil then nil else if type(_collisionComposer.ValidationView) ~= "function" then nil else _collisionComposer:ValidationView()
    )
    return v1
end

function v1.tryAdvance(a1) -- Line: 74 -- upvalues: Serial (val), WorldReplay (val), OwnerRecovery (val)
    local _pendingReconciliationInstall = a1._pendingReconciliationInstall
    local _pendingOwnerSnapshot = a1._pendingOwnerSnapshot
    local _pendingDiscontinuity = a1._pendingDiscontinuity
    if _pendingDiscontinuity ~= nil then
        if _pendingOwnerSnapshot == nil
            or Serial.isNewerUInt32(_pendingDiscontinuity.Sequence, _pendingOwnerSnapshot.Sequence) then
            _pendingOwnerSnapshot = _pendingDiscontinuity
        end
    end
    local _reconciler = a1._reconciler
    local _config = a1._config
    local _mapping = a1._mapping
    local _commandStream = a1._commandStream
    if _pendingReconciliationInstall ~= nil
        and _pendingOwnerSnapshot ~= nil
        and _reconciler ~= nil
        and _config ~= nil
        and _mapping ~= nil
        and _commandStream ~= nil then
        if _pendingReconciliationInstall.FailedOwnerSequence == _pendingOwnerSnapshot.Sequence
            and WorldReplay.controlsUnchanged(a1, _pendingReconciliationInstall.FailedOwnerControls) then
            return false
        end
        if _commandStream:lastSampledCommandNumber() ~= nil
            and OwnerRecovery.retirementCutoff(_commandStream, a1._predictionRing, _config, _pendingOwnerSnapshot.LastProcessedCommand) == nil then
            local MoverRevisionToValidate, MoverRevisionToValidate_2, _commandResyncRequestedAt, _lastResyncOwnerSnapshot, _pendingCommandResyncThrough, _pendingDiscontinuity_2, _pendingReconciliationInstall_2, result, success, u68, v1, v2, v3, v4
            if not _mapping.PlayerCollisionsEnabled then
                v4 = _reconciler:forkForNewerOwner(_pendingOwnerSnapshot)
                if v4 == nil then
                    return false
                end
                u68, v1 = WorldReplay.prepare(a1)
                if v1 ~= nil then
                    _pendingReconciliationInstall.FailedOwnerSequence = _pendingOwnerSnapshot.Sequence
                    _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    return false
                end
                _pendingCommandResyncThrough = a1._pendingCommandResyncThrough
                _commandResyncRequestedAt = a1._commandResyncRequestedAt
                _lastResyncOwnerSnapshot = a1._lastResyncOwnerSnapshot
                a1._reconciler = v4
                a1._pendingReconciliationInstall = nil
                if u68 ~= nil then
                    u68:bind()
                end
                success, result, v2 = pcall(function() -- Line: 131 -- upvalues: a1 (val), _pendingOwnerSnapshot (ref), u68 (val)
                    local v1 = _pendingOwnerSnapshot
                    return a1:_installSnapshot(v1, false, nil, true, if u68 == nil then nil else function() -- Line: 138 -- upvalues: u68 (upval)
                        u68:commit()
                    end)
                end)
                if u68 ~= nil then
                    u68:destroy()
                end
                if not success then
                    v3 = v4:lastAcceptedSequence()
                    if v3 ~= _pendingOwnerSnapshot.Sequence then
                        v3 = _pendingOwnerSnapshot
                        a1._reconciler = _reconciler
                        a1._pendingReconciliationInstall = _pendingReconciliationInstall
                        a1._pendingCommandResyncThrough = _pendingCommandResyncThrough
                        a1._commandResyncRequestedAt = _commandResyncRequestedAt
                        a1._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot
                        _pendingReconciliationInstall.FailedOwnerSequence = v3.Sequence
                        _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    end
                    error(result, 0)
                end
                if not result and v2 ~= "ReplayPending" then
                    v3 = _pendingOwnerSnapshot
                    a1._reconciler = _reconciler
                    a1._pendingReconciliationInstall = _pendingReconciliationInstall
                    a1._pendingCommandResyncThrough = _pendingCommandResyncThrough
                    a1._commandResyncRequestedAt = _commandResyncRequestedAt
                    a1._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot
                    _pendingReconciliationInstall.FailedOwnerSequence = v3.Sequence
                    _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    return false
                end
                a1._pendingOwnerSnapshot = nil
                MoverRevisionToValidate = _pendingReconciliationInstall.MoverRevisionToValidate
                MoverRevisionToValidate_2 = u68 and u68.MoverRevisionToValidate
                if MoverRevisionToValidate_2 ~= nil then
                    if MoverRevisionToValidate == nil
                        or 0 < (Serial.deltaUInt32(MoverRevisionToValidate_2, MoverRevisionToValidate)) then
                        MoverRevisionToValidate = MoverRevisionToValidate_2
                    end
                end
                _pendingReconciliationInstall_2 = a1._pendingReconciliationInstall
                if _pendingReconciliationInstall_2 ~= nil then
                    _pendingReconciliationInstall_2.MoverRevisionToValidate = MoverRevisionToValidate
                elseif MoverRevisionToValidate ~= nil then
                    a1:_markMoverRevisionValidated(MoverRevisionToValidate)
                end
                _pendingDiscontinuity_2 = a1._pendingDiscontinuity
                if _pendingDiscontinuity_2 ~= nil
                    and _pendingDiscontinuity_2.Generation == _pendingOwnerSnapshot.Generation
                    and not Serial.isNewerUInt32(_pendingDiscontinuity_2.Sequence, _pendingOwnerSnapshot.Sequence) then
                    a1._pendingDiscontinuity = if not result then _pendingOwnerSnapshot else nil
                end
                return true, result, v2
            end
            v4 = assert(a1._remoteBuffer):latestCompleteServerTick()
            if v4 ~= nil and not ((Serial.deltaUInt32(v4, _pendingOwnerSnapshot.ServerTick)) < 0) then
                v4 = _reconciler:forkForNewerOwner(_pendingOwnerSnapshot)
                if v4 == nil then
                    return false
                end
                u68, v1 = WorldReplay.prepare(a1)
                if v1 ~= nil then
                    _pendingReconciliationInstall.FailedOwnerSequence = _pendingOwnerSnapshot.Sequence
                    _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    return false
                end
                _pendingCommandResyncThrough = a1._pendingCommandResyncThrough
                _commandResyncRequestedAt = a1._commandResyncRequestedAt
                _lastResyncOwnerSnapshot = a1._lastResyncOwnerSnapshot
                a1._reconciler = v4
                a1._pendingReconciliationInstall = nil
                if u68 ~= nil then
                    u68:bind()
                end
                success, result, v2 = pcall(function() -- Line: 131 -- upvalues: a1 (val), _pendingOwnerSnapshot (ref), u68 (val)
                    local v1 = _pendingOwnerSnapshot
                    return a1:_installSnapshot(v1, false, nil, true, if u68 == nil then nil else function() -- Line: 138 -- upvalues: u68 (upval)
                        u68:commit()
                    end)
                end)
                if u68 ~= nil then
                    u68:destroy()
                end
                if not success then
                    v3 = v4:lastAcceptedSequence()
                    if v3 ~= _pendingOwnerSnapshot.Sequence then
                        v3 = _pendingOwnerSnapshot
                        a1._reconciler = _reconciler
                        a1._pendingReconciliationInstall = _pendingReconciliationInstall
                        a1._pendingCommandResyncThrough = _pendingCommandResyncThrough
                        a1._commandResyncRequestedAt = _commandResyncRequestedAt
                        a1._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot
                        _pendingReconciliationInstall.FailedOwnerSequence = v3.Sequence
                        _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    end
                    error(result, 0)
                end
                if not result and v2 ~= "ReplayPending" then
                    v3 = _pendingOwnerSnapshot
                    a1._reconciler = _reconciler
                    a1._pendingReconciliationInstall = _pendingReconciliationInstall
                    a1._pendingCommandResyncThrough = _pendingCommandResyncThrough
                    a1._commandResyncRequestedAt = _commandResyncRequestedAt
                    a1._lastResyncOwnerSnapshot = _lastResyncOwnerSnapshot
                    _pendingReconciliationInstall.FailedOwnerSequence = v3.Sequence
                    _pendingReconciliationInstall.FailedOwnerControls = WorldReplay.controlVersion(a1)
                    return false
                end
                a1._pendingOwnerSnapshot = nil
                MoverRevisionToValidate = _pendingReconciliationInstall.MoverRevisionToValidate
                MoverRevisionToValidate_2 = u68 and u68.MoverRevisionToValidate
                if MoverRevisionToValidate_2 ~= nil then
                    if MoverRevisionToValidate == nil
                        or 0 < (Serial.deltaUInt32(MoverRevisionToValidate_2, MoverRevisionToValidate)) then
                        MoverRevisionToValidate = MoverRevisionToValidate_2
                    end
                end
                _pendingReconciliationInstall_2 = a1._pendingReconciliationInstall
                if _pendingReconciliationInstall_2 ~= nil then
                    _pendingReconciliationInstall_2.MoverRevisionToValidate = MoverRevisionToValidate
                elseif MoverRevisionToValidate ~= nil then
                    a1:_markMoverRevisionValidated(MoverRevisionToValidate)
                end
                _pendingDiscontinuity_2 = a1._pendingDiscontinuity
                if _pendingDiscontinuity_2 ~= nil
                    and _pendingDiscontinuity_2.Generation == _pendingOwnerSnapshot.Generation
                    and not Serial.isNewerUInt32(_pendingDiscontinuity_2.Sequence, _pendingOwnerSnapshot.Sequence) then
                    a1._pendingDiscontinuity = if not result then _pendingOwnerSnapshot else nil
                end
                return true, result, v2
            end
            return false
        end
        return false
    end
    return false
end

return table.freeze(v1)