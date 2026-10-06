-- Decompiled with Potassium's decompiler.

local CompositeWorld = require(script.Parent.Parent.Collision.CompositeWorld);
local Config = require(script.Parent.Parent.Config);
local DoorSwing = require(script.Parent.Parent.DoorSwing);
local Enums = require(script.Parent.Parent.Enums);
local MoverFrame = require(script.Parent.Parent.Collision.MoverFrame);
local MoverDescriptorCodec = require(script.Parent.Parent.MoverDescriptorCodec);
local MoverProxyCache = require(script.Parent.Parent.Collision.MoverProxyCache);
local MoverTrajectory = require(script.Parent.Parent.MoverTrajectory);
local Serial = require(script.Parent.Parent.Serial);
local Config2 = require(script.Parent.Parent.Simulation.Config);
local u1 = {};
u1.__index = u1;
local table_freeze_ret = table.freeze({});

local function effectiveTick(p2) -- Line: 51
    return p2.EffectiveTick;
end;

local function earlierTick(p3: number?, p4: number) -- Line: 55
    -- upvalues: Serial (copy)
    if p3 == nil or Serial.deltaUInt32(p4, p3) < 0 then
        return p4;
    end;

    return p3;
end;

local function nextRevision(p5: number) -- Line: 59
    -- upvalues: Serial (copy)
    return Serial.UInt32Max <= p5 and 1 or p5 + 1;
end;

local function sameGeometry(p6, p7) -- Line: 63
    local v8;

    if p6.Id == p7.Id and (p6.Size == p7.Size and (p6.CollisionOffset == p7.CollisionOffset and p6.SurfaceFriction == p7.SurfaceFriction)) then
        v8 = p6.Behavior == p7.Behavior;
    else
        v8 = false;
    end;

    return v8;
end;

local function sameCollisionDescriptor(p9, p10) -- Line: 72
    local v11;

    if p9.Id == p10.Id and (p9.Size == p10.Size and (p9.CollisionOffset == p10.CollisionOffset and p9.SurfaceFriction == p10.SurfaceFriction)) then
        v11 = p9.Behavior == p10.Behavior;
    else
        v11 = false;
    end;

    if v11 then
        if p9.StartPose == p10.StartPose and (p9.TargetPose == p10.TargetPose and (p9.EffectiveTick == p10.EffectiveTick and (p9.StartTick == p10.StartTick and (p9.DurationTicks == p10.DurationTicks and (p9.Moving == p10.Moving and p9.Active == p10.Active))))) then
            v11 = p9.Revision == p10.Revision;
        else
            v11 = false;
        end;
    end;

    return v11;
end;

local function posesMatch(p12, p13) -- Line: 84
    if p12 == nil or p13 == nil then
        return p12 == p13;
    end;

    if (p12.Position - p13.Position).Magnitude > 0.00001 then
        return false;
    end;

    local _, v14 = p12.Rotation:ToObjectSpace(p13.Rotation):ToAxisAngle();

    return math.abs(v14) <= 0.00001;
end;

local function stanceBoundingRadius(p15) -- Line: 98
    -- upvalues: Config2 (copy)
    local v16;

    if p15 == "Ducking" then
        v16 = Config2.Default.PlayerSizeDucking;
    else
        v16 = Config2.Default.PlayerSizeStanding;
    end;

    return (v16 * 0.5).Magnitude;
end;

local function distanceSquaredToSegment(p17: vector, p18: vector, p19: vector) -- Line: 105
    local v20 = p19 - p18;
    local v21 = v20:Dot(v20);

    if v21 <= 1e-12 then
        local v22 = p17 - p18;

        return v22:Dot(v22);
    end;

    local v23 = (p17 - p18):Dot(v20) / v21;
    local v24 = p17 - (p18 + v20 * math.clamp(v23, 0, 1));

    return v24:Dot(v24);
end;

local function recordMayAffectPosition(p25: any, p26: vector, p27: any) -- Line: 117
    -- upvalues: Config2 (copy), distanceSquaredToSegment (copy)
    local v28;

    if p27 == "Ducking" then
        v28 = Config2.Default.PlayerSizeDucking;
    else
        v28 = Config2.Default.PlayerSizeStanding;
    end;

    local v29 = p25.BoundingRadius + (v28 * 0.5).Magnitude + 0.25;

    return distanceSquaredToSegment(p26, p25.PreviousCFrame.Position, p25.CFrame.Position) <= v29 * v29;
end;

local function descriptorMayAffectPosition(p30: any, p31: vector, p32: any) -- Line: 122
    -- upvalues: Config2 (copy), distanceSquaredToSegment (copy)
    local v33;

    if p32 == "Ducking" then
        v33 = Config2.Default.PlayerSizeDucking;
    else
        v33 = Config2.Default.PlayerSizeStanding;
    end;

    local v34 = (p30.Size * 0.5).Magnitude + p30.CollisionOffset.Position.Magnitude + (v33 * 0.5).Magnitude + 0.25;

    return distanceSquaredToSegment(p31, p30.StartPose.Position, p30.TargetPose.Position) <= v34 * v34;
end;

