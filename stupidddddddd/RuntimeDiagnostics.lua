-- ReplicatedStorage.MovementV2.Client.RuntimeDiagnostics
-- Script path: ReplicatedStorage.MovementV2.Client.RuntimeDiagnostics
-- Decompile time: 38.46 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Config = require(script.Parent.Parent.Config)
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol)
local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local ProvenMath = require(script.Parent.Parent.Simulation.ProvenMath)
local RuntimeSettings = require(script.Parent.Parent.Simulation.RuntimeSettings)
local State = require(script.Parent.Parent.Simulation.State)
require(script.Parent.Parent.Simulation.Types)
require(script.Parent.Parent.Transport)
local CorrectionDiagnostics = require(script.Parent.CorrectionDiagnostics)
local DiagnosticOutput = require(script.Parent.DiagnosticOutput)
local PredictionErrorSmoother = require(script.Parent.PredictionErrorSmoother)
require(script.Parent.PredictionRing)
require(script.Parent.Reconciler)
require(script.Parent.RuntimeTypes)
local u111 = table.freeze({
    OwnerCorrection = 5,
    Reconciliation = 5,
    TraceComparison = 0.5,
    PredictionHitch = 10,
    RuntimeWarning = 5,
    NetcodeSummary = 10,
})
local u112 = {}
u112.__index = u112
local output = DiagnosticProtocol.output

local function materialAckCorrection(a1) -- Line: 121
    local ComparedAtAck = a1.ComparedAtAck
    if ComparedAtAck then
        ComparedAtAck = true
        if not (0.01 <= a1.Position) then
            ComparedAtAck = true
            if not (0.1 <= a1.Velocity) then
                ComparedAtAck = true
                if not (0.01 <= a1.SupportAnchor) then
                    ComparedAtAck = true
                    if not (0.1 <= a1.SupportVelocity) then
                        ComparedAtAck = true
                        if not (0.004363323129985824 <= a1.LookYaw) then
                            ComparedAtAck = true
                            if not (0.004363323129985824 <= a1.VerticalLook) then
                                ComparedAtAck = true
                                if not (0.01 <= a1.DuckAmount) then
                                    ComparedAtAck = true
                                    if not (0.01 <= a1.Stamina) then
                                        ComparedAtAck = true
                                        if not (0 < a1.SupportKindMismatch) then
                                            ComparedAtAck = 0 < a1.SupportSourceMismatch
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return ComparedAtAck
end

local function materialTailCorrection(a1) -- Line: 137
    local TailCompared = a1.TailCompared
    if TailCompared then
        TailCompared = true
        if not (0.01 <= a1.TailPosition) then
            TailCompared = true
            if not (0.1 <= a1.TailVelocity) then
                TailCompared = true
                if not (0.01 <= a1.TailSupportAnchor) then
                    TailCompared = true
                    if not (0.1 <= a1.TailSupportVelocity) then
                        TailCompared = true
                        if not (0 < a1.TailSupportKindMismatch) then
                            TailCompared = true
                            if not (0 < a1.TailSupportSourceMismatch) then
                                TailCompared = a1.TailGroundMismatch or a1.TailStanceMismatch
                            end
                        end
                    end
                end
            end
        end
    end
    return TailCompared
end

local function presentationSnapCorrection(a1) -- Line: 151 -- upvalues: PredictionErrorSmoother (val)
    return a1.TailCompared and PredictionErrorSmoother.isHardSnapCorrection(a1)
end

local function mappingLabel(a1) -- Line: 155
    if a1 == nil then
        return "mapping=nil"
    end
    return string.format(
        "mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s",
        a1.Generation,
        a1.ActorId,
        a1.SimulationHz,
        a1.TopologyEpoch,
        a1.TopologyFingerprint,
        (tostring(a1.PlayerCollisionsEnabled))
    )
end

local function supportIdentityLabel(a1) -- Line: 170
    if a1 == nil then
        return "nil"
    end
    return (("%*:%*"):format(a1.Kind, a1.SourceId))
end

local function vectorLabel(a1) -- Line: 177 -- types: a1: vector
    return string.format("(%+.8f,%+.8f,%+.8f)", a1.X, a1.Y, a1.Z)
end

local function stateLabel(a1, a2) -- Line: 181 -- types: a1: string
    if a2 == nil then
        return (("%*=nil"):format(a1))
    end
    local format = string.format
    local Position = a2.Position
    local v1 = string.format("(%+.8f,%+.8f,%+.8f)", Position.X, Position.Y, Position.Z)
    local Velocity = a2.Velocity
    local v2 = string.format("(%+.8f,%+.8f,%+.8f)", Velocity.X, Velocity.Y, Velocity.Z)
    local LookYaw = a2.LookYaw
    local VerticalLook = a2.VerticalLook
    local BaseMoveSpeed = a2.BaseMoveSpeed
    local WeaponMoveSpeed = a2.WeaponMoveSpeed
    local WeaponScopedMoveSpeed = a2.WeaponScopedMoveSpeed
    local VelocityModifier = a2.VelocityModifier
    local MovementMode = a2.MovementMode
    local Stance = a2.Stance
    local v3 = tostring(a2.OnGround)
    local GroundNormal = a2.GroundNormal
    local v4 = string.format("(%+.8f,%+.8f,%+.8f)", GroundNormal.X, GroundNormal.Y, GroundNormal.Z)
    local WallNormal = a2.WallNormal
    return format(
        "%s pos=%s vel=%s yaw=%+.8f verticalLook=%+.8f baseSpeed=%.5f weaponProfile=%.5f/%.5f velocityModifier=%.6f mode=%s stance=%s onGround=%s groundNormal=%s wallNormal=%s friction=%.6f duck=%.6f duckMs=%.3f isDucking=%s duckSpeed=%.6f duckCooldown=%.6f stamina=%.6f lastJumpCmd=%u buttons=0x%02X jumpBuffer=%d jumpHull=%s stuckTicks=%d",
        a1,
        v1,
        v2,
        LookYaw,
        VerticalLook,
        BaseMoveSpeed,
        WeaponMoveSpeed,
        WeaponScopedMoveSpeed,
        VelocityModifier,
        MovementMode,
        Stance,
        v3,
        v4,
        string.format("(%+.8f,%+.8f,%+.8f)", WallNormal.X, WallNormal.Y, WallNormal.Z),
        a2.GroundSurfaceFriction,
        a2.DuckAmount,
        a2.DuckTimeMsecs,
        tostring(a2.IsDucking),
        a2.DuckSpeed,
        a2.DuckCooldownSeconds,
        a2.Stamina,
        a2.LastJumpCommandNumber,
        a2.PreviousButtons,
        a2.JumpBufferTicksRemaining,
        tostring(a2.JumpHullActive),
        a2.StuckStepTicks
    )
end

local function supportLabel(a1, a2) -- Line: 216 -- upvalues: vectorLabel (val) -- types: a1: string
    if a2 == nil then
        return (("%*=nil"):format(a1))
    end
    local format = string.format
    local Kind = a2.Kind
    local SourceId = a2.SourceId
    local Anchor = a2.Anchor
    return format(
        "%s kind=%d source=%u anchor=%s velocity=%s",
        a1,
        Kind,
        SourceId,
        string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z),
        vectorLabel(a2.Velocity)
    )
end

local function snapshotIdentity(a1) -- Line: 231
    return {
        Generation = a1.Generation,
        Sequence = a1.Sequence,
        CommandNumber = a1.LastProcessedCommand,
        ServerTick = a1.ServerTick,
    }
end

local function tailIdentity(a1) -- Line: 241
    local _lastAcceptedOwnerSnapshot = a1._lastAcceptedOwnerSnapshot
    return {
        Sequence = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.Sequence else nil,
        CommandNumber = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.LastProcessedCommand else nil,
    }
end

