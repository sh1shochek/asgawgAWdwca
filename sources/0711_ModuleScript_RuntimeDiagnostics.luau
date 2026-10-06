-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Config = require(script.Parent.Parent.Config);
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol);
local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local ProvenMath = require(script.Parent.Parent.Simulation.ProvenMath);
local RuntimeSettings = require(script.Parent.Parent.Simulation.RuntimeSettings);
local State = require(script.Parent.Parent.Simulation.State);
require(script.Parent.Parent.Simulation.Types);
require(script.Parent.Parent.Transport);
local CorrectionDiagnostics = require(script.Parent.CorrectionDiagnostics);
local DiagnosticOutput = require(script.Parent.DiagnosticOutput);
local PredictionErrorSmoother = require(script.Parent.PredictionErrorSmoother);
require(script.Parent.PredictionRing);
require(script.Parent.Reconciler);
require(script.Parent.RuntimeTypes);
local table_freeze_ret = table.freeze({
    OwnerCorrection = 5,
    Reconciliation = 5,
    TraceComparison = 0.5,
    PredictionHitch = 10,
    RuntimeWarning = 5,
    NetcodeSummary = 10
});
local u1 = {};
u1.__index = u1;
local output = DiagnosticProtocol.output;

local function materialAckCorrection(p2) -- Line: 121
    return p2.ComparedAtAck and ((p2.Position >= 0.01 or (p2.Velocity >= 0.1 or (p2.SupportAnchor >= 0.01 or (p2.SupportVelocity >= 0.1 or (p2.LookYaw >= 0.004363323129985824 or (p2.VerticalLook >= 0.004363323129985824 or (p2.DuckAmount >= 0.01 or (p2.Stamina >= 0.01 or p2.SupportKindMismatch > 0)))))))) and true or p2.SupportSourceMismatch > 0);
end;

local function materialTailCorrection(p3) -- Line: 137
    return p3.TailCompared and ((p3.TailPosition >= 0.01 or (p3.TailVelocity >= 0.1 or (p3.TailSupportAnchor >= 0.01 or (p3.TailSupportVelocity >= 0.1 or (p3.TailSupportKindMismatch > 0 or p3.TailSupportSourceMismatch > 0))))) and true or (p3.TailGroundMismatch or p3.TailStanceMismatch));
end;

local function presentationSnapCorrection(p4) -- Line: 151
    -- upvalues: PredictionErrorSmoother (copy)
    local v5 = p4.TailCompared and PredictionErrorSmoother.isHardSnapCorrection(p4);

    return v5;
end;

local function mappingLabel(p6) -- Line: 155
    return p6 == nil and "mapping=nil" or string.format("mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s", p6.Generation, p6.ActorId, p6.SimulationHz, p6.TopologyEpoch, p6.TopologyFingerprint, (tostring(p6.PlayerCollisionsEnabled)));
end;

local function supportIdentityLabel(p7) -- Line: 170
    return p7 == nil and "nil" or `{p7.Kind}:{p7.SourceId}`;
end;

local function vectorLabel(p8: vector) -- Line: 177
    return string.format("(%+.8f,%+.8f,%+.8f)", p8.X, p8.Y, p8.Z);
end;

local function stateLabel(p9: string, p10: any) -- Line: 181
    if p10 == nil then
        return `{p9}=nil`;
    end;

    local string_format = string.format;
    local Position = p10.Position;
    local string_format_ret = string.format("(%+.8f,%+.8f,%+.8f)", Position.X, Position.Y, Position.Z);
    local Velocity = p10.Velocity;
    local string_format_ret2 = string.format("(%+.8f,%+.8f,%+.8f)", Velocity.X, Velocity.Y, Velocity.Z);
    local LookYaw = p10.LookYaw;
    local VerticalLook = p10.VerticalLook;
    local BaseMoveSpeed = p10.BaseMoveSpeed;
    local WeaponMoveSpeed = p10.WeaponMoveSpeed;
    local WeaponScopedMoveSpeed = p10.WeaponScopedMoveSpeed;
    local VelocityModifier = p10.VelocityModifier;
    local MovementMode = p10.MovementMode;
    local Stance = p10.Stance;
    local v11 = tostring(p10.OnGround);
    local GroundNormal = p10.GroundNormal;
    local string_format_ret3 = string.format("(%+.8f,%+.8f,%+.8f)", GroundNormal.X, GroundNormal.Y, GroundNormal.Z);
    local WallNormal = p10.WallNormal;

    return string_format("%s pos=%s vel=%s yaw=%+.8f verticalLook=%+.8f baseSpeed=%.5f weaponProfile=%.5f/%.5f velocityModifier=%.6f mode=%s stance=%s onGround=%s groundNormal=%s wallNormal=%s friction=%.6f duck=%.6f duckMs=%.3f isDucking=%s duckSpeed=%.6f duckCooldown=%.6f stamina=%.6f lastJumpCmd=%u buttons=0x%02X jumpBuffer=%d jumpHull=%s stuckTicks=%d", p9, string_format_ret, string_format_ret2, LookYaw, VerticalLook, BaseMoveSpeed, WeaponMoveSpeed, WeaponScopedMoveSpeed, VelocityModifier, MovementMode, Stance, v11, string_format_ret3, string.format("(%+.8f,%+.8f,%+.8f)", WallNormal.X, WallNormal.Y, WallNormal.Z), p10.GroundSurfaceFriction, p10.DuckAmount, p10.DuckTimeMsecs, tostring(p10.IsDucking), p10.DuckSpeed, p10.DuckCooldownSeconds, p10.Stamina, p10.LastJumpCommandNumber, p10.PreviousButtons, p10.JumpBufferTicksRemaining, tostring(p10.JumpHullActive), p10.StuckStepTicks);
end;

local function supportLabel(p12: string, p13: any) -- Line: 216
    -- upvalues: vectorLabel (copy)
    if p13 == nil then
        return `{p12}=nil`;
    end;

    local Anchor = p13.Anchor;

    return string.format("%s kind=%d source=%u anchor=%s velocity=%s", p12, p13.Kind, p13.SourceId, string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z), vectorLabel(p13.Velocity));
end;

local function snapshotIdentity(p14) -- Line: 231
    return {
        Generation = p14.Generation,
        Sequence = p14.Sequence,
        CommandNumber = p14.LastProcessedCommand,
        ServerTick = p14.ServerTick
    };
end;

local function tailIdentity(p15) -- Line: 241
    local _lastAcceptedOwnerSnapshot = p15._lastAcceptedOwnerSnapshot;
    local v16 = {};
    local v17;

    if _lastAcceptedOwnerSnapshot == nil then
        v17 = nil;
    else
        v17 = _lastAcceptedOwnerSnapshot.Sequence;
    end;

    v16.Sequence = v17;
    local v18;

    if _lastAcceptedOwnerSnapshot == nil then
        v18 = nil;
    else
        v18 = _lastAcceptedOwnerSnapshot.LastProcessedCommand;
    end;

    v16.CommandNumber = v18;

    return v16;
end;

local function signedHorizontalAngle(p19: vector, p20: vector) -- Line: 249
    if p19.Magnitude <= 1e-6 or p20.Magnitude <= 1e-6 then
        return 0;
    end;

    local v21 = p19.X * p20.Z - p19.Z * p20.X;
    local v22 = p19:Dot(p20);

    return math.atan2(v21, v22);
