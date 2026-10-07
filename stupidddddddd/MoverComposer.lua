-- ReplicatedStorage.MovementV2.Client.MoverComposer
-- Script path: ReplicatedStorage.MovementV2.Client.MoverComposer
-- Decompile time: 32.83 ms

local CompositeWorld = require(script.Parent.Parent.Collision.CompositeWorld)
local Config = require(script.Parent.Parent.Config)
local DoorSwing = require(script.Parent.Parent.DoorSwing)
local Enums = require(script.Parent.Parent.Enums)
local MoverFrame = require(script.Parent.Parent.Collision.MoverFrame)
local MoverDescriptorCodec = require(script.Parent.Parent.MoverDescriptorCodec)
local MoverProxyCache = require(script.Parent.Parent.Collision.MoverProxyCache)
local MoverTrajectory = require(script.Parent.Parent.MoverTrajectory)
local Serial = require(script.Parent.Parent.Serial)
local Config_2 = require(script.Parent.Parent.Simulation.Config)
local u64 = {}
u64.__index = u64
local u67 = table.freeze({})

local function effectiveTick(a1) -- Line: 51
    return a1.EffectiveTick
end

local function earlierTick(a1, a2) -- Line: 55 -- upvalues: Serial (val) -- types: a1: number?, a2: number
    if a1 ~= nil and not ((Serial.deltaUInt32(a2, a1)) < 0) then
        return a1
    end
    return a2
end

local function nextRevision(a1) -- Line: 59 -- upvalues: Serial (val) -- types: a1: number
    if Serial.UInt32Max <= a1 then
        return 1
    end
    return a1 + 1
end

local function sameGeometry(a1, a2) -- Line: 63
    local v1 = false
    if a1.Id == a2.Id then
        v1 = false
        if a1.Size == a2.Size then
            v1 = false
            if a1.CollisionOffset == a2.CollisionOffset then
                v1 = false
                if a1.SurfaceFriction == a2.SurfaceFriction then
                    v1 = a1.Behavior == a2.Behavior
                end
            end
        end
    end
    return v1
end

local function sameCollisionDescriptor(a1, a2) -- Line: 72
    local v1 = false
    if a1.Id == a2.Id then
        v1 = false
        if a1.Size == a2.Size then
            v1 = false
            if a1.CollisionOffset == a2.CollisionOffset then
                v1 = false
                if a1.SurfaceFriction == a2.SurfaceFriction then
                    v1 = a1.Behavior == a2.Behavior
                end
            end
        end
    end
    if v1 then
        v1 = false
        if a1.StartPose == a2.StartPose then
            v1 = false
            if a1.TargetPose == a2.TargetPose then
                v1 = false
                if a1.EffectiveTick == a2.EffectiveTick then
                    v1 = false
                    if a1.StartTick == a2.StartTick then
                        v1 = false
                        if a1.DurationTicks == a2.DurationTicks then
                            v1 = false
                            if a1.Moving == a2.Moving then
                                v1 = false
                                if a1.Active == a2.Active then
                                    v1 = a1.Revision == a2.Revision
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

local function posesMatch(a1, a2) -- Line: 84 -- types: a1: userdata?, a2: userdata?
    if a1 ~= nil and a2 ~= nil then
        local v1
        if 1e-05 < (a1.Position - a2.Position).Magnitude then
            return false
        end
        _, v1 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
        return (math.abs(v1)) <= 1e-05
    end
    return a1 == a2
end

local function stanceBoundingRadius(a1) -- Line: 98 -- upvalues: Config_2 (val)
    local PlayerSizeDucking = if a1 ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
    return (PlayerSizeDucking * 0.5).Magnitude
end

local function distanceSquaredToSegment(a1, a2, a3) -- Line: 105 -- types: a1: vector, a2: vector, a3: vector
    local v1 = a3 - a2
    local v2 = v1:Dot(v1)
    if v2 <= 1e-12 then
        local v3 = a1 - a2
        return v3:Dot(v3)
    end
    local v4 = a1 - (a2 + v1 * math.clamp((a1 - a2):Dot(v1) / v2, 0, 1))
    return v4:Dot(v4)
end

local function recordMayAffectPosition(a1, a2, a3) -- Line: 117
    -- upvalues: Config_2 (val), distanceSquaredToSegment (val)
    local BoundingRadius = a1.BoundingRadius
    local PlayerSizeDucking = if a3 ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
    local v1 = BoundingRadius + (PlayerSizeDucking * 0.5).Magnitude + 0.25
    return (distanceSquaredToSegment(a2, a1.PreviousCFrame.Position, a1.CFrame.Position)) <= v1 * v1
end

local function descriptorMayAffectPosition(a1, a2, a3) -- Line: 122
    -- upvalues: Config_2 (val), distanceSquaredToSegment (val)
    local v1 = (a1.Size * 0.5).Magnitude + a1.CollisionOffset.Position.Magnitude
    local PlayerSizeDucking = if a3 ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
    local v2 = v1 + (PlayerSizeDucking * 0.5).Magnitude + 0.25
    return (distanceSquaredToSegment(a2, a1.StartPose.Position, a1.TargetPose.Position)) <= v2 * v2
end