local function signedHorizontalAngle(a1, a2) -- Line: 249 -- types: a1: vector, a2: vector
    if not (a1.Magnitude <= 1e-06) and not (a2.Magnitude <= 1e-06) then
        return (math.atan2(a1.X * a2.Z - a1.Z * a2.X, (a1:Dot(a2))))
    end
    return 0
end

local function newWindow() -- Line: 256
    return {
        BarrierCounts = {},
        ReplayCommands = 0,
        ReplayEvents = 0,
        StallSamples = 0,
        StalledFlagSamples = 0,
        StalledRun = 0,
        LongestStalledRun = 0,
        DepthSum = 0,
        DepthSamples = 0,
        WorstDepth = nil,
        StepsDrained = 0,
        Frames = 0,
        MaxStepsInFrame = 0,
        DiscardedSeconds = 0,
        CeilingBreaks = 0,
        RemoteFramesSeen = 0,
        RemoteSequenceGaps = 0,
        RemoteBaselineRejects = 0,
        RemoteOtherRejects = 0,
        RemoteActorSamples = 0,
        RemoteStaleSamples = 0,
        RemoteMissingSamples = 0,
        RemoteBlindFrames = 0,
        RemoteBlindRunStartedAt = nil,
        RemoteLongestBlindSeconds = 0,
        StatusDwellSeconds = {},
        StatusEnteredAt = os.clock(),
        ResyncRequests = 0,
        MappingRequests = 0,
        CommandPacketsBase = 0,
        RecoveryPacketsBase = 0,
        SendDeferralsBase = 0,
        MaxCorrection = 0,
        CorrectionCount = 0,
    }
end

function u112.new(a1) -- Line: 295 -- upvalues: DiagnosticOutput (val), newWindow (val), u112 (val)
    return (setmetatable({
        _ownerReceived = 0,
        _ownerApplied = 0,
        _replayTotal = 0,
        _replayMax = 0,
        _reconciliationCount = 0,
        _lastSummaryAt = 0,
        _lastAnomalyAt = 0,
        _airStrafeHeaderPrinted = false,
        _airStrafeLineCount = 0,
        _runtime = a1,
        _output = DiagnosticOutput.new(),
        _window = newWindow(),
        _summaryAt = os.clock(),
        _lastReportAtByKind = {},
    }, u112))
end

function u112.reportingEnabled(a1) -- Line: 315 -- upvalues: DiagnosticProtocol (val), Players (val)
    return DiagnosticProtocol.shouldReport(Players.LocalPlayer)
end

function u112:_resetWindow() -- Line: 320 -- upvalues: newWindow (val)
    local v1 = newWindow()
    v1.RemoteBlindRunStartedAt = self._window.RemoteBlindRunStartedAt
    local v2 = self._runtime._uplink:counters()
    v1.CommandPacketsBase = v2.PacketsSent
    v1.RecoveryPacketsBase = v2.RecoveryPacketsSent
    v1.SendDeferralsBase = v2.BudgetDeferrals
    self._window = v1
end

function u112.resetGeneration(a1) -- Line: 332
    a1._ownerReceived = 0
    a1._ownerApplied = 0
    a1._replayTotal = 0
    a1._replayMax = 0
    a1._reconciliationCount = 0
    a1._lastSummaryAt = 0
    a1._lastAnomalyAt = 0
    table.clear(a1._lastReportAtByKind)
    a1:_resetWindow()
    a1._remoteLastSequence = nil
end

function u112:reportIssue(a2, a3, a4) -- Line: 345
    -- upvalues: u111 (val), DiagnosticProtocol (val), Workspace (val)
    local _runtime = self._runtime
    local _channels = _runtime._channels
    if _channels ~= nil and self:reportingEnabled() then
        local v1 = os.clock()
        local v2 = self._lastReportAtByKind[a2] or (-1 / 0)
        local v3 = u111[a2] or 5
        if v1 - v2 < v3 then
            return
        end
        self._lastReportAtByKind[a2] = v1
        local _mapping = _runtime._mapping
        local v4 = a4 or {}
        local Diagnostics = _channels.Diagnostics
        local v5 = {Version = DiagnosticProtocol.Version, Kind = a2}
        local Generation = v4.Generation or (if _mapping ~= nil then _mapping.Generation else nil)
        v5.Generation = Generation
        local ActorId = v4.ActorId or (if _mapping ~= nil then _mapping.ActorId else nil)
        v5.ActorId = ActorId
        v5.Sequence = v4.Sequence
        v5.CommandNumber = v4.CommandNumber
        local ServerTick = v4.ServerTick or _runtime._lastPredictedServerTick
        v5.ServerTick = ServerTick
        v5.ClientServerTime = Workspace:GetServerTimeNow()
        v5.ClientLog = string.sub(a3, 1, DiagnosticProtocol.MaxClientLogBytes)
        Diagnostics:FireServer(v5)
        return
    end
end

function u112.reportWarning(a1, a2) -- Line: 374
    -- upvalues: Workspace (val), stateLabel (val), supportLabel (val)
    if not a1:reportingEnabled() then
        return
    end
    local _runtime = a1._runtime
    local concat = table.concat
    local v1 = {}
    local v2 = string.format(
        "issue=RuntimeWarning message=%s status=%s statusReason=%s clientServerTime=%.6f accumulatorMs=%.3f",
        a2,
        _runtime._status,
        tostring(_runtime._reason),
        Workspace:GetServerTimeNow(),
        _runtime._accumulatorSeconds * 1000
    )
    local _mapping = _runtime._mapping
    local v3 = if _mapping ~= nil then string.format(
        "mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s",
        _mapping.Generation,
        _mapping.ActorId,
        _mapping.SimulationHz,
        _mapping.TopologyEpoch,
        _mapping.TopologyFingerprint,
        (tostring(_mapping.PlayerCollisionsEnabled))
    ) else "mapping=nil"
    local v4 = stateLabel("predictedTail", _runtime._state)
    v1[1] = v2
    v1[2] = v3
    v1[3] = v4
    v1[4] = supportLabel("predictedTailSupport", _runtime._support)
    local v5 = concat(v1, "\n")
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot
    a1:reportIssue("RuntimeWarning", v5, {
        Sequence = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.Sequence else nil,
        CommandNumber = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.LastProcessedCommand else nil,
    })
end

function u112.reportPredictionHitch(a1, a2) -- Line: 398 -- upvalues: stateLabel (val), supportLabel (val)
    if not a1:reportingEnabled() then
        return
    end
    local _runtime = a1._runtime
    local concat = table.concat
    local v1 = {}
    local v2 = string.format(
        "issue=PredictionHitch likelyCause=ClientFrameStallOrPredictionDebt frameMs=%.3f discardedMs=%.3f backlogBeforeMs=%.3f backlogAfterMs=%.3f drained=%d guaranteed=%d hardCap=%d predictionWorkMs=%.3f ownerAgeMs=%.3f status=%s statusReason=%s accumulatorMs=%.3f",
        a2.FrameSeconds * 1000,
        a2.DiscardedSeconds * 1000,
        a2.BacklogBeforeSeconds * 1000,
        a2.BacklogAfterSeconds * 1000,
        a2.StepsDrained,
        a2.GuaranteedStepBudget,
        a2.StepBudget,
        a2.PredictionWorkSeconds * 1000,
        a2.OwnerSnapshotAgeSeconds * 1000,
        a2.Status,
        tostring(_runtime._reason),
        _runtime._accumulatorSeconds * 1000
    )
    local _mapping = _runtime._mapping
    local v3 = if _mapping ~= nil then string.format(
        "mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s",
        _mapping.Generation,
        _mapping.ActorId,
        _mapping.SimulationHz,
        _mapping.TopologyEpoch,
        _mapping.TopologyFingerprint,
        (tostring(_mapping.PlayerCollisionsEnabled))
    ) else "mapping=nil"
    local v4 = stateLabel("predictedTail", _runtime._state)
    v1[1] = v2
    v1[2] = v3
    v1[3] = v4
    v1[4] = supportLabel("predictedTailSupport", _runtime._support)
    local v5 = concat(v1, "\n")
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot
    a1:reportIssue("PredictionHitch", v5, {
        Sequence = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.Sequence else nil,
        CommandNumber = if _lastAcceptedOwnerSnapshot ~= nil then _lastAcceptedOwnerSnapshot.LastProcessedCommand else nil,
    })