end;

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
        CorrectionCount = 0
    };
end;

function u1.new(p23) -- Line: 295
    -- upvalues: DiagnosticOutput (copy), newWindow (copy), u1 (copy)
    local os_clock_ret = os.clock();
    local v24 = {
        _ownerReceived = 0,
        _ownerApplied = 0,
        _replayTotal = 0,
        _replayMax = 0,
        _reconciliationCount = 0,
        _lastSummaryAt = 0,
        _lastAnomalyAt = 0,
        _airStrafeHeaderPrinted = false,
        _airStrafeLineCount = 0,
        _runtime = p23,
        _output = DiagnosticOutput.new(),
        _window = newWindow(),
        _summaryAt = os_clock_ret,
        _lastReportAtByKind = {}
    };

    return setmetatable(v24, u1);
end;

function u1.reportingEnabled(p25) -- Line: 315
    -- upvalues: DiagnosticProtocol (copy), Players (copy)
    return DiagnosticProtocol.shouldReport(Players.LocalPlayer);
end;

function u1._resetWindow(p26) -- Line: 320
    -- upvalues: newWindow (copy)
    local v27 = newWindow();
    v27.RemoteBlindRunStartedAt = p26._window.RemoteBlindRunStartedAt;
    local v28 = p26._runtime._uplink:counters();
    v27.CommandPacketsBase = v28.PacketsSent;
    v27.RecoveryPacketsBase = v28.RecoveryPacketsSent;
    v27.SendDeferralsBase = v28.BudgetDeferrals;
    p26._window = v27;
end;

function u1.resetGeneration(p29) -- Line: 332
    p29._ownerReceived = 0;
    p29._ownerApplied = 0;
    p29._replayTotal = 0;
    p29._replayMax = 0;
    p29._reconciliationCount = 0;
    p29._lastSummaryAt = 0;
    p29._lastAnomalyAt = 0;
    table.clear(p29._lastReportAtByKind);
    p29:_resetWindow();
    p29._remoteLastSequence = nil;
end;

function u1.reportIssue(p30: table, p31: any, p32: string, p33: any) -- Line: 345
    -- upvalues: table_freeze_ret (copy), DiagnosticProtocol (copy), Workspace (copy)
    local _runtime = p30._runtime;
    local _channels = _runtime._channels;

    if _channels == nil or not p30:reportingEnabled() then
        return;
    end;

    local os_clock_ret = os.clock();

    if (table_freeze_ret[p31] or 5) > os_clock_ret - (p30._lastReportAtByKind[p31] or (-1 / 0)) then
        return;
    end;

    p30._lastReportAtByKind[p31] = os_clock_ret;
    local _mapping = _runtime._mapping;
    local v34 = p33 or {};
    local Diagnostics = _channels.Diagnostics;
    local v35 = {
        Version = DiagnosticProtocol.Version,
        Kind = p31
    };
    local Generation = v34.Generation;

    if not Generation then
        if _mapping == nil then
            Generation = nil;
        else
            Generation = _mapping.Generation;
        end;
    end;

    v35.Generation = Generation;
    local ActorId = v34.ActorId;

    if not ActorId then
        if _mapping == nil then
            ActorId = nil;
        else
            ActorId = _mapping.ActorId;
        end;
    end;

    v35.ActorId = ActorId;
    v35.Sequence = v34.Sequence;
    v35.CommandNumber = v34.CommandNumber;
    v35.ServerTick = v34.ServerTick or _runtime._lastPredictedServerTick;
    v35.ClientServerTime = Workspace:GetServerTimeNow();
    v35.ClientLog = string.sub(p32, 1, DiagnosticProtocol.MaxClientLogBytes);
    Diagnostics:FireServer(v35);
end;

function u1.reportWarning(p36: table, p37: string) -- Line: 374
    -- upvalues: Workspace (copy), stateLabel (copy), supportLabel (copy)
    if not p36:reportingEnabled() then
        return;
    end;

    local _runtime = p36._runtime;
    local table_concat = table.concat;
    local v38 = {};
    local string_format_ret = string.format("issue=RuntimeWarning message=%s status=%s statusReason=%s clientServerTime=%.6f accumulatorMs=%.3f", p37, _runtime._status, tostring(_runtime._reason), Workspace:GetServerTimeNow(), _runtime._accumulatorSeconds * 1000);
    local _mapping = _runtime._mapping;
    v38[1], v38[2], v38[3], v38[4] = string_format_ret, _mapping == nil and "mapping=nil" or string.format("mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s", _mapping.Generation, _mapping.ActorId, _mapping.SimulationHz, _mapping.TopologyEpoch, _mapping.TopologyFingerprint, (tostring(_mapping.PlayerCollisionsEnabled))), stateLabel("predictedTail", _runtime._state), supportLabel("predictedTailSupport", _runtime._support);
    local v39 = table_concat(v38, "\n");
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot;
    local v40 = {};
    local v41;

    if _lastAcceptedOwnerSnapshot == nil then
        v41 = nil;
    else
        v41 = _lastAcceptedOwnerSnapshot.Sequence;
    end;

    v40.Sequence = v41;
    local v42;

    if _lastAcceptedOwnerSnapshot == nil then
        v42 = nil;
    else
        v42 = _lastAcceptedOwnerSnapshot.LastProcessedCommand;
    end;

    v40.CommandNumber = v42;
    p36:reportIssue("RuntimeWarning", v39, v40);
end;

function u1.reportPredictionHitch(p43, p44) -- Line: 398
    -- upvalues: stateLabel (copy), supportLabel (copy)
    if not p43:reportingEnabled() then
        return;
    end;

    local _runtime = p43._runtime;
    local table_concat = table.concat;
    local v45 = {};
    local string_format_ret = string.format("issue=PredictionHitch likelyCause=ClientFrameStallOrPredictionDebt frameMs=%.3f discardedMs=%.3f backlogBeforeMs=%.3f backlogAfterMs=%.3f drained=%d guaranteed=%d hardCap=%d predictionWorkMs=%.3f ownerAgeMs=%.3f status=%s statusReason=%s accumulatorMs=%.3f", p44.FrameSeconds * 1000, p44.DiscardedSeconds * 1000, p44.BacklogBeforeSeconds * 1000, p44.BacklogAfterSeconds * 1000, p44.StepsDrained, p44.GuaranteedStepBudget, p44.StepBudget, p44.PredictionWorkSeconds * 1000, p44.OwnerSnapshotAgeSeconds * 1000, p44.Status, tostring(_runtime._reason), _runtime._accumulatorSeconds * 1000);
    local _mapping = _runtime._mapping;
    v45[1], v45[2], v45[3], v45[4] = string_format_ret, _mapping == nil and "mapping=nil" or string.format("mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s", _mapping.Generation, _mapping.ActorId, _mapping.SimulationHz, _mapping.TopologyEpoch, _mapping.TopologyFingerprint, (tostring(_mapping.PlayerCollisionsEnabled))), stateLabel("predictedTail", _runtime._state), supportLabel("predictedTailSupport", _runtime._support);
    local v46 = table_concat(v45, "\n");
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot;
    local v47 = {};
    local v48;

    if _lastAcceptedOwnerSnapshot == nil then
        v48 = nil;
    else
        v48 = _lastAcceptedOwnerSnapshot.Sequence;
    end;

    v47.Sequence = v48;
    local v49;

    if _lastAcceptedOwnerSnapshot == nil then
        v49 = nil;
    else
        v49 = _lastAcceptedOwnerSnapshot.LastProcessedCommand;
    end;

    v47.CommandNumber = v49;
    p43:reportIssue("PredictionHitch", v46, v47);
