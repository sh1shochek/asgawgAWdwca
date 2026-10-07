-- ReplicatedStorage.MovementV2.Client.Runtime
-- Script path: ReplicatedStorage.MovementV2.Client.Runtime
-- Decompile time: 55.52 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Catalog = require(script.Parent.Parent.Collision.Catalog)
local TopologyBuilder = require(script.Parent.Parent.Collision.TopologyBuilder)
local Config = require(script.Parent.Parent.Config)
local ControlCodec = require(script.Parent.Parent.ControlCodec)
local DamageTag = require(script.Parent.Parent.DamageTag)
local ActionLockTimeline = require(script.Parent.Parent.ActionLockTimeline)
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol)
local Enums = require(script.Parent.Parent.Enums)
local Mapping = require(script.Parent.Parent.Mapping)
local OwnerSnapshotCodec = require(script.Parent.Parent.OwnerSnapshotCodec)
local RemoteSnapshotCodec = require(script.Parent.Parent.RemoteSnapshotCodec)
local Serial = require(script.Parent.Parent.Serial)
local Simulation = require(script.Parent.Parent.Simulation)
local Config_2 = require(script.Parent.Parent.Simulation.Config)
local DeterminismTrace = require(script.Parent.Parent.Simulation.DeterminismTrace)
local PlayerContacts = require(script.Parent.Parent.Simulation.PlayerContacts)
local RuntimeSettings = require(script.Parent.Parent.Simulation.RuntimeSettings)
require(script.Parent.Parent.Simulation.Types)
local Transport = require(script.Parent.Parent.Transport)
require(script.Parent.Parent.Types)
local WorldComposer = require(script.Parent.WorldComposer)
local CommandState = require(script.Parent.CommandState)
local CommandStream = require(script.Parent.CommandStream)
local CommandUplink = require(script.Parent.CommandUplink)
local DestructibleTimeline = require(script.Parent.DestructibleTimeline)
local DeterminismTraceCapture = require(script.Parent.DeterminismTraceCapture)
local PlayerContactAdapter = require(script.Parent.PlayerContactAdapter)
local PredictionErrorSmoother = require(script.Parent.PredictionErrorSmoother)
local RootFrame = require(script.Parent.Parent.RootFrame)
local PredictionPacing = require(script.Parent.PredictionPacing)
local CommandClock = require(script.Parent.CommandClock)
local OwnerCommandFeedback = require(script.Parent.OwnerCommandFeedback)
local OwnerReplay = require(script.Parent.OwnerReplay)
local OwnerRecovery = require(script.Parent.OwnerRecovery)
local DamageTagReplay = require(script.Parent.DamageTagReplay)
local ActionLockReplay = require(script.Parent.ActionLockReplay)
local PredictionRing = require(script.Parent.PredictionRing)
local Reconciler = require(script.Parent.Reconciler)
local RemoteBuffer = require(script.Parent.RemoteBuffer)
local RemoteClock = require(script.Parent.RemoteClock)
local RuntimeDiagnostics = require(script.Parent.RuntimeDiagnostics)
require(script.Parent.RuntimeTypes)
local u253 = {}
u253.__index = u253

local function newReconciliationReplayBudget() -- Line: 101
    return {MinimumSteps = 1, MaximumSteps = 16, MaximumSeconds = 0.0005}
end

local function beginReconciliationTiming() -- Line: 109
    return {WorkSeconds = 0, SliceCount = 0, MaximumSliceSeconds = 0, StartedAt = os.clock()}
end

local function recordReconciliationSlice(a1, a2) -- Line: 118 -- types: a2: number
    local v1 = math.max(os.clock() - a2, 0)
    a1.WorkSeconds = a1.WorkSeconds + v1
    a1.SliceCount = a1.SliceCount + 1
    a1.MaximumSliceSeconds = math.max(a1.MaximumSliceSeconds, v1)
end

local function applyReconciliationTiming(a1, a2) -- Line: 125
    a1.ReconciliationWorkSeconds = a2.WorkSeconds
    a1.ReconciliationElapsedSeconds = math.max(os.clock() - a2.StartedAt, a2.WorkSeconds)
    a1.ReconciliationSliceCount = a2.SliceCount
    a1.ReconciliationMaximumSliceSeconds = a2.MaximumSliceSeconds
end

local function cloneMapping(a1) -- Line: 132 -- upvalues: Mapping (val)
    return (table.freeze(Mapping.clone(a1)))
end

local function sameMappingIdentity(a1, a2) -- Line: 136
    local v1 = false
    if a1.Generation == a2.Generation then
        v1 = false
        if a1.ActorId == a2.ActorId then
            v1 = false
            if a1.SimulationHz == a2.SimulationHz then
                v1 = false
                if a1.TopologyEpoch == a2.TopologyEpoch then
                    v1 = a1.TopologyFingerprint == a2.TopologyFingerprint
                end
            end
        end
    end
    return v1
end

local function isPlayerCollisionPolicyRemap(a1, a2) -- Line: 144
    local v1 = false
    if a1.Generation == a2.Generation then
        v1 = false
        if a1.ActorId == a2.ActorId then
            v1 = false
            if a1.SimulationHz == a2.SimulationHz then
                v1 = false
                if a1.TopologyEpoch == a2.TopologyEpoch then
                    v1 = a1.TopologyFingerprint == a2.TopologyFingerprint
                end
            end
        end
    end
    if v1 then
        v1 = a1.PlayerCollisionsEnabled ~= a2.PlayerCollisionsEnabled
    end
    return v1
end

local clone = Simulation.State.clone
local cloneSupport = Simulation.State.cloneSupport