local function appendDescriptor(a1, a2) -- Line: 132 -- upvalues: MoverTrajectory (val), u67 (val) -- types: a1: table
    local v1, v2 = MoverTrajectory.Validate(a2)
    if not v1 then
        return false, v2
    end
    local v3 = a1[a2.Id]
    if v3 == nil then
        v3 = {Descriptors = {}, Speculative = u67}
        a1[a2.Id] = v3
        v3.Descriptors[#v3.Descriptors + 1] = a2
        return true, nil
    end
    local v4 = v3.Descriptors[#v3.Descriptors]
    if v4 ~= nil then
        local v5 = false
        if v4.Id == a2.Id then
            v5 = false
            if v4.Size == a2.Size then
                v5 = false
                if v4.CollisionOffset == a2.CollisionOffset then
                    v5 = false
                    if v4.SurfaceFriction == a2.SurfaceFriction then
                        v5 = v4.Behavior == a2.Behavior
                    end
                end
            end
        end
        if not v5 then
            return false, "MoverGeometryChangedInsideRegistration"
        end
    end
    v3.Descriptors[#v3.Descriptors + 1] = a2
    return true, nil
end

local function resolve(a1, a2, a3) -- Line: 151 -- upvalues: Serial (val) -- types: a1: table, a2: number, a3: boolean?
    local v1 = nil
    for i, j in a1.Descriptors do
        if 0 <= (Serial.deltaUInt32(a2, j.EffectiveTick)) then
            v1 = j
        end
    end
    if a3 == true then
        for k, n in a1.Speculative do
            if 0 <= (Serial.deltaUInt32(a2, n.EffectiveTick)) then
                v1 = n
            end
        end
    end
    return v1
end

local function resolvePose(a1, a2, a3) -- Line: 169
    -- upvalues: resolve (val), MoverTrajectory (val)
    local v1 = resolve(a1, a2, a3)
    if v1 == nil then
        return nil, nil
    end
    return v1, MoverTrajectory.EvaluateTick(v1, a2)
end

local function predictedPose(a1, a2) -- Line: 178
    -- upvalues: resolve (val), MoverTrajectory (val)
    if a1 == nil then
        return nil
    end
    local v1 = resolve(a1, a2, true)
    if v1 ~= nil and v1.Active then
        return MoverTrajectory.EvaluateTick(v1, a2)
    end
    return nil
end

local function firstPoseDifference(a1, a2, a3, a4) -- Line: 190
    -- upvalues: Serial (val), resolve (val), MoverTrajectory (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = Serial.deltaUInt32(a4, a3)
    if v7 < 0 then
        return nil
    end
    if v7 > 1024 then
        a3 = Serial.addUInt32(a4, -1024)
        v7 = 1024
    end
    local v8, v9 = a1, a2
    for i = 0, v7 do
        v5 = Serial.addUInt32(a3, i)
        if v8 ~= nil then
            v2 = resolve(v8, v5, true)
            v1 = if v2 == nil then nil else if v2.Active then MoverTrajectory.EvaluateTick(v2, v5) else nil
        else
            v1 = nil
        end
        if v9 ~= nil then
            v3 = resolve(v9, v5, true)
            v2 = if v3 == nil then nil else if v3.Active then MoverTrajectory.EvaluateTick(v3, v5) else nil
        else
            v2 = nil
        end
        if v1 == nil or v2 == nil then
            v6 = v1 == v2
        elseif not (1e-05 < (v1.Position - v2.Position).Magnitude) then
            _, v4 = v1.Rotation:ToObjectSpace(v2.Rotation):ToAxisAngle()
            v6 = (math.abs(v4)) <= 1e-05
        else
            v6 = false
        end
        if not v6 then
            return v5
        end
    end
    return nil
end

local function changeTick(a1) -- Line: 208 -- types: a1: table
    return a1.AffectedTick
end

local function pruneByAge(a1, a2, a3, a4) -- Line: 213
    -- upvalues: Serial (val)
    local v1
    if #a1 < 2 then
        return
    end
    local v2 = nil
    for i, j in a1 do
        if a4 < Serial.deltaUInt32(a3, a2(j)) then
            v2 = i
        end
    end
    local v3 = 1
    local v4 = nil
    local v5 = nil
    local v6, v7, v8, v9 = a1, a3, a2, a4
    for k, n in a1, v4, v5 do
        v1 = Serial.deltaUInt32(v7, v8(n))
        if k == v2 or v1 < 0 or v1 <= v9 then
            v6[v3] = n
            v3 = v3 + 1
        end
    end
    for m = #v6, v3, -1 do
        v6[m] = nil
    end
end

local function pruneAll(a1, a2, a3) -- Line: 237
    -- upvalues: pruneByAge (val), changeTick (val), effectiveTick (val)
    pruneByAge(a1._revisionChanges, changeTick, a2, a3)
    for i, j in a1._tracks do
        pruneByAge(j.Descriptors, effectiveTick, a2, a3)
    end
end

local function cloneTrack(a1) -- Line: 244 -- types: a1: table
    return {Descriptors = table.clone(a1.Descriptors), Speculative = a1.Speculative}
end

local function cloneTracks(a1) -- Line: 252 -- types: a1: table
    local v1
    local v2 = {}
    for i, j in a1 do
        v1 = {Descriptors = table.clone(j.Descriptors), Speculative = j.Speculative}
        v2[i] = v1
    end
    return v2
end

local function publishSpeculation(a1, a2, a3) -- Line: 261
    -- upvalues: MoverTrajectory (val)
    if a1._replaySource ~= nil then
        return
    end
    local v1 = a3.Speculative[#a3.Speculative]
    if v1 ~= nil then
        MoverTrajectory.InstallClientSpeculativeDescriptor(v1)
        return
    end
    MoverTrajectory.ClearClientSpeculativeDescriptor(a2)
end

local function commitStagedRevision(a1, a2, a3, a4, a5) -- Line: 274
    -- upvalues: pruneAll (val)
    a1._tracks = a2
    a1._revision = a3
    a1._latestCommitTick = a4
    a1._revisionChanges[#a1._revisionChanges + 1] = {Revision = a3, AffectedTick = a5}
    local _horizonTicks = a1._horizonTicks
    if _horizonTicks ~= nil then
        pruneAll(a1, a4, _horizonTicks)
    end
end

local function compareId(a1, a2) -- Line: 294
    return a1.Id < a2.Id
end

local function validateHeader(a1, a2, a3) -- Line: 298 -- upvalues: Serial (val)
    if not Serial.isNonZeroUInt16(a1) then
        return false, "InvalidMoverEpoch"
    end
    if not Serial.isUInt32(a2) then
        return false, "InvalidMoverRevision"
    end
    if not Serial.isUInt32(a3) then
        return false, "InvalidMoverServerTick"
    end
    return true, nil
end

local function checkNextRevision(a1, a2, a3, a4) -- Line: 312 -- upvalues: Serial (val)
    local _epoch = a1._epoch
    local _revision = a1._revision
    if _epoch ~= nil and _revision ~= nil then
        if a2 ~= _epoch then
            return false, "MoverEpochMismatch"
        end
        local v1 = Serial.deltaUInt32(a3, _revision)
        if v1 <= 0 then
            return false, nil
        end
        if v1 ~= 1 then
            return false, "MoverRevisionGap"
        end
        if (Serial.deltaUInt32(a4, (assert(a1._latestCommitTick)))) < 0 then
            return false, "MoverCommitTickRegressed"
        end
        return true, nil
    end
    return false, "MoverBaselineRequired"
end

function u64.new() -- Line: 335 -- upvalues: MoverProxyCache (val), u64 (val)
    return (setmetatable({_tracks = {}, _revisionChanges = {}, _proxyCache = MoverProxyCache.new()}, u64))
end

function u64:ForkPrediction() -- Line: 344 -- upvalues: u64 (val)
    local _tracks_2, v1
    local v2 = u64.new()
    v2._replaySource = self
    local _epoch = self._epoch
    local _revision = self._revision
    v2._epoch = _epoch
    v2._revision = _revision
    local _baselineServerTick = self._baselineServerTick
    local _latestCommitTick = self._latestCommitTick
    v2._baselineServerTick = _baselineServerTick
    v2._latestCommitTick = _latestCommitTick
    v2._revisionChanges = table.clone(self._revisionChanges)
    local _horizonHz = self._horizonHz
    local _horizonTicks = self._horizonTicks
    v2._horizonHz = _horizonHz
    v2._horizonTicks = _horizonTicks
    v2._lastComposedTick = self._lastComposedTick
    for i, j in self._tracks do
        _tracks_2 = v2._tracks
        v1 = {Descriptors = table.clone(j.Descriptors), Speculative = j.Speculative}
        _tracks_2[i] = v1
        v2._proxyCache:ReserveContactMover(i)
    end
    return v2
end

function u64.ForkControls(a1) -- Line: 359
    local v1 = a1:ForkPrediction()
    v1._controlsFork = true
    return v1
end

function u64.AdoptReplay(a1, a2, a3) -- Line: 366
    local v1 = false
    if a2._replaySource == a3 then
        v1 = a3._replaySource == a1
    end
    assert(v1, "unrelated mover replay")
    v1 = false
    if a1._epoch == a2._epoch then
        v1 = a1._revision == a2._revision
    end
    assert(v1, "mover controls not committed")
    a2._replaySource = a1
end

local function syncReplaySpeculation(a1) -- Line: 372
    local _replaySource = a1._replaySource
    if _replaySource ~= nil and not a1._controlsFork then
        local v1
        for i, j in a1._tracks do
            v1 = _replaySource._tracks[i]
            if v1 ~= nil and j.Speculative ~= v1.Speculative then
                j.Speculative = v1.Speculative
            end
        end
        return
    end
end

local function installPresentation(a1, a2) -- Line: 386
    -- upvalues: Serial (val), resolve (val), MoverTrajectory (val)
    local v1, v2, v3, v4
    local v5 = Serial.addUInt32(a2, -1)
    local v6 = {}
    local v7 = nil
    local v8 = nil
    local v9 = a2
    for i, j in a1._tracks, v7, v8 do
        v2 = resolve(j, v9, true)
        if v2 ~= nil then
            v4 = v2
            v1 = MoverTrajectory.EvaluateTick(v2, v9)
        else
            v4 = nil
            v1 = nil
        end
        if v4 ~= nil and v1 ~= nil and v4.Active then
            v3 = resolve(j, v5, true)
            MoverTrajectory.InstallClientResolvedPose(v4, v9, (if v3 ~= nil then MoverTrajectory.EvaluateTick(v3, v5) else nil) or v1, v1)
        end
        v2 = nil
        for k, n in j.Descriptors do
            if 0 <= (Serial.deltaUInt32(v9, n.EffectiveTick)) then
                v2 = n
            end
        end
        if v2 ~= nil then
            v6[#v6 + 1] = v2
        end
    end
    MoverTrajectory.InstallClientResolved(v9, v6)
end

function u64.CommitPrediction(a1, a2) -- Line: 403 -- upvalues: Serial (val), installPresentation (val)
    assert(a2._replaySource == a1, "mover replay belongs to a different composer")
    local v1 = false
    if a1._epoch == a2._epoch then
        v1 = a1._revision == a2._revision
    end
    assert(v1, "mover controls changed during replay")
    local _lastComposedTick = a2._lastComposedTick
    local _lastComposedTick_2 = a1._lastComposedTick
    if _lastComposedTick == nil then
        return
    end
    if _lastComposedTick_2 ~= nil and (Serial.deltaUInt32(_lastComposedTick, _lastComposedTick_2)) <= 0 then
        return
    end
    a1._lastComposedTick = _lastComposedTick
    if a1._replaySource == nil then
        installPresentation(a1, _lastComposedTick)
    end
end

function u64.Revision(a1) -- Line: 419
    return a1._revision
end

function u64:Reset() -- Line: 423 -- upvalues: MoverTrajectory (val)
    table.clear(self._tracks)
    self._epoch = nil
    self._revision = nil
    self._baselineServerTick = nil
    self._latestCommitTick = nil
    self._lastComposedTick = nil
    table.clear(self._revisionChanges)
    self._horizonHz = nil
    self._horizonTicks = nil
    self._proxyCache:Reset()
    if self._replaySource == nil then
        MoverTrajectory.ResetClientDescriptors()
    end
end

function u64.IsPredictionStateAffected(a1, a2, a3, a4) -- Line: 439
    -- upvalues: Enums (val), Config_2 (val), distanceSquaredToSegment (val)
    if type(a4) == "table" and a4.Kind == Enums.SupportKind.Mover and a2[a4.SourceId] == true then
        return true
    end
    if type(a3) == "table" and typeof(a3.Position) == "Vector3" then
        local PlayerSizeDucking, PlayerSizeDucking_2, Position_2, Position_3, Stance, Stance_2, v1, v2, v3, v4, v5
        local v6 = nil
        local v7 = nil
        local v8, v9 = a1, a3
        for i in a2, v6, v7 do
            v5 = v8._tracks[i]
            if v5 == nil then
                return true
            end
            v1 = nil
            v2 = nil
            for j, k in v5.Descriptors, v1, v2 do
                Position_3 = v9.Position
                Stance_2 = v9.Stance
                v4 = (k.Size * 0.5).Magnitude + k.CollisionOffset.Position.Magnitude
                PlayerSizeDucking_2 = if Stance_2 ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
                v3 = v4 + (PlayerSizeDucking_2 * 0.5).Magnitude + 0.25
                if (distanceSquaredToSegment(Position_3, k.StartPose.Position, k.TargetPose.Position)) <= v3 * v3 then
                    return true
                end
            end
            v1 = nil
            v2 = nil
            for n, m in v5.Speculative, v1, v2 do
                Position_2 = v9.Position
                Stance = v9.Stance
                v4 = (m.Size * 0.5).Magnitude + m.CollisionOffset.Position.Magnitude
                PlayerSizeDucking = if Stance ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
                v3 = v4 + (PlayerSizeDucking * 0.5).Magnitude + 0.25
                if (distanceSquaredToSegment(Position_2, m.StartPose.Position, m.TargetPose.Position)) <= v3 * v3 then
                    return true
                end
            end
        end
        return false
    end
    return true
end

function u64.PredictDoorUse(a1, a2, a3, a4, a5) -- Line: 471
    -- upvalues: Serial (val), MoverTrajectory (val), resolve (val), DoorSwing (val), MoverDescriptorCodec (val)
    if Serial.isUInt32(a4) and a5 % 1 == 0 and not (a5 <= 0) then
        local Attribute = a2:GetAttribute(MoverTrajectory.Attributes.Id)
        if Serial.isUInt32(Attribute) and Attribute ~= 0 then
            local TargetPose, v1
            local v2 = a1._tracks[Attribute]
            if v2 == nil then
                return nil, "MoverDoorTrackUnavailable"
            end
            local v3 = resolve(v2, a4, true)
            if v3 ~= nil then
                v1 = v3
                TargetPose = MoverTrajectory.EvaluateTick(v3, a4)
            else
                v1 = nil
                TargetPose = nil
            end
            if v1 ~= nil and TargetPose ~= nil and v1.Active then
                local Attribute_2, Magnitude, OpenAngle, Position, Position_2, v4, v5, v6, v7, v8, v9, v10, v11, v12
                local Revision = v1.Revision
                v3 = if not (Serial.UInt32Max <= Revision) then Revision + 1 else 1
                if not v1.Moving then
                    Attribute_2 = a2:GetAttribute("DoorClosedPivot")
                    if typeof(Attribute_2) ~= "CFrame" then
                        return nil, "MoverDoorClosedPoseUnavailable"
                    end
                    _, v4 = Attribute_2:ToObjectSpace(TargetPose):ToOrientation()
                    OpenAngle = DoorSwing.OpenAngle
                    if not (DoorSwing.ClosedAngleEpsilon <= (math.abs(v4))) then
                        Position = (Attribute_2 * CFrame.Angles(0, OpenAngle, 0) * v1.CollisionOffset).Position
                        Position_2 = (Attribute_2 * CFrame.Angles(0, -OpenAngle, 0) * v1.CollisionOffset).Position
                        Magnitude = (Position - a3).Magnitude
                        v5 = if not ((Position_2 - a3).Magnitude <= Magnitude) then -OpenAngle else OpenAngle
                    else
                        v5 = 0
                    end
                    v6 = math.abs(v5 - v4)
                    if v6 < DoorSwing.TargetEpsilon then
                        return nil, "MoverDoorTargetAlreadyReached"
                    end
                    v7 = math.max(1, (math.ceil((DoorSwing.durationSeconds(v6)) * a5)))
                    v8 = Serial.addUInt32(a4, 1)
                    v9, v10 = MoverDescriptorCodec.canonicalize({
                        Moving = true,
                        Active = true,
                        Id = v1.Id,
                        Size = v1.Size,
                        CollisionOffset = v1.CollisionOffset,
                        SurfaceFriction = v1.SurfaceFriction,
                        StartPose = TargetPose,
                        TargetPose = Attribute_2 * CFrame.Angles(0, v5, 0),
                        EffectiveTick = v8,
                        StartTick = Serial.addUInt32(v8, 1),
                        DurationTicks = v7,
                        StartServerTime = workspace:GetServerTimeNow(),
                        DurationSeconds = v7 / a5,
                        Behavior = v1.Behavior,
                        Revision = v3,
                    })
                    if v9 == nil then
                        return nil, v10
                    end
                    v11 = table.clone(v2.Speculative)
                    v11[#v11 + 1] = v9
                    v2.Speculative = table.freeze(v11)
                    if a1._replaySource == nil then
                        v12 = v2.Speculative[#v2.Speculative]
                        if v12 == nil then
                            MoverTrajectory.ClearClientSpeculativeDescriptor(Attribute)
                        else
                            MoverTrajectory.InstallClientSpeculativeDescriptor(v12)
                        end
                    end
                    return {ServerTick = v8, TargetAngle = v5, MoverId = Attribute, Revision = v3}, nil
                end
                local v13 = MoverTrajectory.TickAlpha(v1, a4)
                if not (v13 < 1) then
                    v13 = #v2.Speculative
                    if not (v13 >= 2) then
                        v13 = v3
                        v3 = if not (Serial.UInt32Max <= v13) then v13 + 1 else 1
                        TargetPose = v1.TargetPose
                        Attribute_2 = a2:GetAttribute("DoorClosedPivot")
                        if typeof(Attribute_2) ~= "CFrame" then
                            return nil, "MoverDoorClosedPoseUnavailable"
                        end
                        _, v4 = Attribute_2:ToObjectSpace(TargetPose):ToOrientation()
                        OpenAngle = DoorSwing.OpenAngle
                        if not (DoorSwing.ClosedAngleEpsilon <= (math.abs(v4))) then
                            Position = (Attribute_2 * CFrame.Angles(0, OpenAngle, 0) * v1.CollisionOffset).Position
                            Position_2 = (Attribute_2 * CFrame.Angles(0, -OpenAngle, 0) * v1.CollisionOffset).Position
                            Magnitude = (Position - a3).Magnitude
                            v5 = if not ((Position_2 - a3).Magnitude <= Magnitude) then -OpenAngle else OpenAngle
                        else
                            v5 = 0
                        end
                        v6 = math.abs(v5 - v4)
                        if v6 < DoorSwing.TargetEpsilon then
                            return nil, "MoverDoorTargetAlreadyReached"
                        end
                        v7 = math.max(1, (math.ceil((DoorSwing.durationSeconds(v6)) * a5)))
                        v8 = Serial.addUInt32(a4, 1)
                        v9, v10 = MoverDescriptorCodec.canonicalize({
                            Moving = true,
                            Active = true,
                            Id = v1.Id,
                            Size = v1.Size,
                            CollisionOffset = v1.CollisionOffset,
                            SurfaceFriction = v1.SurfaceFriction,
                            StartPose = TargetPose,
                            TargetPose = Attribute_2 * CFrame.Angles(0, v5, 0),
                            EffectiveTick = v8,
                            StartTick = Serial.addUInt32(v8, 1),
                            DurationTicks = v7,
                            StartServerTime = workspace:GetServerTimeNow(),
                            DurationSeconds = v7 / a5,
                            Behavior = v1.Behavior,
                            Revision = v3,
                        })
                        if v9 == nil then
                            return nil, v10
                        end
                        v11 = table.clone(v2.Speculative)
                        v11[#v11 + 1] = v9
                        v2.Speculative = table.freeze(v11)
                        if a1._replaySource == nil then
                            v12 = v2.Speculative[#v2.Speculative]
                            if v12 == nil then
                                MoverTrajectory.ClearClientSpeculativeDescriptor(Attribute)
                            else
                                MoverTrajectory.InstallClientSpeculativeDescriptor(v12)
                            end
                        end
                        return {ServerTick = v8, TargetAngle = v5, MoverId = Attribute, Revision = v3}, nil
                    end
                end
                return nil, "MoverDoorAlreadyMoving"
            end
            return nil, "MoverDoorPoseUnavailable"
        end
        return nil, "MoverDoorIdentityUnavailable"
    end
    return nil, "MoverDoorPredictionClockInvalid"
end

function u64.RejectDoorUse(a1, a2, a3) -- Line: 566
    -- upvalues: Serial (val), u67 (val), MoverTrajectory (val)
    if Serial.isUInt32(a2) and a2 ~= 0 and Serial.isUInt32(a3) and a3 ~= 0 then
        local v1, v2
        local v3 = a1._tracks[a2]
        if v3 == nil then
            return nil, nil
        end
        for i, j in v3.Speculative do
            if j.Revision == a3 then
                v2 = table.move(v3.Speculative, 1, i - 1, 1, {})
                v3.Speculative = if #v2 ~= 0 then table.freeze(v2) else u67
                if a1._replaySource == nil then
                    v1 = v3.Speculative[#v3.Speculative]
                    if v1 == nil then
                        MoverTrajectory.ClearClientSpeculativeDescriptor(a2)
                    else
                        MoverTrajectory.InstallClientSpeculativeDescriptor(v1)
                    end
                end
                return j.EffectiveTick, nil
            end
        end
        return nil, nil
    end
    return nil, "MoverDoorRejectionIdentityInvalid"
end

local function equivalentBaseline(a1, a2, a3) -- Line: 587
    -- upvalues: Serial (val), sameCollisionDescriptor (val)
    local Active, v1, v2, v3, v4, v5, v6, v7, v8
    for i in a3 do
        if a1._tracks[i] == nil then
            return false
        end
    end
    local v9 = nil
    local v10 = nil
    for j, k in a1._tracks, v9, v10 do
        v7 = a3[j]
        v8 = nil
        for n, m in k.Descriptors do
            if 0 <= (Serial.deltaUInt32(v1, m.EffectiveTick)) then
                v8 = n
            end
        end
        v2 = 0
        v3 = nil
        v4 = nil
        for i5, i6 in k.Descriptors, v3, v4 do
            Active = false
            if i5 == v8 then
                Active = i6.Active
            end
            if v8 == nil or v8 < i5 then
                v5 = Serial.deltaUInt32(i6.EffectiveTick, v1)
                if v5 > 0 then
                    v5 = k.Descriptors[i5 + 1]
                    v6 = true
                    if v5 ~= nil then
                        v6 = v5.EffectiveTick ~= i6.EffectiveTick
                    end
                    Active = v6
                end
            end
            if Active then
                v2 = v2 + 1
                v5 = if not v7 then nil else v7.Descriptors[v2]
                if v5 ~= nil
                    and sameCollisionDescriptor(i6, v5)
                    and i6.StartServerTime == v5.StartServerTime
                    and i6.DurationSeconds == v5.DurationSeconds then
                    continue
                end
                return false
            end
        end
        if (if not v7 then 0 else #v7.Descriptors) ~= v2 then
            return false
        end
    end
    return true
end

function u64.ConsumeBaseline(a1, a2, a3, a4, a5, a6) -- Line: 631
    -- upvalues: Serial (val), appendDescriptor (val), equivalentBaseline (val), pruneAll (val), MoverTrajectory (val)
    local _horizonTicks, _latestCommitTick, v1, v2, v3, v4, v5
    if not Serial.isNonZeroUInt16(a2) then
        v3 = false
        v4 = "InvalidMoverEpoch"
    elseif not Serial.isUInt32(a3) then
        v3 = false
        v4 = "InvalidMoverRevision"
    elseif Serial.isUInt32(a4) then
        v3 = true
        v4 = nil
    else
        v3 = false
        v4 = "InvalidMoverServerTick"
    end
    if not v3 then
        return false, v4
    end
    if type(a5) ~= "table" then
        return false, "MoverDescriptorsNotTable"
    end
    if a6 == nil then
        v5 = {}
        for n, m in a5 do
            v1, v2 = appendDescriptor(v5, m)
            if not v1 then
                return false, v2
            end
        end
        if a1._epoch == a2 and a1._revision == a3 and equivalentBaseline(a1, a4, v5) then
            _latestCommitTick = a1._latestCommitTick
            if _latestCommitTick ~= nil and 0 < (Serial.deltaUInt32(a4, _latestCommitTick)) then
                a1._latestCommitTick = a4
            end
            _horizonTicks = a1._horizonTicks
            if _horizonTicks ~= nil then
                pruneAll(a1, assert(a1._latestCommitTick), _horizonTicks)
            end
            return true, nil, nil, nil, false
        end
        a1._tracks = v5
        a1._proxyCache:Reset()
        for i5 in v5 do
            a1._proxyCache:ReserveContactMover(i5)
        end
        a1._epoch = a2
        a1._revision = a3
        a1._baselineServerTick = a4
        a1._latestCommitTick = a4
        a1._revisionChanges = {{Revision = a3, AffectedTick = a4}}
        if a1._replaySource == nil then
            MoverTrajectory.InstallClientBaseline(a5, a4)
        end
        return true, nil, nil, nil, true
    end
    if type(a6) == "table" and next(a6) == nil then
        v5 = {}
        for i, j in a5 do
            v1, v2 = appendDescriptor(v5, j)
            if not v1 then
                return false, v2
            end
        end
        if a1._epoch == a2 and a1._revision == a3 and equivalentBaseline(a1, a4, v5) then
            _latestCommitTick = a1._latestCommitTick
            if _latestCommitTick ~= nil and 0 < (Serial.deltaUInt32(a4, _latestCommitTick)) then
                a1._latestCommitTick = a4
            end
            _horizonTicks = a1._horizonTicks
            if _horizonTicks ~= nil then
                pruneAll(a1, assert(a1._latestCommitTick), _horizonTicks)
            end
            return true, nil, nil, nil, false
        end
        a1._tracks = v5
        a1._proxyCache:Reset()
        for k in v5 do
            a1._proxyCache:ReserveContactMover(k)
        end
        a1._epoch = a2
        a1._revision = a3
        a1._baselineServerTick = a4
        a1._latestCommitTick = a4
        a1._revisionChanges = {{Revision = a3, AffectedTick = a4}}
        if a1._replaySource == nil then
            MoverTrajectory.InstallClientBaseline(a5, a4)
        end
        return true, nil, nil, nil, true
    end
    return false, "MoverProgressUnsupported"
end

local function settleSpeculation(a1, a2) -- Line: 686
    -- upvalues: Serial (val), sameCollisionDescriptor (val), u67 (val)
    local EffectiveTick, v1
    local Speculative = a1.Speculative
    if #Speculative == 0 then
        return a2
    end
    local Revision = a1.Descriptors[#a1.Descriptors].Revision
    local v2 = {}
    local v3 = false
    local v4 = nil
    local v5 = nil
    local v6, v7 = a1, a2
    for i, j in Speculative, v4, v5 do
        if v3 then
            if not v3 then
                v1 = false
                for k, n in v6.Descriptors do
                    if n.Revision == j.Revision then
                        v1 = sameCollisionDescriptor(j, n)
                    end
                end
            end
            v1 = v7
            EffectiveTick = j.EffectiveTick
            v7 = if v1 == nil then EffectiveTick else if not ((Serial.deltaUInt32(EffectiveTick, v1)) < 0) then v1 else EffectiveTick
        else
            v1 = Serial.deltaUInt32(Revision, j.Revision)
            if not (v1 < 0) then
                if not v3 then
                    v1 = false
                    for m, i5 in v6.Descriptors do
                        if i5.Revision == j.Revision then
                            v1 = sameCollisionDescriptor(j, i5)
                        end
                    end
                end
                v1 = v7
                EffectiveTick = j.EffectiveTick
                v7 = if v1 == nil then EffectiveTick else if not ((Serial.deltaUInt32(EffectiveTick, v1)) < 0) then v1 else EffectiveTick
            else
                v2[#v2 + 1] = j
            end
        end
    end
    if #v2 ~= #Speculative then
        v6.Speculative = if #v2 ~= 0 then table.freeze(v2) else u67
    end
    return v7
end

function u64.ConsumeDelta(a1, a2, a3, a4, a5) -- Line: 717
    -- upvalues: Serial (val), checkNextRevision (val), cloneTracks (val), appendDescriptor (val)
    -- upvalues: settleSpeculation (val), firstPoseDifference (val), commitStagedRevision (val), MoverTrajectory (val)
    local v1, v2
    if not Serial.isNonZeroUInt16(a2) then
        v1 = false
        v2 = "InvalidMoverEpoch"
    elseif not Serial.isUInt32(a3) then
        v1 = false
        v2 = "InvalidMoverRevision"
    elseif Serial.isUInt32(a4) then
        v1 = true
        v2 = nil
    else
        v1 = false
        v2 = "InvalidMoverServerTick"
    end
    if not v1 then
        return nil, v2, false
    end
    local v3, v4 = checkNextRevision(a1, a2, a3, a4)
    if not v3 then
        return nil, v4, false
    end
    if type(a5) == "table" and #a5 ~= 0 then
        local EffectiveTick, Id, v5, v6, v7, v8, v9
        local v10 = cloneTracks(a1._tracks)
        local v11 = {}
        local v12 = {}
        local v13 = nil
        local v14 = nil
        local v15, v16, v17, v18 = a1, a3, a4, a5
        for i, j in a5, v13, v14 do
            v5, v6 = appendDescriptor(v10, j)
            if not v5 then
                return nil, v6, false
            end
            v12[j.Id] = true
            Id = j.Id
            v8 = v11[j.Id]
            EffectiveTick = j.EffectiveTick
            v11[Id] = if v8 == nil then EffectiveTick else if not ((Serial.deltaUInt32(EffectiveTick, v8)) < 0) then v8 else EffectiveTick
        end
        local v19 = nil
        v13 = nil
        local _lastComposedTick = v15._lastComposedTick
        local v20 = nil
        v5 = nil
        for k in v12, v20, v5 do
            v7 = settleSpeculation(v10[k], v11[k])
            v8 = v19
            v19 = if v8 == nil then v7 else if not ((Serial.deltaUInt32(v7, v8)) < 0) then v8 else v7
            if _lastComposedTick ~= nil then
                v8 = firstPoseDifference(v15._tracks[k], v10[k], v7, _lastComposedTick)
                if v8 ~= nil then
                    v9 = v13
                    v13 = if v9 == nil then v8 else if not ((Serial.deltaUInt32(v8, v9)) < 0) then v9 else v8
                end
            else
                v8 = v13
                v13 = if v8 == nil then v7 else if not ((Serial.deltaUInt32(v7, v8)) < 0) then v8 else v7
            end
        end
        commitStagedRevision(v15, v10, v16, v17, assert(v19))
        for n in v12 do
            v15._proxyCache:ReserveContactMover(n)
        end
        if v15._replaySource == nil then
            MoverTrajectory.InstallClientDelta(v18, v17)
            for m in v12 do
                v7 = v15._tracks[m]
                if v15._replaySource == nil then
                    v8 = v7.Speculative[#v7.Speculative]
                    if v8 == nil then
                        MoverTrajectory.ClearClientSpeculativeDescriptor(m)
                    else
                        MoverTrajectory.InstallClientSpeculativeDescriptor(v8)
                    end
                end
            end
        end
        return v13, nil, v13 == nil, v12
    end
    return nil, "MoverDeltaEmpty", false
end

function u64.ConsumeProgress(a1, a2, a3, a4, a5) -- Line: 780 -- upvalues: Serial (val)
    local v1, v2
    if not Serial.isNonZeroUInt16(a2) then
        v1 = false
        v2 = "InvalidMoverEpoch"
    elseif not Serial.isUInt32(a3) then
        v1 = false
        v2 = "InvalidMoverRevision"
    elseif Serial.isUInt32(a4) then
        v1 = true
        v2 = nil
    else
        v1 = false
        v2 = "InvalidMoverServerTick"
    end
    if not v1 then
        return nil, v2, false
    end
    return nil, "MoverProgressUnsupported", false
end

function u64.ComposeTick(a1, a2, a3) -- Line: 795 -- upvalues: Serial (val) -- types: a2: number, a3: boolean?
    local _baselineServerTick = a1._baselineServerTick
    if a3 == true
        and _baselineServerTick ~= nil
        and Serial.isUInt32(a2)
        and (Serial.deltaUInt32(a2, _baselineServerTick)) < 0 then
        return _baselineServerTick
    end
    return a2
end

local function predictLocalHold(a1, a2, a3, a4, a5, a6, a7) -- Line: 809
    -- upvalues: Config_2 (val), distanceSquaredToSegment (val), MoverFrame (val), MoverTrajectory (val)
    -- upvalues: MoverDescriptorCodec (val), Serial (val)
    local ContactState = a7.ContactState
    if ContactState ~= nil and a3.Behavior == "StopOnBlock" and a3.Moving and a4 ~= a5 then
        local Position = ContactState.Position
        local Stance = ContactState.Stance
        local v1 = (a3.Size * 0.5).Magnitude + a3.CollisionOffset.Position.Magnitude
        local PlayerSizeDucking = if Stance ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
        local v2 = v1 + (PlayerSizeDucking * 0.5).Magnitude + 0.25
        local v3 = (distanceSquaredToSegment(Position, a3.StartPose.Position, a3.TargetPose.Position)) <= v2 * v2
        if v3 then
            v3 = MoverFrame.Build(a7.StepSeconds, {
                {
                    Id = a3.Id,
                    PreviousCFrame = MoverTrajectory.CollisionPose(a3, a4),
                    CFrame = MoverTrajectory.CollisionPose(a3, a5),
                    Size = a3.Size,
                    SurfaceFriction = a3.SurfaceFriction,
                },
            })
            local v4 = {Id = 0, Position = ContactState.Position, Stance = ContactState.Stance}
            local Config = a7.StaticWorld.Topology.Config
            local _proxyCache = a1._proxyCache
            v1 = v3.ById[a3.Id]
            local v5 = {v4}
            if _proxyCache:FindEarliestStationaryContact(v1, v5, Config) == nil then
                return nil, nil
            end
            local canonicalize = MoverDescriptorCodec.canonicalize
            local v6 = {
                DurationTicks = 0,
                DurationSeconds = 0,
                Moving = false,
                Active = true,
                Id = a3.Id,
                Size = a3.Size,
                CollisionOffset = a3.CollisionOffset,
                SurfaceFriction = a3.SurfaceFriction,
                StartPose = a4,
                TargetPose = a4,
                EffectiveTick = a6,
                StartTick = a6,
                StartServerTime = workspace:GetServerTimeNow(),
                Behavior = a3.Behavior,
            }
            local Revision = a3.Revision
            v6.Revision = if not (Serial.UInt32Max <= Revision) then Revision + 1 else 1
            v2 = canonicalize(v6)
            if v2 == nil then
                return nil, nil
            end
            v6 = table.clone(a2.Speculative)
            v6[#v6 + 1] = v2
            a2.Speculative = table.freeze(v6)
            local Id = a3.Id
            if a1._replaySource == nil then
                v5 = a2.Speculative[#a2.Speculative]
                if v5 == nil then
                    MoverTrajectory.ClearClientSpeculativeDescriptor(Id)
                else
                    MoverTrajectory.InstallClientSpeculativeDescriptor(v5)
                end
            end
            return v2, MoverTrajectory.EvaluateTick(v2, a6)
        end
    end
    return nil, nil
end

local function compose(a1, a2, a3) -- Line: 871
    -- upvalues: syncReplaySpeculation (val), Serial (val), u64 (val), Config (val), pruneByAge (val), changeTick (val)
    -- upvalues: resolve (val), MoverTrajectory (val), effectiveTick (val), predictLocalHold (val), compareId (val)
    -- upvalues: MoverFrame (val), CompositeWorld (val), Config_2 (val), distanceSquaredToSegment (val)
    syncReplaySpeculation(a1)
    local ServerTick = a2.ServerTick
    local PreviousServerTick = a2.PreviousServerTick
    local StepSeconds = a2.StepSeconds
    if Serial.isUInt32(ServerTick) and Serial.isUInt32(PreviousServerTick) then
        local _revision = a1._revision
        local _baselineServerTick = a1._baselineServerTick
        if _revision ~= nil and _baselineServerTick ~= nil then
            local v1, v2, v3, v4, v5, v6, v7
            if a2.Mapping.TopologyEpoch ~= a1._epoch then
                return nil, "MoverEpochMismatch"
            end
            if (Serial.deltaUInt32(ServerTick, _baselineServerTick)) < 0 and a2.Speculative ~= true then
                return nil, "MoverFrameOutsideRetention"
            end
            local v8 = u64.ComposeTick(a1, ServerTick, a2.Speculative)
            if v8 ~= ServerTick then
                ServerTick = v8
                PreviousServerTick = v8
            end
            local SimulationHz = a2.Mapping.SimulationHz
            if a1._horizonHz ~= SimulationHz then
                a1._horizonHz = SimulationHz
                a1._horizonTicks = Config.derive(SimulationHz).PredictionReplayTicks
            end
            local v9 = assert(a1._horizonTicks)
            local v10 = assert(a1._latestCommitTick)
            pruneByAge(a1._revisionChanges, changeTick, v10, v9)
            local MoverRevision = a2.MoverRevision
            if MoverRevision ~= nil then
                if not Serial.isUInt32(MoverRevision) then
                    return nil, "MoverRevisionInvalid"
                end
                if _revision ~= MoverRevision then
                    v1 = false
                    for i, j in a1._revisionChanges do
                        if j.Revision == MoverRevision then
                            v1 = true
                        elseif v1 and 0 <= (Serial.deltaUInt32(ServerTick, j.AffectedTick)) then
                            return nil, "MoverRevisionUnavailable"
                        end
                    end
                    if not v1 then
                        return nil, "MoverRevisionUnavailable"
                    end
                end
            end
            v1 = not a3 and a1._replaySource == nil
            local v11 = {}
            local v12 = {}
            local v13 = {}
            local _tracks = a1._tracks
            local v14 = nil
            local v15 = nil
            local v16, v17, v18 = a1, a3, a2
            for k, n in _tracks, v14, v15 do
                v5 = resolve(n, ServerTick, true)
                if v5 ~= nil then
                    v2 = v5
                    v3 = MoverTrajectory.EvaluateTick(v5, ServerTick)
                else
                    v2 = nil
                    v3 = nil
                end
                pruneByAge(n.Descriptors, effectiveTick, v10, v9)
                if v2 ~= nil then
                    if v1 then
                        v4 = nil
                        for m, i5 in n.Descriptors do
                            if 0 <= (Serial.deltaUInt32(ServerTick, i5.EffectiveTick)) then
                                v4 = i5
                            end
                        end
                        if v4 ~= nil then
                            v12[#v12 + 1] = v4
                        end
                    end
                    if v2.Active then
                        v7 = resolve(n, PreviousServerTick, true)
                        v5 = if v7 ~= nil then MoverTrajectory.EvaluateTick(v7, PreviousServerTick) else nil
                        if v5 == nil and v3 ~= nil and v2.EffectiveTick == ServerTick then
                            v5 = v3
                        end
                        if v5 ~= nil and v3 ~= nil then
                            if v1 then
                                v6, v7 = predictLocalHold(v16, n, v2, v5, v3, ServerTick, v18)
                                if v6 ~= nil and v7 ~= nil then
                                    v2 = v6
                                    v3 = v7
                                end
                                MoverTrajectory.InstallClientResolvedPose(v2, ServerTick, v5, v3)
                            end
                            v6 = #v11 + 1
                            v11[v6] = {
                                Id = k,
                                PreviousCFrame = MoverTrajectory.CollisionPose(v2, v5),
                                CFrame = MoverTrajectory.CollisionPose(v2, v3),
                                Size = v2.Size,
                                SurfaceFriction = v2.SurfaceFriction,
                                Pushes = v2.Behavior == "Pusher",
                            }
                            continue
                        end
                        return nil, "MoverReplayPoseUnavailable"
                    elseif not v17 and v9 < Serial.deltaUInt32(v10, v2.EffectiveTick) then
                        v13[#v13 + 1] = k
                    end
                end
            end
            if #v13 > 0 then
                for i6, i7 in v13 do
                    v16._tracks[i7] = nil
                    v16._proxyCache:Retire(i7)
                end
                if v16._replaySource == nil then
                    MoverTrajectory.RetireClientDescriptors(v13)
                end
            end
            table.sort(v11, compareId)
            local u173 = MoverFrame.Build(StepSeconds, v11)
            if v1 then
                MoverTrajectory.InstallClientResolved(ServerTick, v12)
            end
            if not v17 then
                v16._lastComposedTick = ServerTick
            end
            local u209 = CompositeWorld.new(v18.StaticWorld, u173, {Cache = v16._proxyCache})
            return {
                Query = u209,
                MoverSensitiveAt = function(a1, a2) -- Line: 996 -- upvalues: u173 (val), Config_2 (upval), distanceSquaredToSegment (upval)
                    local BoundingRadius, PlayerSizeDucking, v1
                    local Records = u173.Records
                    local v2 = nil
                    local v3 = nil
                    local v4, v5 = a2, a1
                    for i, j in Records, v2, v3 do
                        if j.PreviousCFrame ~= j.CFrame then
                            BoundingRadius = j.BoundingRadius
                            PlayerSizeDucking = if v4 ~= "Ducking" then Config_2.Default.PlayerSizeStanding else Config_2.Default.PlayerSizeDucking
                            v1 = BoundingRadius + (PlayerSizeDucking * 0.5).Magnitude + 0.25
                            if (distanceSquaredToSegment(v5, j.PreviousCFrame.Position, j.CFrame.Position)) <= v1 * v1 then
                                return true
                            end
                        end
                    end
                    return false
                end,
                ResolveSupportMotion = function(a1) -- Line: 1004 -- upvalues: MoverFrame (upval), u173 (val)
                    return MoverFrame.ResolveSupportMotion(u173, a1)
                end,
                CanOccupyAtEnd = function(a1, a2, a3) -- Line: 1007 -- upvalues: u209 (val)
                    return u209:CanMove(a2, a3, a1.Stance, nil, 1, 1)
                end,
            }, nil
        end
        return nil, "MoverBaselineRequired"
    end
    return nil, "MoverComposerTickInvalid"
end

function u64.Compose(a1, a2) -- Line: 1014 -- upvalues: compose (val)
    return compose(a1, a2, false)
end

local u114 = {}
u114.__index = u114

function u114.ComposeTick(a1, a2, a3) -- Line: 1021 -- upvalues: u64 (val) -- types: a2: number, a3: boolean?
    return u64.ComposeTick(a1._composer, a2, a3)
end

function u114.Compose(a1, a2) -- Line: 1025 -- upvalues: compose (val)
    return compose(a1._composer, a2, true)
end

function u64.ValidationView(a1) -- Line: 1030 -- upvalues: u114 (val)
    local _validationView = a1._validationView
    if _validationView == nil then
        local v1 = {_composer = a1}
        a1._validationView = (setmetatable(v1, u114))
    end
    return _validationView
end

function u64.Destroy(a1) -- Line: 1039
    a1:Reset()
end

return u64