end

function u112:recordStatusChange(a2) -- Line: 430
    local v1 = os.clock()
    local _window = self._window
    local StatusDwellSeconds = _window.StatusDwellSeconds
    StatusDwellSeconds[a2] = (StatusDwellSeconds[a2] or 0) + (v1 - _window.StatusEnteredAt)
    _window.StatusEnteredAt = v1
end

function u112.recordOwnerSnapshotReceived(a1) -- Line: 438
    a1._ownerReceived = a1._ownerReceived + 1
end

function u112.recordOwnerFeedback(a1, a2) -- Line: 443 -- upvalues: Enums (val)
    local _window = a1._window
    local BufferDepth = a2.BufferDepth
    _window.DepthSum = _window.DepthSum + BufferDepth
    _window.DepthSamples = _window.DepthSamples + 1
    if _window.WorstDepth == nil or BufferDepth < _window.WorstDepth then
        _window.WorstDepth = BufferDepth
    end
    if BufferDepth < 0 then
        _window.StallSamples = _window.StallSamples + 1
    end
    if bit32.band(a2.Flags, Enums.OwnerSnapshotFlags.Stalled) == 0 then
        _window.StalledRun = 0
        return
    end
    _window.StalledFlagSamples = _window.StalledFlagSamples + 1
    _window.StalledRun = _window.StalledRun + 1
    _window.LongestStalledRun = math.max(_window.LongestStalledRun, _window.StalledRun)
end

function u112.recordRemoteSnapshot(a1, a2) -- Line: 464 -- upvalues: Serial (val) -- types: a1: table, a2: number
    local _window = a1._window
    local _remoteLastSequence = a1._remoteLastSequence
    if _remoteLastSequence == nil then
        a1._remoteLastSequence = a2
        _window.RemoteFramesSeen = _window.RemoteFramesSeen + 1
        return
    end
    if Serial.isNewerUInt32(a2, _remoteLastSequence) then
        _window.RemoteSequenceGaps = _window.RemoteSequenceGaps + (Serial.deltaUInt32(a2, _remoteLastSequence) - 1)
        a1._remoteLastSequence = a2
        _window.RemoteFramesSeen = _window.RemoteFramesSeen + 1
    end
end

function u112.recordRemoteRejected(a1, a2) -- Line: 478 -- types: a1: table, a2: string
    if a2 == "RemoteBaselineRequired" then
        local _window = a1._window
        _window.RemoteBaselineRejects = _window.RemoteBaselineRejects + 1
        return
    end
    local _window_2 = a1._window
    _window_2.RemoteOtherRejects = _window_2.RemoteOtherRejects + 1
end

function u112.recordRemotePresentation(a1, a2, a3, a4, a5) -- Line: 487
    -- upvalues: 
    local _window = a1._window
    _window.RemoteActorSamples = _window.RemoteActorSamples + a2
    _window.RemoteStaleSamples = _window.RemoteStaleSamples + a3
    _window.RemoteMissingSamples = _window.RemoteMissingSamples + a4
    if not a5 then
        _window.RemoteBlindRunStartedAt = nil
        return
    end
    _window.RemoteBlindFrames = _window.RemoteBlindFrames + 1
    local RemoteBlindRunStartedAt = _window.RemoteBlindRunStartedAt
    if RemoteBlindRunStartedAt == nil then
        _window.RemoteBlindRunStartedAt = (os.clock())
    end
    local v1 = os.clock() - RemoteBlindRunStartedAt
    if _window.RemoteLongestBlindSeconds < v1 then
        _window.RemoteLongestBlindSeconds = v1
    end
end

function u112.recordPredictionFrame(a1, a2, a3, a4) -- Line: 513
    -- upvalues: 
    local _window = a1._window
    _window.Frames = _window.Frames + 1
    _window.StepsDrained = _window.StepsDrained + a2
    _window.DiscardedSeconds = _window.DiscardedSeconds + a3
    if _window.MaxStepsInFrame < a2 then
        _window.MaxStepsInFrame = a2
    end
    if a4 then
        _window.CeilingBreaks = _window.CeilingBreaks + 1
    end
end

function u112.recordResyncRequest(a1) -- Line: 526
    local _window = a1._window
    _window.ResyncRequests = _window.ResyncRequests + 1
end

function u112.recordMappingRequest(a1) -- Line: 530
    local _window = a1._window
    _window.MappingRequests = _window.MappingRequests + 1
end

function u112:_recordReplayWindow(a2) -- Line: 534
    local _window = self._window
    local ReplayBarrier = a2.Metrics.ReplayBarrier
    _window.BarrierCounts[ReplayBarrier] = (_window.BarrierCounts[ReplayBarrier] or 0) + 1
    if 0 < a2.ReplayCount then
        _window.ReplayEvents = _window.ReplayEvents + 1
        _window.ReplayCommands = _window.ReplayCommands + a2.ReplayCount
    end
    if _window.MaxCorrection < a2.Metrics.Position then
        _window.MaxCorrection = a2.Metrics.Position
    end
    if 0.01 < a2.Metrics.Position then
        _window.CorrectionCount = _window.CorrectionCount + 1
    end
end

