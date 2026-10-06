-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local Mapping = require(script.Parent.Parent.Mapping);
local OwnerSnapshotCodec = require(script.Parent.Parent.OwnerSnapshotCodec);
local Quantization = require(script.Parent.Parent.Quantization);
local Serial = require(script.Parent.Parent.Serial);
local StateCodec = require(script.Parent.Parent.StateCodec);
require(script.Parent.Parent.Types);
local State = require(script.Parent.Parent.Simulation.State);
local PredictionRing = require(script.Parent.PredictionRing);
local v1 = State.fieldMask("Position");
local bit32_bor_ret = bit32.bor(v1, State.fieldMask("Velocity"));
local u2 = {};
u2.__index = u2;

local function cloneTopology(p3: any, p4: number?) -- Line: 187
    return {
        Epoch = p3.Epoch,
        Fingerprint = p3.Fingerprint,
        DestructibleRevision = p4 or p3.DestructibleRevision,
        MoverRevision = p3.MoverRevision
    };
end;

local function advanceValidatedMoverRevision(p5: any, p6: number) -- Line: 196
    -- upvalues: Serial (copy)
    local _validatedMoverRevision = p5._validatedMoverRevision;

    if _validatedMoverRevision == nil or Serial.deltaUInt32(p6, _validatedMoverRevision) > 0 then
        p5._validatedMoverRevision = p6;
    end;
end;

local function recordAcceptedSnapshot(p7, p8) -- Line: 203
    -- upvalues: State (copy), Serial (copy)
    p7._lastSequence = p8.Sequence;
    p7._lastServerTick = p8.ServerTick;
    p7._lastProcessedCommand = p8.LastProcessedCommand;
    p7._lastSnapshotState = State.clone(p8.State);
    p7._lastSnapshotSupport = State.cloneSupport(p8.Support);
    p7._lastTopologyRevision = p8.Topology.DestructibleRevision;
    p7._lastMoverRevision = p8.Topology.MoverRevision;
    local MoverRevision = p8.Topology.MoverRevision;
    local _validatedMoverRevision = p7._validatedMoverRevision;

    if _validatedMoverRevision == nil or Serial.deltaUInt32(MoverRevision, _validatedMoverRevision) > 0 then
        p7._validatedMoverRevision = MoverRevision;
    end;
end;

local function replayAnchor(p9: any, p10: any, p11: any, p12: number, p13: number, p14: number) -- Line: 214
    -- upvalues: State (copy)
    return {
        Snapshot = p9,
        State = State.clone(p10),
        Support = State.cloneSupport(p11),
        ServerTick = p12,
        CommandNumber = p13,
        TopologyRevision = p14
    };
end;

local function snapshotReplayAnchor(p15) -- Line: 232
    -- upvalues: State (copy)
    local Support = p15.Support;
    local ServerTick = p15.ServerTick;
    local LastProcessedCommand = p15.LastProcessedCommand;
    local DestructibleRevision = p15.Topology.DestructibleRevision;

    return {
        Snapshot = p15,
        State = State.clone(p15.State),
        Support = State.cloneSupport(Support),
        ServerTick = ServerTick,
        CommandNumber = LastProcessedCommand,
        TopologyRevision = DestructibleRevision
    };
end;

local function validSupport(p16) -- Line: 243
    -- upvalues: Enums (copy), Serial (copy), Quantization (copy)
    local v17;

    if typeof(p16) == "table" and (type(p16.Kind) == "number" and (p16.Kind % 1 == 0 and (p16.Kind >= Enums.SupportKind.None and p16.Kind <= Enums.SupportKind.Max))) then
        v17 = Serial.isUInt32(p16.SourceId);

        if v17 then
            if p16.Kind == Enums.SupportKind.None == (p16.SourceId == 0) then
                v17 = Quantization.isFiniteVector3(p16.Anchor) and Quantization.isFiniteVector3(p16.Velocity);
            else
                v17 = false;
            end;
        end;
    else
        v17 = false;
    end;

    return v17;
end;

local function angleError(p18: number, p19: number) -- Line: 255
    return math.abs((p18 - p19 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793);
end;

local function tailResult(p20: any, p21: any, p22: number, p23: table) -- Line: 260
    -- upvalues: State (copy)
    local v24 = {
        ReplayCount = 0,
        LastProcessedCommand = p20.LastProcessedCommand,
        ServerTick = p20.ServerTick
    };
    local v25;

    if p21 == nil then
        v25 = p20.LastProcessedCommand;
    else
        v25 = p21.Command.CommandNumber;
    end;

    v24.TailCommandNumber = v25;
    local v26;

    if p21 == nil then
        v26 = p20.ServerTick;
    else
        v26 = p21.ServerTick;
    end;

    v24.TailServerTick = v26;
    local v27;

    if p21 == nil then
        v27 = State.clone(p20.State);
    else
        v27 = State.clone(p21.PostState);
    end;

    v24.State = v27;
    local v28;

    if p21 == nil then
        v28 = State.cloneSupport(p20.Support);
    else
        v28 = State.cloneSupport(p21.PostSupport);
    end;

    v24.Support = v28;
    v24.DroppedCommandCount = p22;
    v24.Metrics = p23;

    return v24;
end;

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
        TopologyRevisionDelta = 0
    };
end;

local function canonicalStateMismatch(p29, p30) -- Line: 330
    -- upvalues: StateCodec (copy), State (copy)
    local v31, v32 = StateCodec.canonicalize(p29);
    assert(v31 ~= nil, v32 or "predicted state could not be canonicalized");

    return State.canonicalMismatch(v31, p30);
end;

