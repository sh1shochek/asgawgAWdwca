-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Catalog = require(script.Parent.Parent.Collision.Catalog);
local TopologyBuilder = require(script.Parent.Parent.Collision.TopologyBuilder);
local Config = require(script.Parent.Parent.Config);
local ControlCodec = require(script.Parent.Parent.ControlCodec);
local DamageTag = require(script.Parent.Parent.DamageTag);
local ActionLockTimeline = require(script.Parent.Parent.ActionLockTimeline);
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol);
local Enums = require(script.Parent.Parent.Enums);
local Mapping = require(script.Parent.Parent.Mapping);
local OwnerSnapshotCodec = require(script.Parent.Parent.OwnerSnapshotCodec);
local RemoteSnapshotCodec = require(script.Parent.Parent.RemoteSnapshotCodec);
local Serial = require(script.Parent.Parent.Serial);
local Simulation = require(script.Parent.Parent.Simulation);
local Config2 = require(script.Parent.Parent.Simulation.Config);
local DeterminismTrace = require(script.Parent.Parent.Simulation.DeterminismTrace);
local PlayerContacts = require(script.Parent.Parent.Simulation.PlayerContacts);
local RuntimeSettings = require(script.Parent.Parent.Simulation.RuntimeSettings);
require(script.Parent.Parent.Simulation.Types);
local Transport = require(script.Parent.Parent.Transport);
require(script.Parent.Parent.Types);
local WorldComposer = require(script.Parent.WorldComposer);
local CommandState = require(script.Parent.CommandState);
local CommandStream = require(script.Parent.CommandStream);
local CommandUplink = require(script.Parent.CommandUplink);
local DestructibleTimeline = require(script.Parent.DestructibleTimeline);
local DeterminismTraceCapture = require(script.Parent.DeterminismTraceCapture);
local PlayerContactAdapter = require(script.Parent.PlayerContactAdapter);
local PredictionErrorSmoother = require(script.Parent.PredictionErrorSmoother);
local RootFrame = require(script.Parent.Parent.RootFrame);
local PredictionPacing = require(script.Parent.PredictionPacing);
local CommandClock = require(script.Parent.CommandClock);
local OwnerCommandFeedback = require(script.Parent.OwnerCommandFeedback);
local OwnerReplay = require(script.Parent.OwnerReplay);
local OwnerRecovery = require(script.Parent.OwnerRecovery);
local DamageTagReplay = require(script.Parent.DamageTagReplay);
local ActionLockReplay = require(script.Parent.ActionLockReplay);
local PredictionRing = require(script.Parent.PredictionRing);
local Reconciler = require(script.Parent.Reconciler);
local RemoteBuffer = require(script.Parent.RemoteBuffer);
local RemoteClock = require(script.Parent.RemoteClock);
local RuntimeDiagnostics = require(script.Parent.RuntimeDiagnostics);
require(script.Parent.RuntimeTypes);
local u1 = {};
u1.__index = u1;

local function newReconciliationReplayBudget() -- Line: 101
    return {
        MinimumSteps = 1,
        MaximumSteps = 16,
        MaximumSeconds = 0.0005
    };
end;

local function beginReconciliationTiming() -- Line: 109
    return {
        WorkSeconds = 0,
        SliceCount = 0,
        MaximumSliceSeconds = 0,
        StartedAt = os.clock()
    };
end;

local function recordReconciliationSlice(p2: any, p3: number) -- Line: 118
    local v4 = os.clock() - p3;
    local math_max_ret = math.max(v4, 0);
    p2.WorkSeconds = p2.WorkSeconds + math_max_ret;
    p2.SliceCount = p2.SliceCount + 1;
    p2.MaximumSliceSeconds = math.max(p2.MaximumSliceSeconds, math_max_ret);
end;

local function applyReconciliationTiming(p5, p6) -- Line: 125
    p5.ReconciliationWorkSeconds = p6.WorkSeconds;
    local v7 = os.clock() - p6.StartedAt;
    p5.ReconciliationElapsedSeconds = math.max(v7, p6.WorkSeconds);
    p5.ReconciliationSliceCount = p6.SliceCount;
    p5.ReconciliationMaximumSliceSeconds = p6.MaximumSliceSeconds;
end;

local function cloneMapping(p8) -- Line: 132
    -- upvalues: Mapping (copy)
    return table.freeze(Mapping.clone(p8));
end;

local function sameMappingIdentity(p9, p10) -- Line: 136
    local v11;

    if p9.Generation == p10.Generation and (p9.ActorId == p10.ActorId and (p9.SimulationHz == p10.SimulationHz and p9.TopologyEpoch == p10.TopologyEpoch)) then
        v11 = p9.TopologyFingerprint == p10.TopologyFingerprint;
    else
        v11 = false;
    end;

    return v11;
end;

local function isPlayerCollisionPolicyRemap(p12, p13) -- Line: 144
    local v14;

    if p12.Generation == p13.Generation and (p12.ActorId == p13.ActorId and (p12.SimulationHz == p13.SimulationHz and p12.TopologyEpoch == p13.TopologyEpoch)) then
        v14 = p12.TopologyFingerprint == p13.TopologyFingerprint;
    else
        v14 = false;
    end;

    if v14 then
        v14 = p12.PlayerCollisionsEnabled ~= p13.PlayerCollisionsEnabled;
    end;

    return v14;
end;

local clone = Simulation.State.clone;
local cloneSupport = Simulation.State.cloneSupport;

local function finiteSpeed(p15) -- Line: 151
    local v16;

    if type(p15) == "number" and p15 == p15 then
        v16 = math.abs(p15) < (1 / 0);
    else
        v16 = false;
    end;

    return v16;
end;

local forCommand = CommandState.forCommand;
local serverTimeAtTick = CommandState.serverTimeAtTick;

local function defaultMapRoot(p17) -- Line: 158
    -- upvalues: Catalog (copy), Workspace (copy)
    return Catalog.FindReplica(p17.TopologyEpoch, p17.TopologyFingerprint) or Workspace:FindFirstChild("Map");
end;

local function stanceHalfSize(p18) -- Line: 163
    -- upvalues: Config2 (copy)
    local Default = Config2.Default;
    local v19;

    if p18 == "Ducking" then
        v19 = Default.PlayerSizeDucking;
    else
        v19 = Default.PlayerSizeStanding;
    end;

    return v19 * 0.5;
end;

local function withinPlayerContactMargin(p20, p21) -- Line: 168
    -- upvalues: Config2 (copy), PlayerContacts (copy)
    local Default = Config2.Default;
    local v22;

    if p20.Stance == "Ducking" then
        v22 = Default.PlayerSizeDucking;
    else
        v22 = Default.PlayerSizeStanding;
    end;

    local Default2 = Config2.Default;
    local v23;

    if p21.Stance == "Ducking" then
        v23 = Default2.PlayerSizeDucking;
    else
        v23 = Default2.PlayerSizeStanding;
    end;

    local v24 = v22 * 0.5 + v23 * 0.5;
    local v25 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin;
    local v26 = p20.Position - p21.Position;
    local v27;

    if math.abs(v26.X) <= v24.X + v25 and math.abs(v26.Y) <= v24.Y + v25 then
        v27 = math.abs(v26.Z) <= v24.Z + v25;
    else
        v27 = false;
    end;

    return v27;
end;

function u1.new(p28) -- Line: 177
    -- upvalues: RunService (copy), u1 (copy), CommandUplink (copy), RuntimeDiagnostics (copy), DeterminismTraceCapture (copy)
    local v29 = RunService:IsClient();
    assert(v29, "MovementV2 Client.Runtime is client-only");
    local v30;

    if type(p28) == "table" then
        v30 = type(p28.SampleInput) == "function";
    else
        v30 = false;
    end;

    assert(v30, "SampleInput callback is required");
    local u31 = setmetatable({
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
        _options = p28,
        _connections = {},
        _collisionComposer = p28.CollisionComposer,
        _presentationContextScratch = {
            Mapping = nil,
            ServerTick = nil,
            TickFraction = 0,
            LocalPlayerContactCritical = false,
            Status = "Stopped",
            Reason = nil
        },
        _localPresentationContextScratch = {
            Mapping = nil,
            ServerTick = nil,
            TickFraction = 0,
            LocalPlayerContactCritical = false,
            Status = "Stopped",
            Reason = nil
        },
        _remotePresentationPool = {},
        _remotePresentations = {},
        _pendingDeltas = {},
        _pendingMoverDeltas = {},
        _pendingMoverReplayIds = {},
        _damageTagsByMovementTick = {},
        _reconciliationReplayBudget = {
            MinimumSteps = 1,
            MaximumSteps = 16,
            MaximumSeconds = 0.0005
        },
        _contactActorIds = {},
        _seenJumpCommands = {},
        _seenJumpOrder = {},
        _lastWarningAtByMessage = {}
    }, u1);
    u31._uplink = CommandUplink.new({
        OnPacketSent = function(p32: number, p33: boolean) -- Line: 227, Name: OnPacketSent
            -- upvalues: u31 (copy)
            local _mapping = u31._mapping;
            local OnCommandPacketSent = u31._options.OnCommandPacketSent;

            if _mapping ~= nil and OnCommandPacketSent ~= nil then
                OnCommandPacketSent(_mapping.Generation, p32, p33);
            end;
        end,

        Warn = function(p34: string) -- Line: 234, Name: Warn
            -- upvalues: u31 (copy)
            u31:_warn(p34);
        end
    });
    u31._diagnostics = RuntimeDiagnostics.new(u31);
    u31._traceCapture = DeterminismTraceCapture.new({
        Report = function(p35, p36, p37) -- Line: 240, Name: Report
            -- upvalues: u31 (copy)
            u31._diagnostics:reportIssue(p35, p36, p37);
        end,

        Warn = function(p38: string) -- Line: 243, Name: Warn
            -- upvalues: u31 (copy)
            u31:_warn(p38);
        end
    });

    return u31;
end;

local function annotateReconciliation(p39: any, p40: any, p41: any, p42: any, p43: any, p44: any, p45: number?, p46: any) -- Line: 250
    -- upvalues: Serial (copy)
    p39.ReconciliationMode = p40.ReplayCount == 0 and p39.ReplayBarrier == "AcknowledgementHeld" and "Reuse" or (p41.LastProcessedCommand == Serial.UInt32Max and "Initial" or (p42 == nil and "Reanchor" or (p40.ReplayCount > 0 and "Replay" or "Reuse")));
    p39.ReplayCount = p40.ReplayCount;
    p39.DroppedCommandCount = p40.DroppedCommandCount;

    if p46 ~= nil and (p46.LastProcessedCommand ~= Serial.UInt32Max and p41.LastProcessedCommand ~= Serial.UInt32Max) then
        local v47 = Serial.deltaUInt32(p41.LastProcessedCommand, p46.LastProcessedCommand);
        p39.AcknowledgedCommandDelta = math.max(v47, 0);
        local v48 = Serial.deltaUInt32(p41.ServerTick, p46.ServerTick);
        p39.ServerTickDelta = math.max(v48, 0);
        p39.ServerHeldTickCount = math.max(p39.ServerTickDelta - p39.AcknowledgedCommandDelta, 0);
    end;

    if p43 == nil or p44 == nil then
        return;
    end;

    p39.TailCompared = true;

    if p45 ~= nil then
        p39.TailServerTickDelta = Serial.deltaUInt32(p40.TailServerTick, p45);
    end;

    local v49 = p40.State.Position - p43.Position;
    local v50 = p40.State.Velocity - p43.Velocity;
    p39.TailPosition = v49.Magnitude;
    p39.TailHorizontalPosition = Vector2.new(v49.X, v49.Z).Magnitude;
    p39.TailVerticalPosition = v49.Y;
    p39.TailVelocity = v50.Magnitude;
    p39.TailVerticalVelocity = v50.Y;
    p39.TailSupportAnchor = (p40.Support.Anchor - p44.Anchor).Magnitude;
    p39.TailSupportVelocity = (p40.Support.Velocity - p44.Velocity).Magnitude;
    p39.TailSupportKindMismatch = p40.Support.Kind == p44.Kind and 0 or 1;
    p39.TailSupportSourceMismatch = p40.Support.SourceId == p44.SourceId and 0 or 1;
    p39.TailGroundMismatch = p40.State.OnGround ~= p43.OnGround;
    p39.TailStanceMismatch = p40.State.Stance ~= p43.Stance;
end;