function u112:_reportOwnerCorrection(a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 550
    -- upvalues: Players (val), CorrectionDiagnostics (val), Workspace (val), State (val), stateLabel (val)
    -- upvalues: vectorLabel (val)
    local v1, v2
    local _runtime = self._runtime
    local Metrics = a3.Metrics
    local _predictionRing = _runtime._predictionRing
    local v3 = if _runtime._remoteClock ~= nil then _runtime._remoteClock:diagnostics() else nil
    local v4, v5, v6 = _runtime._uplink:peekBudget(_runtime._config, a5)
    local v7 = _runtime._uplink:counters()
    local v8 = _runtime._uplink:lastRecoveryAcknowledgedCommand()
    local Command = if a4 ~= nil then a4.Command else nil
    local v9 = -1
    local success, result = pcall(function() -- Line: 569 -- upvalues: Players (upval)
        return Players.LocalPlayer:GetNetworkPing()
    end)
    if success and typeof(result) == "number" then
        v9 = result
    end
    local v10 = nil
    local ResolveMovementDiagnosticContext = _runtime._options.ResolveMovementDiagnosticContext
    if ResolveMovementDiagnosticContext ~= nil then
        local success_2, result_2 = pcall(ResolveMovementDiagnosticContext, a2.ServerTime)
        if success_2 and typeof(result_2) == "table" then
            v10 = result_2
        end
    end
    local v11 = {}
    local v12 = string.format(
        "issue=OwnerCorrection suspectedCause=%s status=%s statusReason=%s clientServerTime=%.6f pingMs=%.2f",
        CorrectionDiagnostics.classify(Metrics, if a4 ~= nil then a4.PostState else nil, a2.State, v10),
        _runtime._status,
        tostring(_runtime._reason),
        Workspace:GetServerTimeNow(),
        v9 * 1000
    )
    local _mapping = _runtime._mapping
    local v13 = if _mapping ~= nil then string.format(
        "mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s",
        _mapping.Generation,
        _mapping.ActorId,
        _mapping.SimulationHz,
        _mapping.TopologyEpoch,
        _mapping.TopologyFingerprint,
        (tostring(_mapping.PlayerCollisionsEnabled))
    ) else "mapping=nil"
    local v14 = CorrectionDiagnostics.formatMovementLockContext(v10, a2.ServerTime)
    local format_3 = string.format
    local Sequence = a2.Sequence
    local LastProcessedCommand = a2.LastProcessedCommand
    local ServerTick_2 = a2.ServerTick
    local TailServerTick = a3.TailServerTick
    local v15 = if _predictionRing ~= nil then _predictionRing:count() else 0
    local v16 = format_3(
        "anchor sequence=%u ackCommand=%u predictedAckTick=%s authorityTick=%u tailTick=%u newestCommand=%s commandLead=%d ring=%d ownerReceived=%d ownerApplied=%d topologyRevision=%u moverRevision=%u flags=0x%02X",
        Sequence,
        LastProcessedCommand,
        if a4 ~= nil then tostring(a4.ServerTick) else "nil",
        ServerTick_2,
        TailServerTick,
        if a8 ~= nil then tostring(a8) else "nil",
        a9,
        v15,
        self._ownerReceived,
        self._ownerApplied,
        a2.Topology.DestructibleRevision,
        a2.Topology.MoverRevision,
        a2.Flags
    )
    local v17 = string.format(
        "commandTransport packets=%d recoveryPackets=%d budgetDeferrals=%d tokens=%.3f/%.3f rate=%.3f recoveryAck=%s",
        v7.PacketsSent,
        v7.RecoveryPacketsSent,
        v7.BudgetDeferrals,
        v4,
        v6,
        v5,
        if v8 ~= nil then tostring(v8) else "nil"
    )
    local v18 = string.format(
        "reconcile count=%d mode=%s barrier=%s replay=%d retiredAckedPredictions=%d ackAdvance=%d tickAdvance=%d heldTicks=%d synthInput=%s playerContact=%s comparedAtAck=%s tailCompared=%s tailTickDelta=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f",
        self._reconciliationCount,
        Metrics.ReconciliationMode,
        Metrics.ReplayBarrier,
        Metrics.ReplayCount,
        Metrics.DroppedCommandCount,
        Metrics.AcknowledgedCommandDelta,
        Metrics.ServerTickDelta,
        Metrics.ServerHeldTickCount,
        tostring(Metrics.SynthesizedInput),
        tostring(Metrics.PlayerContactCorrection),
        tostring(Metrics.ComparedAtAck),
        tostring(Metrics.TailCompared),
        Metrics.TailServerTickDelta,
        Metrics.ReconciliationWorkSeconds * 1000,
        Metrics.ReconciliationElapsedSeconds * 1000,
        Metrics.ReconciliationSliceCount,
        Metrics.ReconciliationMaximumSliceSeconds * 1000
    )
    local v19 = string.format(
        "ackError fields=%s mask=0x%X count=%d position=%.8f horizontal=%.8f vertical=%+.8f velocity=%.8f verticalVelocity=%+.8f yawDeg=%.6f verticalLookDeg=%.6f duck=%.8f stamina=%.8f supportAnchor=%.8f supportVelocity=%.8f supportKindMismatch=%d supportSourceMismatch=%d supportCanonicalMismatch=%s topologyRevisionDelta=%d",
        State.mismatchLabel(Metrics.CanonicalStateMismatchMask),
        Metrics.CanonicalStateMismatchMask,
        Metrics.CanonicalStateMismatchCount,
        Metrics.Position,
        Metrics.HorizontalPosition,
        a6,
        Metrics.Velocity,
        a7,
        math.deg(Metrics.LookYaw),
        math.deg(Metrics.VerticalLook),
        Metrics.DuckAmount,
        Metrics.Stamina,
        Metrics.SupportAnchor,
        Metrics.SupportVelocity,
        Metrics.SupportKindMismatch,
        Metrics.SupportSourceMismatch,
        tostring(Metrics.CanonicalSupportMismatch),
        Metrics.TopologyRevisionDelta
    )
    local v20 = string.format(
        "tailError position=%.8f horizontal=%.8f vertical=%+.8f velocity=%.8f verticalVelocity=%+.8f supportAnchor=%.8f supportVelocity=%.8f supportKindMismatch=%d supportSourceMismatch=%d groundMismatch=%s stanceMismatch=%s",
        Metrics.TailPosition,
        Metrics.TailHorizontalPosition,
        Metrics.TailVerticalPosition,
        Metrics.TailVelocity,
        Metrics.TailVerticalVelocity,
        Metrics.TailSupportAnchor,
        Metrics.TailSupportVelocity,
        Metrics.TailSupportKindMismatch,
        Metrics.TailSupportSourceMismatch,
        tostring(Metrics.TailGroundMismatch),
        (tostring(Metrics.TailStanceMismatch))
    )
    local v21 = if Command ~= nil then string.format(
        "ackCommandInput number=%u move=(%+.6f,%+.6f) yaw=%+.8f verticalLook=%+.8f buttons=0x%02X weaponRequest=%s weapon=%s predictedBaseSpeed=%s weaponProfile=%s/%s",
        Command.CommandNumber,
        Command.Move.X,
        Command.Move.Y,
        Command.LookYaw,
        Command.VerticalLook,
        Command.Buttons,
        tostring(Command.WeaponSelectRequestId),
        tostring(Command.WeaponSelectIdentifier),
        tostring(Command.PredictedBaseMoveSpeed),
        tostring(Command.PredictedWeaponMoveSpeed),
        (tostring(Command.PredictedWeaponScopedMoveSpeed))
    ) else "ackCommandInput=nil"
    local v22 = stateLabel("predictedAtAck", if a4 ~= nil then a4.PostState else nil)
    local PostSupport = if a4 ~= nil then a4.PostSupport else nil
    if PostSupport ~= nil then
        local format_9 = string.format
        local Kind = PostSupport.Kind
        local SourceId = PostSupport.SourceId
        local Anchor = PostSupport.Anchor
        v1 = format_9(
            "%s kind=%d source=%u anchor=%s velocity=%s",
            "predictedSupportAtAck",
            Kind,
            SourceId,
            string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z),
            vectorLabel(PostSupport.Velocity)
        )
    else
        v1 = "predictedSupportAtAck=nil"
    end
    local v23 = stateLabel("authoritativeAtAck", a2.State)
    local Support = a2.Support
    if Support ~= nil then
        local format_10 = string.format
        local Kind_2 = Support.Kind
        local SourceId_2 = Support.SourceId
        local Anchor_2 = Support.Anchor
        v15 = format_10(
            "%s kind=%d source=%u anchor=%s velocity=%s",
            "authoritativeSupportAtAck",
            Kind_2,
            SourceId_2,
            string.format("(%+.8f,%+.8f,%+.8f)", Anchor_2.X, Anchor_2.Y, Anchor_2.Z),
            vectorLabel(Support.Velocity)
        )
    else
        v15 = "authoritativeSupportAtAck=nil"
    end
    local v24 = stateLabel("reconciledTail", a3.State)
    local Support_2 = a3.Support
    if Support_2 ~= nil then
        local format_11 = string.format
        local Kind_3 = Support_2.Kind
        local SourceId_3 = Support_2.SourceId
        local Anchor_3 = Support_2.Anchor
        v2 = format_11(
            "%s kind=%d source=%u anchor=%s velocity=%s",
            "reconciledTailSupport",
            Kind_3,
            SourceId_3,
            string.format("(%+.8f,%+.8f,%+.8f)", Anchor_3.X, Anchor_3.Y, Anchor_3.Z),
            vectorLabel(Support_2.Velocity)
        )
    else
        v2 = "reconciledTailSupport=nil"
    end
    local v25 = if v3 ~= nil then string.format(
        "remoteClock mode=%s driftTicks=%+.6f hardRebases=%d latestObservedTick=%s",
        v3.Mode,
        v3.DriftTicks,
        v3.HardRebases,
        (tostring(v3.LatestObservedTick))
    ) else "remoteClock=nil"
    v11[1] = v12
    v11[2] = v13
    v11[3] = v14
    v11[4] = v16
    v11[5] = v17
    v11[6] = v18
    v11[7] = v19
    v11[8] = v20
    v11[9] = v21
    v11[10] = v22
    v11[11] = v1
    v11[12] = v23
    v11[13] = v15
    v11[14] = v24
    v11[15] = v2
    v11[16] = v25
    self:reportIssue("OwnerCorrection", table.concat(v11, "\n"), {
        Generation = a2.Generation,
        Sequence = a2.Sequence,
        CommandNumber = a2.LastProcessedCommand,
        ServerTick = a2.ServerTick,
    })
