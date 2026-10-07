-- ReplicatedStorage.MovementV2.Client.Reconciler
-- Script path: ReplicatedStorage.MovementV2.Client.Reconciler
-- Decompile time: 94.30 ms

local Enums = require(script.Parent.Parent.Enums)
local Mapping = require(script.Parent.Parent.Mapping)
local OwnerSnapshotCodec = require(script.Parent.Parent.OwnerSnapshotCodec)
local Quantization = require(script.Parent.Parent.Quantization)
local Serial = require(script.Parent.Parent.Serial)
local StateCodec = require(script.Parent.Parent.StateCodec)
require(script.Parent.Parent.Types)
local State = require(script.Parent.Parent.Simulation.State)
local PredictionRing = require(script.Parent.PredictionRing)
local u61 = bit32.bor(State.fieldMask("Position"), (State.fieldMask("Velocity")))
local u62 = {}
u62.__index = u62

local function cloneTopology(a1, a2) -- Line: 187 -- types: a2: number?
    return {
        Epoch = a1.Epoch,
        Fingerprint = a1.Fingerprint,
        DestructibleRevision = a2 or a1.DestructibleRevision,
        MoverRevision = a1.MoverRevision,
    }
end

local function advanceValidatedMoverRevision(a1, a2) -- Line: 196 -- upvalues: Serial (val) -- types: a2: number
    local _validatedMoverRevision = a1._validatedMoverRevision
    if _validatedMoverRevision == nil or 0 < (Serial.deltaUInt32(a2, _validatedMoverRevision)) then
        a1._validatedMoverRevision = a2
    end
end

local function recordAcceptedSnapshot(a1, a2) -- Line: 203 -- upvalues: State (val), Serial (val)
    a1._lastSequence = a2.Sequence
    a1._lastServerTick = a2.ServerTick
    a1._lastProcessedCommand = a2.LastProcessedCommand
    a1._lastSnapshotState = State.clone(a2.State)
    a1._lastSnapshotSupport = State.cloneSupport(a2.Support)
    a1._lastTopologyRevision = a2.Topology.DestructibleRevision
    a1._lastMoverRevision = a2.Topology.MoverRevision
    local MoverRevision = a2.Topology.MoverRevision
    local _validatedMoverRevision = a1._validatedMoverRevision
    if _validatedMoverRevision == nil or 0 < (Serial.deltaUInt32(MoverRevision, _validatedMoverRevision)) then
        a1._validatedMoverRevision = MoverRevision
    end
end

local function replayAnchor(a1, a2, a3, a4, a5, a6) -- Line: 214
    -- upvalues: State (val)
    return {
        Snapshot = a1,
        State = State.clone(a2),
        Support = State.cloneSupport(a3),
        ServerTick = a4,
        CommandNumber = a5,
        TopologyRevision = a6,
    }
end

local function snapshotReplayAnchor(a1) -- Line: 232 -- upvalues: State (val)
    local State_2 = a1.State
    local Support = a1.Support
    local ServerTick = a1.ServerTick
    local LastProcessedCommand = a1.LastProcessedCommand
    local DestructibleRevision = a1.Topology.DestructibleRevision
    return {
        Snapshot = a1,
        State = State.clone(State_2),
        Support = State.cloneSupport(Support),
        ServerTick = ServerTick,
        CommandNumber = LastProcessedCommand,
        TopologyRevision = DestructibleRevision,
    }
end