end;

function u1.recordStatusChange(p50, p51) -- Line: 430
    local os_clock_ret = os.clock();
    local _window = p50._window;
    local StatusDwellSeconds = _window.StatusDwellSeconds;
    StatusDwellSeconds[p51] = (StatusDwellSeconds[p51] or 0) + (os_clock_ret - _window.StatusEnteredAt);
    _window.StatusEnteredAt = os_clock_ret;
end;

function u1.recordOwnerSnapshotReceived(p52) -- Line: 438
    p52._ownerReceived = p52._ownerReceived + 1;
end;

function u1.recordOwnerFeedback(p53, p54) -- Line: 443
    -- upvalues: Enums (copy)
    local _window = p53._window;
    local BufferDepth = p54.BufferDepth;
    _window.DepthSum = _window.DepthSum + BufferDepth;
    _window.DepthSamples = _window.DepthSamples + 1;

    if _window.WorstDepth == nil or BufferDepth < _window.WorstDepth then
        _window.WorstDepth = BufferDepth;
    end;

    if BufferDepth < 0 then
        _window.StallSamples = _window.StallSamples + 1;
    end;

    if bit32.band(p54.Flags, Enums.OwnerSnapshotFlags.Stalled) == 0 then
        _window.StalledRun = 0;

        return;
    end;

    _window.StalledFlagSamples = _window.StalledFlagSamples + 1;
    _window.StalledRun = _window.StalledRun + 1;
    _window.LongestStalledRun = math.max(_window.LongestStalledRun, _window.StalledRun);
end;

function u1.recordRemoteSnapshot(p55: table, p56: number) -- Line: 464
    -- upvalues: Serial (copy)
    local _window = p55._window;
    local _remoteLastSequence = p55._remoteLastSequence;

    if _remoteLastSequence ~= nil then
        if Serial.isNewerUInt32(p56, _remoteLastSequence) then
            _window.RemoteSequenceGaps = _window.RemoteSequenceGaps + (Serial.deltaUInt32(p56, _remoteLastSequence) - 1);
            p55._remoteLastSequence = p56;
            _window.RemoteFramesSeen = _window.RemoteFramesSeen + 1;
        end;

        return;
    end;

    p55._remoteLastSequence = p56;
    _window.RemoteFramesSeen = _window.RemoteFramesSeen + 1;
end;

function u1.recordRemoteRejected(p57: table, p58: string) -- Line: 478
    if p58 == "RemoteBaselineRequired" then
        local _window = p57._window;
        _window.RemoteBaselineRejects = _window.RemoteBaselineRejects + 1;

        return;
    end;

    local _window = p57._window;
    _window.RemoteOtherRejects = _window.RemoteOtherRejects + 1;
end;

function u1.recordRemotePresentation(p59: table, p60: number, p61: number, p62: number, p63: boolean) -- Line: 487
    local _window = p59._window;
    _window.RemoteActorSamples = _window.RemoteActorSamples + p60;
    _window.RemoteStaleSamples = _window.RemoteStaleSamples + p61;
    _window.RemoteMissingSamples = _window.RemoteMissingSamples + p62;

    if not p63 then
        _window.RemoteBlindRunStartedAt = nil;

        return;
    end;

    _window.RemoteBlindFrames = _window.RemoteBlindFrames + 1;
    local RemoteBlindRunStartedAt = _window.RemoteBlindRunStartedAt;

    if RemoteBlindRunStartedAt == nil then
        RemoteBlindRunStartedAt = os.clock();
        _window.RemoteBlindRunStartedAt = RemoteBlindRunStartedAt;
    end;

    local v64 = os.clock() - RemoteBlindRunStartedAt;

    if _window.RemoteLongestBlindSeconds < v64 then
        _window.RemoteLongestBlindSeconds = v64;
    end;
end;

function u1.recordPredictionFrame(p65: table, p66: number, p67: number, p68: boolean) -- Line: 513
    local _window = p65._window;
    _window.Frames = _window.Frames + 1;
    _window.StepsDrained = _window.StepsDrained + p66;
    _window.DiscardedSeconds = _window.DiscardedSeconds + p67;

    if _window.MaxStepsInFrame < p66 then
        _window.MaxStepsInFrame = p66;
    end;

    if p68 then
        _window.CeilingBreaks = _window.CeilingBreaks + 1;
    end;
end;

function u1.recordResyncRequest(p69) -- Line: 526
    local _window = p69._window;
    _window.ResyncRequests = _window.ResyncRequests + 1;
end;

function u1.recordMappingRequest(p70) -- Line: 530
    local _window = p70._window;
    _window.MappingRequests = _window.MappingRequests + 1;
end;

function u1._recordReplayWindow(p71, p72) -- Line: 534
    local _window = p71._window;
    local ReplayBarrier = p72.Metrics.ReplayBarrier;
    _window.BarrierCounts[ReplayBarrier] = (_window.BarrierCounts[ReplayBarrier] or 0) + 1;

    if p72.ReplayCount > 0 then
        _window.ReplayEvents = _window.ReplayEvents + 1;
        _window.ReplayCommands = _window.ReplayCommands + p72.ReplayCount;
    end;

    if p72.Metrics.Position > _window.MaxCorrection then
        _window.MaxCorrection = p72.Metrics.Position;
    end;

    if p72.Metrics.Position > 0.01 then
        _window.CorrectionCount = _window.CorrectionCount + 1;
    end;
end;