local function appendDescriptor(p35: table, p36: any) -- Line: 132
    -- upvalues: MoverTrajectory (copy), table_freeze_ret (copy)
    local v37, v38 = MoverTrajectory.Validate(p36);

    if not v37 then
        return false, v38;
    end;

    local v39 = p35[p36.Id];

    if v39 == nil then
        v39 = {
            Descriptors = {},
            Speculative = table_freeze_ret
        };
        p35[p36.Id] = v39;
    else
        local v40 = v39.Descriptors[#v39.Descriptors];

        if v40 ~= nil then
            local v41;

            if v40.Id == p36.Id and (v40.Size == p36.Size and (v40.CollisionOffset == p36.CollisionOffset and v40.SurfaceFriction == p36.SurfaceFriction)) then
                v41 = v40.Behavior == p36.Behavior;
            else
                v41 = false;
            end;

            if not v41 then
                return false, "MoverGeometryChangedInsideRegistration";
            end;
        end;
    end;

    v39.Descriptors[#v39.Descriptors + 1] = p36;

    return true, nil;
end;

local function resolve(p42: table, p43: number, p44: boolean?) -- Line: 151
    -- upvalues: Serial (copy)
    local v45 = nil;

    for _, v in p42.Descriptors do
        if Serial.deltaUInt32(p43, v.EffectiveTick) >= 0 then
            v45 = v;
        end;
    end;

    if p44 == true then
        for _, v in p42.Speculative do
            if Serial.deltaUInt32(p43, v.EffectiveTick) >= 0 then
                v45 = v;
            end;
        end;
    end;

    return v45;
end;

local function resolvePose(p46: table, p47: number, p48: boolean?) -- Line: 169
    -- upvalues: resolve (copy), MoverTrajectory (copy)
    local v49 = resolve(p46, p47, p48);

    if v49 == nil then
        return nil, nil;
    end;

    return v49, MoverTrajectory.EvaluateTick(v49, p47);
end;

local function predictedPose(p50: table?, p51: number) -- Line: 178
    -- upvalues: resolve (copy), MoverTrajectory (copy)
    if p50 == nil then
        return nil;
    end;

    local v52 = resolve(p50, p51, true);

    if v52 == nil or not v52.Active then
        return nil;
    end;

    return MoverTrajectory.EvaluateTick(v52, p51);
end;

local function firstPoseDifference(p53: table?, p54: table?, p55: number, p56: number) -- Line: 190
    -- upvalues: Serial (copy), resolve (copy), MoverTrajectory (copy)
    local v57 = Serial.deltaUInt32(p56, p55);

    if v57 < 0 then
        return nil;
    end;

    if v57 > 1024 then
        p55 = Serial.addUInt32(p56, -1024);
        v57 = 1024;
    end;

    for i = 0, v57 do
        local v58 = Serial.addUInt32(p55, i);
        local v59;

        if p53 == nil then
            v59 = nil;
        else
            local v60 = resolve(p53, v58, true);

            if v60 == nil or not v60.Active then
                v59 = nil;
            else
                v59 = MoverTrajectory.EvaluateTick(v60, v58);
            end;
        end;

        local v61;

        if p54 == nil then
            v61 = nil;
        else
            local v62 = resolve(p54, v58, true);

            if v62 == nil or not v62.Active then
                v61 = nil;
            else
                v61 = MoverTrajectory.EvaluateTick(v62, v58);
            end;
        end;

        local v63;

        if v59 == nil or v61 == nil then
            v63 = v59 == v61;
        elseif (v59.Position - v61.Position).Magnitude > 0.00001 then
            v63 = false;
        else
            local _, v64 = v59.Rotation:ToObjectSpace(v61.Rotation):ToAxisAngle();
            v63 = math.abs(v64) <= 0.00001;
        end;

        if not v63 then
            return v58;
        end;

        local _ = i;
    end;

    return nil;
end;

local function changeTick(p65: table) -- Line: 208
    return p65.AffectedTick;
end;

local function pruneByAge(p66: table, p67: function, p68: number, p69: number) -- Line: 213
    -- upvalues: Serial (copy)
    if #p66 < 2 then
        return;
    end;

    local v70 = nil;

    for i, v in p66 do
        if p69 < Serial.deltaUInt32(p68, p67(v)) then
            v70 = i;
        end;
    end;

    local v71 = 1;

    for i, v in p66 do
        local v72 = Serial.deltaUInt32(p68, p67(v));

        if i == v70 or (v72 < 0 or v72 <= p69) then
            p66[v71] = v;
            v71 = v71 + 1;
        end;
    end;

    for i = #p66, v71, -1 do
        p66[i] = nil;
        local _ = i;
    end;
end;

local function pruneAll(p73: any, p74: number, p75: number) -- Line: 237
    -- upvalues: pruneByAge (copy), changeTick (copy), effectiveTick (copy)
    pruneByAge(p73._revisionChanges, changeTick, p74, p75);

    for _, v in p73._tracks do
        pruneByAge(v.Descriptors, effectiveTick, p74, p75);
    end;
end;

local function cloneTrack(p76: table) -- Line: 244
    return {
        Descriptors = table.clone(p76.Descriptors),
        Speculative = p76.Speculative
    };
end;

local function cloneTracks(p77: table) -- Line: 252
    local v78 = {};

    for i, v in p77 do
        v78[i] = {
            Descriptors = table.clone(v.Descriptors),
            Speculative = v.Speculative
        };
    end;

    return v78;
end;

local function publishSpeculation(p79: any, p80: number, p81: table) -- Line: 261
    -- upvalues: MoverTrajectory (copy)
    if p79._replaySource ~= nil then
        return;
    end;

    local v82 = p81.Speculative[#p81.Speculative];

    if v82 == nil then
        MoverTrajectory.ClearClientSpeculativeDescriptor(p80);

        return;
    end;

    MoverTrajectory.InstallClientSpeculativeDescriptor(v82);
end;

local function commitStagedRevision(p83: any, p84: table, p85: number, p86: number, p87: number) -- Line: 274
    -- upvalues: pruneAll (copy)
    p83._tracks = p84;
    p83._revision = p85;
    p83._latestCommitTick = p86;
    p83._revisionChanges[#p83._revisionChanges + 1] = {
        Revision = p85,
        AffectedTick = p87
    };
    local _horizonTicks = p83._horizonTicks;

    if _horizonTicks ~= nil then
        pruneAll(p83, p86, _horizonTicks);
    end;
end;

local function compareId(p88, p89) -- Line: 294
    return p88.Id < p89.Id;
end;

local function validateHeader(p90, p91, p92) -- Line: 298
    -- upvalues: Serial (copy)
    if not Serial.isNonZeroUInt16(p90) then
        return false, "InvalidMoverEpoch";
    end;

    if not Serial.isUInt32(p91) then
        return false, "InvalidMoverRevision";
    end;

    if Serial.isUInt32(p92) then
        return true, nil;
    end;

    return false, "InvalidMoverServerTick";
end;

local function checkNextRevision(p93, p94, p95, p96) -- Line: 312
    -- upvalues: Serial (copy)
    local _epoch = p93._epoch;
    local _revision = p93._revision;

    if _epoch == nil or _revision == nil then
        return false, "MoverBaselineRequired";
    end;

    if p94 ~= _epoch then
        return false, "MoverEpochMismatch";
    end;

    local v97 = Serial.deltaUInt32(p95, _revision);

    if v97 <= 0 then
        return false, nil;
    end;

    if v97 ~= 1 then
        return false, "MoverRevisionGap";
    end;

    local v98 = assert(p93._latestCommitTick);

    if Serial.deltaUInt32(p96, v98) < 0 then
        return false, "MoverCommitTickRegressed";
    end;

    return true, nil;
end;

function u1.new() -- Line: 335
    -- upvalues: MoverProxyCache (copy), u1 (copy)
    local v99 = {
        _tracks = {},
        _revisionChanges = {},
        _proxyCache = MoverProxyCache.new()
    };

    return setmetatable(v99, u1);
end;

function u1.ForkPrediction(p100) -- Line: 344
    -- upvalues: u1 (copy)
    local v101 = u1.new();
    v101._replaySource = p100;
    local _revision = p100._revision;
    v101._epoch = p100._epoch;
    v101._revision = _revision;
    local _latestCommitTick = p100._latestCommitTick;
    v101._baselineServerTick = p100._baselineServerTick;
    v101._latestCommitTick = _latestCommitTick;
    v101._revisionChanges = table.clone(p100._revisionChanges);
    local _horizonTicks = p100._horizonTicks;
    v101._horizonHz = p100._horizonHz;
    v101._horizonTicks = _horizonTicks;
    v101._lastComposedTick = p100._lastComposedTick;

    for i, v in p100._tracks do
        v101._tracks[i] = {
            Descriptors = table.clone(v.Descriptors),
            Speculative = v.Speculative
        };
        v101._proxyCache:ReserveContactMover(i);
    end;

    return v101;
end;

function u1.ForkControls(p102) -- Line: 359
    local v103 = p102:ForkPrediction();
    v103._controlsFork = true;

    return v103;
end;

function u1.AdoptReplay(p104, p105, p106) -- Line: 366
    local v107;

    if p105._replaySource == p106 then
        v107 = p106._replaySource == p104;
    else
        v107 = false;
    end;

    assert(v107, "unrelated mover replay");
    local v108;

    if p104._epoch == p105._epoch then
        v108 = p104._revision == p105._revision;
    else
        v108 = false;
    end;

    assert(v108, "mover controls not committed");
    p105._replaySource = p104;
end;

local function syncReplaySpeculation(p109) -- Line: 372
    local _replaySource = p109._replaySource;

    if _replaySource == nil or p109._controlsFork then
        return;
    end;

    for i, v in p109._tracks do
        local v110 = _replaySource._tracks[i];

        if v110 ~= nil and v.Speculative ~= v110.Speculative then
            v.Speculative = v110.Speculative;
        end;
    end;
end;

local function installPresentation(p111: any, p112: number) -- Line: 386
    -- upvalues: Serial (copy), resolve (copy), MoverTrajectory (copy)
    local v113 = Serial.addUInt32(p112, -1);
    local v114 = {};

    for _, v in p111._tracks do
        local v115 = resolve(v, p112, true);
        local v116;

        if v115 == nil then
            v115 = nil;
            v116 = nil;
        else
            v116 = MoverTrajectory.EvaluateTick(v115, p112);
        end;

        if v115 ~= nil and (v116 ~= nil and v115.Active) then
            local v117 = resolve(v, v113, true);
            local v118;

            if v117 == nil then
                v118 = nil;
            else
                v118 = MoverTrajectory.EvaluateTick(v117, v113);
            end;

            MoverTrajectory.InstallClientResolvedPose(v115, p112, v118 or v116, v116);
        end;

        local v119 = nil;

        for _, v2 in v.Descriptors do
            if Serial.deltaUInt32(p112, v2.EffectiveTick) >= 0 then
                v119 = v2;
            end;
        end;

        if v119 ~= nil then
            v114[#v114 + 1] = v119;
        end;
    end;

    MoverTrajectory.InstallClientResolved(p112, v114);
end;

function u1.CommitPrediction(p120, p121) -- Line: 403
    -- upvalues: Serial (copy), installPresentation (copy)
    assert(p121._replaySource == p120, "mover replay belongs to a different composer");
    local v122;

    if p120._epoch == p121._epoch then
        v122 = p120._revision == p121._revision;
    else
        v122 = false;
    end;

    assert(v122, "mover controls changed during replay");
    local _lastComposedTick = p121._lastComposedTick;
    local _lastComposedTick2 = p120._lastComposedTick;

    if _lastComposedTick == nil or _lastComposedTick2 ~= nil and Serial.deltaUInt32(_lastComposedTick, _lastComposedTick2) <= 0 then
        return;
    end;

    p120._lastComposedTick = _lastComposedTick;

    if p120._replaySource == nil then
        installPresentation(p120, _lastComposedTick);
    end;
end;

function u1.Revision(p123) -- Line: 419
    return p123._revision;
end;

function u1.Reset(p124) -- Line: 423
    -- upvalues: MoverTrajectory (copy)
    table.clear(p124._tracks);
    p124._epoch = nil;
    p124._revision = nil;
    p124._baselineServerTick = nil;
    p124._latestCommitTick = nil;
    p124._lastComposedTick = nil;
    table.clear(p124._revisionChanges);
    p124._horizonHz = nil;
    p124._horizonTicks = nil;
    p124._proxyCache:Reset();

    if p124._replaySource == nil then
        MoverTrajectory.ResetClientDescriptors();
    end;
end;

function u1.IsPredictionStateAffected(p125: any, p126: table, p127: any, p128: any) -- Line: 439
    -- upvalues: Enums (copy), Config2 (copy), distanceSquaredToSegment (copy)
    if type(p128) == "table" and (p128.Kind == Enums.SupportKind.Mover and p126[p128.SourceId] == true) then
        return true;
    end;

    if type(p127) ~= "table" or typeof(p127.Position) ~= "Vector3" then
        return true;
    end;

    for i in p126 do
        local v129 = p125._tracks[i];

        if v129 == nil then
            return true;
        end;

        for _, v in v129.Descriptors do
            local v130;

            if p127.Stance == "Ducking" then
                v130 = Config2.Default.PlayerSizeDucking;
            else
                v130 = Config2.Default.PlayerSizeStanding;
            end;

            local v131 = (v.Size * 0.5).Magnitude + v.CollisionOffset.Position.Magnitude + (v130 * 0.5).Magnitude + 0.25;

            if distanceSquaredToSegment(p127.Position, v.StartPose.Position, v.TargetPose.Position) <= v131 * v131 then
                return true;
            end;
        end;

        for _, v in v129.Speculative do
            local v132;

            if p127.Stance == "Ducking" then
                v132 = Config2.Default.PlayerSizeDucking;
            else
                v132 = Config2.Default.PlayerSizeStanding;
            end;

            local v133 = (v.Size * 0.5).Magnitude + v.CollisionOffset.Position.Magnitude + (v132 * 0.5).Magnitude + 0.25;

            if distanceSquaredToSegment(p127.Position, v.StartPose.Position, v.TargetPose.Position) <= v133 * v133 then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.PredictDoorUse(p134: any, p135: userdata, p136: vector, p137: number, p138: number) -- Line: 471
    -- upvalues: Serial (copy), MoverTrajectory (copy), resolve (copy), DoorSwing (copy), MoverDescriptorCodec (copy)
    if not (Serial.isUInt32(p137) and (p138 % 1 == 0 and p138 > 0)) then
        return nil, "MoverDoorPredictionClockInvalid";
    end;

    local Attribute = p135:GetAttribute(MoverTrajectory.Attributes.Id);

    if not Serial.isUInt32(Attribute) or Attribute == 0 then
        return nil, "MoverDoorIdentityUnavailable";
    end;

    local v139 = p134._tracks[Attribute];

    if v139 == nil then
        return nil, "MoverDoorTrackUnavailable";
    end;

    local v140 = resolve(v139, p137, true);
    local v141;

    if v140 == nil then
        v140 = nil;
        v141 = nil;
    else
        v141 = MoverTrajectory.EvaluateTick(v140, p137);
    end;

    if v140 == nil or (v141 == nil or not v140.Active) then
        return nil, "MoverDoorPoseUnavailable";
    end;

    local Revision = v140.Revision;
    local v142 = Serial.UInt32Max <= Revision and 1 or Revision + 1;

    if v140.Moving then
        if MoverTrajectory.TickAlpha(v140, p137) < 1 or #v139.Speculative >= 2 then
            return nil, "MoverDoorAlreadyMoving";
        end;

        v142 = Serial.UInt32Max <= v142 and 1 or v142 + 1;
        v141 = v140.TargetPose;
    end;

    local Attribute2 = p135:GetAttribute("DoorClosedPivot");

    if typeof(Attribute2) ~= "CFrame" then
        return nil, "MoverDoorClosedPoseUnavailable";
    end;

    local _, v143 = Attribute2:ToObjectSpace(v141):ToOrientation();
    local OpenAngle = DoorSwing.OpenAngle;

    if math.abs(v143) >= DoorSwing.ClosedAngleEpsilon then
        OpenAngle = 0;
    else
        local Position = (Attribute2 * CFrame.Angles(0, OpenAngle, 0) * v140.CollisionOffset).Position;
        local Position2 = (Attribute2 * CFrame.Angles(0, -OpenAngle, 0) * v140.CollisionOffset).Position;

        if (Position - p136).Magnitude < (Position2 - p136).Magnitude then
            OpenAngle = -OpenAngle;
        end;
    end;

    local v144 = Attribute2 * CFrame.Angles(0, OpenAngle, 0);
    local math_abs_ret = math.abs(OpenAngle - v143);

    if math_abs_ret < DoorSwing.TargetEpsilon then
        return nil, "MoverDoorTargetAlreadyReached";
    end;

    local v145 = DoorSwing.durationSeconds(math_abs_ret) * p138;
    local math_ceil_ret = math.ceil(v145);
    local math_max_ret = math.max(1, math_ceil_ret);
    local v146 = Serial.addUInt32(p137, 1);
    local v147 = {
        Moving = true,
        Active = true,
        Id = v140.Id,
        Size = v140.Size,
        CollisionOffset = v140.CollisionOffset,
        SurfaceFriction = v140.SurfaceFriction,
        StartPose = v141,
        TargetPose = v144,
        EffectiveTick = v146,
        StartTick = Serial.addUInt32(v146, 1),
        DurationTicks = math_max_ret,
        StartServerTime = workspace:GetServerTimeNow(),
        DurationSeconds = math_max_ret / p138,
        Behavior = v140.Behavior,
        Revision = v142
    };
    local v148, v149 = MoverDescriptorCodec.canonicalize(v147);

    if v148 == nil then
        return nil, v149;
    end;

    local table_clone_ret = table.clone(v139.Speculative);
    table_clone_ret[#table_clone_ret + 1] = v148;
    v139.Speculative = table.freeze(table_clone_ret);

    if p134._replaySource == nil then
        local v150 = v139.Speculative[#v139.Speculative];

        if v150 == nil then
            MoverTrajectory.ClearClientSpeculativeDescriptor(Attribute);
        else
            MoverTrajectory.InstallClientSpeculativeDescriptor(v150);
        end;
    end;

    return {
        ServerTick = v146,
        TargetAngle = OpenAngle,
        MoverId = Attribute,
        Revision = v142
    }, nil;
end;

function u1.RejectDoorUse(p151: any, p152: number, p153: number) -- Line: 566
    -- upvalues: Serial (copy), table_freeze_ret (copy), MoverTrajectory (copy)
    if not (Serial.isUInt32(p152) and (p152 ~= 0 and (Serial.isUInt32(p153) and p153 ~= 0))) then
        return nil, "MoverDoorRejectionIdentityInvalid";
    end;

    local v154 = p151._tracks[p152];

    if v154 == nil then
        return nil, nil;
    end;

    for i, v in v154.Speculative do
        if v.Revision == p153 then
            local table_move_ret = table.move(v154.Speculative, 1, i - 1, 1, {});
            local v155;

            if #table_move_ret == 0 then
                v155 = table_freeze_ret;
            else
                v155 = table.freeze(table_move_ret);
            end;

            v154.Speculative = v155;

            if p151._replaySource == nil then
                local v156 = v154.Speculative[#v154.Speculative];

                if v156 == nil then
                    MoverTrajectory.ClearClientSpeculativeDescriptor(p152);
                else
                    MoverTrajectory.InstallClientSpeculativeDescriptor(v156);
                end;
            end;

            return v.EffectiveTick, nil;
        end;
    end;

    return nil, nil;
end;

local function equivalentBaseline(p157: any, p158: number, p159: table) -- Line: 587
    -- upvalues: Serial (copy), sameCollisionDescriptor (copy)
    for i in p159 do
        if p157._tracks[i] == nil then
            return false;
        end;
    end;

    for i, v in p157._tracks do
        local v160 = p159[i];
        local v161 = v;
        local v162 = nil;

        for i2, v2 in v.Descriptors do
            if Serial.deltaUInt32(p158, v2.EffectiveTick) >= 0 then
                v162 = i2;
            end;
        end;

        local v163 = 0;

        for i2, v2 in v161.Descriptors do
            local v164;

            if i2 == v162 then
                v164 = v2.Active;
            else
                v164 = false;
            end;

            if (v162 == nil or v162 < i2) and Serial.deltaUInt32(v2.EffectiveTick, p158) > 0 then
                local v165 = v161.Descriptors[i2 + 1];
                v164 = v165 == nil and true or v165.EffectiveTick ~= v2.EffectiveTick;
            end;

            if v164 then
                v163 = v163 + 1;
                local v166;

                if v160 then
                    v166 = v160.Descriptors[v163];
                else
                    v166 = nil;
                end;

                if v166 == nil or not (sameCollisionDescriptor(v2, v166) and (v2.StartServerTime == v166.StartServerTime and v2.DurationSeconds == v166.DurationSeconds)) then
                    return false;
                end;
            end;
        end;

        if (v160 and #v160.Descriptors or 0) ~= v163 then
            return false;
        end;
    end;

    return true;
end;

function u1.ConsumeBaseline(p167, p168, p169, p170, p171, p172) -- Line: 631
    -- upvalues: Serial (copy), appendDescriptor (copy), equivalentBaseline (copy), pruneAll (copy), MoverTrajectory (copy)
    local v173, v174;

    if Serial.isNonZeroUInt16(p168) then
        if Serial.isUInt32(p169) then
            if Serial.isUInt32(p170) then
                v173 = true;
                v174 = nil;
            else
                v173 = false;
                v174 = "InvalidMoverServerTick";
            end;
        else
            v173 = false;
            v174 = "InvalidMoverRevision";
        end;
    else
        v173 = false;
        v174 = "InvalidMoverEpoch";
    end;

    if not v173 then
        return false, v174;
    end;

    if type(p171) ~= "table" then
        return false, "MoverDescriptorsNotTable";
    end;

    if p172 ~= nil and (type(p172) ~= "table" or next(p172) ~= nil) then
        return false, "MoverProgressUnsupported";
    end;

    local v175 = {};

    for _, v in p171 do
        local v176, v177 = appendDescriptor(v175, v);

        if not v176 then
            return false, v177;
        end;
    end;

    if p167._epoch == p168 and (p167._revision == p169 and equivalentBaseline(p167, p170, v175)) then
        local _latestCommitTick = p167._latestCommitTick;

        if _latestCommitTick ~= nil and Serial.deltaUInt32(p170, _latestCommitTick) > 0 then
            p167._latestCommitTick = p170;
        end;

        local _horizonTicks = p167._horizonTicks;

        if _horizonTicks ~= nil then
            pruneAll(p167, assert(p167._latestCommitTick), _horizonTicks);
        end;

        return true, nil, nil, nil, false;
    end;

    p167._tracks = v175;
    p167._proxyCache:Reset();

    for i in v175 do
        p167._proxyCache:ReserveContactMover(i);
    end;

    p167._epoch = p168;
    p167._revision = p169;
    p167._baselineServerTick = p170;
    p167._latestCommitTick = p170;
    p167._revisionChanges = {
        {
            Revision = p169,
            AffectedTick = p170
        }
    };

    if p167._replaySource == nil then
        MoverTrajectory.InstallClientBaseline(p171, p170);
    end;

    return true, nil, nil, nil, true;
end;

local function settleSpeculation(p178: table, p179: number?) -- Line: 686
    -- upvalues: Serial (copy), sameCollisionDescriptor (copy), table_freeze_ret (copy)
    local Speculative = p178.Speculative;

    if #Speculative == 0 then
        return p179;
    end;

    local Revision = p178.Descriptors[#p178.Descriptors].Revision;
    local v180 = false;
    local v181 = {};

    for _, v in Speculative do
        if v180 or Serial.deltaUInt32(Revision, v.Revision) >= 0 then
            local v182;

            if v180 then
                v182 = v;
            else
                v182 = v;
                local v183 = false;

                for _, v2 in p178.Descriptors do
                    if v2.Revision == v182.Revision then
                        v183 = sameCollisionDescriptor(v182, v2);
                    end;
                end;

                v180 = not v183;
            end;

            local EffectiveTick = v182.EffectiveTick;

            if p179 == nil or Serial.deltaUInt32(EffectiveTick, p179) < 0 then
                p179 = EffectiveTick;
            end;
        else
            v181[#v181 + 1] = v;
        end;
    end;

    if #v181 ~= #Speculative then
        local v184;

        if #v181 == 0 then
            v184 = table_freeze_ret;
        else
            v184 = table.freeze(v181);
        end;

        p178.Speculative = v184;
    end;

    return p179;
end;

function u1.ConsumeDelta(p185, p186, p187, p188, p189) -- Line: 717
    -- upvalues: Serial (copy), checkNextRevision (copy), cloneTracks (copy), appendDescriptor (copy), settleSpeculation (copy), firstPoseDifference (copy), commitStagedRevision (copy), MoverTrajectory (copy)
    local v190, v191;

    if Serial.isNonZeroUInt16(p186) then
        if Serial.isUInt32(p187) then
            if Serial.isUInt32(p188) then
                v190 = true;
                v191 = nil;
            else
                v190 = false;
                v191 = "InvalidMoverServerTick";
            end;
        else
            v190 = false;
            v191 = "InvalidMoverRevision";
        end;
    else
        v190 = false;
        v191 = "InvalidMoverEpoch";
    end;

    if not v190 then
        return nil, v191, false;
    end;

    local v192, v193 = checkNextRevision(p185, p186, p187, p188);

    if not v192 then
        return nil, v193, false;
    end;

    if type(p189) ~= "table" or #p189 == 0 then
        return nil, "MoverDeltaEmpty", false;
    end;

    local v194 = cloneTracks(p185._tracks);
    local v195 = {};
    local v196 = {};

    for _, v in p189 do
        local v197, v198 = appendDescriptor(v194, v);

        if not v197 then
            return nil, v198, false;
        end;

        v195[v.Id] = true;
        local Id = v.Id;
        local v199 = v196[v.Id];
        local EffectiveTick = v.EffectiveTick;

        if v199 ~= nil and Serial.deltaUInt32(EffectiveTick, v199) >= 0 then
            EffectiveTick = v199;
        end;

        v196[Id] = EffectiveTick;
    end;

    local _lastComposedTick = p185._lastComposedTick;
    local v200 = nil;
    local v201 = nil;

    for i in v195 do
        local v202 = settleSpeculation(v194[i], v196[i]);

        if v200 == nil or Serial.deltaUInt32(v202, v200) < 0 then
            v200 = v202;
        end;

        if _lastComposedTick == nil then
            if v201 == nil or Serial.deltaUInt32(v202, v201) < 0 then
                v201 = v202;
            end;
        else
            local v203 = firstPoseDifference(p185._tracks[i], v194[i], v202, _lastComposedTick);

            if v203 ~= nil then
                if v201 == nil or Serial.deltaUInt32(v203, v201) < 0 then
                    v201 = v203;
                end;
            end;
        end;
    end;

    commitStagedRevision(p185, v194, p187, p188, assert(v200));

    for i in v195 do
        p185._proxyCache:ReserveContactMover(i);
    end;

    if p185._replaySource == nil then
        MoverTrajectory.InstallClientDelta(p189, p188);

        for i in v195 do
            local v204 = p185._tracks[i];

            if p185._replaySource == nil then
                local v205 = v204.Speculative[#v204.Speculative];

                if v205 == nil then
                    MoverTrajectory.ClearClientSpeculativeDescriptor(i);
                else
                    MoverTrajectory.InstallClientSpeculativeDescriptor(v205);
                end;
            end;
        end;
    end;

    return v201, nil, v201 == nil, v195;
end;

function u1.ConsumeProgress(p206, p207, p208, p209, p210) -- Line: 780
    -- upvalues: Serial (copy)
    local v211, v212;

    if Serial.isNonZeroUInt16(p207) then
        if Serial.isUInt32(p208) then
            if Serial.isUInt32(p209) then
                v211 = true;
                v212 = nil;
            else
                v211 = false;
                v212 = "InvalidMoverServerTick";
            end;
        else
            v211 = false;
            v212 = "InvalidMoverRevision";
        end;
    else
        v211 = false;
        v212 = "InvalidMoverEpoch";
    end;

    if v211 then
        return nil, "MoverProgressUnsupported", false;
    end;

    return nil, v212, false;
end;

function u1.ComposeTick(p213: any, p214: number, p215: boolean?) -- Line: 795
    -- upvalues: Serial (copy)
    local _baselineServerTick = p213._baselineServerTick;

    if p215 == true and (_baselineServerTick ~= nil and (Serial.isUInt32(p214) and Serial.deltaUInt32(p214, _baselineServerTick) < 0)) then
        return _baselineServerTick;
    end;

    return p214;
end;

local function predictLocalHold(p216: any, p217: table, p218: any, p219, p220, p221: number, p222: any) -- Line: 809
    -- upvalues: Config2 (copy), distanceSquaredToSegment (copy), MoverFrame (copy), MoverTrajectory (copy), MoverDescriptorCodec (copy), Serial (copy)
    local ContactState = p222.ContactState;

    if ContactState ~= nil and (p218.Behavior == "StopOnBlock" and (p218.Moving and p219 ~= p220)) then
        local v223;

        if ContactState.Stance == "Ducking" then
            v223 = Config2.Default.PlayerSizeDucking;
        else
            v223 = Config2.Default.PlayerSizeStanding;
        end;

        local v224 = (p218.Size * 0.5).Magnitude + p218.CollisionOffset.Position.Magnitude + (v223 * 0.5).Magnitude + 0.25;

        if distanceSquaredToSegment(ContactState.Position, p218.StartPose.Position, p218.TargetPose.Position) <= v224 * v224 then
            local v225 = MoverFrame.Build(p222.StepSeconds, {
                {
                    Id = p218.Id,
                    PreviousCFrame = MoverTrajectory.CollisionPose(p218, p219),
                    CFrame = MoverTrajectory.CollisionPose(p218, p220),
                    Size = p218.Size,
                    SurfaceFriction = p218.SurfaceFriction
                }
            });

            if p216._proxyCache:FindEarliestStationaryContact(v225.ById[p218.Id], {
                {
                    Id = 0,
                    Position = ContactState.Position,
                    Stance = ContactState.Stance
                }
            }, p222.StaticWorld.Topology.Config) == nil then
                return nil, nil;
            end;

            local canonicalize = MoverDescriptorCodec.canonicalize;
            local v226 = {
                DurationTicks = 0,
                DurationSeconds = 0,
                Moving = false,
                Active = true,
                Id = p218.Id,
                Size = p218.Size,
                CollisionOffset = p218.CollisionOffset,
                SurfaceFriction = p218.SurfaceFriction,
                StartPose = p219,
                TargetPose = p219,
                EffectiveTick = p221,
                StartTick = p221,
                StartServerTime = workspace:GetServerTimeNow(),
                Behavior = p218.Behavior
            };
            local Revision = p218.Revision;
            v226.Revision = Serial.UInt32Max <= Revision and 1 or Revision + 1;
            local v227 = canonicalize(v226);

            if v227 == nil then
                return nil, nil;
            end;

            local table_clone_ret = table.clone(p217.Speculative);
            table_clone_ret[#table_clone_ret + 1] = v227;
            p217.Speculative = table.freeze(table_clone_ret);
            local Id = p218.Id;

            if p216._replaySource == nil then
                local v228 = p217.Speculative[#p217.Speculative];

                if v228 == nil then
                    MoverTrajectory.ClearClientSpeculativeDescriptor(Id);
                else
                    MoverTrajectory.InstallClientSpeculativeDescriptor(v228);
                end;
            end;

            return v227, MoverTrajectory.EvaluateTick(v227, p221);
        end;
    end;

    return nil, nil;
end;

local function compose(p229: any, p230: any, p231: boolean) -- Line: 871
    -- upvalues: syncReplaySpeculation (copy), Serial (copy), u1 (copy), Config (copy), pruneByAge (copy), changeTick (copy), resolve (copy), MoverTrajectory (copy), effectiveTick (copy), predictLocalHold (copy), compareId (copy), MoverFrame (copy), CompositeWorld (copy), Config2 (copy), distanceSquaredToSegment (copy)
    syncReplaySpeculation(p229);
    local ServerTick = p230.ServerTick;
    local PreviousServerTick = p230.PreviousServerTick;
    local StepSeconds = p230.StepSeconds;

    if not (Serial.isUInt32(ServerTick) and Serial.isUInt32(PreviousServerTick)) then
        return nil, "MoverComposerTickInvalid";
    end;

    local _revision = p229._revision;
    local _baselineServerTick = p229._baselineServerTick;

    if _revision == nil or _baselineServerTick == nil then
        return nil, "MoverBaselineRequired";
    end;

    if p230.Mapping.TopologyEpoch ~= p229._epoch then
        return nil, "MoverEpochMismatch";
    end;

    if Serial.deltaUInt32(ServerTick, _baselineServerTick) < 0 and p230.Speculative ~= true then
        return nil, "MoverFrameOutsideRetention";
    end;

    local v232 = u1.ComposeTick(p229, ServerTick, p230.Speculative);

    if v232 == ServerTick then
        v232 = PreviousServerTick;
    else
        ServerTick = v232;
    end;

    local SimulationHz = p230.Mapping.SimulationHz;

    if p229._horizonHz ~= SimulationHz then
        p229._horizonHz = SimulationHz;
        p229._horizonTicks = Config.derive(SimulationHz).PredictionReplayTicks;
    end;

    local v233 = assert(p229._horizonTicks);
    local v234 = assert(p229._latestCommitTick);
    pruneByAge(p229._revisionChanges, changeTick, v234, v233);
    local MoverRevision = p230.MoverRevision;

    if MoverRevision ~= nil then
        if not Serial.isUInt32(MoverRevision) then
            return nil, "MoverRevisionInvalid";
        end;

        if _revision ~= MoverRevision then
            local v235 = false;

            for _, v in p229._revisionChanges do
                if v.Revision == MoverRevision then
                    v235 = true;
                elseif v235 and Serial.deltaUInt32(ServerTick, v.AffectedTick) >= 0 then
                    return nil, "MoverRevisionUnavailable";
                end;
            end;

            if not v235 then
                return nil, "MoverRevisionUnavailable";
            end;
        end;
    end;

    local v236 = not p231 and p229._replaySource == nil;
    local v237 = {};
    local v238 = {};
    local v239 = {};

    for i, v in p229._tracks do
        local v240 = resolve(v, ServerTick, true);
        local v241;

        if v240 == nil then
            v241 = nil;
            v240 = nil;
        else
            v241 = MoverTrajectory.EvaluateTick(v240, ServerTick);
        end;

        pruneByAge(v.Descriptors, effectiveTick, v234, v233);

        if v240 ~= nil then
            local v242, v243;

            if v236 then
                v242 = i;
                v243 = v;
                local v244 = nil;

                for _, v2 in v.Descriptors do
                    if Serial.deltaUInt32(ServerTick, v2.EffectiveTick) >= 0 then
                        v244 = v2;
                    end;
                end;

                if v244 ~= nil then
                    v238[#v238 + 1] = v244;
                end;
            else
                v242 = i;
                v243 = v;
            end;

            if v240.Active then
                local v245 = resolve(v243, v232, true);
                local v246;

                if v245 == nil then
                    v246 = nil;
                else
                    v246 = MoverTrajectory.EvaluateTick(v245, v232);
                end;

                if v246 == nil and v241 ~= nil then
                    if v240.EffectiveTick == ServerTick then
                        v246 = v241;
                    end;
                end;

                if v246 == nil or v241 == nil then
                    return nil, "MoverReplayPoseUnavailable";
                end;

                local v247, v248;

                if v236 then
                    v247, v248 = predictLocalHold(p229, v243, v240, v246, v241, ServerTick, p230);

                    if v247 == nil then
                        v248 = v241;
                        v247 = v240;
                    elseif v248 == nil then
                        v248 = v241;
                        v247 = v240;
                    end;

                    MoverTrajectory.InstallClientResolvedPose(v247, ServerTick, v246, v248);
                else
                    v248 = v241;
                    v247 = v240;
                end;

                v237[#v237 + 1] = {
                    Id = v242,
                    PreviousCFrame = MoverTrajectory.CollisionPose(v247, v246),
                    CFrame = MoverTrajectory.CollisionPose(v247, v248),
                    Size = v247.Size,
                    SurfaceFriction = v247.SurfaceFriction,
                    Pushes = v247.Behavior == "Pusher"
                };
            elseif not p231 and v233 < Serial.deltaUInt32(v234, v240.EffectiveTick) then
                v239[#v239 + 1] = v242;
            end;
        end;
    end;

    if #v239 > 0 then
        for _, v in v239 do
            p229._tracks[v] = nil;
            p229._proxyCache:Retire(v);
        end;

        if p229._replaySource == nil then
            MoverTrajectory.RetireClientDescriptors(v239);
        end;
    end;

    table.sort(v237, compareId);
    local u249 = MoverFrame.Build(StepSeconds, v237);

    if v236 then
        MoverTrajectory.InstallClientResolved(ServerTick, v238);
    end;

    if not p231 then
        p229._lastComposedTick = ServerTick;
    end;

    local u250 = CompositeWorld.new(p230.StaticWorld, u249, {
        Cache = p229._proxyCache
    });

    return {
        Query = u250,

        MoverSensitiveAt = function(p251, p252) -- Line: 996, Name: MoverSensitiveAt
            -- upvalues: u249 (copy), Config2 (ref), distanceSquaredToSegment (ref)
            for _, v in u249.Records do
                if v.PreviousCFrame ~= v.CFrame then
                    local v253;

                    if p252 == "Ducking" then
                        v253 = Config2.Default.PlayerSizeDucking;
                    else
                        v253 = Config2.Default.PlayerSizeStanding;
                    end;

                    local v254 = v.BoundingRadius + (v253 * 0.5).Magnitude + 0.25;

                    if distanceSquaredToSegment(p251, v.PreviousCFrame.Position, v.CFrame.Position) <= v254 * v254 then
                        return true;
                    end;
                end;
            end;

            return false;
        end,

        ResolveSupportMotion = function(p255) -- Line: 1004, Name: ResolveSupportMotion
            -- upvalues: MoverFrame (ref), u249 (copy)
            return MoverFrame.ResolveSupportMotion(u249, p255);
        end,

        CanOccupyAtEnd = function(p256, p257, p258) -- Line: 1007, Name: CanOccupyAtEnd
            -- upvalues: u250 (copy)
            return u250:CanMove(p257, p258, p256.Stance, nil, 1, 1);
        end
    }, nil;
end;

function u1.Compose(p259, p260) -- Line: 1014
    -- upvalues: compose (copy)
    return compose(p259, p260, false);
end;

local u261 = {};
u261.__index = u261;

function u261.ComposeTick(p262: any, p263: number, p264: boolean?) -- Line: 1021
    -- upvalues: u1 (copy)
    return u1.ComposeTick(p262._composer, p263, p264);
end;

function u261.Compose(p265, p266) -- Line: 1025
    -- upvalues: compose (copy)
    return compose(p265._composer, p266, true);
end;

function u1.ValidationView(p267) -- Line: 1030
    -- upvalues: u261 (copy)
    local _validationView = p267._validationView;

    if _validationView == nil then
        _validationView = setmetatable({
            _composer = p267
        }, u261);
        p267._validationView = _validationView;
    end;

    return _validationView;
end;

function u1.Destroy(p268) -- Line: 1039
    p268:Reset();
end;

return u1;