local function measure(p33, p34) -- Line: 336
    -- upvalues: zeroMetrics (copy), Enums (copy), StateCodec (copy), State (copy), OwnerSnapshotCodec (copy), Serial (copy)
    local v35 = zeroMetrics();
    v35.SynthesizedInput = bit32.band(p33.Flags, Enums.OwnerSnapshotFlags.SynthesizedInput) ~= 0;

    if p34 == nil then
        return v35;
    end;

    local v36 = p34.PostState.Position - p33.State.Position;
    v35.ComparedAtAck = true;
    local State2 = p33.State;
    local v37, v38 = StateCodec.canonicalize(p34.PostState);
    assert(v37 ~= nil, v38 or "predicted state could not be canonicalized");
    local v39, v40 = State.canonicalMismatch(v37, State2);
    v35.CanonicalStateMismatchCount = v39;
    v35.CanonicalStateMismatchMask = v40;
    local v41, v42 = OwnerSnapshotCodec.canonicalizeSupport(p34.PostSupport);
    assert(v41 ~= nil, v42 or "predicted support could not be canonicalized");
    v35.CanonicalSupportMismatch = (v41.Kind ~= p33.Support.Kind or (v41.SourceId ~= p33.Support.SourceId or v41.Anchor ~= p33.Support.Anchor)) and true or v41.Velocity ~= p33.Support.Velocity;
    v35.Position = v36.Magnitude;
    v35.HorizontalPosition = Vector2.new(v36.X, v36.Z).Magnitude;
    v35.Velocity = (p34.PostState.Velocity - p33.State.Velocity).Magnitude;
    v35.LookYaw = math.abs((p34.PostState.LookYaw - p33.State.LookYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793);
    v35.VerticalLook = math.abs(p34.PostState.VerticalLook - p33.State.VerticalLook);
    v35.DuckAmount = math.abs(p34.PostState.DuckAmount - p33.State.DuckAmount);
    v35.Stamina = math.abs(p34.PostState.Stamina - p33.State.Stamina);
    v35.SupportAnchor = (p34.PostSupport.Anchor - p33.Support.Anchor).Magnitude;
    v35.SupportVelocity = (p34.PostSupport.Velocity - p33.Support.Velocity).Magnitude;
    v35.SupportKindMismatch = p34.PostSupport.Kind == p33.Support.Kind and 0 or 1;
    v35.SupportSourceMismatch = p34.PostSupport.SourceId == p33.Support.SourceId and 0 or 1;
    local v43 = Serial.deltaUInt32(p34.TopologyRevision, p33.Topology.DestructibleRevision);
    v35.TopologyRevisionDelta = math.abs(v43);

    return v35;
end;

function u2.new(p44, p45) -- Line: 368
    -- upvalues: Mapping (copy), u2 (copy)
    local v46, v47 = Mapping.validate(p44);
    assert(v46, v47 or "invalid command mapping");
    local v48 = {
        _requiresWorldReplay = false,
        _mapping = Mapping.clone(p44),
        _ring = p45,
        _entryScratch = {}
    };

    return setmetatable(v48, u2);
end;

local function clearReplayHistory(p49: any, p50: boolean) -- Line: 380
    if not p50 then
        p49._lastSequence = nil;
        p49._lastServerTick = nil;
        p49._lastProcessedCommand = nil;
        p49._lastTopologyRevision = nil;
        p49._lastMoverRevision = nil;
    end;

    p49._validatedMoverRevision = nil;
    p49._pendingReplay = nil;
    p49._lastSnapshotState = nil;
    p49._lastSnapshotSupport = nil;
    table.clear(p49._entryScratch);
end;

function u2.reset(p51, p52) -- Line: 395
    -- upvalues: Mapping (copy)
    p51._completedReplayAnchor = nil;
    local v53, v54 = Mapping.validate(p52);
    assert(v53, v54 or "invalid command mapping");
    p51._mapping = Mapping.clone(p52);
    p51._ring:reset(p52);
    p51._requiresWorldReplay = false;
    p51._lastSequence = nil;
    p51._lastServerTick = nil;
    p51._lastProcessedCommand = nil;
    p51._lastTopologyRevision = nil;
    p51._lastMoverRevision = nil;
    p51._validatedMoverRevision = nil;
    p51._pendingReplay = nil;
    p51._lastSnapshotState = nil;
    p51._lastSnapshotSupport = nil;
    table.clear(p51._entryScratch);
end;

function u2.reconfigure(p55, p56) -- Line: 406
    -- upvalues: Mapping (copy)
    p55._completedReplayAnchor = nil;
    local v57, v58 = Mapping.validate(p56);
    assert(v57, v58 or "invalid command mapping");
    assert(p56.Generation == p55._mapping.Generation, "cannot reconfigure a different reconciliation generation");
    assert(p56.SimulationHz == p55._mapping.SimulationHz, "cannot reconfigure the reconciliation rate");
    local v59;

    if p56.ActorId == p55._mapping.ActorId and (p56.TopologyEpoch == p55._mapping.TopologyEpoch and p56.TopologyFingerprint == p55._mapping.TopologyFingerprint) then
        v59 = p56.PlayerCollisionsEnabled ~= p55._mapping.PlayerCollisionsEnabled;
    else
        v59 = false;
    end;

    p55._mapping = Mapping.clone(p56);
    p55._requiresWorldReplay = v59;

    if not v59 then
        p55._lastSequence = nil;
        p55._lastServerTick = nil;
        p55._lastProcessedCommand = nil;
        p55._lastTopologyRevision = nil;
        p55._lastMoverRevision = nil;
    end;

    p55._validatedMoverRevision = nil;
    p55._pendingReplay = nil;
    p55._lastSnapshotState = nil;
    p55._lastSnapshotSupport = nil;
    table.clear(p55._entryScratch);
end;

function u2.markMoverRevisionValidated(p60: table, p61: number) -- Line: 421
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p61) then
        return false, "InvalidMoverRevision";
    end;

    local _validatedMoverRevision = p60._validatedMoverRevision;

    if _validatedMoverRevision == nil or Serial.deltaUInt32(p61, _validatedMoverRevision) > 0 then
        p60._validatedMoverRevision = p61;
    end;

    local _completedReplayAnchor = p60._completedReplayAnchor;

    if _completedReplayAnchor ~= nil and (_completedReplayAnchor.WorldInvalidRevision ~= nil and Serial.deltaUInt32(p61, _completedReplayAnchor.WorldInvalidRevision) >= 0) then
        _completedReplayAnchor.WorldInvalidFromTick = nil;
        _completedReplayAnchor.WorldInvalidRevision = nil;
    end;

    return true, nil;