function u1._reportOwnerCorrection(p73: table, p74: any, p75: any, p76: any, p77: number, p78: number, p79: number, p80: number?, p81: number) -- Line: 550
    -- upvalues: Players (copy), CorrectionDiagnostics (copy), Workspace (copy), State (copy), stateLabel (copy), vectorLabel (copy)
    local _runtime = p73._runtime;
    local Metrics = p75.Metrics;
    local _predictionRing = _runtime._predictionRing;
    local v82;

    if _runtime._remoteClock == nil then
        v82 = nil;
    else
        v82 = _runtime._remoteClock:diagnostics();
    end;

    local v83, v84, v85 = _runtime._uplink:peekBudget(_runtime._config, p77);
    local v86 = _runtime._uplink:counters();
    local v87 = _runtime._uplink:lastRecoveryAcknowledgedCommand();
    local v88;

    if p76 == nil then
        v88 = nil;
    else
        v88 = p76.Command;
    end;

    local v89 = -1;
    local success, result = pcall(function() -- Line: 569
        -- upvalues: Players (ref)
        return Players.LocalPlayer:GetNetworkPing();
    end);

    if success then
        if typeof(result) ~= "number" then
            result = v89;
        end;
    else
        result = v89;
    end;

    local v90 = nil;
    local ResolveMovementDiagnosticContext = _runtime._options.ResolveMovementDiagnosticContext;
    local v91;

    if ResolveMovementDiagnosticContext == nil then
        v91 = v90;
    else
        local v92;
        v92, v91 = pcall(ResolveMovementDiagnosticContext, p74.ServerTime);

        if v92 then
            if typeof(v91) ~= "table" then
                v91 = v90;
            end;
        else
            v91 = v90;
        end;
    end;

    local v93;

    if p76 == nil then
        v93 = nil;
    else
        v93 = p76.PostState;
    end;

    local v94 = CorrectionDiagnostics.classify(Metrics, v93, p74.State, v91);
    local v95 = {};
    local string_format_ret = string.format("issue=OwnerCorrection suspectedCause=%s status=%s statusReason=%s clientServerTime=%.6f pingMs=%.2f", v94, _runtime._status, tostring(_runtime._reason), Workspace:GetServerTimeNow(), result * 1000);
    local _mapping = _runtime._mapping;
    local v96 = _mapping == nil and "mapping=nil" or string.format("mapping generation=%u actor=%u simulationHz=%d topologyEpoch=%u topologyFingerprint=%u playerCollisions=%s", _mapping.Generation, _mapping.ActorId, _mapping.SimulationHz, _mapping.TopologyEpoch, _mapping.TopologyFingerprint, (tostring(_mapping.PlayerCollisionsEnabled)));
    local v97 = CorrectionDiagnostics.formatMovementLockContext(v91, p74.ServerTime);
    local string_format_ret2 = string.format("anchor sequence=%u ackCommand=%u predictedAckTick=%s authorityTick=%u tailTick=%u newestCommand=%s commandLead=%d ring=%d ownerReceived=%d ownerApplied=%d topologyRevision=%u moverRevision=%u flags=0x%02X", p74.Sequence, p74.LastProcessedCommand, p76 == nil and "nil" or tostring(p76.ServerTick), p74.ServerTick, p75.TailServerTick, p80 == nil and "nil" or tostring(p80), p81, _predictionRing == nil and 0 or _predictionRing:count(), p73._ownerReceived, p73._ownerApplied, p74.Topology.DestructibleRevision, p74.Topology.MoverRevision, p74.Flags);
    local string_format_ret3 = string.format("commandTransport packets=%d recoveryPackets=%d budgetDeferrals=%d tokens=%.3f/%.3f rate=%.3f recoveryAck=%s", v86.PacketsSent, v86.RecoveryPacketsSent, v86.BudgetDeferrals, v83, v85, v84, v87 == nil and "nil" or tostring(v87));
    local string_format_ret4 = string.format("reconcile count=%d mode=%s barrier=%s replay=%d retiredAckedPredictions=%d ackAdvance=%d tickAdvance=%d heldTicks=%d synthInput=%s playerContact=%s comparedAtAck=%s tailCompared=%s tailTickDelta=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f", p73._reconciliationCount, Metrics.ReconciliationMode, Metrics.ReplayBarrier, Metrics.ReplayCount, Metrics.DroppedCommandCount, Metrics.AcknowledgedCommandDelta, Metrics.ServerTickDelta, Metrics.ServerHeldTickCount, tostring(Metrics.SynthesizedInput), tostring(Metrics.PlayerContactCorrection), tostring(Metrics.ComparedAtAck), tostring(Metrics.TailCompared), Metrics.TailServerTickDelta, Metrics.ReconciliationWorkSeconds * 1000, Metrics.ReconciliationElapsedSeconds * 1000, Metrics.ReconciliationSliceCount, Metrics.ReconciliationMaximumSliceSeconds * 1000);
    local string_format_ret5 = string.format("ackError fields=%s mask=0x%X count=%d position=%.8f horizontal=%.8f vertical=%+.8f velocity=%.8f verticalVelocity=%+.8f yawDeg=%.6f verticalLookDeg=%.6f duck=%.8f stamina=%.8f supportAnchor=%.8f supportVelocity=%.8f supportKindMismatch=%d supportSourceMismatch=%d supportCanonicalMismatch=%s topologyRevisionDelta=%d", State.mismatchLabel(Metrics.CanonicalStateMismatchMask), Metrics.CanonicalStateMismatchMask, Metrics.CanonicalStateMismatchCount, Metrics.Position, Metrics.HorizontalPosition, p78, Metrics.Velocity, p79, math.deg(Metrics.LookYaw), math.deg(Metrics.VerticalLook), Metrics.DuckAmount, Metrics.Stamina, Metrics.SupportAnchor, Metrics.SupportVelocity, Metrics.SupportKindMismatch, Metrics.SupportSourceMismatch, tostring(Metrics.CanonicalSupportMismatch), Metrics.TopologyRevisionDelta);
    local string_format_ret6 = string.format("tailError position=%.8f horizontal=%.8f vertical=%+.8f velocity=%.8f verticalVelocity=%+.8f supportAnchor=%.8f supportVelocity=%.8f supportKindMismatch=%d supportSourceMismatch=%d groundMismatch=%s stanceMismatch=%s", Metrics.TailPosition, Metrics.TailHorizontalPosition, Metrics.TailVerticalPosition, Metrics.TailVelocity, Metrics.TailVerticalVelocity, Metrics.TailSupportAnchor, Metrics.TailSupportVelocity, Metrics.TailSupportKindMismatch, Metrics.TailSupportSourceMismatch, tostring(Metrics.TailGroundMismatch), (tostring(Metrics.TailStanceMismatch)));
    local v98 = v88 == nil and "ackCommandInput=nil" or string.format("ackCommandInput number=%u move=(%+.6f,%+.6f) yaw=%+.8f verticalLook=%+.8f buttons=0x%02X weaponRequest=%s weapon=%s predictedBaseSpeed=%s weaponProfile=%s/%s", v88.CommandNumber, v88.Move.X, v88.Move.Y, v88.LookYaw, v88.VerticalLook, v88.Buttons, tostring(v88.WeaponSelectRequestId), tostring(v88.WeaponSelectIdentifier), tostring(v88.PredictedBaseMoveSpeed), tostring(v88.PredictedWeaponMoveSpeed), (tostring(v88.PredictedWeaponScopedMoveSpeed)));
    local v99;

    if p76 == nil then
        v99 = nil;
    else
        v99 = p76.PostState;
    end;

    local v100 = stateLabel("predictedAtAck", v99);
    local v101;

    if p76 == nil then
        v101 = nil;
    else
        v101 = p76.PostSupport;
    end;

    local v102;

    if v101 == nil then
        v102 = "predictedSupportAtAck=nil";
    else
        local Anchor = v101.Anchor;
        v102 = string.format("%s kind=%d source=%u anchor=%s velocity=%s", "predictedSupportAtAck", v101.Kind, v101.SourceId, string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z), vectorLabel(v101.Velocity));
    end;

    local v103 = stateLabel("authoritativeAtAck", p74.State);
    local Support = p74.Support;
    local v104;

    if Support == nil then
        v104 = "authoritativeSupportAtAck=nil";
    else
        local Anchor = Support.Anchor;
        v104 = string.format("%s kind=%d source=%u anchor=%s velocity=%s", "authoritativeSupportAtAck", Support.Kind, Support.SourceId, string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z), vectorLabel(Support.Velocity));
    end;

    local v105 = stateLabel("reconciledTail", p75.State);
    local Support2 = p75.Support;
    local v106;

    if Support2 == nil then
        v106 = "reconciledTailSupport=nil";
    else
        local Anchor = Support2.Anchor;
        v106 = string.format("%s kind=%d source=%u anchor=%s velocity=%s", "reconciledTailSupport", Support2.Kind, Support2.SourceId, string.format("(%+.8f,%+.8f,%+.8f)", Anchor.X, Anchor.Y, Anchor.Z), vectorLabel(Support2.Velocity));
    end;

    v95[1], v95[2], v95[3], v95[4], v95[5], v95[6], v95[7], v95[8], v95[9], v95[10], v95[11], v95[12], v95[13], v95[14], v95[15], v95[16] = string_format_ret, v96, v97, string_format_ret2, string_format_ret3, string_format_ret4, string_format_ret5, string_format_ret6, v98, v100, v102, v103, v104, v105, v106, v82 == nil and "remoteClock=nil" or string.format("remoteClock mode=%s driftTicks=%+.6f hardRebases=%d latestObservedTick=%s", v82.Mode, v82.DriftTicks, v82.HardRebases, (tostring(v82.LatestObservedTick)));
    p73:reportIssue("OwnerCorrection", table.concat(v95, "\n"), {
        Generation = p74.Generation,
        Sequence = p74.Sequence,
        CommandNumber = p74.LastProcessedCommand,
        ServerTick = p74.ServerTick
    });