end

function u112:_printOwnerTrace(a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 716
    -- upvalues: materialAckCorrection (val), output (val), State (val)
    local Metrics = a3.Metrics
    if Metrics.ReconciliationMode ~= "Reuse" and not Metrics.PlayerContactCorrection then
        if materialAckCorrection(Metrics) then
            output(string.format(
                "[MovementV2.Client] CORRECTION mode=%s barrier=%s seq=%u ack=%u tick=%u ackFields=%s ackPos=%.8f ackVel=%.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f tailTickDelta=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f held=%d synth=%s groundTail=%s stanceTail=%s supportTail=%d/%d",
                Metrics.ReconciliationMode,
                Metrics.ReplayBarrier,
                a2.Sequence,
                a2.LastProcessedCommand,
                a2.ServerTick,
                State.mismatchLabel(Metrics.CanonicalStateMismatchMask),
                Metrics.Position,
                Metrics.Velocity,
                Metrics.TailPosition,
                Metrics.TailVerticalPosition,
                Metrics.TailVelocity,
                Metrics.TailVerticalVelocity,
                Metrics.TailServerTickDelta,
                Metrics.ReplayCount,
                Metrics.ReconciliationWorkSeconds * 1000,
                Metrics.ReconciliationElapsedSeconds * 1000,
                Metrics.ReconciliationSliceCount,
                Metrics.ReconciliationMaximumSliceSeconds * 1000,
                Metrics.ServerHeldTickCount,
                tostring(Metrics.SynthesizedInput),
                tostring(Metrics.TailGroundMismatch),
                tostring(Metrics.TailStanceMismatch),
                Metrics.TailSupportKindMismatch,
                Metrics.TailSupportSourceMismatch
            ))
        else
            local TailCompared = Metrics.TailCompared
            if TailCompared then
                TailCompared = true
                if not (0.01 <= Metrics.TailPosition) then
                    TailCompared = true
                    if not (0.1 <= Metrics.TailVelocity) then
                        TailCompared = true
                        if not (0.01 <= Metrics.TailSupportAnchor) then
                            TailCompared = true
                            if not (0.1 <= Metrics.TailSupportVelocity) then
                                TailCompared = true
                                if not (0 < Metrics.TailSupportKindMismatch) then
                                    TailCompared = true
                                    if not (0 < Metrics.TailSupportSourceMismatch) then
                                        TailCompared = Metrics.TailGroundMismatch or Metrics.TailStanceMismatch
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if TailCompared then
                output(string.format(
                    "[MovementV2.Client] CORRECTION mode=%s barrier=%s seq=%u ack=%u tick=%u ackFields=%s ackPos=%.8f ackVel=%.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f tailTickDelta=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f held=%d synth=%s groundTail=%s stanceTail=%s supportTail=%d/%d",
                    Metrics.ReconciliationMode,
                    Metrics.ReplayBarrier,
                    a2.Sequence,
                    a2.LastProcessedCommand,
                    a2.ServerTick,
                    State.mismatchLabel(Metrics.CanonicalStateMismatchMask),
                    Metrics.Position,
                    Metrics.Velocity,
                    Metrics.TailPosition,
                    Metrics.TailVerticalPosition,
                    Metrics.TailVelocity,
                    Metrics.TailVerticalVelocity,
                    Metrics.TailServerTickDelta,
                    Metrics.ReplayCount,
                    Metrics.ReconciliationWorkSeconds * 1000,
                    Metrics.ReconciliationElapsedSeconds * 1000,
                    Metrics.ReconciliationSliceCount,
                    Metrics.ReconciliationMaximumSliceSeconds * 1000,
                    Metrics.ServerHeldTickCount,
                    tostring(Metrics.SynthesizedInput),
                    tostring(Metrics.TailGroundMismatch),
                    tostring(Metrics.TailStanceMismatch),
                    Metrics.TailSupportKindMismatch,
                    Metrics.TailSupportSourceMismatch
                ))
            end
        end
    end
    local v1 = 1 <= a5 - self._lastSummaryAt
    local v2 = a6 and 0.25 <= a5 - self._lastAnomalyAt
    if not v1 and not v2 then
        return
    end
    if v1 then
        self._lastSummaryAt = a5
    end
    if v2 then
        self._lastAnomalyAt = a5
    end
    local _predictionRing = self._runtime._predictionRing
    local _replayTotal = self._replayTotal
    local format_2 = string.format
    local ReconciliationMode_2 = Metrics.ReconciliationMode
    local ReplayBarrier_2 = Metrics.ReplayBarrier
    local Sequence_2 = a2.Sequence
    local LastProcessedCommand_2 = a2.LastProcessedCommand
    local ServerTick_3 = a2.ServerTick
    local AcknowledgedCommandDelta = Metrics.AcknowledgedCommandDelta
    local ServerTickDelta = Metrics.ServerTickDelta
    local ServerHeldTickCount_2 = Metrics.ServerHeldTickCount
    local v3 = tostring(Metrics.SynthesizedInput)
    local _reconciliationCount = self._reconciliationCount
    local ReplayCount_2 = a3.ReplayCount
    local v4 = Metrics.ReconciliationWorkSeconds * 1000
    local v5 = Metrics.ReconciliationElapsedSeconds * 1000
    local ReconciliationSliceCount_2 = Metrics.ReconciliationSliceCount
    local v6 = Metrics.ReconciliationMaximumSliceSeconds * 1000
    local _replayMax = self._replayMax
    local v7 = if _predictionRing ~= nil then _predictionRing:count() else 0
    local _ownerReceived = self._ownerReceived
    local _ownerApplied = self._ownerApplied
    local TailServerTick = a3.TailServerTick
    local TailServerTickDelta = Metrics.TailServerTickDelta
    local v8 = State.mismatchLabel(Metrics.CanonicalStateMismatchMask)
    local CanonicalStateMismatchMask = Metrics.CanonicalStateMismatchMask
    local CanonicalStateMismatchCount = Metrics.CanonicalStateMismatchCount
    local Position = Metrics.Position
    local Velocity = Metrics.Velocity
    local TailPosition = Metrics.TailPosition
    local TailVerticalPosition = Metrics.TailVerticalPosition
    local TailVelocity = Metrics.TailVelocity
    local TailVerticalVelocity = Metrics.TailVerticalVelocity
    local v9 = if a4 ~= nil then tostring(a4.PostState.OnGround) else "nil"
    local v10 = tostring(a2.State.OnGround)
    local PostSupport = if a4 ~= nil then a4.PostSupport else nil
    local v11 = if PostSupport ~= nil then ("%*:%*"):format(PostSupport.Kind, PostSupport.SourceId) else "nil"
    local Support = a2.Support
    local v12 = if Support ~= nil then ("%*:%*"):format(Support.Kind, Support.SourceId) else "nil"
    local Stance = if a4 ~= nil then a4.PostState.Stance else "nil"
    local Stance_2 = a2.State.Stance
    local v13 = if a4 ~= nil then tostring(a4.PostState.JumpHullActive) else "nil"
    local JumpHullActive_2 = a2.State.JumpHullActive
    output(format_2(
        "[MovementV2.Client] owner mode=%s barrier=%s seq=%u ack=%u ackTick=%s/%u ackAdvance=%d tickAdvance=%d held=%d synth=%s newest=%s lead=%d reconcileCount=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f avgReplay=%.1f maxReplay=%d ring=%d recv/applied=%d/%d tailTick=%u tailTickDelta=%d fields=%s mismatch=0x%X/%d posErr=%.8f yErr=%+.8f velErr=%.8f vyErr=%+.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f ground=%s/%s support=%s/%s stance=%s/%s jumpHull=%s/%s",
        ReconciliationMode_2,
        ReplayBarrier_2,
        Sequence_2,
        LastProcessedCommand_2,
        if a4 ~= nil then tostring(a4.ServerTick) else "nil",
        ServerTick_3,
        AcknowledgedCommandDelta,
        ServerTickDelta,
        ServerHeldTickCount_2,
        v3,
        if a9 ~= nil then tostring(a9) else "nil",
        a10,
        _reconciliationCount,
        ReplayCount_2,
        v4,
        v5,
        ReconciliationSliceCount_2,
        v6,
        _replayTotal / math.max(self._ownerApplied, 1),
        _replayMax,
        v7,
        _ownerReceived,
        _ownerApplied,
        TailServerTick,
        TailServerTickDelta,
        v8,
        CanonicalStateMismatchMask,
        CanonicalStateMismatchCount,
        Position,
        a7,
        Velocity,
        a8,
        TailPosition,
        TailVerticalPosition,
        TailVelocity,
        TailVerticalVelocity,
        v9,
        v10,
        v11,
        v12,
        Stance,
        Stance_2,
        v13,
        (tostring(JumpHullActive_2))
    ))
end

function u112.recordOwnerApplied(a1, a2, a3, a4) -- Line: 829
    -- upvalues: DiagnosticProtocol (val), Players (val), Serial (val), PredictionErrorSmoother (val)
    -- upvalues: materialAckCorrection (val), Config (val)
    local _runtime = a1._runtime
    local Metrics = a3.Metrics
    a1:_recordReplayWindow(a3)
    a1._ownerApplied = a1._ownerApplied + 1
    a1._replayTotal = a1._replayTotal + a3.ReplayCount
    a1._replayMax = math.max(a1._replayMax, a3.ReplayCount)
    local v1 = true
    if Metrics.ReconciliationMode ~= "Replay" then
        v1 = Metrics.ReconciliationMode == "Reanchor"
    end
    if v1 then
        a1._reconciliationCount = a1._reconciliationCount + 1
    end
    local v2 = a1:reportingEnabled()
    local OwnerTraceEnabled = DiagnosticProtocol.OwnerTraceEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer)
    if not v2 and not OwnerTraceEnabled then
        return
    end
    local v3 = os.clock()
    local v4 = if a4 ~= nil then a4.PostState.Position.Y - a2.State.Position.Y else 0
    local v5 = if a4 ~= nil then a4.PostState.Velocity.Y - a2.State.Velocity.Y else 0
    local _predictionRing = _runtime._predictionRing
    local v6 = if _predictionRing ~= nil then _predictionRing:newestCommandNumber() else nil
    local v7 = if v6 ~= nil then math.max(Serial.deltaUInt32(v6, a2.LastProcessedCommand), 0) else 0
    local ComparedAtAck = Metrics.ComparedAtAck
    if ComparedAtAck then
        ComparedAtAck = true
        if not (0 < Metrics.CanonicalStateMismatchCount) then
            ComparedAtAck = Metrics.CanonicalSupportMismatch
        end
    end
    local SynthesizedInput = false
    if Metrics.ReconciliationMode ~= "Initial" then
        SynthesizedInput = true
        if Metrics.ReconciliationMode ~= "Reanchor" then
            SynthesizedInput = Metrics.SynthesizedInput
            if not SynthesizedInput then
                SynthesizedInput = ComparedAtAck
                if not SynthesizedInput then
                    SynthesizedInput = Metrics.TailCompared and PredictionErrorSmoother.isHardSnapCorrection(Metrics)
                    if not SynthesizedInput then
                        SynthesizedInput = false
                        if Metrics.ReconciliationMode ~= "Reuse" then
                            SynthesizedInput = materialAckCorrection(Metrics)
                            if not SynthesizedInput then
                                SynthesizedInput = Metrics.TailCompared
                                if SynthesizedInput then
                                    SynthesizedInput = true
                                    if not (0.01 <= Metrics.TailPosition) then
                                        SynthesizedInput = true
                                        if not (0.1 <= Metrics.TailVelocity) then
                                            SynthesizedInput = true
                                            if not (0.01 <= Metrics.TailSupportAnchor) then
                                                SynthesizedInput = true
                                                if not (0.1 <= Metrics.TailSupportVelocity) then
                                                    SynthesizedInput = true
                                                    if not (0 < Metrics.TailSupportKindMismatch) then
                                                        SynthesizedInput = true
                                                        if not (0 < Metrics.TailSupportSourceMismatch) then
                                                            SynthesizedInput = Metrics.TailGroundMismatch or Metrics.TailStanceMismatch
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if v2 and v1 and not SynthesizedInput then
        a1:reportIssue("Reconciliation", string.format(
            "issue=Reconciliation count=%d mode=%s barrier=%s generation=%u sequence=%u ackCommand=%u authorityTick=%u tailTick=%u replay=%d retiredAckedPredictions=%d heldTicks=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f ackPos=%.8f ackVel=%.8f tailPos=%.8f tailVel=%.8f",
            a1._reconciliationCount,
            Metrics.ReconciliationMode,
            Metrics.ReplayBarrier,
            a2.Generation,
            a2.Sequence,
            a2.LastProcessedCommand,
            a2.ServerTick,
            a3.TailServerTick,
            Metrics.ReplayCount,
            Metrics.DroppedCommandCount,
            Metrics.ServerHeldTickCount,
            Metrics.ReconciliationWorkSeconds * 1000,
            Metrics.ReconciliationElapsedSeconds * 1000,
            Metrics.ReconciliationSliceCount,
            Metrics.ReconciliationMaximumSliceSeconds * 1000,
            Metrics.Position,
            Metrics.Velocity,
            Metrics.TailPosition,
            Metrics.TailVelocity
        ), {
            Generation = a2.Generation,
            Sequence = a2.Sequence,
            CommandNumber = a2.LastProcessedCommand,
            ServerTick = a2.ServerTick,
        })
    end
    if v2 and SynthesizedInput then
        a1:_reportOwnerCorrection(a2, a3, a4, v3, v4, v5, v6, v7)
    end
    if not OwnerTraceEnabled then
        return
    end
    local v8 = math.max(1, (math.ceil(0.0625 * (_runtime._config or Config.Default).SimulationHz)))
    local v9 = false
    if a4 ~= nil then
        v9 = a4.PostState.OnGround ~= a2.State.OnGround
    end
    local v10 = false
    if a4 ~= nil then
        v10 = true
        if a4.PostSupport.Kind == a2.Support.Kind then
            v10 = a4.PostSupport.SourceId ~= a2.Support.SourceId
        end
    end
    local v11 = true
    if not (v8 <= a3.ReplayCount) then
        v11 = true
        if Metrics.ReconciliationMode ~= "Reanchor" then
            v11 = true
            if not (0 < Metrics.ServerHeldTickCount) then
                v11 = true
                if not (0.01 <= (math.abs(v4))) then
                    v11 = true
                    if not (0.1 <= (math.abs(v5))) then
                        v11 = v9 or v10
                    end
                end
            end
        end
    end
    a1:_printOwnerTrace(a2, a3, a4, v3, v11, v4, v5, v6, v7)