local function finiteSpeed(a1) -- Line: 151
    local v1 = false
    if type(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = (math.abs(a1)) < (1 / 0)
        end
    end
    return v1
end

local forCommand = CommandState.forCommand
local serverTimeAtTick = CommandState.serverTimeAtTick

local function defaultMapRoot(a1) -- Line: 158 -- upvalues: Catalog (val), Workspace (val)
    return Catalog.FindReplica(a1.TopologyEpoch, a1.TopologyFingerprint) or Workspace:FindFirstChild("Map")
end

local function stanceHalfSize(a1) -- Line: 163 -- upvalues: Config_2 (val)
    local Default = Config_2.Default
    local PlayerSizeDucking = if a1 ~= "Ducking" then Default.PlayerSizeStanding else Default.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

local function withinPlayerContactMargin(a1, a2) -- Line: 168 -- upvalues: Config_2 (val), PlayerContacts (val)
    local Stance = a1.Stance
    local Default = Config_2.Default
    local PlayerSizeDucking = if Stance ~= "Ducking" then Default.PlayerSizeStanding else Default.PlayerSizeDucking
    local v1 = PlayerSizeDucking * 0.5
    local Stance_2 = a2.Stance
    local Default_2 = Config_2.Default
    local PlayerSizeDucking_2 = if Stance_2 ~= "Ducking" then Default_2.PlayerSizeStanding else Default_2.PlayerSizeDucking
    local v2 = v1 + PlayerSizeDucking_2 * 0.5
    v1 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin
    local v3 = a1.Position - a2.Position
    local v4 = false
    if (math.abs(v3.X)) <= v2.X + v1 then
        v4 = false
        if (math.abs(v3.Y)) <= v2.Y + v1 then
            v4 = (math.abs(v3.Z)) <= v2.Z + v1
        end
    end
    return v4
end

function u253.new(a1) -- Line: 177
    -- upvalues: RunService (val), u253 (val), CommandUplink (val), RuntimeDiagnostics (val)
    -- upvalues: DeterminismTraceCapture (val)
    assert(RunService:IsClient(), "MovementV2 Client.Runtime is client-only")
    local v1 = false
    if type(a1) == "table" then
        v1 = type(a1.SampleInput) == "function"
    end
    assert(v1, "SampleInput callback is required")
    v1 = {
        _started = false,
        _status = "Stopped",
        _statusFromPredictionFailure = false,
        _accumulatorSeconds = 0,
        _topologyRetrySeconds = 0,
        _pendingActionLockReplay = false,
        _lastHistoryRecoveryRequestAt = 0,
        _lastOwnerAppliedAt = 0,
        _lastPredictionHitchAt = 0,
        _commandResyncRequestedAt = 0,
        _discardNextAdvanceDelta = false,
        _options = a1,
        _connections = {},
        _collisionComposer = a1.CollisionComposer,
        _presentationContextScratch = {TickFraction = 0, LocalPlayerContactCritical = false, Status = "Stopped"},
        _localPresentationContextScratch = {TickFraction = 0, LocalPlayerContactCritical = false, Status = "Stopped"},
        _remotePresentationPool = {},
        _remotePresentations = {},
        _pendingDeltas = {},
        _pendingMoverDeltas = {},
        _pendingMoverReplayIds = {},
        _damageTagsByMovementTick = {},
        _reconciliationReplayBudget = {MinimumSteps = 1, MaximumSteps = 16, MaximumSeconds = 0.0005},
        _contactActorIds = {},
        _seenJumpCommands = {},
        _seenJumpOrder = {},
        _lastWarningAtByMessage = {},
    }
    local u40 = setmetatable(v1, u253)
    u40._uplink = CommandUplink.new({
        OnPacketSent = function(a1, a2) -- Line: 227 -- upvalues: u40 (val) -- types: a1: number, a2: boolean
            local _mapping = u40._mapping
            local OnCommandPacketSent = u40._options.OnCommandPacketSent
            if _mapping ~= nil and OnCommandPacketSent ~= nil then
                OnCommandPacketSent(_mapping.Generation, a1, a2)
            end
        end,
        Warn = function(a1) -- Line: 234 -- upvalues: u40 (val) -- types: a1: string
            u40:_warn(a1)
        end,
    })
    u40._diagnostics = RuntimeDiagnostics.new(u40)
    u40._traceCapture = DeterminismTraceCapture.new({
        Report = function(a1, a2, a3) -- Line: 240 -- upvalues: u40 (val)
            u40._diagnostics:reportIssue(a1, a2, a3)
        end,
        Warn = function(a1) -- Line: 243 -- upvalues: u40 (val) -- types: a1: string
            u40:_warn(a1)
        end,
    })
    return u40
end

local function annotateReconciliation(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 250
    -- upvalues: Serial (val)
    a1.ReconciliationMode = if a2.ReplayCount ~= 0 then if a3.LastProcessedCommand ~= Serial.UInt32Max then if a4 ~= nil then if not (0 < a2.ReplayCount) then "Reuse" else "Replay" else "Reanchor" else "Initial" else if a1.ReplayBarrier ~= "AcknowledgementHeld" then if a3.LastProcessedCommand ~= Serial.UInt32Max then if a4 ~= nil then if not (0 < a2.ReplayCount) then "Reuse" else "Replay" else "Reanchor" else "Initial" else "Reuse"
    a1.ReplayCount = a2.ReplayCount
    a1.DroppedCommandCount = a2.DroppedCommandCount
    if a8 ~= nil and a8.LastProcessedCommand ~= Serial.UInt32Max and a3.LastProcessedCommand ~= Serial.UInt32Max then
        a1.AcknowledgedCommandDelta = math.max(Serial.deltaUInt32(a3.LastProcessedCommand, a8.LastProcessedCommand), 0)
        a1.ServerTickDelta = math.max(Serial.deltaUInt32(a3.ServerTick, a8.ServerTick), 0)
        a1.ServerHeldTickCount = math.max(a1.ServerTickDelta - a1.AcknowledgedCommandDelta, 0)
    end
    if a5 ~= nil and a6 ~= nil then
        a1.TailCompared = true
        if a7 ~= nil then
            a1.TailServerTickDelta = Serial.deltaUInt32(a2.TailServerTick, a7)
        end
        local v1 = a2.State.Position - a5.Position
        local v2 = a2.State.Velocity - a5.Velocity
        a1.TailPosition = v1.Magnitude
        a1.TailHorizontalPosition = Vector2.new(v1.X, v1.Z).Magnitude
        a1.TailVerticalPosition = v1.Y
        a1.TailVelocity = v2.Magnitude
        a1.TailVerticalVelocity = v2.Y
        a1.TailSupportAnchor = (a2.Support.Anchor - a6.Anchor).Magnitude
        a1.TailSupportVelocity = (a2.Support.Velocity - a6.Velocity).Magnitude
        a1.TailSupportKindMismatch = if a2.Support.Kind ~= a6.Kind then 1 else 0
        a1.TailSupportSourceMismatch = if a2.Support.SourceId ~= a6.SourceId then 1 else 0
        a1.TailGroundMismatch = a2.State.OnGround ~= a5.OnGround
        a1.TailStanceMismatch = a2.State.Stance ~= a5.Stance
        return
    end
end

function u253:_warn(a2) -- Line: 303 -- upvalues: DiagnosticProtocol (val) -- types: self: table, a2: string
    local v1 = os.clock()
    if v1 - (self._lastWarningAtByMessage[a2] or (-1 / 0)) < 5 then
        return
    end
    self._lastWarningAtByMessage[a2] = v1
    self._diagnostics:reportWarning(a2)
    local OnWarning = self._options.OnWarning
    if OnWarning ~= nil then
        OnWarning(a2)
        return
    end
    DiagnosticProtocol.outputWarning((("[MovementV2.Client] %*"):format(a2)))
end

function u253:_setStatus(a2, a3) -- Line: 319 -- types: self: table, a3: string?
    self._statusFromPredictionFailure = false
    if self._status == a2 and self._reason == a3 then
        return
    end
    self._diagnostics:recordStatusChange(self._status)
    self._status = a2
    self._reason = a3
    local OnStatusChanged = self._options.OnStatusChanged
    if OnStatusChanged ~= nil then
        OnStatusChanged(a2, a3)
    end
end

function u253.getStatus(a1) -- Line: 333
    return a1._status, a1._reason
end

function u253.getMapping(a1) -- Line: 337
    return a1._mapping
end

function u253:_refreshPresentedState(a2) -- Line: 341 -- upvalues: clone (val), cloneSupport (val)
    if self._state ~= nil and self._support ~= nil then
        local v1 = clone(self._state)
        self._presentedState = v1
        self._previousPresentedState = if a2 ~= nil then clone(a2) else v1
        self._presentedSupport = cloneSupport(self._support)
        return
    end
    self._presentedState = nil
    self._previousPresentedState = nil
    self._presentedSupport = nil
end

function u253.getPredictedState(a1) -- Line: 354 -- upvalues: clone (val), cloneSupport (val)
    if a1._state ~= nil and a1._support ~= nil then
        return (clone(a1._state)), (cloneSupport(a1._support)), a1._lastPredictedServerTick
    end
    return nil, nil, a1._lastPredictedServerTick
end

function u253.getRemoteViewTick(a1) -- Line: 362
    local v1, v2 = a1:_presentationClock()
    local _config = a1._config
    if v1 ~= nil and _config ~= nil then
        return v1 + v2 - _config.RenderInterpolationTicks
    end
    return nil
end

function u253.rejectDoorPrediction(a1, a2, a3) -- Line: 372
    -- upvalues: OwnerReplay (val), Serial (val)
    local _collisionComposer = a1._collisionComposer
    if _collisionComposer ~= nil and type(_collisionComposer.RejectDoorUse) == "function" then
        local v1, v2 = _collisionComposer:RejectDoorUse(a2, a3)
        if v2 ~= nil then
            return false, v2
        end
        if v1 == nil then
            return true, nil
        end
        OwnerReplay.invalidateWorld(a1)
        local _reconciler = a1._reconciler
        if a1._pendingReconciliationInstall ~= nil and _reconciler ~= nil then
            _reconciler:invalidatePendingReplayFromTick(v1)
        end
        local _pendingMoverReplayTick = a1._pendingMoverReplayTick
        if _pendingMoverReplayTick == nil or (Serial.deltaUInt32(v1, _pendingMoverReplayTick)) < 0 then
            a1._pendingMoverReplayTick = v1
        end
        a1._pendingMoverReplayIds[a2] = true
        return true, nil
    end
    return false, "MoverComposerUnavailable"
end

function u253:_localClockAnchor() -- Line: 398
    local _lastPredictedServerTick = self._lastPredictedServerTick
    local _config = self._config
    if _lastPredictedServerTick ~= nil and _config ~= nil then
        return _lastPredictedServerTick, (math.clamp(self._accumulatorSeconds / _config.StepSeconds, 0, 0.999999))
    end
    return _lastPredictedServerTick, 0
end

function u253:_presentationClock() -- Line: 407
    local _remoteClock = self._remoteClock
    if _remoteClock == nil then
        return nil, 0
    end
    return _remoteClock:current()
end

function u253:_localPlayerContactCritical() -- Line: 415 -- upvalues: Enums (val)
    local _mapping = self._mapping
    if _mapping ~= nil and _mapping.PlayerCollisionsEnabled then
        local _support = self._support
        if _support ~= nil and _support.Kind == Enums.SupportKind.Player and _support.SourceId ~= 0 then
            return true
        end
        return next(self._contactActorIds) ~= nil
    end
    return false
end

function u253:_playerContactNearStateAtTick(a2, a3) -- Line: 427
    -- upvalues: PlayerContacts (val), Config_2 (val), withinPlayerContactMargin (val)
    local _mapping = self._mapping
    local _remoteBuffer = self._remoteBuffer
    if _mapping ~= nil and _mapping.PlayerCollisionsEnabled and _remoteBuffer ~= nil then
        local v1
        local v2 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin
        local v3 = Config_2.Default.PlayerSizeStanding + Vector3.new(v2, v2, v2)
        for i, j in _remoteBuffer:queryCollisionActorKeys(a2.Position - v3, a2.Position + v3) do
            v1 = _remoteBuffer:getCollisionPose(j, a3, 0)
            if v1 ~= nil and v1.ActorId ~= _mapping.ActorId and withinPlayerContactMargin(a2, v1) then
                return true
            end
        end
        return false
    end
    return false
end

function u253:_presentationContext() -- Line: 445
    local v1, v2 = self:_presentationClock()
    return {
        Mapping = self._mapping,
        ServerTick = v1,
        TickFraction = v2,
        LocalPlayerContactCritical = self:_localPlayerContactCritical(),
        Status = self._status,
        Reason = self._reason,
    }
end

function u253:_sendBaselineRequest(a2, a3, a4) -- Line: 457
    -- upvalues: ControlCodec (val)
    local _channels = self._channels
    if _channels == nil then
        return
    end
    local v1, v2 = ControlCodec.encodeBaselineRequest(a2, a3)
    if v1 == nil then
        self:_warn((("failed to encode destructible baseline request: %*"):format(v2)))
        return
    end
    self:_sendDueCommands(true)
    _channels.Control:FireServer(v1)
    self:_setStatus("WaitingForBaseline", a4)
end

function u253:_sendMappingRequest(a2) -- Line: 472 -- upvalues: ControlCodec (val) -- types: self: table, a2: number
    if self._retiredGeneration == a2 or self._requestedMappingGeneration == a2 then
        return
    end
    local _channels = self._channels
    if _channels == nil then
        return
    end
    local v1, v2 = ControlCodec.encodeMappingRequest(a2)
    if v1 == nil then
        self:_warn((("failed to encode mapping request: %*"):format(v2)))
        return
    end
    self:_sendDueCommands(true)
    self._diagnostics:recordMappingRequest()
    self._requestedMappingGeneration = a2
    _channels.Control:FireServer(v1)
end

function u253:_sendCommandResyncRequest(a2, a3) -- Line: 494
    -- upvalues: Serial (val), ControlCodec (val)
    local _mapping = self._mapping
    local _channels = self._channels
    if _mapping ~= nil and _channels ~= nil and Serial.isUInt32(a2) then
        local v1 = self._pendingCommandResyncThrough or a2
        if self._pendingCommandResyncThrough == v1 and a3 ~= true then
            return true
        end
        local v2, v3 = ControlCodec.encodeCommandResyncRequest(_mapping.Generation, v1)
        if v2 == nil then
            self:_warn((("failed to encode command resync request: %*"):format(v3)))
            return false
        end
        self:_sendDueCommands(true)
        self._diagnostics:recordResyncRequest()
        self._pendingCommandResyncThrough = v1
        self._commandResyncRequestedAt = os.clock()
        _channels.Control:FireServer(v2)
        return true
    end
    return false
end

function u253:_canPredict() -- Line: 518
    local v1
    if self._status == "Running" or self._status == "WaitingForInput" or self._status == "WaitingForAuthority" then
        v1 = false
        if self._mapping ~= nil then
            v1 = false
            if self._topology ~= nil then
                v1 = false
                if self._timeline ~= nil then
                    v1 = false
                    if self._state ~= nil then
                        v1 = false
                        if self._support ~= nil then
                            v1 = false
                            if self._lastPredictedServerTick ~= nil then
                                v1 = self._lastAcceptedOwnerSnapshot ~= nil
                            end
                        end
                    end
                end
            end
        end
    else
        v1 = false
        if self._status == "WaitingForBaseline" then
            v1 = false
            if self._mapping ~= nil then
                v1 = false
                if self._topology ~= nil then
                    v1 = false
                    if self._timeline ~= nil then
                        v1 = false
                        if self._state ~= nil then
                            v1 = false
                            if self._support ~= nil then
                                v1 = false
                                if self._lastPredictedServerTick ~= nil then
                                    v1 = self._lastAcceptedOwnerSnapshot ~= nil
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return v1
end

function u253:_sendGrenadeTransitionRequest(a2) -- Line: 534 -- upvalues: ControlCodec (val)
    local _mapping = self._mapping
    local _channels = self._channels
    local WeaponSelectRequestId = a2.WeaponSelectRequestId
    local WeaponSelectIdentifier = a2.WeaponSelectIdentifier
    local GrenadeThrowIdentifier = a2.GrenadeThrowIdentifier
    local GrenadeThrowAnimation = a2.GrenadeThrowAnimation
    if _mapping ~= nil
        and _channels ~= nil
        and WeaponSelectRequestId ~= nil
        and WeaponSelectIdentifier ~= nil
        and GrenadeThrowIdentifier ~= nil
        and GrenadeThrowAnimation ~= nil then
        local v1, v2 = ControlCodec.encodeGrenadeTransitionRequest(
            _mapping.Generation,
            a2.CommandNumber,
            WeaponSelectRequestId,
            WeaponSelectIdentifier,
            GrenadeThrowIdentifier,
            GrenadeThrowAnimation,
            a2.LookYaw,
            a2.VerticalLook
        )
        if v1 == nil then
            self:_warn((("failed to encode grenade transition: %*"):format(v2)))
            return false
        end
        _channels.Control:FireServer(v1)
        return true
    end
    return false
end

function u253:requestMapping(a2) -- Line: 569 -- upvalues: Serial (val) -- types: self: table, a2: number
    if not Serial.isNonZeroUInt16(a2) then
        return false, "InvalidGeneration"
    end
    if self._retiredGeneration == a2 then
        return false, "GenerationRetired"
    end
    if self._channels == nil then
        self._queuedMappingGeneration = a2
        return true, nil
    end
    self._queuedMappingGeneration = nil
    local _mapping = self._mapping
    if _mapping == nil or _mapping.Generation ~= a2 then
        self:_setStatus("WaitingForMapping", "RequestedCharacterGeneration")
    end
    self._requestedMappingGeneration = nil
    self:_sendMappingRequest(a2)
    return true, nil
end

function u253:_disposeTimeline() -- Line: 591
    if self._timelineConnection ~= nil then
        self._timelineConnection:Disconnect()
        self._timelineConnection = nil
    end
    if self._timeline ~= nil then
        self._timeline:destroy()
        self._timeline = nil
    end
end

function u253:_clearGenerationState() -- Line: 603
    self:_disposeTimeline()
    self._commandStream = nil
    self._predictionRing = nil
    self._traceCapture:reset(nil)
    self._reconciler = nil
    self._state = nil
    self._support = nil
    self:_refreshPresentedState()
    self._lastPredictedServerTick = nil
    self._lastWeaponSelectionCommand = nil
    self._accumulatorSeconds = 0
    self._cachedStaticFrame = nil
    self._cachedStaticWorld = nil
    self._pendingBaseline = nil
    table.clear(self._pendingDeltas)
    self._pendingMoverBaseline = nil
    table.clear(self._pendingMoverDeltas)
    self._pendingMoverReplayTick = nil
    self._pendingMoverReplayRevision = nil
    table.clear(self._pendingMoverReplayIds)
    table.clear(self._damageTagsByMovementTick)
    self._pendingDamageTagReplayMovementTick = nil
    self._actionLocks = nil
    self._pendingActionLockReplay = false
    self._pendingDiscontinuity = nil
    self._pendingOwnerSnapshot = nil
    self._pendingReconciliationInstall = nil
    self._lastHistoryRecoveryRequestAt = 0
    self._lastAcceptedOwnerSnapshot = nil
    self._requestedMappingGeneration = nil
    self._queuedMappingGeneration = nil
    table.clear(self._contactActorIds)
    table.clear(self._seenJumpCommands)
    table.clear(self._seenJumpOrder)
    self._lastAuthoritativeJumpCommand = nil
    self._uplink:resetGeneration()
    self._pendingCommandResyncThrough = nil
    self._commandResyncRequestedAt = 0
    local _collisionComposer = self._collisionComposer
    if _collisionComposer ~= nil then
        _collisionComposer:Reset()
    end
end

function u253:retireGeneration(a2) -- Line: 648 -- upvalues: Serial (val) -- types: self: table, a2: number
    if not Serial.isNonZeroUInt16(a2) then
        return false, "InvalidGeneration"
    end
    local _mapping = self._mapping
    if _mapping ~= nil and _mapping.Generation ~= a2 then
        return false, "GenerationMismatch"
    end
    self._retiredGeneration = a2
    self._mapping = nil
    self._config = nil
    self._predictionPacingPolicy = nil
    self._commandClock = nil
    self._topologyRetrySeconds = 0
    self:_clearGenerationState()
    self:_setStatus("WaitingForMapping", "GenerationUnbound")
    return true, nil
end

function u253._bindCollisionSources(a1, a2, a3) -- Line: 670
    a1._timeline = a2
    a1._collisionComposer = a3
end

function u253:_ensureTopology(a2) -- Line: 675
    -- upvalues: defaultMapRoot (val), TopologyBuilder (val), Catalog (val), Config_2 (val)
    local v1, v2
    local _topology = self._topology
    if _topology ~= nil
        and _topology.Epoch == a2.TopologyEpoch
        and _topology.Fingerprint == a2.TopologyFingerprint then
        return true, nil
    end
    local u18 = (self._options.ResolveMapRoot or defaultMapRoot)(a2)
    if u18 == nil then
        return false, "ReplicatedMapUnavailable"
    end
    local _topologyBuild = self._topologyBuild
    if _topologyBuild ~= nil
        and _topologyBuild.Epoch == a2.TopologyEpoch
        and _topologyBuild.Fingerprint == a2.TopologyFingerprint then
        if _topologyBuild.Result == nil and _topologyBuild.Error == nil then
            return false, "TopologyBuilding"
        end
        self._topologyBuild = nil
        if _topologyBuild.Result == nil then
            return false, _topologyBuild.Error
        end
        self._topology = _topologyBuild.Result
        return true, nil
    end
    local Barriers = u18:FindFirstChild("Barriers")
    if Barriers ~= nil then
        v1 = #Barriers:GetDescendants()
        if TopologyBuilder.LargeSourceCount <= v1 then
            local u51 = {Epoch = a2.TopologyEpoch, Fingerprint = a2.TopologyFingerprint}
            self._topologyBuild = u51
            task.spawn(function() -- Line: 715
                -- upvalues: TopologyBuilder (upval), self (val), u51 (val), Catalog (upval), u18 (val)
                -- upvalues: Config_2 (upval)
                local u3 = TopologyBuilder.createFrameYielder(0.008)

                local function yieldIfNeeded() -- Line: 717 -- upvalues: u3 (val), self (upval), u51 (upval)
                    u3()
                    if self._topologyBuild ~= u51 then
                        error("TopologyBuildSuperseded")
                    end
                end

                local success, result = pcall(function() -- Line: 724
                    -- upvalues: Catalog (upval), u18 (upval), self (upval), yieldIfNeeded (val), u51 (upval)
                    -- upvalues: TopologyBuilder (upval), Config_2 (upval)
                    local v1, v2 = Catalog.ReadPublished(u18, self._options.OnWarning, yieldIfNeeded)
                    if v1 == nil then
                        return v2
                    end
                    if v1.Manifest.Epoch == u51.Epoch and v1.Manifest.Fingerprint == u51.Fingerprint then
                        return TopologyBuilder.Build(v1, Config_2.Default, nil, yieldIfNeeded)
                    end
                    return "ReplicatedManifestDoesNotMatchMapping"
                end)
                if not success then
                    u51.Error = ("TopologyBuildFailed: %*"):format(result)
                    return
                end
                if typeof(result) == "string" then
                    u51.Error = result
                    return
                end
                if result.Epoch == u51.Epoch and result.Fingerprint == u51.Fingerprint then
                    u51.Result = result
                    return
                end
                u51.Error = "BuiltTopologyDoesNotMatchMapping"
            end)
            return false, "TopologyBuilding"
        end
    end
    v1, v2 = Catalog.ReadPublished(u18, self._options.OnWarning)
    if v1 == nil then
        return false, v2
    end
    if v1.Manifest.Epoch == a2.TopologyEpoch and v1.Manifest.Fingerprint == a2.TopologyFingerprint then
        local v3 = TopologyBuilder.Build(v1, Config_2.Default)
        if v3.Epoch == a2.TopologyEpoch and v3.Fingerprint == a2.TopologyFingerprint then
            self._topology = v3
            return true, nil
        end
        return false, "BuiltTopologyDoesNotMatchMapping"
    end
    return false, "ReplicatedManifestDoesNotMatchMapping"
end

function u253:_initializeGeneration(a2) -- Line: 765
    -- upvalues: DestructibleTimeline (val), Config (val), PredictionPacing (val), CommandClock (val)
    -- upvalues: CommandStream (val), PredictionRing (val), Reconciler (val)
    self._lastResyncOwnerSnapshot = nil
    local v1, v2 = self:_ensureTopology(a2)
    if not v1 then
        self:_setStatus("WaitingForTopology", v2)
        return false, v2
    end
    local v3 = assert(self._topology)
    self:_disposeTimeline()
    local u26 = DestructibleTimeline.new(a2.SimulationHz, v3.Epoch, v3.DestructibleCount)
    self._timeline = u26
    self._timelineConnection = u26.BaselineNeeded:Connect(function(a1, a2, a3) -- Line: 776 -- upvalues: self (val), u26 (val)
        if self._timeline == u26 then
            self:_sendBaselineRequest(a1, a2, a3)
        end
    end)
    self._config = Config.derive(a2.SimulationHz)
    self._predictionPacingPolicy = PredictionPacing.policyFromConfig(self._config)
    self._commandClock = CommandClock.new(self._config)
    self._lastOwnerCommandFeedback = nil
    self._commandStream = CommandStream.new(a2)
    self._uplink:fillBudget(self._config)
    self._predictionRing = PredictionRing.new(a2)
    self._traceCapture:reset(self._config)
    self._reconciler = Reconciler.new(a2, self._predictionRing)
    self._observerMapping = nil
    self:_ensureRemoteStreams(a2, false)
    self._state = nil
    self._support = nil
    self:_refreshPresentedState()
    self._lastPredictedServerTick = nil
    self._lastWeaponSelectionCommand = nil
    self._pendingReconciliationInstall = nil
    self._lastHistoryRecoveryRequestAt = 0
    self._accumulatorSeconds = 0
    self._topologyRetrySeconds = 0
    table.clear(self._contactActorIds)
    table.clear(self._seenJumpCommands)
    table.clear(self._seenJumpOrder)
    self._lastAuthoritativeJumpCommand = nil
    self:_setStatus("WaitingForBaseline", "InitialDestructibleBaseline")
    return true, nil
end

function u253:retryTopology() -- Line: 810
    local _mapping = self._mapping
    if _mapping == nil then
        return false, "MappingUnavailable"
    end
    if self._timeline ~= nil then
        return true, nil
    end
    local v1, v2 = self:_initializeGeneration(_mapping)
    if v1 then
        self:_drainPendingCollisionControls()
        self:_tryInstallDiscontinuity()
    end
    return v1, v2
end

function u253:_applyMapping(a2) -- Line: 826
    -- upvalues: Mapping (val), Serial (val), Enums (val), clone (val), PlayerContacts (val), RuntimeSettings (val)
    -- upvalues: Config (val), PredictionPacing (val)
    local v1, v2 = Mapping.validate(a2)
    if not v1 then
        self:_warn((("rejected movement mapping: %*"):format(v2)))
        return
    end
    if self._retiredGeneration == a2.Generation then
        return
    end
    local _mapping = self._mapping
    if _mapping ~= nil then
        local v3 = Serial.deltaUInt16(a2.Generation, _mapping.Generation)
        if v3 < 0 then
            return
        end
        if v3 == 0 then
            local v4 = false
            if a2.Generation == _mapping.Generation then
                v4 = false
                if a2.ActorId == _mapping.ActorId then
                    v4 = false
                    if a2.SimulationHz == _mapping.SimulationHz then
                        v4 = false
                        if a2.TopologyEpoch == _mapping.TopologyEpoch then
                            v4 = a2.TopologyFingerprint == _mapping.TopologyFingerprint
                        end
                    end
                end
            end
            if v4 then
                v4 = a2.PlayerCollisionsEnabled ~= _mapping.PlayerCollisionsEnabled
            end
            if not v4 then
                v4 = false
                if a2.Generation == _mapping.Generation then
                    v4 = false
                    if a2.ActorId == _mapping.ActorId then
                        v4 = false
                        if a2.SimulationHz == _mapping.SimulationHz then
                            v4 = false
                            if a2.TopologyEpoch == _mapping.TopologyEpoch then
                                v4 = a2.TopologyFingerprint == _mapping.TopologyFingerprint
                            end
                        end
                    end
                end
                if not v4 then
                    self:_warn("received conflicting mapping for the active generation")
                    self:_sendMappingRequest(a2.Generation)
                    return
                end
                self._requestedMappingGeneration = nil
                self._queuedMappingGeneration = nil
                if self._timeline == nil then
                    self:retryTopology()
                end
                local _lastAcceptedOwnerSnapshot = self._lastAcceptedOwnerSnapshot
                if _lastAcceptedOwnerSnapshot ~= nil and _lastAcceptedOwnerSnapshot.Generation == a2.Generation then
                    self:_sendRecoveryCommands(_lastAcceptedOwnerSnapshot.LastProcessedCommand)
                    return
                end
                self:_sendDueCommands(true)
                return
            end
            local _commandStream = self._commandStream
            local _reconciler = self._reconciler
            if _commandStream ~= nil and _reconciler ~= nil then
                self._mapping = table.freeze(Mapping.clone(a2))
                _commandStream:reconfigure(a2)
                _reconciler:reconfigure(a2)
                self._traceCapture:reset(self._config)
                table.clear(self._contactActorIds)
                self._pendingReconciliationInstall = nil
                self._lastHistoryRecoveryRequestAt = 0
                self._requestedMappingGeneration = nil
                self._queuedMappingGeneration = nil
                self._pendingDiscontinuity = nil
                self._pendingOwnerSnapshot = nil
                local _state = self._state
                local _support = self._support
                if not a2.PlayerCollisionsEnabled
                    and _state ~= nil
                    and _support ~= nil
                    and _support.Kind == Enums.SupportKind.Player then
                    local v5 = clone(_state)
                    v5.Velocity = PlayerContacts.toWorldVelocity(_state.Velocity, _support)
                    v5.OnGround = false
                    v5.GroundNormal = Vector3.new(0, 1, 0)
                    v5.GroundSurfaceFriction = RuntimeSettings.getMovementConfig(a2.SimulationHz).SurfaceFrictionDefault
                    self._state = v5
                    self._support = {
                        SourceId = 0,
                        Anchor = Vector3.new(0, 0, 0),
                        Velocity = Vector3.new(0, 0, 0),
                        Kind = Enums.SupportKind.None,
                    }
                end
                if self:_canPredict() then
                    self:_setStatus("Running", nil)
                    return
                end
                self:_setStatus("WaitingForAuthority", "PlayerCollisionPolicyChanged")
                return
            end
            self._mapping = nil
            self:_applyMapping(a2)
            return
        end
    end
    self:_clearGenerationState()
    self._config = Config.derive(a2.SimulationHz)
    self._predictionPacingPolicy = PredictionPacing.policyFromConfig(self._config)
    if self._commandClock ~= nil then
        self._commandClock:reset()
        self._lastOwnerCommandFeedback = nil
    end
    self._observerMapping = nil
    self._mapping = table.freeze(Mapping.clone(a2))
    self._retiredGeneration = nil
    self._lastPredictionHitchAt = 0
    self._lastOwnerAppliedAt = 0
    table.clear(self._lastWarningAtByMessage)
    self._uplink:resetCounters()
    self._diagnostics:resetGeneration()
    self:_initializeGeneration(a2)
end

function u253:_applyBaseline(a2) -- Line: 928 -- upvalues: OwnerReplay (val)
    local _timeline = self._timeline
    if _timeline == nil then
        self._pendingBaseline = a2
        return false
    end
    local v1, v2, v3 = _timeline:consumeBaseline(a2.ServerTick, a2.Frame)
    if not v1 then
        self:_warn((("rejected destructible baseline: %*"):format(v2)))
        return false
    end
    if v3 then
        OwnerReplay.invalidateWorld(self)
    end
    self._pendingBaseline = nil
    return true
end

function u253:_deferDestructibleDelta(a2, a3) -- Line: 947 -- upvalues: Config (val) -- types: self: table, a3: number
    local _config = self._config or Config.Default
    if not (_config.PredictionReplayTicks <= #self._pendingDeltas) then
        self._pendingDeltas[#self._pendingDeltas + 1] = a2
        return
    end
    table.clear(self._pendingDeltas)
    self:_sendBaselineRequest(a2.Epoch, a3, "PendingDestructibleHistoryOverflow")
end

function u253:_deferMoverDelta(a2) -- Line: 958 -- upvalues: Config (val)
    local _config = self._config or Config.Default
    if not (_config.PredictionReplayTicks <= #self._pendingMoverDeltas) then
        self._pendingMoverDeltas[#self._pendingMoverDeltas + 1] = a2
        return
    end
    table.clear(self._pendingMoverDeltas)
    local _mapping = self._mapping
    if _mapping ~= nil then
        self:_sendMappingRequest(_mapping.Generation)
    end
end

function u253:_applyDelta(a2) -- Line: 971 -- upvalues: OwnerReplay (val), Serial (val)
    OwnerReplay.invalidateWorld(self)
    local _timeline = self._timeline
    if _timeline == nil then
        self:_deferDestructibleDelta(a2, 0)
        return false
    end
    local v1, v2 = _timeline:consumeDelta(a2.Epoch, a2.Revision, a2.ServerTick, a2.Indices)
    if not v1 then
        self:_warn((("rejected destructible delta: %*"):format(v2)))
        return false
    end
    local v3 = if self._predictionRing ~= nil then self._predictionRing:newestCommandNumber() else nil
    local v4 = if v3 ~= nil then self._predictionRing:get(v3) else nil
    local v5 = false
    if v4 ~= nil then
        v5 = 0 <= (Serial.deltaUInt32(v4.ServerTick, a2.ServerTick))
    end
    local v6 = self._pendingDiscontinuity ~= nil
    self:_tryInstallDiscontinuity()
    if self._pendingReconciliationInstall ~= nil then
        return true
    end
    local v7 = v6 and self._pendingDiscontinuity == nil
    local _pendingOwnerSnapshot = self._pendingOwnerSnapshot
    if _pendingOwnerSnapshot ~= nil and self._state ~= nil then
        self._pendingOwnerSnapshot = nil
        v7 = self:_handleOwnerSnapshot(_pendingOwnerSnapshot) or v7
    end
    if v5 and not v7 then
        self:_setStatus("WaitingForAuthority", "DestructibleChangedInsidePrediction")
        local _mapping = self._mapping
        if _mapping ~= nil then
            self:_sendMappingRequest(_mapping.Generation)
        end
    end
    return true
end

function u253:_applyMoverBaseline(a2) -- Line: 1009 -- upvalues: OwnerReplay (val)
    local _collisionComposer = self._collisionComposer
    local _mapping = self._mapping
    if _collisionComposer ~= nil and _mapping ~= nil then
        if a2.Epoch ~= _mapping.TopologyEpoch then
            return false
        end
        local v1, v2, v3, v4, v5 = _collisionComposer:ConsumeBaseline(a2.Epoch, a2.Revision, a2.ServerTick, a2.Descriptors, a2.ProgressAnchors)
        if not v1 then
            self:_warn((("rejected mover baseline: %*"):format(v2)))
            return false
        end
        if v5 ~= false then
            OwnerReplay.invalidateWorld(self)
        end
        if v3 ~= nil then
            self:_queueMoverReplay(v3, a2.Revision, v4)
        end
        self:_applyPendingMoverDeltas()
        if v3 ~= nil and self._state ~= nil then
            return true
        end
        self:_tryInstallDiscontinuity()
        self:_installOwnerSnapshotAfterControls()
        return true
    end
    return false
end

function u253:_applyPendingMoverDeltas() -- Line: 1045
    local _pendingMoverDeltas_2, v1, v2, v3
    local _pendingMoverDeltas = self._pendingMoverDeltas
    self._pendingMoverDeltas = {}
    for i, j in _pendingMoverDeltas do
        if not self:_applyMoverDelta(j) then
            v3 = i + 1
            v2 = #_pendingMoverDeltas
            for k = v3, v2 do
                _pendingMoverDeltas_2 = self._pendingMoverDeltas
                v1 = #self._pendingMoverDeltas + 1
                _pendingMoverDeltas_2[v1] = _pendingMoverDeltas[k]
            end
            return
        end
    end
end

function u253:_markMoverRevisionValidated(a2) -- Line: 1058 -- types: self: table, a2: number
    local _reconciler = self._reconciler
    if _reconciler == nil then
        return false
    end
    local v1, v2 = _reconciler:markMoverRevisionValidated(a2)
    if not v1 then
        self:_warn((("could not validate mover revision: %*"):format(v2 or "unknown")))
    end
    return v1
end

function u253:_applyMoverDelta(a2) -- Line: 1070
    local _collisionComposer = self._collisionComposer
    local _mapping = self._mapping
    if _collisionComposer ~= nil and _mapping ~= nil then
        local v1, v2, v3, v4, v5
        if a2.Epoch ~= _mapping.TopologyEpoch then
            return false
        end
        if a2.Kind ~= "MoverProgress" then
            v4, v5, v1, v2 = _collisionComposer:ConsumeDelta(a2.Epoch, a2.Revision, a2.ServerTick, a2.Descriptors)
        else
            v4, v5, v1, v2 = _collisionComposer:ConsumeProgress(a2.Epoch, a2.Revision, a2.ServerTick, a2.Streams)
        end
        local v6 = v4
        if v5 == "MoverBaselineRequired" then
            self:_deferMoverDelta(a2)
            return false
        end
        if v3 ~= nil then
            self:_warn((("rejected mover delta: %*"):format(v3)))
            self:_sendMappingRequest(_mapping.Generation)
            return false
        end
        if v6 ~= nil then
            self:_queueMoverReplay(v6, a2.Revision, v2)
            return true
        end
        if v1 then
            if self._pendingMoverReplayTick ~= nil then
                self._pendingMoverReplayRevision = a2.Revision
            else
                self:_markMoverRevisionValidated(a2.Revision)
            end
        end
        return true
    end
    self:_deferMoverDelta(a2)
    return false
end

function u253:_queueMoverReplay(a2, a3, a4) -- Line: 1113
    -- upvalues: OwnerReplay (val), Serial (val)
    OwnerReplay.invalidateWorldFromTick(self, a2, a3)
    local _pendingMoverReplayTick = self._pendingMoverReplayTick
    if _pendingMoverReplayTick == nil or (Serial.deltaUInt32(a2, _pendingMoverReplayTick)) < 0 then
        self._pendingMoverReplayTick = a2
    end
    local _pendingMoverReplayRevision = self._pendingMoverReplayRevision
    if _pendingMoverReplayRevision == nil or 0 < (Serial.deltaUInt32(a3, _pendingMoverReplayRevision)) then
        self._pendingMoverReplayRevision = a3
    end
    if a4 ~= nil then
        for i in a4 do
            self._pendingMoverReplayIds[i] = true
        end
    end
end

function u253:_flushPendingMoverReplay() -- Line: 1131 -- upvalues: Serial (val)
    local v1
    local _pendingMoverReplayTick = self._pendingMoverReplayTick
    if _pendingMoverReplayTick == nil then
        return false
    end
    local _pendingMoverReplayRevision = self._pendingMoverReplayRevision
    local _pendingMoverReplayIds = self._pendingMoverReplayIds
    self._pendingMoverReplayTick = nil
    self._pendingMoverReplayRevision = nil
    self._pendingMoverReplayIds = {}
    local _mapping = self._mapping
    if _mapping == nil then
        return false
    end
    local _predictionRing = self._predictionRing
    local v2 = if _predictionRing ~= nil then _predictionRing:newestCommandNumber() else nil
    local v3 = if v2 ~= nil then _predictionRing:get(v2) else nil
    local _collisionComposer = self._collisionComposer
    local v4 = false
    if _predictionRing ~= nil and v3 ~= nil then
        v1 = Serial.deltaUInt32(v3.ServerTick, _pendingMoverReplayTick)
        if v1 >= 0 then
            v1 = true
            if next(_pendingMoverReplayIds) ~= nil then
                v1 = true
                if _collisionComposer ~= nil then
                    v1 = true
                    if type(_collisionComposer.IsPredictionStateAffected) == "function" then
                        v1 = _predictionRing:anyEntryAtOrAfterServerTick(_pendingMoverReplayTick, function(a1) -- Line: 1154 -- upvalues: _collisionComposer (val), _pendingMoverReplayIds (val)
                            return _collisionComposer:IsPredictionStateAffected(_pendingMoverReplayIds, a1.PostState, a1.PostSupport)
                        end)
                    end
                end
            end
            v4 = v1
        end
    end
    if not v4 then
        if _pendingMoverReplayRevision ~= nil then
            self:_markMoverRevisionValidated(_pendingMoverReplayRevision)
        end
        return false
    end
    v1 = self._pendingDiscontinuity ~= nil
    self:_tryInstallDiscontinuity()
    local v5 = v1 and self._pendingDiscontinuity == nil
    local _pendingOwnerSnapshot = self._pendingOwnerSnapshot
    if _pendingOwnerSnapshot ~= nil and self._state ~= nil then
        self._pendingOwnerSnapshot = nil
        v5 = self:_handleOwnerSnapshot(_pendingOwnerSnapshot, true)
        if self._pendingReconciliationInstall ~= nil then
            self._pendingReconciliationInstall.MoverRevisionToValidate = _pendingMoverReplayRevision
            return true
        end
    end
    if v4 and not v5 then
        local _lastAcceptedOwnerSnapshot = self._lastAcceptedOwnerSnapshot
        if _lastAcceptedOwnerSnapshot ~= nil then
            local v6, v7 = self:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, nil, nil, _pendingMoverReplayTick)
            v5 = v6
            if v7 == "ReplayPending" then
                local _pendingReconciliationInstall = self._pendingReconciliationInstall
                if _pendingReconciliationInstall ~= nil then
                    _pendingReconciliationInstall.MoverRevisionToValidate = _pendingMoverReplayRevision
                end
                return true
            end
        end
        if not v5 then
            self:_setStatus("WaitingForAuthority", "MoverChangedBeforePredictedTail")
            self:_sendMappingRequest(_mapping.Generation)
        end
    end
    if v5 and _pendingMoverReplayRevision ~= nil then
        self:_markMoverRevisionValidated(_pendingMoverReplayRevision)
    end
    return v5
end

function u253:_applyDamageTagForStep(a2) -- Line: 1202 -- upvalues: Serial (val), clone (val), DamageTag (val)
    local v1 = self._damageTagsByMovementTick[(Serial.addUInt32(a2.MovementTick, 1))]
    if v1 == nil then
        return a2
    end
    local v2 = clone(a2)
    v2.VelocityModifier = DamageTag.apply(v2.VelocityModifier, v1)
    return v2
end

function u253:_stateForCommand(a2, a3, a4, a5) -- Line: 1213
    -- upvalues: forCommand (val), ActionLockTimeline (val)
    return forCommand(a2, a3, a4, self._options.ResolveBaseMoveSpeed, a5, ActionLockTimeline.isLockedAt(self._actionLocks, a4))
end

function u253:_pruneDamageTagsThrough(a2) -- Line: 1229 -- upvalues: Serial (val) -- types: self: table, a2: number
    for i in self._damageTagsByMovementTick do
        if 0 <= (Serial.deltaUInt32(a2, i)) then
            self._damageTagsByMovementTick[i] = nil
        end
    end
    local _pendingDamageTagReplayMovementTick = self._pendingDamageTagReplayMovementTick
    if _pendingDamageTagReplayMovementTick ~= nil
        and 0 <= (Serial.deltaUInt32(a2, _pendingDamageTagReplayMovementTick)) then
        self._pendingDamageTagReplayMovementTick = nil
    end
end

function u253:_queueDamageTag(a2) -- Line: 1241 -- upvalues: Serial (val), DamageTag (val)
    local _mapping = self._mapping
    if _mapping ~= nil and a2.Generation == _mapping.Generation then
        local _lastAcceptedOwnerSnapshot = self._lastAcceptedOwnerSnapshot
        if _lastAcceptedOwnerSnapshot ~= nil
            and 0 <= (Serial.deltaUInt32(_lastAcceptedOwnerSnapshot.State.MovementTick, a2.ApplyMovementTick)) then
            return
        end
        local v1 = self._damageTagsByMovementTick[a2.ApplyMovementTick]
        local VelocityModifier = if v1 ~= nil then DamageTag.apply(v1, a2.VelocityModifier) else a2.VelocityModifier
        if v1 == VelocityModifier then
            return
        end
        self._damageTagsByMovementTick[a2.ApplyMovementTick] = VelocityModifier
        local _reconciler = self._reconciler
        if _reconciler ~= nil then
            _reconciler:invalidatePendingReplayFromMovementTick(a2.ApplyMovementTick)
        end
        local MovementTick = if self._state ~= nil then self._state.MovementTick else nil
        if MovementTick ~= nil and not ((Serial.deltaUInt32(MovementTick, a2.ApplyMovementTick)) < 0) then
            local _pendingDamageTagReplayMovementTick = self._pendingDamageTagReplayMovementTick
            local MovementTick_2 = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.State.MovementTick else _pendingDamageTagReplayMovementTick
            if _pendingDamageTagReplayMovementTick == nil
                or MovementTick_2 == nil
                or (Serial.deltaUInt32(a2.ApplyMovementTick, MovementTick_2)) < Serial.deltaUInt32(_pendingDamageTagReplayMovementTick, MovementTick_2) then
                self._pendingDamageTagReplayMovementTick = a2.ApplyMovementTick
            end
            return
        end
        return
    end
    if self._retiredGeneration ~= a2.Generation then
        self:_sendMappingRequest(a2.Generation)
    end
end

function u253._flushPendingDamageTagReplay(a1) -- Line: 1286 -- upvalues: DamageTagReplay (val)
    return DamageTagReplay.flush(a1)
end

function u253:_drainPendingCollisionControls() -- Line: 1290
    if self._pendingReconciliationInstall ~= nil then
        return
    end
    local _pendingBaseline = self._pendingBaseline
    if _pendingBaseline ~= nil and not self:_applyBaseline(_pendingBaseline) then
        return
    end
    if self._timeline ~= nil and not self._timeline:needsBaseline() then
        local _pendingDeltas_2, v1, v2, v3, v4
        local _pendingDeltas = self._pendingDeltas
        self._pendingDeltas = {}
        for i, j in _pendingDeltas do
            if self:_applyDelta(j) and self._pendingReconciliationInstall == nil then
                continue
            end
            v2 = i + 1
            v4 = #_pendingDeltas
            for k = v2, v4 do
                _pendingDeltas_2 = self._pendingDeltas
                v3 = #self._pendingDeltas + 1
                _pendingDeltas_2[v3] = _pendingDeltas[k]
            end
            if self._pendingReconciliationInstall ~= nil then
                return
            end
            v1 = self
            break
        end
        local _pendingMoverBaseline = v1._pendingMoverBaseline
        if _pendingMoverBaseline ~= nil then
            v1._pendingMoverBaseline = nil
            v1:_applyMoverBaseline(_pendingMoverBaseline)
            if v1._pendingReconciliationInstall ~= nil then
                return
            end
        end
        v1:_applyPendingMoverDeltas()
        v1:_flushPendingMoverReplay()
        v1:_tryInstallDiscontinuity()
        v1:_installOwnerSnapshotAfterControls()
        return
    end
end

function u253:_installOwnerSnapshotAfterControls() -- Line: 1330
    local _pendingOwnerSnapshot = self._pendingOwnerSnapshot
    if _pendingOwnerSnapshot ~= nil
        and self._state ~= nil
        and self:_remoteContactFrameReady(_pendingOwnerSnapshot) then
        self._pendingOwnerSnapshot = nil
        self:_handleOwnerSnapshot(_pendingOwnerSnapshot)
    end
end

function u253:_remoteContactFrameReady(a2) -- Line: 1339 -- upvalues: Serial (val)
    local _mapping = self._mapping
    if _mapping ~= nil and _mapping.PlayerCollisionsEnabled then
        local _remoteBuffer = self._remoteBuffer
        local v1 = if _remoteBuffer ~= nil then _remoteBuffer:latestCompleteServerTick() else nil
        local v2 = false
        if v1 ~= nil then
            v2 = 0 <= (Serial.deltaUInt32(v1, a2.ServerTick))
        end
        return v2
    end
    return true
end

function u253._composeWorld(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 1349
    -- upvalues: WorldComposer (val)
    return WorldComposer.compose(a1, a2, a3, a4, a5, a6, a7, a8)
end

function u253:_resolveSupportMotion(a2, a3, a4, a5) -- Line: 1370 -- upvalues: Enums (val), PlayerContactAdapter (val)
    local _remoteBuffer = a5 or self._remoteBuffer
    if _remoteBuffer ~= nil and a4.Kind == Enums.SupportKind.Player then
        return PlayerContactAdapter.resolvePlayerSupportMotion(a3, a4, _remoteBuffer, a2.ServerTick, assert(self._config).StepSeconds)
    end
    local ResolveSupportMotion = a2.Composed.ResolveSupportMotion
    if ResolveSupportMotion == nil then
        return nil
    end
    return (ResolveSupportMotion(a4))
end

function u253:_simulate(a2, a3, a4, a5, a6, a7) -- Line: 1390
    -- upvalues: RuntimeSettings (val), PlayerContactAdapter (val), Simulation (val), DeterminismTrace (val)
    local v1 = assert(self._config)
    local v2 = assert(self._mapping)
    local v3 = a7 or assert(self._remoteBuffer)
    local v4 = self:_resolveSupportMotion(a5, a2, a3, a7)
    local v5 = RuntimeSettings.getMovementConfig(v1.SimulationHz)
    local v6, v7 = PlayerContactAdapter.bindStanceProbe(v2, a5.ServerTick, v3, v5)
    local v8, v9, v10 = Simulation.step(a2, a3, a4, v1.StepSeconds, a5.Composed.Query, v4, v5, a6, v6)
    if not v2.PlayerCollisionsEnabled then
        DeterminismTrace.checkpoint(a6, "runtime.playerContacts.final", v8, v9, nil)
        self._traceCapture:finish(a6)
        return v8, v9, v10, {}, 0, false, (Vector3.new(0, 0, 0))
    end
    local Position = v8.Position
    local v11 = PlayerContactAdapter.solve(a2, a3, v8, v9, v10, v2, a5.ServerTick, v3, a5.Composed.Query, a5.Composed.CanOccupyAtEnd, v5, a6)
    if v7 ~= nil then
        for i in v7 do
            v11.ContactActorIds[i] = true
            v11.NearbyPlayer = true
        end
    end
    DeterminismTrace.checkpoint(a6, "runtime.playerContacts.final", v11.State, v11.Support, nil)
    self._traceCapture:finish(a6)
    return v11.State, v11.Support, v11.Events, v11.ContactActorIds, v11.ExternalDisplacement, v11.NearbyPlayer, v11.State.Position - Position
end

local function predictionDependencyMask(a1, a2, a3, a4, a5, a6, a7) -- Line: 1453
    -- upvalues: Enums (val), PredictionRing (val)
    local v1 = 0
    if a4.Kind == Enums.SupportKind.Player or a5.Kind == Enums.SupportKind.Player or next(a6) ~= nil or a7 then
        v1 = bit32.bor(v1, PredictionRing.Dependency.Player)
    end
    local MoverSensitiveAt = a1.Composed.MoverSensitiveAt
    if MoverSensitiveAt ~= nil then
        if MoverSensitiveAt(a2.Position, a2.Stance) or MoverSensitiveAt(a3.Position, a3.Stance) then
            v1 = bit32.bor(v1, PredictionRing.Dependency.Mover)
        end
    end
    return v1
end

function u253:_rememberJumpEvent(a2) -- Line: 1484 -- upvalues: Serial (val) -- types: self: table, a2: number
    if Serial.isUInt32(a2) and a2 ~= Serial.UInt32Max then
        if self._seenJumpCommands[a2] then
            return false
        end
        self._seenJumpCommands[a2] = true
        local _seenJumpOrder = self._seenJumpOrder
        _seenJumpOrder[#_seenJumpOrder + 1] = a2
        if #_seenJumpOrder > 64 then
            local v1 = table.remove(_seenJumpOrder, 1)
            if v1 ~= self._lastAuthoritativeJumpCommand then
                self._seenJumpCommands[v1] = nil
            end
        end
        return true
    end
    return false
end

function u253:_dispatchStepEvents(a2, a3) -- Line: 1503 -- types: self: table, a3: number
    if a2.Jumped and not self:_rememberJumpEvent(a3) then
        a2.Jumped = false
    end
    local OnStepEvents = self._options.OnStepEvents
    if OnStepEvents ~= nil then
        OnStepEvents(a2, self:_presentationContext())
    end
end

function u253:_recoverAuthoritativeJump(a2) -- Line: 1514 -- upvalues: Serial (val)
    local LastJumpCommandNumber = a2.State.LastJumpCommandNumber
    if LastJumpCommandNumber ~= Serial.UInt32Max and LastJumpCommandNumber ~= self._lastAuthoritativeJumpCommand then
        self._lastAuthoritativeJumpCommand = LastJumpCommandNumber
        if self._seenJumpCommands[LastJumpCommandNumber] then
            return
        end
        self:_dispatchStepEvents({
            Jumped = true,
            Landed = false,
            LeftGround = true,
            Blocked = false,
            StartSolid = false,
        }, LastJumpCommandNumber)
        return
    end
end

local function simulateReplayStep(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 1534
    -- upvalues: serverTimeAtTick (val), predictionDependencyMask (val)
    local v1, v2, v3, v4
    local v5 = a1._traceCapture:begin(a2, a6.CommandNumber, a7.ServerTick)
    local v6 = serverTimeAtTick(a3, a7.ServerTick, assert(a1._config).StepSeconds)
    local v7 = a1:_stateForCommand(a1:_applyDamageTagForStep(a4), a6, v6, true)
    v1, v2, _, v3, _, v4 = a1:_simulate(v7, a5, a6, a7, v5, a8)
    return v1, v2, (predictionDependencyMask(a7, v7, v1, a5, v2, v3, v4)), v3
end

function u253:_commitSnapshotInstall(a2, a3, a4, a5, a6) -- Line: 1556
    -- upvalues: annotateReconciliation (val), RootFrame (val), clone (val), cloneSupport (val), Serial (val)
    local _state = self._state
    local _support = self._support
    local _lastPredictedServerTick = self._lastPredictedServerTick
    local _lastAcceptedOwnerSnapshot = self._lastAcceptedOwnerSnapshot
    a3.Metrics.PlayerContactCorrection = a5
    annotateReconciliation(a3.Metrics, a3, a2, a4, _state, _support, _lastPredictedServerTick, _lastAcceptedOwnerSnapshot)
    self._traceCapture:onSnapshotCommitted(a2, a4, a3.Metrics, (self._diagnostics:reportingEnabled()))
    local v1 = self:_canPredict()
    local v2 = math.clamp(self._accumulatorSeconds / assert(self._config).StepSeconds, 0, 1)
    local Position = if self._presentedState == nil or self._previousPresentedState == nil then nil else (RootFrame.cframe(self._previousPresentedState)):Lerp(RootFrame.cframe(self._presentedState), v2).Position
    self._state = a3.State
    self._support = a3.Support
    local v3 = if _state ~= nil then math.abs((math.atan2(math.sin(a3.State.LookYaw - _state.LookYaw), (math.cos(a3.State.LookYaw - _state.LookYaw))))) else (1 / 0)
    local v4 = true
    if _state ~= nil then
        v4 = true
        if not (0.0001 < (a3.State.Position - _state.Position).Magnitude) then
            v4 = true
            if a3.State.Stance == _state.Stance then
                v4 = v3 > 0.0001
            end
        end
    end
    if _state == nil or self._presentedState == nil or self._previousPresentedState == nil then
        self:_refreshPresentedState()
    elseif v4 then
        local v5 = clone(self._previousPresentedState)
        v5.Position = v5.Position + (a3.State.Position - _state.Position)
        v5.LookYaw = v5.LookYaw + (a3.State.LookYaw - _state.LookYaw)
        self:_refreshPresentedState(v5)
    elseif a3.Metrics.ReconciliationMode ~= "Reuse" then
        self._presentedState = clone(a3.State)
        self._presentedSupport = cloneSupport(a3.Support)
    end
    if Position ~= nil then
        local Position_2 = ((RootFrame.cframe((assert(self._previousPresentedState)))):Lerp(RootFrame.cframe(assert(self._presentedState)), v2)).Position
        a3.Metrics.PresentationPositionDelta = Position_2 - Position
    end
    self._lastPredictedServerTick = a3.TailServerTick
    self._contactActorIds = a6
    self._lastAcceptedOwnerSnapshot = a2
    self:_pruneDamageTagsThrough(a2.State.MovementTick)
    local _pendingDamageTagReplayMovementTick = self._pendingDamageTagReplayMovementTick
    if 0 < a3.ReplayCount
        and _pendingDamageTagReplayMovementTick ~= nil
        and 0 <= (Serial.deltaUInt32(a3.State.MovementTick, _pendingDamageTagReplayMovementTick)) then
        self._pendingDamageTagReplayMovementTick = nil
    end
    local _pendingCommandResyncThrough = self._pendingCommandResyncThrough
    if _pendingCommandResyncThrough ~= nil
        and 0 <= (Serial.deltaUInt32(a2.LastProcessedCommand, _pendingCommandResyncThrough)) then
        self._pendingCommandResyncThrough = nil
        self._commandResyncRequestedAt = 0
    end
    self:_recoverAuthoritativeJump(a2)
    self._lastOwnerAppliedAt = os.clock()
    self._uplink:onOwnerApplied(a2.LastProcessedCommand)
    self._diagnostics:recordOwnerApplied(a2, a3, a4)
    if not v1 then
        self._accumulatorSeconds = math.min(self._accumulatorSeconds, (assert(self._config)).StepSeconds * 0.999999)
        self._discardNextAdvanceDelta = true
    end
    self:_setStatus("Running", nil)
    local OnReconciled = self._options.OnReconciled
    if OnReconciled ~= nil then
        OnReconciled(a3.Metrics, self:_presentationContext())
    end
    return true, nil
end

function u253:_installSnapshot(a2, a3, a4, a5, a6, a7) -- Line: 1659
    -- upvalues: OwnerRecovery (val), OwnerReplay (val), Serial (val), simulateReplayStep (val), serverTimeAtTick (val)
    local _mapping = self._mapping
    local _timeline = self._timeline
    local _reconciler = self._reconciler
    local _commandStream = self._commandStream
    if _mapping ~= nil and _timeline ~= nil and _reconciler ~= nil and _commandStream ~= nil then
        if a2.Generation ~= _mapping.Generation then
            return false, "GenerationMismatch"
        end
        if a2.Topology.Epoch == _mapping.TopologyEpoch
            and a2.Topology.Fingerprint == _mapping.TopologyFingerprint then
            local v1, v2
            if not a3 and not a4 then
                v1, v2 = OwnerRecovery.prepare(self, a2)
                if not v1 then
                    return false, v2
                end
            end
            if a4 and a7 == nil then
                _reconciler:discardReplayContinuation()
            end
            v1 = OwnerReplay.checkWorld(self, a2, if not a4 then nil else a7)
            if v1 ~= nil then
                return false, v1
            end
            if a3 then
                if a2.LastProcessedCommand ~= Serial.UInt32Max then
                    self:_sendMappingRequest(_mapping.Generation)
                    return false, "InitialDiscontinuityDoesNotPrecedeCommandZero"
                end
                _commandStream:reset(_mapping)
                _reconciler:reset(_mapping)
            end
            v2 = self._predictionRing and self._predictionRing:get(a2.LastProcessedCommand) or nil
            local v3 = self:_playerContactNearStateAtTick(a2.State, a2.ServerTick)
            if not v3 then
                v3 = false
                if v2 ~= nil then
                    v3 = self:_playerContactNearStateAtTick(v2.PostState, a2.ServerTick)
                end
            end
            local u109 = {}
            local u110 = nil
            local u111 = nil
            local v4 = {WorkSeconds = 0, SliceCount = 0, MaximumSliceSeconds = 0, StartedAt = os.clock()}
            local StartedAt = v4.StartedAt
            debug.profilebegin("MovementV2.Client.ReconciliationReplay")
            local _reconciliationReplayBudget = self._reconciliationReplayBudget
            local v5, v6 = _reconciler:accept(a2, function(a1, a2, a3) -- Line: 1716 -- upvalues: u110 (ref), _mapping (val), self (val), u111 (ref)
                if u110 == nil then
                    if _mapping.PlayerCollisionsEnabled or self._collisionComposer ~= nil then
                        u110 = assert(self._remoteBuffer):captureCollisionFrame()
                    end
                end
                local _collisionComposer = self._collisionComposer
                if u111 == nil
                    and _collisionComposer ~= nil
                    and type(_collisionComposer.ForkPrediction) == "function" then
                    u111 = _collisionComposer:ForkPrediction()
                end
                local v1, v2 = self:_composeWorld(a1, nil, nil, a3, nil, u110, u111)
                if v1 == nil then
                    return nil, nil, v2
                end
                return v1, v1.Destructibles.Revision, nil
            end, function(a1, a2_2, a3, a4, a5, a6, a7) -- Line: 1732
                -- upvalues: simulateReplayStep (upval), self (val), _mapping (val), a2 (val), u110 (ref), u109 (ref)
                local v1, v2, v3, v4 = simulateReplayStep(self, _mapping.Generation, a2, a1, a2_2, a3, a7, u110)
                u109 = v4
                return v1, v2, v3
            end, a4, v3, _reconciliationReplayBudget, a5, a7, function(a1, a2_2, a3) -- Line: 1751 -- upvalues: serverTimeAtTick (upval), a2 (val), self (val)
                return self:_stateForCommand(a1, a2_2, serverTimeAtTick(a2, a3, assert(self._config).StepSeconds), true) == a1
            end)
            debug.profileend()
            local v7 = math.max(os.clock() - StartedAt, 0)
            v4.WorkSeconds = v4.WorkSeconds + v7
            v4.SliceCount = v4.SliceCount + 1
            v4.MaximumSliceSeconds = math.max(v4.MaximumSliceSeconds, v7)
            if v5 == nil then
                if v6 == "ReplayPending" then
                    self._pendingReconciliationInstall = {
                        Snapshot = a2,
                        PredictedAtAck = v2,
                        PlayerContactAtAck = v3,
                        Timing = v4,
                        CollisionFrame = u110,
                        CollisionComposer = u111,
                        FreshCollisionFrames = {},
                    }
                    if a6 ~= nil then
                        a6()
                    end
                end
                return false, v6
            end
            if u111 ~= nil then
                self._collisionComposer:CommitPrediction(u111)
            end
            if a6 ~= nil then
                a6()
            end
            local Metrics = v5.Metrics
            Metrics.ReconciliationWorkSeconds = v4.WorkSeconds
            Metrics.ReconciliationElapsedSeconds = math.max(os.clock() - v4.StartedAt, v4.WorkSeconds)
            Metrics.ReconciliationSliceCount = v4.SliceCount
            Metrics.ReconciliationMaximumSliceSeconds = v4.MaximumSliceSeconds
            return (self:_commitSnapshotInstall(a2, v5, v2, v3, u109))
        end
        return false, "TopologyMismatch"
    end
    return false, "GenerationContextUnavailable"
end

function u253:_resumePendingReconciliation() -- Line: 1786
    -- upvalues: OwnerReplay (val), simulateReplayStep (val), Serial (val)
    local v1, v2, v3 = OwnerReplay.tryAdvance(self)
    if v1 then
        return v2 == true, v3
    end
    local _pendingReconciliationInstall = self._pendingReconciliationInstall
    local _reconciler = self._reconciler
    local _mapping = self._mapping
    if _pendingReconciliationInstall ~= nil and _reconciler ~= nil and _mapping ~= nil then
        local v4
        if _pendingReconciliationInstall.Snapshot.Generation ~= _mapping.Generation then
            _reconciler:cancelPendingReplay()
            self._pendingReconciliationInstall = nil
            return false, "GenerationMismatch"
        end
        local u24 = {}
        local v5 = os.clock()
        debug.profilebegin("MovementV2.Client.ReconciliationReplay")
        local _reconciliationReplayBudget = self._reconciliationReplayBudget
        local v6, v7 = _reconciler:resume(function(a1, a2, a3, a4, a5) -- Line: 1806 -- upvalues: _pendingReconciliationInstall (val), self (val)
            local v1, v2 = self:_composeWorld(
                a1,
                nil,
                nil,
                a3,
                nil,
                _pendingReconciliationInstall.FreshCollisionFrames[a5] or _pendingReconciliationInstall.CollisionFrame,
                _pendingReconciliationInstall.CollisionComposer
            )
            if v1 == nil then
                return nil, nil, v2
            end
            return v1, v1.Destructibles.Revision, nil
        end, function(a1, a2, a3, a4, a5, a6, a7) -- Line: 1814
            -- upvalues: simulateReplayStep (upval), self (val), _mapping (val), _pendingReconciliationInstall (val)
            -- upvalues: u24 (ref)
            local v1, v2, v3, v4 = simulateReplayStep(
                self,
                _mapping.Generation,
                _pendingReconciliationInstall.Snapshot,
                a1,
                a2,
                a3,
                a7,
                _pendingReconciliationInstall.FreshCollisionFrames[a3.CommandNumber] or _pendingReconciliationInstall.CollisionFrame
            )
            u24 = v4
            return v1, v2, v3
        end, _reconciliationReplayBudget)
        debug.profileend()
        local Timing = _pendingReconciliationInstall.Timing
        local v8 = math.max(os.clock() - v5, 0)
        Timing.WorkSeconds = Timing.WorkSeconds + v8
        Timing.SliceCount = Timing.SliceCount + 1
        Timing.MaximumSliceSeconds = math.max(Timing.MaximumSliceSeconds, v8)
        if v6 == nil then
            if v7 ~= "ReplayPending" then
                _reconciler:cancelPendingReplay()
                self._pendingReconciliationInstall = nil
                return false, v7
            end
            v4 = _reconciler:retiredReplayCommandNumber()
            if v4 ~= nil and v4 ~= _pendingReconciliationInstall.CollisionFramesRetiredThrough then
                for i in _pendingReconciliationInstall.FreshCollisionFrames do
                    if (Serial.deltaUInt32(i, v4)) <= 0 then
                        _pendingReconciliationInstall.FreshCollisionFrames[i] = nil
                    end
                end
                _pendingReconciliationInstall.CollisionFramesRetiredThrough = v4
            end
            return false, v7
        end
        self._pendingReconciliationInstall = nil
        if _pendingReconciliationInstall.CollisionComposer ~= nil then
            self._collisionComposer:CommitPrediction(_pendingReconciliationInstall.CollisionComposer)
        end
        local Metrics = v6.Metrics
        local Timing_2 = _pendingReconciliationInstall.Timing
        Metrics.ReconciliationWorkSeconds = Timing_2.WorkSeconds
        Metrics.ReconciliationElapsedSeconds = math.max(os.clock() - Timing_2.StartedAt, Timing_2.WorkSeconds)
        Metrics.ReconciliationSliceCount = Timing_2.SliceCount
        Metrics.ReconciliationMaximumSliceSeconds = Timing_2.MaximumSliceSeconds
        v4, v8 = self:_commitSnapshotInstall(
            _pendingReconciliationInstall.Snapshot,
            v6,
            _pendingReconciliationInstall.PredictedAtAck,
            _pendingReconciliationInstall.PlayerContactAtAck,
            u24
        )
        if v4 and self._pendingDiscontinuity == _pendingReconciliationInstall.Snapshot then
            self._pendingDiscontinuity = nil
        end
        if v4 and _pendingReconciliationInstall.MoverRevisionToValidate ~= nil then
            self:_markMoverRevisionValidated(_pendingReconciliationInstall.MoverRevisionToValidate)
        end
        return v4, v8
    end
    return false, "ReconciliationReplayUnavailable"
end

function u253:_tryInstallDiscontinuity() -- Line: 1869
    if self._pendingReconciliationInstall ~= nil then
        return
    end
    local _pendingDiscontinuity = self._pendingDiscontinuity
    if _pendingDiscontinuity == nil then
        if self._state == nil and self._timeline ~= nil and not self._timeline:needsBaseline() then
            self:_setStatus("WaitingForState", "ReliableDiscontinuityUnavailable")
        end
        return
    end
    local v1, v2 = self:_installSnapshot(_pendingDiscontinuity, self._state == nil)
    if v1 then
        self._pendingDiscontinuity = nil
        self:_installOwnerSnapshotAfterControls()
        return
    end
    if v2 == "SnapshotNotNewer" then
        self._pendingDiscontinuity = nil
        return
    end
    if v2 == "ReplayPending" then
        return
    end
    if v2 ~= "CommandLeadResync"
        and v2 ~= "BaselineRequired"
        and v2 ~= "DestructibleFrameOutsideRetention"
        and v2 ~= "DestructibleRevisionMismatch"
        and v2 ~= "MoverBaselineRequired"
        and v2 ~= "MoverRevisionUnavailable"
        and v2 ~= "MoverFrameOutsideRetention"
        and v2 ~= "GenerationContextUnavailable" then
        self:_warn((("could not install reliable discontinuity: %*"):format(v2)))
    end
end

function u253:_handleOwnerSnapshot(a2, a3) -- Line: 1902
    -- upvalues: OwnerCommandFeedback (val)
    local _mapping = self._mapping
    if _mapping ~= nil and a2.Generation == _mapping.Generation then
        OwnerCommandFeedback.observe(self, a2, os.clock())
        if self._pendingReconciliationInstall ~= nil then
            self:_queueOwnerSnapshot(a2)
            return false
        end
        if self._state == nil then
            self._pendingOwnerSnapshot = a2
            self:_sendMappingRequest(a2.Generation)
            return false
        end
        local v1, v2 = self:_installSnapshot(a2, false, nil, a3)
        if v1 then
            return true
        end
        if v2 ~= "SnapshotNotNewer"
            and v2 ~= "CommandLeadResync"
            and v2 ~= "DestructibleFrameOutsideRetention"
            and v2 ~= "ReplayPending" then
            if v2 == "BaselineRequired" then
                self._pendingOwnerSnapshot = a2
                self:_setStatus("WaitingForBaseline", v2)
            elseif v2 == "DestructibleRevisionMismatch" then
                self._pendingOwnerSnapshot = a2
                self:_setStatus("WaitingForAuthority", "AwaitingDestructibleDelta")
            elseif v2 == "MoverBaselineRequired" or v2 == "MoverRevisionUnavailable" then
                self._pendingOwnerSnapshot = a2
                self:_setStatus("WaitingForAuthority", "AwaitingMoverDescriptor")
            elseif v2 ~= "MoverFrameOutsideRetention" then
                self:_warn((("rejected owner snapshot: %*"):format(v2)))
            else
                self:_sendMappingRequest(_mapping.Generation)
            end
            return false
        end
        return false
    end
    self:_sendMappingRequest(a2.Generation)
    return false
end

function u253:_queueOwnerSnapshot(a2) -- Line: 1948
    -- upvalues: OwnerCommandFeedback (val), OwnerRecovery (val), Serial (val)
    OwnerCommandFeedback.observe(self, a2, os.clock())
    OwnerRecovery.observe(self, a2)
    local _pendingOwnerSnapshot = self._pendingOwnerSnapshot
    if _pendingOwnerSnapshot == nil
        or _pendingOwnerSnapshot.Generation ~= a2.Generation
        or Serial.isNewerUInt32(a2.Sequence, _pendingOwnerSnapshot.Sequence) then
        self._pendingOwnerSnapshot = a2
    end
end

function u253:_ensureObserverRemoteStreams(a2) -- Line: 1962 -- upvalues: Config (val), Mapping (val)
    if self._mapping ~= nil then
        return false
    end
    local _observerMapping = self._observerMapping
    local _remoteBuffer = self._remoteBuffer
    if _observerMapping ~= nil
        and _remoteBuffer ~= nil
        and self._remoteClock ~= nil
        and _remoteBuffer:sharesStream(_observerMapping)
        and _observerMapping.TopologyEpoch == a2.Topology.Epoch
        and _observerMapping.TopologyFingerprint == a2.Topology.Fingerprint then
        return true
    end
    local v1 = {
        Generation = 65535,
        ActorId = 4294967295,
        PlayerCollisionsEnabled = false,
        SimulationHz = Config.DefaultSimulationHz,
        TopologyEpoch = a2.Topology.Epoch,
        TopologyFingerprint = a2.Topology.Fingerprint,
    }
    local v2, v3 = Mapping.validate(v1)
    if not v2 then
        self:_warn((("could not derive observer remote mapping: %*"):format(v3)))
        return false
    end
    self._observerMapping = table.freeze(v1)
    self:_ensureRemoteStreams(v1, true)
    return true
end

function u253:_ensureRemoteStreams(a2, a3) -- Line: 2000
    -- upvalues: Players (val), RemoteBuffer (val), RemoteClock (val), Config (val)
    local _remoteBuffer = self._remoteBuffer
    local _remoteClock = self._remoteClock
    if _remoteBuffer ~= nil and _remoteClock ~= nil and _remoteBuffer:sharesStream(a2) then
        _remoteBuffer:forgetActor(Players.LocalPlayer.UserId)
        _remoteClock:setSpectator(a3)
        return
    end
    self._remoteBuffer = RemoteBuffer.new(a2)
    self._remoteClock = RemoteClock.new(Config.derive(a2.SimulationHz), a3)
end

function u253:_applyRemoteSnapshot(a2) -- Line: 2012
    local v1
    local _mapping = self._mapping
    local _remoteBuffer = self._remoteBuffer
    if _mapping == nil then
        local v2
        if not self:_ensureObserverRemoteStreams(a2) then
            return
        end
        local v3 = assert(self._remoteBuffer)
        _, v2 = v3:pushDecoded(a2)
        v1 = v3:latestServerTick()
        if v2 == nil and v1 ~= nil then
            local _remoteClock = self._remoteClock
            if _remoteClock ~= nil then
                _remoteClock:observe(v1, (os.clock()))
            end
        end
        return
    end
    if _remoteBuffer ~= nil
        and _remoteBuffer:sharesStream(_mapping)
        and a2.Topology.Epoch == _mapping.TopologyEpoch
        and a2.Topology.Fingerprint == _mapping.TopologyFingerprint then
        local v4
        _, v4 = _remoteBuffer:pushDecoded(a2)
        if v4 == nil then
            local _remoteClock_2 = self._remoteClock
            v1 = _remoteBuffer:latestServerTick()
            if _remoteClock_2 ~= nil and v1 ~= nil then
                _remoteClock_2:observe(v1, (os.clock()))
            end
        end
        if v4 == "RemoteBaselineRequired" then
            self._diagnostics:recordRemoteRejected(v4)
            return
        end
        if v4 ~= nil
            and v4 ~= "DuplicateRemoteChunk"
            and v4 ~= "RemoteSnapshotTooOld"
            and v4 ~= "RemoteDeltaHeld" then
            self._diagnostics:recordRemoteRejected(v4)
            self:_warn((("rejected remote snapshot: %*"):format(v4)))
        end
        return
    end
end

function u253:_handleRemoteSnapshot(a2) -- Line: 2062 -- upvalues: RemoteSnapshotCodec (val)
    local v1 = RemoteSnapshotCodec.decode(a2)
    if v1 == nil then
        return
    end
    self._diagnostics:recordRemoteSnapshot(v1.Sequence)
    local _mapping = self._mapping
    if _mapping ~= nil then
        local OnRemoteSnapshotReceived = self._options.OnRemoteSnapshotReceived
        if OnRemoteSnapshotReceived ~= nil then
            OnRemoteSnapshotReceived(_mapping.Generation, v1.Sequence, {
                Bytes = buffer.len(a2),
                Kind = v1.Kind,
                FullActorCount = #v1.Actors,
                DeltaActorCount = #v1.Deltas,
                RemovedActorCount = #v1.RemovedActorIds,
                ChunkCount = v1.ChunkCount,
            })
        end
    end
    self:_applyRemoteSnapshot(v1)
end

function u253:_handleControl(a2) -- Line: 2085
    -- upvalues: ControlCodec (val), ActionLockReplay (val), OwnerRecovery (val)
    local v1, v2 = ControlCodec.decode(a2)
    if v1 == nil then
        self:_warn((("rejected movement control: %*"):format(v2)))
        return
    end
    if v1.Kind == "Mapping" then
        self:_applyMapping(v1.Mapping)
        return
    end
    if v1.Kind == "GenerationUnbound" then
        self:retireGeneration(v1.Generation)
        return
    end
    if v1.Kind == "DamageTag" then
        self:_queueDamageTag(v1)
        return
    end
    if v1.Kind == "ActionLocks" then
        ActionLockReplay.queue(self, v1)
        return
    end
    local v3 = self._pendingReconciliationInstall ~= nil
    if not v3 then
        v3 = true
        if self._pendingMoverBaseline == nil then
            v3 = #self._pendingMoverDeltas > 0
        end
    end
    if v1.Kind == "Discontinuity" then
        local _mapping = self._mapping
        local OnOwnerSnapshotReceived = self._options.OnOwnerSnapshotReceived
        if OnOwnerSnapshotReceived ~= nil and _mapping ~= nil and v1.Snapshot.Generation == _mapping.Generation then
            OnOwnerSnapshotReceived(v1.Snapshot.Generation, v1.Snapshot.Sequence, {Kind = "Discontinuity", Bytes = buffer.len(a2)})
        end
        if _mapping ~= nil and v1.Snapshot.Generation == _mapping.Generation then
            OwnerRecovery.observe(self, v1.Snapshot)
            self._pendingDiscontinuity = v1.Snapshot
            self:_tryInstallDiscontinuity()
            return
        end
        self._pendingDiscontinuity = v1.Snapshot
        self:_sendMappingRequest(v1.Snapshot.Generation)
        return
    end
    if v1.Kind == "DestructibleBaseline" then
        self._pendingBaseline = {ServerTick = v1.ServerTick, Frame = v1.Frame}
        self:_drainPendingCollisionControls()
        return
    end
    if v1.Kind == "DestructibleDelta" then
        local v4
        local v5 = {
            Epoch = v1.Epoch,
            Revision = v1.Revision,
            ServerTick = v1.ServerTick,
            Indices = v1.Indices,
        }
        if not v4 and self._pendingBaseline == nil and not (#self._pendingDeltas > 0) then
            self:_applyDelta(v5)
            return
        end
        self:_deferDestructibleDelta(v5, v1.Revision)
        return
    end
    if v1.Kind == "MoverBaseline" then
        if v3 then
            self._pendingMoverBaseline = v1
            return
        end
        self:_applyMoverBaseline(v1)
        return
    end
    if v1.Kind ~= "MoverDelta" and v1.Kind ~= "MoverProgress" then
        return
    end
    if v3 then
        self:_deferMoverDelta(v1)
        return
    end
    self:_applyMoverDelta(v1)
end

function u253:_sendDueCommands(a2) -- Line: 2170 -- types: self: table, a2: boolean?
    self._uplink:sendDue(self._commandStream, self._config, self._channels, a2)
end

function u253:_sendRecoveryCommands(a2) -- Line: 2174 -- types: self: table, a2: number
    if self._pendingCommandResyncThrough ~= nil then
        return
    end
    self._uplink:sendRecovery(self._commandStream, self._config, self._channels, a2)
end

function u253:_recoverStalledCommands() -- Line: 2182 -- upvalues: OwnerCommandFeedback (val)
    local _pendingReconciliationInstall = self._pendingReconciliationInstall
    self._uplink:recoverStalled(OwnerCommandFeedback.choose(
        self._lastAcceptedOwnerSnapshot,
        self._pendingOwnerSnapshot,
        if not _pendingReconciliationInstall then nil else _pendingReconciliationInstall.Snapshot
    ), self._commandStream, self._config, self._channels, self._lastOwnerAppliedAt, self._pendingCommandResyncThrough ~= nil)
end

function u253:_buildCommandInput(a2, a3, a4, a5, a6) -- Line: 2200
    -- upvalues: Enums (val), Serial (val), Config_2 (val)
    local v1, v2
    local v3 = a2
    local ResolveScopedState = self._options.ResolveScopedState
    if ResolveScopedState ~= nil then
        v3 = table.clone(a2)
        v3.Buttons = Enums.Buttons.with(a2.Buttons, Enums.Buttons.Scoped, ResolveScopedState())
    end
    local v4 = nil
    local v5 = false
    local ConsumePendingWeaponSelection = self._options.ConsumePendingWeaponSelection
    if ConsumePendingWeaponSelection ~= nil then
        v5 = (ConsumePendingWeaponSelection()) ~= nil
    end
    if v4 == nil then
        local GetUnresolvedWeaponSelection = self._options.GetUnresolvedWeaponSelection
        local _lastWeaponSelectionCommand = self._lastWeaponSelectionCommand
        if GetUnresolvedWeaponSelection ~= nil then
            if _lastWeaponSelectionCommand == nil
                or a6.CommandPacketEveryTicks <= (Serial.deltaUInt32(a4, _lastWeaponSelectionCommand)) then
                v4 = GetUnresolvedWeaponSelection()
            end
        end
    end
    local WeaponMoveSpeed = a3.WeaponMoveSpeed
    local WeaponScopedMoveSpeed = a3.WeaponScopedMoveSpeed
    if v4 ~= nil then
        if v3 == a2 then
            v3 = table.clone(a2)
        end
        v3.WeaponSelectRequestId = v4.RequestId
        v3.WeaponSelectIdentifier = v4.Identifier
        v3.GrenadeThrowIdentifier = v4.GrenadeThrowIdentifier
        v3.GrenadeThrowAnimation = v4.GrenadeThrowAnimation
        local ResolveWeaponSpeedProfile = self._options.ResolveWeaponSpeedProfile
        if ResolveWeaponSpeedProfile ~= nil then
            v1, v2 = ResolveWeaponSpeedProfile(v4)
            local v6 = false
            if type(v1) == "number" then
                v6 = false
                if v1 == v1 then
                    v6 = (math.abs(v1)) < (1 / 0)
                end
            end
            if v6 then
                v6 = false
                if type(v2) == "number" then
                    v6 = false
                    if v2 == v2 then
                        v6 = (math.abs(v2)) < (1 / 0)
                    end
                end
                if v6 then
                    WeaponMoveSpeed = math.clamp(v1, 0, Config_2.Default.MaxBaseMoveSpeed)
                    WeaponScopedMoveSpeed = math.clamp(v2, 0, Config_2.Default.MaxBaseMoveSpeed)
                    v3.PredictedWeaponMoveSpeed = WeaponMoveSpeed
                    v3.PredictedWeaponScopedMoveSpeed = WeaponScopedMoveSpeed
                end
            end
        end
    end
    local ResolveBaseMoveSpeed = self._options.ResolveBaseMoveSpeed
    if ResolveBaseMoveSpeed ~= nil then
        v1 = ResolveBaseMoveSpeed(
            a3.BaseMoveSpeed,
            a5,
            WeaponMoveSpeed,
            WeaponScopedMoveSpeed,
            Enums.Buttons.has(v3.Buttons, Enums.Buttons.Scoped)
        )
        v2 = false
        if type(v1) == "number" then
            v2 = false
            if v1 == v1 then
                v2 = (math.abs(v1)) < (1 / 0)
            end
        end
        if v2 then
            if v3 == a2 then
                v3 = table.clone(a2)
            end
            v3.PredictedBaseMoveSpeed = math.clamp(v1, 0, Config_2.Default.MaxBaseMoveSpeed)
        end
    end
    return v3, v4, v5
end

function u253:_stepPrediction(a2) -- Line: 2277
    -- upvalues: Serial (val), serverTimeAtTick (val), predictionDependencyMask (val), PlayerContacts (val)
    -- upvalues: PredictionErrorSmoother (val)
    local v1
    if not self:_canPredict() then
        local _reason = self._reason or self._status
        return false, _reason
    end
    local v2 = assert(self._mapping)
    local v3 = assert(self._commandStream)
    local v4 = assert(self._predictionRing)
    local v5 = assert(self._state)
    local v6 = assert(self._support)
    local v7 = assert(self._config)
    if v4:isFull() and 1 <= os.clock() - self._lastHistoryRecoveryRequestAt then
        self._lastHistoryRecoveryRequestAt = os.clock()
        self:_sendMappingRequest(v2.Generation)
    end
    local v8 = v3:lastSampledCommandNumber()
    local _lastPredictedServerTick = self._lastPredictedServerTick
    if _lastPredictedServerTick == nil then
        return false, "AuthoritativeTickUnavailable"
    end
    local v9 = Serial.addUInt32(_lastPredictedServerTick, 1)
    local _lastAcceptedOwnerSnapshot = self._lastAcceptedOwnerSnapshot
    if _lastAcceptedOwnerSnapshot == nil then
        return false, "AuthoritativeTimeUnavailable"
    end
    local v10 = serverTimeAtTick(_lastAcceptedOwnerSnapshot, v9, v7.StepSeconds)
    local v11, v12 = assert(self._timeline):predict(v9)
    if v11 == nil then
        return false, v12
    end
    debug.profilebegin("MovementV2.Client.ComposeWorld")
    local v13, v14 = self:_composeWorld(v9, v11.Revision, nil, v5, true)
    debug.profileend()
    if v13 == nil then
        return false, v14
    end
    local v15 = self._options.SampleInput({
        Mapping = v2,
        ServerTick = v9,
        ScheduledServerTime = v10,
        StepSeconds = v7.StepSeconds,
        FrameSampleAlpha = a2,
        State = assert(self._presentedState),
        Support = assert(self._presentedSupport),
    })
    if v15 == nil then
        return false, "InputUnavailable"
    end
    local v16, v17, v18 = self:_buildCommandInput(v15, v5, if v8 ~= nil then Serial.addUInt32(v8, 1) else 0, v10, v7)
    local v19, v20 = v3:sample(v16)
    if v19 == nil then
        if v18 and v17 ~= nil then
            local RestorePendingWeaponSelection = self._options.RestorePendingWeaponSelection
            if RestorePendingWeaponSelection ~= nil then
                RestorePendingWeaponSelection(v17)
            end
        end
        return false, (("InputRejected:%*"):format(v20 or "Unknown"))
    end
    if v17 ~= nil then
        self._lastWeaponSelectionCommand = v19.CommandNumber
    end
    if v19.CommandNumber ~= v1 then
        return false, "SampledCommandOrderMismatch"
    end
    local v21 = self._traceCapture:begin(v2.Generation, v19.CommandNumber, v9)
    local v22 = self:_stateForCommand(self:_applyDamageTagForStep(v5), v19, v10, false)
    local _pendingReconciliationInstall = self._pendingReconciliationInstall
    if _pendingReconciliationInstall ~= nil then
        if v2.PlayerCollisionsEnabled or self._collisionComposer ~= nil then
            _pendingReconciliationInstall.FreshCollisionFrames[v19.CommandNumber] = (assert(self._remoteBuffer):captureCollisionFrame())
        end
    end
    local v23, v24, v25, v26, v27, v28, v29 = self:_simulate(v22, v6, v19, v13, v21)
    self._traceCapture:observePredictedStep(v2.Generation, v19, v9, v22, v6, v23, v24, v25)
    ;(assert(self._reconciler)):retainReplayPrefixBeforePush(v19.CommandNumber)
    local v30, v31 = v4:push(v19, v9, v23, v24, v11.Revision, true, (predictionDependencyMask(v13, v22, v23, v6, v24, v26, v28)))
    if not v30 then
        return false, v31
    end
    if v19.GrenadeThrowIdentifier ~= nil then
        self:_sendGrenadeTransitionRequest(v19)
    end
    self._state = v23
    self._support = v24
    self:_refreshPresentedState(v5)
    self._lastPredictedServerTick = v9
    self._contactActorIds = v26
    if PlayerContacts.DefaultContactEpsilon < v27 then
        local OnPlayerContactCorrection = self._options.OnPlayerContactCorrection
        if OnPlayerContactCorrection ~= nil then
            if PredictionErrorSmoother.ContactMinDistance < v27 then
                local v32 = assert(self._previousPresentedState)
                v32.Position = v32.Position + v29
            end
            OnPlayerContactCorrection(v27, self:_presentationContext(), v29)
        end
    end
    self:_dispatchStepEvents(v25, v19.CommandNumber)
    self._diagnostics:recordPredictedStep(v19, v9, a2, v22, v23, v24, v25)
    return true, nil
end

function u253:_present() -- Line: 2418 -- upvalues: Players (val), Enums (val), withinPlayerContactMargin (val)
    local v1
    local _presentationContextScratch = self._presentationContextScratch
    local v2, v3 = self:_presentationClock()
    _presentationContextScratch.Mapping = self._mapping
    _presentationContextScratch.ServerTick = v2
    _presentationContextScratch.TickFraction = v3
    _presentationContextScratch.LocalPlayerContactCritical = self:_localPlayerContactCritical()
    _presentationContextScratch.Status = self._status
    _presentationContextScratch.Reason = self._reason
    local _state = self._state
    local _support = self._support
    local PresentRemotes = self._options.PresentRemotes
    local _remoteBuffer = self._remoteBuffer
    local _mapping = self._mapping
    local PlayerCollisionsEnabled = false
    if _mapping ~= nil then
        PlayerCollisionsEnabled = _mapping.PlayerCollisionsEnabled
    end
    local _remotePresentations = self._remotePresentations
    local _remotePresentationPool = self._remotePresentationPool
    local v4 = 0
    local v5 = 0
    local v6 = 0
    local UserId = Players.LocalPlayer.UserId
    table.clear(_remotePresentations)
    if _remoteBuffer == nil or _presentationContextScratch.ServerTick == nil then
        v1 = self
    else
        local ServerTick, TickFraction, v7, v8, v9, v10, v11, v12
        for i, j in _remoteBuffer:actorKeys() do
            ServerTick = _presentationContextScratch.ServerTick
            TickFraction = _presentationContextScratch.TickFraction
            v7, v8 = _remoteBuffer:getPresentationPoses(j, ServerTick, TickFraction)
            if PresentRemotes == nil then
                v7 = nil
            end
            if j ~= UserId and PresentRemotes ~= nil then
                v4 = v4 + 1
                if v7 == nil then
                    if v8 ~= nil then
                        v5 = v5 + 1
                    else
                        v6 = v6 + 1
                    end
                end
            end
            v9 = v8 or v7
            if v9 ~= nil then
                if _mapping == nil or v9.ActorId ~= _mapping.ActorId then
                    v10 = false
                    if v8 ~= nil then
                        v10 = PlayerCollisionsEnabled
                        if v10 then
                            v10 = true
                            if self._contactActorIds[v9.ActorId] ~= true then
                                if _support == nil or _support.Kind ~= Enums.SupportKind.Player then
                                    v10 = false
                                    if _state ~= nil then
                                        v10 = withinPlayerContactMargin(_state, v8)
                                    end
                                else
                                    v10 = true
                                    if _support.SourceId ~= v9.ActorId then
                                        v10 = false
                                        if _state ~= nil then
                                            v10 = withinPlayerContactMargin(_state, v8)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    _presentationContextScratch.LocalPlayerContactCritical = _presentationContextScratch.LocalPlayerContactCritical or v10
                    if PresentRemotes ~= nil then
                        v11 = #_remotePresentations + 1
                        v12 = _remotePresentationPool[v11]
                        if v12 ~= nil then
                            v12.UserId = v9.UserId
                            v12.ActorId = v9.ActorId
                            v12.Generation = v9.Generation
                            v12.RenderPose = v7
                        else
                            _remotePresentationPool[v11] = {
                                UserId = v9.UserId,
                                ActorId = v9.ActorId,
                                Generation = v9.Generation,
                                RenderPose = v7,
                            }
                        end
                        _remotePresentations[v11] = v12
                    end
                end
            end
        end
    end
    v1._diagnostics:recordRemotePresentation(v4, v5, v6, 0 < v5 + v6)
    local PresentLocal = v1._options.PresentLocal
    if PresentLocal ~= nil and v1._presentedState ~= nil and v1._presentedSupport ~= nil then
        local v13, v14 = v1:_localClockAnchor()
        local _localPresentationContextScratch = v1._localPresentationContextScratch
        _localPresentationContextScratch.Mapping = _presentationContextScratch.Mapping
        _localPresentationContextScratch.ServerTick = v13
        _localPresentationContextScratch.TickFraction = v14
        _localPresentationContextScratch.LocalPlayerContactCritical = _presentationContextScratch.LocalPlayerContactCritical
        _localPresentationContextScratch.Status = _presentationContextScratch.Status
        _localPresentationContextScratch.Reason = _presentationContextScratch.Reason
        PresentLocal(
            v1._presentedState,
            v1._presentedSupport,
            _localPresentationContextScratch,
            v1._previousPresentedState or v1._presentedState
        )
    end
    if PresentRemotes ~= nil then
        debug.profilebegin("MovementV2.Client.PresentRemotes")
        PresentRemotes(_remotePresentations, _presentationContextScratch)
        debug.profileend()
    end
end

function u253:_updateReplayBudget(a2) -- Line: 2527 -- types: self: table, a2: number
    local _config = self._config
    local v1 = if _config == nil then 1 else math.ceil((math.min(a2, _config.MaxPredictionFrameTicks * _config.StepSeconds)) / _config.StepSeconds * 1.1)
    local v2 = if _config == nil then 16 else math.max(16, (math.ceil(_config.MaxPredictionFrameTicks * 1.1)) + 2)
    self._reconciliationReplayBudget.MaximumSteps = v2
    self._reconciliationReplayBudget.MinimumSteps = math.min(v2, v1 + 2)
end

function u253:_advanceReplayAndControls() -- Line: 2544 -- upvalues: ActionLockReplay (val)
    local v1
    if self._pendingReconciliationInstall ~= nil then
        local v2
        _, v2 = self:_resumePendingReconciliation()
        if v2 ~= nil and v2 ~= "ReplayPending" and v2 ~= "ReplayEventOutsideRetention" then
            self:_warn((("could not resume reconciliation replay: %*"):format(v2)))
            local _mapping = self._mapping
            if _mapping ~= nil then
                self:_sendMappingRequest(_mapping.Generation)
            end
        end
    end
    if self._pendingReconciliationInstall == nil and not v1 then
        self:_drainPendingCollisionControls()
        self:_flushPendingMoverReplay()
        self:_flushPendingDamageTagReplay()
        ActionLockReplay.flush(self)
    end
    return v1
end

function u253:_installQueuedOwnerSnapshot(a2) -- Line: 2572 -- types: self: table, a2: boolean
    local _pendingOwnerSnapshot = self._pendingOwnerSnapshot
    local v1 = true
    if self._status ~= "WaitingForBaseline" then
        v1 = false
        if self._status == "WaitingForAuthority" then
            v1 = false
            if self._reason ~= nil then
                v1 = string.sub(self._reason, 1, 7) == "Awaiting"
            end
        end
    end
    if _pendingOwnerSnapshot ~= nil
        and self._pendingReconciliationInstall == nil
        and not a2
        and not v1
        and self:_remoteContactFrameReady(_pendingOwnerSnapshot) then
        self._pendingOwnerSnapshot = nil
        self:_handleOwnerSnapshot(_pendingOwnerSnapshot)
    end
end

function u253:_enterPredictionFailureStatus(a2) -- Line: 2593 -- types: self: table, a2: string?
    if a2 == "InputUnavailable" then
        self._accumulatorSeconds = 0
        self:_setStatus("WaitingForInput", a2)
    elseif a2 == nil then
        if a2 == "BaselineRequired" or a2 == "DestructibleRevisionMismatch" then
            self:_setStatus("WaitingForBaseline", a2)
        elseif a2 ~= "DestructibleFrameOutsideRetention" then
            self:_setStatus("WaitingForAuthority", a2)
        else
            self:_setStatus("WaitingForBaseline", a2)
        end
    elseif string.sub(a2, 1, 14) == "InputRejected:" then
        self._accumulatorSeconds = 0
        self:_setStatus("WaitingForInput", a2)
    elseif a2 == "BaselineRequired" or a2 == "DestructibleRevisionMismatch" then
        self:_setStatus("WaitingForBaseline", a2)
    elseif a2 ~= "DestructibleFrameOutsideRetention" then
        self:_setStatus("WaitingForAuthority", a2)
    else
        self:_setStatus("WaitingForBaseline", a2)
    end
    self._statusFromPredictionFailure = true
end

function u253:_drainPrediction(a2, a3) -- Line: 2610
    -- upvalues: PredictionPacing (val)
    local _config = self._config
    if self:_canPredict() and _config ~= nil then
        local v1, v2, v3
        local _accumulatorSeconds = self._accumulatorSeconds
        local _commandClock = self._commandClock
        local v4 = if _commandClock == nil then 1 else _commandClock:rate((os.clock()))
        local v5 = PredictionPacing.plan(self._accumulatorSeconds, a2, assert(self._predictionPacingPolicy), v4)
        local AdmittedSeconds = v5.AdmittedSeconds
        self._accumulatorSeconds = v5.AccumulatorSeconds
        local DiscardedSeconds = v5.DiscardedSeconds
        local GuaranteedSteps = v5.GuaranteedSteps
        local MaxSteps = v5.MaxSteps
        local v6 = GuaranteedSteps * _config.StepSeconds
        local _accumulatorSeconds_3 = self._accumulatorSeconds
        local v7 = true
        if not (DiscardedSeconds > 0) then
            v7 = v6 + _config.StepSeconds < _accumulatorSeconds_3
        end
        local v8 = 0
        local v9 = false
        local v10 = os.clock()
        local v11 = math.min(0.00075, AdmittedSeconds * 0.15)
        debug.profilebegin("MovementV2.Client.PredictionDrain")
        local v12, v13 = self, a2
        while true do
            if not (_config.StepSeconds <= v12._accumulatorSeconds) or MaxSteps <= v8 then
                break
            end
            if v5.MinimumSteps <= v8 and v5.WorkCeilingSeconds <= os.clock() - v10 then
                v9 = true
                break
            end
            if GuaranteedSteps <= v8
                and (v14 or v12._pendingReconciliationInstall ~= nil or v11 <= os.clock() - v10) then
                break
            end
            v1 = _config.StepSeconds - _accumulatorSeconds + v8 * _config.StepSeconds
            v2, v3 = v12:_stepPrediction(if not (AdmittedSeconds > 0) then 1 else math.clamp(v1 / AdmittedSeconds, 0, 1))
            if not v2 then
                v12:_sendDueCommands(true)
                v12:_enterPredictionFailureStatus(v3)
                break
            end
            if v12._statusFromPredictionFailure then
                v12:_setStatus("Running", nil)
            end
            v12._accumulatorSeconds = v12._accumulatorSeconds - _config.StepSeconds
            v8 = v8 + 1
        end
        debug.profileend()
        v12._diagnostics:recordPredictionFrame(v8, DiscardedSeconds, v9)
        v1 = os.clock() - v10
        local v15 = os.clock()
        if v7 then
            v2 = v15 - v12._lastPredictionHitchAt
            if v2 >= 0.25 then
                v12._lastPredictionHitchAt = v15
                v2 = table.freeze({
                    FrameSeconds = v13,
                    DiscardedSeconds = DiscardedSeconds,
                    BacklogBeforeSeconds = _accumulatorSeconds_3,
                    BacklogAfterSeconds = v12._accumulatorSeconds,
                    StepsDrained = v8,
                    GuaranteedStepBudget = GuaranteedSteps,
                    StepBudget = MaxSteps,
                    PredictionWorkSeconds = v1,
                    OwnerSnapshotAgeSeconds = if not (v12._lastOwnerAppliedAt <= 0) then v15 - v12._lastOwnerAppliedAt else -1,
                    ServerTick = v12._lastPredictedServerTick,
                    Status = v12._status,
                })
                v12._diagnostics:reportPredictionHitch(v2)
                local OnPredictionHitch = v12._options.OnPredictionHitch
                if OnPredictionHitch ~= nil then
                    OnPredictionHitch(v2)
                end
            end
        end
        return
    end
end

function u253:advance(a2) -- Line: 2698 -- types: self: table, a2: number
    local v1
    local v2 = false
    if typeof(a2) == "number" then
        v2 = false
        if a2 == a2 then
            v2 = false
            if a2 >= 0 then
                v2 = a2 < (1 / 0)
            end
        end
    end
    assert(v2, "invalid delta")
    if not self._discardNextAdvanceDelta then
        v1 = a2
    else
        self._discardNextAdvanceDelta = false
        v1 = 0
    end
    local _pendingCommandResyncThrough = self._pendingCommandResyncThrough
    if _pendingCommandResyncThrough ~= nil and 0.5 <= os.clock() - self._commandResyncRequestedAt then
        self:_sendCommandResyncRequest(_pendingCommandResyncThrough, true)
    end
    self:_updateReplayBudget(v1)
    local PrepareInputFrame = self._options.PrepareInputFrame
    if PrepareInputFrame ~= nil then
        PrepareInputFrame()
    end
    local v3 = self:_advanceReplayAndControls()
    self:_installQueuedOwnerSnapshot(v3)
    if self._status == "WaitingForTopology" then
        self._topologyRetrySeconds = self._topologyRetrySeconds + v1
        if 0.25 <= self._topologyRetrySeconds then
            self._topologyRetrySeconds = self._topologyRetrySeconds % 0.25
            self:retryTopology()
        end
    end
    self:_drainPrediction(v1, v3)
    self:_recoverStalledCommands()
    self:_sendDueCommands()
    self._diagnostics:emitNetcodeSummary()
end

function u253:render(a2) -- Line: 2739 -- types: self: table, a2: number?
    local v1 = true
    if a2 ~= nil then
        v1 = false
        if typeof(a2) == "number" then
            v1 = false
            if a2 == a2 then
                v1 = false
                if a2 >= 0 then
                    v1 = a2 < (1 / 0)
                end
            end
        end
    end
    assert(v1, "invalid render delta")
    local _remoteClock = self._remoteClock
    if _remoteClock ~= nil then
        _remoteClock:advance(a2, (os.clock()))
    end
    self:_present()
end

function u253.start(a1) -- Line: 2757 -- upvalues: Transport (val), OwnerSnapshotCodec (val), RunService (val)
    if a1._started then
        return
    end
    a1._started = true
    a1._channels = Transport.getClientChannels()
    a1._requestedMappingGeneration = nil
    local v1 = assert(a1._channels)
    a1._traceCapture:bind(v1)
    local _connections = a1._connections
    local v2 = #a1._connections + 1
    _connections[v2] = (v1.Control.OnClientEvent:Connect(function(a1_2) -- Line: 2766 -- upvalues: a1 (val)
        a1:_handleControl(a1_2)
    end))
    local _connections_2 = a1._connections
    v2 = #a1._connections + 1
    _connections_2[v2] = (v1.Diagnostics.OnClientEvent:Connect(function(a1) -- Line: 2770
        if typeof(a1) == "table" and a1.Kind == "MovementFailure" and type(a1.Message) == "string" then
            warn((("[MovementV2] server movement simulation failed at tick %*; your movement was held:\n%*"):format(
                tostring(a1.ServerTick),
                a1.Message
            )))
            return
        end
    end))
    local _connections_3 = a1._connections
    v2 = #a1._connections + 1
    _connections_3[v2] = (v1.Trace.OnClientEvent:Connect(function(a1_2) -- Line: 2778 -- upvalues: a1 (val)
        local _lastAcceptedOwnerSnapshot = a1._lastAcceptedOwnerSnapshot
        a1._traceCapture:handleServerTrace(a1_2, if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.Sequence else nil)
    end))
    for i, j in a1._diagnostics:connectOutput(v1) do
        a1._connections[#a1._connections + 1] = j
    end
    local _connections_4 = a1._connections
    v2 = #a1._connections + 1
    _connections_4[v2] = (v1.OwnerSnapshot.OnClientEvent:Connect(function(a1_2) -- Line: 2786 -- upvalues: OwnerSnapshotCodec (upval), a1 (val)
        local v1 = OwnerSnapshotCodec.decode(a1_2)
        if v1 ~= nil then
            a1._diagnostics:recordOwnerSnapshotReceived()
            local _mapping = a1._mapping
            local OnOwnerSnapshotReceived = a1._options.OnOwnerSnapshotReceived
            if OnOwnerSnapshotReceived ~= nil and _mapping ~= nil and v1.Generation == _mapping.Generation then
                OnOwnerSnapshotReceived(v1.Generation, v1.Sequence, {Kind = "OwnerSnapshot", Bytes = buffer.len(a1_2)})
            end
            a1:_queueOwnerSnapshot(v1)
        end
    end))
    local _connections_5 = a1._connections
    v2 = #a1._connections + 1
    _connections_5[v2] = (v1.RemoteSnapshot.OnClientEvent:Connect(function(a1_2) -- Line: 2801 -- upvalues: a1 (val)
        a1:_handleRemoteSnapshot(a1_2)
    end))
    local v3 = ("MovementV2.Client.Runtime.%*"):format((tostring(a1)))
    a1._renderStepName = v3
    RunService:BindToRenderStep(v3, Enum.RenderPriority.Camera.Value - 2, function(a1_2) -- Line: 2807 -- upvalues: a1 (val)
        debug.profilebegin("MovementV2.Client.Advance")
        a1:advance(a1_2)
        debug.profileend()
        debug.profilebegin("MovementV2.Client.Render")
        a1:render(a1_2)
        debug.profileend()
    end)
    local _queuedMappingGeneration = a1._queuedMappingGeneration
    if _queuedMappingGeneration == nil and a1._options.ResolveGeneration ~= nil then
        _queuedMappingGeneration = a1._options.ResolveGeneration()
    end
    if _queuedMappingGeneration == nil and a1._mapping ~= nil then
        _queuedMappingGeneration = a1._mapping.Generation
    end
    if a1._mapping == nil then
        a1:_setStatus("WaitingForMapping", nil)
    else
        a1:_setStatus("WaitingForAuthority", "RuntimeStarted")
    end
    if _queuedMappingGeneration ~= nil then
        local v4, v5 = a1:requestMapping(_queuedMappingGeneration)
        if not v4 then
            a1:_warn((("could not request startup mapping: %*"):format(v5)))
        end
    end
end

function u253:stop() -- Line: 2835 -- upvalues: RunService (val)
    if not self._started then
        return
    end
    self:_sendDueCommands(true)
    self._started = false
    for i, j in self._connections do
        j:Disconnect()
    end
    table.clear(self._connections)
    self._diagnostics:clearOutput()
    self._traceCapture:bind(nil)
    local _renderStepName = self._renderStepName
    if _renderStepName ~= nil then
        RunService:UnbindFromRenderStep(_renderStepName)
        self._renderStepName = nil
    end
    self._channels = nil
    self._pendingCommandResyncThrough = nil
    self._commandResyncRequestedAt = 0
    self:_setStatus("Stopped", nil)
end

function u253:destroy() -- Line: 2858
    self:stop()
    self:_disposeTimeline()
    local _collisionComposer = self._collisionComposer
    if _collisionComposer ~= nil then
        _collisionComposer:Reset()
    end
    self._mapping = nil
    self._topology = nil
    self._topologyBuild = nil
    self._cachedStaticFrame = nil
    self._cachedStaticWorld = nil
    self._state = nil
    self._support = nil
    self._traceCapture:reset(nil)
    table.clear(self._damageTagsByMovementTick)
    self._pendingDamageTagReplayMovementTick = nil
    self._actionLocks = nil
    self._pendingActionLockReplay = false
    self:_refreshPresentedState()
end

return table.freeze(u253)