end;

function u1._printOwnerTrace(p107: table, p108: any, p109: any, p110: any, p111: number, p112: boolean, p113: number, p114: number, p115: number?, p116: number) -- Line: 716
    -- upvalues: materialAckCorrection (copy), output (copy), State (copy)
    local Metrics = p109.Metrics;

    if Metrics.ReconciliationMode ~= "Reuse" and not Metrics.PlayerContactCorrection then
        if materialAckCorrection(Metrics) then
            output(string.format("[MovementV2.Client] CORRECTION mode=%s barrier=%s seq=%u ack=%u tick=%u ackFields=%s ackPos=%.8f ackVel=%.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f tailTickDelta=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f held=%d synth=%s groundTail=%s stanceTail=%s supportTail=%d/%d", Metrics.ReconciliationMode, Metrics.ReplayBarrier, p108.Sequence, p108.LastProcessedCommand, p108.ServerTick, State.mismatchLabel(Metrics.CanonicalStateMismatchMask), Metrics.Position, Metrics.Velocity, Metrics.TailPosition, Metrics.TailVerticalPosition, Metrics.TailVelocity, Metrics.TailVerticalVelocity, Metrics.TailServerTickDelta, Metrics.ReplayCount, Metrics.ReconciliationWorkSeconds * 1000, Metrics.ReconciliationElapsedSeconds * 1000, Metrics.ReconciliationSliceCount, Metrics.ReconciliationMaximumSliceSeconds * 1000, Metrics.ServerHeldTickCount, tostring(Metrics.SynthesizedInput), tostring(Metrics.TailGroundMismatch), tostring(Metrics.TailStanceMismatch), Metrics.TailSupportKindMismatch, Metrics.TailSupportSourceMismatch));
        elseif Metrics.TailCompared and ((Metrics.TailPosition >= 0.01 or (Metrics.TailVelocity >= 0.1 or (Metrics.TailSupportAnchor >= 0.01 or (Metrics.TailSupportVelocity >= 0.1 or (Metrics.TailSupportKindMismatch > 0 or Metrics.TailSupportSourceMismatch > 0))))) and true or (Metrics.TailGroundMismatch or Metrics.TailStanceMismatch)) then
            output(string.format("[MovementV2.Client] CORRECTION mode=%s barrier=%s seq=%u ack=%u tick=%u ackFields=%s ackPos=%.8f ackVel=%.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f tailTickDelta=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f held=%d synth=%s groundTail=%s stanceTail=%s supportTail=%d/%d", Metrics.ReconciliationMode, Metrics.ReplayBarrier, p108.Sequence, p108.LastProcessedCommand, p108.ServerTick, State.mismatchLabel(Metrics.CanonicalStateMismatchMask), Metrics.Position, Metrics.Velocity, Metrics.TailPosition, Metrics.TailVerticalPosition, Metrics.TailVelocity, Metrics.TailVerticalVelocity, Metrics.TailServerTickDelta, Metrics.ReplayCount, Metrics.ReconciliationWorkSeconds * 1000, Metrics.ReconciliationElapsedSeconds * 1000, Metrics.ReconciliationSliceCount, Metrics.ReconciliationMaximumSliceSeconds * 1000, Metrics.ServerHeldTickCount, tostring(Metrics.SynthesizedInput), tostring(Metrics.TailGroundMismatch), tostring(Metrics.TailStanceMismatch), Metrics.TailSupportKindMismatch, Metrics.TailSupportSourceMismatch));
        end;
    end;

    local v117 = p111 - p107._lastSummaryAt >= 1;

    if p112 then
        p112 = p111 - p107._lastAnomalyAt >= 0.25;
    end;

    if not (v117 or p112) then
        return;
    end;

    if v117 then
        p107._lastSummaryAt = p111;
    end;

    if p112 then
        p107._lastAnomalyAt = p111;
    end;

    local _predictionRing = p107._runtime._predictionRing;
    local v118 = p107._replayTotal / math.max(p107._ownerApplied, 1);
    local string_format = string.format;
    local ReconciliationMode = Metrics.ReconciliationMode;
    local ReplayBarrier = Metrics.ReplayBarrier;
    local Sequence = p108.Sequence;
    local LastProcessedCommand = p108.LastProcessedCommand;
    local v119 = p110 == nil and "nil" or tostring(p110.ServerTick);
    local ServerTick = p108.ServerTick;
    local AcknowledgedCommandDelta = Metrics.AcknowledgedCommandDelta;
    local ServerTickDelta = Metrics.ServerTickDelta;
    local ServerHeldTickCount = Metrics.ServerHeldTickCount;
    local v120 = tostring(Metrics.SynthesizedInput);
    local v121 = p115 == nil and "nil" or tostring(p115);
    local _reconciliationCount = p107._reconciliationCount;
    local ReplayCount = p109.ReplayCount;
    local v122 = Metrics.ReconciliationWorkSeconds * 1000;
    local v123 = Metrics.ReconciliationElapsedSeconds * 1000;
    local ReconciliationSliceCount = Metrics.ReconciliationSliceCount;
    local v124 = Metrics.ReconciliationMaximumSliceSeconds * 1000;
    local _replayMax = p107._replayMax;
    local v125 = _predictionRing == nil and 0 or _predictionRing:count();
    local _ownerReceived = p107._ownerReceived;
    local _ownerApplied = p107._ownerApplied;
    local TailServerTick = p109.TailServerTick;
    local TailServerTickDelta = Metrics.TailServerTickDelta;
    local v126 = State.mismatchLabel(Metrics.CanonicalStateMismatchMask);
    local CanonicalStateMismatchMask = Metrics.CanonicalStateMismatchMask;
    local CanonicalStateMismatchCount = Metrics.CanonicalStateMismatchCount;
    local Position = Metrics.Position;
    local Velocity = Metrics.Velocity;
    local TailPosition = Metrics.TailPosition;
    local TailVerticalPosition = Metrics.TailVerticalPosition;
    local TailVelocity = Metrics.TailVelocity;
    local TailVerticalVelocity = Metrics.TailVerticalVelocity;
    local v127 = p110 == nil and "nil" or tostring(p110.PostState.OnGround);
    local v128 = tostring(p108.State.OnGround);
    local v129;

    if p110 == nil then
        v129 = nil;
    else
        v129 = p110.PostSupport;
    end;

    local v130 = v129 == nil and "nil" or `{v129.Kind}:{v129.SourceId}`;
    local Support = p108.Support;
    output(string_format("[MovementV2.Client] owner mode=%s barrier=%s seq=%u ack=%u ackTick=%s/%u ackAdvance=%d tickAdvance=%d held=%d synth=%s newest=%s lead=%d reconcileCount=%d replay=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f avgReplay=%.1f maxReplay=%d ring=%d recv/applied=%d/%d tailTick=%u tailTickDelta=%d fields=%s mismatch=0x%X/%d posErr=%.8f yErr=%+.8f velErr=%.8f vyErr=%+.8f tailPos=%.8f tailY=%+.8f tailVel=%.8f tailVy=%+.8f ground=%s/%s support=%s/%s stance=%s/%s jumpHull=%s/%s", ReconciliationMode, ReplayBarrier, Sequence, LastProcessedCommand, v119, ServerTick, AcknowledgedCommandDelta, ServerTickDelta, ServerHeldTickCount, v120, v121, p116, _reconciliationCount, ReplayCount, v122, v123, ReconciliationSliceCount, v124, v118, _replayMax, v125, _ownerReceived, _ownerApplied, TailServerTick, TailServerTickDelta, v126, CanonicalStateMismatchMask, CanonicalStateMismatchCount, Position, p113, Velocity, p114, TailPosition, TailVerticalPosition, TailVelocity, TailVerticalVelocity, v127, v128, v130, Support == nil and "nil" or `{Support.Kind}:{Support.SourceId}`, p110 == nil and "nil" or p110.PostState.Stance, p108.State.Stance, p110 == nil and "nil" or tostring(p110.PostState.JumpHullActive), (tostring(p108.State.JumpHullActive))));