end

function u112:_traceAirStrafe(a2, a3, a4, a5, a6) -- Line: 948
    -- upvalues: RuntimeSettings (val), output (val), Workspace (val), ProvenMath (val)
    local v1, v2
    local _airStrafePreviousYaw = self._airStrafePreviousYaw
    self._airStrafePreviousYaw = a2.LookYaw
    if 320 <= self._airStrafeLineCount then
        return
    end
    if a5.OnGround and a6.OnGround then
        return
    end
    local _runtime = self._runtime
    local v3 = assert(_runtime._config)
    local v4 = RuntimeSettings.getMovementConfig(v3.SimulationHz)
    local v5 = false
    if 0 < v4.BunnyHopAirAccelerate then
        v5 = v4.PositionSnapEpsilon < v4.BunnyHopAirSpeedCap
    end
    if not self._airStrafeHeaderPrinted then
        self._airStrafeHeaderPrinted = true
        local format = string.format
        v1 = if not v5 then "source" else "relaxed"
        output(format(
            "[MovementV2.AirStrafe] BEGIN version=1 generation=%u gamemode=%s profile=%s simulationHz=%u airAccelerate=%.6f airSpeedCap=%.6f bunnyHopAirAccelerate=%.6f bunnyHopAirSpeedCap=%.6f",
            assert(_runtime._mapping).Generation,
            tostring((Workspace:GetAttribute("ServerGamemode"))),
            v1,
            v3.SimulationHz,
            v4.AirAccelerate,
            v4.AirSpeedCap,
            v4.BunnyHopAirAccelerate,
            v4.BunnyHopAirSpeedCap
        ))
    end
    local v6 = ProvenMath.moveVectorToWorld(a2.Move, a2.LookYaw)
    local Unit = if not (1e-06 < v6.Magnitude) then Vector3.new(0, 0, 0) else v6.Unit
    local v7 = Vector3.new(a5.Velocity.X, 0, a5.Velocity.Z)
    local v8 = Vector3.new(a6.Velocity.X, 0, a6.Velocity.Z)
    local v9 = v8 - v7
    v1 = v7:Dot(Unit)
    local BunnyHopAirSpeedCap_2 = if not v5 then v4.AirSpeedCap else v4.BunnyHopAirSpeedCap
    local v10 = BunnyHopAirSpeedCap_2 - v1
    local v11 = math.min(
        if not v5 then v4.AirAccelerate * a5.BaseMoveSpeed * a5.VelocityModifier * v3.StepSeconds * a5.GroundSurfaceFriction else v4.BunnyHopAirAccelerate * BunnyHopAirSpeedCap_2 * v3.StepSeconds,
        (math.max(v10, 0))
    )
    local v12 = if not a5.OnGround then if a5.OnGround then "air" else if not a6.OnGround then "air" else "landing" else if a6.OnGround then if a5.OnGround then "air" else if not a6.OnGround then "air" else "landing" else "takeoff"
    self._airStrafeLineCount = self._airStrafeLineCount + 1
    output(string.format(
        "[MovementV2.AirStrafe] cmd=%u tick=%u phase=%s alpha=%.4f buttons=%u move=(%+.4f,%+.4f) yawDeg=%+.3f yawDeltaDeg=%+.3f wish=(%+.5f,%+.5f) wishVsVelocityDeg=%+.3f velocityTurnDeg=%+.3f speed=%.6f->%.6f speedDelta=%+.6f directionalSpeed=%+.6f room=%+.6f fullWishImpulse=%.6f expectedImpulse=%.6f appliedAlongWish=%+.6f baseSpeed=%.6f velocityModifier=%.6f stamina=%.6f surfaceFriction=%.6f wallNormal=%.6f",
        a2.CommandNumber,
        a3,
        v12,
        a4,
        a2.Buttons,
        a2.Move.X,
        a2.Move.Y,
        math.deg(a2.LookYaw),
        math.deg(if _airStrafePreviousYaw ~= nil then math.atan2(math.sin(a2.LookYaw - _airStrafePreviousYaw), (math.cos(a2.LookYaw - _airStrafePreviousYaw))) else 0),
        Unit.X,
        Unit.Z,
        math.deg(if v7.Magnitude <= 1e-06 then 0 else if not (Unit.Magnitude <= 1e-06) then math.atan2(v7.X * Unit.Z - v7.Z * Unit.X, (v7:Dot(Unit))) else 0),
        math.deg(if v7.Magnitude <= 1e-06 then 0 else if not (v8.Magnitude <= 1e-06) then math.atan2(v7.X * v8.Z - v7.Z * v8.X, (v7:Dot(v8))) else 0),
        v7.Magnitude,
        v8.Magnitude,
        v8.Magnitude - v7.Magnitude,
        v1,
        v10,
        v2,
        v11,
        v9:Dot(Unit),
        a5.BaseMoveSpeed,
        a5.VelocityModifier,
        a5.Stamina,
        a5.GroundSurfaceFriction,
        a6.WallNormal.Magnitude
    ))
    if self._airStrafeLineCount == 320 then
        output((("[MovementV2.AirStrafe] COMPLETE reason=lineLimit lines=%*"):format(320)))
    end