function u1._warn(p51: table, p52: string) -- Line: 303
    -- upvalues: DiagnosticProtocol (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - (p51._lastWarningAtByMessage[p52] or (-1 / 0)) < 5 then
        return;
    end;

    p51._lastWarningAtByMessage[p52] = os_clock_ret;
    p51._diagnostics:reportWarning(p52);
    local OnWarning = p51._options.OnWarning;

    if OnWarning == nil then
        DiagnosticProtocol.outputWarning((`[MovementV2.Client] {p52}`));

        return;
    end;

    OnWarning(p52);
end;

function u1._setStatus(p53: table, p54: any, p55: string?) -- Line: 319
    p53._statusFromPredictionFailure = false;

    if p53._status == p54 and p53._reason == p55 then
        return;
    end;

    p53._diagnostics:recordStatusChange(p53._status);
    p53._status = p54;
    p53._reason = p55;
    local OnStatusChanged = p53._options.OnStatusChanged;

    if OnStatusChanged ~= nil then
        OnStatusChanged(p54, p55);
    end;
end;

function u1.getStatus(p56) -- Line: 333
    return p56._status, p56._reason;
end;

function u1.getMapping(p57) -- Line: 337
    return p57._mapping;
end;

function u1._refreshPresentedState(p58, p59) -- Line: 341
    -- upvalues: clone (copy), cloneSupport (copy)
    if p58._state == nil or p58._support == nil then
        p58._presentedState = nil;
        p58._previousPresentedState = nil;
        p58._presentedSupport = nil;

        return;
    end;

    local v60 = clone(p58._state);
    p58._presentedState = v60;

    if p59 ~= nil then
        v60 = clone(p59);
    end;

    p58._previousPresentedState = v60;
    p58._presentedSupport = cloneSupport(p58._support);
end;

function u1.getPredictedState(p61) -- Line: 354
    -- upvalues: clone (copy), cloneSupport (copy)
    if p61._state == nil or p61._support == nil then
        return nil, nil, p61._lastPredictedServerTick;
    end;

    return clone(p61._state), cloneSupport(p61._support), p61._lastPredictedServerTick;
end;

function u1.getRemoteViewTick(p62) -- Line: 362
    local v63, v64 = p62:_presentationClock();
    local _config = p62._config;

    if v63 == nil or _config == nil then
        return nil;
    end;

    return v63 + v64 - _config.RenderInterpolationTicks;
end;

function u1.rejectDoorPrediction(p65: table, p66: number, p67: number) -- Line: 372
    -- upvalues: OwnerReplay (copy), Serial (copy)
    local _collisionComposer = p65._collisionComposer;

    if _collisionComposer == nil or type(_collisionComposer.RejectDoorUse) ~= "function" then
        return false, "MoverComposerUnavailable";
    end;

    local v68, v69 = _collisionComposer:RejectDoorUse(p66, p67);

    if v69 ~= nil then
        return false, v69;
    end;

    if v68 == nil then
        return true, nil;
    end;

    OwnerReplay.invalidateWorld(p65);
    local _reconciler = p65._reconciler;

    if p65._pendingReconciliationInstall ~= nil and _reconciler ~= nil then
        _reconciler:invalidatePendingReplayFromTick(v68);
    end;

    local _pendingMoverReplayTick = p65._pendingMoverReplayTick;

    if _pendingMoverReplayTick == nil or Serial.deltaUInt32(v68, _pendingMoverReplayTick) < 0 then
        p65._pendingMoverReplayTick = v68;
    end;

    p65._pendingMoverReplayIds[p66] = true;

    return true, nil;
end;

function u1._localClockAnchor(p70) -- Line: 398
    local _lastPredictedServerTick = p70._lastPredictedServerTick;
    local _config = p70._config;

    if _lastPredictedServerTick == nil or _config == nil then
        return _lastPredictedServerTick, 0;
    end;

    return _lastPredictedServerTick, math.clamp(p70._accumulatorSeconds / _config.StepSeconds, 0, 0.999999);
end;

function u1._presentationClock(p71) -- Line: 407
    local _remoteClock = p71._remoteClock;

    if _remoteClock == nil then
        return nil, 0;
    end;

    return _remoteClock:current();
end;

function u1._localPlayerContactCritical(p72) -- Line: 415
    -- upvalues: Enums (copy)
    local _mapping = p72._mapping;

    if _mapping == nil or not _mapping.PlayerCollisionsEnabled then
        return false;
    end;

    local _support = p72._support;

    return _support ~= nil and (_support.Kind == Enums.SupportKind.Player and _support.SourceId ~= 0) and true or next(p72._contactActorIds) ~= nil;
end;

function u1._playerContactNearStateAtTick(p73: table, p74: any, p75: number) -- Line: 427
    -- upvalues: PlayerContacts (copy), Config2 (copy), withinPlayerContactMargin (copy)
    local _mapping = p73._mapping;
    local _remoteBuffer = p73._remoteBuffer;

    if _mapping == nil or (not _mapping.PlayerCollisionsEnabled or _remoteBuffer == nil) then
        return false;
    end;

    local v76 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin;
    local v77 = Config2.Default.PlayerSizeStanding + Vector3.new(v76, v76, v76);

    for _, v in _remoteBuffer:queryCollisionActorKeys(p74.Position - v77, p74.Position + v77) do
        local CollisionPose = _remoteBuffer:getCollisionPose(v, p75, 0);

        if CollisionPose ~= nil and (CollisionPose.ActorId ~= _mapping.ActorId and withinPlayerContactMargin(p74, CollisionPose)) then
            return true;
        end;
    end;

    return false;
end;

function u1._presentationContext(p78) -- Line: 445
    local v79, v80 = p78:_presentationClock();

    return {
        Mapping = p78._mapping,
        ServerTick = v79,
        TickFraction = v80,
        LocalPlayerContactCritical = p78:_localPlayerContactCritical(),
        Status = p78._status,
        Reason = p78._reason
    };
end;

function u1._sendBaselineRequest(p81: table, p82: number, p83: number, p84: string) -- Line: 457
    -- upvalues: ControlCodec (copy)
    local _channels = p81._channels;

    if _channels == nil then
        return;
    end;

    local v85, v86 = ControlCodec.encodeBaselineRequest(p82, p83);

    if v85 == nil then
        p81:_warn((`failed to encode destructible baseline request: {v86}`));

        return;
    end;

    p81:_sendDueCommands(true);
    _channels.Control:FireServer(v85);
    p81:_setStatus("WaitingForBaseline", p84);
end;

function u1._sendMappingRequest(p87: table, p88: number) -- Line: 472
    -- upvalues: ControlCodec (copy)
    if p87._retiredGeneration == p88 then
        return;
    end;

    if p87._requestedMappingGeneration == p88 then
        return;
    end;

    local _channels = p87._channels;

    if _channels == nil then
        return;
    end;

    local v89, v90 = ControlCodec.encodeMappingRequest(p88);

    if v89 == nil then
        p87:_warn((`failed to encode mapping request: {v90}`));

        return;
    end;

    p87:_sendDueCommands(true);
    p87._diagnostics:recordMappingRequest();
    p87._requestedMappingGeneration = p88;
    _channels.Control:FireServer(v89);
end;

function u1._sendCommandResyncRequest(p91: table, p92: number, p93: boolean?) -- Line: 494
    -- upvalues: Serial (copy), ControlCodec (copy)
    local _mapping = p91._mapping;
    local _channels = p91._channels;

    if _mapping == nil or (_channels == nil or not Serial.isUInt32(p92)) then
        return false;
    end;

    local v94 = p91._pendingCommandResyncThrough or p92;

    if p91._pendingCommandResyncThrough == v94 and p93 ~= true then
        return true;
    end;

    local v95, v96 = ControlCodec.encodeCommandResyncRequest(_mapping.Generation, v94);

    if v95 == nil then
        p91:_warn((`failed to encode command resync request: {v96}`));

        return false;
    end;

    p91:_sendDueCommands(true);
    p91._diagnostics:recordResyncRequest();
    p91._pendingCommandResyncThrough = v94;
    p91._commandResyncRequestedAt = os.clock();
    _channels.Control:FireServer(v95);

    return true;
end;

function u1._canPredict(p97) -- Line: 518
    local v98;

    if p97._status ~= "Running" and (p97._status ~= "WaitingForInput" and (p97._status ~= "WaitingForAuthority" and p97._status ~= "WaitingForBaseline")) or (p97._mapping == nil or (p97._topology == nil or (p97._timeline == nil or (p97._state == nil or (p97._support == nil or p97._lastPredictedServerTick == nil))))) then
        v98 = false;
    else
        v98 = p97._lastAcceptedOwnerSnapshot ~= nil;
    end;

    return v98;
end;

function u1._sendGrenadeTransitionRequest(p99, p100) -- Line: 534
    -- upvalues: ControlCodec (copy)
    local _mapping = p99._mapping;
    local _channels = p99._channels;
    local WeaponSelectRequestId = p100.WeaponSelectRequestId;
    local WeaponSelectIdentifier = p100.WeaponSelectIdentifier;
    local GrenadeThrowIdentifier = p100.GrenadeThrowIdentifier;
    local GrenadeThrowAnimation = p100.GrenadeThrowAnimation;

    if _mapping == nil or (_channels == nil or (WeaponSelectRequestId == nil or (WeaponSelectIdentifier == nil or (GrenadeThrowIdentifier == nil or GrenadeThrowAnimation == nil)))) then
        return false;
    end;

    local v101, v102 = ControlCodec.encodeGrenadeTransitionRequest(_mapping.Generation, p100.CommandNumber, WeaponSelectRequestId, WeaponSelectIdentifier, GrenadeThrowIdentifier, GrenadeThrowAnimation, p100.LookYaw, p100.VerticalLook);

    if v101 == nil then
        p99:_warn((`failed to encode grenade transition: {v102}`));

        return false;
    end;

    _channels.Control:FireServer(v101);

    return true;
end;

function u1.requestMapping(p103: table, p104: number) -- Line: 569
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p104) then
        return false, "InvalidGeneration";
    end;

    if p103._retiredGeneration == p104 then
        return false, "GenerationRetired";
    end;

    if p103._channels == nil then
        p103._queuedMappingGeneration = p104;

        return true, nil;
    end;

    p103._queuedMappingGeneration = nil;
    local _mapping = p103._mapping;

    if _mapping == nil or _mapping.Generation ~= p104 then
        p103:_setStatus("WaitingForMapping", "RequestedCharacterGeneration");
    end;

    p103._requestedMappingGeneration = nil;
    p103:_sendMappingRequest(p104);

    return true, nil;
end;

function u1._disposeTimeline(p105) -- Line: 591
    if p105._timelineConnection ~= nil then
        p105._timelineConnection:Disconnect();
        p105._timelineConnection = nil;
    end;

    if p105._timeline ~= nil then
        p105._timeline:destroy();
        p105._timeline = nil;
    end;
end;

function u1._clearGenerationState(p106) -- Line: 603
    p106:_disposeTimeline();
    p106._commandStream = nil;
    p106._predictionRing = nil;
    p106._traceCapture:reset(nil);
    p106._reconciler = nil;
    p106._state = nil;
    p106._support = nil;
    p106:_refreshPresentedState();
    p106._lastPredictedServerTick = nil;
    p106._lastWeaponSelectionCommand = nil;
    p106._accumulatorSeconds = 0;
    p106._cachedStaticFrame = nil;
    p106._cachedStaticWorld = nil;
    p106._pendingBaseline = nil;
    table.clear(p106._pendingDeltas);
    p106._pendingMoverBaseline = nil;
    table.clear(p106._pendingMoverDeltas);
    p106._pendingMoverReplayTick = nil;
    p106._pendingMoverReplayRevision = nil;
    table.clear(p106._pendingMoverReplayIds);
    table.clear(p106._damageTagsByMovementTick);
    p106._pendingDamageTagReplayMovementTick = nil;
    p106._actionLocks = nil;
    p106._pendingActionLockReplay = false;
    p106._pendingDiscontinuity = nil;
    p106._pendingOwnerSnapshot = nil;
    p106._pendingReconciliationInstall = nil;
    p106._lastHistoryRecoveryRequestAt = 0;
    p106._lastAcceptedOwnerSnapshot = nil;
    p106._requestedMappingGeneration = nil;
    p106._queuedMappingGeneration = nil;
    table.clear(p106._contactActorIds);
    table.clear(p106._seenJumpCommands);
    table.clear(p106._seenJumpOrder);
    p106._lastAuthoritativeJumpCommand = nil;
    p106._uplink:resetGeneration();
    p106._pendingCommandResyncThrough = nil;
    p106._commandResyncRequestedAt = 0;
    local _collisionComposer = p106._collisionComposer;

    if _collisionComposer ~= nil then
        _collisionComposer:Reset();
    end;
end;

function u1.retireGeneration(p107: table, p108: number) -- Line: 648
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p108) then
        return false, "InvalidGeneration";
    end;

    local _mapping = p107._mapping;

    if _mapping ~= nil and _mapping.Generation ~= p108 then
        return false, "GenerationMismatch";
    end;

    p107._retiredGeneration = p108;
    p107._mapping = nil;
    p107._config = nil;
    p107._predictionPacingPolicy = nil;
    p107._commandClock = nil;
    p107._topologyRetrySeconds = 0;
    p107:_clearGenerationState();
    p107:_setStatus("WaitingForMapping", "GenerationUnbound");

    return true, nil;
end;

function u1._bindCollisionSources(p109, p110, p111) -- Line: 670
    p109._timeline = p110;
    p109._collisionComposer = p111;
end;

function u1._ensureTopology(u112, p113) -- Line: 675
    -- upvalues: defaultMapRoot (copy), TopologyBuilder (copy), Catalog (copy), Config2 (copy)
    local _topology = u112._topology;

    if _topology ~= nil and (_topology.Epoch == p113.TopologyEpoch and _topology.Fingerprint == p113.TopologyFingerprint) then
        return true, nil;
    end;

    local u114 = (u112._options.ResolveMapRoot or defaultMapRoot)(p113);

    if u114 == nil then
        return false, "ReplicatedMapUnavailable";
    end;

    local _topologyBuild = u112._topologyBuild;

    if _topologyBuild ~= nil and (_topologyBuild.Epoch == p113.TopologyEpoch and _topologyBuild.Fingerprint == p113.TopologyFingerprint) then
        if _topologyBuild.Result == nil and _topologyBuild.Error == nil then
            return false, "TopologyBuilding";
        end;

        u112._topologyBuild = nil;

        if _topologyBuild.Result == nil then
            return false, _topologyBuild.Error;
        end;

        u112._topology = _topologyBuild.Result;

        return true, nil;
    end;

    local Barriers = u114:FindFirstChild("Barriers");

    if Barriers ~= nil and #Barriers:GetDescendants() >= TopologyBuilder.LargeSourceCount then
        local u115 = {
            Result = nil,
            Error = nil,
            Epoch = p113.TopologyEpoch,
            Fingerprint = p113.TopologyFingerprint
        };
        u112._topologyBuild = u115;
        task.spawn(function() -- Line: 715
            -- upvalues: TopologyBuilder (ref), u112 (copy), u115 (copy), Catalog (ref), u114 (copy), Config2 (ref)
            local u116 = TopologyBuilder.createFrameYielder(0.008);

            local function yieldIfNeeded() -- Line: 717
                -- upvalues: u116 (copy), u112 (ref), u115 (ref)
                u116();

                if u112._topologyBuild ~= u115 then
                    error("TopologyBuildSuperseded");
                end;
            end;

            local success, result = pcall(function() -- Line: 724
                -- upvalues: Catalog (ref), u114 (ref), u112 (ref), yieldIfNeeded (copy), u115 (ref), TopologyBuilder (ref), Config2 (ref)
                local v117, v118 = Catalog.ReadPublished(u114, u112._options.OnWarning, yieldIfNeeded);

                if v117 == nil then
                    return v118;
                end;

                return (v117.Manifest.Epoch ~= u115.Epoch or v117.Manifest.Fingerprint ~= u115.Fingerprint) and "ReplicatedManifestDoesNotMatchMapping" or TopologyBuilder.Build(v117, Config2.Default, nil, yieldIfNeeded);
            end);

            if not success then
                u115.Error = `TopologyBuildFailed: {result}`;

                return;
            end;

            if typeof(result) == "string" then
                u115.Error = result;

                return;
            end;

            if result.Epoch == u115.Epoch and result.Fingerprint == u115.Fingerprint then
                u115.Result = result;

                return;
            end;

            u115.Error = "BuiltTopologyDoesNotMatchMapping";
        end);

        return false, "TopologyBuilding";
    end;

    local v119, v120 = Catalog.ReadPublished(u114, u112._options.OnWarning);

    if v119 == nil then
        return false, v120;
    end;

    if v119.Manifest.Epoch ~= p113.TopologyEpoch or v119.Manifest.Fingerprint ~= p113.TopologyFingerprint then
        return false, "ReplicatedManifestDoesNotMatchMapping";
    end;

    local v121 = TopologyBuilder.Build(v119, Config2.Default);

    if v121.Epoch ~= p113.TopologyEpoch or v121.Fingerprint ~= p113.TopologyFingerprint then
        return false, "BuiltTopologyDoesNotMatchMapping";
    end;

    u112._topology = v121;

    return true, nil;
