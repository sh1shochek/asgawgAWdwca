-- ReplicatedStorage.MovementV2.Client.RemoteBuffer
-- Script path: ReplicatedStorage.MovementV2.Client.RemoteBuffer
-- Decompile time: 52.57 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Config = require(script.Parent.Parent.Config)
local Mapping = require(script.Parent.Parent.Mapping)
local PlayerBroadphase = require(script.Parent.Parent.Simulation.PlayerBroadphase)
local Quantization = require(script.Parent.Parent.Quantization)
local RootFrame = require(script.Parent.Parent.RootFrame)
local RemoteActorIdentity = require(script.Parent.Parent.RemoteActorIdentity)
local RemoteSnapshotCodec = require(script.Parent.Parent.RemoteSnapshotCodec)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local u65 = {}
u65.__index = u65
local u66 = {}
u66.__index = u66

local function cloneActor(a1) -- Line: 138
    return {
        UserId = a1.UserId,
        ActorId = a1.ActorId,
        Generation = a1.Generation,
        Position = a1.Position,
        Velocity = a1.Velocity,
        LookYaw = a1.LookYaw,
        VerticalLook = a1.VerticalLook,
        MovementMode = a1.MovementMode,
        Stance = a1.Stance,
        OnGround = a1.OnGround,
        DuckAmount = a1.DuckAmount,
        SupportKind = a1.SupportKind,
        SupportSourceId = a1.SupportSourceId,
    }
end

local function restoredStudioUserId(a1) -- Line: 156 -- upvalues: RunService (val), Players (val) -- types: a1: number
    if a1 ~= 0 and RunService:IsStudio() and Players:GetPlayerByUserId(a1) == nil then
        local v1 = -a1
        if Players:GetPlayerByUserId(v1) ~= nil then
            return v1
        end
        return a1
    end
    return a1
end

local function restoreStudioActor(a1) -- Line: 164 -- upvalues: RunService (val), cloneActor (val), Players (val)
    local v1
    if not RunService:IsStudio() then
        return a1
    end
    local v2 = cloneActor(a1)
    local UserId = v2.UserId
    if UserId == 0 or not RunService:IsStudio() then
        v1 = UserId
    elseif Players:GetPlayerByUserId(UserId) == nil then
        local v3 = -UserId
        v1 = if Players:GetPlayerByUserId(v3) == nil then UserId else v3
    else
        v1 = UserId
    end
    v2.UserId = v1
    return v2
end

local function actorStatesEqual(a1, a2) -- Line: 173
    local v1 = false
    if a1.UserId == a2.UserId then
        v1 = false
        if a1.ActorId == a2.ActorId then
            v1 = false
            if a1.Generation == a2.Generation then
                v1 = false
                if a1.Position == a2.Position then
                    v1 = false
                    if a1.Velocity == a2.Velocity then
                        v1 = false
                        if a1.LookYaw == a2.LookYaw then
                            v1 = false
                            if a1.VerticalLook == a2.VerticalLook then
                                v1 = false
                                if a1.MovementMode == a2.MovementMode then
                                    v1 = false
                                    if a1.Stance == a2.Stance then
                                        v1 = false
                                        if a1.OnGround == a2.OnGround then
                                            v1 = false
                                            if a1.DuckAmount == a2.DuckAmount then
                                                v1 = false
                                                if a1.SupportKind == a2.SupportKind then
                                                    v1 = a1.SupportSourceId == a2.SupportSourceId
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
    return v1
end