end

function u112.recordPredictedStep(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 1048
    -- upvalues: DiagnosticProtocol (val), Players (val), output (val)
    if not DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) then
        return
    end
    if DiagnosticProtocol.AirStrafeTraceEnabled then
        a1:_traceAirStrafe(a2, a3, a4, a5, a6)
    end
    if DiagnosticProtocol.OwnerTraceEnabled then
        if a8.Jumped or a8.Landed or a8.LeftGround then
            output(string.format(
                "[MovementV2.Client] transition cmd=%u tick=%u jumped=%s landed=%s leftGround=%s y=%.5f vy=%.5f onGround=%s stance=%s jumpHull=%s support=%s",
                a2.CommandNumber,
                a3,
                tostring(a8.Jumped),
                tostring(a8.Landed),
                tostring(a8.LeftGround),
                a6.Position.Y,
                a6.Velocity.Y,
                tostring(a6.OnGround),
                a6.Stance,
                tostring(a6.JumpHullActive),
                if a7 ~= nil then ("%*:%*"):format(a7.Kind, a7.SourceId) else "nil"
            ))
        end
    end
end

function u112.emitNetcodeSummary(a1) -- Line: 1084 -- upvalues: u111 (val), Players (val), Serial (val)
    local format_9, v1
    local v2 = os.clock()
    if v2 - a1._summaryAt < u111.NetcodeSummary then
        return
    end
    if not a1:reportingEnabled() then
        a1._summaryAt = v2
        a1:_resetWindow()
        return
    end
    local _runtime = a1._runtime
    local _window = a1._window
    local v3 = math.max(v2 - a1._summaryAt, 1e-06)
    a1._summaryAt = v2
    local v4 = {}
    for i, j in _window.BarrierCounts do
        table.insert(v4, (string.format("%s=%d", i, j)))
    end
    table.sort(v4)
    a1:recordStatusChange(_runtime._status)
    local v5 = {}
    for k, n in _window.StatusDwellSeconds do
        if n >= 0.001 then
            format_9 = string.format
            v1 = n * 1000
            table.insert(v5, (format_9("%s=%.0fms", k, v1)))
        end
    end
    table.sort(v5)
    local _commandClock = _runtime._commandClock
    local v6 = if _commandClock ~= nil then _commandClock:diagnostics() else nil
    local _remoteClock = _runtime._remoteClock
    local v7 = if _remoteClock ~= nil then _remoteClock:diagnostics() else nil
    local _config = _runtime._config
    local _predictionRing = _runtime._predictionRing
    local _commandStream = _runtime._commandStream
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot
    local v8 = if _commandStream ~= nil then _commandStream:lastSampledCommandNumber() else nil
    local v9 = _runtime._uplink:counters()
    v1 = math.max(_window.DepthSamples, 1)
    local v10 = math.max(_window.Frames, 1)
    local concat = table.concat
    local v11 = {}
    local v12 = string.format(
        "issue=NetcodeSummary windowSeconds=%.2f status=%s statusReason=%s ping=%.0fms",
        v3,
        _runtime._status,
        tostring(_runtime._reason),
        Players.LocalPlayer:GetNetworkPing() * 1000
    )
    local format_2 = string.format
    local v13 = _window.DepthSum / v1
    local v14 = tostring(_window.WorstDepth)
    local StallSamples = _window.StallSamples
    local DepthSamples_2 = _window.DepthSamples
    local StalledFlagSamples = _window.StalledFlagSamples
    local LongestStalledRun = _window.LongestStalledRun
    local Rate = if v6 ~= nil then v6.Rate else 1
    local v15 = if v6 ~= nil then tostring(v6.TargetDepth) else "nil"
    local v16 = if v6 ~= nil then tostring(v6.ErrorTicks) else "nil"
    local v17 = format_2(
        "reservoir meanDepth=%.2f worstDepth=%s negativeSamples=%d/%d stalledFlag=%d longestStalledRun=%d clockRate=%.4f clockWorst=%s clockTarget=%s clockError=%s",
        v13,
        v14,
        StallSamples,
        DepthSamples_2,
        StalledFlagSamples,
        LongestStalledRun,
        Rate,
        if v6 ~= nil then tostring(v6.WorstDepth) else "nil",
        v15,
        v16
    )
    local v18 = string.format(
        "pacing frames=%d commandsPerSecond=%.1f stepsPerFrame=%.2f maxStepsInFrame=%d discardedMs=%.2f ceilingBreaks=%d accumulatorMs=%.2f",
        _window.Frames,
        _window.StepsDrained / v3,
        _window.StepsDrained / v10,
        _window.MaxStepsInFrame,
        _window.DiscardedSeconds * 1000,
        _window.CeilingBreaks,
        _runtime._accumulatorSeconds * 1000
    )
    local format_4 = string.format
    local _ownerReceived = a1._ownerReceived
    local _ownerApplied = a1._ownerApplied
    local v19 = _window.ReplayEvents / v3
    local v20 = _window.ReplayCommands / v3
    local v21 = _window.CorrectionCount / v3
    local MaxCorrection = _window.MaxCorrection
    v16 = if _predictionRing ~= nil then _predictionRing:capacity() else 0
    local v22 = if v8 == nil then "nil" else if _lastAcceptedOwnerSnapshot ~= nil then tostring((Serial.deltaUInt32(v8, _lastAcceptedOwnerSnapshot.LastProcessedCommand))) else "nil"
    v13 = format_4(
        "reconcile ownerRecv=%d ownerApplied=%d replayEvents=%.2f/s replayCommands=%.2f/s corrections=%.2f/s maxCorrection=%.5f ring=%d/%d lead=%s",
        _ownerReceived,
        _ownerApplied,
        v19,
        v20,
        v21,
        MaxCorrection,
        if _predictionRing ~= nil then _predictionRing:count() else 0,
        v16,
        v22
    )
    local format_5 = string.format
    local RemoteFramesSeen = _window.RemoteFramesSeen
    local RemoteSequenceGaps = _window.RemoteSequenceGaps
    local RemoteSequenceGaps_2 = _window.RemoteSequenceGaps
    local RemoteFramesSeen_2 = _window.RemoteFramesSeen
    local RemoteBaselineRejects = _window.RemoteBaselineRejects
    local RemoteOtherRejects = _window.RemoteOtherRejects
    local RemoteActorSamples = _window.RemoteActorSamples
    v16 = 100 * (_window.RemoteStaleSamples / math.max(1, _window.RemoteActorSamples))
    v22 = 100 * (_window.RemoteMissingSamples / math.max(1, _window.RemoteActorSamples))
    local RemoteBlindFrames = _window.RemoteBlindFrames
    local v23 = _window.RemoteLongestBlindSeconds * 1000
    local Mode = if v7 ~= nil then v7.Mode else "nil"
    local DriftTicks = if v7 ~= nil then v7.DriftTicks else 0
    local HardRebases = if v7 ~= nil then v7.HardRebases else 0
    local DelayMs = if v7 ~= nil then v7.DelayMs else 0
    local v24 = v7 ~= nil and v7.WindowMinMarginMs or 0
    local Rate_2 = if v7 ~= nil then v7.Rate else 1
    local ExtrapolatingFrames = if v7 ~= nil then v7.ExtrapolatingFrames else 0
    local HoldingFrames = if v7 ~= nil then v7.HoldingFrames else 0
    v14 = format_5(
        "remote framesSeen=%d seqGaps=%d rxLoss=%.2f%% baselineRejects=%d otherRejects=%d actorSamples=%d stale=%.2f%% missing=%.2f%% blindFrames=%d longestBlindMs=%.1f clock=%s drift=%.2f rebases=%d delayMs=%.1f minMarginMs=%.1f rate=%.3f extrapFrames=%d holdFrames=%d",
        RemoteFramesSeen,
        RemoteSequenceGaps,
        100 * (RemoteSequenceGaps_2 / math.max(1, RemoteFramesSeen_2 + _window.RemoteSequenceGaps)),
        RemoteBaselineRejects,
        RemoteOtherRejects,
        RemoteActorSamples,
        v16,
        v22,
        RemoteBlindFrames,
        v23,
        Mode,
        DriftTicks,
        HardRebases,
        DelayMs,
        v24,
        Rate_2,
        ExtrapolatingFrames,
        HoldingFrames
    )
    local v25 = string.format(
        "uplink commandPackets=%.1f/s recoveryPackets=%.1f/s budgetDeferrals=%d",
        (v9.PacketsSent - _window.CommandPacketsBase) / v3,
        (v9.RecoveryPacketsSent - _window.RecoveryPacketsBase) / v3,
        v9.BudgetDeferrals - _window.SendDeferralsBase
    )
    local v26 = string.format(
        "recovery resyncRequests=%d mappingRequests=%d dwell=%s",
        _window.ResyncRequests,
        _window.MappingRequests,
        if #v5 ~= 0 then table.concat(v5, " ") else "none"
    )
    v19 = "barriers " .. (if #v4 ~= 0 then table.concat(v4, " ") else "none")
    local format_8 = string.format
    v15 = if _config ~= nil then tostring(_config.CommandBufferTargetTicks) else "nil"
    v16 = if _config ~= nil then tostring(_config.CommandCatchUpBankTicks) else "nil"
    v22 = if _config ~= nil then tostring(_config.MaxPredictionFrameTicks) else "nil"
    local v27 = if _config ~= nil then tostring(_config.PredictionAccumulatorTicks) else "nil"
    v11[1] = v12
    v11[2] = v17
    v11[3] = v18
    v11[4] = v13
    v11[5] = v14
    v11[6] = v25
    v11[7] = v26
    v11[8] = v19
    v11[9] = format_8(
        "policy simulationHz=%s bufferTarget=%s catchUpBank=%s maxFrameTicks=%s accumulatorTicks=%s",
        if _config ~= nil then tostring(_config.SimulationHz) else "nil",
        v15,
        v16,
        v22,
        v27
    )
    a1:reportIssue("NetcodeSummary", (concat(v11, "\n")))
    a1:_resetWindow()
end

function u112.connectOutput(a1, a2) -- Line: 1223 -- upvalues: DiagnosticProtocol (val), Players (val), RunService (val)
    if not DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) then
        return {}
    end
    local _output = a1._output
    return {
        a2.Diagnostics.OnClientEvent:Connect(function(a1) -- Line: 1229 -- upvalues: DiagnosticProtocol (upval), _output (val)
            local v1 = DiagnosticProtocol.decodeDelivery(a1)
            if v1 ~= nil then
                _output:queue(v1)
            end
        end),
        (RunService.Heartbeat:Connect(function() -- Line: 1235 -- upvalues: _output (val)
            _output:drain()
        end)),
    }
end

function u112.clearOutput(a1) -- Line: 1241
    a1._output:clear()
end

return table.freeze(u112)