end;

function u2.hasPendingReplay(p62) -- Line: 437
    return p62._pendingReplay ~= nil;
end;

function u2.cancelPendingReplay(p63) -- Line: 441
    p63._pendingReplay = nil;
end;

function u2.discardReplayContinuation(p64) -- Line: 445
    p64._completedReplayAnchor = nil;
end;

function u2.invalidateWorldReplayFromTick(p65: table, p66: number, p67: number) -- Line: 449
    -- upvalues: Serial (copy)
    local _completedReplayAnchor = p65._completedReplayAnchor;

    if _completedReplayAnchor == nil then
        return;
    end;

    if Serial.deltaUInt32(p66, _completedReplayAnchor.ServerTick) <= 0 then
        p65._completedReplayAnchor = nil;

        return;
    end;

    if _completedReplayAnchor.WorldInvalidFromTick == nil or Serial.deltaUInt32(p66, _completedReplayAnchor.WorldInvalidFromTick) < 0 then
        _completedReplayAnchor.WorldInvalidFromTick = p66;
    end;

    if _completedReplayAnchor.WorldInvalidRevision == nil or Serial.deltaUInt32(p67, _completedReplayAnchor.WorldInvalidRevision) > 0 then
        _completedReplayAnchor.WorldInvalidRevision = p67;
    end;
end;

function u2.retainReplayPrefixBeforePush(p68: table, p69: number) -- Line: 466
    -- upvalues: Serial (copy), State (copy)
    local _completedReplayAnchor = p68._completedReplayAnchor;

    if _completedReplayAnchor == nil or p68._pendingReplay ~= nil then
        return;
    end;

    local v70 = p68._ring:get(Serial.addUInt32(p69, -p68._ring:capacity()));

    if v70 == nil then
        return;
    end;

    if not (v70.Command.CommandNumber == Serial.addUInt32(_completedReplayAnchor.CommandNumber, 1) and (v70.ServerTick == Serial.addUInt32(_completedReplayAnchor.ServerTick, 1) and (_completedReplayAnchor.InvalidFromTick == nil or Serial.deltaUInt32(v70.ServerTick, _completedReplayAnchor.InvalidFromTick) < 0)) and (_completedReplayAnchor.WorldInvalidFromTick == nil or Serial.deltaUInt32(v70.ServerTick, _completedReplayAnchor.WorldInvalidFromTick) < 0)) then
        p68._completedReplayAnchor = nil;

        return;
    end;

    _completedReplayAnchor.State = State.clone(v70.PostState);
    _completedReplayAnchor.Support = State.cloneSupport(v70.PostSupport);
    _completedReplayAnchor.ServerTick = v70.ServerTick;
    _completedReplayAnchor.CommandNumber = v70.Command.CommandNumber;
    _completedReplayAnchor.TopologyRevision = v70.TopologyRevision;
end;

function u2.retainedReplayAnchor(p71: table, p72: any, p73: number?) -- Line: 496
    -- upvalues: Serial (copy)
    local _completedReplayAnchor = p71._completedReplayAnchor;

    if _completedReplayAnchor == nil or (_completedReplayAnchor.Snapshot ~= p72 or (_completedReplayAnchor.CommandNumber == p72.LastProcessedCommand or (p72.Sequence ~= p71._lastSequence or (p71._requiresWorldReplay or (p73 == nil or Serial.deltaUInt32(p73, _completedReplayAnchor.ServerTick) <= 0))))) then
        return nil;
    end;

    return _completedReplayAnchor;
end;

function u2.forkForNewerOwner(p74, p75) -- Line: 510
    -- upvalues: Serial (copy), u2 (copy)
    local _pendingReplay = p74._pendingReplay;

    if _pendingReplay == nil then
        return nil;
    end;

    local Snapshot = _pendingReplay.Snapshot;

    if p75.Generation ~= Snapshot.Generation or (p75.Topology.Epoch ~= Snapshot.Topology.Epoch or (p75.Topology.Fingerprint ~= Snapshot.Topology.Fingerprint or not (Serial.isNewerUInt32(p75.Sequence, Snapshot.Sequence) and (Serial.deltaUInt32(p75.ServerTick, Snapshot.ServerTick) >= 0 and (Serial.deltaUInt32(p75.Topology.DestructibleRevision, Snapshot.Topology.DestructibleRevision) >= 0 and (Serial.deltaUInt32(p75.Topology.MoverRevision, Snapshot.Topology.MoverRevision) >= 0 and (Serial.deltaUInt32(p75.LastProcessedCommand, _pendingReplay.TailCommandNumber) > 0 and p74._ring:get(p75.LastProcessedCommand) ~= nil))))))) then
        return nil;
    end;

    local table_clone_ret = table.clone(p74);
    table_clone_ret._pendingReplay = nil;
    table_clone_ret._entryScratch = {};

    return setmetatable(table_clone_ret, u2);
end;

function u2.lastAcceptedSequence(p76) -- Line: 535
    return p76._lastSequence;
end;

