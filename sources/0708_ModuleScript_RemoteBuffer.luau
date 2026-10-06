-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Config = require(script.Parent.Parent.Config);
local Mapping = require(script.Parent.Parent.Mapping);
local PlayerBroadphase = require(script.Parent.Parent.Simulation.PlayerBroadphase);
local Quantization = require(script.Parent.Parent.Quantization);
local RootFrame = require(script.Parent.Parent.RootFrame);
local RemoteActorIdentity = require(script.Parent.Parent.RemoteActorIdentity);
local RemoteSnapshotCodec = require(script.Parent.Parent.RemoteSnapshotCodec);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;
local u2 = {};
u2.__index = u2;

local function cloneActor(p3) -- Line: 138
    return {
        UserId = p3.UserId,
        ActorId = p3.ActorId,
        Generation = p3.Generation,
        Position = p3.Position,
        Velocity = p3.Velocity,
        LookYaw = p3.LookYaw,
        VerticalLook = p3.VerticalLook,
        MovementMode = p3.MovementMode,
        Stance = p3.Stance,
        OnGround = p3.OnGround,
        DuckAmount = p3.DuckAmount,
        SupportKind = p3.SupportKind,
        SupportSourceId = p3.SupportSourceId
    };
end;

local function restoredStudioUserId(p4: number) -- Line: 156
    -- upvalues: RunService (copy), Players (copy)
    if p4 == 0 or (not RunService:IsStudio() or Players:GetPlayerByUserId(p4) ~= nil) then
        return p4;
    end;

    local v5 = -p4;

    if Players:GetPlayerByUserId(v5) == nil then
        return p4;
    end;

    return v5;
end;

local function restoreStudioActor(p6) -- Line: 164
    -- upvalues: RunService (copy), cloneActor (copy), Players (copy)
    if not RunService:IsStudio() then
        return p6;
    end;

    local v7 = cloneActor(p6);
    local UserId = v7.UserId;

    if UserId ~= 0 and (RunService:IsStudio() and Players:GetPlayerByUserId(UserId) == nil) then
        local v8 = -UserId;

        if Players:GetPlayerByUserId(v8) ~= nil then
            UserId = v8;
        end;
    end;

    v7.UserId = UserId;

    return v7;
end;

local function actorStatesEqual(p9, p10) -- Line: 173
    local v11;

    if p9.UserId == p10.UserId and (p9.ActorId == p10.ActorId and (p9.Generation == p10.Generation and (p9.Position == p10.Position and (p9.Velocity == p10.Velocity and (p9.LookYaw == p10.LookYaw and (p9.VerticalLook == p10.VerticalLook and (p9.MovementMode == p10.MovementMode and (p9.Stance == p10.Stance and (p9.OnGround == p10.OnGround and (p9.DuckAmount == p10.DuckAmount and p9.SupportKind == p10.SupportKind)))))))))) then
        v11 = p9.SupportSourceId == p10.SupportSourceId;
    else
        v11 = false;
    end;

    return v11;
end;