local function shortestAngleLerp(a1, a2, a3) -- Line: 189 -- types: a1: number, a2: number, a3: number
    return a1 + ((a2 - a1 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * a3
end

local function makePose(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) -- Line: 194
    -- upvalues: RootFrame (val)
    local v1 = a11 or {}
    v1.UserId = a1.UserId
    v1.ActorId = a1.ActorId
    v1.Generation = a1.Generation
    v1.Position = a6 or a1.Position
    v1.Velocity = a7 or a1.Velocity
    v1.LookYaw = a8 or a1.LookYaw
    v1.VerticalLook = a9 or a1.VerticalLook
    v1.MovementMode = a1.MovementMode
    v1.Stance = a1.Stance
    v1.OnGround = a1.OnGround
    v1.DuckAmount = a10 or a1.DuckAmount
    v1.SupportKind = a1.SupportKind
    v1.SupportSourceId = a1.SupportSourceId
    v1.SourceServerTick = a2
    v1.TopologyRevision = a3
    v1.InterpolationAlpha = a4
    v1.ExtrapolatedSeconds = a5
    v1.VisualRootPosition = RootFrame.simulationToVisualRootPosition(v1.Position, v1.DuckAmount)
    return v1
end

local function sampleVisualRoot(a1) -- Line: 229 -- upvalues: RootFrame (val) -- types: a1: table
    local VisualRoot = a1.VisualRoot
    if VisualRoot == nil then
        a1.VisualRoot = (RootFrame.simulationToVisualRootPosition(a1.Actor.Position, a1.Actor.DuckAmount))
    end
    return VisualRoot
end

local function interpolateSample(a1, a2, a3, a4) -- Line: 238
    -- upvalues: makePose (val), RootFrame (val)
    local v1 = math.clamp(a3, 0, 1)
    local Actor = if not (v1 < 0.5) then a2.Actor else a1.Actor
    local ServerTick = if not (v1 < 0.5) then a2.ServerTick else a1.ServerTick
    local TopologyRevision = if not (v1 < 0.5) then a2.TopologyRevision else a1.TopologyRevision
    local v2 = a1.Actor.Position:Lerp(a2.Actor.Position, v1)
    local v3 = a1.Actor.Velocity:Lerp(a2.Actor.Velocity, v1)
    local LookYaw = a1.Actor.LookYaw
    local v4 = makePose(
        Actor,
        ServerTick,
        TopologyRevision,
        v1,
        0,
        v2,
        v3,
        LookYaw + ((a2.Actor.LookYaw - LookYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v1,
        a1.Actor.VerticalLook + (a2.Actor.VerticalLook - a1.Actor.VerticalLook) * v1,
        a1.Actor.DuckAmount + (a2.Actor.DuckAmount - a1.Actor.DuckAmount) * v1,
        a4
    )
    local VisualRoot = a1.VisualRoot
    if VisualRoot == nil then
        a1.VisualRoot = (RootFrame.simulationToVisualRootPosition(a1.Actor.Position, a1.Actor.DuckAmount))
    end
    local VisualRoot_2 = a2.VisualRoot
    if VisualRoot_2 == nil then
        a2.VisualRoot = (RootFrame.simulationToVisualRootPosition(a2.Actor.Position, a2.Actor.DuckAmount))
    end
    v4.VisualRootPosition = VisualRoot:Lerp(VisualRoot_2, v1)
    return v4
end

local function validateClock(a1, a2) -- Line: 258
    -- upvalues: Serial (val), Quantization (val)
    if not Serial.isUInt32(a1) then
        return nil, "InvalidCurrentServerTick"
    end
    local v1 = a2 or 0
    if Quantization.isFinite(v1) and not (v1 < 0) and not (v1 >= 1) then
        return v1, nil
    end
    return nil, "InvalidTickFraction"
end

local function relativeTick(a1, a2) -- Line: 269 -- upvalues: Serial (val) -- types: a1: number, a2: number
    return Serial.deltaUInt32(a1, a2)
end

function u66.new(a1) -- Line: 273
    -- upvalues: Mapping (val), Config (val), RunService (val), PlayerBroadphase (val), u66 (val)
    local v1, v2 = Mapping.validate(a1)
    assert(v1, v2 or "invalid command mapping")
    local v3 = Config.derive(a1.SimulationHz)
    local RemoteHistoryTicks_2 = if not RunService:IsStudio() then v3.RemoteHistoryTicks else math.max(v3.RemoteHistoryTicks, (math.ceil(a1.SimulationHz * 0.75)))
    return (setmetatable({
        _actorOrderDirty = false,
        _mapping = Mapping.clone(a1),
        _config = v3,
        _retentionHistoryTicks = RemoteHistoryTicks_2,
        _maxSamplesPerActor = math.max(2, (math.ceil(RemoteHistoryTicks_2 / v3.RemoteSnapshotEveryTicks)) + 2),
        _actors = {},
        _actorIdToKey = {},
        _orderedActorKeys = table.freeze({}),
        _frames = {},
        _baselineActorsByActorId = {},
        _retainedBaselines = {},
        _retainedBaselineOrder = {},
        _heldDeltas = {},
        _collisionBroadphase = PlayerBroadphase.new(),
        _collisionQueryActorIds = {},
        _collisionQueryActorKeys = {},
        _presentationPoseByActorKey = {},
    }, u66))
end

function u66.sharesStream(a1, a2) -- Line: 305
    local _mapping = a1._mapping
    local v1 = false
    if _mapping.TopologyEpoch == a2.TopologyEpoch then
        v1 = false
        if _mapping.TopologyFingerprint == a2.TopologyFingerprint then
            v1 = _mapping.SimulationHz == a2.SimulationHz
        end
    end
    return v1
end

function u66.getCollisionPoseByActorId(a1, a2, a3, a4) -- Line: 312
    -- upvalues: 
    local v1 = a1._actorIdToKey[a2]
    if v1 == nil then
        return nil, "ActorIdNotBuffered"
    end
    local v2, v3 = a1:getCollisionPose(v1, a3, a4)
    if v2 ~= nil and v2.ActorId ~= a2 then
        return nil, "ActorIdInactive"
    end
    return v2, v3
end

function u66.actorKeys(a1) -- Line: 328 -- upvalues: RemoteActorIdentity (val)
    if not a1._actorOrderDirty then
        return a1._orderedActorKeys
    end
    local v1 = {}
    for i in a1._actors do
        table.insert(v1, i)
    end
    table.sort(v1, RemoteActorIdentity.keyLess)
    a1._orderedActorKeys = table.freeze(v1)
    a1._actorOrderDirty = false
    return a1._orderedActorKeys
end

function u66.latestServerTick(a1) -- Line: 342
    return a1._latestServerTick
end

function u66.latestCompleteServerTick(a1) -- Line: 347
    return a1._latestCompleteServerTick
end

function u66.queryCollisionActorKeys(a1, a2, a3) -- Line: 352 -- types: a1: table, a2: vector, a3: vector
    local v1
    local v2 = a1._collisionBroadphase:query(a2, a3, a1._collisionQueryActorIds)
    local _collisionQueryActorKeys = a1._collisionQueryActorKeys
    table.clear(_collisionQueryActorKeys)
    for i, j in v2 do
        v1 = a1._actorIdToKey[j]
        if v1 ~= nil then
            _collisionQueryActorKeys[#_collisionQueryActorKeys + 1] = v1
        end
    end
    return _collisionQueryActorKeys
end

local function forgetActorId(a1, a2, a3) -- Line: 365 -- types: a3: number
    a1._collisionBroadphase:remove(a3)
    if a1._actorIdToKey[a3] == a2 then
        a1._actorIdToKey[a3] = nil
    end
end

function u66.forgetActor(a1, a2) -- Line: 373
    local v1 = a1._actors[a2]
    if v1 == nil then
        return
    end
    for i, j in v1.ActorIdsByGeneration do
        a1._collisionBroadphase:remove(j)
        if a1._actorIdToKey[j] == a2 then
            a1._actorIdToKey[j] = nil
        end
    end
    a1._collisionFrame = nil
    a1._actors[a2] = nil
    a1._presentationPoseByActorKey[a2] = nil
    a1._actorOrderDirty = true
end

local u88 = table.freeze({})
local u89 = {}
local u90 = {}

function u66:_prune() -- Line: 392 -- upvalues: Serial (val), u89 (val), u88 (val), u90 (val)
    local Activity, Actor, Generation, Samples, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
    local _latestServerTick = self._latestServerTick
    if _latestServerTick == nil then
        return
    end
    local _retentionHistoryTicks = self._retentionHistoryTicks
    for i, j in self._frames do
        if _retentionHistoryTicks < Serial.deltaUInt32(_latestServerTick, j.ServerTick) then
            self._frames[i] = nil
        end
    end
    local v16 = nil
    local v17 = nil
    for k, n in self._actors, v16, v17 do
        v14 = n.Samples[#n.Samples]
        v15 = n.Activity[#n.Activity]
        v2 = false
        if v15 ~= nil then
            v2 = not v15.Active
        end
        if v14 == nil then
            Samples = n.Samples
            v3 = #Samples
            v4 = 0
            while 1 < v3 - v4 do
                if v3 - v4 <= v1._maxSamplesPerActor
                    and Serial.deltaUInt32(_latestServerTick, Samples[v4 + 1].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v4 = v4 + 1
            end
            if v4 > 0 then
                table.move(Samples, v4 + 1, v3, 1)
                for m = v3 - v4 + 1, v3 do
                    Samples[m] = nil
                end
            end
            Activity = n.Activity
            v5 = #Activity
            v6 = 0
            while 1 < v5 - v6 do
                if Serial.deltaUInt32(_latestServerTick, Activity[v6 + 2].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v6 = v6 + 1
            end
            if v6 > 0 then
                table.move(Activity, v6 + 1, v5, 1)
                for i5 = v5 - v6 + 1, v5 do
                    Activity[i5] = nil
                end
            end
            v7 = u89
            table.clear(v7)
            v8 = nil
            v9 = nil
            for i6, i7 in Samples, v8, v9 do
                Actor = i7.Actor
                v11 = v7[Actor.Generation]
                if v11 == nil then
                    v7[Actor.Generation] = Actor.ActorId
                elseif v11 ~= Actor.ActorId then
                    v7[Actor.Generation] = u88
                    Generation = Actor.Generation
                    v13 = u90[Actor.Generation] or {}
                    u90[Generation] = v13
                    v12 = u90[Actor.Generation]
                    v12[v11] = true
                    v12 = u90[Actor.Generation]
                    v12[Actor.ActorId] = true
                end
            end
            v8 = nil
            v9 = nil
            for i8, i9 in n.ActorIdsByGeneration, v8, v9 do
                v10 = v7[i8]
                v11 = true
                if v10 ~= i9 then
                    v11 = false
                    if v10 == u88 then
                        v11 = u90[i8][i9] == true
                    end
                end
                if not v11 then
                    n.ActorIdsByGeneration[i8] = nil
                    v1._collisionBroadphase:remove(i9)
                    if v1._actorIdToKey[i9] == k then
                        v1._actorIdToKey[i9] = nil
                    end
                end
            end
            table.clear(u90)
        elseif not v2 then
            Samples = n.Samples
            v3 = #Samples
            v4 = 0
            while 1 < v3 - v4 do
                if v3 - v4 <= v1._maxSamplesPerActor
                    and Serial.deltaUInt32(_latestServerTick, Samples[v4 + 1].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v4 = v4 + 1
            end
            if v4 > 0 then
                table.move(Samples, v4 + 1, v3, 1)
                for i10 = v3 - v4 + 1, v3 do
                    Samples[i10] = nil
                end
            end
            Activity = n.Activity
            v5 = #Activity
            v6 = 0
            while 1 < v5 - v6 do
                if Serial.deltaUInt32(_latestServerTick, Activity[v6 + 2].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v6 = v6 + 1
            end
            if v6 > 0 then
                table.move(Activity, v6 + 1, v5, 1)
                for i11 = v5 - v6 + 1, v5 do
                    Activity[i11] = nil
                end
            end
            v7 = u89
            table.clear(v7)
            v8 = nil
            v9 = nil
            for i12, i13 in Samples, v8, v9 do
                Actor = i13.Actor
                v11 = v7[Actor.Generation]
                if v11 == nil then
                    v7[Actor.Generation] = Actor.ActorId
                elseif v11 ~= Actor.ActorId then
                    v7[Actor.Generation] = u88
                    Generation = Actor.Generation
                    v13 = u90[Actor.Generation] or {}
                    u90[Generation] = v13
                    v12 = u90[Actor.Generation]
                    v12[v11] = true
                    v12 = u90[Actor.Generation]
                    v12[Actor.ActorId] = true
                end
            end
            v8 = nil
            v9 = nil
            for i14, i15 in n.ActorIdsByGeneration, v8, v9 do
                v10 = v7[i14]
                v11 = true
                if v10 ~= i15 then
                    v11 = false
                    if v10 == u88 then
                        v11 = u90[i14][i15] == true
                    end
                end
                if not v11 then
                    n.ActorIdsByGeneration[i14] = nil
                    v1._collisionBroadphase:remove(i15)
                    if v1._actorIdToKey[i15] == k then
                        v1._actorIdToKey[i15] = nil
                    end
                end
            end
            table.clear(u90)
        elseif not (_retentionHistoryTicks < Serial.deltaUInt32(_latestServerTick, v14.ServerTick)) then
            Samples = n.Samples
            v3 = #Samples
            v4 = 0
            while 1 < v3 - v4 do
                if v3 - v4 <= v1._maxSamplesPerActor
                    and Serial.deltaUInt32(_latestServerTick, Samples[v4 + 1].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v4 = v4 + 1
            end
            if v4 > 0 then
                table.move(Samples, v4 + 1, v3, 1)
                for i16 = v3 - v4 + 1, v3 do
                    Samples[i16] = nil
                end
            end
            Activity = n.Activity
            v5 = #Activity
            v6 = 0
            while 1 < v5 - v6 do
                if Serial.deltaUInt32(_latestServerTick, Activity[v6 + 2].ServerTick) <= _retentionHistoryTicks then
                    break
                end
                v6 = v6 + 1
            end
            if v6 > 0 then
                table.move(Activity, v6 + 1, v5, 1)
                for i17 = v5 - v6 + 1, v5 do
                    Activity[i17] = nil
                end
            end
            v7 = u89
            table.clear(v7)
            v8 = nil
            v9 = nil
            for i18, i19 in Samples, v8, v9 do
                Actor = i19.Actor
                v11 = v7[Actor.Generation]
                if v11 == nil then
                    v7[Actor.Generation] = Actor.ActorId
                elseif v11 ~= Actor.ActorId then
                    v7[Actor.Generation] = u88
                    Generation = Actor.Generation
                    v13 = u90[Actor.Generation] or {}
                    u90[Generation] = v13
                    v12 = u90[Actor.Generation]
                    v12[v11] = true
                    v12 = u90[Actor.Generation]
                    v12[Actor.ActorId] = true
                end
            end
            v8 = nil
            v9 = nil
            for i20, i21 in n.ActorIdsByGeneration, v8, v9 do
                v10 = v7[i20]
                v11 = true
                if v10 ~= i21 then
                    v11 = false
                    if v10 == u88 then
                        v11 = u90[i20][i21] == true
                    end
                end
                if not v11 then
                    n.ActorIdsByGeneration[i20] = nil
                    v1._collisionBroadphase:remove(i21)
                    if v1._actorIdToKey[i21] == k then
                        v1._actorIdToKey[i21] = nil
                    end
                end
            end
            table.clear(u90)
        else
            for i22, i23 in n.ActorIdsByGeneration do
                v1._collisionBroadphase:remove(i23)
                if v1._actorIdToKey[i23] == k then
                    v1._actorIdToKey[i23] = nil
                end
            end
            v1._collisionFrame = nil
            v1._actors[k] = nil
            v1._presentationPoseByActorKey[k] = nil
            v1._actorOrderDirty = true
        end
    end
end

local function upsertActorSample(a1, a2) -- Line: 488 -- upvalues: Serial (val) -- types: a1: table, a2: table
    local v1
    local Samples = a1.Samples
    for i = #Samples, 1, -1 do
        v1 = Samples[i]
        if v1.ServerTick == a2.ServerTick then
            if v1.Sequence == a2.Sequence or not Serial.isNewerUInt32(a2.Sequence, v1.Sequence) then
                return false
            end
            Samples[i] = a2
            return true
        end
        if 0 < (Serial.deltaUInt32(a2.ServerTick, v1.ServerTick)) then
            table.insert(Samples, i + 1, a2)
            return true
        end
    end
    table.insert(Samples, 1, a2)
    return true
end

local function continuesRun(a1, a2) -- Line: 511 -- types: a1: table, a2: table
    local Active = a1.Active
    if Active then
        Active = a2.Active
        if Active then
            Active = false
            if a1.Generation == a2.Generation then
                Active = a1.ActorId == a2.ActorId
            end
        end
    end
    return Active
end

local function linkRuns(a1, a2) -- Line: 519 -- types: a1: table, a2: number
    local Active, RunStart, v1, v2
    local v3 = #a1
    local v4 = a1
    for i = a2, v3 do
        v1 = v4[i]
        v2 = v4[i - 1]
        if v2 == nil then
            RunStart = v1
        else
            Active = v2.Active
            if Active then
                Active = v1.Active
                if Active then
                    Active = false
                    if v2.Generation == v1.Generation then
                        Active = v2.ActorId == v1.ActorId
                    end
                end
            end
            RunStart = if not Active then v1 else v2.RunStart
        end
        v1.RunStart = RunStart
    end
end

local function upsertActivityEvent(a1, a2) -- Line: 528
    -- upvalues: Serial (val), linkRuns (val)
    local v1
    local Activity = a1.Activity
    for i = #Activity, 1, -1 do
        v1 = Activity[i]
        if v1.ServerTick == a2.ServerTick then
            if v1.Sequence == a2.Sequence or not Serial.isNewerUInt32(a2.Sequence, v1.Sequence) then
                return false
            end
            Activity[i] = a2
            linkRuns(Activity, i)
            return true
        end
        if 0 < (Serial.deltaUInt32(a2.ServerTick, v1.ServerTick)) then
            table.insert(Activity, i + 1, a2)
            linkRuns(Activity, i + 1)
            return true
        end
    end
    table.insert(Activity, 1, a2)
    linkRuns(Activity, 1)
    return true
end

local function activeEvent(a1) -- Line: 554 -- types: a1: table
    return {
        Active = true,
        Sequence = a1.Sequence,
        ServerTick = a1.ServerTick,
        Generation = a1.Actor.Generation,
        ActorId = a1.Actor.ActorId,
    }
end

local function inactiveEvent(a1, a2) -- Line: 564 -- types: a1: table, a2: number
    return {
        Active = false,
        Generation = 0,
        ActorId = 0,
        Sequence = a2,
        ServerTick = a1.ServerTick,
    }
end

local function refreshCollisionIndex(a1, a2) -- Line: 574 -- types: a2: table
    a1._collisionFrame = nil
    local v1 = a2.Activity[#a2.Activity]
    if v1 ~= nil and v1.Active then
        local v2
        for i, j in a2.ActorIdsByGeneration do
            if j ~= v1.ActorId then
                a1._collisionBroadphase:remove(j)
            end
        end
        local v3, v4 = a2, a1
        for k = #a2.Samples, 1, -1 do
            v2 = v3.Samples[k]
            if v2.Actor.Generation == v1.Generation and v2.Actor.ActorId == v1.ActorId then
                v4._collisionBroadphase:upsert(v2.Actor.ActorId, v2.Actor.Position)
                return
            end
        end
        return
    end
    for n, m in a2.ActorIdsByGeneration do
        a1._collisionBroadphase:remove(m)
    end
end

local function reconcileCompleteFrames(a1, a2, a3, a4) -- Line: 597
    -- upvalues: upsertActivityEvent (val)
    local _frames = a1._frames
    local v1 = nil
    local v2 = nil
    local v3, v4, v5 = a2, a4, a3
    for i, j in _frames, v1, v2 do
        if j.AuthoritativeLifecycle then
            if j.Kind ~= "Baseline" then
                if j.RemovedActorKeys[v3] then
                    if not j.SeenActorKeys[v3] then
                        upsertActivityEvent(v5, {
                            Active = false,
                            Generation = 0,
                            ActorId = 0,
                            Sequence = i,
                            ServerTick = j.ServerTick,
                        })
                    end
                elseif j.RemovedActorIds[v4] and not j.SeenActorKeys[v3] then
                    upsertActivityEvent(v5, {
                        Active = false,
                        Generation = 0,
                        ActorId = 0,
                        Sequence = i,
                        ServerTick = j.ServerTick,
                    })
                end
            elseif not j.SeenActorKeys[v3] then
                upsertActivityEvent(v5, {
                    Active = false,
                    Generation = 0,
                    ActorId = 0,
                    Sequence = i,
                    ServerTick = j.ServerTick,
                })
            elseif j.RemovedActorKeys[v3] then
                if not j.SeenActorKeys[v3] then
                    upsertActivityEvent(v5, {
                        Active = false,
                        Generation = 0,
                        ActorId = 0,
                        Sequence = i,
                        ServerTick = j.ServerTick,
                    })
                end
            elseif j.RemovedActorIds[v4] and not j.SeenActorKeys[v3] then
                upsertActivityEvent(v5, {
                    Active = false,
                    Generation = 0,
                    ActorId = 0,
                    Sequence = i,
                    ServerTick = j.ServerTick,
                })
            end
        end
    end
end

local function applyFrameLifecycle(a1, a2, a3) -- Line: 614
    -- upvalues: Serial (val), RunService (val), cloneActor (val), Players (val), RemoteActorIdentity (val)
    -- upvalues: actorStatesEqual (val), upsertActorSample (val), upsertActivityEvent (val), refreshCollisionIndex (val)
    local v1, v2, v3, v4
    if a3.AuthoritativeLifecycle then
        return
    end
    a3.AuthoritativeLifecycle = true
    local _latestCompleteServerTick = a1._latestCompleteServerTick
    if _latestCompleteServerTick == nil or Serial.isNewerUInt32(a3.ServerTick, _latestCompleteServerTick) then
        a1._latestCompleteServerTick = a3.ServerTick
    end
    if a3.Kind == "Delta" and a3.BaselineSequence == a1._baselineSequence then
        local UserId, v5, v6, v7, v8
        v2 = nil
        v3 = nil
        for i, j in a1._baselineActorsByActorId, v2, v3 do
            if not a3.SeenActorIds[i] and not a3.RemovedActorIds[i] then
                if RunService:IsStudio() then
                    v5 = cloneActor(j)
                    UserId = v5.UserId
                    if UserId == 0 or not RunService:IsStudio() then
                        v1 = UserId
                    elseif Players:GetPlayerByUserId(UserId) == nil then
                        v7 = -UserId
                        v1 = if Players:GetPlayerByUserId(v7) == nil then UserId else v7
                    else
                        v1 = UserId
                    end
                    v5.UserId = v1
                    v4 = v5
                else
                    v4 = j
                end
                v5 = RemoteActorIdentity.key(v4)
                a3.SeenActorKeys[v5] = true
                a3.SeenActorIds[i] = true
                v1 = a1._actors[v5]
                v6 = if v1 ~= nil then v1.Samples[#v1.Samples] else nil
                v7 = if v1 ~= nil then v1.Activity[#v1.Activity] else nil
                if v1 ~= nil then
                    if v6 == nil
                        or not actorStatesEqual(v6.Actor, v4)
                        or v7 == nil
                        or not v7.Active
                        or v7.ActorId ~= i
                        or v7.Generation ~= v4.Generation then
                        v8 = {
                            Sequence = a2,
                            ServerTick = a3.ServerTick,
                            TopologyRevision = a3.TopologyRevision,
                            Actor = v4,
                        }
                        upsertActorSample(v1, v8)
                        upsertActivityEvent(v1, {
                            Active = true,
                            Sequence = v8.Sequence,
                            ServerTick = v8.ServerTick,
                            Generation = v8.Actor.Generation,
                            ActorId = v8.Actor.ActorId,
                        })
                        refreshCollisionIndex(a1, v1)
                    end
                end
            end
        end
    end
    for k in a3.RemovedActorIds do
        v4 = a1._actorIdToKey[k]
        if v4 ~= nil then
            a3.RemovedActorKeys[v4] = true
        end
    end
    v2 = nil
    v3 = nil
    for n, m in a1._actors, v2, v3 do
        if a3.Kind ~= "Baseline" then
            if a3.RemovedActorKeys[n] and not a3.SeenActorKeys[n] then
                v4 = upsertActivityEvent
                v1 = {
                    Active = false,
                    Generation = 0,
                    ActorId = 0,
                    Sequence = a2,
                    ServerTick = a3.ServerTick,
                }
                v4(m, v1)
                refreshCollisionIndex(a1, m)
            end
        elseif not a3.SeenActorKeys[n] or a3.RemovedActorKeys[n] and not a3.SeenActorKeys[n] then
            v4 = upsertActivityEvent
            v1 = {
                Active = false,
                Generation = 0,
                ActorId = 0,
                Sequence = a2,
                ServerTick = a3.ServerTick,
            }
            v4(m, v1)
            refreshCollisionIndex(a1, m)
        end
    end
end

local function retainBaseline(a1, a2, a3) -- Line: 679 -- upvalues: Serial (val) -- types: a2: number, a3: table
    local _retainedBaselineOrder = a1._retainedBaselineOrder
    if a1._retainedBaselines[a2] ~= nil then
        return
    end
    local v1 = #_retainedBaselineOrder + 1
    for i, j in _retainedBaselineOrder do
        if Serial.isNewerUInt32(j, a2) then
            v1 = i
            break
        end
    end
    table.insert(_retainedBaselineOrder, v1, a2)
    a1._retainedBaselines[a2] = a3
    while #_retainedBaselineOrder > 3 do
        a1._retainedBaselines[(table.remove(_retainedBaselineOrder, 1))] = nil
    end
end

local function admitCompleteFrame(a1, a2, a3) -- Line: 698
    -- upvalues: cloneActor (val), retainBaseline (val), Serial (val), applyFrameLifecycle (val)
    if a3.Kind ~= "Baseline" then
        local _baselineSequence_2 = a1._baselineSequence
        local _lastAppliedSequence = a1._lastAppliedSequence
        if _baselineSequence_2 ~= nil
            and _lastAppliedSequence ~= nil
            and a3.BaselineSequence == _baselineSequence_2
            and Serial.isNewerUInt32(a2, _lastAppliedSequence) then
            applyFrameLifecycle(a1, a2, a3)
            a1._lastAppliedSequence = a2
        end
        return
    end
    local v1 = {}
    for i, j in a3.BaselineActorsByActorId do
        v1[i] = (cloneActor(j))
    end
    retainBaseline(a1, a2, v1)
    local _baselineSequence = a1._baselineSequence
    if _baselineSequence == nil or Serial.isNewerUInt32(a2, _baselineSequence) then
        a1._baselineActorsByActorId = v1
        a1._baselineSequence = a2
        a1._lastAppliedSequence = a2
        applyFrameLifecycle(a1, a2, a3)
    end
end

local function generationsAreChronological(a1, a2, a3) -- Line: 728
    -- upvalues: Serial (val)
    local v1, v2
    local v3 = next(a1.ActorIdsByGeneration)
    if v3 == a2.Generation and next(a1.ActorIdsByGeneration, v3) == nil then
        return true
    end
    local Samples = a1.Samples
    local v4 = nil
    local v5 = nil
    local v6, v7 = a2, a3
    for i, j in Samples, v4, v5 do
        v2 = Serial.deltaUInt16(v6.Generation, j.Actor.Generation)
        v1 = Serial.deltaUInt32(v7, j.ServerTick)
        if v2 > 0 and v1 <= 0 then
            return false
        end
        if v2 < 0 and v1 >= 0 then
            return false
        end
    end
    return true
end

local function expandSnapshotRecords(a1, a2) -- Line: 744
    -- upvalues: RunService (val), cloneActor (val), Players (val), RemoteSnapshotCodec (val), RemoteActorIdentity (val)
    local UserId, UserId_2, UserId_3, key, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v13 = table.create(#a2.Actors + #a2.Deltas)
    local Actors = a2.Actors
    local v14 = nil
    local v15 = nil
    local v16, v17 = a1, a2
    for i, j in Actors, v14, v15 do
        v11 = #v13 + 1
        if RunService:IsStudio() then
            v1 = cloneActor(j)
            UserId_3 = v1.UserId
            if UserId_3 == 0 or not RunService:IsStudio() then
                v2 = UserId_3
            elseif Players:GetPlayerByUserId(UserId_3) == nil then
                v4 = -UserId_3
                v2 = if Players:GetPlayerByUserId(v4) == nil then UserId_3 else v4
            else
                v2 = UserId_3
            end
            v1.UserId = v2
            v12 = v1
        else
            v12 = j
        end
        v13[v11] = v12
    end
    local _baselineActorsByActorId = v16._baselineActorsByActorId
    if v17.Kind ~= "Delta" then
        v14 = #v17.Deltas
        if not (v14 > 0) then
            v14 = #v17.RemovedActorIds
            if not (v14 > 0) then
                v14 = table.create(#v17.RemovedActorIds)
                v9 = nil
                v10 = nil
                for k, n in v17.RemovedActorIds, v9, v10 do
                    v1 = _baselineActorsByActorId[n]
                    if v1 == nil then
                        v2 = v16._actorIdToKey[n]
                    else
                        key = RemoteActorIdentity.key
                        if RunService:IsStudio() then
                            v4 = cloneActor(v1)
                            UserId_2 = v4.UserId
                            if UserId_2 == 0 or not RunService:IsStudio() then
                                v5 = UserId_2
                            elseif Players:GetPlayerByUserId(UserId_2) == nil then
                                v7 = -UserId_2
                                v5 = if Players:GetPlayerByUserId(v7) == nil then UserId_2 else v7
                            else
                                v5 = UserId_2
                            end
                            v4.UserId = v5
                            v3 = v4
                        else
                            v3 = v1
                        end
                        v2 = key(v3)
                    end
                    v14[k] = v2
                end
                return v13, v14, nil
            end
        end
        return nil, nil, "RemoteBaselineHasDeltaRecords"
    end
    v14 = v16._retainedBaselines[v17.BaselineSequence]
    if v14 == nil then
        return nil, nil, "RemoteBaselineRequired"
    end
    v9 = nil
    v10 = nil
    for m, i5 in v17.Deltas, v9, v10 do
        v1 = v14[i5.ActorId]
        if v1 == nil then
            return nil, nil, "RemoteDeltaActorMissingFromBaseline"
        end
        v2, v3 = RemoteSnapshotCodec.applyDeltaToCanonicalBaseline(v1, i5, true)
        if v2 == nil then
            return nil, nil, v3
        end
        v4 = #v13 + 1
        if RunService:IsStudio() then
            v6 = cloneActor(v2)
            UserId = v6.UserId
            if UserId == 0 or not RunService:IsStudio() then
                v7 = UserId
            elseif Players:GetPlayerByUserId(UserId) == nil then
                v8 = -UserId
                v7 = if Players:GetPlayerByUserId(v8) == nil then UserId else v8
            else
                v7 = UserId
            end
            v6.UserId = v7
            v5 = v6
        else
            v5 = v2
        end
        v13[v4] = v5
    end
    v14 = table.create(#v17.RemovedActorIds)
    v9 = nil
    v10 = nil
    for i6, i7 in v17.RemovedActorIds, v9, v10 do
        v1 = _baselineActorsByActorId[i7]
        if v1 == nil then
            v2 = v16._actorIdToKey[i7]
        else
            key = RemoteActorIdentity.key
            if RunService:IsStudio() then
                v4 = cloneActor(v1)
                UserId_2 = v4.UserId
                if UserId_2 == 0 or not RunService:IsStudio() then
                    v5 = UserId_2
                elseif Players:GetPlayerByUserId(UserId_2) == nil then
                    v7 = -UserId_2
                    v5 = if Players:GetPlayerByUserId(v7) == nil then UserId_2 else v7
                else
                    v5 = UserId_2
                end
                v4.UserId = v5
                v3 = v4
            else
                v3 = v1
            end
            v2 = key(v3)
        end
        v14[i6] = v2
    end
    return v13, v14, nil
end

local function holdDelta(a1, a2) -- Line: 786 -- upvalues: Serial (val)
    local v1
    local _heldDeltas = a1._heldDeltas
    local _latestServerTick = a1._latestServerTick
    for i = #_heldDeltas, 1, -1 do
        v1 = false
        if _latestServerTick ~= nil then
            v1 = a1._retentionHistoryTicks < (Serial.deltaUInt32(_latestServerTick, _heldDeltas[i].ServerTick))
        end
        if v1 or _heldDeltas[i].Sequence == a2.Sequence and _heldDeltas[i].ChunkIndex == a2.ChunkIndex then
            table.remove(_heldDeltas, i)
        end
    end
    if #_heldDeltas >= 24 then
        table.remove(_heldDeltas, 1)
    end
    _heldDeltas[#_heldDeltas + 1] = a2
end

local function releaseHeldDeltas(a1, a2) -- Line: 802 -- upvalues: Serial (val) -- types: a2: number
    local _heldDeltas = a1._heldDeltas
    local v1 = {}
    for i = #_heldDeltas, 1, -1 do
        if _heldDeltas[i].BaselineSequence == a2 then
            v1[#v1 + 1] = (table.remove(_heldDeltas, i))
        end
    end
    table.sort(v1, function(a1, a2) -- Line: 810 -- upvalues: Serial (upval)
        return Serial.isNewerUInt32(a2.Sequence, a1.Sequence)
    end)
    for j, k in v1 do
        a1:pushDecoded(k)
    end
end

function u66:pushDecoded(a2) -- Line: 819
    -- upvalues: Serial (val), holdDelta (val), expandSnapshotRecords (val), RemoteActorIdentity (val)
    -- upvalues: generationsAreChronological (val), reconcileCompleteFrames (val), cloneActor (val)
    -- upvalues: upsertActorSample (val), upsertActivityEvent (val), refreshCollisionIndex (val)
    -- upvalues: admitCompleteFrame (val), releaseHeldDeltas (val)
    if a2.Topology.Epoch == self._mapping.TopologyEpoch
        and a2.Topology.Fingerprint == self._mapping.TopologyFingerprint then
        if a2.Kind == "Delta" and self._retainedBaselines[a2.BaselineSequence] == nil then
            local _baselineSequence = self._baselineSequence
            if _baselineSequence ~= nil and not Serial.isNewerUInt32(a2.BaselineSequence, _baselineSequence) then
                return nil, "RemoteBaselineRequired"
            end
            holdDelta(self, a2)
            return nil, "RemoteDeltaHeld"
        end
        local v1, v2, v3 = expandSnapshotRecords(self, a2)
        if v1 ~= nil and v2 ~= nil then
            local _latestServerTick, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
            local v17 = self._frames[a2.Sequence]
            if v17 == nil then
                if v17 ~= nil and v17.ReceivedChunks[a2.ChunkIndex] then
                    return nil, "DuplicateRemoteChunk"
                end
                _latestServerTick = self._latestServerTick
                if _latestServerTick ~= nil then
                    if self._retentionHistoryTicks < (Serial.deltaUInt32(_latestServerTick, a2.ServerTick)) then
                        return nil, "RemoteSnapshotTooOld"
                    end
                    if Serial.isNewerUInt32(a2.ServerTick, _latestServerTick) then
                        if self._latestTopologyRevision ~= nil
                            and (Serial.deltaUInt32(a2.Topology.DestructibleRevision, self._latestTopologyRevision)) < 0 then
                            return nil, "TopologyRevisionRegressed"
                        end
                        self._latestServerTick = a2.ServerTick
                        self._latestTopologyRevision = a2.Topology.DestructibleRevision
                    end
                    if v17 == nil then
                        v17 = {
                            ReceivedChunkCount = 0,
                            AuthoritativeLifecycle = false,
                            Kind = a2.Kind,
                            BaselineSequence = a2.BaselineSequence,
                            ServerTick = a2.ServerTick,
                            TopologyRevision = a2.Topology.DestructibleRevision,
                            ChunkCount = a2.ChunkCount,
                            ReceivedChunks = {},
                            SeenActorKeys = {},
                            SeenActorIds = {},
                            RemovedActorKeys = {},
                            RemovedActorIds = {},
                            BaselineActorsByActorId = {},
                        }
                        self._frames[a2.Sequence] = v17
                    end
                    v14 = v17
                    v16 = nil
                    v6 = nil
                    v5, v4 = a2, self
                    for i86, i87 in v1, v16, v6 do
                        v8 = RemoteActorIdentity.key(i87)
                        if v14.SeenActorKeys[v8] then
                            return nil, "DuplicateRemoteActorUserId"
                        end
                        if not v14.SeenActorIds[i87.ActorId] and not v14.RemovedActorIds[i87.ActorId] then
                            v9 = v4._actorIdToKey[i87.ActorId]
                            if v9 ~= nil and v9 ~= v8 then
                                return nil, "ConflictingActorId"
                            end
                            v10 = v4._actors[v8]
                            if v10 ~= nil then
                                v11 = v10.ActorIdsByGeneration[i87.Generation]
                                if v11 ~= nil and v11 ~= i87.ActorId then
                                    return nil, "ActorIdChangedWithinGeneration"
                                end
                            end
                            continue
                        end
                        return nil, "DuplicateRemoteActorId"
                    end
                    for i88, i89 in v5.RemovedActorIds do
                        if not v14.SeenActorIds[i89] and not v14.RemovedActorIds[i89] then
                            continue
                        end
                        return nil, "DuplicateRemovedRemoteActorId"
                    end
                    v15 = 0
                    v6 = nil
                    v7 = nil
                    for i90, i91 in v1, v6, v7 do
                        v9 = RemoteActorIdentity.key(i91)
                        v10 = v4._actors[v9]
                        v11 = true
                        if v10 ~= nil then
                            v11 = v10.ActorIdsByGeneration[i91.Generation] == nil
                        end
                        if v10 == nil then
                            v12 = {Generation = i91.Generation, ActorId = i91.ActorId}
                            v13 = {}
                            v13[i91.Generation] = i91.ActorId
                            v12.ActorIdsByGeneration = v13
                            v12.Samples = {}
                            v12.Activity = {}
                            v10 = v12
                            v4._actors[v9] = v10
                            v4._actorOrderDirty = true
                            v10.ActorIdsByGeneration[i91.Generation] = i91.ActorId
                            v4._actorIdToKey[i91.ActorId] = v9
                            if v11 then
                                reconcileCompleteFrames(v4, v9, v10, i91.ActorId)
                            end
                            v12 = {
                                Sequence = v5.Sequence,
                                ServerTick = v5.ServerTick,
                                TopologyRevision = v5.Topology.DestructibleRevision,
                                Actor = cloneActor(i91),
                            }
                            if upsertActorSample(v10, v12) then
                                upsertActivityEvent(v10, {
                                    Active = true,
                                    Sequence = v12.Sequence,
                                    ServerTick = v12.ServerTick,
                                    Generation = v12.Actor.Generation,
                                    ActorId = v12.Actor.ActorId,
                                })
                                refreshCollisionIndex(v4, v10)
                                v15 = v15 + 1
                            end
                        elseif generationsAreChronological(v10, i91, v5.ServerTick) then
                            if i91.Generation == v10.Generation then
                                if i91.ActorId ~= v10.ActorId then
                                    return nil, "ActorIdChangedWithinGeneration"
                                end
                            elseif 0 < (Serial.deltaUInt16(i91.Generation, v10.Generation)) then
                                v10.Generation = i91.Generation
                                v10.ActorId = i91.ActorId
                            end
                            v10.ActorIdsByGeneration[i91.Generation] = i91.ActorId
                            v4._actorIdToKey[i91.ActorId] = v9
                            if v11 then
                                reconcileCompleteFrames(v4, v9, v10, i91.ActorId)
                            end
                            v12 = {
                                Sequence = v5.Sequence,
                                ServerTick = v5.ServerTick,
                                TopologyRevision = v5.Topology.DestructibleRevision,
                                Actor = cloneActor(i91),
                            }
                            if upsertActorSample(v10, v12) then
                                upsertActivityEvent(v10, {
                                    Active = true,
                                    Sequence = v12.Sequence,
                                    ServerTick = v12.ServerTick,
                                    Generation = v12.Actor.Generation,
                                    ActorId = v12.Actor.ActorId,
                                })
                                refreshCollisionIndex(v4, v10)
                                v15 = v15 + 1
                            end
                        end
                    end
                    for i92, i93 in v1 do
                        v14.SeenActorKeys[(RemoteActorIdentity.key(i93))] = true
                        v14.SeenActorIds[i93.ActorId] = true
                    end
                    for i94, i95 in v2 do
                        v14.RemovedActorKeys[i95] = true
                    end
                    for i96, i97 in v5.RemovedActorIds do
                        v14.RemovedActorIds[i97] = true
                    end
                    if v5.Kind == "Baseline" then
                        for i98, i99 in v5.Actors do
                            v14.BaselineActorsByActorId[i99.ActorId] = (cloneActor(i99))
                        end
                    end
                    v14.ReceivedChunks[v5.ChunkIndex] = true
                    v14.ReceivedChunkCount = v14.ReceivedChunkCount + 1
                    v16 = false
                    if v14.ReceivedChunkCount == v14.ChunkCount then
                        admitCompleteFrame(v4, v5.Sequence, v14)
                        v16 = v5.Kind == "Baseline"
                    end
                    v4:_prune()
                    if v16 and v4._retainedBaselines[v5.Sequence] ~= nil and #v4._heldDeltas > 0 then
                        releaseHeldDeltas(v4, v5.Sequence)
                    end
                    return v15, nil
                end
                self._latestServerTick = a2.ServerTick
                self._latestTopologyRevision = a2.Topology.DestructibleRevision
                if v17 == nil then
                    v17 = {
                        ReceivedChunkCount = 0,
                        AuthoritativeLifecycle = false,
                        Kind = a2.Kind,
                        BaselineSequence = a2.BaselineSequence,
                        ServerTick = a2.ServerTick,
                        TopologyRevision = a2.Topology.DestructibleRevision,
                        ChunkCount = a2.ChunkCount,
                        ReceivedChunks = {},
                        SeenActorKeys = {},
                        SeenActorIds = {},
                        RemovedActorKeys = {},
                        RemovedActorIds = {},
                        BaselineActorsByActorId = {},
                    }
                    self._frames[a2.Sequence] = v17
                end
                v14 = v17
                v16 = nil
                v6 = nil
                v5, v4 = a2, self
                for i72, i73 in v1, v16, v6 do
                    v8 = RemoteActorIdentity.key(i73)
                    if v14.SeenActorKeys[v8] then
                        return nil, "DuplicateRemoteActorUserId"
                    end
                    if not v14.SeenActorIds[i73.ActorId] and not v14.RemovedActorIds[i73.ActorId] then
                        v9 = v4._actorIdToKey[i73.ActorId]
                        if v9 ~= nil and v9 ~= v8 then
                            return nil, "ConflictingActorId"
                        end
                        v10 = v4._actors[v8]
                        if v10 ~= nil then
                            v11 = v10.ActorIdsByGeneration[i73.Generation]
                            if v11 ~= nil and v11 ~= i73.ActorId then
                                return nil, "ActorIdChangedWithinGeneration"
                            end
                        end
                        continue
                    end
                    return nil, "DuplicateRemoteActorId"
                end
                for i74, i75 in v5.RemovedActorIds do
                    if not v14.SeenActorIds[i75] and not v14.RemovedActorIds[i75] then
                        continue
                    end
                    return nil, "DuplicateRemovedRemoteActorId"
                end
                v15 = 0
                v6 = nil
                v7 = nil
                for i76, i77 in v1, v6, v7 do
                    v9 = RemoteActorIdentity.key(i77)
                    v10 = v4._actors[v9]
                    v11 = true
                    if v10 ~= nil then
                        v11 = v10.ActorIdsByGeneration[i77.Generation] == nil
                    end
                    if v10 == nil then
                        v12 = {Generation = i77.Generation, ActorId = i77.ActorId}
                        v13 = {}
                        v13[i77.Generation] = i77.ActorId
                        v12.ActorIdsByGeneration = v13
                        v12.Samples = {}
                        v12.Activity = {}
                        v10 = v12
                        v4._actors[v9] = v10
                        v4._actorOrderDirty = true
                        v10.ActorIdsByGeneration[i77.Generation] = i77.ActorId
                        v4._actorIdToKey[i77.ActorId] = v9
                        if v11 then
                            reconcileCompleteFrames(v4, v9, v10, i77.ActorId)
                        end
                        v12 = {
                            Sequence = v5.Sequence,
                            ServerTick = v5.ServerTick,
                            TopologyRevision = v5.Topology.DestructibleRevision,
                            Actor = cloneActor(i77),
                        }
                        if upsertActorSample(v10, v12) then
                            upsertActivityEvent(v10, {
                                Active = true,
                                Sequence = v12.Sequence,
                                ServerTick = v12.ServerTick,
                                Generation = v12.Actor.Generation,
                                ActorId = v12.Actor.ActorId,
                            })
                            refreshCollisionIndex(v4, v10)
                            v15 = v15 + 1
                        end
                    elseif generationsAreChronological(v10, i77, v5.ServerTick) then
                        if i77.Generation == v10.Generation then
                            if i77.ActorId ~= v10.ActorId then
                                return nil, "ActorIdChangedWithinGeneration"
                            end
                        elseif 0 < (Serial.deltaUInt16(i77.Generation, v10.Generation)) then
                            v10.Generation = i77.Generation
                            v10.ActorId = i77.ActorId
                        end
                        v10.ActorIdsByGeneration[i77.Generation] = i77.ActorId
                        v4._actorIdToKey[i77.ActorId] = v9
                        if v11 then
                            reconcileCompleteFrames(v4, v9, v10, i77.ActorId)
                        end
                        v12 = {
                            Sequence = v5.Sequence,
                            ServerTick = v5.ServerTick,
                            TopologyRevision = v5.Topology.DestructibleRevision,
                            Actor = cloneActor(i77),
                        }
                        if upsertActorSample(v10, v12) then
                            upsertActivityEvent(v10, {
                                Active = true,
                                Sequence = v12.Sequence,
                                ServerTick = v12.ServerTick,
                                Generation = v12.Actor.Generation,
                                ActorId = v12.Actor.ActorId,
                            })
                            refreshCollisionIndex(v4, v10)
                            v15 = v15 + 1
                        end
                    end
                end
                for i78, i79 in v1 do
                    v14.SeenActorKeys[(RemoteActorIdentity.key(i79))] = true
                    v14.SeenActorIds[i79.ActorId] = true
                end
                for i80, i81 in v2 do
                    v14.RemovedActorKeys[i81] = true
                end
                for i82, i83 in v5.RemovedActorIds do
                    v14.RemovedActorIds[i83] = true
                end
                if v5.Kind == "Baseline" then
                    for i84, i85 in v5.Actors do
                        v14.BaselineActorsByActorId[i85.ActorId] = (cloneActor(i85))
                    end
                end
                v14.ReceivedChunks[v5.ChunkIndex] = true
                v14.ReceivedChunkCount = v14.ReceivedChunkCount + 1
                v16 = false
                if v14.ReceivedChunkCount == v14.ChunkCount then
                    admitCompleteFrame(v4, v5.Sequence, v14)
                    v16 = v5.Kind == "Baseline"
                end
                v4:_prune()
                if v16 and v4._retainedBaselines[v5.Sequence] ~= nil and #v4._heldDeltas > 0 then
                    releaseHeldDeltas(v4, v5.Sequence)
                end
                return v15, nil
            end
            if v17.Kind == a2.Kind
                and v17.BaselineSequence == a2.BaselineSequence
                and v17.ServerTick == a2.ServerTick
                and v17.TopologyRevision == a2.Topology.DestructibleRevision
                and v17.ChunkCount == a2.ChunkCount then
                if v17 ~= nil and v17.ReceivedChunks[a2.ChunkIndex] then
                    return nil, "DuplicateRemoteChunk"
                end
                _latestServerTick = self._latestServerTick
                if _latestServerTick == nil then
                    self._latestServerTick = a2.ServerTick
                    self._latestTopologyRevision = a2.Topology.DestructibleRevision
                    if v17 == nil then
                        v17 = {
                            ReceivedChunkCount = 0,
                            AuthoritativeLifecycle = false,
                            Kind = a2.Kind,
                            BaselineSequence = a2.BaselineSequence,
                            ServerTick = a2.ServerTick,
                            TopologyRevision = a2.Topology.DestructibleRevision,
                            ChunkCount = a2.ChunkCount,
                            ReceivedChunks = {},
                            SeenActorKeys = {},
                            SeenActorIds = {},
                            RemovedActorKeys = {},
                            RemovedActorIds = {},
                            BaselineActorsByActorId = {},
                        }
                        self._frames[a2.Sequence] = v17
                    end
                    v14 = v17
                    v16 = nil
                    v6 = nil
                    v5, v4 = a2, self
                    for i44, i45 in v1, v16, v6 do
                        v8 = RemoteActorIdentity.key(i45)
                        if v14.SeenActorKeys[v8] then
                            return nil, "DuplicateRemoteActorUserId"
                        end
                        if not v14.SeenActorIds[i45.ActorId] and not v14.RemovedActorIds[i45.ActorId] then
                            v9 = v4._actorIdToKey[i45.ActorId]
                            if v9 ~= nil and v9 ~= v8 then
                                return nil, "ConflictingActorId"
                            end
                            v10 = v4._actors[v8]
                            if v10 ~= nil then
                                v11 = v10.ActorIdsByGeneration[i45.Generation]
                                if v11 ~= nil and v11 ~= i45.ActorId then
                                    return nil, "ActorIdChangedWithinGeneration"
                                end
                            end
                            continue
                        end
                        return nil, "DuplicateRemoteActorId"
                    end
                    for i46, i47 in v5.RemovedActorIds do
                        if not v14.SeenActorIds[i47] and not v14.RemovedActorIds[i47] then
                            continue
                        end
                        return nil, "DuplicateRemovedRemoteActorId"
                    end
                    v15 = 0
                    v6 = nil
                    v7 = nil
                    for i48, i49 in v1, v6, v7 do
                        v9 = RemoteActorIdentity.key(i49)
                        v10 = v4._actors[v9]
                        v11 = true
                        if v10 ~= nil then
                            v11 = v10.ActorIdsByGeneration[i49.Generation] == nil
                        end
                        if v10 == nil then
                            v12 = {Generation = i49.Generation, ActorId = i49.ActorId}
                            v13 = {}
                            v13[i49.Generation] = i49.ActorId
                            v12.ActorIdsByGeneration = v13
                            v12.Samples = {}
                            v12.Activity = {}
                            v10 = v12
                            v4._actors[v9] = v10
                            v4._actorOrderDirty = true
                            v10.ActorIdsByGeneration[i49.Generation] = i49.ActorId
                            v4._actorIdToKey[i49.ActorId] = v9
                            if v11 then
                                reconcileCompleteFrames(v4, v9, v10, i49.ActorId)
                            end
                            v12 = {
                                Sequence = v5.Sequence,
                                ServerTick = v5.ServerTick,
                                TopologyRevision = v5.Topology.DestructibleRevision,
                                Actor = cloneActor(i49),
                            }
                            if upsertActorSample(v10, v12) then
                                upsertActivityEvent(v10, {
                                    Active = true,
                                    Sequence = v12.Sequence,
                                    ServerTick = v12.ServerTick,
                                    Generation = v12.Actor.Generation,
                                    ActorId = v12.Actor.ActorId,
                                })
                                refreshCollisionIndex(v4, v10)
                                v15 = v15 + 1
                            end
                        elseif generationsAreChronological(v10, i49, v5.ServerTick) then
                            if i49.Generation == v10.Generation then
                                if i49.ActorId ~= v10.ActorId then
                                    return nil, "ActorIdChangedWithinGeneration"
                                end
                            elseif 0 < (Serial.deltaUInt16(i49.Generation, v10.Generation)) then
                                v10.Generation = i49.Generation
                                v10.ActorId = i49.ActorId
                            end
                            v10.ActorIdsByGeneration[i49.Generation] = i49.ActorId
                            v4._actorIdToKey[i49.ActorId] = v9
                            if v11 then
                                reconcileCompleteFrames(v4, v9, v10, i49.ActorId)
                            end
                            v12 = {
                                Sequence = v5.Sequence,
                                ServerTick = v5.ServerTick,
                                TopologyRevision = v5.Topology.DestructibleRevision,
                                Actor = cloneActor(i49),
                            }
                            if upsertActorSample(v10, v12) then
                                upsertActivityEvent(v10, {
                                    Active = true,
                                    Sequence = v12.Sequence,
                                    ServerTick = v12.ServerTick,
                                    Generation = v12.Actor.Generation,
                                    ActorId = v12.Actor.ActorId,
                                })
                                refreshCollisionIndex(v4, v10)
                                v15 = v15 + 1
                            end
                        end
                    end
                    for i50, i51 in v1 do
                        v14.SeenActorKeys[(RemoteActorIdentity.key(i51))] = true
                        v14.SeenActorIds[i51.ActorId] = true
                    end
                    for i52, i53 in v2 do
                        v14.RemovedActorKeys[i53] = true
                    end
                    for i54, i55 in v5.RemovedActorIds do
                        v14.RemovedActorIds[i55] = true
                    end
                    if v5.Kind == "Baseline" then
                        for i56, i57 in v5.Actors do
                            v14.BaselineActorsByActorId[i57.ActorId] = (cloneActor(i57))
                        end
                    end
                    v14.ReceivedChunks[v5.ChunkIndex] = true
                    v14.ReceivedChunkCount = v14.ReceivedChunkCount + 1
                    v16 = false
                    if v14.ReceivedChunkCount == v14.ChunkCount then
                        admitCompleteFrame(v4, v5.Sequence, v14)
                        v16 = v5.Kind == "Baseline"
                    end
                    v4:_prune()
                    if v16 and v4._retainedBaselines[v5.Sequence] ~= nil and #v4._heldDeltas > 0 then
                        releaseHeldDeltas(v4, v5.Sequence)
                    end
                    return v15, nil
                end
                if self._retentionHistoryTicks < (Serial.deltaUInt32(_latestServerTick, a2.ServerTick)) then
                    return nil, "RemoteSnapshotTooOld"
                end
                if Serial.isNewerUInt32(a2.ServerTick, _latestServerTick) then
                    if self._latestTopologyRevision ~= nil
                        and (Serial.deltaUInt32(a2.Topology.DestructibleRevision, self._latestTopologyRevision)) < 0 then
                        return nil, "TopologyRevisionRegressed"
                    end
                    self._latestServerTick = a2.ServerTick
                    self._latestTopologyRevision = a2.Topology.DestructibleRevision
                end
                if v17 == nil then
                    v17 = {
                        ReceivedChunkCount = 0,
                        AuthoritativeLifecycle = false,
                        Kind = a2.Kind,
                        BaselineSequence = a2.BaselineSequence,
                        ServerTick = a2.ServerTick,
                        TopologyRevision = a2.Topology.DestructibleRevision,
                        ChunkCount = a2.ChunkCount,
                        ReceivedChunks = {},
                        SeenActorKeys = {},
                        SeenActorIds = {},
                        RemovedActorKeys = {},
                        RemovedActorIds = {},
                        BaselineActorsByActorId = {},
                    }
                    self._frames[a2.Sequence] = v17
                end
                v14 = v17
                v16 = nil
                v6 = nil
                v5, v4 = a2, self
                for i58, i59 in v1, v16, v6 do
                    v8 = RemoteActorIdentity.key(i59)
                    if v14.SeenActorKeys[v8] then
                        return nil, "DuplicateRemoteActorUserId"
                    end
                    if not v14.SeenActorIds[i59.ActorId] and not v14.RemovedActorIds[i59.ActorId] then
                        v9 = v4._actorIdToKey[i59.ActorId]
                        if v9 ~= nil and v9 ~= v8 then
                            return nil, "ConflictingActorId"
                        end
                        v10 = v4._actors[v8]
                        if v10 ~= nil then
                            v11 = v10.ActorIdsByGeneration[i59.Generation]
                            if v11 ~= nil and v11 ~= i59.ActorId then
                                return nil, "ActorIdChangedWithinGeneration"
                            end
                        end
                        continue
                    end
                    return nil, "DuplicateRemoteActorId"
                end
                for i60, i61 in v5.RemovedActorIds do
                    if not v14.SeenActorIds[i61] and not v14.RemovedActorIds[i61] then
                        continue
                    end
                    return nil, "DuplicateRemovedRemoteActorId"
                end
                v15 = 0
                v6 = nil
                v7 = nil
                for i62, i63 in v1, v6, v7 do
                    v9 = RemoteActorIdentity.key(i63)
                    v10 = v4._actors[v9]
                    v11 = true
                    if v10 ~= nil then
                        v11 = v10.ActorIdsByGeneration[i63.Generation] == nil
                    end
                    if v10 == nil then
                        v12 = {Generation = i63.Generation, ActorId = i63.ActorId}
                        v13 = {}
                        v13[i63.Generation] = i63.ActorId
                        v12.ActorIdsByGeneration = v13
                        v12.Samples = {}
                        v12.Activity = {}
                        v10 = v12
                        v4._actors[v9] = v10
                        v4._actorOrderDirty = true
                        v10.ActorIdsByGeneration[i63.Generation] = i63.ActorId
                        v4._actorIdToKey[i63.ActorId] = v9
                        if v11 then
                            reconcileCompleteFrames(v4, v9, v10, i63.ActorId)
                        end
                        v12 = {
                            Sequence = v5.Sequence,
                            ServerTick = v5.ServerTick,
                            TopologyRevision = v5.Topology.DestructibleRevision,
                            Actor = cloneActor(i63),
                        }
                        if upsertActorSample(v10, v12) then
                            upsertActivityEvent(v10, {
                                Active = true,
                                Sequence = v12.Sequence,
                                ServerTick = v12.ServerTick,
                                Generation = v12.Actor.Generation,
                                ActorId = v12.Actor.ActorId,
                            })
                            refreshCollisionIndex(v4, v10)
                            v15 = v15 + 1
                        end
                    elseif generationsAreChronological(v10, i63, v5.ServerTick) then
                        if i63.Generation == v10.Generation then
                            if i63.ActorId ~= v10.ActorId then
                                return nil, "ActorIdChangedWithinGeneration"
                            end
                        elseif 0 < (Serial.deltaUInt16(i63.Generation, v10.Generation)) then
                            v10.Generation = i63.Generation
                            v10.ActorId = i63.ActorId
                        end
                        v10.ActorIdsByGeneration[i63.Generation] = i63.ActorId
                        v4._actorIdToKey[i63.ActorId] = v9
                        if v11 then
                            reconcileCompleteFrames(v4, v9, v10, i63.ActorId)
                        end
                        v12 = {
                            Sequence = v5.Sequence,
                            ServerTick = v5.ServerTick,
                            TopologyRevision = v5.Topology.DestructibleRevision,
                            Actor = cloneActor(i63),
                        }
                        if upsertActorSample(v10, v12) then
                            upsertActivityEvent(v10, {
                                Active = true,
                                Sequence = v12.Sequence,
                                ServerTick = v12.ServerTick,
                                Generation = v12.Actor.Generation,
                                ActorId = v12.Actor.ActorId,
                            })
                            refreshCollisionIndex(v4, v10)
                            v15 = v15 + 1
                        end
                    end
                end
                for i64, i65 in v1 do
                    v14.SeenActorKeys[(RemoteActorIdentity.key(i65))] = true
                    v14.SeenActorIds[i65.ActorId] = true
                end
                for i66, i67 in v2 do
                    v14.RemovedActorKeys[i67] = true
                end
                for i68, i69 in v5.RemovedActorIds do
                    v14.RemovedActorIds[i69] = true
                end
                if v5.Kind == "Baseline" then
                    for i70, i71 in v5.Actors do
                        v14.BaselineActorsByActorId[i71.ActorId] = (cloneActor(i71))
                    end
                end
                v14.ReceivedChunks[v5.ChunkIndex] = true
                v14.ReceivedChunkCount = v14.ReceivedChunkCount + 1
                v16 = false
                if v14.ReceivedChunkCount == v14.ChunkCount then
                    admitCompleteFrame(v4, v5.Sequence, v14)
                    v16 = v5.Kind == "Baseline"
                end
                v4:_prune()
                if v16 and v4._retainedBaselines[v5.Sequence] ~= nil and #v4._heldDeltas > 0 then
                    releaseHeldDeltas(v4, v5.Sequence)
                end
                return v15, nil
            end
            return nil, "ConflictingRemoteFrame"
        end
        return nil, v3
    end
    return nil, "TopologyMismatch"
end

local function lowerBound(a1, a2, a3) -- Line: 1002
    -- upvalues: Serial (val)
    local v1
    local v2 = 1
    local v3 = #a1 + 1
    local v4, v5, v6 = a1, a2, a3
    while v2 < v3 do
        v1 = (v2 + v3) // 2
        if not (Serial.deltaUInt32(v4[v1].ServerTick, v5) < v6) then
            v3 = v1
        else
            v2 = v1 + 1
        end
    end
    return v2
end

local function upperBound(a1, a2, a3) -- Line: 1016
    -- upvalues: Serial (val)
    local v1
    local v2 = 1
    local v3 = #a1 + 1
    local v4, v5, v6 = a1, a2, a3
    while v2 < v3 do
        v1 = (v2 + v3) // 2
        if not (Serial.deltaUInt32(v4[v1].ServerTick, v5) <= v6) then
            v3 = v1
        else
            v2 = v1 + 1
        end
    end
    return v2
end

local function activityWindow(a1, a2, a3) -- Line: 1030
    -- upvalues: upperBound (val), Serial (val), relativeTick (val)
    local Activity = a1.Activity
    local v1 = upperBound(Activity, a2, a3) - 1
    local v2 = Activity[v1]
    if v2 ~= nil and v2.Active then
        local v3, v4, v5, v6
        local Generation = v2.Generation
        local ActorId = v2.ActorId
        local RunStart = v2.RunStart
        if RunStart == nil then
            local Active
            v3 = v1
            while v3 > 1 do
                v4 = Activity[v3 - 1]
                Active = v4.Active
                if Active then
                    Active = v2.Active
                    if Active then
                        Active = false
                        if v4.Generation == v2.Generation then
                            Active = v4.ActorId == v2.ActorId
                        end
                    end
                end
                if not Active then
                    break
                end
                v3 = v3 - 1
            end
            v6 = Serial.deltaUInt32(Activity[v3].ServerTick, a2)
        else
            v6 = math.max(Serial.deltaUInt32(RunStart.ServerTick, a2), (relativeTick(Activity[1].ServerTick, a2)))
        end
        v4 = v1 + 1
        v3 = #Activity
        for i = v4, v3 do
            v5 = Activity[i]
            if v5.Active and v5.Generation == Generation and v5.ActorId == ActorId then
                continue
            end
            return Generation, ActorId, v6, relativeTick(v5.ServerTick, a2)
        end
        return Generation, ActorId, v6, nil
    end
    return nil, nil, nil, nil
end

local function inWindow(a1, a2, a3, a4, a5, a6) -- Line: 1066
    -- upvalues: 
    local Actor = a1.Actor
    local v1 = false
    if Actor.Generation == a3 then
        v1 = false
        if Actor.ActorId == a4 then
            v1 = false
            if a5 <= a2 then
                v1 = true
                if a6 ~= nil then
                    v1 = a2 < a6
                end
            end
        end
    end
    return v1
end

local function bracketActivityWindow(a1, a2, a3, a4, a5, a6, a7) -- Line: 1082
    -- upvalues: Serial (val), lowerBound (val)
    local Actor, Actor_2, Actor_3, v1, v2, v3, v4, v5, v6
    local v7 = nil
    for i = #a1, 1, -1 do
        v1 = a1[i]
        v3 = Serial.deltaUInt32(v1.ServerTick, a2)
        Actor = v1.Actor
        v2 = false
        if Actor.Generation == a4 then
            v2 = false
            if Actor.ActorId == a5 then
                v2 = false
                if a6 <= v3 then
                    v2 = true
                    if a7 ~= nil then
                        v2 = v3 < a7
                    end
                end
            end
        end
        if v2 then
            v7 = v1
            break
        end
    end
    if v7 == nil then
        return nil, nil, 0, nil
    end
    local v8 = lowerBound(a1, a2, a3)
    local v9 = nil
    local v10 = 0
    for j = v8 - 1, 1, -1 do
        v4 = a1[j]
        v5 = Serial.deltaUInt32(v4.ServerTick, a2)
        Actor_2 = v4.Actor
        v6 = false
        if Actor_2.Generation == a4 then
            v6 = false
            if Actor_2.ActorId == a5 then
                v6 = false
                if a6 <= v5 then
                    v6 = true
                    if a7 ~= nil then
                        v6 = v5 < a7
                    end
                end
            end
        end
        if v6 then
            v9 = v4
            v10 = v5
            break
        end
    end
    v1 = #a1
    for k = v8, v1 do
        v4 = a1[k]
        v5 = Serial.deltaUInt32(v4.ServerTick, a2)
        Actor_3 = v4.Actor
        v6 = false
        if Actor_3.Generation == a4 then
            v6 = false
            if Actor_3.ActorId == a5 then
                v6 = false
                if a6 <= v5 then
                    v6 = true
                    if a7 ~= nil then
                        v6 = v5 < a7
                    end
                end
            end
        end
        if v6 then
            if v5 == a3 then
                return v4, nil, 0, v7
            end
            if v9 == nil then
                return nil, nil, 0, v7
            end
            v6 = v5 - v10
            return v9, v4, if not (v6 <= 0) then math.clamp((a3 - v10) / v6, 0, 1) else 0, v7
        end
    end
    if v9 ~= nil then
        return v9, nil, 1, v7
    end
    return nil, nil, 0, v7
end

local function renderPoseFromSorted(a1, a2, a3, a4, a5) -- Line: 1144
    -- upvalues: activityWindow (val), bracketActivityWindow (val), Serial (val), makePose (val)
    -- upvalues: interpolateSample (val)
    local v1 = a4 - a1._config.RenderInterpolationTicks
    local v2, v3, v4, v5 = activityWindow(a2, a3, v1)
    if v2 ~= nil and v3 ~= nil and v4 ~= nil then
        local v6, v7, v8, v9 = bracketActivityWindow(a2.Samples, a3, v1, v2, v3, v4, v5)
        if v6 ~= nil and v9 ~= nil then
            if v7 ~= nil then
                return (interpolateSample(v6, v7, v8, a5)), nil
            end
            local v10 = Serial.deltaUInt32(v6.ServerTick, a3)
            local v11 = a4 - a1._config.RenderInterpolationTicks - v10
            local v12 = (math.clamp(v11, 0, a1._config.MaxRemoteExtrapolationTicks)) / a1._mapping.SimulationHz
            local v13 = a1._config.MaxRemoteExtrapolationTicks < v11
            local Actor = v6.Actor
            local ServerTick = v6.ServerTick
            local TopologyRevision = v6.TopologyRevision
            local v14 = v6.Actor.Position + v6.Actor.Velocity * v12
            return (makePose(Actor, ServerTick, TopologyRevision, 1, v12, v14, if not v13 then nil else Vector3.new(0, 0, 0), nil, nil, nil, a5)), nil
        end
        return nil, "RemoteRenderPoseUnavailable"
    end
    return nil, "RemoteRenderPoseInactive"
end

local function collisionPoseFromSorted(a1) -- Line: 1193 -- upvalues: makePose (val) -- types: a1: table
    local v1 = a1.Activity[#a1.Activity]
    if v1 ~= nil and v1.Active then
        local v2
        local v3 = a1
        for i = #a1.Samples, 1, -1 do
            v2 = v3.Samples[i]
            if v2.Actor.Generation == v1.Generation and v2.Actor.ActorId == v1.ActorId then
                if v3.CollisionPoseSample ~= v2 or v3.CollisionPoseActivity ~= v1 or v3.CollisionPose == nil then
                    v3.CollisionPoseSample = v2
                    v3.CollisionPoseActivity = v1
                    v3.CollisionPose = makePose(v2.Actor, v2.ServerTick, v2.TopologyRevision, 1, 0)
                end
                return v3.CollisionPose, nil
            end
        end
        return nil, "RemoteCollisionPoseUnavailable"
    end
    return nil, "RemoteCollisionPoseInactive"
end

local function sortedHistory(a1, a2, a3, a4) -- Line: 1217
    -- upvalues: Serial (val), Quantization (val)
    local v1, v2, v3
    if Serial.isUInt32(a3) then
        v3 = a4 or 0
        if not Quantization.isFinite(v3) or v3 < 0 then
            v1 = nil
            v2 = "InvalidTickFraction"
        elseif not (v3 >= 1) then
            v1 = v3
            v2 = nil
        else
            v1 = nil
            v2 = "InvalidTickFraction"
        end
    else
        v1 = nil
        v2 = "InvalidCurrentServerTick"
    end
    if v1 == nil then
        return nil, nil, v2
    end
    v3 = a1._actors[a2]
    if v3 ~= nil and #v3.Samples ~= 0 then
        return v3, v1, nil
    end
    return nil, nil, "ActorNotBuffered"
end

function u66:getCollisionPose(a2, a3, a4) -- Line: 1234
    -- upvalues: Serial (val), Quantization (val), collisionPoseFromSorted (val)
    local v1, v2, v3, v4, v5, v6
    if Serial.isUInt32(a3) then
        v6 = a4 or 0
        if not Quantization.isFinite(v6) or v6 < 0 then
            v4 = nil
            v5 = "InvalidTickFraction"
        elseif not (v6 >= 1) then
            v4 = v6
            v5 = nil
        else
            v4 = nil
            v5 = "InvalidTickFraction"
        end
    else
        v4 = nil
        v5 = "InvalidCurrentServerTick"
    end
    if v4 ~= nil then
        v6 = self._actors[a2]
        if v6 == nil then
            v1 = nil
            v2 = nil
            v3 = "ActorNotBuffered"
        elseif #v6.Samples ~= 0 then
            v1 = v6
            v2 = v4
            v3 = nil
        else
            v1 = nil
            v2 = nil
            v3 = "ActorNotBuffered"
        end
    else
        v1 = nil
        v2 = nil
        v3 = v5
    end
    if v1 ~= nil and v2 ~= nil then
        return collisionPoseFromSorted(v1)
    end
    return nil, v3
end

function u66.getPresentationPoses(a1, a2, a3, a4) -- Line: 1247
    -- upvalues: Serial (val), Quantization (val), renderPoseFromSorted (val), collisionPoseFromSorted (val)
    local v1, v2, v3, v4, v5, v6
    if Serial.isUInt32(a3) then
        v6 = a4 or 0
        if not Quantization.isFinite(v6) or v6 < 0 then
            v4 = nil
            v5 = "InvalidTickFraction"
        elseif not (v6 >= 1) then
            v4 = v6
            v5 = nil
        else
            v4 = nil
            v5 = "InvalidTickFraction"
        end
    else
        v4 = nil
        v5 = "InvalidCurrentServerTick"
    end
    if v4 ~= nil then
        v6 = a1._actors[a2]
        if v6 == nil then
            v1 = nil
            v2 = nil
            v3 = "ActorNotBuffered"
        elseif #v6.Samples ~= 0 then
            v1 = v6
            v2 = v4
            v3 = nil
        else
            v1 = nil
            v2 = nil
            v3 = "ActorNotBuffered"
        end
    else
        v1 = nil
        v2 = nil
        v3 = v5
    end
    if v1 ~= nil and v2 ~= nil then
        v4 = a1._presentationPoseByActorKey[a2]
        v5, v6 = renderPoseFromSorted(a1, v1, a3, v2, v4)
        if v5 ~= nil and v4 == nil then
            a1._presentationPoseByActorKey[a2] = v5
        end
        local v7, v8 = collisionPoseFromSorted(v1)
        return v5, v7, if v5 ~= nil then nil else if v7 ~= nil then nil else v6 or v8
    end
    return nil, nil, v3
end

function u65.actorKeys(a1) -- Line: 1267
    return a1._actorKeys
end

function u65:getCollisionPose(a2, a3, a4) -- Line: 1271
    -- upvalues: Serial (val), Quantization (val)
    local v1, v2, v3
    if Serial.isUInt32(a3) then
        v3 = a4 or 0
        if not Quantization.isFinite(v3) or v3 < 0 then
            v1 = nil
            v2 = "InvalidTickFraction"
        elseif not (v3 >= 1) then
            v1 = v3
            v2 = nil
        else
            v1 = nil
            v2 = "InvalidTickFraction"
        end
    else
        v1 = nil
        v2 = "InvalidCurrentServerTick"
    end
    if v1 == nil then
        return nil, v2
    end
    v3 = self._poses[a2]
    local v4 = v3
    if v3 == nil then
        return v4, "ActorNotBuffered"
    end
    return v4, nil
end

function u65.getCollisionPoseByActorId(a1, a2, a3, a4) -- Line: 1280
    -- upvalues: 
    local v1 = a1._actorIdToKey[a2]
    if v1 == nil then
        return nil, "ActorIdNotBuffered"
    end
    return a1:getCollisionPose(v1, a3, a4)
end

function u65.queryCollisionActorKeys(a1, a2, a3) -- Line: 1292 -- types: a1: table, a2: vector, a3: vector
    local v1 = a1._broadphase:query(a2, a3, a1._queryActorIds)
    local _queryActorKeys = a1._queryActorKeys
    table.clear(_queryActorKeys)
    for i, j in v1 do
        _queryActorKeys[#_queryActorKeys + 1] = a1._actorIdToKey[j]
    end
    return _queryActorKeys
end

function u66.captureCollisionFrame(a1) -- Line: 1302
    -- upvalues: PlayerBroadphase (val), collisionPoseFromSorted (val), RemoteActorIdentity (val), u65 (val)
    local v1
    local _collisionFrame = a1._collisionFrame
    if _collisionFrame ~= nil then
        return _collisionFrame
    end
    local v2 = {}
    local v3 = {}
    local v4 = {}
    local v5 = PlayerBroadphase.new()
    for i, j in a1._actors do
        v1 = collisionPoseFromSorted(j)
        if v1 ~= nil then
            v2[#v2 + 1] = i
            v3[i] = (table.freeze(table.clone(v1)))
            v4[v1.ActorId] = i
            v5:upsert(v1.ActorId, v1.Position)
        end
    end
    table.sort(v2, RemoteActorIdentity.keyLess)
    local v6 = {
        _actorKeys = table.freeze(v2),
        _poses = table.freeze(v3),
        _actorIdToKey = table.freeze(v4),
        _broadphase = v5,
        _queryActorIds = {},
        _queryActorKeys = {},
    }
    local v7 = setmetatable(v6, u65)
    a1._collisionFrame = v7
    return v7
end

table.freeze(u65)
return table.freeze(u66)