function u2.retiredReplayCommandNumber(p77) -- Line: 539
    local _pendingReplay = p77._pendingReplay;

    if _pendingReplay == nil or _pendingReplay.RetiredCount <= 0 then
        return nil;
    end;

    return _pendingReplay.AnchorCommandNumber;
end;

local function invalidatePendingReplay(p78: any, p79: number, p80: boolean) -- Line: 545
    -- upvalues: Serial (copy), State (copy)
    local _completedReplayAnchor = p78._completedReplayAnchor;
    local v81;

    if p80 and _completedReplayAnchor ~= nil then
        v81 = Serial.addUInt32(_completedReplayAnchor.ServerTick, Serial.deltaUInt32(p79, _completedReplayAnchor.State.MovementTick));
    else
        v81 = p79;
    end;

    if _completedReplayAnchor == nil or Serial.deltaUInt32(v81, _completedReplayAnchor.ServerTick) > 0 then
        if _completedReplayAnchor ~= nil and (_completedReplayAnchor.InvalidFromTick == nil or Serial.deltaUInt32(v81, _completedReplayAnchor.InvalidFromTick) < 0) then
            _completedReplayAnchor.InvalidFromTick = v81;
        end;
    else
        p78._completedReplayAnchor = nil;
    end;

    local _pendingReplay = p78._pendingReplay;

    if _pendingReplay == nil then
        return false;
    end;

    local v82;

    if p80 then
        v82 = _pendingReplay.AnchorState.MovementTick;
    else
        v82 = _pendingReplay.AnchorServerTick;
    end;

    local v83;

    if p80 then
        v83 = _pendingReplay.Snapshot.State.MovementTick;
    else
        v83 = _pendingReplay.Snapshot.ServerTick;
    end;

    local v84 = Serial.deltaUInt32(p79, v82);

    if v84 <= 0 and Serial.deltaUInt32(p79, v83) > 0 then
        _pendingReplay.InvalidatedReason = "ReplayEventOutsideRetention";

        return false;
    end;

    if v84 < 1 or #_pendingReplay.Staged < v84 then
        return true;
    end;

    local v85 = _pendingReplay.Staged[v84 - 1];
    local v86;

    if v85 == nil then
        v86 = _pendingReplay.AnchorState;
    else
        v86 = v85.State;
    end;

    _pendingReplay.State = State.clone(v86);
    local v87;

    if v85 == nil then
        v87 = _pendingReplay.AnchorSupport;
    else
        v87 = v85.Support;
    end;

    _pendingReplay.Support = State.cloneSupport(v87);
    local v88;

    if v85 == nil then
        v88 = _pendingReplay.AnchorTopologyRevision;
    else
        v88 = v85.TopologyRevision;
    end;

    _pendingReplay.TopologyRevision = v88;
    local v89;

    if v85 == nil then
        v89 = _pendingReplay.AnchorCommandNumber;
    else
        v89 = v85.Entry.Command.CommandNumber;
    end;

    _pendingReplay.TailCommandNumber = v89;
    _pendingReplay.TailServerTick = Serial.addUInt32(_pendingReplay.AnchorServerTick, v84 - 1);
    _pendingReplay.NextIndex = v84;

    for i = #_pendingReplay.Staged, v84, -1 do
        _pendingReplay.Staged[i] = nil;
        local _ = i;
    end;

    return true;
end;

function u2.invalidatePendingReplayFromTick(p90: table, p91: number) -- Line: 590
    -- upvalues: invalidatePendingReplay (copy)
    return invalidatePendingReplay(p90, p91, false);
end;

function u2.invalidatePendingReplayFromMovementTick(p92: table, p93: number) -- Line: 594
    -- upvalues: invalidatePendingReplay (copy)
    return invalidatePendingReplay(p92, p93, true);
end;

local function retireReplayPrefix(p94: any, p95: table, p96: number) -- Line: 598
    -- upvalues: State (copy)
    if p96 <= 0 then
        return true;
    end;

    if #p95.Staged < p96 then
        return false;
    end;

    for i = 1, p96 do
        if p94._ring:get(p95.Entries[i].Command.CommandNumber) ~= nil then
            return false;
        end;

        local _ = i;
    end;

    local v97 = p95.Staged[p96];
    p95.AnchorState = State.clone(v97.State);
    p95.AnchorSupport = State.cloneSupport(v97.Support);
    p95.AnchorServerTick = v97.ServerTick;
    p95.AnchorCommandNumber = v97.Entry.Command.CommandNumber;
    p95.AnchorTopologyRevision = v97.TopologyRevision;
    p95.RetiredCount = p95.RetiredCount + p96;
    p95.NextIndex = p95.NextIndex - p96;
    local Entries = p95.Entries;
    local Staged = p95.Staged;
    local v98 = #Entries;
    local v99 = #Staged;
    table.move(Entries, p96 + 1, v98, 1);
    table.move(Staged, p96 + 1, v99, 1);

    for i = v98, v98 - p96 + 1, -1 do
        Entries[i] = nil;
        local _ = i;
    end;

    for i = v99, v99 - p96 + 1, -1 do
        Staged[i] = nil;
        local _ = i;
    end;

    return true;
end;