end;

function u1.recordOwnerApplied(p131, p132, p133, p134) -- Line: 829
    -- upvalues: DiagnosticProtocol (copy), Players (copy), Serial (copy), PredictionErrorSmoother (copy), materialAckCorrection (copy), Config (copy)
    local _runtime = p131._runtime;
    local Metrics = p133.Metrics;
    p131:_recordReplayWindow(p133);
    p131._ownerApplied = p131._ownerApplied + 1;
    p131._replayTotal = p131._replayTotal + p133.ReplayCount;
    p131._replayMax = math.max(p131._replayMax, p133.ReplayCount);
    local v135 = Metrics.ReconciliationMode == "Replay" and true or Metrics.ReconciliationMode == "Reanchor";

    if v135 then
        p131._reconciliationCount = p131._reconciliationCount + 1;
    end;

    local v136 = p131:reportingEnabled();
    local v137 = DiagnosticProtocol.OwnerTraceEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer);

    if not (v136 or v137) then
        return;
    end;

    local os_clock_ret = os.clock();
    local v138 = p134 == nil and 0 or p134.PostState.Position.Y - p132.State.Position.Y;
    local v139 = p134 == nil and 0 or p134.PostState.Velocity.Y - p132.State.Velocity.Y;
    local _predictionRing = _runtime._predictionRing;
    local v140;

    if _predictionRing == nil then
        v140 = nil;
    else
        v140 = _predictionRing:newestCommandNumber();
    end;

    local v141;

    if v140 == nil then
        v141 = 0;
    else
        local v142 = Serial.deltaUInt32(v140, p132.LastProcessedCommand);
        v141 = math.max(v142, 0);
    end;

    local v143 = Metrics.ComparedAtAck and (Metrics.CanonicalStateMismatchCount > 0 and true or Metrics.CanonicalSupportMismatch);

    if Metrics.ReconciliationMode == "Initial" then
        v143 = false;
    elseif Metrics.ReconciliationMode == "Reanchor" then
        v143 = true;
    else
        local SynthesizedInput = Metrics.SynthesizedInput;

        if SynthesizedInput then
            v143 = SynthesizedInput;
        elseif not v143 then
            v143 = Metrics.TailCompared and PredictionErrorSmoother.isHardSnapCorrection(Metrics);

            if not v143 then
                if Metrics.ReconciliationMode == "Reuse" then
                    v143 = false;
                else
                    v143 = materialAckCorrection(Metrics) or Metrics.TailCompared and ((Metrics.TailPosition >= 0.01 or (Metrics.TailVelocity >= 0.1 or (Metrics.TailSupportAnchor >= 0.01 or (Metrics.TailSupportVelocity >= 0.1 or (Metrics.TailSupportKindMismatch > 0 or Metrics.TailSupportSourceMismatch > 0))))) and true or (Metrics.TailGroundMismatch or Metrics.TailStanceMismatch));
                end;
            end;
        end;
    end;

    if v136 and (v135 and not v143) then
        p131:reportIssue("Reconciliation", string.format("issue=Reconciliation count=%d mode=%s barrier=%s generation=%u sequence=%u ackCommand=%u authorityTick=%u tailTick=%u replay=%d retiredAckedPredictions=%d heldTicks=%d workMs=%.3f elapsedMs=%.3f slices=%d maxSliceMs=%.3f ackPos=%.8f ackVel=%.8f tailPos=%.8f tailVel=%.8f", p131._reconciliationCount, Metrics.ReconciliationMode, Metrics.ReplayBarrier, p132.Generation, p132.Sequence, p132.LastProcessedCommand, p132.ServerTick, p133.TailServerTick, Metrics.ReplayCount, Metrics.DroppedCommandCount, Metrics.ServerHeldTickCount, Metrics.ReconciliationWorkSeconds * 1000, Metrics.ReconciliationElapsedSeconds * 1000, Metrics.ReconciliationSliceCount, Metrics.ReconciliationMaximumSliceSeconds * 1000, Metrics.Position, Metrics.Velocity, Metrics.TailPosition, Metrics.TailVelocity), {
            Generation = p132.Generation,
            Sequence = p132.Sequence,
            CommandNumber = p132.LastProcessedCommand,
            ServerTick = p132.ServerTick
        });
    end;

    if v136 and v143 then
        p131:_reportOwnerCorrection(p132, p133, p134, os_clock_ret, v138, v139, v140, v141);
    end;

    if not v137 then
        return;
    end;

    local math_ceil_ret = math.ceil(0.0625 * (_runtime._config or Config.Default).SimulationHz);
    local math_max_ret = math.max(1, math_ceil_ret);
    local v144;

    if p134 == nil then
        v144 = false;
    else
        v144 = p134.PostState.OnGround ~= p132.State.OnGround;
    end;

    local v145;

    if p134 == nil then
        v145 = false;
    else
        v145 = p134.PostSupport.Kind ~= p132.Support.Kind and true or p134.PostSupport.SourceId ~= p132.Support.SourceId;
    end;

    p131:_printOwnerTrace(p132, p133, p134, os_clock_ret, (math_max_ret <= p133.ReplayCount or (Metrics.ReconciliationMode == "Reanchor" or (Metrics.ServerHeldTickCount > 0 or (math.abs(v138) >= 0.01 or math.abs(v139) >= 0.1)))) and true or (v144 or v145), v138, v139, v140, v141);
end;