end;

function u1._initializeGeneration(u122, p123) -- Line: 765
    -- upvalues: DestructibleTimeline (copy), Config (copy), PredictionPacing (copy), CommandClock (copy), CommandStream (copy), PredictionRing (copy), Reconciler (copy)
    u122._lastResyncOwnerSnapshot = nil;
    local v124, v125 = u122:_ensureTopology(p123);

    if not v124 then
        u122:_setStatus("WaitingForTopology", v125);

        return false, v125;
    end;

    local v126 = assert(u122._topology);
    u122:_disposeTimeline();
    local u127 = DestructibleTimeline.new(p123.SimulationHz, v126.Epoch, v126.DestructibleCount);
    u122._timeline = u127;
    u122._timelineConnection = u127.BaselineNeeded:Connect(function(p128, p129, p130) -- Line: 776
        -- upvalues: u122 (copy), u127 (copy)
        if u122._timeline == u127 then
            u122:_sendBaselineRequest(p128, p129, p130);
        end;
    end);
    u122._config = Config.derive(p123.SimulationHz);
    u122._predictionPacingPolicy = PredictionPacing.policyFromConfig(u122._config);
    u122._commandClock = CommandClock.new(u122._config);
    u122._lastOwnerCommandFeedback = nil;
    u122._commandStream = CommandStream.new(p123);
    u122._uplink:fillBudget(u122._config);
    u122._predictionRing = PredictionRing.new(p123);
    u122._traceCapture:reset(u122._config);
    u122._reconciler = Reconciler.new(p123, u122._predictionRing);
    u122._observerMapping = nil;
    u122:_ensureRemoteStreams(p123, false);
    u122._state = nil;
    u122._support = nil;
    u122:_refreshPresentedState();
    u122._lastPredictedServerTick = nil;
    u122._lastWeaponSelectionCommand = nil;
    u122._pendingReconciliationInstall = nil;
    u122._lastHistoryRecoveryRequestAt = 0;
    u122._accumulatorSeconds = 0;
    u122._topologyRetrySeconds = 0;
    table.clear(u122._contactActorIds);
    table.clear(u122._seenJumpCommands);
    table.clear(u122._seenJumpOrder);
    u122._lastAuthoritativeJumpCommand = nil;
    u122:_setStatus("WaitingForBaseline", "InitialDestructibleBaseline");

    return true, nil;
end;

function u1.retryTopology(p131) -- Line: 810
    local _mapping = p131._mapping;

    if _mapping == nil then
        return false, "MappingUnavailable";
    end;

    if p131._timeline ~= nil then
        return true, nil;
    end;

    local v132, v133 = p131:_initializeGeneration(_mapping);

    if v132 then
        p131:_drainPendingCollisionControls();
        p131:_tryInstallDiscontinuity();
    end;

    return v132, v133;
end;

function u1._applyMapping(p134, p135) -- Line: 826
    -- upvalues: Mapping (copy), Serial (copy), Enums (copy), clone (copy), PlayerContacts (copy), RuntimeSettings (copy), Config (copy), PredictionPacing (copy)
    local v136, v137 = Mapping.validate(p135);

    if not v136 then
        p134:_warn((`rejected movement mapping: {v137}`));

        return;
    end;

    if p134._retiredGeneration == p135.Generation then
        return;
    end;

    local _mapping = p134._mapping;

    if _mapping ~= nil then
        local v138 = Serial.deltaUInt16(p135.Generation, _mapping.Generation);

        if v138 < 0 then
            return;
        end;

        if v138 == 0 then
            local v139;

            if p135.Generation == _mapping.Generation and (p135.ActorId == _mapping.ActorId and (p135.SimulationHz == _mapping.SimulationHz and p135.TopologyEpoch == _mapping.TopologyEpoch)) then
                v139 = p135.TopologyFingerprint == _mapping.TopologyFingerprint;
            else
                v139 = false;
            end;

            if v139 then
                v139 = p135.PlayerCollisionsEnabled ~= _mapping.PlayerCollisionsEnabled;
            end;

            if not v139 then
                local v140;

                if p135.Generation == _mapping.Generation and (p135.ActorId == _mapping.ActorId and (p135.SimulationHz == _mapping.SimulationHz and p135.TopologyEpoch == _mapping.TopologyEpoch)) then
                    v140 = p135.TopologyFingerprint == _mapping.TopologyFingerprint;
                else
                    v140 = false;
                end;

                if not v140 then
                    p134:_warn("received conflicting mapping for the active generation");
                    p134:_sendMappingRequest(p135.Generation);

                    return;
                end;

                p134._requestedMappingGeneration = nil;
                p134._queuedMappingGeneration = nil;

                if p134._timeline == nil then
                    p134:retryTopology();
                end;

                local _lastAcceptedOwnerSnapshot = p134._lastAcceptedOwnerSnapshot;

                if _lastAcceptedOwnerSnapshot == nil or _lastAcceptedOwnerSnapshot.Generation ~= p135.Generation then
                    p134:_sendDueCommands(true);

                    return;
                end;

                p134:_sendRecoveryCommands(_lastAcceptedOwnerSnapshot.LastProcessedCommand);

                return;
            end;

            local _commandStream = p134._commandStream;
            local _reconciler = p134._reconciler;

            if _commandStream == nil or _reconciler == nil then
                p134._mapping = nil;
                p134:_applyMapping(p135);

                return;
            end;

            p134._mapping = table.freeze(Mapping.clone(p135));
            _commandStream:reconfigure(p135);
            _reconciler:reconfigure(p135);
            p134._traceCapture:reset(p134._config);
            table.clear(p134._contactActorIds);
            p134._pendingReconciliationInstall = nil;
            p134._lastHistoryRecoveryRequestAt = 0;
            p134._requestedMappingGeneration = nil;
            p134._queuedMappingGeneration = nil;
            p134._pendingDiscontinuity = nil;
            p134._pendingOwnerSnapshot = nil;
            local _state = p134._state;
            local _support = p134._support;

            if not (p135.PlayerCollisionsEnabled or (_state == nil or (_support == nil or _support.Kind ~= Enums.SupportKind.Player))) then
                local v141 = clone(_state);
                v141.Velocity = PlayerContacts.toWorldVelocity(_state.Velocity, _support);
                v141.OnGround = false;
                v141.GroundNormal = Vector3.new(0, 1, 0);
                v141.GroundSurfaceFriction = RuntimeSettings.getMovementConfig(p135.SimulationHz).SurfaceFrictionDefault;
                p134._state = v141;
                p134._support = {
                    SourceId = 0,
                    Anchor = Vector3.new(0, 0, 0),
                    Velocity = Vector3.new(0, 0, 0),
                    Kind = Enums.SupportKind.None
                };
            end;

            if p134:_canPredict() then
                p134:_setStatus("Running", nil);

                return;
            end;

            p134:_setStatus("WaitingForAuthority", "PlayerCollisionPolicyChanged");

            return;
        end;
    end;

    p134:_clearGenerationState();
    p134._config = Config.derive(p135.SimulationHz);
    p134._predictionPacingPolicy = PredictionPacing.policyFromConfig(p134._config);

    if p134._commandClock ~= nil then
        p134._commandClock:reset();
        p134._lastOwnerCommandFeedback = nil;
    end;

    p134._observerMapping = nil;
    p134._mapping = table.freeze(Mapping.clone(p135));
    p134._retiredGeneration = nil;
    p134._lastPredictionHitchAt = 0;
    p134._lastOwnerAppliedAt = 0;
    table.clear(p134._lastWarningAtByMessage);
    p134._uplink:resetCounters();
    p134._diagnostics:resetGeneration();
    p134:_initializeGeneration(p135);
end;

function u1._applyBaseline(p142, p143) -- Line: 928
    -- upvalues: OwnerReplay (copy)
    local _timeline = p142._timeline;

    if _timeline == nil then
        p142._pendingBaseline = p143;

        return false;
    end;

    local v144, v145, v146 = _timeline:consumeBaseline(p143.ServerTick, p143.Frame);

    if not v144 then
        p142:_warn((`rejected destructible baseline: {v145}`));

        return false;
    end;

    if v146 then
        OwnerReplay.invalidateWorld(p142);
    end;

    p142._pendingBaseline = nil;

    return true;
end;