local function appendReplayEntries(p100: any, p101: table) -- Line: 632
    -- upvalues: Serial (copy), retireReplayPrefix (copy), PredictionRing (copy)
    local Entries = p101.Entries;
    local v102;

    if #Entries == 0 then
        v102 = p101.Snapshot.LastProcessedCommand;
    else
        v102 = Entries[#Entries].Command.CommandNumber;
    end;

    local v103 = p100._ring:entriesAfter(v102, p100._entryScratch);
    local v104 = p100._ring:newestCommandNumber();

    if v104 ~= nil and Serial.deltaUInt32(v104, v102) > #v103 then
        return false, "PredictionHistoryGap";
    end;

    if not retireReplayPrefix(p100, p101, #Entries + #v103 - p100._ring:capacity()) then
        return false, "ReplayHistoryOverflow";
    end;

    if #v103 > 0 and v103[1].Command.CommandNumber ~= Serial.addUInt32(v102, 1) then
        return false, "PredictionHistoryGap";
    end;

    for _, v in v103 do
        Entries[#Entries + 1] = PredictionRing.cloneEntry(v);
    end;

    return true, nil;
end;

local function advancePendingReplay(p105: any, p106: function, p107: function, p108: any) -- Line: 655
    -- upvalues: appendReplayEntries (copy), Serial (copy), StateCodec (copy), validSupport (copy), PredictionRing (copy), recordAcceptedSnapshot (copy), State (copy)
    local _pendingReplay = p105._pendingReplay;

    if _pendingReplay == nil then
        return nil, "ReplayNotPending";
    end;

    if _pendingReplay.InvalidatedReason ~= nil then
        return nil, _pendingReplay.InvalidatedReason;
    end;

    local v109 = (1 / 0);
    local v110 = (1 / 0);
    local v111 = (1 / 0);

    if type(p108) == "number" then
        if p108 ~= p108 or (p108 < 1 or p108 == (1 / 0)) then
            return nil, "InvalidReplayStepBudget";
        end;

        v110 = math.floor(p108);
        v109 = v110;
    elseif p108 ~= nil then
        if type(p108.MinimumSteps) ~= "number" or (p108.MinimumSteps ~= p108.MinimumSteps or (p108.MinimumSteps % 1 ~= 0 or (p108.MinimumSteps < 1 or (p108.MinimumSteps == (1 / 0) or (type(p108.MaximumSteps) ~= "number" or (p108.MaximumSteps ~= p108.MaximumSteps or (p108.MaximumSteps % 1 ~= 0 or (p108.MaximumSteps < p108.MinimumSteps or (p108.MaximumSteps == (1 / 0) or (type(p108.MaximumSeconds) ~= "number" or (p108.MaximumSeconds ~= p108.MaximumSeconds or (p108.MaximumSeconds < 0 or p108.MaximumSeconds == (1 / 0))))))))))))) then
            return nil, "InvalidReplayBudget";
        end;

        v109 = p108.MinimumSteps;
        v110 = p108.MaximumSteps;
        v111 = p108.MaximumSeconds;
    end;

    local v112, v113 = appendReplayEntries(p105, _pendingReplay);

    if not v112 then
        return nil, v113;
    end;

    local math_min_ret = math.min(#_pendingReplay.Entries, _pendingReplay.NextIndex + v110 - 1);
    local os_clock_ret = os.clock();
    local v114 = 0;

    for i = _pendingReplay.NextIndex, math_min_ret do
        local v115 = _pendingReplay.Entries[i];
        local v116 = Serial.addUInt32(_pendingReplay.TailServerTick, 1);
        local Topology = _pendingReplay.Snapshot.Topology;
        local v117, v118, v119 = p106(v116, {
            Epoch = Topology.Epoch,
            Fingerprint = Topology.Fingerprint,
            DestructibleRevision = _pendingReplay.TopologyRevision or Topology.DestructibleRevision,
            MoverRevision = Topology.MoverRevision
        }, _pendingReplay.State, _pendingReplay.Support, v115.Command.CommandNumber);

        if v117 == nil then
            return nil, v119 or "WorldFrameUnavailable";
        end;

        if v118 == nil or not Serial.isUInt32(v118) then
            return nil, "WorldFrameRevisionUnavailable";
        end;

        if Serial.deltaUInt32(v118, _pendingReplay.TopologyRevision) < 0 then
            return nil, "WorldFrameRevisionRegressed";
        end;

        _pendingReplay.TopologyRevision = v118;
        local Topology2 = _pendingReplay.Snapshot.Topology;
        local v120, v121, v122 = p107(_pendingReplay.State, _pendingReplay.Support, v115.Command, 1 / p105._mapping.SimulationHz, v116, {
            Epoch = Topology2.Epoch,
            Fingerprint = Topology2.Fingerprint,
            DestructibleRevision = _pendingReplay.TopologyRevision or Topology2.DestructibleRevision,
            MoverRevision = Topology2.MoverRevision
        }, v117);
        local v123, v124 = StateCodec.validate(v120);

        if not v123 then
            return nil, v124 or "InvalidReplayState";
        end;

        if not validSupport(v121) then
            return nil, "InvalidReplaySupport";
        end;

        local v125 = v122 or 0;

        if not Serial.isUInt32(v125) then
            return nil, "InvalidReplayDependencyMask";
        end;

        local bit32_bnot_ret = bit32.bnot(PredictionRing.Dependency.ValidMask);

        if bit32.band(v125, bit32_bnot_ret) ~= 0 then
            return nil, "InvalidReplayDependencyMask";
        end;

        _pendingReplay.State = v120;
        _pendingReplay.Support = v121;
        _pendingReplay.Staged[#_pendingReplay.Staged + 1] = {
            Entry = v115,
            ServerTick = v116,
            State = v120,
            Support = v121,
            TopologyRevision = _pendingReplay.TopologyRevision,
            DependencyMask = v125
        };
        _pendingReplay.TailCommandNumber = v115.Command.CommandNumber;
        _pendingReplay.TailServerTick = v116;
        _pendingReplay.NextIndex = i + 1;
        v114 = v114 + 1;
        local Metrics = _pendingReplay.Metrics;
        Metrics.ReplayCount = Metrics.ReplayCount + 1;

        if v109 <= v114 and v111 <= os.clock() - os_clock_ret then
            break;
        end;

        local _ = i;
    end;

    if _pendingReplay.NextIndex <= #_pendingReplay.Entries then
        return nil, "ReplayPending";
    end;

    local Snapshot = _pendingReplay.Snapshot;
    local v126 = p105._ring:dropThrough(Snapshot.LastProcessedCommand);

    for _, v in _pendingReplay.Staged do
        if p105._ring:get(v.Entry.Command.CommandNumber) ~= nil then
            local v127, v128 = p105._ring:replacePrediction(v.Entry.Command.CommandNumber, v.ServerTick, v.State, v.Support, v.TopologyRevision, v.DependencyMask);
            assert(v127, v128 or "retained staged prediction disappeared");
        end;
    end;

    p105._requiresWorldReplay = false;
    recordAcceptedSnapshot(p105, Snapshot);
    local AnchorSupport = _pendingReplay.AnchorSupport;
    local AnchorServerTick = _pendingReplay.AnchorServerTick;
    local AnchorCommandNumber = _pendingReplay.AnchorCommandNumber;
    local AnchorTopologyRevision = _pendingReplay.AnchorTopologyRevision;
    p105._completedReplayAnchor = {
        Snapshot = Snapshot,
        State = State.clone(_pendingReplay.AnchorState),
        Support = State.cloneSupport(AnchorSupport),
        ServerTick = AnchorServerTick,
        CommandNumber = AnchorCommandNumber,
        TopologyRevision = AnchorTopologyRevision
    };
    p105._pendingReplay = nil;

    return {
        LastProcessedCommand = Snapshot.LastProcessedCommand,
        ServerTick = Snapshot.ServerTick,
        TailCommandNumber = _pendingReplay.TailCommandNumber,
        TailServerTick = _pendingReplay.TailServerTick,
        State = State.clone(_pendingReplay.State),
        Support = State.cloneSupport(_pendingReplay.Support),
        ReplayCount = _pendingReplay.Metrics.ReplayCount,
        DroppedCommandCount = v126,
        Metrics = _pendingReplay.Metrics
    }, nil;
end;

function u2.resume(p129: table, p130: function, p131: function, p132: any) -- Line: 816
    -- upvalues: advancePendingReplay (copy)
    return advancePendingReplay(p129, p130, p131, p132);
end;

function u2.accept(p133: table, p134: any, p135: function, p136: function, p137: boolean?, p138: boolean?, p139: any, p140: boolean?, p141: number?, p142: function?) -- Line: 824
    -- upvalues: Serial (copy), canonicalStateMismatch (copy), PredictionRing (copy), zeroMetrics (copy), State (copy), tailResult (copy), measure (copy), bit32_bor_ret (copy), recordAcceptedSnapshot (copy), advancePendingReplay (copy)
    local v143 = p140 or p133._requiresWorldReplay;

    if p133._pendingReplay ~= nil then
        return nil, "ReplayAlreadyPending";
    end;

    if p134.Generation ~= p133._mapping.Generation then
        return nil, "GenerationMismatch";
    end;

    if p134.Topology.Epoch ~= p133._mapping.TopologyEpoch or p134.Topology.Fingerprint ~= p133._mapping.TopologyFingerprint then
        return nil, "TopologyMismatch";
    end;

    if p137 then
        if p133._lastSequence == nil or (p134.Sequence ~= p133._lastSequence or (p134.ServerTick ~= p133._lastServerTick or (p134.LastProcessedCommand ~= p133._lastProcessedCommand or (p134.Topology.DestructibleRevision ~= p133._lastTopologyRevision or p134.Topology.MoverRevision ~= p133._lastMoverRevision)))) then
            return nil, "AcceptedSnapshotIdentityMismatch";
        end;
    else
        if p133._lastSequence ~= nil and not Serial.isNewerUInt32(p134.Sequence, p133._lastSequence) then
            return nil, "SnapshotNotNewer";
        end;

        if p133._lastServerTick ~= nil and Serial.deltaUInt32(p134.ServerTick, p133._lastServerTick) < 0 then
            return nil, "ServerTickRegressed";
        end;

        if p133._lastProcessedCommand ~= nil and Serial.deltaUInt32(p134.LastProcessedCommand, p133._lastProcessedCommand) < 0 then
            return nil, "AcknowledgementRegressed";
        end;

        if p133._lastTopologyRevision ~= nil and Serial.deltaUInt32(p134.Topology.DestructibleRevision, p133._lastTopologyRevision) < 0 then
            return nil, "TopologyRevisionRegressed";
        end;

        if p133._lastMoverRevision ~= nil and Serial.deltaUInt32(p134.Topology.MoverRevision, p133._lastMoverRevision) < 0 then
            return nil, "MoverRevisionRegressed";
        end;
    end;

    if not (p137 or (v143 or (p133._lastProcessedCommand == nil or (p133._lastServerTick == nil or (p134.LastProcessedCommand ~= p133._lastProcessedCommand or (p133._ring:get(p134.LastProcessedCommand) ~= nil or (p133._lastSnapshotState == nil or (p133._lastSnapshotSupport == nil or (select(1, canonicalStateMismatch(p133._lastSnapshotState, p134.State)) ~= 0 or (p133._lastSnapshotSupport.Kind ~= p134.Support.Kind or (p133._lastSnapshotSupport.SourceId ~= p134.Support.SourceId or (p133._lastSnapshotSupport.Anchor ~= p134.Support.Anchor or (p133._lastSnapshotSupport.Velocity ~= p134.Support.Velocity or (p134.Topology.DestructibleRevision ~= p133._lastTopologyRevision or p134.Topology.MoverRevision ~= p133._lastMoverRevision and (p133._validatedMoverRevision == nil or Serial.deltaUInt32(p134.Topology.MoverRevision, p133._validatedMoverRevision) > 0))))))))))))))) then
        local v144 = Serial.deltaUInt32(p134.ServerTick, p133._lastServerTick);
        local v145 = p133._ring:entriesAfter(p134.LastProcessedCommand, p133._entryScratch);
        local v146 = v145[#v145];
        local v147 = true;

        for _, v in v145 do
            if bit32.band(v.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 or v144 ~= 0 and (p142 ~= nil and not p142(v.PostState, v.Command, Serial.addUInt32(v.ServerTick, v144))) then
                v147 = false;
                break;
            end;
        end;

        if v147 and (v144 >= 0 and v144 <= p133._ring:capacity()) then
            if v144 > 0 then
                local v148, v149 = p133._ring:shiftServerTicksAfter(p134.LastProcessedCommand, v144);

                if not v148 then
                    return nil, v149;
                end;
            end;

            local v150 = zeroMetrics();
            v150.ReplayBarrier = "AcknowledgementHeld";
            v150.TickRealigned = v144 > 0;
            v150.ServerHeldTickCount = v144;
            p133._lastSequence = p134.Sequence;
            local Support = p134.Support;
            local ServerTick = p134.ServerTick;
            local LastProcessedCommand = p134.LastProcessedCommand;
            local DestructibleRevision = p134.Topology.DestructibleRevision;
            p133._completedReplayAnchor = {
                Snapshot = p134,
                State = State.clone(p134.State),
                Support = State.cloneSupport(Support),
                ServerTick = ServerTick,
                CommandNumber = LastProcessedCommand,
                TopologyRevision = DestructibleRevision
            };
            p133._lastServerTick = p134.ServerTick;
            local MoverRevision = p134.Topology.MoverRevision;
            local _validatedMoverRevision = p133._validatedMoverRevision;

            if _validatedMoverRevision == nil or Serial.deltaUInt32(MoverRevision, _validatedMoverRevision) > 0 then
                p133._validatedMoverRevision = MoverRevision;
            end;

            p133._lastMoverRevision = p134.Topology.MoverRevision;

            return tailResult(p134, v146, 0, v150), nil;
        end;
    end;

    local v151 = p133._ring:get(p134.LastProcessedCommand);
    local v152 = measure(p134, v151);
    local v153;

    if p137 then
        v153 = p133:retainedReplayAnchor(p134, p141);
    else
        v153 = nil;
    end;

    local v154;

    if v153 == nil then
        v154 = p134.LastProcessedCommand;
    else
        v154 = v153.CommandNumber;
    end;

    local v155;

    if v153 == nil then
        v155 = p134.ServerTick;
    else
        v155 = v153.ServerTick;
    end;

    local v156;

    if v153 == nil then
        v156 = p134.Topology.DestructibleRevision;
    else
        v156 = v153.TopologyRevision;
    end;

    local v157 = p133._ring:entriesAfter(v154, p133._entryScratch);

    if #v157 > 0 and v157[1].Command.CommandNumber ~= Serial.addUInt32(v154, 1) then
        return nil, "PredictionHistoryGap";
    end;

    local v158;

    if #v157 > 0 then
        v158 = v157[#v157];
    else
        v158 = nil;
    end;

    local CanonicalStateMismatchMask = v152.CanonicalStateMismatchMask;
    local bit32_bnot_ret = bit32.bnot(bit32_bor_ret);
    local bit32_band_ret = bit32.band(CanonicalStateMismatchMask, bit32_bnot_ret);
    local v159;

    if v152.CanonicalStateMismatchCount > 0 and (bit32_band_ret == 0 and v152.Position <= 0.0001) then
        v159 = v152.Velocity <= 0.0001;
    else
        v159 = false;
    end;

    local v160;

    if p138 == true then
        if v152.CanonicalStateMismatchCount == 0 then
            v160 = true;
        elseif bit32_band_ret == 0 and v152.Position <= 0.0625 then
            v160 = v152.Velocity <= 2;
        else
            v160 = false;
        end;
    else
        v160 = false;
    end;

    local v161;

    if p138 == true and (v152.SupportKindMismatch == 0 and (v152.SupportSourceMismatch == 0 and v152.SupportAnchor <= 0.0625)) then
        v161 = v152.SupportVelocity <= 2;
    else
        v161 = false;
    end;

    local v162;

    if p138 == true and (v158 ~= nil and (v152.CanonicalStateMismatchCount > 0 and (bit32_band_ret == 0 and (v158.PostState.Position - p134.State.Position).Magnitude <= 0.0625))) then
        v162 = (v158.PostState.Velocity - p134.State.Velocity).Magnitude <= 2;
    else
        v162 = false;
    end;

    local v163;

    if v160 and v161 then
        v163 = v152.CanonicalStateMismatchCount > 0 and true or (v152.CanonicalSupportMismatch or v162 and v161);
    else
        v163 = v162 and v161;
    end;

    local _validatedMoverRevision = p133._validatedMoverRevision;
    local v164;

    if _validatedMoverRevision == nil then
        v164 = false;
    else
        v164 = Serial.deltaUInt32(p134.Topology.MoverRevision, _validatedMoverRevision) <= 0;
    end;

    local v165 = v151 == nil and 0 or Serial.deltaUInt32(p134.ServerTick, v151.ServerTick);
    local v166 = true;

    for _, v in v157 do
        if bit32.band(v.DependencyMask, PredictionRing.Dependency.Mover) ~= 0 or (v.TopologyRevision ~= p134.Topology.DestructibleRevision or v165 ~= 0 and (p142 ~= nil and not p142(v.PostState, v.Command, Serial.addUInt32(v.ServerTick, v165)))) then
            v166 = false;
            break;
        end;
    end;

    local v167 = not (p137 or v143);

    if v167 then
        if v151 == nil or (v151.ServerTick == p134.ServerTick or (math.abs(v165) > p133._ring:capacity() or (v151.TopologyRevision ~= p134.Topology.DestructibleRevision or v152.CanonicalStateMismatchCount ~= 0))) then
            v166 = false;
        else
            local v168 = not v152.CanonicalSupportMismatch;

            if v168 then
                if p133._lastTopologyRevision == p134.Topology.DestructibleRevision then
                    if p133._lastMoverRevision ~= p134.Topology.MoverRevision and not v164 then
                        v166 = v164;
                    end;
                else
                    v166 = false;
                end;
            else
                v166 = v168;
            end;
        end;
    else
        v166 = v167;
    end;

    local v169;

    if p137 then
        v169 = "AcceptedWorldChange";
    elseif v143 then
        v169 = "WorldChange";
    elseif v151 == nil then
        v169 = "PredictionMissing";
    elseif v151.ServerTick == p134.ServerTick then
        v169 = v151.TopologyRevision == p134.Topology.DestructibleRevision and ((v152.CanonicalStateMismatchCount == 0 or (v159 or v163)) and (v152.CanonicalSupportMismatch and not v163 and "SupportMismatch" or (p133._lastTopologyRevision == p134.Topology.DestructibleRevision and ((p133._lastMoverRevision == p134.Topology.MoverRevision or v164) and "None" or "MoverRevision") or "DestructibleRevision")) or "StateMismatch") or "PredictionTopology";
    else
        v169 = v166 and "TickRealignFastPath" or "PredictionTick";
    end;

    v152.ReplayBarrier = v169;
    v152.TickRealigned = v169 == "TickRealignFastPath";

    if v169 == "None" and true or v152.TickRealigned then
        if v152.TickRealigned then
            local v170, v171 = p133._ring:shiftServerTicksAfter(p134.LastProcessedCommand, v165);

            if not v170 then
                return nil, v171;
            end;
        end;

        local v172 = p133._ring:dropThrough(p134.LastProcessedCommand);
        local Support = p134.Support;
        local ServerTick = p134.ServerTick;
        local LastProcessedCommand = p134.LastProcessedCommand;
        local DestructibleRevision = p134.Topology.DestructibleRevision;
        p133._completedReplayAnchor = {
            Snapshot = p134,
            State = State.clone(p134.State),
            Support = State.cloneSupport(Support),
            ServerTick = ServerTick,
            CommandNumber = LastProcessedCommand,
            TopologyRevision = DestructibleRevision
        };
        recordAcceptedSnapshot(p133, p134);

        return tailResult(p134, v158, v172, v152), nil;
    end;

    if v151 == nil or (v151.ServerTick ~= p134.ServerTick or v151.TopologyRevision ~= p134.Topology.DestructibleRevision) then
        v163 = false;
    elseif v159 or v163 then
        v163 = not v152.CanonicalSupportMismatch;
    end;

    local v173;

    if v153 == nil then
        if v163 then
            v173 = v151.PostState;
        else
            v173 = p134.State;
        end;
    else
        v173 = v153.State;
    end;

    local v174 = State.clone(v173);
    local v175;

    if v153 == nil then
        if v163 then
            v175 = v151.PostSupport;
        else
            v175 = p134.Support;
        end;
    else
        v175 = v153.Support;
    end;

    local v176 = State.cloneSupport(v175);
    local table_create_ret = table.create(#v157);

    for _, v in v157 do
        table_create_ret[#table_create_ret + 1] = PredictionRing.cloneEntry(v);
    end;

    p133._pendingReplay = {
        RetiredCount = 0,
        InvalidatedReason = nil,
        NextIndex = 1,
        Snapshot = p134,
        AnchorState = v174,
        AnchorSupport = v176,
        AnchorServerTick = v155,
        AnchorCommandNumber = v154,
        AnchorTopologyRevision = v156,
        Metrics = v152,
        Entries = table_create_ret,
        Staged = table.create(#v157),
        State = v174,
        Support = v176,
        TopologyRevision = v156,
        TailCommandNumber = v154,
        TailServerTick = v155
    };
    local _completedReplayAnchor = p133._completedReplayAnchor;

    if p137 and (p141 ~= nil and (_completedReplayAnchor ~= nil and (_completedReplayAnchor.Snapshot == p134 and not p133._requiresWorldReplay))) then
        local _pendingReplay = p133._pendingReplay;

        for i, v in table_create_ret do
            if not (v.ServerTick == Serial.addUInt32(_pendingReplay.TailServerTick, 1) and (v.Command.CommandNumber == Serial.addUInt32(_pendingReplay.TailCommandNumber, 1) and (Serial.deltaUInt32(v.ServerTick, p141) < 0 and (_completedReplayAnchor.InvalidFromTick == nil or Serial.deltaUInt32(v.ServerTick, _completedReplayAnchor.InvalidFromTick) < 0))) and (_completedReplayAnchor.WorldInvalidFromTick == nil or Serial.deltaUInt32(v.ServerTick, _completedReplayAnchor.WorldInvalidFromTick) < 0)) then
                break;
            end;

            _pendingReplay.Staged[i] = {
                Entry = v,
                ServerTick = v.ServerTick,
                State = v.PostState,
                Support = v.PostSupport,
                TopologyRevision = v.TopologyRevision,
                DependencyMask = v.DependencyMask
            };
            local PostSupport = v.PostSupport;
            _pendingReplay.State = v.PostState;
            _pendingReplay.Support = PostSupport;
            _pendingReplay.TopologyRevision = v.TopologyRevision;
            local CommandNumber = v.Command.CommandNumber;
            _pendingReplay.TailServerTick = v.ServerTick;
            _pendingReplay.TailCommandNumber = CommandNumber;
            _pendingReplay.NextIndex = i + 1;
        end;
    end;

    local v177, v178 = advancePendingReplay(p133, p135, p136, p139);

    if v177 == nil and v178 ~= "ReplayPending" then
        p133._pendingReplay = nil;
    end;

    return v177, v178;
end;

return table.freeze(u2);