local function shortestAngleLerp(p12: number, p13: number, p14: number) -- Line: 189
    return p12 + ((p13 - p12 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p14;
end;

local function makePose(p15: any, p16: number, p17: number, p18: number, p19: number, p20: vector?, p21: vector?, p22: number?, p23: number?, p24: number?, p25: table?) -- Line: 194
    -- upvalues: RootFrame (copy)
    local v26 = p25 or {};
    v26.UserId = p15.UserId;
    v26.ActorId = p15.ActorId;
    v26.Generation = p15.Generation;
    v26.Position = p20 or p15.Position;
    v26.Velocity = p21 or p15.Velocity;
    v26.LookYaw = p22 or p15.LookYaw;
    v26.VerticalLook = p23 or p15.VerticalLook;
    v26.MovementMode = p15.MovementMode;
    v26.Stance = p15.Stance;
    v26.OnGround = p15.OnGround;
    v26.DuckAmount = p24 or p15.DuckAmount;
    v26.SupportKind = p15.SupportKind;
    v26.SupportSourceId = p15.SupportSourceId;
    v26.SourceServerTick = p16;
    v26.TopologyRevision = p17;
    v26.InterpolationAlpha = p18;
    v26.ExtrapolatedSeconds = p19;
    v26.VisualRootPosition = RootFrame.simulationToVisualRootPosition(v26.Position, v26.DuckAmount);

    return v26;
end;

local function sampleVisualRoot(p27: table) -- Line: 229
    -- upvalues: RootFrame (copy)
    local VisualRoot = p27.VisualRoot;

    if VisualRoot == nil then
        VisualRoot = RootFrame.simulationToVisualRootPosition(p27.Actor.Position, p27.Actor.DuckAmount);
        p27.VisualRoot = VisualRoot;
    end;

    return VisualRoot;
end;

local function interpolateSample(p28: table, p29: table, p30: number, p31: table?) -- Line: 238
    -- upvalues: makePose (copy), RootFrame (copy)
    local math_clamp_ret = math.clamp(p30, 0, 1);
    local v32;

    if math_clamp_ret < 0.5 then
        v32 = p28.Actor;
    else
        v32 = p29.Actor;
    end;

    local v33;

    if math_clamp_ret < 0.5 then
        v33 = p28.ServerTick;
    else
        v33 = p29.ServerTick;
    end;

    local v34;

    if math_clamp_ret < 0.5 then
        v34 = p28.TopologyRevision;
    else
        v34 = p29.TopologyRevision;
    end;

    local v35 = p28.Actor.Position:Lerp(p29.Actor.Position, math_clamp_ret);
    local v36 = p28.Actor.Velocity:Lerp(p29.Actor.Velocity, math_clamp_ret);
    local LookYaw = p28.Actor.LookYaw;
    local v37 = makePose(v32, v33, v34, math_clamp_ret, 0, v35, v36, LookYaw + ((p29.Actor.LookYaw - LookYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math_clamp_ret, p28.Actor.VerticalLook + (p29.Actor.VerticalLook - p28.Actor.VerticalLook) * math_clamp_ret, p28.Actor.DuckAmount + (p29.Actor.DuckAmount - p28.Actor.DuckAmount) * math_clamp_ret, p31);
    local VisualRoot = p28.VisualRoot;

    if VisualRoot == nil then
        VisualRoot = RootFrame.simulationToVisualRootPosition(p28.Actor.Position, p28.Actor.DuckAmount);
        p28.VisualRoot = VisualRoot;
    end;

    local VisualRoot2 = p29.VisualRoot;

    if VisualRoot2 == nil then
        VisualRoot2 = RootFrame.simulationToVisualRootPosition(p29.Actor.Position, p29.Actor.DuckAmount);
        p29.VisualRoot = VisualRoot2;
    end;

    v37.VisualRootPosition = VisualRoot:Lerp(VisualRoot2, math_clamp_ret);

    return v37;
end;

local function validateClock(p38: number, p39: number?) -- Line: 258
    -- upvalues: Serial (copy), Quantization (copy)
    if not Serial.isUInt32(p38) then
        return nil, "InvalidCurrentServerTick";
    end;

    local v40 = p39 or 0;

    if Quantization.isFinite(v40) and (v40 >= 0 and v40 < 1) then
        return v40, nil;
    end;

    return nil, "InvalidTickFraction";
end;

local function relativeTick(p41: number, p42: number) -- Line: 269
    -- upvalues: Serial (copy)
    return Serial.deltaUInt32(p41, p42);
end;

function u2.new(p43) -- Line: 273
    -- upvalues: Mapping (copy), Config (copy), RunService (copy), PlayerBroadphase (copy), u2 (copy)
    local v44, v45 = Mapping.validate(p43);
    assert(v44, v45 or "invalid command mapping");
    local v46 = Config.derive(p43.SimulationHz);
    local v47;

    if RunService:IsStudio() then
        local RemoteHistoryTicks = v46.RemoteHistoryTicks;
        local math_ceil_ret = math.ceil(p43.SimulationHz * 0.75);
        v47 = math.max(RemoteHistoryTicks, math_ceil_ret);
    else
        v47 = v46.RemoteHistoryTicks;
    end;

    local v48 = math.ceil(v47 / v46.RemoteSnapshotEveryTicks) + 2;
    local math_max_ret = math.max(2, v48);
    local v49 = {
        _actorOrderDirty = false,
        _mapping = Mapping.clone(p43),
        _config = v46,
        _retentionHistoryTicks = v47,
        _maxSamplesPerActor = math_max_ret,
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
        _presentationPoseByActorKey = {}
    };

    return setmetatable(v49, u2);
end;

function u2.sharesStream(p50, p51) -- Line: 305
    local _mapping = p50._mapping;
    local v52;

    if _mapping.TopologyEpoch == p51.TopologyEpoch and _mapping.TopologyFingerprint == p51.TopologyFingerprint then
        v52 = _mapping.SimulationHz == p51.SimulationHz;
    else
        v52 = false;
    end;

    return v52;
end;

function u2.getCollisionPoseByActorId(p53: table, p54: number, p55: number, p56: number?) -- Line: 312
    local v57 = p53._actorIdToKey[p54];

    if v57 == nil then
        return nil, "ActorIdNotBuffered";
    end;

    local CollisionPose, v58 = p53:getCollisionPose(v57, p55, p56);

    if CollisionPose == nil or CollisionPose.ActorId == p54 then
        return CollisionPose, v58;
    end;

    return nil, "ActorIdInactive";
end;

function u2.actorKeys(p59) -- Line: 328
    -- upvalues: RemoteActorIdentity (copy)
    if not p59._actorOrderDirty then
        return p59._orderedActorKeys;
    end;

    local v60 = {};

    for i in p59._actors do
        table.insert(v60, i);
    end;

    table.sort(v60, RemoteActorIdentity.keyLess);
    p59._orderedActorKeys = table.freeze(v60);
    p59._actorOrderDirty = false;

    return p59._orderedActorKeys;
end;

function u2.latestServerTick(p61) -- Line: 342
    return p61._latestServerTick;
end;

function u2.latestCompleteServerTick(p62) -- Line: 347
    return p62._latestCompleteServerTick;
end;

function u2.queryCollisionActorKeys(p63: table, p64: vector, p65: vector) -- Line: 352
    local v66 = p63._collisionBroadphase:query(p64, p65, p63._collisionQueryActorIds);
    local _collisionQueryActorKeys = p63._collisionQueryActorKeys;
    table.clear(_collisionQueryActorKeys);

    for _, v in v66 do
        local v67 = p63._actorIdToKey[v];

        if v67 ~= nil then
            _collisionQueryActorKeys[#_collisionQueryActorKeys + 1] = v67;
        end;
    end;

    return _collisionQueryActorKeys;
end;

local function forgetActorId(p68: any, p69: any, p70: number) -- Line: 365
    p68._collisionBroadphase:remove(p70);

    if p68._actorIdToKey[p70] == p69 then
        p68._actorIdToKey[p70] = nil;
    end;
end;

function u2.forgetActor(p71, p72) -- Line: 373
    local v73 = p71._actors[p72];

    if v73 == nil then
        return;
    end;

    for _, v in v73.ActorIdsByGeneration do
        p71._collisionBroadphase:remove(v);

        if p71._actorIdToKey[v] == p72 then
            p71._actorIdToKey[v] = nil;
        end;
    end;

    p71._collisionFrame = nil;
    p71._actors[p72] = nil;
    p71._presentationPoseByActorKey[p72] = nil;
    p71._actorOrderDirty = true;
end;

local table_freeze_ret = table.freeze({});
local u74 = {};
local u75 = {};

function u2._prune(p76) -- Line: 392
    -- upvalues: Serial (copy), u74 (copy), table_freeze_ret (copy), u75 (copy)
    local _latestServerTick = p76._latestServerTick;

    if _latestServerTick == nil then
        return;
    end;

    local _retentionHistoryTicks = p76._retentionHistoryTicks;

    for i, v in p76._frames do
        if _retentionHistoryTicks < Serial.deltaUInt32(_latestServerTick, v.ServerTick) then
            p76._frames[i] = nil;
        end;
    end;

    for i, v in p76._actors do
        local v77 = v.Samples[#v.Samples];
        local v78 = v.Activity[#v.Activity];
        local v79;

        if v78 == nil then
            v79 = false;
        else
            v79 = not v78.Active;
        end;

        if v77 == nil or (not v79 or _retentionHistoryTicks >= Serial.deltaUInt32(_latestServerTick, v77.ServerTick)) then
            local Samples = v.Samples;
            local v80 = #Samples;
            local v81 = i;
            local v82 = v;
            local v83 = 0;

            while v80 - v83 > 1 and (v80 - v83 > p76._maxSamplesPerActor or Serial.deltaUInt32(_latestServerTick, Samples[v83 + 1].ServerTick) > _retentionHistoryTicks) do
                v83 = v83 + 1;
            end;

            if v83 > 0 then
                table.move(Samples, v83 + 1, v80, 1);

                for i2 = v80 - v83 + 1, v80 do
                    Samples[i2] = nil;
                    local _ = i2;
                end;
            end;

            local Activity = v82.Activity;
            local v84 = #Activity;
            local v85 = 0;

            while v84 - v85 > 1 and Serial.deltaUInt32(_latestServerTick, Activity[v85 + 2].ServerTick) > _retentionHistoryTicks do
                v85 = v85 + 1;
            end;

            if v85 > 0 then
                table.move(Activity, v85 + 1, v84, 1);

                for i2 = v84 - v85 + 1, v84 do
                    Activity[i2] = nil;
                    local _ = i2;
                end;
            end;

            local v86 = u74;
            table.clear(v86);

            for _, v2 in Samples do
                local Actor = v2.Actor;
                local v87 = v86[Actor.Generation];

                if v87 == nil then
                    v86[Actor.Generation] = Actor.ActorId;
                elseif v87 ~= Actor.ActorId then
                    v86[Actor.Generation] = table_freeze_ret;
                    u75[Actor.Generation] = u75[Actor.Generation] or {};
                    u75[Actor.Generation][v87] = true;
                    u75[Actor.Generation][Actor.ActorId] = true;
                end;
            end;

            for i2, v2 in v82.ActorIdsByGeneration do
                local v88 = v86[i2];
                local v89;

                if v88 == v2 then
                    v89 = true;
                elseif v88 == table_freeze_ret then
                    v89 = u75[i2][v2] == true;
                else
                    v89 = false;
                end;

                if not v89 then
                    v82.ActorIdsByGeneration[i2] = nil;
                    p76._collisionBroadphase:remove(v2);

                    if p76._actorIdToKey[v2] == v81 then
                        p76._actorIdToKey[v2] = nil;
                    end;
                end;
            end;

            table.clear(u75);
        else
            local v90 = i;

            for _, v2 in v.ActorIdsByGeneration do
                p76._collisionBroadphase:remove(v2);

                if p76._actorIdToKey[v2] == v90 then
                    p76._actorIdToKey[v2] = nil;
                end;
            end;

            p76._collisionFrame = nil;
            p76._actors[v90] = nil;
            p76._presentationPoseByActorKey[v90] = nil;
            p76._actorOrderDirty = true;
        end;
    end;
end;

local function upsertActorSample(p91: table, p92: table) -- Line: 488
    -- upvalues: Serial (copy)
    local Samples = p91.Samples;

    for i = #Samples, 1, -1 do
        local v93 = Samples[i];

        if v93.ServerTick == p92.ServerTick then
            if v93.Sequence == p92.Sequence then
                return false;
            end;

            if not Serial.isNewerUInt32(p92.Sequence, v93.Sequence) then
                return false;
            end;

            Samples[i] = p92;

            return true;
        end;

        if Serial.deltaUInt32(p92.ServerTick, v93.ServerTick) > 0 then
            table.insert(Samples, i + 1, p92);

            return true;
        end;

        local _ = i;
    end;

    table.insert(Samples, 1, p92);

    return true;
end;

local function continuesRun(p94: table, p95: table) -- Line: 511
    local v96 = p94.Active and p95.Active;

    if v96 then
        if p94.Generation == p95.Generation then
            v96 = p94.ActorId == p95.ActorId;
        else
            v96 = false;
        end;
    end;

    return v96;
end;

local function linkRuns(p97: table, p98: number) -- Line: 519
    for i = p98, #p97 do
        local v99 = p97[i];
        local v100 = p97[i - 1];
        local v101;

        if v100 == nil then
            v101 = v99;
        else
            local v102 = v100.Active and v99.Active;

            if v102 then
                if v100.Generation == v99.Generation then
                    v102 = v100.ActorId == v99.ActorId;
                else
                    v102 = false;
                end;
            end;

            if v102 then
                v101 = v100.RunStart;
            else
                v101 = v99;
            end;
        end;

        v99.RunStart = v101;
        local _ = i;
    end;
end;

local function upsertActivityEvent(p103: table, p104: table) -- Line: 528
    -- upvalues: Serial (copy), linkRuns (copy)
    local Activity = p103.Activity;

    for i = #Activity, 1, -1 do
        local v105 = Activity[i];

        if v105.ServerTick == p104.ServerTick then
            if v105.Sequence == p104.Sequence then
                return false;
            end;

            if not Serial.isNewerUInt32(p104.Sequence, v105.Sequence) then
                return false;
            end;

            Activity[i] = p104;
            linkRuns(Activity, i);

            return true;
        end;

        if Serial.deltaUInt32(p104.ServerTick, v105.ServerTick) > 0 then
            table.insert(Activity, i + 1, p104);
            linkRuns(Activity, i + 1);

            return true;
        end;

        local _ = i;
    end;

    table.insert(Activity, 1, p104);
    linkRuns(Activity, 1);

    return true;
end;

local function activeEvent(p106: table) -- Line: 554
    return {
        Active = true,
        Sequence = p106.Sequence,
        ServerTick = p106.ServerTick,
        Generation = p106.Actor.Generation,
        ActorId = p106.Actor.ActorId
    };
end;

local function inactiveEvent(p107: table, p108: number) -- Line: 564
    return {
        Active = false,
        Generation = 0,
        ActorId = 0,
        Sequence = p108,
        ServerTick = p107.ServerTick
    };
end;

local function refreshCollisionIndex(p109: any, p110: table) -- Line: 574
    p109._collisionFrame = nil;
    local v111 = p110.Activity[#p110.Activity];

    if v111 == nil or not v111.Active then
        for _, v in p110.ActorIdsByGeneration do
            p109._collisionBroadphase:remove(v);
        end;

        return;
    end;

    for _, v in p110.ActorIdsByGeneration do
        if v ~= v111.ActorId then
            p109._collisionBroadphase:remove(v);
        end;
    end;

    for i = #p110.Samples, 1, -1 do
        local v112 = p110.Samples[i];

        if v112.Actor.Generation == v111.Generation and v112.Actor.ActorId == v111.ActorId then
            p109._collisionBroadphase:upsert(v112.Actor.ActorId, v112.Actor.Position);

            return;
        end;

        local _ = i;
    end;
end;

local function reconcileCompleteFrames(p113: any, p114: any, p115: table, p116: number) -- Line: 597
    -- upvalues: upsertActivityEvent (copy)
    for i, v in p113._frames do
        if v.AuthoritativeLifecycle and (v.Kind == "Baseline" and not v.SeenActorKeys[p114] or (v.RemovedActorKeys[p114] or v.RemovedActorIds[p116]) and not v.SeenActorKeys[p114]) then
            upsertActivityEvent(p115, {
                Active = false,
                Generation = 0,
                ActorId = 0,
                Sequence = i,
                ServerTick = v.ServerTick
            });
        end;
    end;
end;

local function applyFrameLifecycle(p117: any, p118: number, p119: table) -- Line: 614
    -- upvalues: Serial (copy), RunService (copy), cloneActor (copy), Players (copy), RemoteActorIdentity (copy), actorStatesEqual (copy), upsertActorSample (copy), upsertActivityEvent (copy), refreshCollisionIndex (copy)
    if p119.AuthoritativeLifecycle then
        return;
    end;

    p119.AuthoritativeLifecycle = true;
    local _latestCompleteServerTick = p117._latestCompleteServerTick;

    if _latestCompleteServerTick == nil or Serial.isNewerUInt32(p119.ServerTick, _latestCompleteServerTick) then
        p117._latestCompleteServerTick = p119.ServerTick;
    end;

    if p119.Kind == "Delta" and p119.BaselineSequence == p117._baselineSequence then
        for i, v in p117._baselineActorsByActorId do
            if not (p119.SeenActorIds[i] or p119.RemovedActorIds[i]) then
                local v120;

                if RunService:IsStudio() then
                    v120 = cloneActor(v);
                    local UserId = v120.UserId;

                    if UserId ~= 0 and (RunService:IsStudio() and Players:GetPlayerByUserId(UserId) == nil) then
                        local v121 = -UserId;

                        if Players:GetPlayerByUserId(v121) ~= nil then
                            UserId = v121;
                        end;
                    end;

                    v120.UserId = UserId;
                else
                    v120 = v;
                end;

                local v122 = RemoteActorIdentity.key(v120);
                p119.SeenActorKeys[v122] = true;
                p119.SeenActorIds[i] = true;
                local v123 = p117._actors[v122];
                local v124;

                if v123 == nil then
                    v124 = nil;
                else
                    v124 = v123.Samples[#v123.Samples];
                end;

                local v125;

                if v123 == nil then
                    v125 = nil;
                else
                    v125 = v123.Activity[#v123.Activity];
                end;

                if v123 ~= nil and (v124 == nil or not (actorStatesEqual(v124.Actor, v120) and (v125 ~= nil and (v125.Active and (v125.ActorId == i and v125.Generation == v120.Generation))))) then
                    local v126 = {
                        Sequence = p118,
                        ServerTick = p119.ServerTick,
                        TopologyRevision = p119.TopologyRevision,
                        Actor = v120
                    };
                    upsertActorSample(v123, v126);
                    upsertActivityEvent(v123, {
                        Active = true,
                        Sequence = v126.Sequence,
                        ServerTick = v126.ServerTick,
                        Generation = v126.Actor.Generation,
                        ActorId = v126.Actor.ActorId
                    });
                    refreshCollisionIndex(p117, v123);
                end;
            end;
        end;
    end;

    for i in p119.RemovedActorIds do
        local v127 = p117._actorIdToKey[i];

        if v127 ~= nil then
            p119.RemovedActorKeys[v127] = true;
        end;
    end;

    for i, v in p117._actors do
        if p119.Kind == "Baseline" and not p119.SeenActorKeys[i] or p119.RemovedActorKeys[i] and not p119.SeenActorKeys[i] then
            upsertActivityEvent(v, {
                Active = false,
                Generation = 0,
                ActorId = 0,
                Sequence = p118,
                ServerTick = p119.ServerTick
            });
            refreshCollisionIndex(p117, v);
        end;
    end;
end;

local function retainBaseline(p128: any, p129: number, p130: table) -- Line: 679
    -- upvalues: Serial (copy)
    local _retainedBaselineOrder = p128._retainedBaselineOrder;

    if p128._retainedBaselines[p129] ~= nil then
        return;
    end;

    local v131 = #_retainedBaselineOrder + 1;

    for i, v in _retainedBaselineOrder do
        if Serial.isNewerUInt32(v, p129) then
            v131 = i;
            break;
        end;
    end;

    table.insert(_retainedBaselineOrder, v131, p129);
    p128._retainedBaselines[p129] = p130;

    while #_retainedBaselineOrder > 3 do
        p128._retainedBaselines[table.remove(_retainedBaselineOrder, 1)] = nil;
    end;
end;

local function admitCompleteFrame(p132: any, p133: number, p134: table) -- Line: 698
    -- upvalues: cloneActor (copy), retainBaseline (copy), Serial (copy), applyFrameLifecycle (copy)
    if p134.Kind ~= "Baseline" then
        local _baselineSequence = p132._baselineSequence;
        local _lastAppliedSequence = p132._lastAppliedSequence;

        if _baselineSequence ~= nil and (_lastAppliedSequence ~= nil and (p134.BaselineSequence == _baselineSequence and Serial.isNewerUInt32(p133, _lastAppliedSequence))) then
            applyFrameLifecycle(p132, p133, p134);
            p132._lastAppliedSequence = p133;
        end;

        return;
    end;

    local v135 = {};

    for i, v in p134.BaselineActorsByActorId do
        v135[i] = cloneActor(v);
    end;

    retainBaseline(p132, p133, v135);
    local _baselineSequence = p132._baselineSequence;

    if _baselineSequence == nil or Serial.isNewerUInt32(p133, _baselineSequence) then
        p132._baselineActorsByActorId = v135;
        p132._baselineSequence = p133;
        p132._lastAppliedSequence = p133;
        applyFrameLifecycle(p132, p133, p134);
    end;
end;

local function generationsAreChronological(p136: table, p137: any, p138: number) -- Line: 728
    -- upvalues: Serial (copy)
    local v139 = next(p136.ActorIdsByGeneration);

    if v139 == p137.Generation and next(p136.ActorIdsByGeneration, v139) == nil then
        return true;
    end;

    for _, v in p136.Samples do
        local v140 = Serial.deltaUInt16(p137.Generation, v.Actor.Generation);
        local v141 = Serial.deltaUInt32(p138, v.ServerTick);

        if v140 > 0 and v141 <= 0 or v140 < 0 and v141 >= 0 then
            return false;
        end;
    end;

    return true;
end;

local function expandSnapshotRecords(p142, p143) -- Line: 744
    -- upvalues: RunService (copy), cloneActor (copy), Players (copy), RemoteSnapshotCodec (copy), RemoteActorIdentity (copy)
    local table_create_ret = table.create(#p143.Actors + #p143.Deltas);

    for _, v in p143.Actors do
        local v144;

        if RunService:IsStudio() then
            v144 = cloneActor(v);
            local UserId = v144.UserId;

            if UserId ~= 0 and (RunService:IsStudio() and Players:GetPlayerByUserId(UserId) == nil) then
                local v145 = -UserId;

                if Players:GetPlayerByUserId(v145) ~= nil then
                    UserId = v145;
                end;
            end;

            v144.UserId = UserId;
        else
            v144 = v;
        end;

        table_create_ret[#table_create_ret + 1] = v144;
    end;

    local _baselineActorsByActorId = p142._baselineActorsByActorId;

    if p143.Kind == "Delta" then
        _baselineActorsByActorId = p142._retainedBaselines[p143.BaselineSequence];

        if _baselineActorsByActorId == nil then
            return nil, nil, "RemoteBaselineRequired";
        end;

        for _, v in p143.Deltas do
            local v146 = _baselineActorsByActorId[v.ActorId];

            if v146 == nil then
                return nil, nil, "RemoteDeltaActorMissingFromBaseline";
            end;

            local v147, v148 = RemoteSnapshotCodec.applyDeltaToCanonicalBaseline(v146, v, true);

            if v147 == nil then
                return nil, nil, v148;
            end;

            if RunService:IsStudio() then
                v147 = cloneActor(v147);
                local UserId = v147.UserId;

                if UserId ~= 0 and (RunService:IsStudio() and Players:GetPlayerByUserId(UserId) == nil) then
                    local v149 = -UserId;

                    if Players:GetPlayerByUserId(v149) ~= nil then
                        UserId = v149;
                    end;
                end;

                v147.UserId = UserId;
            end;

            table_create_ret[#table_create_ret + 1] = v147;
        end;
    elseif #p143.Deltas > 0 or #p143.RemovedActorIds > 0 then
        return nil, nil, "RemoteBaselineHasDeltaRecords";
    end;

    local table_create_ret2 = table.create(#p143.RemovedActorIds);

    for i, v in p143.RemovedActorIds do
        local v150 = _baselineActorsByActorId[v];
        local v151;

        if v150 == nil then
            v151 = p142._actorIdToKey[v];
        else
            local key = RemoteActorIdentity.key;

            if RunService:IsStudio() then
                v150 = cloneActor(v150);
                local UserId = v150.UserId;

                if UserId ~= 0 and (RunService:IsStudio() and Players:GetPlayerByUserId(UserId) == nil) then
                    local v152 = -UserId;

                    if Players:GetPlayerByUserId(v152) ~= nil then
                        UserId = v152;
                    end;
                end;

                v150.UserId = UserId;
            end;

            v151 = key(v150);
        end;

        table_create_ret2[i] = v151;
    end;

    return table_create_ret, table_create_ret2, nil;
end;

local function holdDelta(p153, p154) -- Line: 786
    -- upvalues: Serial (copy)
    local _heldDeltas = p153._heldDeltas;
    local _latestServerTick = p153._latestServerTick;

    for i = #_heldDeltas, 1, -1 do
        local v155;

        if _latestServerTick == nil then
            v155 = false;
        else
            v155 = Serial.deltaUInt32(_latestServerTick, _heldDeltas[i].ServerTick) > p153._retentionHistoryTicks;
        end;

        local v156;

        if v155 or _heldDeltas[i].Sequence == p154.Sequence and _heldDeltas[i].ChunkIndex == p154.ChunkIndex then
            table.remove(_heldDeltas, i);
            v156 = i;
        else
            v156 = i;
        end;
    end;

    if #_heldDeltas >= 24 then
        table.remove(_heldDeltas, 1);
    end;

    _heldDeltas[#_heldDeltas + 1] = p154;
end;

local function releaseHeldDeltas(p157: any, p158: number) -- Line: 802
    -- upvalues: Serial (copy)
    local _heldDeltas = p157._heldDeltas;
    local v159 = {};

    for i = #_heldDeltas, 1, -1 do
        local v160;

        if _heldDeltas[i].BaselineSequence == p158 then
            v159[#v159 + 1] = table.remove(_heldDeltas, i);
            v160 = i;
        else
            v160 = i;
        end;
    end;

    table.sort(v159, function(p161, p162) -- Line: 810
        -- upvalues: Serial (ref)
        return Serial.isNewerUInt32(p162.Sequence, p161.Sequence);
    end);

    for _, v in v159 do
        p157:pushDecoded(v);
    end;
end;

function u2.pushDecoded(p163, p164) -- Line: 819
    -- upvalues: Serial (copy), holdDelta (copy), expandSnapshotRecords (copy), RemoteActorIdentity (copy), generationsAreChronological (copy), reconcileCompleteFrames (copy), cloneActor (copy), upsertActorSample (copy), upsertActivityEvent (copy), refreshCollisionIndex (copy), admitCompleteFrame (copy), releaseHeldDeltas (copy)
    if p164.Topology.Epoch ~= p163._mapping.TopologyEpoch or p164.Topology.Fingerprint ~= p163._mapping.TopologyFingerprint then
        return nil, "TopologyMismatch";
    end;

    if p164.Kind == "Delta" and p163._retainedBaselines[p164.BaselineSequence] == nil then
        local _baselineSequence = p163._baselineSequence;

        if _baselineSequence ~= nil and not Serial.isNewerUInt32(p164.BaselineSequence, _baselineSequence) then
            return nil, "RemoteBaselineRequired";
        end;

        holdDelta(p163, p164);

        return nil, "RemoteDeltaHeld";
    end;

    local v165, v166, v167 = expandSnapshotRecords(p163, p164);

    if v165 == nil or v166 == nil then
        return nil, v167;
    end;

    local v168 = p163._frames[p164.Sequence];

    if v168 ~= nil and (v168.Kind ~= p164.Kind or (v168.BaselineSequence ~= p164.BaselineSequence or (v168.ServerTick ~= p164.ServerTick or (v168.TopologyRevision ~= p164.Topology.DestructibleRevision or v168.ChunkCount ~= p164.ChunkCount)))) then
        return nil, "ConflictingRemoteFrame";
    end;

    if v168 ~= nil and v168.ReceivedChunks[p164.ChunkIndex] then
        return nil, "DuplicateRemoteChunk";
    end;

    local _latestServerTick = p163._latestServerTick;

    if _latestServerTick == nil then
        p163._latestServerTick = p164.ServerTick;
        p163._latestTopologyRevision = p164.Topology.DestructibleRevision;
    else
        if Serial.deltaUInt32(_latestServerTick, p164.ServerTick) > p163._retentionHistoryTicks then
            return nil, "RemoteSnapshotTooOld";
        end;

        if Serial.isNewerUInt32(p164.ServerTick, _latestServerTick) then
            if p163._latestTopologyRevision ~= nil and Serial.deltaUInt32(p164.Topology.DestructibleRevision, p163._latestTopologyRevision) < 0 then
                return nil, "TopologyRevisionRegressed";
            end;

            p163._latestServerTick = p164.ServerTick;
            p163._latestTopologyRevision = p164.Topology.DestructibleRevision;
        end;
    end;

    if v168 == nil then
        v168 = {
            ReceivedChunkCount = 0,
            AuthoritativeLifecycle = false,
            Kind = p164.Kind,
            BaselineSequence = p164.BaselineSequence,
            ServerTick = p164.ServerTick,
            TopologyRevision = p164.Topology.DestructibleRevision,
            ChunkCount = p164.ChunkCount,
            ReceivedChunks = {},
            SeenActorKeys = {},
            SeenActorIds = {},
            RemovedActorKeys = {},
            RemovedActorIds = {},
            BaselineActorsByActorId = {}
        };
        p163._frames[p164.Sequence] = v168;
    end;

    for _, v in v165 do
        local v169 = RemoteActorIdentity.key(v);

        if v168.SeenActorKeys[v169] then
            return nil, "DuplicateRemoteActorUserId";
        end;

        if v168.SeenActorIds[v.ActorId] or v168.RemovedActorIds[v.ActorId] then
            return nil, "DuplicateRemoteActorId";
        end;

        local v170 = p163._actorIdToKey[v.ActorId];

        if v170 ~= nil and v170 ~= v169 then
            return nil, "ConflictingActorId";
        end;

        local v171 = p163._actors[v169];

        if v171 ~= nil then
            local v172 = v171.ActorIdsByGeneration[v.Generation];

            if v172 ~= nil and v172 ~= v.ActorId then
                return nil, "ActorIdChangedWithinGeneration";
            end;
        end;
    end;

    for _, v in p164.RemovedActorIds do
        if v168.SeenActorIds[v] or v168.RemovedActorIds[v] then
            return nil, "DuplicateRemovedRemoteActorId";
        end;
    end;

    local v173 = 0;

    for _, v in v165 do
        local v174 = RemoteActorIdentity.key(v);
        local v175 = p163._actors[v174];
        local v176 = v175 == nil and true or v175.ActorIdsByGeneration[v.Generation] == nil;
        local v177;

        if v175 == nil then
            v175 = {
                Generation = v.Generation,
                ActorId = v.ActorId,
                ActorIdsByGeneration = {
                    [v.Generation] = v.ActorId
                },
                Samples = {},
                Activity = {}
            };
            p163._actors[v174] = v175;
            p163._actorOrderDirty = true;
            v175.ActorIdsByGeneration[v.Generation] = v.ActorId;
            p163._actorIdToKey[v.ActorId] = v174;

            if v176 then
                reconcileCompleteFrames(p163, v174, v175, v.ActorId);
            end;

            v177 = {
                Sequence = p164.Sequence,
                ServerTick = p164.ServerTick,
                TopologyRevision = p164.Topology.DestructibleRevision,
                Actor = cloneActor(v)
            };

            if upsertActorSample(v175, v177) then
                upsertActivityEvent(v175, {
                    Active = true,
                    Sequence = v177.Sequence,
                    ServerTick = v177.ServerTick,
                    Generation = v177.Actor.Generation,
                    ActorId = v177.Actor.ActorId
                });
                refreshCollisionIndex(p163, v175);
                v173 = v173 + 1;
            end;
        elseif generationsAreChronological(v175, v, p164.ServerTick) then
            if v.Generation == v175.Generation then
                if v.ActorId ~= v175.ActorId then
                    return nil, "ActorIdChangedWithinGeneration";
                end;
            elseif Serial.deltaUInt16(v.Generation, v175.Generation) > 0 then
                v175.Generation = v.Generation;
                v175.ActorId = v.ActorId;
            end;

            v175.ActorIdsByGeneration[v.Generation] = v.ActorId;
            p163._actorIdToKey[v.ActorId] = v174;

            if v176 then
                reconcileCompleteFrames(p163, v174, v175, v.ActorId);
            end;

            v177 = {
                Sequence = p164.Sequence,
                ServerTick = p164.ServerTick,
                TopologyRevision = p164.Topology.DestructibleRevision,
                Actor = cloneActor(v)
            };

            if upsertActorSample(v175, v177) then
                upsertActivityEvent(v175, {
                    Active = true,
                    Sequence = v177.Sequence,
                    ServerTick = v177.ServerTick,
                    Generation = v177.Actor.Generation,
                    ActorId = v177.Actor.ActorId
                });
                refreshCollisionIndex(p163, v175);
                v173 = v173 + 1;
            end;
        end;
    end;

    for _, v in v165 do
        v168.SeenActorKeys[RemoteActorIdentity.key(v)] = true;
        v168.SeenActorIds[v.ActorId] = true;
    end;

    for _, v in v166 do
        v168.RemovedActorKeys[v] = true;
    end;

    for _, v in p164.RemovedActorIds do
        v168.RemovedActorIds[v] = true;
    end;

    if p164.Kind == "Baseline" then
        for _, v in p164.Actors do
            v168.BaselineActorsByActorId[v.ActorId] = cloneActor(v);
        end;
    end;

    v168.ReceivedChunks[p164.ChunkIndex] = true;
    v168.ReceivedChunkCount = v168.ReceivedChunkCount + 1;
    local v178;

    if v168.ReceivedChunkCount == v168.ChunkCount then
        admitCompleteFrame(p163, p164.Sequence, v168);
        v178 = p164.Kind == "Baseline";
    else
        v178 = false;
    end;

    p163:_prune();

    if v178 and (p163._retainedBaselines[p164.Sequence] ~= nil and #p163._heldDeltas > 0) then
        releaseHeldDeltas(p163, p164.Sequence);
    end;

    return v173, nil;
end;

local function lowerBound(p179: table, p180: number, p181: number) -- Line: 1002
    -- upvalues: Serial (copy)
    local v182 = #p179 + 1;
    local v183 = 1;

    while v183 < v182 do
        local v184 = (v183 + v182) // 2;

        if Serial.deltaUInt32(p179[v184].ServerTick, p180) < p181 then
            v183 = v184 + 1;
        else
            v182 = v184;
        end;
    end;

    return v183;
end;

local function upperBound(p185: table, p186: number, p187: number) -- Line: 1016
    -- upvalues: Serial (copy)
    local v188 = #p185 + 1;
    local v189 = 1;

    while v189 < v188 do
        local v190 = (v189 + v188) // 2;

        if Serial.deltaUInt32(p185[v190].ServerTick, p186) <= p187 then
            v189 = v190 + 1;
        else
            v188 = v190;
        end;
    end;

    return v189;
end;

local function activityWindow(p191: table, p192: number, p193: number) -- Line: 1030
    -- upvalues: upperBound (copy), Serial (copy), relativeTick (copy)
    local Activity = p191.Activity;
    local v194 = upperBound(Activity, p192, p193) - 1;
    local v195 = Activity[v194];

    if v195 == nil or not v195.Active then
        return nil, nil, nil, nil;
    end;

    local Generation = v195.Generation;
    local ActorId = v195.ActorId;
    local RunStart = v195.RunStart;
    local v196;

    if RunStart == nil then
        local v197 = v194;

        while v194 > 1 do
            local v198 = Activity[v194 - 1];
            local v199 = v198.Active and v195.Active;

            if v199 then
                if v198.Generation == v195.Generation then
                    v199 = v198.ActorId == v195.ActorId;
                else
                    v199 = false;
                end;
            end;

            if not v199 then
                break;
            end;

            v194 = v194 - 1;
        end;

        v196 = Serial.deltaUInt32(Activity[v194].ServerTick, p192);
        v194 = v197;
    else
        local v200 = Serial.deltaUInt32(RunStart.ServerTick, p192);
        v196 = math.max(v200, relativeTick(Activity[1].ServerTick, p192));
    end;

    for i = v194 + 1, #Activity do
        local v201 = Activity[i];

        if not (v201.Active and (v201.Generation == Generation and v201.ActorId == ActorId)) then
            return Generation, ActorId, v196, relativeTick(v201.ServerTick, p192);
        end;

        local _ = i;
    end;

    return Generation, ActorId, v196, nil;
end;

local function inWindow(p202: table, p203: number, p204: number, p205: number, p206: number, p207: number?) -- Line: 1066
    local Actor = p202.Actor;
    local v208;

    if Actor.Generation == p204 and (Actor.ActorId == p205 and p206 <= p203) then
        v208 = p207 == nil and true or p203 < p207;
    else
        v208 = false;
    end;

    return v208;
end;

local function bracketActivityWindow(p209: table, p210: number, p211: number, p212: number, p213: number, p214: number, p215: number?) -- Line: 1082
    -- upvalues: Serial (copy), lowerBound (copy)
    local v216 = nil;

    for i = #p209, 1, -1 do
        local v217 = p209[i];
        local v218 = Serial.deltaUInt32(v217.ServerTick, p210);
        local Actor = v217.Actor;
        local v219;

        if Actor.Generation == p212 and (Actor.ActorId == p213 and p214 <= v218) then
            v219 = p215 == nil and true or v218 < p215;
        else
            v219 = false;
        end;

        if v219 then
            v216 = v217;
            break;
        end;

        local _ = i;
    end;

    if v216 == nil then
        return nil, nil, 0, nil;
    end;

    local v220 = lowerBound(p209, p210, p211);
    local v221 = nil;
    local v222 = 0;

    for i = v220 - 1, 1, -1 do
        local v223 = p209[i];
        local v224 = Serial.deltaUInt32(v223.ServerTick, p210);
        local Actor = v223.Actor;
        local v225;

        if Actor.Generation == p212 and (Actor.ActorId == p213 and p214 <= v224) then
            v225 = p215 == nil and true or v224 < p215;
        else
            v225 = false;
        end;

        if v225 then
            v222 = v224;
            v221 = v223;
            break;
        end;

        local _ = i;
    end;

    for i = v220, #p209 do
        local v226 = p209[i];
        local v227 = Serial.deltaUInt32(v226.ServerTick, p210);
        local Actor = v226.Actor;
        local v228;

        if Actor.Generation == p212 and (Actor.ActorId == p213 and p214 <= v227) then
            v228 = p215 == nil and true or v227 < p215;
        else
            v228 = false;
        end;

        if v228 then
            if v227 == p211 then
                return v226, nil, 0, v216;
            end;

            if v221 == nil then
                return nil, nil, 0, v216;
            end;

            local v229 = v227 - v222;

            return v221, v226, v229 <= 0 and 0 or math.clamp((p211 - v222) / v229, 0, 1), v216;
        end;

        local _ = i;
    end;

    if v221 == nil then
        return nil, nil, 0, v216;
    end;

    return v221, nil, 1, v216;
end;

local function renderPoseFromSorted(p230: any, p231: table, p232: number, p233: number, p234: table?) -- Line: 1144
    -- upvalues: activityWindow (copy), bracketActivityWindow (copy), Serial (copy), makePose (copy), interpolateSample (copy)
    local v235 = p233 - p230._config.RenderInterpolationTicks;
    local v236, v237, v238, v239 = activityWindow(p231, p232, v235);

    if v236 == nil or (v237 == nil or v238 == nil) then
        return nil, "RemoteRenderPoseInactive";
    end;

    local v240, v241, v242, v243 = bracketActivityWindow(p231.Samples, p232, v235, v236, v237, v238, v239);

    if v240 == nil or v243 == nil then
        return nil, "RemoteRenderPoseUnavailable";
    end;

    if v241 ~= nil then
        return interpolateSample(v240, v241, v242, p234), nil;
    end;

    local v244 = Serial.deltaUInt32(v240.ServerTick, p232);
    local v245 = p233 - p230._config.RenderInterpolationTicks - v244;
    local v246 = math.clamp(v245, 0, p230._config.MaxRemoteExtrapolationTicks) / p230._mapping.SimulationHz;

    return makePose(v240.Actor, v240.ServerTick, v240.TopologyRevision, 1, v246, v240.Actor.Position + v240.Actor.Velocity * v246, p230._config.MaxRemoteExtrapolationTicks < v245 and Vector3.new(0, 0, 0) or nil, nil, nil, nil, p234), nil;
end;

local function collisionPoseFromSorted(p247: table) -- Line: 1193
    -- upvalues: makePose (copy)
    local v248 = p247.Activity[#p247.Activity];

    if v248 == nil or not v248.Active then
        return nil, "RemoteCollisionPoseInactive";
    end;

    for i = #p247.Samples, 1, -1 do
        local v249 = p247.Samples[i];

        if v249.Actor.Generation == v248.Generation and v249.Actor.ActorId == v248.ActorId then
            if p247.CollisionPoseSample ~= v249 or (p247.CollisionPoseActivity ~= v248 or p247.CollisionPose == nil) then
                p247.CollisionPoseSample = v249;
                p247.CollisionPoseActivity = v248;
                p247.CollisionPose = makePose(v249.Actor, v249.ServerTick, v249.TopologyRevision, 1, 0);
            end;

            return p247.CollisionPose, nil;
        end;

        local _ = i;
    end;

    return nil, "RemoteCollisionPoseUnavailable";
end;

local function sortedHistory(p250: any, p251: any, p252: number, p253: number?) -- Line: 1217
    -- upvalues: Serial (copy), Quantization (copy)
    local v254, v255;

    if Serial.isUInt32(p252) then
        v254 = p253 or 0;

        if Quantization.isFinite(v254) and (v254 >= 0 and v254 < 1) then
            v255 = nil;
        else
            v254 = nil;
            v255 = "InvalidTickFraction";
        end;
    else
        v254 = nil;
        v255 = "InvalidCurrentServerTick";
    end;

    if v254 == nil then
        return nil, nil, v255;
    end;

    local v256 = p250._actors[p251];

    if v256 == nil or #v256.Samples == 0 then
        return nil, nil, "ActorNotBuffered";
    end;

    return v256, v254, nil;
end;

function u2.getCollisionPose(p257: table, p258: any, p259: number, p260: number?) -- Line: 1234
    -- upvalues: Serial (copy), Quantization (copy), collisionPoseFromSorted (copy)
    local v261, v262;

    if Serial.isUInt32(p259) then
        v261 = p260 or 0;

        if Quantization.isFinite(v261) and (v261 >= 0 and v261 < 1) then
            v262 = nil;
        else
            v261 = nil;
            v262 = "InvalidTickFraction";
        end;
    else
        v261 = nil;
        v262 = "InvalidCurrentServerTick";
    end;

    local v263;

    if v261 == nil then
        v263 = nil;
        v261 = nil;
    else
        v263 = p257._actors[p258];

        if v263 == nil or #v263.Samples == 0 then
            v263 = nil;
            v262 = "ActorNotBuffered";
            v261 = nil;
        else
            v262 = nil;
        end;
    end;

    if v263 == nil or v261 == nil then
        return nil, v262;
    end;

    return collisionPoseFromSorted(v263);
end;

function u2.getPresentationPoses(p264: table, p265: any, p266: number, p267: number?) -- Line: 1247
    -- upvalues: Serial (copy), Quantization (copy), renderPoseFromSorted (copy), collisionPoseFromSorted (copy)
    local v268, v269;

    if Serial.isUInt32(p266) then
        v268 = p267 or 0;

        if Quantization.isFinite(v268) and (v268 >= 0 and v268 < 1) then
            v269 = nil;
        else
            v268 = nil;
            v269 = "InvalidTickFraction";
        end;
    else
        v268 = nil;
        v269 = "InvalidCurrentServerTick";
    end;

    local v270;

    if v268 == nil then
        v270 = nil;
        v268 = nil;
    else
        v270 = p264._actors[p265];

        if v270 == nil or #v270.Samples == 0 then
            v270 = nil;
            v269 = "ActorNotBuffered";
            v268 = nil;
        else
            v269 = nil;
        end;
    end;

    if v270 == nil or v268 == nil then
        return nil, nil, v269;
    end;

    local v271 = p264._presentationPoseByActorKey[p265];
    local v272, v273 = renderPoseFromSorted(p264, v270, p266, v268, v271);

    if v272 ~= nil and v271 == nil then
        p264._presentationPoseByActorKey[p265] = v272;
    end;

    local v274, v275 = collisionPoseFromSorted(v270);
    local v276;

    if v272 == nil and v274 == nil then
        v276 = v273 or v275;
    else
        v276 = nil;
    end;

    return v272, v274, v276;
end;

function u1.actorKeys(p277) -- Line: 1267
    return p277._actorKeys;
end;

function u1.getCollisionPose(p278: table, p279: any, p280: number, p281: number?) -- Line: 1271
    -- upvalues: Serial (copy), Quantization (copy)
    local v282, v283;

    if Serial.isUInt32(p280) then
        v282 = p281 or 0;

        if Quantization.isFinite(v282) and (v282 >= 0 and v282 < 1) then
            v283 = nil;
        else
            v282 = nil;
            v283 = "InvalidTickFraction";
        end;
    else
        v282 = nil;
        v283 = "InvalidCurrentServerTick";
    end;

    if v282 == nil then
        return nil, v283;
    end;

    local v284 = p278._poses[p279];

    if v284 == nil then
        return v284, "ActorNotBuffered";
    end;

    return v284, nil;
end;

function u1.getCollisionPoseByActorId(p285: table, p286: number, p287: number, p288: number?) -- Line: 1280
    local v289 = p285._actorIdToKey[p286];

    if v289 == nil then
        return nil, "ActorIdNotBuffered";
    end;

    return p285:getCollisionPose(v289, p287, p288);
end;

function u1.queryCollisionActorKeys(p290: table, p291: vector, p292: vector) -- Line: 1292
    local v293 = p290._broadphase:query(p291, p292, p290._queryActorIds);
    local _queryActorKeys = p290._queryActorKeys;
    table.clear(_queryActorKeys);

    for _, v in v293 do
        _queryActorKeys[#_queryActorKeys + 1] = p290._actorIdToKey[v];
    end;

    return _queryActorKeys;
end;

function u2.captureCollisionFrame(p294) -- Line: 1302
    -- upvalues: PlayerBroadphase (copy), collisionPoseFromSorted (copy), RemoteActorIdentity (copy), u1 (copy)
    local _collisionFrame = p294._collisionFrame;

    if _collisionFrame ~= nil then
        return _collisionFrame;
    end;

    local v295 = PlayerBroadphase.new();
    local v296 = {};
    local v297 = {};
    local v298 = {};

    for i, v in p294._actors do
        local v299 = collisionPoseFromSorted(v);

        if v299 ~= nil then
            v296[#v296 + 1] = i;
            v297[i] = table.freeze(table.clone(v299));
            v298[v299.ActorId] = i;
            v295:upsert(v299.ActorId, v299.Position);
        end;
    end;

    table.sort(v296, RemoteActorIdentity.keyLess);
    local v300 = {
        _actorKeys = table.freeze(v296),
        _poses = table.freeze(v297),
        _actorIdToKey = table.freeze(v298),
        _broadphase = v295,
        _queryActorIds = {},
        _queryActorKeys = {}
    };
    local v301 = setmetatable(v300, u1);
    p294._collisionFrame = v301;

    return v301;
end;

table.freeze(u1);

return table.freeze(u2);