function u1._traceAirStrafe(p146: table, p147: any, p148: number, p149: number, p150: any, p151: any) -- Line: 948
    -- upvalues: RuntimeSettings (copy), output (copy), Workspace (copy), ProvenMath (copy)
    local _airStrafePreviousYaw = p146._airStrafePreviousYaw;
    p146._airStrafePreviousYaw = p147.LookYaw;

    if p146._airStrafeLineCount >= 320 then
        return;
    end;

    if p150.OnGround and p151.OnGround then
        return;
    end;

    local _runtime = p146._runtime;
    local v152 = assert(_runtime._config);
    local MovementConfig = RuntimeSettings.getMovementConfig(v152.SimulationHz);
    local v153;

    if MovementConfig.BunnyHopAirAccelerate > 0 then
        v153 = MovementConfig.BunnyHopAirSpeedCap > MovementConfig.PositionSnapEpsilon;
    else
        v153 = false;
    end;

    if not p146._airStrafeHeaderPrinted then
        p146._airStrafeHeaderPrinted = true;
        output(string.format("[MovementV2.AirStrafe] BEGIN version=1 generation=%u gamemode=%s profile=%s simulationHz=%u airAccelerate=%.6f airSpeedCap=%.6f bunnyHopAirAccelerate=%.6f bunnyHopAirSpeedCap=%.6f", assert(_runtime._mapping).Generation, tostring(Workspace:GetAttribute("ServerGamemode")), v153 and "relaxed" or "source", v152.SimulationHz, MovementConfig.AirAccelerate, MovementConfig.AirSpeedCap, MovementConfig.BunnyHopAirAccelerate, MovementConfig.BunnyHopAirSpeedCap));
    end;

    local v154 = ProvenMath.moveVectorToWorld(p147.Move, p147.LookYaw);
    local v155 = v154.Magnitude <= 1e-6 and Vector3.new(0, 0, 0) or v154.Unit;
    local Vector3_new_ret = Vector3.new(p150.Velocity.X, 0, p150.Velocity.Z);
    local Vector3_new_ret2 = Vector3.new(p151.Velocity.X, 0, p151.Velocity.Z);
    local v156 = Vector3_new_ret:Dot(v155);
    local v157;

    if v153 then
        v157 = MovementConfig.BunnyHopAirSpeedCap;
    else
        v157 = MovementConfig.AirSpeedCap;
    end;

    local v158 = v157 - v156;
    local v159;

    if v153 then
        v159 = MovementConfig.BunnyHopAirAccelerate * v157 * v152.StepSeconds;
    else
        v159 = MovementConfig.AirAccelerate * p150.BaseMoveSpeed * p150.VelocityModifier * v152.StepSeconds * p150.GroundSurfaceFriction;
    end;

    local math_max_ret = math.max(v158, 0);
    local math_min_ret = math.min(v159, math_max_ret);
    local v160;

    if _airStrafePreviousYaw == nil then
        v160 = 0;
    else
        local math_sin_ret = math.sin(p147.LookYaw - _airStrafePreviousYaw);
        local math_cos_ret = math.cos(p147.LookYaw - _airStrafePreviousYaw);
        v160 = math.atan2(math_sin_ret, math_cos_ret);
    end;

    local v161 = p150.OnGround and not p151.OnGround and "takeoff" or ((p150.OnGround or not p151.OnGround) and "air" or "landing");
    p146._airStrafeLineCount = p146._airStrafeLineCount + 1;
    local string_format = string.format;
    local CommandNumber = p147.CommandNumber;
    local Buttons = p147.Buttons;
    local X = p147.Move.X;
    local Y = p147.Move.Y;
    local math_deg_ret = math.deg(p147.LookYaw);
    local math_deg_ret2 = math.deg(v160);
    local X2 = v155.X;
    local Z = v155.Z;
    local v162;

    if Vector3_new_ret.Magnitude <= 1e-6 or v155.Magnitude <= 1e-6 then
        v162 = 0;
    else
        local v163 = Vector3_new_ret.X * v155.Z - Vector3_new_ret.Z * v155.X;
        local v164 = Vector3_new_ret:Dot(v155);
        v162 = math.atan2(v163, v164);
    end;

    local math_deg_ret3 = math.deg(v162);
    local v165;

    if Vector3_new_ret.Magnitude <= 1e-6 or Vector3_new_ret2.Magnitude <= 1e-6 then
        v165 = 0;
    else
        local v166 = Vector3_new_ret.X * Vector3_new_ret2.Z - Vector3_new_ret.Z * Vector3_new_ret2.X;
        local v167 = Vector3_new_ret:Dot(Vector3_new_ret2);
        v165 = math.atan2(v166, v167);
    end;

    output(string_format("[MovementV2.AirStrafe] cmd=%u tick=%u phase=%s alpha=%.4f buttons=%u move=(%+.4f,%+.4f) yawDeg=%+.3f yawDeltaDeg=%+.3f wish=(%+.5f,%+.5f) wishVsVelocityDeg=%+.3f velocityTurnDeg=%+.3f speed=%.6f->%.6f speedDelta=%+.6f directionalSpeed=%+.6f room=%+.6f fullWishImpulse=%.6f expectedImpulse=%.6f appliedAlongWish=%+.6f baseSpeed=%.6f velocityModifier=%.6f stamina=%.6f surfaceFriction=%.6f wallNormal=%.6f", CommandNumber, p148, v161, p149, Buttons, X, Y, math_deg_ret, math_deg_ret2, X2, Z, math_deg_ret3, math.deg(v165), Vector3_new_ret.Magnitude, Vector3_new_ret2.Magnitude, Vector3_new_ret2.Magnitude - Vector3_new_ret.Magnitude, v156, v158, v159, math_min_ret, (Vector3_new_ret2 - Vector3_new_ret):Dot(v155), p150.BaseMoveSpeed, p150.VelocityModifier, p150.Stamina, p150.GroundSurfaceFriction, p151.WallNormal.Magnitude));

    if p146._airStrafeLineCount == 320 then
        output((`[MovementV2.AirStrafe] COMPLETE reason=lineLimit lines={320}`));
    end;
end;

function u1.recordPredictedStep(p168: table, p169: any, p170: number, p171: number, p172: any, p173: any, p174: any, p175: any) -- Line: 1048
    -- upvalues: DiagnosticProtocol (copy), Players (copy), output (copy)
    if not DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) then
        return;
    end;

    if DiagnosticProtocol.AirStrafeTraceEnabled then
        p168:_traceAirStrafe(p169, p170, p171, p172, p173);
    end;

    if DiagnosticProtocol.OwnerTraceEnabled and (p175.Jumped or (p175.Landed or p175.LeftGround)) then
        output(string.format("[MovementV2.Client] transition cmd=%u tick=%u jumped=%s landed=%s leftGround=%s y=%.5f vy=%.5f onGround=%s stance=%s jumpHull=%s support=%s", p169.CommandNumber, p170, tostring(p175.Jumped), tostring(p175.Landed), tostring(p175.LeftGround), p173.Position.Y, p173.Velocity.Y, tostring(p173.OnGround), p173.Stance, tostring(p173.JumpHullActive), p174 == nil and "nil" or `{p174.Kind}:{p174.SourceId}`));
    end;
end;