function u1._deferDestructibleDelta(p147: table, p148: any, p149: number) -- Line: 947
    -- upvalues: Config (copy)
    if #p147._pendingDeltas < (p147._config or Config.Default).PredictionReplayTicks then
        p147._pendingDeltas[#p147._pendingDeltas + 1] = p148;

        return;
    end;

    table.clear(p147._pendingDeltas);
    p147:_sendBaselineRequest(p148.Epoch, p149, "PendingDestructibleHistoryOverflow");
end;

function u1._deferMoverDelta(p150, p151) -- Line: 958
    -- upvalues: Config (copy)
    if #p150._pendingMoverDeltas < (p150._config or Config.Default).PredictionReplayTicks then
        p150._pendingMoverDeltas[#p150._pendingMoverDeltas + 1] = p151;

        return;
    end;

    table.clear(p150._pendingMoverDeltas);
    local _mapping = p150._mapping;

    if _mapping ~= nil then
        p150:_sendMappingRequest(_mapping.Generation);
    end;
end;

function u1._applyDelta(p152, p153) -- Line: 971
    -- upvalues: OwnerReplay (copy), Serial (copy)
    OwnerReplay.invalidateWorld(p152);
    local _timeline = p152._timeline;

    if _timeline == nil then
        p152:_deferDestructibleDelta(p153, 0);

        return false;
    end;

    local v154, v155 = _timeline:consumeDelta(p153.Epoch, p153.Revision, p153.ServerTick, p153.Indices);

    if not v154 then
        p152:_warn((`rejected destructible delta: {v155}`));

        return false;
    end;

    local v156;

    if p152._predictionRing == nil then
        v156 = nil;
    else
        v156 = p152._predictionRing:newestCommandNumber();
    end;

    local v157;

    if v156 == nil then
        v157 = nil;
    else
        v157 = p152._predictionRing:get(v156);
    end;

    local v158;

    if v157 == nil then
        v158 = false;
    else
        v158 = Serial.deltaUInt32(v157.ServerTick, p153.ServerTick) >= 0;
    end;

    local v159 = p152._pendingDiscontinuity ~= nil;
    p152:_tryInstallDiscontinuity();

    if p152._pendingReconciliationInstall ~= nil then
        return true;
    end;

    if v159 then
        v159 = p152._pendingDiscontinuity == nil;
    end;

    local _pendingOwnerSnapshot = p152._pendingOwnerSnapshot;

    if _pendingOwnerSnapshot ~= nil and p152._state ~= nil then
        p152._pendingOwnerSnapshot = nil;
        v159 = p152:_handleOwnerSnapshot(_pendingOwnerSnapshot) or v159;
    end;

    if v158 and not v159 then
        p152:_setStatus("WaitingForAuthority", "DestructibleChangedInsidePrediction");
        local _mapping = p152._mapping;

        if _mapping ~= nil then
            p152:_sendMappingRequest(_mapping.Generation);
        end;
    end;

    return true;
end;

function u1._applyMoverBaseline(p160, p161) -- Line: 1009
    -- upvalues: OwnerReplay (copy)
    local _collisionComposer = p160._collisionComposer;
    local _mapping = p160._mapping;

    if _collisionComposer == nil or _mapping == nil then
        return false;
    end;

    if p161.Epoch ~= _mapping.TopologyEpoch then
        return false;
    end;

    local v162, v163, v164, v165, v166 = _collisionComposer:ConsumeBaseline(p161.Epoch, p161.Revision, p161.ServerTick, p161.Descriptors, p161.ProgressAnchors);

    if not v162 then
        p160:_warn((`rejected mover baseline: {v163}`));

        return false;
    end;

    if v166 ~= false then
        OwnerReplay.invalidateWorld(p160);
    end;

    if v164 ~= nil then
        p160:_queueMoverReplay(v164, p161.Revision, v165);
    end;

    p160:_applyPendingMoverDeltas();

    if v164 ~= nil and p160._state ~= nil then
        return true;
    end;

    p160:_tryInstallDiscontinuity();
    p160:_installOwnerSnapshotAfterControls();

    return true;
end;

function u1._applyPendingMoverDeltas(p167) -- Line: 1045
    local _pendingMoverDeltas = p167._pendingMoverDeltas;
    p167._pendingMoverDeltas = {};

    for i, v in _pendingMoverDeltas do
        if not p167:_applyMoverDelta(v) then
            for i2 = i + 1, #_pendingMoverDeltas do
                p167._pendingMoverDeltas[#p167._pendingMoverDeltas + 1] = _pendingMoverDeltas[i2];
                local _ = i2;
            end;

            return;
        end;
    end;
end;

function u1._markMoverRevisionValidated(p168: table, p169: number) -- Line: 1058
    local _reconciler = p168._reconciler;

    if _reconciler == nil then
        return false;
    end;

    local v170, v171 = _reconciler:markMoverRevisionValidated(p169);

    if not v170 then
        p168:_warn((`could not validate mover revision: {v171 or "unknown"}`));
    end;

    return v170;
end;

function u1._applyMoverDelta(p172, p173) -- Line: 1070
    local _collisionComposer = p172._collisionComposer;
    local _mapping = p172._mapping;

    if _collisionComposer == nil or _mapping == nil then
        p172:_deferMoverDelta(p173);

        return false;
    end;

    if p173.Epoch ~= _mapping.TopologyEpoch then
        return false;
    end;

    local v174, v175, v176, v177;

    if p173.Kind == "MoverProgress" then
        v174, v175, v176, v177 = _collisionComposer:ConsumeProgress(p173.Epoch, p173.Revision, p173.ServerTick, p173.Streams);
    else
        v174, v175, v176, v177 = _collisionComposer:ConsumeDelta(p173.Epoch, p173.Revision, p173.ServerTick, p173.Descriptors);
    end;

    if v175 == "MoverBaselineRequired" then
        p172:_deferMoverDelta(p173);

        return false;
    end;

    if v175 == nil then
        if v174 == nil then
            if v176 then
                if p172._pendingMoverReplayTick == nil then
                    p172:_markMoverRevisionValidated(p173.Revision);
                else
                    p172._pendingMoverReplayRevision = p173.Revision;
                end;
            end;

            return true;
        end;

        p172:_queueMoverReplay(v174, p173.Revision, v177);

        return true;
    end;

    p172:_warn((`rejected mover delta: {v175}`));
    p172:_sendMappingRequest(_mapping.Generation);

    return false;
end;

function u1._queueMoverReplay(p178: table, p179: number, p180: number, p181: table?) -- Line: 1113
    -- upvalues: OwnerReplay (copy), Serial (copy)
    OwnerReplay.invalidateWorldFromTick(p178, p179, p180);
    local _pendingMoverReplayTick = p178._pendingMoverReplayTick;

    if _pendingMoverReplayTick == nil or Serial.deltaUInt32(p179, _pendingMoverReplayTick) < 0 then
        p178._pendingMoverReplayTick = p179;
    end;

    local _pendingMoverReplayRevision = p178._pendingMoverReplayRevision;

    if _pendingMoverReplayRevision == nil or Serial.deltaUInt32(p180, _pendingMoverReplayRevision) > 0 then
        p178._pendingMoverReplayRevision = p180;
    end;

    if p181 ~= nil then
        for i in p181 do
            p178._pendingMoverReplayIds[i] = true;
        end;
    end;
end;

function u1._flushPendingMoverReplay(p182) -- Line: 1131
    -- upvalues: Serial (copy)
    local _pendingMoverReplayTick = p182._pendingMoverReplayTick;

    if _pendingMoverReplayTick == nil then
        return false;
    end;

    local _pendingMoverReplayRevision = p182._pendingMoverReplayRevision;
    local _pendingMoverReplayIds = p182._pendingMoverReplayIds;
    p182._pendingMoverReplayTick = nil;
    p182._pendingMoverReplayRevision = nil;
    p182._pendingMoverReplayIds = {};
    local _mapping = p182._mapping;

    if _mapping == nil then
        return false;
    end;

    local _predictionRing = p182._predictionRing;
    local v183;

    if _predictionRing == nil then
        v183 = nil;
    else
        v183 = _predictionRing:newestCommandNumber();
    end;

    local v184;

    if v183 == nil then
        v184 = nil;
    else
        v184 = _predictionRing:get(v183);
    end;

    local _collisionComposer = p182._collisionComposer;
    local v185;

    if _predictionRing == nil or (v184 == nil or Serial.deltaUInt32(v184.ServerTick, _pendingMoverReplayTick) < 0) then
        v185 = false;
    else
        v185 = (next(_pendingMoverReplayIds) == nil or (_collisionComposer == nil or type(_collisionComposer.IsPredictionStateAffected) ~= "function")) and true or _predictionRing:anyEntryAtOrAfterServerTick(_pendingMoverReplayTick, function(p186) -- Line: 1154
            -- upvalues: _collisionComposer (copy), _pendingMoverReplayIds (copy)
            return _collisionComposer:IsPredictionStateAffected(_pendingMoverReplayIds, p186.PostState, p186.PostSupport);
        end);
    end;

    if not v185 then
        if _pendingMoverReplayRevision ~= nil then
            p182:_markMoverRevisionValidated(_pendingMoverReplayRevision);
        end;

        return false;
    end;

    local v187 = p182._pendingDiscontinuity ~= nil;
    p182:_tryInstallDiscontinuity();

    if v187 then
        v187 = p182._pendingDiscontinuity == nil;
    end;

    local _pendingOwnerSnapshot = p182._pendingOwnerSnapshot;

    if _pendingOwnerSnapshot ~= nil and p182._state ~= nil then
        p182._pendingOwnerSnapshot = nil;
        v187 = p182:_handleOwnerSnapshot(_pendingOwnerSnapshot, true);

        if p182._pendingReconciliationInstall ~= nil then
            p182._pendingReconciliationInstall.MoverRevisionToValidate = _pendingMoverReplayRevision;

            return true;
        end;
    end;

    if v185 and not v187 then
        local _lastAcceptedOwnerSnapshot = p182._lastAcceptedOwnerSnapshot;

        if _lastAcceptedOwnerSnapshot ~= nil then
            local v188;
            v187, v188 = p182:_installSnapshot(_lastAcceptedOwnerSnapshot, false, true, nil, nil, _pendingMoverReplayTick);

            if v188 == "ReplayPending" then
                local _pendingReconciliationInstall = p182._pendingReconciliationInstall;

                if _pendingReconciliationInstall ~= nil then
                    _pendingReconciliationInstall.MoverRevisionToValidate = _pendingMoverReplayRevision;
                end;

                return true;
            end;
        end;

        if not v187 then
            p182:_setStatus("WaitingForAuthority", "MoverChangedBeforePredictedTail");
            p182:_sendMappingRequest(_mapping.Generation);
        end;
    end;

    if v187 and _pendingMoverReplayRevision ~= nil then
        p182:_markMoverRevisionValidated(_pendingMoverReplayRevision);
    end;

    return v187;
end;

function u1._applyDamageTagForStep(p189, p190) -- Line: 1202
    -- upvalues: Serial (copy), clone (copy), DamageTag (copy)
    local v191 = Serial.addUInt32(p190.MovementTick, 1);
    local v192 = p189._damageTagsByMovementTick[v191];

    if v192 == nil then
        return p190;
    end;

    local v193 = clone(p190);
    v193.VelocityModifier = DamageTag.apply(v193.VelocityModifier, v192);

    return v193;
end;

function u1._stateForCommand(p194: table, p195: any, p196: any, p197: number, p198: boolean) -- Line: 1213
    -- upvalues: forCommand (copy), ActionLockTimeline (copy)
    return forCommand(p195, p196, p197, p194._options.ResolveBaseMoveSpeed, p198, ActionLockTimeline.isLockedAt(p194._actionLocks, p197));
end;

function u1._pruneDamageTagsThrough(p199: table, p200: number) -- Line: 1229
    -- upvalues: Serial (copy)
    for i in p199._damageTagsByMovementTick do
        if Serial.deltaUInt32(p200, i) >= 0 then
            p199._damageTagsByMovementTick[i] = nil;
        end;
    end;

    local _pendingDamageTagReplayMovementTick = p199._pendingDamageTagReplayMovementTick;

    if _pendingDamageTagReplayMovementTick ~= nil and Serial.deltaUInt32(p200, _pendingDamageTagReplayMovementTick) >= 0 then
        p199._pendingDamageTagReplayMovementTick = nil;
    end;
end;

function u1._queueDamageTag(p201, p202) -- Line: 1241
    -- upvalues: Serial (copy), DamageTag (copy)
    local _mapping = p201._mapping;

    if _mapping == nil or p202.Generation ~= _mapping.Generation then
        if p201._retiredGeneration ~= p202.Generation then
            p201:_sendMappingRequest(p202.Generation);
        end;

        return;
    end;

    local _lastAcceptedOwnerSnapshot = p201._lastAcceptedOwnerSnapshot;

    if _lastAcceptedOwnerSnapshot ~= nil and Serial.deltaUInt32(_lastAcceptedOwnerSnapshot.State.MovementTick, p202.ApplyMovementTick) >= 0 then
        return;
    end;

    local v203 = p201._damageTagsByMovementTick[p202.ApplyMovementTick];
    local v204;

    if v203 == nil then
        v204 = p202.VelocityModifier;
    else
        v204 = DamageTag.apply(v203, p202.VelocityModifier);
    end;

    if v203 == v204 then
        return;
    end;

    p201._damageTagsByMovementTick[p202.ApplyMovementTick] = v204;
    local _reconciler = p201._reconciler;

    if _reconciler ~= nil then
        _reconciler:invalidatePendingReplayFromMovementTick(p202.ApplyMovementTick);
    end;

    local v205;

    if p201._state == nil then
        v205 = nil;
    else
        v205 = p201._state.MovementTick;
    end;

    if v205 == nil or Serial.deltaUInt32(v205, p202.ApplyMovementTick) < 0 then
        return;
    end;

    local _pendingDamageTagReplayMovementTick = p201._pendingDamageTagReplayMovementTick;
    local v206;

    if _lastAcceptedOwnerSnapshot == nil then
        v206 = _pendingDamageTagReplayMovementTick;
    else
        v206 = _lastAcceptedOwnerSnapshot.State.MovementTick;
    end;

    if _pendingDamageTagReplayMovementTick == nil or (v206 == nil or Serial.deltaUInt32(p202.ApplyMovementTick, v206) < Serial.deltaUInt32(_pendingDamageTagReplayMovementTick, v206)) then
        p201._pendingDamageTagReplayMovementTick = p202.ApplyMovementTick;
    end;
end;

function u1._flushPendingDamageTagReplay(p207) -- Line: 1286
    -- upvalues: DamageTagReplay (copy)
    return DamageTagReplay.flush(p207);
end;

function u1._drainPendingCollisionControls(p208) -- Line: 1290
    if p208._pendingReconciliationInstall ~= nil then
        return;
    end;

    local _pendingBaseline = p208._pendingBaseline;

    if _pendingBaseline ~= nil and not p208:_applyBaseline(_pendingBaseline) then
        return;
    end;

    if p208._timeline == nil or p208._timeline:needsBaseline() then
        return;
    end;

    local _pendingDeltas = p208._pendingDeltas;
    p208._pendingDeltas = {};

    for i, v in _pendingDeltas do
        if not p208:_applyDelta(v) or p208._pendingReconciliationInstall ~= nil then
            for i2 = i + 1, #_pendingDeltas do
                p208._pendingDeltas[#p208._pendingDeltas + 1] = _pendingDeltas[i2];
                local _ = i2;
            end;

            if p208._pendingReconciliationInstall ~= nil then
                return;
            end;

            break;
        end;
    end;

    local _pendingMoverBaseline = p208._pendingMoverBaseline;

    if _pendingMoverBaseline ~= nil then
        p208._pendingMoverBaseline = nil;
        p208:_applyMoverBaseline(_pendingMoverBaseline);

        if p208._pendingReconciliationInstall ~= nil then
            return;
        end;
    end;

    p208:_applyPendingMoverDeltas();
    p208:_flushPendingMoverReplay();
    p208:_tryInstallDiscontinuity();
    p208:_installOwnerSnapshotAfterControls();
end;

function u1._installOwnerSnapshotAfterControls(p209) -- Line: 1330
    local _pendingOwnerSnapshot = p209._pendingOwnerSnapshot;

    if _pendingOwnerSnapshot ~= nil and (p209._state ~= nil and p209:_remoteContactFrameReady(_pendingOwnerSnapshot)) then
        p209._pendingOwnerSnapshot = nil;
        p209:_handleOwnerSnapshot(_pendingOwnerSnapshot);
    end;
end;

function u1._remoteContactFrameReady(p210, p211) -- Line: 1339
    -- upvalues: Serial (copy)
    local _mapping = p210._mapping;

    if _mapping == nil or not _mapping.PlayerCollisionsEnabled then
        return true;
    end;

    local _remoteBuffer = p210._remoteBuffer;
    local v212;

    if _remoteBuffer == nil then
        v212 = nil;
    else
        v212 = _remoteBuffer:latestCompleteServerTick();
    end;

    local v213;

    if v212 == nil then
        v213 = false;
    else
        v213 = Serial.deltaUInt32(v212, p211.ServerTick) >= 0;
    end;

    return v213;
end;

function u1._composeWorld(p214: table, p215: number, p216: number?, p217: number?, p218: any, p219: boolean?, p220: any, p221: any) -- Line: 1349
    -- upvalues: WorldComposer (copy)
    return WorldComposer.compose(p214, p215, p216, p217, p218, p219, p220, p221);
end;

function u1._resolveSupportMotion(p222, p223, p224, p225, p226) -- Line: 1370
    -- upvalues: Enums (copy), PlayerContactAdapter (copy)
    local v227 = p226 or p222._remoteBuffer;

    if v227 ~= nil and p225.Kind == Enums.SupportKind.Player then
        return PlayerContactAdapter.resolvePlayerSupportMotion(p224, p225, v227, p223.ServerTick, assert(p222._config).StepSeconds);
    end;

    local ResolveSupportMotion = p223.Composed.ResolveSupportMotion;

    if ResolveSupportMotion == nil then
        return nil;
    end;

    return ResolveSupportMotion(p225);
end;

function u1._simulate(p228, p229, p230, p231, p232, p233, p234) -- Line: 1390
    -- upvalues: RuntimeSettings (copy), PlayerContactAdapter (copy), Simulation (copy), DeterminismTrace (copy)
    local v235 = assert(p228._config);
    local v236 = assert(p228._mapping);
    local v237 = p234 or assert(p228._remoteBuffer);
    local v238 = p228:_resolveSupportMotion(p232, p229, p230, p234);
    local MovementConfig = RuntimeSettings.getMovementConfig(v235.SimulationHz);
    local v239, v240 = PlayerContactAdapter.bindStanceProbe(v236, p232.ServerTick, v237, MovementConfig);
    local v241, v242, v243 = Simulation.step(p229, p230, p231, v235.StepSeconds, p232.Composed.Query, v238, MovementConfig, p233, v239);

    if not v236.PlayerCollisionsEnabled then
        DeterminismTrace.checkpoint(p233, "runtime.playerContacts.final", v241, v242, nil);
        p228._traceCapture:finish(p233);

        return v241, v242, v243, {}, 0, false, Vector3.new(0, 0, 0);
    end;

    local Position = v241.Position;
    local v244 = PlayerContactAdapter.solve(p229, p230, v241, v242, v243, v236, p232.ServerTick, v237, p232.Composed.Query, p232.Composed.CanOccupyAtEnd, MovementConfig, p233);

    if v240 ~= nil then
        for i in v240 do
            v244.ContactActorIds[i] = true;
            v244.NearbyPlayer = true;
        end;
    end;

    DeterminismTrace.checkpoint(p233, "runtime.playerContacts.final", v244.State, v244.Support, nil);
    p228._traceCapture:finish(p233);

    return v244.State, v244.Support, v244.Events, v244.ContactActorIds, v244.ExternalDisplacement, v244.NearbyPlayer, v244.State.Position - Position;
end;

local function predictionDependencyMask(p245: any, p246: any, p247: any, p248: any, p249: any, p250: table, p251: boolean) -- Line: 1453
    -- upvalues: Enums (copy), PredictionRing (copy)
    local v252 = 0;

    if p248.Kind == Enums.SupportKind.Player or (p249.Kind == Enums.SupportKind.Player or (next(p250) ~= nil or p251)) then
        v252 = bit32.bor(v252, PredictionRing.Dependency.Player);
    end;

    local MoverSensitiveAt = p245.Composed.MoverSensitiveAt;

    if MoverSensitiveAt ~= nil and (MoverSensitiveAt(p246.Position, p246.Stance) or MoverSensitiveAt(p247.Position, p247.Stance)) then
        v252 = bit32.bor(v252, PredictionRing.Dependency.Mover);
    end;

    return v252;
end;

function u1._rememberJumpEvent(p253: table, p254: number) -- Line: 1484
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p254) or p254 == Serial.UInt32Max then
        return false;
    end;

    if p253._seenJumpCommands[p254] then
        return false;
    end;

    p253._seenJumpCommands[p254] = true;
    local _seenJumpOrder = p253._seenJumpOrder;
    _seenJumpOrder[#_seenJumpOrder + 1] = p254;

    if #_seenJumpOrder > 64 then
        local table_remove_ret = table.remove(_seenJumpOrder, 1);

        if table_remove_ret ~= p253._lastAuthoritativeJumpCommand then
            p253._seenJumpCommands[table_remove_ret] = nil;
        end;
    end;

    return true;
end;

function u1._dispatchStepEvents(p255: table, p256: any, p257: number) -- Line: 1503
    if p256.Jumped and not p255:_rememberJumpEvent(p257) then
        p256.Jumped = false;
    end;

    local OnStepEvents = p255._options.OnStepEvents;

    if OnStepEvents ~= nil then
        OnStepEvents(p256, p255:_presentationContext());
    end;
end;

function u1._recoverAuthoritativeJump(p258, p259) -- Line: 1514
    -- upvalues: Serial (copy)
    local LastJumpCommandNumber = p259.State.LastJumpCommandNumber;

    if LastJumpCommandNumber == Serial.UInt32Max or LastJumpCommandNumber == p258._lastAuthoritativeJumpCommand then
        return;
    end;

    p258._lastAuthoritativeJumpCommand = LastJumpCommandNumber;

    if p258._seenJumpCommands[LastJumpCommandNumber] then
        return;
    end;

    p258:_dispatchStepEvents({
        Jumped = true,
        Landed = false,
        LeftGround = true,
        ImpactVelocityY = nil,
        Blocked = false,
        StartSolid = false
    }, LastJumpCommandNumber);
end;

local function simulateReplayStep(p260: any, p261: number, p262: any, p263: any, p264: any, p265: any, p266: any, p267: any) -- Line: 1534
    -- upvalues: serverTimeAtTick (copy), predictionDependencyMask (copy)
    local v268 = p260._traceCapture:begin(p261, p265.CommandNumber, p266.ServerTick);
    local v269 = serverTimeAtTick(p262, p266.ServerTick, assert(p260._config).StepSeconds);
    local v270 = p260:_stateForCommand(p260:_applyDamageTagForStep(p263), p265, v269, true);
    local v271, v272, _, v273, _, v274 = p260:_simulate(v270, p264, p265, p266, v268, p267);

    return v271, v272, predictionDependencyMask(p266, v270, v271, p264, v272, v273, v274), v273;
end;

function u1._commitSnapshotInstall(p275: table, p276: any, p277: any, p278: any, p279: boolean, p280: table) -- Line: 1556
    -- upvalues: annotateReconciliation (copy), RootFrame (copy), clone (copy), cloneSupport (copy), Serial (copy)
    local _state = p275._state;
    local _support = p275._support;
    local _lastPredictedServerTick = p275._lastPredictedServerTick;
    local _lastAcceptedOwnerSnapshot = p275._lastAcceptedOwnerSnapshot;
    p277.Metrics.PlayerContactCorrection = p279;
    annotateReconciliation(p277.Metrics, p277, p276, p278, _state, _support, _lastPredictedServerTick, _lastAcceptedOwnerSnapshot);
    p275._traceCapture:onSnapshotCommitted(p276, p278, p277.Metrics, p275._diagnostics:reportingEnabled());
    local v281 = p275:_canPredict();
    local v282 = p275._accumulatorSeconds / assert(p275._config).StepSeconds;
    local math_clamp_ret = math.clamp(v282, 0, 1);
    local v283;

    if p275._presentedState == nil or p275._previousPresentedState == nil then
        v283 = nil;
    else
        v283 = RootFrame.cframe(p275._previousPresentedState):Lerp(RootFrame.cframe(p275._presentedState), math_clamp_ret).Position;
    end;

    p275._state = p277.State;
    p275._support = p277.Support;
    local v284;

    if _state == nil then
        v284 = (1 / 0);
    else
        local math_sin_ret = math.sin(p277.State.LookYaw - _state.LookYaw);
        local math_cos_ret = math.cos(p277.State.LookYaw - _state.LookYaw);
        local math_atan2_ret = math.atan2(math_sin_ret, math_cos_ret);
        v284 = math.abs(math_atan2_ret);
    end;

    local v285 = (_state == nil or ((p277.State.Position - _state.Position).Magnitude > 0.0001 or p277.State.Stance ~= _state.Stance)) and true or v284 > 0.0001;

    if _state == nil or (p275._presentedState == nil or p275._previousPresentedState == nil) then
        p275:_refreshPresentedState();
    elseif v285 then
        local v286 = clone(p275._previousPresentedState);
        v286.Position = v286.Position + (p277.State.Position - _state.Position);
        v286.LookYaw = v286.LookYaw + (p277.State.LookYaw - _state.LookYaw);
        p275:_refreshPresentedState(v286);
    elseif p277.Metrics.ReconciliationMode ~= "Reuse" then
        p275._presentedState = clone(p277.State);
        p275._presentedSupport = cloneSupport(p277.Support);
    end;

    if v283 ~= nil then
        local Position = RootFrame.cframe(assert(p275._previousPresentedState)):Lerp(RootFrame.cframe(assert(p275._presentedState)), math_clamp_ret).Position;
        p277.Metrics.PresentationPositionDelta = Position - v283;
    end;

    p275._lastPredictedServerTick = p277.TailServerTick;
    p275._contactActorIds = p280;
    p275._lastAcceptedOwnerSnapshot = p276;
    p275:_pruneDamageTagsThrough(p276.State.MovementTick);
    local _pendingDamageTagReplayMovementTick = p275._pendingDamageTagReplayMovementTick;

    if p277.ReplayCount > 0 and (_pendingDamageTagReplayMovementTick ~= nil and Serial.deltaUInt32(p277.State.MovementTick, _pendingDamageTagReplayMovementTick) >= 0) then
        p275._pendingDamageTagReplayMovementTick = nil;
    end;

    local _pendingCommandResyncThrough = p275._pendingCommandResyncThrough;

    if _pendingCommandResyncThrough ~= nil and Serial.deltaUInt32(p276.LastProcessedCommand, _pendingCommandResyncThrough) >= 0 then
        p275._pendingCommandResyncThrough = nil;
        p275._commandResyncRequestedAt = 0;
    end;

    p275:_recoverAuthoritativeJump(p276);
    p275._lastOwnerAppliedAt = os.clock();
    p275._uplink:onOwnerApplied(p276.LastProcessedCommand);
    p275._diagnostics:recordOwnerApplied(p276, p277, p278);

    if not v281 then
        local v287 = assert(p275._config);
        p275._accumulatorSeconds = math.min(p275._accumulatorSeconds, v287.StepSeconds * 0.999999);
        p275._discardNextAdvanceDelta = true;
    end;

    p275:_setStatus("Running", nil);
    local OnReconciled = p275._options.OnReconciled;

    if OnReconciled ~= nil then
        OnReconciled(p277.Metrics, p275:_presentationContext());
    end;

    return true, nil;
end;

function u1._installSnapshot(u288: table, u289: any, p290: boolean, p291: boolean?, p292: boolean?, p293: function?, p294: number?) -- Line: 1659
    -- upvalues: OwnerRecovery (copy), OwnerReplay (copy), Serial (copy), simulateReplayStep (copy), serverTimeAtTick (copy)
    local _mapping = u288._mapping;
    local _reconciler = u288._reconciler;
    local _commandStream = u288._commandStream;

    if _mapping == nil or (u288._timeline == nil or (_reconciler == nil or _commandStream == nil)) then
        return false, "GenerationContextUnavailable";
    end;

    if u289.Generation ~= _mapping.Generation then
        return false, "GenerationMismatch";
    end;

    if u289.Topology.Epoch ~= _mapping.TopologyEpoch or u289.Topology.Fingerprint ~= _mapping.TopologyFingerprint then
        return false, "TopologyMismatch";
    end;

    if not (p290 or p291) then
        local v295, v296 = OwnerRecovery.prepare(u288, u289);

        if not v295 then
            return false, v296;
        end;
    end;

    if p291 and p294 == nil then
        _reconciler:discardReplayContinuation();
    end;

    local v297;

    if p291 then
        v297 = p294;
    else
        v297 = nil;
    end;

    local v298 = OwnerReplay.checkWorld(u288, u289, v297);

    if v298 ~= nil then
        return false, v298;
    end;

    if p290 then
        if u289.LastProcessedCommand ~= Serial.UInt32Max then
            u288:_sendMappingRequest(_mapping.Generation);

            return false, "InitialDiscontinuityDoesNotPrecedeCommandZero";
        end;

        _commandStream:reset(_mapping);
        _reconciler:reset(_mapping);
    end;

    local v299;

    if u288._predictionRing then
        v299 = u288._predictionRing:get(u289.LastProcessedCommand) or nil;
    else
        v299 = nil;
    end;

    local v300 = u288:_playerContactNearStateAtTick(u289.State, u289.ServerTick);

    if not v300 then
        if v299 == nil then
            v300 = false;
        else
            v300 = u288:_playerContactNearStateAtTick(v299.PostState, u289.ServerTick);
        end;
    end;

    local u301 = {};
    local u302 = nil;
    local u303 = nil;
    local v304 = {
        WorkSeconds = 0,
        SliceCount = 0,
        MaximumSliceSeconds = 0,
        StartedAt = os.clock()
    };
    local StartedAt = v304.StartedAt;
    debug.profilebegin("MovementV2.Client.ReconciliationReplay");
    local v324, v325 = _reconciler:accept(u289, function(p305, p306, p307) -- Line: 1716
        -- upvalues: u302 (ref), _mapping (copy), u288 (copy), u303 (ref)
        if u302 == nil and (_mapping.PlayerCollisionsEnabled or u288._collisionComposer ~= nil) then
            u302 = assert(u288._remoteBuffer):captureCollisionFrame();
        end;

        local _collisionComposer = u288._collisionComposer;

        if u303 == nil and (_collisionComposer ~= nil and type(_collisionComposer.ForkPrediction) == "function") then
            u303 = _collisionComposer:ForkPrediction();
        end;

        local v308, v309 = u288:_composeWorld(p305, nil, nil, p307, nil, u302, u303);

        if v308 == nil then
            return nil, nil, v309;
        end;

        return v308, v308.Destructibles.Revision, nil;
    end, function(p310, p311, p312, p313, p314, p315, p316) -- Line: 1732
        -- upvalues: simulateReplayStep (ref), u288 (copy), _mapping (copy), u289 (copy), u302 (ref), u301 (ref)
        local v317, v318, v319, v320 = simulateReplayStep(u288, _mapping.Generation, u289, p310, p311, p312, p316, u302);
        u301 = v320;

        return v317, v318, v319;
    end, p291, v300, u288._reconciliationReplayBudget, p292, p294, function(p321, p322, p323) -- Line: 1751
        -- upvalues: serverTimeAtTick (ref), u289 (copy), u288 (copy)
        return u288:_stateForCommand(p321, p322, serverTimeAtTick(u289, p323, assert(u288._config).StepSeconds), true) == p321;
    end);
    debug.profileend();
    local v326 = os.clock() - StartedAt;
    local math_max_ret = math.max(v326, 0);
    v304.WorkSeconds = v304.WorkSeconds + math_max_ret;
    v304.SliceCount = v304.SliceCount + 1;
    v304.MaximumSliceSeconds = math.max(v304.MaximumSliceSeconds, math_max_ret);

    if v324 == nil then
        if v325 == "ReplayPending" then
            u288._pendingReconciliationInstall = {
                MoverRevisionToValidate = nil,
                Snapshot = u289,
                PredictedAtAck = v299,
                PlayerContactAtAck = v300,
                Timing = v304,
                CollisionFrame = u302,
                CollisionComposer = u303,
                FreshCollisionFrames = {}
            };

            if p293 ~= nil then
                p293();
            end;
        end;

        return false, v325;
    end;

    if u303 ~= nil then
        u288._collisionComposer:CommitPrediction(u303);
    end;

    if p293 ~= nil then
        p293();
    end;

    local Metrics = v324.Metrics;
    Metrics.ReconciliationWorkSeconds = v304.WorkSeconds;
    local v327 = os.clock() - v304.StartedAt;
    Metrics.ReconciliationElapsedSeconds = math.max(v327, v304.WorkSeconds);
    Metrics.ReconciliationSliceCount = v304.SliceCount;
    Metrics.ReconciliationMaximumSliceSeconds = v304.MaximumSliceSeconds;

    return u288:_commitSnapshotInstall(u289, v324, v299, v300, u301);
end;

function u1._resumePendingReconciliation(u328) -- Line: 1786
    -- upvalues: OwnerReplay (copy), simulateReplayStep (copy), Serial (copy)
    local v329, v330, v331 = OwnerReplay.tryAdvance(u328);

    if v329 then
        return v330 == true, v331;
    end;

    local _pendingReconciliationInstall = u328._pendingReconciliationInstall;
    local _reconciler = u328._reconciler;
    local _mapping = u328._mapping;

    if _pendingReconciliationInstall == nil or (_reconciler == nil or _mapping == nil) then
        return false, "ReconciliationReplayUnavailable";
    end;

    if _pendingReconciliationInstall.Snapshot.Generation ~= _mapping.Generation then
        _reconciler:cancelPendingReplay();
        u328._pendingReconciliationInstall = nil;

        return false, "GenerationMismatch";
    end;

    local u332 = {};
    local os_clock_ret = os.clock();
    debug.profilebegin("MovementV2.Client.ReconciliationReplay");
    local v351, v352 = _reconciler:resume(function(p333, p334, p335, p336, p337) -- Line: 1806
        -- upvalues: _pendingReconciliationInstall (copy), u328 (copy)
        local v338, v339 = u328:_composeWorld(p333, nil, nil, p335, nil, _pendingReconciliationInstall.FreshCollisionFrames[p337] or _pendingReconciliationInstall.CollisionFrame, _pendingReconciliationInstall.CollisionComposer);

        if v338 == nil then
            return nil, nil, v339;
        end;

        return v338, v338.Destructibles.Revision, nil;
    end, function(p340, p341, p342, p343, p344, p345, p346) -- Line: 1814
        -- upvalues: simulateReplayStep (ref), u328 (copy), _mapping (copy), _pendingReconciliationInstall (copy), u332 (ref)
        local v347, v348, v349, v350 = simulateReplayStep(u328, _mapping.Generation, _pendingReconciliationInstall.Snapshot, p340, p341, p342, p346, _pendingReconciliationInstall.FreshCollisionFrames[p342.CommandNumber] or _pendingReconciliationInstall.CollisionFrame);
        u332 = v350;

        return v347, v348, v349;
    end, u328._reconciliationReplayBudget);
    debug.profileend();
    local Timing = _pendingReconciliationInstall.Timing;
    local v353 = os.clock() - os_clock_ret;
    local math_max_ret = math.max(v353, 0);
    Timing.WorkSeconds = Timing.WorkSeconds + math_max_ret;
    Timing.SliceCount = Timing.SliceCount + 1;
    Timing.MaximumSliceSeconds = math.max(Timing.MaximumSliceSeconds, math_max_ret);

    if v351 == nil then
        if v352 == "ReplayPending" then
            local v354 = _reconciler:retiredReplayCommandNumber();

            if v354 ~= nil and v354 ~= _pendingReconciliationInstall.CollisionFramesRetiredThrough then
                for i in _pendingReconciliationInstall.FreshCollisionFrames do
                    if Serial.deltaUInt32(i, v354) <= 0 then
                        _pendingReconciliationInstall.FreshCollisionFrames[i] = nil;
                    end;
                end;

                _pendingReconciliationInstall.CollisionFramesRetiredThrough = v354;
            end;

            return false, v352;
        end;

        _reconciler:cancelPendingReplay();
        u328._pendingReconciliationInstall = nil;

        return false, v352;
    end;

    u328._pendingReconciliationInstall = nil;

    if _pendingReconciliationInstall.CollisionComposer ~= nil then
        u328._collisionComposer:CommitPrediction(_pendingReconciliationInstall.CollisionComposer);
    end;

    local Metrics = v351.Metrics;
    local Timing2 = _pendingReconciliationInstall.Timing;
    Metrics.ReconciliationWorkSeconds = Timing2.WorkSeconds;
    local v355 = os.clock() - Timing2.StartedAt;
    Metrics.ReconciliationElapsedSeconds = math.max(v355, Timing2.WorkSeconds);
    Metrics.ReconciliationSliceCount = Timing2.SliceCount;
    Metrics.ReconciliationMaximumSliceSeconds = Timing2.MaximumSliceSeconds;
    local v356, v357 = u328:_commitSnapshotInstall(_pendingReconciliationInstall.Snapshot, v351, _pendingReconciliationInstall.PredictedAtAck, _pendingReconciliationInstall.PlayerContactAtAck, u332);

    if v356 and u328._pendingDiscontinuity == _pendingReconciliationInstall.Snapshot then
        u328._pendingDiscontinuity = nil;
    end;

    if v356 and _pendingReconciliationInstall.MoverRevisionToValidate ~= nil then
        u328:_markMoverRevisionValidated(_pendingReconciliationInstall.MoverRevisionToValidate);
    end;

    return v356, v357;
end;

function u1._tryInstallDiscontinuity(p358) -- Line: 1869
    if p358._pendingReconciliationInstall ~= nil then
        return;
    end;

    local _pendingDiscontinuity = p358._pendingDiscontinuity;

    if _pendingDiscontinuity == nil then
        if p358._state == nil and (p358._timeline ~= nil and not p358._timeline:needsBaseline()) then
            p358:_setStatus("WaitingForState", "ReliableDiscontinuityUnavailable");
        end;

        return;
    end;

    local v359, v360 = p358:_installSnapshot(_pendingDiscontinuity, p358._state == nil);

    if v359 then
        p358._pendingDiscontinuity = nil;
        p358:_installOwnerSnapshotAfterControls();

        return;
    end;

    if v360 == "SnapshotNotNewer" then
        p358._pendingDiscontinuity = nil;

        return;
    end;

    if v360 == "ReplayPending" then
        return;
    end;

    if v360 ~= "CommandLeadResync" and (v360 ~= "BaselineRequired" and (v360 ~= "DestructibleFrameOutsideRetention" and (v360 ~= "DestructibleRevisionMismatch" and (v360 ~= "MoverBaselineRequired" and (v360 ~= "MoverRevisionUnavailable" and (v360 ~= "MoverFrameOutsideRetention" and v360 ~= "GenerationContextUnavailable")))))) then
        p358:_warn((`could not install reliable discontinuity: {v360}`));
    end;
end;

function u1._handleOwnerSnapshot(p361: table, p362: any, p363: boolean?) -- Line: 1902
    -- upvalues: OwnerCommandFeedback (copy)
    local _mapping = p361._mapping;

    if _mapping == nil or p362.Generation ~= _mapping.Generation then
        p361:_sendMappingRequest(p362.Generation);

        return false;
    end;

    OwnerCommandFeedback.observe(p361, p362, os.clock());

    if p361._pendingReconciliationInstall ~= nil then
        p361:_queueOwnerSnapshot(p362);

        return false;
    end;

    if p361._state == nil then
        p361._pendingOwnerSnapshot = p362;
        p361:_sendMappingRequest(p362.Generation);

        return false;
    end;

    local v364, v365 = p361:_installSnapshot(p362, false, nil, p363);

    if v364 then
        return true;
    end;

    if v365 == "SnapshotNotNewer" or (v365 == "CommandLeadResync" or (v365 == "DestructibleFrameOutsideRetention" or v365 == "ReplayPending")) then
        return false;
    end;

    if v365 == "BaselineRequired" then
        p361._pendingOwnerSnapshot = p362;
        p361:_setStatus("WaitingForBaseline", v365);
    elseif v365 == "DestructibleRevisionMismatch" then
        p361._pendingOwnerSnapshot = p362;
        p361:_setStatus("WaitingForAuthority", "AwaitingDestructibleDelta");
    elseif v365 == "MoverBaselineRequired" or v365 == "MoverRevisionUnavailable" then
        p361._pendingOwnerSnapshot = p362;
        p361:_setStatus("WaitingForAuthority", "AwaitingMoverDescriptor");
    elseif v365 == "MoverFrameOutsideRetention" then
        p361:_sendMappingRequest(_mapping.Generation);
    else
        p361:_warn((`rejected owner snapshot: {v365}`));
    end;

    return false;
end;

function u1._queueOwnerSnapshot(p366, p367) -- Line: 1948
    -- upvalues: OwnerCommandFeedback (copy), OwnerRecovery (copy), Serial (copy)
    OwnerCommandFeedback.observe(p366, p367, os.clock());
    OwnerRecovery.observe(p366, p367);
    local _pendingOwnerSnapshot = p366._pendingOwnerSnapshot;

    if _pendingOwnerSnapshot == nil or (_pendingOwnerSnapshot.Generation ~= p367.Generation or Serial.isNewerUInt32(p367.Sequence, _pendingOwnerSnapshot.Sequence)) then
        p366._pendingOwnerSnapshot = p367;
    end;
end;

function u1._ensureObserverRemoteStreams(p368, p369) -- Line: 1962
    -- upvalues: Config (copy), Mapping (copy)
    if p368._mapping ~= nil then
        return false;
    end;

    local _observerMapping = p368._observerMapping;
    local _remoteBuffer = p368._remoteBuffer;

    if _observerMapping ~= nil and (_remoteBuffer ~= nil and (p368._remoteClock ~= nil and (_remoteBuffer:sharesStream(_observerMapping) and (_observerMapping.TopologyEpoch == p369.Topology.Epoch and _observerMapping.TopologyFingerprint == p369.Topology.Fingerprint)))) then
        return true;
    end;

    local v370 = {
        Generation = 65535,
        ActorId = 4294967295,
        PlayerCollisionsEnabled = false,
        SimulationHz = Config.DefaultSimulationHz,
        TopologyEpoch = p369.Topology.Epoch,
        TopologyFingerprint = p369.Topology.Fingerprint
    };
    local v371, v372 = Mapping.validate(v370);

    if not v371 then
        p368:_warn((`could not derive observer remote mapping: {v372}`));

        return false;
    end;

    p368._observerMapping = table.freeze(v370);
    p368:_ensureRemoteStreams(v370, true);

    return true;
end;

function u1._ensureRemoteStreams(p373: table, p374: any, p375: boolean) -- Line: 2000
    -- upvalues: Players (copy), RemoteBuffer (copy), RemoteClock (copy), Config (copy)
    local _remoteBuffer = p373._remoteBuffer;
    local _remoteClock = p373._remoteClock;

    if _remoteBuffer == nil or (_remoteClock == nil or not _remoteBuffer:sharesStream(p374)) then
        p373._remoteBuffer = RemoteBuffer.new(p374);
        p373._remoteClock = RemoteClock.new(Config.derive(p374.SimulationHz), p375);

        return;
    end;

    _remoteBuffer:forgetActor(Players.LocalPlayer.UserId);
    _remoteClock:setSpectator(p375);
end;

function u1._applyRemoteSnapshot(p376, p377) -- Line: 2012
    local _mapping = p376._mapping;
    local _remoteBuffer = p376._remoteBuffer;

    if _mapping == nil then
        if not p376:_ensureObserverRemoteStreams(p377) then
            return;
        end;

        local v378 = assert(p376._remoteBuffer);
        local _, v379 = v378:pushDecoded(p377);
        local v380 = v378:latestServerTick();

        if v379 == nil and v380 ~= nil then
            local _remoteClock = p376._remoteClock;

            if _remoteClock ~= nil then
                _remoteClock:observe(v380, os.clock());
            end;
        end;

        return;
    end;

    if _remoteBuffer == nil or not (_remoteBuffer:sharesStream(_mapping) and (p377.Topology.Epoch == _mapping.TopologyEpoch and p377.Topology.Fingerprint == _mapping.TopologyFingerprint)) then
        return;
    end;

    local _, v381 = _remoteBuffer:pushDecoded(p377);

    if v381 == nil then
        local _remoteClock = p376._remoteClock;
        local v382 = _remoteBuffer:latestServerTick();

        if _remoteClock ~= nil and v382 ~= nil then
            _remoteClock:observe(v382, os.clock());
        end;
    end;

    if v381 == "RemoteBaselineRequired" then
        p376._diagnostics:recordRemoteRejected(v381);

        return;
    end;

    if v381 ~= nil and (v381 ~= "DuplicateRemoteChunk" and (v381 ~= "RemoteSnapshotTooOld" and v381 ~= "RemoteDeltaHeld")) then
        p376._diagnostics:recordRemoteRejected(v381);
        p376:_warn((`rejected remote snapshot: {v381}`));
    end;
end;

function u1._handleRemoteSnapshot(p383, p384) -- Line: 2062
    -- upvalues: RemoteSnapshotCodec (copy)
    local v385 = RemoteSnapshotCodec.decode(p384);

    if v385 == nil then
        return;
    end;

    p383._diagnostics:recordRemoteSnapshot(v385.Sequence);
    local _mapping = p383._mapping;

    if _mapping ~= nil then
        local OnRemoteSnapshotReceived = p383._options.OnRemoteSnapshotReceived;

        if OnRemoteSnapshotReceived ~= nil then
            OnRemoteSnapshotReceived(_mapping.Generation, v385.Sequence, {
                Bytes = buffer.len(p384),
                Kind = v385.Kind,
                FullActorCount = #v385.Actors,
                DeltaActorCount = #v385.Deltas,
                RemovedActorCount = #v385.RemovedActorIds,
                ChunkCount = v385.ChunkCount
            });
        end;
    end;

    p383:_applyRemoteSnapshot(v385);
end;

function u1._handleControl(p386, p387) -- Line: 2085
    -- upvalues: ControlCodec (copy), ActionLockReplay (copy), OwnerRecovery (copy)
    local v388, v389 = ControlCodec.decode(p387);

    if v388 == nil then
        p386:_warn((`rejected movement control: {v389}`));

        return;
    end;

    if v388.Kind == "Mapping" then
        p386:_applyMapping(v388.Mapping);

        return;
    end;

    if v388.Kind == "GenerationUnbound" then
        p386:retireGeneration(v388.Generation);

        return;
    end;

    if v388.Kind == "DamageTag" then
        p386:_queueDamageTag(v388);

        return;
    end;

    if v388.Kind == "ActionLocks" then
        ActionLockReplay.queue(p386, v388);

        return;
    end;

    local v390 = p386._pendingReconciliationInstall ~= nil;
    local v391 = v390 or (p386._pendingMoverBaseline ~= nil and true or #p386._pendingMoverDeltas > 0);

    if v388.Kind ~= "Discontinuity" then
        if v388.Kind == "DestructibleBaseline" then
            p386._pendingBaseline = {
                ServerTick = v388.ServerTick,
                Frame = v388.Frame
            };
            p386:_drainPendingCollisionControls();

            return;
        end;

        if v388.Kind == "DestructibleDelta" then
            local v392 = {
                Epoch = v388.Epoch,
                Revision = v388.Revision,
                ServerTick = v388.ServerTick,
                Indices = v388.Indices
            };

            if v390 or (p386._pendingBaseline ~= nil or #p386._pendingDeltas > 0) then
                p386:_deferDestructibleDelta(v392, v388.Revision);

                return;
            end;

            p386:_applyDelta(v392);

            return;
        end;

        if v388.Kind ~= "MoverBaseline" then
            if v388.Kind == "MoverDelta" or v388.Kind == "MoverProgress" then
                if v391 then
                    p386:_deferMoverDelta(v388);

                    return;
                end;

                p386:_applyMoverDelta(v388);
            end;

            return;
        end;

        if v391 then
            p386._pendingMoverBaseline = v388;

            return;
        end;

        p386:_applyMoverBaseline(v388);

        return;
    end;

    local _mapping = p386._mapping;
    local OnOwnerSnapshotReceived = p386._options.OnOwnerSnapshotReceived;

    if OnOwnerSnapshotReceived ~= nil and (_mapping ~= nil and v388.Snapshot.Generation == _mapping.Generation) then
        OnOwnerSnapshotReceived(v388.Snapshot.Generation, v388.Snapshot.Sequence, {
            Kind = "Discontinuity",
            Bytes = buffer.len(p387)
        });
    end;

    if _mapping == nil or v388.Snapshot.Generation ~= _mapping.Generation then
        p386._pendingDiscontinuity = v388.Snapshot;
        p386:_sendMappingRequest(v388.Snapshot.Generation);

        return;
    end;

    OwnerRecovery.observe(p386, v388.Snapshot);
    p386._pendingDiscontinuity = v388.Snapshot;
    p386:_tryInstallDiscontinuity();
end;

function u1._sendDueCommands(p393: table, p394: boolean?) -- Line: 2170
    p393._uplink:sendDue(p393._commandStream, p393._config, p393._channels, p394);
end;

function u1._sendRecoveryCommands(p395: table, p396: number) -- Line: 2174
    if p395._pendingCommandResyncThrough ~= nil then
        return;
    end;

    p395._uplink:sendRecovery(p395._commandStream, p395._config, p395._channels, p396);
end;

function u1._recoverStalledCommands(p397) -- Line: 2182
    -- upvalues: OwnerCommandFeedback (copy)
    local _pendingReconciliationInstall = p397._pendingReconciliationInstall;
    local v398;

    if _pendingReconciliationInstall then
        v398 = _pendingReconciliationInstall.Snapshot;
    else
        v398 = nil;
    end;

    local v399 = OwnerCommandFeedback.choose(p397._lastAcceptedOwnerSnapshot, p397._pendingOwnerSnapshot, v398);
    p397._uplink:recoverStalled(v399, p397._commandStream, p397._config, p397._channels, p397._lastOwnerAppliedAt, p397._pendingCommandResyncThrough ~= nil);
end;

function u1._buildCommandInput(p400: table, p401: any, p402: any, p403: number, p404: number, p405: any) -- Line: 2200
    -- upvalues: Enums (copy), Serial (copy), Config2 (copy)
    local ResolveScopedState = p400._options.ResolveScopedState;
    local v406;

    if ResolveScopedState == nil then
        v406 = p401;
    else
        v406 = table.clone(p401);
        v406.Buttons = Enums.Buttons.with(p401.Buttons, Enums.Buttons.Scoped, ResolveScopedState());
    end;

    local ConsumePendingWeaponSelection = p400._options.ConsumePendingWeaponSelection;
    local v407, v408;

    if ConsumePendingWeaponSelection == nil then
        v407 = nil;
        v408 = false;
    else
        v407 = ConsumePendingWeaponSelection();

        if v407 == nil then
            v408 = false;
        else
            v408 = true;
        end;
    end;

    if v407 == nil then
        local GetUnresolvedWeaponSelection = p400._options.GetUnresolvedWeaponSelection;
        local _lastWeaponSelectionCommand = p400._lastWeaponSelectionCommand;

        if GetUnresolvedWeaponSelection ~= nil and (_lastWeaponSelectionCommand == nil or Serial.deltaUInt32(p403, _lastWeaponSelectionCommand) >= p405.CommandPacketEveryTicks) then
            v407 = GetUnresolvedWeaponSelection();
        end;
    end;

    local WeaponMoveSpeed = p402.WeaponMoveSpeed;
    local WeaponScopedMoveSpeed = p402.WeaponScopedMoveSpeed;

    if v407 ~= nil then
        if v406 == p401 then
            v406 = table.clone(p401);
        end;

        v406.WeaponSelectRequestId = v407.RequestId;
        v406.WeaponSelectIdentifier = v407.Identifier;
        v406.GrenadeThrowIdentifier = v407.GrenadeThrowIdentifier;
        v406.GrenadeThrowAnimation = v407.GrenadeThrowAnimation;
        local ResolveWeaponSpeedProfile = p400._options.ResolveWeaponSpeedProfile;

        if ResolveWeaponSpeedProfile ~= nil then
            local v409, v410 = ResolveWeaponSpeedProfile(v407);
            local v411;

            if type(v409) == "number" and v409 == v409 then
                v411 = math.abs(v409) < (1 / 0);
            else
                v411 = false;
            end;

            if v411 then
                local v412;

                if type(v410) == "number" and v410 == v410 then
                    v412 = math.abs(v410) < (1 / 0);
                else
                    v412 = false;
                end;

                if v412 then
                    WeaponMoveSpeed = math.clamp(v409, 0, Config2.Default.MaxBaseMoveSpeed);
                    WeaponScopedMoveSpeed = math.clamp(v410, 0, Config2.Default.MaxBaseMoveSpeed);
                    v406.PredictedWeaponMoveSpeed = WeaponMoveSpeed;
                    v406.PredictedWeaponScopedMoveSpeed = WeaponScopedMoveSpeed;
                end;
            end;
        end;
    end;

    local ResolveBaseMoveSpeed = p400._options.ResolveBaseMoveSpeed;

    if ResolveBaseMoveSpeed ~= nil then
        local v413 = ResolveBaseMoveSpeed(p402.BaseMoveSpeed, p404, WeaponMoveSpeed, WeaponScopedMoveSpeed, Enums.Buttons.has(v406.Buttons, Enums.Buttons.Scoped));
        local v414;

        if type(v413) == "number" and v413 == v413 then
            v414 = math.abs(v413) < (1 / 0);
        else
            v414 = false;
        end;

        if v414 then
            if v406 == p401 then
                v406 = table.clone(p401);
            end;

            v406.PredictedBaseMoveSpeed = math.clamp(v413, 0, Config2.Default.MaxBaseMoveSpeed);
        end;
    end;

    return v406, v407, v408;
end;

function u1._stepPrediction(p415: table, p416: number) -- Line: 2277
    -- upvalues: Serial (copy), serverTimeAtTick (copy), predictionDependencyMask (copy), PlayerContacts (copy), PredictionErrorSmoother (copy)
    if not p415:_canPredict() then
        return false, p415._reason or p415._status;
    end;

    local v417 = assert(p415._mapping);
    local v418 = assert(p415._commandStream);
    local v419 = assert(p415._predictionRing);
    local v420 = assert(p415._state);
    local v421 = assert(p415._support);
    local v422 = assert(p415._config);

    if v419:isFull() and os.clock() - p415._lastHistoryRecoveryRequestAt >= 1 then
        p415._lastHistoryRecoveryRequestAt = os.clock();
        p415:_sendMappingRequest(v417.Generation);
    end;

    local v423 = v418:lastSampledCommandNumber();
    local v424 = v423 == nil and 0 or Serial.addUInt32(v423, 1);
    local _lastPredictedServerTick = p415._lastPredictedServerTick;

    if _lastPredictedServerTick == nil then
        return false, "AuthoritativeTickUnavailable";
    end;

    local v425 = Serial.addUInt32(_lastPredictedServerTick, 1);
    local _lastAcceptedOwnerSnapshot = p415._lastAcceptedOwnerSnapshot;

    if _lastAcceptedOwnerSnapshot == nil then
        return false, "AuthoritativeTimeUnavailable";
    end;

    local v426 = serverTimeAtTick(_lastAcceptedOwnerSnapshot, v425, v422.StepSeconds);
    local v427, v428 = assert(p415._timeline):predict(v425);

    if v427 == nil then
        return false, v428;
    end;

    debug.profilebegin("MovementV2.Client.ComposeWorld");
    local v429, v430 = p415:_composeWorld(v425, v427.Revision, nil, v420, true);
    debug.profileend();

    if v429 == nil then
        return false, v430;
    end;

    local v431 = p415._options.SampleInput({
        Mapping = v417,
        ServerTick = v425,
        ScheduledServerTime = v426,
        StepSeconds = v422.StepSeconds,
        FrameSampleAlpha = p416,
        State = assert(p415._presentedState),
        Support = assert(p415._presentedSupport)
    });

    if v431 == nil then
        return false, "InputUnavailable";
    end;

    local v432, v433, v434 = p415:_buildCommandInput(v431, v420, v424, v426, v422);
    local v435, v436 = v418:sample(v432);

    if v435 == nil then
        if v434 and v433 ~= nil then
            local RestorePendingWeaponSelection = p415._options.RestorePendingWeaponSelection;

            if RestorePendingWeaponSelection ~= nil then
                RestorePendingWeaponSelection(v433);
            end;
        end;

        return false, `InputRejected:{v436 or "Unknown"}`;
    end;

    if v433 ~= nil then
        p415._lastWeaponSelectionCommand = v435.CommandNumber;
    end;

    if v435.CommandNumber ~= v424 then
        return false, "SampledCommandOrderMismatch";
    end;

    local v437 = p415._traceCapture:begin(v417.Generation, v435.CommandNumber, v425);
    local v438 = p415:_stateForCommand(p415:_applyDamageTagForStep(v420), v435, v426, false);
    local _pendingReconciliationInstall = p415._pendingReconciliationInstall;

    if _pendingReconciliationInstall ~= nil and (v417.PlayerCollisionsEnabled or p415._collisionComposer ~= nil) then
        _pendingReconciliationInstall.FreshCollisionFrames[v435.CommandNumber] = assert(p415._remoteBuffer):captureCollisionFrame();
    end;

    local v439, v440, v441, v442, v443, v444, v445 = p415:_simulate(v438, v421, v435, v429, v437);
    p415._traceCapture:observePredictedStep(v417.Generation, v435, v425, v438, v421, v439, v440, v441);
    assert(p415._reconciler):retainReplayPrefixBeforePush(v435.CommandNumber);
    local v446, v447 = v419:push(v435, v425, v439, v440, v427.Revision, true, (predictionDependencyMask(v429, v438, v439, v421, v440, v442, v444)));

    if not v446 then
        return false, v447;
    end;

    if v435.GrenadeThrowIdentifier ~= nil then
        p415:_sendGrenadeTransitionRequest(v435);
    end;

    p415._state = v439;
    p415._support = v440;
    p415:_refreshPresentedState(v420);
    p415._lastPredictedServerTick = v425;
    p415._contactActorIds = v442;

    if PlayerContacts.DefaultContactEpsilon < v443 then
        local OnPlayerContactCorrection = p415._options.OnPlayerContactCorrection;

        if OnPlayerContactCorrection ~= nil then
            if PredictionErrorSmoother.ContactMinDistance < v443 then
                local v448 = assert(p415._previousPresentedState);
                v448.Position = v448.Position + v445;
            end;

            OnPlayerContactCorrection(v443, p415:_presentationContext(), v445);
        end;
    end;

    p415:_dispatchStepEvents(v441, v435.CommandNumber);
    p415._diagnostics:recordPredictedStep(v435, v425, p416, v438, v439, v440, v441);

    return true, nil;
end;

function u1._present(p449) -- Line: 2418
    -- upvalues: Players (copy), Enums (copy), withinPlayerContactMargin (copy)
    local _presentationContextScratch = p449._presentationContextScratch;
    local v450, v451 = p449:_presentationClock();
    _presentationContextScratch.Mapping = p449._mapping;
    _presentationContextScratch.ServerTick = v450;
    _presentationContextScratch.TickFraction = v451;
    _presentationContextScratch.LocalPlayerContactCritical = p449:_localPlayerContactCritical();
    _presentationContextScratch.Status = p449._status;
    _presentationContextScratch.Reason = p449._reason;
    local _state = p449._state;
    local _support = p449._support;
    local PresentRemotes = p449._options.PresentRemotes;
    local _remoteBuffer = p449._remoteBuffer;
    local _mapping = p449._mapping;
    local v452;

    if _mapping == nil then
        v452 = false;
    else
        v452 = _mapping.PlayerCollisionsEnabled;
    end;

    local _remotePresentations = p449._remotePresentations;
    local _remotePresentationPool = p449._remotePresentationPool;
    local v453 = 0;
    local v454 = 0;
    local v455 = 0;
    local UserId = Players.LocalPlayer.UserId;
    table.clear(_remotePresentations);

    if _remoteBuffer ~= nil and _presentationContextScratch.ServerTick ~= nil then
        for _, v in _remoteBuffer:actorKeys() do
            local PresentationPoses, v456 = _remoteBuffer:getPresentationPoses(v, _presentationContextScratch.ServerTick, _presentationContextScratch.TickFraction);

            if PresentRemotes == nil then
                PresentationPoses = nil;
            end;

            if v ~= UserId and PresentRemotes ~= nil then
                v453 = v453 + 1;

                if PresentationPoses == nil then
                    if v456 == nil then
                        v455 = v455 + 1;
                    else
                        v454 = v454 + 1;
                    end;
                end;
            end;

            local v457 = v456 or PresentationPoses;

            if v457 ~= nil and (_mapping == nil or v457.ActorId ~= _mapping.ActorId) then
                local v458;

                if v456 == nil then
                    v458 = false;
                elseif v452 then
                    if p449._contactActorIds[v457.ActorId] == true or _support ~= nil and (_support.Kind == Enums.SupportKind.Player and _support.SourceId == v457.ActorId) then
                        v458 = true;
                    elseif _state == nil then
                        v458 = false;
                    else
                        v458 = withinPlayerContactMargin(_state, v456);
                    end;
                else
                    v458 = v452;
                end;

                _presentationContextScratch.LocalPlayerContactCritical = _presentationContextScratch.LocalPlayerContactCritical or v458;

                if PresentRemotes ~= nil then
                    local v459 = #_remotePresentations + 1;
                    local v460 = _remotePresentationPool[v459];

                    if v460 == nil then
                        v460 = {
                            UserId = v457.UserId,
                            ActorId = v457.ActorId,
                            Generation = v457.Generation,
                            RenderPose = PresentationPoses
                        };
                        _remotePresentationPool[v459] = v460;
                    else
                        v460.UserId = v457.UserId;
                        v460.ActorId = v457.ActorId;
                        v460.Generation = v457.Generation;
                        v460.RenderPose = PresentationPoses;
                    end;

                    _remotePresentations[v459] = v460;
                end;
            end;
        end;
    end;

    p449._diagnostics:recordRemotePresentation(v453, v454, v455, v454 + v455 > 0);
    local PresentLocal = p449._options.PresentLocal;

    if PresentLocal ~= nil and (p449._presentedState ~= nil and p449._presentedSupport ~= nil) then
        local v461, v462 = p449:_localClockAnchor();
        local _localPresentationContextScratch = p449._localPresentationContextScratch;
        _localPresentationContextScratch.Mapping = _presentationContextScratch.Mapping;
        _localPresentationContextScratch.ServerTick = v461;
        _localPresentationContextScratch.TickFraction = v462;
        _localPresentationContextScratch.LocalPlayerContactCritical = _presentationContextScratch.LocalPlayerContactCritical;
        _localPresentationContextScratch.Status = _presentationContextScratch.Status;
        _localPresentationContextScratch.Reason = _presentationContextScratch.Reason;
        PresentLocal(p449._presentedState, p449._presentedSupport, _localPresentationContextScratch, p449._previousPresentedState or p449._presentedState);
    end;

    if PresentRemotes ~= nil then
        debug.profilebegin("MovementV2.Client.PresentRemotes");
        PresentRemotes(_remotePresentations, _presentationContextScratch);
        debug.profileend();
    end;
end;

function u1._updateReplayBudget(p463: table, p464: number) -- Line: 2527
    local _config = p463._config;
    local v465;

    if _config == nil then
        v465 = 1;
    else
        local v466 = math.min(p464, _config.MaxPredictionFrameTicks * _config.StepSeconds) / _config.StepSeconds * 1.1;
        v465 = math.ceil(v466);
    end;

    local v467;

    if _config == nil then
        v467 = 16;
    else
        local v468 = math.ceil(_config.MaxPredictionFrameTicks * 1.1) + 2;
        v467 = math.max(16, v468);
    end;

    p463._reconciliationReplayBudget.MaximumSteps = v467;
    p463._reconciliationReplayBudget.MinimumSteps = math.min(v467, v465 + 2);
end;

function u1._advanceReplayAndControls(p469) -- Line: 2544
    -- upvalues: ActionLockReplay (copy)
    local v470 = p469._pendingReconciliationInstall ~= nil;

    if v470 then
        local _, v471 = p469:_resumePendingReconciliation();

        if v471 ~= nil and (v471 ~= "ReplayPending" and v471 ~= "ReplayEventOutsideRetention") then
            p469:_warn((`could not resume reconciliation replay: {v471}`));
            local _mapping = p469._mapping;

            if _mapping ~= nil then
                p469:_sendMappingRequest(_mapping.Generation);
            end;
        end;
    end;

    if p469._pendingReconciliationInstall == nil and not v470 then
        p469:_drainPendingCollisionControls();
        p469:_flushPendingMoverReplay();
        p469:_flushPendingDamageTagReplay();
        ActionLockReplay.flush(p469);
    end;

    return v470;
end;

function u1._installQueuedOwnerSnapshot(p472: table, p473: boolean) -- Line: 2572
    local _pendingOwnerSnapshot = p472._pendingOwnerSnapshot;
    local v474;

    if p472._status == "WaitingForBaseline" then
        v474 = true;
    elseif p472._status == "WaitingForAuthority" and p472._reason ~= nil then
        v474 = string.sub(p472._reason, 1, 7) == "Awaiting";
    else
        v474 = false;
    end;

    if _pendingOwnerSnapshot ~= nil and (p472._pendingReconciliationInstall == nil and not (p473 or (v474 or not p472:_remoteContactFrameReady(_pendingOwnerSnapshot)))) then
        p472._pendingOwnerSnapshot = nil;
        p472:_handleOwnerSnapshot(_pendingOwnerSnapshot);
    end;
end;

function u1._enterPredictionFailureStatus(p475: table, p476: string?) -- Line: 2593
    if p476 == "InputUnavailable" or p476 ~= nil and string.sub(p476, 1, 14) == "InputRejected:" then
        p475._accumulatorSeconds = 0;
        p475:_setStatus("WaitingForInput", p476);
    elseif p476 == "BaselineRequired" or (p476 == "DestructibleRevisionMismatch" or p476 == "DestructibleFrameOutsideRetention") then
        p475:_setStatus("WaitingForBaseline", p476);
    else
        p475:_setStatus("WaitingForAuthority", p476);
    end;

    p475._statusFromPredictionFailure = true;
end;

function u1._drainPrediction(p477: table, p478: number, p479: boolean) -- Line: 2610
    -- upvalues: PredictionPacing (copy)
    local _config = p477._config;

    if not p477:_canPredict() or _config == nil then
        return;
    end;

    local _accumulatorSeconds = p477._accumulatorSeconds;
    local _commandClock = p477._commandClock;
    local v480 = _commandClock == nil and 1 or _commandClock:rate(os.clock());
    local v481 = PredictionPacing.plan(p477._accumulatorSeconds, p478, assert(p477._predictionPacingPolicy), v480);
    local AdmittedSeconds = v481.AdmittedSeconds;
    p477._accumulatorSeconds = v481.AccumulatorSeconds;
    local DiscardedSeconds = v481.DiscardedSeconds;
    local GuaranteedSteps = v481.GuaranteedSteps;
    local MaxSteps = v481.MaxSteps;
    local _accumulatorSeconds2 = p477._accumulatorSeconds;
    local v482 = DiscardedSeconds > 0 and true or GuaranteedSteps * _config.StepSeconds + _config.StepSeconds < _accumulatorSeconds2;
    local os_clock_ret = os.clock();
    local math_min_ret = math.min(0.00075, AdmittedSeconds * 0.15);
    debug.profilebegin("MovementV2.Client.PredictionDrain");
    local v483 = 0;
    local v484 = false;

    while p477._accumulatorSeconds >= _config.StepSeconds and MaxSteps > v483 do
        if v481.MinimumSteps <= v483 and os.clock() - os_clock_ret >= v481.WorkCeilingSeconds then
            v484 = true;
            break;
        end;

        if GuaranteedSteps <= v483 and (p479 or (p477._pendingReconciliationInstall ~= nil or math_min_ret <= os.clock() - os_clock_ret)) then
            break;
        end;

        local v485, v486 = p477:_stepPrediction(AdmittedSeconds <= 0 and 1 or math.clamp((_config.StepSeconds - _accumulatorSeconds + v483 * _config.StepSeconds) / AdmittedSeconds, 0, 1));

        if not v485 then
            p477:_sendDueCommands(true);
            p477:_enterPredictionFailureStatus(v486);
            break;
        end;

        if p477._statusFromPredictionFailure then
            p477:_setStatus("Running", nil);
        end;

        p477._accumulatorSeconds = p477._accumulatorSeconds - _config.StepSeconds;
        v483 = v483 + 1;
    end;

    debug.profileend();
    p477._diagnostics:recordPredictionFrame(v483, DiscardedSeconds, v484);
    local v487 = os.clock() - os_clock_ret;
    local os_clock_ret2 = os.clock();

    if v482 and os_clock_ret2 - p477._lastPredictionHitchAt >= 0.25 then
        p477._lastPredictionHitchAt = os_clock_ret2;
        local table_freeze_ret = table.freeze({
            FrameSeconds = p478,
            DiscardedSeconds = DiscardedSeconds,
            BacklogBeforeSeconds = _accumulatorSeconds2,
            BacklogAfterSeconds = p477._accumulatorSeconds,
            StepsDrained = v483,
            GuaranteedStepBudget = GuaranteedSteps,
            StepBudget = MaxSteps,
            PredictionWorkSeconds = v487,
            OwnerSnapshotAgeSeconds = p477._lastOwnerAppliedAt <= 0 and -1 or os_clock_ret2 - p477._lastOwnerAppliedAt,
            ServerTick = p477._lastPredictedServerTick,
            Status = p477._status
        });
        p477._diagnostics:reportPredictionHitch(table_freeze_ret);
        local OnPredictionHitch = p477._options.OnPredictionHitch;

        if OnPredictionHitch ~= nil then
            OnPredictionHitch(table_freeze_ret);
        end;
    end;
end;

function u1.advance(p488: table, p489: number) -- Line: 2698
    local v490;

    if typeof(p489) == "number" and (p489 == p489 and p489 >= 0) then
        v490 = p489 < (1 / 0);
    else
        v490 = false;
    end;

    assert(v490, "invalid delta");

    if p488._discardNextAdvanceDelta then
        p488._discardNextAdvanceDelta = false;
        p489 = 0;
    end;

    local _pendingCommandResyncThrough = p488._pendingCommandResyncThrough;

    if _pendingCommandResyncThrough ~= nil and os.clock() - p488._commandResyncRequestedAt >= 0.5 then
        p488:_sendCommandResyncRequest(_pendingCommandResyncThrough, true);
    end;

    p488:_updateReplayBudget(p489);
    local PrepareInputFrame = p488._options.PrepareInputFrame;

    if PrepareInputFrame ~= nil then
        PrepareInputFrame();
    end;

    local v491 = p488:_advanceReplayAndControls();
    p488:_installQueuedOwnerSnapshot(v491);

    if p488._status == "WaitingForTopology" then
        p488._topologyRetrySeconds = p488._topologyRetrySeconds + p489;

        if p488._topologyRetrySeconds >= 0.25 then
            p488._topologyRetrySeconds = p488._topologyRetrySeconds % 0.25;
            p488:retryTopology();
        end;
    end;

    p488:_drainPrediction(p489, v491);
    p488:_recoverStalledCommands();
    p488:_sendDueCommands();
    p488._diagnostics:emitNetcodeSummary();
end;

function u1.render(p492: table, p493: number?) -- Line: 2739
    local v494;

    if p493 == nil then
        v494 = true;
    elseif typeof(p493) == "number" and (p493 == p493 and p493 >= 0) then
        v494 = p493 < (1 / 0);
    else
        v494 = false;
    end;

    assert(v494, "invalid render delta");
    local _remoteClock = p492._remoteClock;

    if _remoteClock ~= nil then
        _remoteClock:advance(p493, os.clock());
    end;

    p492:_present();
end;

function u1.start(u495) -- Line: 2757
    -- upvalues: Transport (copy), OwnerSnapshotCodec (copy), RunService (copy)
    if u495._started then
        return;
    end;

    u495._started = true;
    u495._channels = Transport.getClientChannels();
    u495._requestedMappingGeneration = nil;
    local v496 = assert(u495._channels);
    u495._traceCapture:bind(v496);
    u495._connections[#u495._connections + 1] = v496.Control.OnClientEvent:Connect(function(p497) -- Line: 2766
        -- upvalues: u495 (copy)
        u495:_handleControl(p497);
    end);
    u495._connections[#u495._connections + 1] = v496.Diagnostics.OnClientEvent:Connect(function(p498) -- Line: 2770
        if typeof(p498) ~= "table" or (p498.Kind ~= "MovementFailure" or type(p498.Message) ~= "string") then
            return;
        end;

        warn((`[MovementV2] server movement simulation failed at tick {tostring(p498.ServerTick)}; your movement was held:\n{p498.Message}`));
    end);
    u495._connections[#u495._connections + 1] = v496.Trace.OnClientEvent:Connect(function(p499) -- Line: 2778
        -- upvalues: u495 (copy)
        local _lastAcceptedOwnerSnapshot = u495._lastAcceptedOwnerSnapshot;
        local v500;

        if _lastAcceptedOwnerSnapshot == nil then
            v500 = nil;
        else
            v500 = _lastAcceptedOwnerSnapshot.Sequence;
        end;

        u495._traceCapture:handleServerTrace(p499, v500);
    end);

    for _, v in u495._diagnostics:connectOutput(v496) do
        u495._connections[#u495._connections + 1] = v;
    end;

    u495._connections[#u495._connections + 1] = v496.OwnerSnapshot.OnClientEvent:Connect(function(p501) -- Line: 2786
        -- upvalues: OwnerSnapshotCodec (ref), u495 (copy)
        local v502 = OwnerSnapshotCodec.decode(p501);

        if v502 ~= nil then
            u495._diagnostics:recordOwnerSnapshotReceived();
            local _mapping = u495._mapping;
            local OnOwnerSnapshotReceived = u495._options.OnOwnerSnapshotReceived;

            if OnOwnerSnapshotReceived ~= nil and (_mapping ~= nil and v502.Generation == _mapping.Generation) then
                OnOwnerSnapshotReceived(v502.Generation, v502.Sequence, {
                    Kind = "OwnerSnapshot",
                    Bytes = buffer.len(p501)
                });
            end;

            u495:_queueOwnerSnapshot(v502);
        end;
    end);
    u495._connections[#u495._connections + 1] = v496.RemoteSnapshot.OnClientEvent:Connect(function(p503) -- Line: 2801
        -- upvalues: u495 (copy)
        u495:_handleRemoteSnapshot(p503);
    end);
    local v504 = `MovementV2.Client.Runtime.{tostring(u495)}`;
    u495._renderStepName = v504;
    RunService:BindToRenderStep(v504, Enum.RenderPriority.Camera.Value - 2, function(p505) -- Line: 2807
        -- upvalues: u495 (copy)
        debug.profilebegin("MovementV2.Client.Advance");
        u495:advance(p505);
        debug.profileend();
        debug.profilebegin("MovementV2.Client.Render");
        u495:render(p505);
        debug.profileend();
    end);
    local _queuedMappingGeneration = u495._queuedMappingGeneration;

    if _queuedMappingGeneration == nil and u495._options.ResolveGeneration ~= nil then
        _queuedMappingGeneration = u495._options.ResolveGeneration();
    end;

    if _queuedMappingGeneration == nil and u495._mapping ~= nil then
        _queuedMappingGeneration = u495._mapping.Generation;
    end;

    if u495._mapping == nil then
        u495:_setStatus("WaitingForMapping", nil);
    else
        u495:_setStatus("WaitingForAuthority", "RuntimeStarted");
    end;

    if _queuedMappingGeneration ~= nil then
        local v506, v507 = u495:requestMapping(_queuedMappingGeneration);

        if not v506 then
            u495:_warn((`could not request startup mapping: {v507}`));
        end;
    end;
end;

function u1.stop(p508) -- Line: 2835
    -- upvalues: RunService (copy)
    if not p508._started then
        return;
    end;

    p508:_sendDueCommands(true);
    p508._started = false;

    for _, v in p508._connections do
        v:Disconnect();
    end;

    table.clear(p508._connections);
    p508._diagnostics:clearOutput();
    p508._traceCapture:bind(nil);
    local _renderStepName = p508._renderStepName;

    if _renderStepName ~= nil then
        RunService:UnbindFromRenderStep(_renderStepName);
        p508._renderStepName = nil;
    end;

    p508._channels = nil;
    p508._pendingCommandResyncThrough = nil;
    p508._commandResyncRequestedAt = 0;
    p508:_setStatus("Stopped", nil);
end;

function u1.destroy(p509) -- Line: 2858
    p509:stop();
    p509:_disposeTimeline();
    local _collisionComposer = p509._collisionComposer;

    if _collisionComposer ~= nil then
        _collisionComposer:Reset();
    end;

    p509._mapping = nil;
    p509._topology = nil;
    p509._topologyBuild = nil;
    p509._cachedStaticFrame = nil;
    p509._cachedStaticWorld = nil;
    p509._state = nil;
    p509._support = nil;
    p509._traceCapture:reset(nil);
    table.clear(p509._damageTagsByMovementTick);
    p509._pendingDamageTagReplayMovementTick = nil;
    p509._actionLocks = nil;
    p509._pendingActionLockReplay = false;
    p509:_refreshPresentedState();
end;

return table.freeze(u1);