local function validSupport(a1) -- Line: 243 -- upvalues: Enums (val), Serial (val), Quantization (val)
    local v1 = false
    if typeof(a1) == "table" then
        v1 = false
        if type(a1.Kind) == "number" then
            v1 = false
            if a1.Kind % 1 == 0 then
                v1 = false
                if Enums.SupportKind.None <= a1.Kind then
                    v1 = false
                    if a1.Kind <= Enums.SupportKind.Max then
                        v1 = Serial.isUInt32(a1.SourceId)
                        if v1 then
                            v1 = false
                            if a1.Kind == Enums.SupportKind.None == (a1.SourceId == 0) then
                                v1 = Quantization.isFiniteVector3(a1.Anchor) and Quantization.isFiniteVector3(a1.Velocity)
                            end
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function angleError(a1, a2) -- Line: 255 -- types: a1: number, a2: number
    return (math.abs((a1 - a2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793))
end

local function tailResult(a1, a2, a3, a4) -- Line: 260 -- upvalues: State (val) -- types: a3: number, a4: table
    local v1 = {
        ReplayCount = 0,
        LastProcessedCommand = a1.LastProcessedCommand,
        ServerTick = a1.ServerTick,
    }
    local LastProcessedCommand = if a2 ~= nil then a2.Command.CommandNumber else a1.LastProcessedCommand
    v1.TailCommandNumber = LastProcessedCommand
    local ServerTick = if a2 ~= nil then a2.ServerTick else a1.ServerTick
    v1.TailServerTick = ServerTick
    local v2 = if a2 ~= nil then State.clone(a2.PostState) else State.clone(a1.State)
    v1.State = v2
    v2 = if a2 ~= nil then State.cloneSupport(a2.PostSupport) else State.cloneSupport(a1.Support)
    v1.Support = v2
    v1.DroppedCommandCount = a3
    v1.Metrics = a4
    return v1
end

local function zeroMetrics() -- Line: 281
    return {
        ComparedAtAck = false,
        SynthesizedInput = false,
        PlayerContactCorrection = false,
        ReconciliationMode = "Reuse",
        ReconciliationWorkSeconds = 0,
        ReconciliationElapsedSeconds = 0,
        ReconciliationSliceCount = 0,
        ReconciliationMaximumSliceSeconds = 0,
        ReplayCount = 0,
        DroppedCommandCount = 0,
        AcknowledgedCommandDelta = 0,
        ServerTickDelta = 0,
        ServerHeldTickCount = 0,
        TailCompared = false,
        TailServerTickDelta = 0,
        TailPosition = 0,
        PresentationPositionDelta = Vector3.new(0, 0, 0),
        TailHorizontalPosition = 0,
        TailVerticalPosition = 0,
        TailVelocity = 0,
        TailVerticalVelocity = 0,
        TailSupportAnchor = 0,
        TailSupportVelocity = 0,
        TailSupportKindMismatch = 0,
        TailSupportSourceMismatch = 0,
        TailGroundMismatch = false,
        TailStanceMismatch = false,
        CanonicalStateMismatchCount = 0,
        CanonicalStateMismatchMask = 0,
        CanonicalSupportMismatch = false,
        TickRealigned = false,
        ReplayBarrier = "None",
        Position = 0,
        HorizontalPosition = 0,
        Velocity = 0,
        LookYaw = 0,
        VerticalLook = 0,
        DuckAmount = 0,
        Stamina = 0,
        SupportAnchor = 0,
        SupportVelocity = 0,
        SupportKindMismatch = 0,
        SupportSourceMismatch = 0,
        TopologyRevisionDelta = 0,
    }
end

local function canonicalStateMismatch(a1, a2) -- Line: 330 -- upvalues: StateCodec (val), State (val)
    local v1, v2 = StateCodec.canonicalize(a1)
    assert(v1 ~= nil, v2 or "predicted state could not be canonicalized")
    return State.canonicalMismatch(v1, a2)
end

local function measure(a1, a2) -- Line: 336
    -- upvalues: zeroMetrics (val), Enums (val), StateCodec (val), State (val), OwnerSnapshotCodec (val), Serial (val)
    local v1 = zeroMetrics()
    v1.SynthesizedInput = bit32.band(a1.Flags, Enums.OwnerSnapshotFlags.SynthesizedInput) ~= 0
    if a2 == nil then
        return v1
    end
    local v2 = a2.PostState.Position - a1.State.Position
    v1.ComparedAtAck = true
    local PostState = a2.PostState
    local State_2 = a1.State
    local v3, v4 = StateCodec.canonicalize(PostState)
    assert(v3 ~= nil, v4 or "predicted state could not be canonicalized")
    local v5, v6 = State.canonicalMismatch(v3, State_2)
    v1.CanonicalStateMismatchCount = v5
    v1.CanonicalStateMismatchMask = v6
    local v7, v8 = OwnerSnapshotCodec.canonicalizeSupport(a2.PostSupport)
    assert(v7 ~= nil, v8 or "predicted support could not be canonicalized")
    local v9 = true
    if v7.Kind == a1.Support.Kind then
        v9 = true
        if v7.SourceId == a1.Support.SourceId then
            v9 = true
            if v7.Anchor == a1.Support.Anchor then
                v9 = v7.Velocity ~= a1.Support.Velocity
            end
        end
    end
    v1.CanonicalSupportMismatch = v9
    v1.Position = v2.Magnitude
    v1.HorizontalPosition = Vector2.new(v2.X, v2.Z).Magnitude
    v1.Velocity = (a2.PostState.Velocity - a1.State.Velocity).Magnitude
    v1.LookYaw = math.abs((a2.PostState.LookYaw - a1.State.LookYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)
    v1.VerticalLook = math.abs(a2.PostState.VerticalLook - a1.State.VerticalLook)
    v1.DuckAmount = math.abs(a2.PostState.DuckAmount - a1.State.DuckAmount)
    v1.Stamina = math.abs(a2.PostState.Stamina - a1.State.Stamina)
    v1.SupportAnchor = (a2.PostSupport.Anchor - a1.Support.Anchor).Magnitude
    v1.SupportVelocity = (a2.PostSupport.Velocity - a1.Support.Velocity).Magnitude
    v1.SupportKindMismatch = if a2.PostSupport.Kind ~= a1.Support.Kind then 1 else 0
    v1.SupportSourceMismatch = if a2.PostSupport.SourceId ~= a1.Support.SourceId then 1 else 0
    v1.TopologyRevisionDelta = math.abs((Serial.deltaUInt32(a2.TopologyRevision, a1.Topology.DestructibleRevision)))
    return v1
end

function u62.new(a1, a2) -- Line: 368 -- upvalues: Mapping (val), u62 (val)
    local v1, v2 = Mapping.validate(a1)
    assert(v1, v2 or "invalid command mapping")
    return (setmetatable({
        _requiresWorldReplay = false,
        _mapping = Mapping.clone(a1),
        _ring = a2,
        _entryScratch = {},
    }, u62))
end

local function clearReplayHistory(a1, a2) -- Line: 380 -- types: a2: boolean
    if not a2 then
        a1._lastSequence = nil
        a1._lastServerTick = nil
        a1._lastProcessedCommand = nil
        a1._lastTopologyRevision = nil
        a1._lastMoverRevision = nil
    end
    a1._validatedMoverRevision = nil
    a1._pendingReplay = nil
    a1._lastSnapshotState = nil
    a1._lastSnapshotSupport = nil
    table.clear(a1._entryScratch)
end

function u62:reset(a2) -- Line: 395 -- upvalues: Mapping (val)
    self._completedReplayAnchor = nil
    local v1, v2 = Mapping.validate(a2)
    assert(v1, v2 or "invalid command mapping")
    self._mapping = Mapping.clone(a2)
    self._ring:reset(a2)
    self._requiresWorldReplay = false
    self._lastSequence = nil
    self._lastServerTick = nil
    self._lastProcessedCommand = nil
    self._lastTopologyRevision = nil
    self._lastMoverRevision = nil
    self._validatedMoverRevision = nil
    self._pendingReplay = nil
    self._lastSnapshotState = nil
    self._lastSnapshotSupport = nil
    table.clear(self._entryScratch)
end

function u62.reconfigure(a1, a2) -- Line: 406 -- upvalues: Mapping (val)
    a1._completedReplayAnchor = nil
    local v1, v2 = Mapping.validate(a2)
    assert(v1, v2 or "invalid command mapping")
    assert(a2.Generation == a1._mapping.Generation, "cannot reconfigure a different reconciliation generation")
    assert(a2.SimulationHz == a1._mapping.SimulationHz, "cannot reconfigure the reconciliation rate")
    local v3 = false
    if a2.ActorId == a1._mapping.ActorId then
        v3 = false
        if a2.TopologyEpoch == a1._mapping.TopologyEpoch then
            v3 = false
            if a2.TopologyFingerprint == a1._mapping.TopologyFingerprint then
                v3 = a2.PlayerCollisionsEnabled ~= a1._mapping.PlayerCollisionsEnabled
            end
        end
    end
    a1._mapping = Mapping.clone(a2)
    a1._requiresWorldReplay = v3
    if not v3 then
        a1._lastSequence = nil
        a1._lastServerTick = nil
        a1._lastProcessedCommand = nil
        a1._lastTopologyRevision = nil
        a1._lastMoverRevision = nil
    end
    a1._validatedMoverRevision = nil
    a1._pendingReplay = nil
    a1._lastSnapshotState = nil
    a1._lastSnapshotSupport = nil
    table.clear(a1._entryScratch)
end

function u62.markMoverRevisionValidated(a1, a2) -- Line: 421 -- upvalues: Serial (val) -- types: a1: table, a2: number
    if not Serial.isUInt32(a2) then
        return false, "InvalidMoverRevision"
    end
    local _validatedMoverRevision = a1._validatedMoverRevision
    if _validatedMoverRevision == nil or 0 < (Serial.deltaUInt32(a2, _validatedMoverRevision)) then
        a1._validatedMoverRevision = a2
    end
    local _completedReplayAnchor = a1._completedReplayAnchor
    if _completedReplayAnchor ~= nil
        and _completedReplayAnchor.WorldInvalidRevision ~= nil
        and 0 <= (Serial.deltaUInt32(a2, _completedReplayAnchor.WorldInvalidRevision)) then
        _completedReplayAnchor.WorldInvalidFromTick = nil
        _completedReplayAnchor.WorldInvalidRevision = nil
    end
    return true, nil
end

function u62.hasPendingReplay(a1) -- Line: 437
    return a1._pendingReplay ~= nil
end

function u62.cancelPendingReplay(a1) -- Line: 441
    a1._pendingReplay = nil
end

function u62.discardReplayContinuation(a1) -- Line: 445
    a1._completedReplayAnchor = nil
end

function u62.invalidateWorldReplayFromTick(a1, a2, a3) -- Line: 449
    -- upvalues: Serial (val)
    local _completedReplayAnchor = a1._completedReplayAnchor
    if _completedReplayAnchor == nil then
        return
    end
    if (Serial.deltaUInt32(a2, _completedReplayAnchor.ServerTick)) <= 0 then
        a1._completedReplayAnchor = nil
        return
    end
    if _completedReplayAnchor.WorldInvalidFromTick == nil
        or (Serial.deltaUInt32(a2, _completedReplayAnchor.WorldInvalidFromTick)) < 0 then
        _completedReplayAnchor.WorldInvalidFromTick = a2
    end
    if _completedReplayAnchor.WorldInvalidRevision == nil
        or 0 < (Serial.deltaUInt32(a3, _completedReplayAnchor.WorldInvalidRevision)) then
        _completedReplayAnchor.WorldInvalidRevision = a3
    end
end

function u62.retainReplayPrefixBeforePush(a1, a2) -- Line: 466
    -- upvalues: Serial (val), State (val)
    local _completedReplayAnchor = a1._completedReplayAnchor
    if _completedReplayAnchor ~= nil and a1._pendingReplay == nil then
        local v1 = a1._ring:get((Serial.addUInt32(a2, -(a1._ring:capacity()))))
        if v1 == nil then
            return
        end
        if v1.Command.CommandNumber == Serial.addUInt32(_completedReplayAnchor.CommandNumber, 1)
            and v1.ServerTick == Serial.addUInt32(_completedReplayAnchor.ServerTick, 1) then
            if _completedReplayAnchor.InvalidFromTick ~= nil
                and 0 <= (Serial.deltaUInt32(v1.ServerTick, _completedReplayAnchor.InvalidFromTick)) then
                a1._completedReplayAnchor = nil
                return
            end
            if _completedReplayAnchor.WorldInvalidFromTick ~= nil
                and 0 <= (Serial.deltaUInt32(v1.ServerTick, _completedReplayAnchor.WorldInvalidFromTick)) then
                a1._completedReplayAnchor = nil
                return
            end
            _completedReplayAnchor.State = State.clone(v1.PostState)
            _completedReplayAnchor.Support = State.cloneSupport(v1.PostSupport)
            _completedReplayAnchor.ServerTick = v1.ServerTick
            _completedReplayAnchor.CommandNumber = v1.Command.CommandNumber
            _completedReplayAnchor.TopologyRevision = v1.TopologyRevision
            return
        end
        a1._completedReplayAnchor = nil
        return
    end
end

function u62:retainedReplayAnchor(a2, a3) -- Line: 496 -- upvalues: Serial (val) -- types: self: table, a3: number?
    local _completedReplayAnchor = self._completedReplayAnchor
    if _completedReplayAnchor ~= nil
        and _completedReplayAnchor.Snapshot == a2
        and _completedReplayAnchor.CommandNumber ~= a2.LastProcessedCommand
        and a2.Sequence == self._lastSequence
        and not self._requiresWorldReplay
        and a3 ~= nil
        and 0 < (Serial.deltaUInt32(a3, _completedReplayAnchor.ServerTick)) then
        return _completedReplayAnchor
    end
    return nil
end

function u62.forkForNewerOwner(a1, a2) -- Line: 510 -- upvalues: Serial (val), u62 (val)
    local _pendingReplay = a1._pendingReplay
    if _pendingReplay == nil then
        return nil
    end
    local Snapshot = _pendingReplay.Snapshot
    if a2.Generation == Snapshot.Generation
        and a2.Topology.Epoch == Snapshot.Topology.Epoch
        and a2.Topology.Fingerprint == Snapshot.Topology.Fingerprint
        and Serial.isNewerUInt32(a2.Sequence, Snapshot.Sequence) then
        local v1 = Serial.deltaUInt32(a2.ServerTick, Snapshot.ServerTick)
        if not (v1 < 0) then
            v1 = Serial.deltaUInt32(a2.Topology.DestructibleRevision, Snapshot.Topology.DestructibleRevision)
            if not (v1 < 0) then
                v1 = Serial.deltaUInt32(a2.Topology.MoverRevision, Snapshot.Topology.MoverRevision)
                if not (v1 < 0) then
                    v1 = Serial.deltaUInt32(a2.LastProcessedCommand, _pendingReplay.TailCommandNumber)
                    if not (v1 <= 0) and a1._ring:get(a2.LastProcessedCommand) ~= nil then
                        v1 = table.clone(a1)
                        v1._pendingReplay = nil
                        v1._entryScratch = {}
                        return (setmetatable(v1, u62))
                    end
                end
            end
        end
    end
    return nil
end

function u62.lastAcceptedSequence(a1) -- Line: 535
    return a1._lastSequence
end

function u62.retiredReplayCommandNumber(a1) -- Line: 539
    local _pendingReplay = a1._pendingReplay
    if _pendingReplay ~= nil and 0 < _pendingReplay.RetiredCount then
        return _pendingReplay.AnchorCommandNumber
    end
    return nil
end

local function invalidatePendingReplay(a1, a2, a3) -- Line: 545
    -- upvalues: Serial (val), State (val)
    local _completedReplayAnchor = a1._completedReplayAnchor
    local v1 = if not a3 then a2 else if _completedReplayAnchor == nil then a2 else Serial.addUInt32(_completedReplayAnchor.ServerTick, Serial.deltaUInt32(a2, _completedReplayAnchor.State.MovementTick))
    if _completedReplayAnchor == nil then
        if _completedReplayAnchor ~= nil then
            if _completedReplayAnchor.InvalidFromTick == nil
                or (Serial.deltaUInt32(v1, _completedReplayAnchor.InvalidFromTick)) < 0 then
                _completedReplayAnchor.InvalidFromTick = v1
            end
        end
    elseif (Serial.deltaUInt32(v1, _completedReplayAnchor.ServerTick)) <= 0 then
        a1._completedReplayAnchor = nil
    elseif _completedReplayAnchor ~= nil then
        if _completedReplayAnchor.InvalidFromTick == nil
            or (Serial.deltaUInt32(v1, _completedReplayAnchor.InvalidFromTick)) < 0 then
            _completedReplayAnchor.InvalidFromTick = v1
        end
    end
    local _pendingReplay = a1._pendingReplay
    if _pendingReplay == nil then
        return false
    end
    local MovementTick = if not a3 then _pendingReplay.AnchorServerTick else _pendingReplay.AnchorState.MovementTick
    local MovementTick_2 = if not a3 then _pendingReplay.Snapshot.ServerTick else _pendingReplay.Snapshot.State.MovementTick
    local v2 = Serial.deltaUInt32(a2, MovementTick)
    if v2 <= 0 and 0 < (Serial.deltaUInt32(a2, MovementTick_2)) then
        _pendingReplay.InvalidatedReason = "ReplayEventOutsideRetention"
        return false
    end
    if not (v2 < 1) and not (#_pendingReplay.Staged < v2) then
        local v3 = _pendingReplay.Staged[v2 - 1]
        _pendingReplay.State = State.clone(if v3 ~= nil then v3.State else _pendingReplay.AnchorState)
        _pendingReplay.Support = State.cloneSupport(if v3 ~= nil then v3.Support else _pendingReplay.AnchorSupport)
        local AnchorTopologyRevision = if v3 ~= nil then v3.TopologyRevision else _pendingReplay.AnchorTopologyRevision
        _pendingReplay.TopologyRevision = AnchorTopologyRevision
        local AnchorCommandNumber = if v3 ~= nil then v3.Entry.Command.CommandNumber else _pendingReplay.AnchorCommandNumber
        _pendingReplay.TailCommandNumber = AnchorCommandNumber
        _pendingReplay.TailServerTick = Serial.addUInt32(_pendingReplay.AnchorServerTick, v2 - 1)
        _pendingReplay.NextIndex = v2
        for i = #_pendingReplay.Staged, v2, -1 do
            _pendingReplay.Staged[i] = nil
        end
        return true
    end
    return true
end

function u62.invalidatePendingReplayFromTick(a1, a2) -- Line: 590
    -- upvalues: invalidatePendingReplay (val)
    return (invalidatePendingReplay(a1, a2, false))
end

function u62.invalidatePendingReplayFromMovementTick(a1, a2) -- Line: 594
    -- upvalues: invalidatePendingReplay (val)
    return (invalidatePendingReplay(a1, a2, true))
end

local function retireReplayPrefix(a1, a2, a3) -- Line: 598 -- upvalues: State (val) -- types: a2: table, a3: number
    if a3 <= 0 then
        return true
    end
    if #a2.Staged < a3 then
        return false
    end
    for i = 1, a3 do
        if a1._ring:get(a2.Entries[i].Command.CommandNumber) ~= nil then
            return false
        end
    end
    local v1 = a2.Staged[a3]
    a2.AnchorState = State.clone(v1.State)
    a2.AnchorSupport = State.cloneSupport(v1.Support)
    a2.AnchorServerTick = v1.ServerTick
    a2.AnchorCommandNumber = v1.Entry.Command.CommandNumber
    a2.AnchorTopologyRevision = v1.TopologyRevision
    a2.RetiredCount = a2.RetiredCount + a3
    a2.NextIndex = a2.NextIndex - a3
    local Entries_2 = a2.Entries
    local Staged = a2.Staged
    local v2 = #Entries_2
    local v3 = #Staged
    table.move(Entries_2, a3 + 1, v2, 1)
    table.move(Staged, a3 + 1, v3, 1)
    local v4 = v2 - a3 + 1
    for j = v2, v4, -1 do
        Entries_2[j] = nil
    end
    v4 = v3 - a3 + 1
    for k = v3, v4, -1 do
        Staged[k] = nil
    end
    return true
end

local function appendReplayEntries(a1, a2) -- Line: 632
    -- upvalues: Serial (val), retireReplayPrefix (val), PredictionRing (val)
    local LastProcessedCommand
    local Entries = a2.Entries
    local v1 = a1._ring:entriesAfter(
        if #Entries ~= 0 then Entries[#Entries].Command.CommandNumber else a2.Snapshot.LastProcessedCommand,
        a1._entryScratch
    )
    local v2 = a1._ring:newestCommandNumber()
    if v2 ~= nil then
        local v3 = Serial.deltaUInt32(v2, LastProcessedCommand)
        if #v1 < v3 then
            return false, "PredictionHistoryGap"
        end
    end
    if not retireReplayPrefix(a1, a2, #Entries + #v1 - a1._ring:capacity()) then
        return false, "ReplayHistoryOverflow"
    end
    if #v1 > 0 and v1[1].Command.CommandNumber ~= Serial.addUInt32(LastProcessedCommand, 1) then
        return false, "PredictionHistoryGap"
    end
    for i, j in v1 do
        Entries[#Entries + 1] = (PredictionRing.cloneEntry(j))
    end
    return true, nil
end

local function advancePendingReplay(a1, a2, a3, a4) -- Line: 655
    -- upvalues: appendReplayEntries (val), Serial (val), StateCodec (val), validSupport (val), PredictionRing (val)
    -- upvalues: recordAcceptedSnapshot (val), State (val)
    local Command, Metrics, Snapshot, Staged, State_2, Support, Topology, Topology_2, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
    local _pendingReplay = a1._pendingReplay
    if _pendingReplay == nil then
        return nil, "ReplayNotPending"
    end
    if _pendingReplay.InvalidatedReason ~= nil then
        return nil, _pendingReplay.InvalidatedReason
    end
    local MinimumSteps_2 = (1 / 0)
    local MaximumSeconds_2 = (1 / 0)
    if type(a4) == "number" then
        if a4 == a4 and not (a4 < 1) and a4 ~= (1 / 0) then
            MinimumSteps_2 = math.floor(a4)
            v19, v20 = appendReplayEntries(a1, _pendingReplay)
            if not v19 then
                return nil, v20
            end
            v2 = math.min(#_pendingReplay.Entries, _pendingReplay.NextIndex + MinimumSteps_2 - 1)
            v3 = os.clock()
            v4 = 0
            for i6 = _pendingReplay.NextIndex, v2 do
                v6 = _pendingReplay.Entries[i6]
                v7 = Serial.addUInt32(_pendingReplay.TailServerTick, 1)
                Topology = _pendingReplay.Snapshot.Topology
                v8 = {
                    Epoch = Topology.Epoch,
                    Fingerprint = Topology.Fingerprint,
                    DestructibleRevision = _pendingReplay.TopologyRevision or Topology.DestructibleRevision,
                    MoverRevision = Topology.MoverRevision,
                }
                v9, v10, v11 = v21(v7, v8, _pendingReplay.State, _pendingReplay.Support, v6.Command.CommandNumber)
                if v9 == nil then
                    return nil, v11 or "WorldFrameUnavailable"
                end
                if v10 ~= nil and Serial.isUInt32(v10) then
                    if (Serial.deltaUInt32(v10, _pendingReplay.TopologyRevision)) < 0 then
                        return nil, "WorldFrameRevisionRegressed"
                    end
                    _pendingReplay.TopologyRevision = v10
                    Topology_2 = _pendingReplay.Snapshot.Topology
                    v8 = {
                        Epoch = Topology_2.Epoch,
                        Fingerprint = Topology_2.Fingerprint,
                        DestructibleRevision = _pendingReplay.TopologyRevision or Topology_2.DestructibleRevision,
                        MoverRevision = Topology_2.MoverRevision,
                    }
                    State_2 = _pendingReplay.State
                    Support = _pendingReplay.Support
                    Command = v6.Command
                    v16 = 1 / v1._mapping.SimulationHz
                    v12, v13, v14 = v22(State_2, Support, Command, v16, v7, v8, v9)
                    v15, v16 = StateCodec.validate(v12)
                    if not v15 then
                        return nil, v16 or "InvalidReplayState"
                    end
                    if not validSupport(v13) then
                        return nil, "InvalidReplaySupport"
                    end
                    v17 = v14 or 0
                    if Serial.isUInt32(v17)
                        and bit32.band(v17, (bit32.bnot(PredictionRing.Dependency.ValidMask))) == 0 then
                        _pendingReplay.State = v12
                        _pendingReplay.Support = v13
                        Staged = _pendingReplay.Staged
                        v18 = #_pendingReplay.Staged + 1
                        Staged[v18] = {
                            Entry = v6,
                            ServerTick = v7,
                            State = v12,
                            Support = v13,
                            TopologyRevision = _pendingReplay.TopologyRevision,
                            DependencyMask = v17,
                        }
                        _pendingReplay.TailCommandNumber = v6.Command.CommandNumber
                        _pendingReplay.TailServerTick = v7
                        _pendingReplay.NextIndex = i6 + 1
                        v4 = v4 + 1
                        Metrics = _pendingReplay.Metrics
                        Metrics.ReplayCount = Metrics.ReplayCount + 1
                        if MinimumSteps_2 <= v4 and MaximumSeconds_2 <= os.clock() - v3 then
                            break
                        end
                        continue
                    end
                    return nil, "InvalidReplayDependencyMask"
                end
                return nil, "WorldFrameRevisionUnavailable"
            end
            if _pendingReplay.NextIndex <= #_pendingReplay.Entries then
                return nil, "ReplayPending"
            end
            Snapshot = _pendingReplay.Snapshot
            v5 = v1._ring:dropThrough(Snapshot.LastProcessedCommand)
            for i7, i8 in _pendingReplay.Staged do
                if v1._ring:get(i8.Entry.Command.CommandNumber) ~= nil then
                    v10, v11 = v1._ring:replacePrediction(
                        i8.Entry.Command.CommandNumber,
                        i8.ServerTick,
                        i8.State,
                        i8.Support,
                        i8.TopologyRevision,
                        i8.DependencyMask
                    )
                    assert(v10, v11 or "retained staged prediction disappeared")
                end
            end
            v1._requiresWorldReplay = false
            recordAcceptedSnapshot(v1, Snapshot)
            v1._completedReplayAnchor = {
                Snapshot = Snapshot,
                State = State.clone(_pendingReplay.AnchorState),
                Support = State.cloneSupport(_pendingReplay.AnchorSupport),
                ServerTick = _pendingReplay.AnchorServerTick,
                CommandNumber = _pendingReplay.AnchorCommandNumber,
                TopologyRevision = _pendingReplay.AnchorTopologyRevision,
            }
            v1._pendingReplay = nil
            return {
                LastProcessedCommand = Snapshot.LastProcessedCommand,
                ServerTick = Snapshot.ServerTick,
                TailCommandNumber = _pendingReplay.TailCommandNumber,
                TailServerTick = _pendingReplay.TailServerTick,
                State = State.clone(_pendingReplay.State),
                Support = State.cloneSupport(_pendingReplay.Support),
                ReplayCount = _pendingReplay.Metrics.ReplayCount,
                DroppedCommandCount = v5,
                Metrics = _pendingReplay.Metrics,
            }, nil
        end
        return nil, "InvalidReplayStepBudget"
    end
    if a4 == nil then
        v19, v20 = appendReplayEntries(a1, _pendingReplay)
        if not v19 then
            return nil, v20
        end
        v2 = math.min(#_pendingReplay.Entries, _pendingReplay.NextIndex + (1 / 0) - 1)
        v3 = os.clock()
        v4 = 0
        for n = _pendingReplay.NextIndex, v2 do
            v6 = _pendingReplay.Entries[n]
            v7 = Serial.addUInt32(_pendingReplay.TailServerTick, 1)
            Topology = _pendingReplay.Snapshot.Topology
            v8 = {
                Epoch = Topology.Epoch,
                Fingerprint = Topology.Fingerprint,
                DestructibleRevision = _pendingReplay.TopologyRevision or Topology.DestructibleRevision,
                MoverRevision = Topology.MoverRevision,
            }
            v9, v10, v11 = v21(v7, v8, _pendingReplay.State, _pendingReplay.Support, v6.Command.CommandNumber)
            if v9 == nil then
                return nil, v11 or "WorldFrameUnavailable"
            end
            if v10 ~= nil and Serial.isUInt32(v10) then
                if (Serial.deltaUInt32(v10, _pendingReplay.TopologyRevision)) < 0 then
                    return nil, "WorldFrameRevisionRegressed"
                end
                _pendingReplay.TopologyRevision = v10
                Topology_2 = _pendingReplay.Snapshot.Topology
                v8 = {
                    Epoch = Topology_2.Epoch,
                    Fingerprint = Topology_2.Fingerprint,
                    DestructibleRevision = _pendingReplay.TopologyRevision or Topology_2.DestructibleRevision,
                    MoverRevision = Topology_2.MoverRevision,
                }
                State_2 = _pendingReplay.State
                Support = _pendingReplay.Support
                Command = v6.Command
                v16 = 1 / v1._mapping.SimulationHz
                v12, v13, v14 = v22(State_2, Support, Command, v16, v7, v8, v9)
                v15, v16 = StateCodec.validate(v12)
                if not v15 then
                    return nil, v16 or "InvalidReplayState"
                end
                if not validSupport(v13) then
                    return nil, "InvalidReplaySupport"
                end
                v17 = v14 or 0
                if Serial.isUInt32(v17)
                    and bit32.band(v17, (bit32.bnot(PredictionRing.Dependency.ValidMask))) == 0 then
                    _pendingReplay.State = v12
                    _pendingReplay.Support = v13
                    Staged = _pendingReplay.Staged
                    v18 = #_pendingReplay.Staged + 1
                    Staged[v18] = {
                        Entry = v6,
                        ServerTick = v7,
                        State = v12,
                        Support = v13,
                        TopologyRevision = _pendingReplay.TopologyRevision,
                        DependencyMask = v17,
                    }
                    _pendingReplay.TailCommandNumber = v6.Command.CommandNumber
                    _pendingReplay.TailServerTick = v7
                    _pendingReplay.NextIndex = n + 1
                    v4 = v4 + 1
                    Metrics = _pendingReplay.Metrics
                    Metrics.ReplayCount = Metrics.ReplayCount + 1
                    if MinimumSteps_2 <= v4 and MaximumSeconds_2 <= os.clock() - v3 then
                        break
                    end
                    continue
                end
                return nil, "InvalidReplayDependencyMask"
            end
            return nil, "WorldFrameRevisionUnavailable"
        end
        if _pendingReplay.NextIndex <= #_pendingReplay.Entries then
            return nil, "ReplayPending"
        end
        Snapshot = _pendingReplay.Snapshot
        v5 = v1._ring:dropThrough(Snapshot.LastProcessedCommand)
        for m, i5 in _pendingReplay.Staged do
            if v1._ring:get(i5.Entry.Command.CommandNumber) ~= nil then
                v10, v11 = v1._ring:replacePrediction(
                    i5.Entry.Command.CommandNumber,
                    i5.ServerTick,
                    i5.State,
                    i5.Support,
                    i5.TopologyRevision,
                    i5.DependencyMask
                )
                assert(v10, v11 or "retained staged prediction disappeared")
            end
        end
        v1._requiresWorldReplay = false
        recordAcceptedSnapshot(v1, Snapshot)
        v1._completedReplayAnchor = {
            Snapshot = Snapshot,
            State = State.clone(_pendingReplay.AnchorState),
            Support = State.cloneSupport(_pendingReplay.AnchorSupport),
            ServerTick = _pendingReplay.AnchorServerTick,
            CommandNumber = _pendingReplay.AnchorCommandNumber,
            TopologyRevision = _pendingReplay.AnchorTopologyRevision,
        }
        v1._pendingReplay = nil
        return {
            LastProcessedCommand = Snapshot.LastProcessedCommand,
            ServerTick = Snapshot.ServerTick,
            TailCommandNumber = _pendingReplay.TailCommandNumber,
            TailServerTick = _pendingReplay.TailServerTick,
            State = State.clone(_pendingReplay.State),
            Support = State.cloneSupport(_pendingReplay.Support),
            ReplayCount = _pendingReplay.Metrics.ReplayCount,
            DroppedCommandCount = v5,
            Metrics = _pendingReplay.Metrics,
        }, nil
    end
    if type(a4.MinimumSteps) == "number"
        and a4.MinimumSteps == a4.MinimumSteps
        and a4.MinimumSteps % 1 == 0
        and not (a4.MinimumSteps < 1)
        and a4.MinimumSteps ~= (1 / 0)
        and type(a4.MaximumSteps) == "number"
        and a4.MaximumSteps == a4.MaximumSteps
        and a4.MaximumSteps % 1 == 0
        and not (a4.MaximumSteps < a4.MinimumSteps)
        and a4.MaximumSteps ~= (1 / 0)
        and type(a4.MaximumSeconds) == "number"
        and a4.MaximumSeconds == a4.MaximumSeconds
        and not (a4.MaximumSeconds < 0)
        and a4.MaximumSeconds ~= (1 / 0) then
        MinimumSteps_2 = a4.MinimumSteps
        local MaximumSteps_2 = a4.MaximumSteps
        MaximumSeconds_2 = a4.MaximumSeconds
        v19, v20 = appendReplayEntries(a1, _pendingReplay)
        if not v19 then
            return nil, v20
        end
        v2 = math.min(#_pendingReplay.Entries, _pendingReplay.NextIndex + MaximumSteps_2 - 1)
        v3 = os.clock()
        v4 = 0
        for i = _pendingReplay.NextIndex, v2 do
            v6 = _pendingReplay.Entries[i]
            v7 = Serial.addUInt32(_pendingReplay.TailServerTick, 1)
            Topology = _pendingReplay.Snapshot.Topology
            v8 = {
                Epoch = Topology.Epoch,
                Fingerprint = Topology.Fingerprint,
                DestructibleRevision = _pendingReplay.TopologyRevision or Topology.DestructibleRevision,
                MoverRevision = Topology.MoverRevision,
            }
            v9, v10, v11 = v21(v7, v8, _pendingReplay.State, _pendingReplay.Support, v6.Command.CommandNumber)
            if v9 == nil then
                return nil, v11 or "WorldFrameUnavailable"
            end
            if v10 ~= nil and Serial.isUInt32(v10) then
                if (Serial.deltaUInt32(v10, _pendingReplay.TopologyRevision)) < 0 then
                    return nil, "WorldFrameRevisionRegressed"
                end
                _pendingReplay.TopologyRevision = v10
                Topology_2 = _pendingReplay.Snapshot.Topology
                v8 = {
                    Epoch = Topology_2.Epoch,
                    Fingerprint = Topology_2.Fingerprint,
                    DestructibleRevision = _pendingReplay.TopologyRevision or Topology_2.DestructibleRevision,
                    MoverRevision = Topology_2.MoverRevision,
                }
                State_2 = _pendingReplay.State
                Support = _pendingReplay.Support
                Command = v6.Command
                v16 = 1 / v1._mapping.SimulationHz
                v12, v13, v14 = v22(State_2, Support, Command, v16, v7, v8, v9)
                v15, v16 = StateCodec.validate(v12)
                if not v15 then
                    return nil, v16 or "InvalidReplayState"
                end
                if not validSupport(v13) then
                    return nil, "InvalidReplaySupport"
                end
                v17 = v14 or 0
                if Serial.isUInt32(v17)
                    and bit32.band(v17, (bit32.bnot(PredictionRing.Dependency.ValidMask))) == 0 then
                    _pendingReplay.State = v12
                    _pendingReplay.Support = v13
                    Staged = _pendingReplay.Staged
                    v18 = #_pendingReplay.Staged + 1
                    Staged[v18] = {
                        Entry = v6,
                        ServerTick = v7,
                        State = v12,
                        Support = v13,
                        TopologyRevision = _pendingReplay.TopologyRevision,
                        DependencyMask = v17,
                    }
                    _pendingReplay.TailCommandNumber = v6.Command.CommandNumber
                    _pendingReplay.TailServerTick = v7
                    _pendingReplay.NextIndex = i + 1
                    v4 = v4 + 1
                    Metrics = _pendingReplay.Metrics
                    Metrics.ReplayCount = Metrics.ReplayCount + 1
                    if MinimumSteps_2 <= v4 and MaximumSeconds_2 <= os.clock() - v3 then
                        break
                    end
                    continue
                end
                return nil, "InvalidReplayDependencyMask"
            end
            return nil, "WorldFrameRevisionUnavailable"
        end
        if _pendingReplay.NextIndex <= #_pendingReplay.Entries then
            return nil, "ReplayPending"
        end
        Snapshot = _pendingReplay.Snapshot
        v5 = v1._ring:dropThrough(Snapshot.LastProcessedCommand)
        for j, k in _pendingReplay.Staged do
            if v1._ring:get(k.Entry.Command.CommandNumber) ~= nil then
                v10, v11 = v1._ring:replacePrediction(
                    k.Entry.Command.CommandNumber,
                    k.ServerTick,
                    k.State,
                    k.Support,
                    k.TopologyRevision,
                    k.DependencyMask
                )
                assert(v10, v11 or "retained staged prediction disappeared")
            end
        end
        v1._requiresWorldReplay = false
        recordAcceptedSnapshot(v1, Snapshot)
        v1._completedReplayAnchor = {
            Snapshot = Snapshot,
            State = State.clone(_pendingReplay.AnchorState),
            Support = State.cloneSupport(_pendingReplay.AnchorSupport),
            ServerTick = _pendingReplay.AnchorServerTick,
            CommandNumber = _pendingReplay.AnchorCommandNumber,
            TopologyRevision = _pendingReplay.AnchorTopologyRevision,
        }
        v1._pendingReplay = nil
        return {
            LastProcessedCommand = Snapshot.LastProcessedCommand,
            ServerTick = Snapshot.ServerTick,
            TailCommandNumber = _pendingReplay.TailCommandNumber,
            TailServerTick = _pendingReplay.TailServerTick,
            State = State.clone(_pendingReplay.State),
            Support = State.cloneSupport(_pendingReplay.Support),
            ReplayCount = _pendingReplay.Metrics.ReplayCount,
            DroppedCommandCount = v5,
            Metrics = _pendingReplay.Metrics,
        }, nil
    end
    return nil, "InvalidReplayBudget"
end

function u62.resume(a1, a2, a3, a4) -- Line: 816
    -- upvalues: advancePendingReplay (val)
    return advancePendingReplay(a1, a2, a3, a4)
end

function u62.accept(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 824
    -- upvalues: Serial (val), canonicalStateMismatch (val), PredictionRing (val), zeroMetrics (val), State (val)
    -- upvalues: tailResult (val), measure (val), u61 (val), recordAcceptedSnapshot (val), advancePendingReplay (val)
    local v1 = a8 or a1._requiresWorldReplay
    if a1._pendingReplay ~= nil then
        return nil, "ReplayAlreadyPending"
    end
    if a2.Generation ~= a1._mapping.Generation then
        return nil, "GenerationMismatch"
    end
    if a2.Topology.Epoch == a1._mapping.TopologyEpoch
        and a2.Topology.Fingerprint == a1._mapping.TopologyFingerprint then
        local CanonicalSupportMismatch, CommandNumber, DestructibleRevision_2, LastProcessedCommand_6, MoverRevision, PostState, PostSupport, ServerTick_2, ServerTick_4, Staged, TickRealigned, _completedReplayAnchor, _pendingReplay, _validatedMoverRevision, _validatedMoverRevision_2, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37
        if a5 then
            if a1._lastSequence ~= nil
                and a2.Sequence == a1._lastSequence
                and a2.ServerTick == a1._lastServerTick
                and a2.LastProcessedCommand == a1._lastProcessedCommand
                and a2.Topology.DestructibleRevision == a1._lastTopologyRevision
                and a2.Topology.MoverRevision == a1._lastMoverRevision then
                v32, v2, v3, v37, v36, v34, v14, v23, v35 = a5, a1, a2, a10, a9, a6, a3, a4, a7
                if not v32
                    and not v1
                    and v2._lastProcessedCommand ~= nil
                    and v2._lastServerTick ~= nil
                    and v3.LastProcessedCommand == v2._lastProcessedCommand
                    and v2._ring:get(v3.LastProcessedCommand) == nil
                    and v2._lastSnapshotState ~= nil
                    and v2._lastSnapshotSupport ~= nil
                    and select(1, canonicalStateMismatch(v2._lastSnapshotState, v3.State)) == 0
                    and v2._lastSnapshotSupport.Kind == v3.Support.Kind
                    and v2._lastSnapshotSupport.SourceId == v3.Support.SourceId
                    and v2._lastSnapshotSupport.Anchor == v3.Support.Anchor
                    and v2._lastSnapshotSupport.Velocity == v3.Support.Velocity
                    and v3.Topology.DestructibleRevision == v2._lastTopologyRevision then
                    if v3.Topology.MoverRevision ~= v2._lastMoverRevision then
                        if v2._validatedMoverRevision ~= nil then
                            v4 = Serial.deltaUInt32(v3.Topology.MoverRevision, v2._validatedMoverRevision)
                            if v4 <= 0 then
                                v4 = Serial.deltaUInt32(v3.ServerTick, v2._lastServerTick)
                                v5 = v2._ring:entriesAfter(v3.LastProcessedCommand, v2._entryScratch)
                                v6 = v5[#v5]
                                v7 = true
                                v8 = v5
                                v9 = nil
                                for i28, i29 in v8, v9 do
                                    if bit32.band(i29.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 then
                                        v7 = false
                                        break
                                    end
                                    if v4 ~= 0
                                        and v37 ~= nil
                                        and not v37(i29.PostState, i29.Command, Serial.addUInt32(i29.ServerTick, v4)) then
                                        v7 = false
                                        break
                                    end
                                end
                                if v7 and v4 >= 0 and v4 <= v2._ring:capacity() then
                                    if v4 > 0 then
                                        v8, v9 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v4)
                                        if not v8 then
                                            return nil, v9
                                        end
                                    end
                                    v8 = zeroMetrics()
                                    v8.ReplayBarrier = "AcknowledgementHeld"
                                    v8.TickRealigned = v4 > 0
                                    v8.ServerHeldTickCount = v4
                                    v2._lastSequence = v3.Sequence
                                    v2._completedReplayAnchor = {
                                        Snapshot = v3,
                                        State = State.clone(v3.State),
                                        Support = State.cloneSupport(v3.Support),
                                        ServerTick = v3.ServerTick,
                                        CommandNumber = v3.LastProcessedCommand,
                                        TopologyRevision = v3.Topology.DestructibleRevision,
                                    }
                                    v2._lastServerTick = v3.ServerTick
                                    MoverRevision = v3.Topology.MoverRevision
                                    _validatedMoverRevision = v2._validatedMoverRevision
                                    if _validatedMoverRevision == nil
                                        or 0 < (Serial.deltaUInt32(MoverRevision, _validatedMoverRevision)) then
                                        v2._validatedMoverRevision = MoverRevision
                                    end
                                    v2._lastMoverRevision = v3.Topology.MoverRevision
                                    return (tailResult(v3, v6, 0, v8)), nil
                                end
                            end
                        end
                        v4 = v2._ring:get(v3.LastProcessedCommand)
                        v5 = measure(v3, v4)
                        v6 = if not v32 then nil else v2:retainedReplayAnchor(v3, v36)
                        LastProcessedCommand_6 = if v6 ~= nil then v6.CommandNumber else v3.LastProcessedCommand
                        ServerTick_2 = if v6 ~= nil then v6.ServerTick else v3.ServerTick
                        DestructibleRevision_2 = if v6 ~= nil then v6.TopologyRevision else v3.Topology.DestructibleRevision
                        v10 = v2._ring:entriesAfter(LastProcessedCommand_6, v2._entryScratch)
                        if #v10 > 0
                            and v10[1].Command.CommandNumber ~= Serial.addUInt32(LastProcessedCommand_6, 1) then
                            return nil, "PredictionHistoryGap"
                        end
                        v11 = if not (#v10 > 0) then nil else v10[#v10]
                        v12 = bit32.band(v5.CanonicalStateMismatchMask, (bit32.bnot(u61)))
                        v13 = false
                        if 0 < v5.CanonicalStateMismatchCount then
                            v13 = false
                            if v12 == 0 then
                                v13 = false
                                if v5.Position <= 0.0001 then
                                    v13 = v5.Velocity <= 0.0001
                                end
                            end
                        end
                        v15 = false
                        if v34 == true then
                            v15 = true
                            if v5.CanonicalStateMismatchCount ~= 0 then
                                v15 = false
                                if v12 == 0 then
                                    v15 = false
                                    if v5.Position <= 0.0625 then
                                        v15 = v5.Velocity <= 2
                                    end
                                end
                            end
                        end
                        v16 = false
                        if v34 == true then
                            v16 = false
                            if v5.SupportKindMismatch == 0 then
                                v16 = false
                                if v5.SupportSourceMismatch == 0 then
                                    v16 = false
                                    if v5.SupportAnchor <= 0.0625 then
                                        v16 = v5.SupportVelocity <= 2
                                    end
                                end
                            end
                        end
                        v17 = false
                        if v34 == true then
                            v17 = false
                            if v11 ~= nil then
                                v17 = false
                                if 0 < v5.CanonicalStateMismatchCount then
                                    v17 = false
                                    if v12 == 0 then
                                        v17 = false
                                        if (v11.PostState.Position - v3.State.Position).Magnitude <= 0.0625 then
                                            v17 = (v11.PostState.Velocity - v3.State.Velocity).Magnitude <= 2
                                        end
                                    end
                                end
                            end
                        end
                        if not v15 or not v16 then
                            CanonicalSupportMismatch = v17 and v16
                        else
                            CanonicalSupportMismatch = true
                            if not (0 < v5.CanonicalStateMismatchCount) then
                                CanonicalSupportMismatch = v5.CanonicalSupportMismatch or v17 and v16
                            end
                        end
                        _validatedMoverRevision_2 = v2._validatedMoverRevision
                        v18 = false
                        if _validatedMoverRevision_2 ~= nil then
                            v18 = (Serial.deltaUInt32(v3.Topology.MoverRevision, _validatedMoverRevision_2)) <= 0
                        end
                        v19 = if v4 ~= nil then Serial.deltaUInt32(v3.ServerTick, v4.ServerTick) else 0
                        v20 = true
                        for i30, i31 in v10 do
                            if bit32.band(i31.DependencyMask, PredictionRing.Dependency.Mover) == 0
                                and i31.TopologyRevision == v3.Topology.DestructibleRevision then
                                if v19 ~= 0
                                    and v37 ~= nil
                                    and not v37(i31.PostState, i31.Command, Serial.addUInt32(i31.ServerTick, v19)) then
                                    v20 = false
                                    break
                                end
                                continue
                            end
                            v20 = false
                            break
                        end
                        v21 = not v32
                        if v21 then
                            v21 = not v1
                            if v21 then
                                v21 = false
                                if v4 ~= nil then
                                    v21 = false
                                    if v4.ServerTick ~= v3.ServerTick then
                                        v21 = false
                                        if (math.abs(v19)) <= v2._ring:capacity() then
                                            v21 = false
                                            if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                                                v21 = false
                                                if v5.CanonicalStateMismatchCount == 0 then
                                                    v21 = not v5.CanonicalSupportMismatch
                                                    if v21 then
                                                        v21 = false
                                                        if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then
                                                            v21 = if v2._lastMoverRevision == v3.Topology.MoverRevision then v20 else v18 and v20
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        v5.ReplayBarrier = if not v32 then if not v1 then if v4 ~= nil then if v4.ServerTick == v3.ServerTick then if v4.TopologyRevision == v3.Topology.DestructibleRevision then if v5.CanonicalStateMismatchCount == 0 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if v13 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if CanonicalSupportMismatch then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else "StateMismatch" else "PredictionTopology" else if not v21 then "PredictionTick" else "TickRealignFastPath" else "PredictionMissing" else "WorldChange" else "AcceptedWorldChange"
                        v5.TickRealigned = v22 == "TickRealignFastPath"
                        TickRealigned = true
                        if v22 ~= "None" then
                            TickRealigned = v5.TickRealigned
                        end
                        if TickRealigned then
                            if v5.TickRealigned then
                                v24, v25 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v19)
                                if not v24 then
                                    return nil, v25
                                end
                            end
                            v24 = v2._ring:dropThrough(v3.LastProcessedCommand)
                            v2._completedReplayAnchor = {
                                Snapshot = v3,
                                State = State.clone(v3.State),
                                Support = State.cloneSupport(v3.Support),
                                ServerTick = v3.ServerTick,
                                CommandNumber = v3.LastProcessedCommand,
                                TopologyRevision = v3.Topology.DestructibleRevision,
                            }
                            recordAcceptedSnapshot(v2, v3)
                            return (tailResult(v3, v11, v24, v5)), nil
                        end
                        v24 = false
                        if v4 ~= nil then
                            v24 = false
                            if v4.ServerTick == v3.ServerTick then
                                v24 = false
                                if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                                    v24 = if v13 then not v5.CanonicalSupportMismatch else CanonicalSupportMismatch and not v5.CanonicalSupportMismatch
                                end
                            end
                        end
                        v25 = State.clone(if v6 == nil then if not v24 then v3.State else v4.PostState else v6.State)
                        v26 = State.cloneSupport(if v6 == nil then if not v24 then v3.Support else v4.PostSupport else v6.Support)
                        v27 = table.create(#v10)
                        for i32, i33 in v10 do
                            v27[#v27 + 1] = (PredictionRing.cloneEntry(i33))
                        end
                        v2._pendingReplay = {
                            RetiredCount = 0,
                            NextIndex = 1,
                            Snapshot = v3,
                            AnchorState = v25,
                            AnchorSupport = v26,
                            AnchorServerTick = ServerTick_2,
                            AnchorCommandNumber = LastProcessedCommand_6,
                            AnchorTopologyRevision = DestructibleRevision_2,
                            Metrics = v5,
                            Entries = v27,
                            Staged = table.create(#v10),
                            State = v25,
                            Support = v26,
                            TopologyRevision = DestructibleRevision_2,
                            TailCommandNumber = LastProcessedCommand_6,
                            TailServerTick = ServerTick_2,
                        }
                        _completedReplayAnchor = v2._completedReplayAnchor
                        if v32
                            and v36 ~= nil
                            and _completedReplayAnchor ~= nil
                            and _completedReplayAnchor.Snapshot == v3
                            and not v2._requiresWorldReplay then
                            _pendingReplay = v2._pendingReplay
                            v30 = nil
                            v31 = nil
                            for i34, i35 in v27, v30, v31 do
                                if i35.ServerTick ~= Serial.addUInt32(_pendingReplay.TailServerTick, 1)
                                    or i35.Command.CommandNumber ~= Serial.addUInt32(_pendingReplay.TailCommandNumber, 1)
                                    or 0 <= (Serial.deltaUInt32(i35.ServerTick, v36)) then
                                    break
                                end
                                if _completedReplayAnchor.InvalidFromTick ~= nil
                                    and 0 <= (Serial.deltaUInt32(i35.ServerTick, _completedReplayAnchor.InvalidFromTick)) then
                                    break
                                end
                                if _completedReplayAnchor.WorldInvalidFromTick ~= nil
                                    and 0 <= (Serial.deltaUInt32(i35.ServerTick, _completedReplayAnchor.WorldInvalidFromTick)) then
                                    break
                                end
                                Staged = _pendingReplay.Staged
                                v33 = {
                                    Entry = i35,
                                    ServerTick = i35.ServerTick,
                                    State = i35.PostState,
                                    Support = i35.PostSupport,
                                    TopologyRevision = i35.TopologyRevision,
                                    DependencyMask = i35.DependencyMask,
                                }
                                Staged[i34] = v33
                                PostState = i35.PostState
                                PostSupport = i35.PostSupport
                                _pendingReplay.State = PostState
                                _pendingReplay.Support = PostSupport
                                _pendingReplay.TopologyRevision = i35.TopologyRevision
                                ServerTick_4 = i35.ServerTick
                                CommandNumber = i35.Command.CommandNumber
                                _pendingReplay.TailServerTick = ServerTick_4
                                _pendingReplay.TailCommandNumber = CommandNumber
                                _pendingReplay.NextIndex = i34 + 1
                            end
                        end
                        v28, v29 = advancePendingReplay(v2, v14, v23, v35)
                        if v28 == nil and v29 ~= "ReplayPending" then
                            v2._pendingReplay = nil
                        end
                        return v28, v29
                    end
                    v4 = Serial.deltaUInt32(v3.ServerTick, v2._lastServerTick)
                    v5 = v2._ring:entriesAfter(v3.LastProcessedCommand, v2._entryScratch)
                    v6 = v5[#v5]
                    v7 = true
                    v8 = v5
                    v9 = nil
                    for i36, i37 in v8, v9 do
                        if bit32.band(i37.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 then
                            v7 = false
                            break
                        end
                        if v4 ~= 0
                            and v37 ~= nil
                            and not v37(i37.PostState, i37.Command, Serial.addUInt32(i37.ServerTick, v4)) then
                            v7 = false
                            break
                        end
                    end
                    if v7 and v4 >= 0 and v4 <= v2._ring:capacity() then
                        if v4 > 0 then
                            v8, v9 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v4)
                            if not v8 then
                                return nil, v9
                            end
                        end
                        v8 = zeroMetrics()
                        v8.ReplayBarrier = "AcknowledgementHeld"
                        v8.TickRealigned = v4 > 0
                        v8.ServerHeldTickCount = v4
                        v2._lastSequence = v3.Sequence
                        v2._completedReplayAnchor = {
                            Snapshot = v3,
                            State = State.clone(v3.State),
                            Support = State.cloneSupport(v3.Support),
                            ServerTick = v3.ServerTick,
                            CommandNumber = v3.LastProcessedCommand,
                            TopologyRevision = v3.Topology.DestructibleRevision,
                        }
                        v2._lastServerTick = v3.ServerTick
                        MoverRevision = v3.Topology.MoverRevision
                        _validatedMoverRevision = v2._validatedMoverRevision
                        if _validatedMoverRevision == nil
                            or 0 < (Serial.deltaUInt32(MoverRevision, _validatedMoverRevision)) then
                            v2._validatedMoverRevision = MoverRevision
                        end
                        v2._lastMoverRevision = v3.Topology.MoverRevision
                        return (tailResult(v3, v6, 0, v8)), nil
                    end
                end
                v4 = v2._ring:get(v3.LastProcessedCommand)
                v5 = measure(v3, v4)
                v6 = if not v32 then nil else v2:retainedReplayAnchor(v3, v36)
                LastProcessedCommand_6 = if v6 ~= nil then v6.CommandNumber else v3.LastProcessedCommand
                ServerTick_2 = if v6 ~= nil then v6.ServerTick else v3.ServerTick
                DestructibleRevision_2 = if v6 ~= nil then v6.TopologyRevision else v3.Topology.DestructibleRevision
                v10 = v2._ring:entriesAfter(LastProcessedCommand_6, v2._entryScratch)
                if #v10 > 0 and v10[1].Command.CommandNumber ~= Serial.addUInt32(LastProcessedCommand_6, 1) then
                    return nil, "PredictionHistoryGap"
                end
                v11 = if not (#v10 > 0) then nil else v10[#v10]
                v12 = bit32.band(v5.CanonicalStateMismatchMask, (bit32.bnot(u61)))
                v13 = false
                if 0 < v5.CanonicalStateMismatchCount then
                    v13 = false
                    if v12 == 0 then
                        v13 = false
                        if v5.Position <= 0.0001 then
                            v13 = v5.Velocity <= 0.0001
                        end
                    end
                end
                v15 = false
                if v34 == true then
                    v15 = true
                    if v5.CanonicalStateMismatchCount ~= 0 then
                        v15 = false
                        if v12 == 0 then
                            v15 = false
                            if v5.Position <= 0.0625 then
                                v15 = v5.Velocity <= 2
                            end
                        end
                    end
                end
                v16 = false
                if v34 == true then
                    v16 = false
                    if v5.SupportKindMismatch == 0 then
                        v16 = false
                        if v5.SupportSourceMismatch == 0 then
                            v16 = false
                            if v5.SupportAnchor <= 0.0625 then
                                v16 = v5.SupportVelocity <= 2
                            end
                        end
                    end
                end
                v17 = false
                if v34 == true then
                    v17 = false
                    if v11 ~= nil then
                        v17 = false
                        if 0 < v5.CanonicalStateMismatchCount then
                            v17 = false
                            if v12 == 0 then
                                v17 = false
                                if (v11.PostState.Position - v3.State.Position).Magnitude <= 0.0625 then
                                    v17 = (v11.PostState.Velocity - v3.State.Velocity).Magnitude <= 2
                                end
                            end
                        end
                    end
                end
                if not v15 or not v16 then
                    CanonicalSupportMismatch = v17 and v16
                else
                    CanonicalSupportMismatch = true
                    if not (0 < v5.CanonicalStateMismatchCount) then
                        CanonicalSupportMismatch = v5.CanonicalSupportMismatch or v17 and v16
                    end
                end
                _validatedMoverRevision_2 = v2._validatedMoverRevision
                v18 = false
                if _validatedMoverRevision_2 ~= nil then
                    v18 = (Serial.deltaUInt32(v3.Topology.MoverRevision, _validatedMoverRevision_2)) <= 0
                end
                v19 = if v4 ~= nil then Serial.deltaUInt32(v3.ServerTick, v4.ServerTick) else 0
                v20 = true
                for i38, i39 in v10 do
                    if bit32.band(i39.DependencyMask, PredictionRing.Dependency.Mover) == 0
                        and i39.TopologyRevision == v3.Topology.DestructibleRevision then
                        if v19 ~= 0
                            and v37 ~= nil
                            and not v37(i39.PostState, i39.Command, Serial.addUInt32(i39.ServerTick, v19)) then
                            v20 = false
                            break
                        end
                        continue
                    end
                    v20 = false
                    break
                end
                v21 = not v32
                if v21 then
                    v21 = not v1
                    if v21 then
                        v21 = false
                        if v4 ~= nil then
                            v21 = false
                            if v4.ServerTick ~= v3.ServerTick then
                                v21 = false
                                if (math.abs(v19)) <= v2._ring:capacity() then
                                    v21 = false
                                    if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                                        v21 = false
                                        if v5.CanonicalStateMismatchCount == 0 then
                                            v21 = not v5.CanonicalSupportMismatch
                                            if v21 then
                                                v21 = false
                                                if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then
                                                    v21 = if v2._lastMoverRevision == v3.Topology.MoverRevision then v20 else v18 and v20
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                v5.ReplayBarrier = if not v32 then if not v1 then if v4 ~= nil then if v4.ServerTick == v3.ServerTick then if v4.TopologyRevision == v3.Topology.DestructibleRevision then if v5.CanonicalStateMismatchCount == 0 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if v13 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if CanonicalSupportMismatch then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else "StateMismatch" else "PredictionTopology" else if not v21 then "PredictionTick" else "TickRealignFastPath" else "PredictionMissing" else "WorldChange" else "AcceptedWorldChange"
                v5.TickRealigned = v22 == "TickRealignFastPath"
                TickRealigned = true
                if v22 ~= "None" then
                    TickRealigned = v5.TickRealigned
                end
                if TickRealigned then
                    if v5.TickRealigned then
                        v24, v25 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v19)
                        if not v24 then
                            return nil, v25
                        end
                    end
                    v24 = v2._ring:dropThrough(v3.LastProcessedCommand)
                    v2._completedReplayAnchor = {
                        Snapshot = v3,
                        State = State.clone(v3.State),
                        Support = State.cloneSupport(v3.Support),
                        ServerTick = v3.ServerTick,
                        CommandNumber = v3.LastProcessedCommand,
                        TopologyRevision = v3.Topology.DestructibleRevision,
                    }
                    recordAcceptedSnapshot(v2, v3)
                    return (tailResult(v3, v11, v24, v5)), nil
                end
                v24 = false
                if v4 ~= nil then
                    v24 = false
                    if v4.ServerTick == v3.ServerTick then
                        v24 = false
                        if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                            v24 = if v13 then not v5.CanonicalSupportMismatch else CanonicalSupportMismatch and not v5.CanonicalSupportMismatch
                        end
                    end
                end
                v25 = State.clone(if v6 == nil then if not v24 then v3.State else v4.PostState else v6.State)
                v26 = State.cloneSupport(if v6 == nil then if not v24 then v3.Support else v4.PostSupport else v6.Support)
                v27 = table.create(#v10)
                for i40, i41 in v10 do
                    v27[#v27 + 1] = (PredictionRing.cloneEntry(i41))
                end
                v2._pendingReplay = {
                    RetiredCount = 0,
                    NextIndex = 1,
                    Snapshot = v3,
                    AnchorState = v25,
                    AnchorSupport = v26,
                    AnchorServerTick = ServerTick_2,
                    AnchorCommandNumber = LastProcessedCommand_6,
                    AnchorTopologyRevision = DestructibleRevision_2,
                    Metrics = v5,
                    Entries = v27,
                    Staged = table.create(#v10),
                    State = v25,
                    Support = v26,
                    TopologyRevision = DestructibleRevision_2,
                    TailCommandNumber = LastProcessedCommand_6,
                    TailServerTick = ServerTick_2,
                }
                _completedReplayAnchor = v2._completedReplayAnchor
                if v32
                    and v36 ~= nil
                    and _completedReplayAnchor ~= nil
                    and _completedReplayAnchor.Snapshot == v3
                    and not v2._requiresWorldReplay then
                    _pendingReplay = v2._pendingReplay
                    v30 = nil
                    v31 = nil
                    for i42, i43 in v27, v30, v31 do
                        if i43.ServerTick ~= Serial.addUInt32(_pendingReplay.TailServerTick, 1)
                            or i43.Command.CommandNumber ~= Serial.addUInt32(_pendingReplay.TailCommandNumber, 1)
                            or 0 <= (Serial.deltaUInt32(i43.ServerTick, v36)) then
                            break
                        end
                        if _completedReplayAnchor.InvalidFromTick ~= nil
                            and 0 <= (Serial.deltaUInt32(i43.ServerTick, _completedReplayAnchor.InvalidFromTick)) then
                            break
                        end
                        if _completedReplayAnchor.WorldInvalidFromTick ~= nil
                            and 0 <= (Serial.deltaUInt32(i43.ServerTick, _completedReplayAnchor.WorldInvalidFromTick)) then
                            break
                        end
                        Staged = _pendingReplay.Staged
                        v33 = {
                            Entry = i43,
                            ServerTick = i43.ServerTick,
                            State = i43.PostState,
                            Support = i43.PostSupport,
                            TopologyRevision = i43.TopologyRevision,
                            DependencyMask = i43.DependencyMask,
                        }
                        Staged[i42] = v33
                        PostState = i43.PostState
                        PostSupport = i43.PostSupport
                        _pendingReplay.State = PostState
                        _pendingReplay.Support = PostSupport
                        _pendingReplay.TopologyRevision = i43.TopologyRevision
                        ServerTick_4 = i43.ServerTick
                        CommandNumber = i43.Command.CommandNumber
                        _pendingReplay.TailServerTick = ServerTick_4
                        _pendingReplay.TailCommandNumber = CommandNumber
                        _pendingReplay.NextIndex = i42 + 1
                    end
                end
                v28, v29 = advancePendingReplay(v2, v14, v23, v35)
                if v28 == nil and v29 ~= "ReplayPending" then
                    v2._pendingReplay = nil
                end
                return v28, v29
            end
            return nil, "AcceptedSnapshotIdentityMismatch"
        end
        if a1._lastSequence ~= nil and not Serial.isNewerUInt32(a2.Sequence, a1._lastSequence) then
            return nil, "SnapshotNotNewer"
        end
        if a1._lastServerTick ~= nil and (Serial.deltaUInt32(a2.ServerTick, a1._lastServerTick)) < 0 then
            return nil, "ServerTickRegressed"
        end
        if a1._lastProcessedCommand ~= nil
            and (Serial.deltaUInt32(a2.LastProcessedCommand, a1._lastProcessedCommand)) < 0 then
            return nil, "AcknowledgementRegressed"
        end
        if a1._lastTopologyRevision ~= nil
            and (Serial.deltaUInt32(a2.Topology.DestructibleRevision, a1._lastTopologyRevision)) < 0 then
            return nil, "TopologyRevisionRegressed"
        end
        if a1._lastMoverRevision ~= nil then
            if (Serial.deltaUInt32(a2.Topology.MoverRevision, a1._lastMoverRevision)) < 0 then
                return nil, "MoverRevisionRegressed"
            end
        end
        v32, v2, v3, v37, v36, v34, v14, v23, v35 = a5, a1, a2, a10, a9, a6, a3, a4, a7
        if not v32
            and not v1
            and v2._lastProcessedCommand ~= nil
            and v2._lastServerTick ~= nil
            and v3.LastProcessedCommand == v2._lastProcessedCommand
            and v2._ring:get(v3.LastProcessedCommand) == nil
            and v2._lastSnapshotState ~= nil
            and v2._lastSnapshotSupport ~= nil
            and select(1, canonicalStateMismatch(v2._lastSnapshotState, v3.State)) == 0
            and v2._lastSnapshotSupport.Kind == v3.Support.Kind
            and v2._lastSnapshotSupport.SourceId == v3.Support.SourceId
            and v2._lastSnapshotSupport.Anchor == v3.Support.Anchor
            and v2._lastSnapshotSupport.Velocity == v3.Support.Velocity
            and v3.Topology.DestructibleRevision == v2._lastTopologyRevision then
            if v3.Topology.MoverRevision ~= v2._lastMoverRevision then
                if v2._validatedMoverRevision ~= nil then
                    v4 = Serial.deltaUInt32(v3.Topology.MoverRevision, v2._validatedMoverRevision)
                    if v4 <= 0 then
                        v4 = Serial.deltaUInt32(v3.ServerTick, v2._lastServerTick)
                        v5 = v2._ring:entriesAfter(v3.LastProcessedCommand, v2._entryScratch)
                        v6 = v5[#v5]
                        v7 = true
                        v8 = v5
                        v9 = nil
                        for i12, i13 in v8, v9 do
                            if bit32.band(i13.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 then
                                v7 = false
                                break
                            end
                            if v4 ~= 0
                                and v37 ~= nil
                                and not v37(i13.PostState, i13.Command, Serial.addUInt32(i13.ServerTick, v4)) then
                                v7 = false
                                break
                            end
                        end
                        if v7 and v4 >= 0 and v4 <= v2._ring:capacity() then
                            if v4 > 0 then
                                v8, v9 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v4)
                                if not v8 then
                                    return nil, v9
                                end
                            end
                            v8 = zeroMetrics()
                            v8.ReplayBarrier = "AcknowledgementHeld"
                            v8.TickRealigned = v4 > 0
                            v8.ServerHeldTickCount = v4
                            v2._lastSequence = v3.Sequence
                            v2._completedReplayAnchor = {
                                Snapshot = v3,
                                State = State.clone(v3.State),
                                Support = State.cloneSupport(v3.Support),
                                ServerTick = v3.ServerTick,
                                CommandNumber = v3.LastProcessedCommand,
                                TopologyRevision = v3.Topology.DestructibleRevision,
                            }
                            v2._lastServerTick = v3.ServerTick
                            MoverRevision = v3.Topology.MoverRevision
                            _validatedMoverRevision = v2._validatedMoverRevision
                            if _validatedMoverRevision == nil
                                or 0 < (Serial.deltaUInt32(MoverRevision, _validatedMoverRevision)) then
                                v2._validatedMoverRevision = MoverRevision
                            end
                            v2._lastMoverRevision = v3.Topology.MoverRevision
                            return (tailResult(v3, v6, 0, v8)), nil
                        end
                    end
                end
                v4 = v2._ring:get(v3.LastProcessedCommand)
                v5 = measure(v3, v4)
                v6 = if not v32 then nil else v2:retainedReplayAnchor(v3, v36)
                LastProcessedCommand_6 = if v6 ~= nil then v6.CommandNumber else v3.LastProcessedCommand
                ServerTick_2 = if v6 ~= nil then v6.ServerTick else v3.ServerTick
                DestructibleRevision_2 = if v6 ~= nil then v6.TopologyRevision else v3.Topology.DestructibleRevision
                v10 = v2._ring:entriesAfter(LastProcessedCommand_6, v2._entryScratch)
                if #v10 > 0 and v10[1].Command.CommandNumber ~= Serial.addUInt32(LastProcessedCommand_6, 1) then
                    return nil, "PredictionHistoryGap"
                end
                v11 = if not (#v10 > 0) then nil else v10[#v10]
                v12 = bit32.band(v5.CanonicalStateMismatchMask, (bit32.bnot(u61)))
                v13 = false
                if 0 < v5.CanonicalStateMismatchCount then
                    v13 = false
                    if v12 == 0 then
                        v13 = false
                        if v5.Position <= 0.0001 then
                            v13 = v5.Velocity <= 0.0001
                        end
                    end
                end
                v15 = false
                if v34 == true then
                    v15 = true
                    if v5.CanonicalStateMismatchCount ~= 0 then
                        v15 = false
                        if v12 == 0 then
                            v15 = false
                            if v5.Position <= 0.0625 then
                                v15 = v5.Velocity <= 2
                            end
                        end
                    end
                end
                v16 = false
                if v34 == true then
                    v16 = false
                    if v5.SupportKindMismatch == 0 then
                        v16 = false
                        if v5.SupportSourceMismatch == 0 then
                            v16 = false
                            if v5.SupportAnchor <= 0.0625 then
                                v16 = v5.SupportVelocity <= 2
                            end
                        end
                    end
                end
                v17 = false
                if v34 == true then
                    v17 = false
                    if v11 ~= nil then
                        v17 = false
                        if 0 < v5.CanonicalStateMismatchCount then
                            v17 = false
                            if v12 == 0 then
                                v17 = false
                                if (v11.PostState.Position - v3.State.Position).Magnitude <= 0.0625 then
                                    v17 = (v11.PostState.Velocity - v3.State.Velocity).Magnitude <= 2
                                end
                            end
                        end
                    end
                end
                if not v15 or not v16 then
                    CanonicalSupportMismatch = v17 and v16
                else
                    CanonicalSupportMismatch = true
                    if not (0 < v5.CanonicalStateMismatchCount) then
                        CanonicalSupportMismatch = v5.CanonicalSupportMismatch or v17 and v16
                    end
                end
                _validatedMoverRevision_2 = v2._validatedMoverRevision
                v18 = false
                if _validatedMoverRevision_2 ~= nil then
                    v18 = (Serial.deltaUInt32(v3.Topology.MoverRevision, _validatedMoverRevision_2)) <= 0
                end
                v19 = if v4 ~= nil then Serial.deltaUInt32(v3.ServerTick, v4.ServerTick) else 0
                v20 = true
                for i14, i15 in v10 do
                    if bit32.band(i15.DependencyMask, PredictionRing.Dependency.Mover) == 0
                        and i15.TopologyRevision == v3.Topology.DestructibleRevision then
                        if v19 ~= 0
                            and v37 ~= nil
                            and not v37(i15.PostState, i15.Command, Serial.addUInt32(i15.ServerTick, v19)) then
                            v20 = false
                            break
                        end
                        continue
                    end
                    v20 = false
                    break
                end
                v21 = not v32
                if v21 then
                    v21 = not v1
                    if v21 then
                        v21 = false
                        if v4 ~= nil then
                            v21 = false
                            if v4.ServerTick ~= v3.ServerTick then
                                v21 = false
                                if (math.abs(v19)) <= v2._ring:capacity() then
                                    v21 = false
                                    if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                                        v21 = false
                                        if v5.CanonicalStateMismatchCount == 0 then
                                            v21 = not v5.CanonicalSupportMismatch
                                            if v21 then
                                                v21 = false
                                                if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then
                                                    v21 = if v2._lastMoverRevision == v3.Topology.MoverRevision then v20 else v18 and v20
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                v5.ReplayBarrier = if not v32 then if not v1 then if v4 ~= nil then if v4.ServerTick == v3.ServerTick then if v4.TopologyRevision == v3.Topology.DestructibleRevision then if v5.CanonicalStateMismatchCount == 0 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if v13 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if CanonicalSupportMismatch then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else "StateMismatch" else "PredictionTopology" else if not v21 then "PredictionTick" else "TickRealignFastPath" else "PredictionMissing" else "WorldChange" else "AcceptedWorldChange"
                v5.TickRealigned = v22 == "TickRealignFastPath"
                TickRealigned = true
                if v22 ~= "None" then
                    TickRealigned = v5.TickRealigned
                end
                if TickRealigned then
                    if v5.TickRealigned then
                        v24, v25 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v19)
                        if not v24 then
                            return nil, v25
                        end
                    end
                    v24 = v2._ring:dropThrough(v3.LastProcessedCommand)
                    v2._completedReplayAnchor = {
                        Snapshot = v3,
                        State = State.clone(v3.State),
                        Support = State.cloneSupport(v3.Support),
                        ServerTick = v3.ServerTick,
                        CommandNumber = v3.LastProcessedCommand,
                        TopologyRevision = v3.Topology.DestructibleRevision,
                    }
                    recordAcceptedSnapshot(v2, v3)
                    return (tailResult(v3, v11, v24, v5)), nil
                end
                v24 = false
                if v4 ~= nil then
                    v24 = false
                    if v4.ServerTick == v3.ServerTick then
                        v24 = false
                        if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                            v24 = if v13 then not v5.CanonicalSupportMismatch else CanonicalSupportMismatch and not v5.CanonicalSupportMismatch
                        end
                    end
                end
                v25 = State.clone(if v6 == nil then if not v24 then v3.State else v4.PostState else v6.State)
                v26 = State.cloneSupport(if v6 == nil then if not v24 then v3.Support else v4.PostSupport else v6.Support)
                v27 = table.create(#v10)
                for i16, i17 in v10 do
                    v27[#v27 + 1] = (PredictionRing.cloneEntry(i17))
                end
                v2._pendingReplay = {
                    RetiredCount = 0,
                    NextIndex = 1,
                    Snapshot = v3,
                    AnchorState = v25,
                    AnchorSupport = v26,
                    AnchorServerTick = ServerTick_2,
                    AnchorCommandNumber = LastProcessedCommand_6,
                    AnchorTopologyRevision = DestructibleRevision_2,
                    Metrics = v5,
                    Entries = v27,
                    Staged = table.create(#v10),
                    State = v25,
                    Support = v26,
                    TopologyRevision = DestructibleRevision_2,
                    TailCommandNumber = LastProcessedCommand_6,
                    TailServerTick = ServerTick_2,
                }
                _completedReplayAnchor = v2._completedReplayAnchor
                if v32
                    and v36 ~= nil
                    and _completedReplayAnchor ~= nil
                    and _completedReplayAnchor.Snapshot == v3
                    and not v2._requiresWorldReplay then
                    _pendingReplay = v2._pendingReplay
                    v30 = nil
                    v31 = nil
                    for i18, i19 in v27, v30, v31 do
                        if i19.ServerTick ~= Serial.addUInt32(_pendingReplay.TailServerTick, 1)
                            or i19.Command.CommandNumber ~= Serial.addUInt32(_pendingReplay.TailCommandNumber, 1)
                            or 0 <= (Serial.deltaUInt32(i19.ServerTick, v36)) then
                            break
                        end
                        if _completedReplayAnchor.InvalidFromTick ~= nil
                            and 0 <= (Serial.deltaUInt32(i19.ServerTick, _completedReplayAnchor.InvalidFromTick)) then
                            break
                        end
                        if _completedReplayAnchor.WorldInvalidFromTick ~= nil
                            and 0 <= (Serial.deltaUInt32(i19.ServerTick, _completedReplayAnchor.WorldInvalidFromTick)) then
                            break
                        end
                        Staged = _pendingReplay.Staged
                        v33 = {
                            Entry = i19,
                            ServerTick = i19.ServerTick,
                            State = i19.PostState,
                            Support = i19.PostSupport,
                            TopologyRevision = i19.TopologyRevision,
                            DependencyMask = i19.DependencyMask,
                        }
                        Staged[i18] = v33
                        PostState = i19.PostState
                        PostSupport = i19.PostSupport
                        _pendingReplay.State = PostState
                        _pendingReplay.Support = PostSupport
                        _pendingReplay.TopologyRevision = i19.TopologyRevision
                        ServerTick_4 = i19.ServerTick
                        CommandNumber = i19.Command.CommandNumber
                        _pendingReplay.TailServerTick = ServerTick_4
                        _pendingReplay.TailCommandNumber = CommandNumber
                        _pendingReplay.NextIndex = i18 + 1
                    end
                end
                v28, v29 = advancePendingReplay(v2, v14, v23, v35)
                if v28 == nil and v29 ~= "ReplayPending" then
                    v2._pendingReplay = nil
                end
                return v28, v29
            end
            v4 = Serial.deltaUInt32(v3.ServerTick, v2._lastServerTick)
            v5 = v2._ring:entriesAfter(v3.LastProcessedCommand, v2._entryScratch)
            v6 = v5[#v5]
            v7 = true
            v8 = v5
            v9 = nil
            for i20, i21 in v8, v9 do
                if bit32.band(i21.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 then
                    v7 = false
                    break
                end
                if v4 ~= 0
                    and v37 ~= nil
                    and not v37(i21.PostState, i21.Command, Serial.addUInt32(i21.ServerTick, v4)) then
                    v7 = false
                    break
                end
            end
            if v7 and v4 >= 0 and v4 <= v2._ring:capacity() then
                if v4 > 0 then
                    v8, v9 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v4)
                    if not v8 then
                        return nil, v9
                    end
                end
                v8 = zeroMetrics()
                v8.ReplayBarrier = "AcknowledgementHeld"
                v8.TickRealigned = v4 > 0
                v8.ServerHeldTickCount = v4
                v2._lastSequence = v3.Sequence
                v2._completedReplayAnchor = {
                    Snapshot = v3,
                    State = State.clone(v3.State),
                    Support = State.cloneSupport(v3.Support),
                    ServerTick = v3.ServerTick,
                    CommandNumber = v3.LastProcessedCommand,
                    TopologyRevision = v3.Topology.DestructibleRevision,
                }
                v2._lastServerTick = v3.ServerTick
                MoverRevision = v3.Topology.MoverRevision
                _validatedMoverRevision = v2._validatedMoverRevision
                if _validatedMoverRevision == nil
                    or 0 < (Serial.deltaUInt32(MoverRevision, _validatedMoverRevision)) then
                    v2._validatedMoverRevision = MoverRevision
                end
                v2._lastMoverRevision = v3.Topology.MoverRevision
                return (tailResult(v3, v6, 0, v8)), nil
            end
        end
        v4 = v2._ring:get(v3.LastProcessedCommand)
        v5 = measure(v3, v4)
        v6 = if not v32 then nil else v2:retainedReplayAnchor(v3, v36)
        LastProcessedCommand_6 = if v6 ~= nil then v6.CommandNumber else v3.LastProcessedCommand
        ServerTick_2 = if v6 ~= nil then v6.ServerTick else v3.ServerTick
        DestructibleRevision_2 = if v6 ~= nil then v6.TopologyRevision else v3.Topology.DestructibleRevision
        v10 = v2._ring:entriesAfter(LastProcessedCommand_6, v2._entryScratch)
        if #v10 > 0 and v10[1].Command.CommandNumber ~= Serial.addUInt32(LastProcessedCommand_6, 1) then
            return nil, "PredictionHistoryGap"
        end
        v11 = if not (#v10 > 0) then nil else v10[#v10]
        v12 = bit32.band(v5.CanonicalStateMismatchMask, (bit32.bnot(u61)))
        v13 = false
        if 0 < v5.CanonicalStateMismatchCount then
            v13 = false
            if v12 == 0 then
                v13 = false
                if v5.Position <= 0.0001 then
                    v13 = v5.Velocity <= 0.0001
                end
            end
        end
        v15 = false
        if v34 == true then
            v15 = true
            if v5.CanonicalStateMismatchCount ~= 0 then
                v15 = false
                if v12 == 0 then
                    v15 = false
                    if v5.Position <= 0.0625 then
                        v15 = v5.Velocity <= 2
                    end
                end
            end
        end
        v16 = false
        if v34 == true then
            v16 = false
            if v5.SupportKindMismatch == 0 then
                v16 = false
                if v5.SupportSourceMismatch == 0 then
                    v16 = false
                    if v5.SupportAnchor <= 0.0625 then
                        v16 = v5.SupportVelocity <= 2
                    end
                end
            end
        end
        v17 = false
        if v34 == true then
            v17 = false
            if v11 ~= nil then
                v17 = false
                if 0 < v5.CanonicalStateMismatchCount then
                    v17 = false
                    if v12 == 0 then
                        v17 = false
                        if (v11.PostState.Position - v3.State.Position).Magnitude <= 0.0625 then
                            v17 = (v11.PostState.Velocity - v3.State.Velocity).Magnitude <= 2
                        end
                    end
                end
            end
        end
        if not v15 or not v16 then
            CanonicalSupportMismatch = v17 and v16
        else
            CanonicalSupportMismatch = true
            if not (0 < v5.CanonicalStateMismatchCount) then
                CanonicalSupportMismatch = v5.CanonicalSupportMismatch or v17 and v16
            end
        end
        _validatedMoverRevision_2 = v2._validatedMoverRevision
        v18 = false
        if _validatedMoverRevision_2 ~= nil then
            v18 = (Serial.deltaUInt32(v3.Topology.MoverRevision, _validatedMoverRevision_2)) <= 0
        end
        v19 = if v4 ~= nil then Serial.deltaUInt32(v3.ServerTick, v4.ServerTick) else 0
        v20 = true
        for i22, i23 in v10 do
            if bit32.band(i23.DependencyMask, PredictionRing.Dependency.Mover) == 0
                and i23.TopologyRevision == v3.Topology.DestructibleRevision then
                if v19 ~= 0
                    and v37 ~= nil
                    and not v37(i23.PostState, i23.Command, Serial.addUInt32(i23.ServerTick, v19)) then
                    v20 = false
                    break
                end
                continue
            end
            v20 = false
            break
        end
        v21 = not v32
        if v21 then
            v21 = not v1
            if v21 then
                v21 = false
                if v4 ~= nil then
                    v21 = false
                    if v4.ServerTick ~= v3.ServerTick then
                        v21 = false
                        if (math.abs(v19)) <= v2._ring:capacity() then
                            v21 = false
                            if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                                v21 = false
                                if v5.CanonicalStateMismatchCount == 0 then
                                    v21 = not v5.CanonicalSupportMismatch
                                    if v21 then
                                        v21 = false
                                        if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then
                                            v21 = if v2._lastMoverRevision == v3.Topology.MoverRevision then v20 else v18 and v20
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        v5.ReplayBarrier = if not v32 then if not v1 then if v4 ~= nil then if v4.ServerTick == v3.ServerTick then if v4.TopologyRevision == v3.Topology.DestructibleRevision then if v5.CanonicalStateMismatchCount == 0 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if v13 then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else if CanonicalSupportMismatch then if not v5.CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else if CanonicalSupportMismatch then if v2._lastTopologyRevision == v3.Topology.DestructibleRevision then if v2._lastMoverRevision == v3.Topology.MoverRevision then "None" else if v18 then "None" else "MoverRevision" else "DestructibleRevision" else "SupportMismatch" else "StateMismatch" else "PredictionTopology" else if not v21 then "PredictionTick" else "TickRealignFastPath" else "PredictionMissing" else "WorldChange" else "AcceptedWorldChange"
        v5.TickRealigned = v22 == "TickRealignFastPath"
        TickRealigned = true
        if v22 ~= "None" then
            TickRealigned = v5.TickRealigned
        end
        if TickRealigned then
            if v5.TickRealigned then
                v24, v25 = v2._ring:shiftServerTicksAfter(v3.LastProcessedCommand, v19)
                if not v24 then
                    return nil, v25
                end
            end
            v24 = v2._ring:dropThrough(v3.LastProcessedCommand)
            v2._completedReplayAnchor = {
                Snapshot = v3,
                State = State.clone(v3.State),
                Support = State.cloneSupport(v3.Support),
                ServerTick = v3.ServerTick,
                CommandNumber = v3.LastProcessedCommand,
                TopologyRevision = v3.Topology.DestructibleRevision,
            }
            recordAcceptedSnapshot(v2, v3)
            return (tailResult(v3, v11, v24, v5)), nil
        end
        v24 = false
        if v4 ~= nil then
            v24 = false
            if v4.ServerTick == v3.ServerTick then
                v24 = false
                if v4.TopologyRevision == v3.Topology.DestructibleRevision then
                    v24 = if v13 then not v5.CanonicalSupportMismatch else CanonicalSupportMismatch and not v5.CanonicalSupportMismatch
                end
            end
        end
        v25 = State.clone(if v6 == nil then if not v24 then v3.State else v4.PostState else v6.State)
        v26 = State.cloneSupport(if v6 == nil then if not v24 then v3.Support else v4.PostSupport else v6.Support)
        v27 = table.create(#v10)
        for i24, i25 in v10 do
            v27[#v27 + 1] = (PredictionRing.cloneEntry(i25))
        end
        v2._pendingReplay = {
            RetiredCount = 0,
            NextIndex = 1,
            Snapshot = v3,
            AnchorState = v25,
            AnchorSupport = v26,
            AnchorServerTick = ServerTick_2,
            AnchorCommandNumber = LastProcessedCommand_6,
            AnchorTopologyRevision = DestructibleRevision_2,
            Metrics = v5,
            Entries = v27,
            Staged = table.create(#v10),
            State = v25,
            Support = v26,
            TopologyRevision = DestructibleRevision_2,
            TailCommandNumber = LastProcessedCommand_6,
            TailServerTick = ServerTick_2,
        }
        _completedReplayAnchor = v2._completedReplayAnchor
        if v32
            and v36 ~= nil
            and _completedReplayAnchor ~= nil
            and _completedReplayAnchor.Snapshot == v3
            and not v2._requiresWorldReplay then
            _pendingReplay = v2._pendingReplay
            v30 = nil
            v31 = nil
            for i26, i27 in v27, v30, v31 do
                if i27.ServerTick ~= Serial.addUInt32(_pendingReplay.TailServerTick, 1)
                    or i27.Command.CommandNumber ~= Serial.addUInt32(_pendingReplay.TailCommandNumber, 1)
                    or 0 <= (Serial.deltaUInt32(i27.ServerTick, v36)) then
                    break
                end
                if _completedReplayAnchor.InvalidFromTick ~= nil
                    and 0 <= (Serial.deltaUInt32(i27.ServerTick, _completedReplayAnchor.InvalidFromTick)) then
                    break
                end
                if _completedReplayAnchor.WorldInvalidFromTick ~= nil
                    and 0 <= (Serial.deltaUInt32(i27.ServerTick, _completedReplayAnchor.WorldInvalidFromTick)) then
                    break
                end
                Staged = _pendingReplay.Staged
                v33 = {
                    Entry = i27,
                    ServerTick = i27.ServerTick,
                    State = i27.PostState,
                    Support = i27.PostSupport,
                    TopologyRevision = i27.TopologyRevision,
                    DependencyMask = i27.DependencyMask,
                }
                Staged[i26] = v33
                PostState = i27.PostState
                PostSupport = i27.PostSupport
                _pendingReplay.State = PostState
                _pendingReplay.Support = PostSupport
                _pendingReplay.TopologyRevision = i27.TopologyRevision
                ServerTick_4 = i27.ServerTick
                CommandNumber = i27.Command.CommandNumber
                _pendingReplay.TailServerTick = ServerTick_4
                _pendingReplay.TailCommandNumber = CommandNumber
                _pendingReplay.NextIndex = i26 + 1
            end
        end
        v28, v29 = advancePendingReplay(v2, v14, v23, v35)
        if v28 == nil and v29 ~= "ReplayPending" then
            v2._pendingReplay = nil
        end
        return v28, v29
    end
    return nil, "TopologyMismatch"
end

return table.freeze(u62)