function u1.emitNetcodeSummary(p176) -- Line: 1084
    -- upvalues: table_freeze_ret (copy), Players (copy), Serial (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - p176._summaryAt < table_freeze_ret.NetcodeSummary then
        return;
    end;

    if not p176:reportingEnabled() then
        p176._summaryAt = os_clock_ret;
        p176:_resetWindow();

        return;
    end;

    local _runtime = p176._runtime;
    local _window = p176._window;
    local math_max_ret = math.max(os_clock_ret - p176._summaryAt, 1e-6);
    p176._summaryAt = os_clock_ret;
    local v177 = {};

    for i, v in _window.BarrierCounts do
        table.insert(v177, string.format("%s=%d", i, v));
    end;

    table.sort(v177);
    p176:recordStatusChange(_runtime._status);
    local v178 = {};

    for i, v in _window.StatusDwellSeconds do
        if v >= 0.001 then
            table.insert(v178, string.format("%s=%.0fms", i, v * 1000));
        end;
    end;

    table.sort(v178);
    local _commandClock = _runtime._commandClock;
    local v179;

    if _commandClock == nil then
        v179 = nil;
    else
        v179 = _commandClock:diagnostics();
    end;

    local _remoteClock = _runtime._remoteClock;
    local v180;

    if _remoteClock == nil then
        v180 = nil;
    else
        v180 = _remoteClock:diagnostics();
    end;

    local _config = _runtime._config;
    local _predictionRing = _runtime._predictionRing;
    local _commandStream = _runtime._commandStream;
    local _lastAcceptedOwnerSnapshot = _runtime._lastAcceptedOwnerSnapshot;
    local v181;

    if _commandStream == nil then
        v181 = nil;
    else
        v181 = _commandStream:lastSampledCommandNumber();
    end;

    local v182 = _runtime._uplink:counters();
    local math_max_ret2 = math.max(_window.DepthSamples, 1);
    local math_max_ret3 = math.max(_window.Frames, 1);
    p176:reportIssue("NetcodeSummary", table.concat({
        string.format("issue=NetcodeSummary windowSeconds=%.2f status=%s statusReason=%s ping=%.0fms", math_max_ret, _runtime._status, tostring(_runtime._reason), Players.LocalPlayer:GetNetworkPing() * 1000),
        string.format("reservoir meanDepth=%.2f worstDepth=%s negativeSamples=%d/%d stalledFlag=%d longestStalledRun=%d clockRate=%.4f clockWorst=%s clockTarget=%s clockError=%s", _window.DepthSum / math_max_ret2, tostring(_window.WorstDepth), _window.StallSamples, _window.DepthSamples, _window.StalledFlagSamples, _window.LongestStalledRun, v179 == nil and 1 or v179.Rate, v179 == nil and "nil" or tostring(v179.WorstDepth), v179 == nil and "nil" or tostring(v179.TargetDepth), v179 == nil and "nil" or tostring(v179.ErrorTicks)),
        string.format("pacing frames=%d commandsPerSecond=%.1f stepsPerFrame=%.2f maxStepsInFrame=%d discardedMs=%.2f ceilingBreaks=%d accumulatorMs=%.2f", _window.Frames, _window.StepsDrained / math_max_ret, _window.StepsDrained / math_max_ret3, _window.MaxStepsInFrame, _window.DiscardedSeconds * 1000, _window.CeilingBreaks, _runtime._accumulatorSeconds * 1000),
        string.format("reconcile ownerRecv=%d ownerApplied=%d replayEvents=%.2f/s replayCommands=%.2f/s corrections=%.2f/s maxCorrection=%.5f ring=%d/%d lead=%s", p176._ownerReceived, p176._ownerApplied, _window.ReplayEvents / math_max_ret, _window.ReplayCommands / math_max_ret, _window.CorrectionCount / math_max_ret, _window.MaxCorrection, _predictionRing == nil and 0 or _predictionRing:count(), _predictionRing == nil and 0 or _predictionRing:capacity(), (v181 == nil or _lastAcceptedOwnerSnapshot == nil) and "nil" or tostring(Serial.deltaUInt32(v181, _lastAcceptedOwnerSnapshot.LastProcessedCommand))),
        string.format("remote framesSeen=%d seqGaps=%d rxLoss=%.2f%% baselineRejects=%d otherRejects=%d actorSamples=%d stale=%.2f%% missing=%.2f%% blindFrames=%d longestBlindMs=%.1f clock=%s drift=%.2f rebases=%d delayMs=%.1f minMarginMs=%.1f rate=%.3f extrapFrames=%d holdFrames=%d", _window.RemoteFramesSeen, _window.RemoteSequenceGaps, 100 * (_window.RemoteSequenceGaps / math.max(1, _window.RemoteFramesSeen + _window.RemoteSequenceGaps)), _window.RemoteBaselineRejects, _window.RemoteOtherRejects, _window.RemoteActorSamples, 100 * (_window.RemoteStaleSamples / math.max(1, _window.RemoteActorSamples)), 100 * (_window.RemoteMissingSamples / math.max(1, _window.RemoteActorSamples)), _window.RemoteBlindFrames, _window.RemoteLongestBlindSeconds * 1000, v180 == nil and "nil" or v180.Mode, v180 == nil and 0 or v180.DriftTicks, v180 == nil and 0 or v180.HardRebases, v180 == nil and 0 or v180.DelayMs, v180 == nil and 0 or (v180.WindowMinMarginMs or 0), v180 == nil and 1 or v180.Rate, v180 == nil and 0 or v180.ExtrapolatingFrames, v180 == nil and 0 or v180.HoldingFrames),
        string.format("uplink commandPackets=%.1f/s recoveryPackets=%.1f/s budgetDeferrals=%d", (v182.PacketsSent - _window.CommandPacketsBase) / math_max_ret, (v182.RecoveryPacketsSent - _window.RecoveryPacketsBase) / math_max_ret, v182.BudgetDeferrals - _window.SendDeferralsBase),
        string.format("recovery resyncRequests=%d mappingRequests=%d dwell=%s", _window.ResyncRequests, _window.MappingRequests, #v178 == 0 and "none" or table.concat(v178, " ")),
        "barriers " .. (#v177 == 0 and "none" or table.concat(v177, " ")),
        string.format("policy simulationHz=%s bufferTarget=%s catchUpBank=%s maxFrameTicks=%s accumulatorTicks=%s", _config == nil and "nil" or tostring(_config.SimulationHz), _config == nil and "nil" or tostring(_config.CommandBufferTargetTicks), _config == nil and "nil" or tostring(_config.CommandCatchUpBankTicks), _config == nil and "nil" or tostring(_config.MaxPredictionFrameTicks), _config == nil and "nil" or tostring(_config.PredictionAccumulatorTicks))
    }, "\n"));
    p176:_resetWindow();
end;

function u1.connectOutput(p183, p184) -- Line: 1223
    -- upvalues: DiagnosticProtocol (copy), Players (copy), RunService (copy)
    if not DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) then
        return {};
    end;

    local _output = p183._output;

    return { p184.Diagnostics.OnClientEvent:Connect(function(p185) -- Line: 1229
            -- upvalues: DiagnosticProtocol (ref), _output (copy)
            local v186 = DiagnosticProtocol.decodeDelivery(p185);

            if v186 ~= nil then
                _output:queue(v186);
            end;
        end), RunService.Heartbeat:Connect(function() -- Line: 1235
            -- upvalues: _output (copy)
            _output:drain();
        end) };
end;

function u1.clearOutput(p187) -- Line: 1241
    p187._output:clear();
end;

return table.freeze(u1);