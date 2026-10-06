-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol);
require(script.Parent.Parent.Types);
local Config = require(script.Parent.Parent.Simulation.Config);
require(script.Parent.Parent.Simulation.DeterminismTrace);
local PlayerContactStep = require(script.Parent.Parent.Simulation.PlayerContactStep);
local PlayerContacts = require(script.Parent.Parent.Simulation.PlayerContacts);
local PlayerHullClearance = require(script.Parent.Parent.Simulation.PlayerHullClearance);
local PlayerLanding = require(script.Parent.Parent.Simulation.PlayerLanding);
require(script.Parent.Parent.Simulation.Types);
require(script.Parent.RemoteBuffer);
local Players = game:GetService("Players");
local v1 = {};
local u2 = PlayerContacts.newScratch();
local u3 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin;
local u4 = (-1 / 0);

local function playerContactDebugEnabled() -- Line: 45
    -- upvalues: DiagnosticProtocol (copy), Players (copy)
    local v5 = DiagnosticProtocol.PlayerContactOutputEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer);

    return v5;
end;

local function compareBodyId(p6, p7) -- Line: 50
    return p6.Id < p7.Id;
end;

local function vectorLabel(p8: vector) -- Line: 54
    return string.format("%.3f/%.3f/%.3f", p8.X, p8.Y, p8.Z);
end;

local function reasonCountsLabel(p9: table) -- Line: 58
    local v10 = {};

    for i, v in p9 do
        v10[#v10 + 1] = `{i}:{v}`;
    end;

    table.sort(v10);

    return #v10 == 0 and "none" or table.concat(v10, ",");
end;

local function bodyHalfSize(p11, p12) -- Line: 67
    local v13;

    if p11 == "Ducking" then
        v13 = p12.PlayerSizeDucking;
    else
        v13 = p12.PlayerSizeStanding;
    end;

    return v13 * 0.5;
end;

local function sweptIntervalsOverlap(p14: number, p15: number, p16: number, p17: number, p18: number, p19: number, p20: number) -- Line: 71
    local v21 = math.min(p14, p15) - p16;
    local v22 = math.max(p14, p15) + p16;
    local v23 = math.min(p17, p18) - p19;
    local v24;

    if v21 <= math.max(p17, p18) + p19 + p20 then
        v24 = v23 <= v22 + p20;
    else
        v24 = false;
    end;

    return v24;
end;

local function couldContact(p25: any, p26: any, p27: any, p28: vector?) -- Line: 87
    -- upvalues: u3 (copy)
    if not p28 then
        local v29;

        if p25.Stance == "Ducking" then
            v29 = p27.PlayerSizeDucking;
        else
            v29 = p27.PlayerSizeStanding;
        end;

        p28 = v29 * 0.5;
    end;

    local v30;

    if p26.Stance == "Ducking" then
        v30 = p27.PlayerSizeDucking;
    else
        v30 = p27.PlayerSizeStanding;
    end;

    local v31 = v30 * 0.5;
    local X = p25.StartPosition.X;
    local X2 = p25.Position.X;
    local X3 = p28.X;
    local X4 = p26.StartPosition.X;
    local X5 = p26.Position.X;
    local X6 = v31.X;
    local v32 = u3;
    local v33 = math.min(X, X2) - X3;
    local v34 = math.max(X, X2) + X3;
    local v35 = math.min(X4, X5) - X6;
    local v36;

    if v33 <= math.max(X4, X5) + X6 + v32 then
        v36 = v35 <= v34 + v32;
    else
        v36 = false;
    end;

    if v36 then
        local Y = p25.StartPosition.Y;
        local Y2 = p25.Position.Y;
        local Y3 = p28.Y;
        local Y4 = p26.StartPosition.Y;
        local Y5 = p26.Position.Y;
        local Y6 = v31.Y;
        local v37 = u3;
        local v38 = math.min(Y, Y2) - Y3;
        local v39 = math.max(Y, Y2) + Y3;
        local v40 = math.min(Y4, Y5) - Y6;

        if v38 <= math.max(Y4, Y5) + Y6 + v37 then
            v36 = v40 <= v39 + v37;
        else
            v36 = false;
        end;

        if v36 then
            local Z = p25.StartPosition.Z;
            local Z2 = p25.Position.Z;
            local Z3 = p28.Z;
            local Z4 = p26.StartPosition.Z;
            local Z5 = p26.Position.Z;
            local Z6 = v31.Z;
            local v41 = u3;
            local v42 = math.min(Z, Z2) - Z3;
            local v43 = math.max(Z, Z2) + Z3;
            local v44 = math.min(Z4, Z5) - Z6;

            if v42 <= math.max(Z4, Z5) + Z6 + v41 then
                v36 = v44 <= v43 + v41;
            else
                v36 = false;
            end;
        end;
    end;

    return v36;
end;

local function contactQueryBounds(p45: any, p46: any, p47: vector?) -- Line: 117
    -- upvalues: u3 (copy)
    if not p47 then
        local v48;

        if p45.Stance == "Ducking" then
            v48 = p46.PlayerSizeDucking;
        else
            v48 = p46.PlayerSizeStanding;
        end;

        p47 = v48 * 0.5;
    end;

    local v49 = p46.PlayerSizeStanding * 0.5;
    local v50 = p46.PlayerSizeDucking * 0.5;
    local math_max_ret = math.max(v49.X, v50.X);
    local math_max_ret2 = math.max(v49.Y, v50.Y);
    local math_max_ret3 = math.max(v49.Z, v50.Z);
    local v51 = p47 + Vector3.new(math_max_ret, math_max_ret2, math_max_ret3) + Vector3.new(u3, u3, u3);
    local math_min_ret = math.min(p45.StartPosition.X, p45.Position.X);
    local math_min_ret2 = math.min(p45.StartPosition.Y, p45.Position.Y);
    local math_min_ret3 = math.min(p45.StartPosition.Z, p45.Position.Z);
    local Vector3_new_ret = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
    local math_max_ret4 = math.max(p45.StartPosition.X, p45.Position.X);
    local math_max_ret5 = math.max(p45.StartPosition.Y, p45.Position.Y);
    local math_max_ret6 = math.max(p45.StartPosition.Z, p45.Position.Z);
    local Vector3_new_ret2 = Vector3.new(math_max_ret4, math_max_ret5, math_max_ret6);

    return Vector3_new_ret - v51, Vector3_new_ret2 + v51;
end;

local function newStanceProbe() -- Line: 149
    -- upvalues: PlayerHullClearance (copy)
    local u52 = {
        ServerTick = 0,
        Contacts = {}
    };

    return function(p53: vector, p54: any) -- Line: 151, Name: probe
        -- upvalues: u52 (copy), PlayerHullClearance (ref)
        local v55 = assert(u52.Mapping);
        local v56 = assert(u52.RemoteBuffer);
        local v57 = assert(u52.Config);
        local v58, v59 = PlayerHullClearance.bounds(p53, p54, v57);
        local v60 = nil;

        for _, v in v56:queryCollisionActorKeys(v58, v59) do
            local CollisionPose = v56:getCollisionPose(v, u52.ServerTick, 0);

            if CollisionPose ~= nil and (CollisionPose.ActorId ~= v55.ActorId and PlayerHullClearance.overlaps(p53, p54, CollisionPose.Position, CollisionPose.Stance, v57)) then
                u52.Contacts[CollisionPose.ActorId] = true;

                if v60 == nil then
                    v60 = CollisionPose.ActorId;
                else
                    v60 = math.min(v60, CollisionPose.ActorId);
                end;
            end;
        end;

        return v60;
    end, u52;
end;

local u61, u62 = newStanceProbe();
local u63, u64 = newStanceProbe();

local function bindProbe(p65: table, p66: any, p67: number, p68: any, p69: any, p70: table) -- Line: 176
    p65.Mapping = p66;
    p65.ServerTick = p67;
    p65.RemoteBuffer = p68;
    p65.Config = p69;
    p65.Contacts = p70;
end;

function v1.bindStanceProbe(p71: any, p72: number, p73: any, p74: any) -- Line: 190
    -- upvalues: u62 (copy), u61 (copy)
    if not p71.PlayerCollisionsEnabled then
        return nil, nil;
    end;

    local Contacts = u62.Contacts;
    table.clear(Contacts);
    local v75 = u62;
    v75.Mapping = p71;
    v75.ServerTick = p72;
    v75.RemoteBuffer = p73;
    v75.Config = p74;
    v75.Contacts = Contacts;

    return u61, Contacts;
end;

function v1.resolvePlayerSupportMotion(p76: any, p77: any, p78: any, p79: number, p80: number) -- Line: 205
    -- upvalues: Enums (copy)
    if p77.Kind ~= Enums.SupportKind.Player or p77.SourceId == 0 then
        return nil;
    end;

    local CollisionPoseByActorId = p78:getCollisionPoseByActorId(p77.SourceId, p79, 0);

    if CollisionPoseByActorId == nil then
        return nil;
    end;

    local v81 = p76.Position - p77.Anchor;
    local Vector3_new_ret = Vector3.new(CollisionPoseByActorId.Velocity.X, 0, CollisionPoseByActorId.Velocity.Z);

    return {
        Kind = Enums.SupportKind.Player,
        SourceId = p77.SourceId,
        Delta = CollisionPoseByActorId.Position - v81 - Vector3_new_ret * p80,
        Velocity = CollisionPoseByActorId.Velocity,
        Position = CollisionPoseByActorId.Position,
        Stance = CollisionPoseByActorId.Stance
    };
end;

function v1.solve(p82: any, p83: any, p84: any, p85: any, p86: any, p87: any, p88: number, p89: any, p90: any, u91: function?, p92: any, p93: any) -- Line: 232
    -- upvalues: PlayerContacts (copy), Config (copy), DiagnosticProtocol (copy), Players (copy), u4 (ref), PlayerLanding (copy), contactQueryBounds (copy), couldContact (copy), vectorLabel (copy), compareBodyId (copy), u64 (copy), u63 (copy), u2 (copy), reasonCountsLabel (copy), PlayerContactStep (copy), Enums (copy)
    local v94 = {
        OwnsMotion = true,
        Id = p87.ActorId,
        StartPosition = p82.Position,
        Position = p84.Position,
        WorldVelocity = PlayerContacts.toWorldVelocity(p84.Velocity, p85),
        Stance = p84.Stance
    };
    local Position = p84.Position;
    local Magnitude = (Position - p82.Position).Magnitude;
    local WorldVelocity = v94.WorldVelocity;
    local v95 = p92 or Config.Default;
    local v96 = { v94 };
    local v97 = DiagnosticProtocol.PlayerContactOutputEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) and os.clock() - u4 >= 0.25;
    local v98 = v97 and {} or nil;
    local v99 = v97 and {} or nil;

    if v97 then
        u4 = os.clock();
    end;

    local v100 = PlayerLanding.needsStanding(p84);
    local v101 = PlayerLanding.queryHalfSize(p84, v95);
    local v102, v103 = contactQueryBounds(v94, v95, v101);

    for _, v in p89:queryCollisionActorKeys(v102, v103) do
        local CollisionPose, v104 = p89:getCollisionPose(v, p88, 0);

        if CollisionPose == nil or CollisionPose.ActorId == p87.ActorId then
            if CollisionPose == nil and (v104 ~= nil and v99 ~= nil) then
                v99[v104] = (v99[v104] or 0) + 1;
            end;
        else
            local v105 = {
                OwnsMotion = false,
                Id = CollisionPose.ActorId,
                StartPosition = CollisionPose.Position,
                Position = CollisionPose.Position,
                WorldVelocity = CollisionPose.Velocity,
                Stance = CollisionPose.Stance
            };

            if couldContact(v94, v105, v95, v101) then
                v96[#v96 + 1] = v105;

                if v98 ~= nil then
                    local Position2 = v105.Position;
                    v98[#v98 + 1] = string.format("a%d src=%u raw=%s replicatedVel=%s", CollisionPose.ActorId, CollisionPose.SourceServerTick, string.format("%.3f/%.3f/%.3f", Position2.X, Position2.Y, Position2.Z), vectorLabel(CollisionPose.Velocity));
                end;
            end;
        end;
    end;

    table.sort(v96, compareBodyId);
    local v106, v107;

    if v100 then
        v106 = {};
        local v108 = u64;
        v108.Mapping = p87;
        v108.ServerTick = p88;
        v108.RemoteBuffer = p89;
        v108.Config = v95;
        v108.Contacts = v106;
        v107 = u63;
        PlayerLanding.prepare(p84, v94, v96, p90, v95, v107, p93);
    else
        v107 = nil;
        v106 = nil;
    end;

    local v111 = PlayerContacts.solve(v96, {
        CanOccupy = u91 ~= nil and function(p109, p110) -- Line: 315
            -- upvalues: u91 (copy)
            return u91(p109, p109.Position, p110);
        end or nil,
        Config = v95,
        TraceRecorder = p93,
        TraceBodyId = p87.ActorId,
        Scratch = u2
    });
    local math_max_ret = math.max((v94.Position - Position).Magnitude - Magnitude - PlayerContacts.DefaultSeparationSkin, 0);
    local v112 = v106 or {};

    for _, v in v111.Contacts do
        if v.A == p87.ActorId then
            v112[v.B] = true;
        elseif v.B == p87.ActorId then
            v112[v.A] = true;
        end;
    end;

    local v113 = v111.SupportsById[p87.ActorId];

    if v113 ~= nil then
        v112[v113.SourceId] = true;
    end;

    local v114;

    if v99 == nil then
        v114 = false;
    else
        v114 = next(v99) ~= nil;
    end;

    if v97 and ((v111.SweptContactCount > 0 or next(v112) ~= nil) and true or (v111.UnresolvedCount > 0 and true or v114)) then
        local v115 = print;
        local string_format = string.format;
        local ActorId = p87.ActorId;
        local StartPosition = v94.StartPosition;
        local string_format_ret = string.format("%.3f/%.3f/%.3f", StartPosition.X, StartPosition.Y, StartPosition.Z);
        local Position2 = p84.Position;
        local string_format_ret2 = string.format("%.3f/%.3f/%.3f", Position2.X, Position2.Y, Position2.Z);
        local Position3 = v94.Position;
        local string_format_ret3 = string.format("%.3f/%.3f/%.3f", Position3.X, Position3.Y, Position3.Z);
        local string_format_ret4 = string.format("%.3f/%.3f/%.3f", WorldVelocity.X, WorldVelocity.Y, WorldVelocity.Z);
        local WorldVelocity2 = v94.WorldVelocity;
        v115(string_format("[MovementV2.PlayerContact] CLIENT tick=%u actor=%d start=%s provisional=%s final=%s velBefore=%s velAfter=%s external=%.4f bodies=%d swept=%d unresolved=%d latestRemote=%s misses=%s remotes=[%s]", p88, ActorId, string_format_ret, string_format_ret2, string_format_ret3, string_format_ret4, string.format("%.3f/%.3f/%.3f", WorldVelocity2.X, WorldVelocity2.Y, WorldVelocity2.Z), math_max_ret, #v96, v111.SweptContactCount, v111.UnresolvedCount, p89:latestServerTick() == nil and "nil" or tostring(p89:latestServerTick()), reasonCountsLabel(assert(v99)), table.concat(assert(v98), "; ")));
    end;

    local v116, v117, v118 = PlayerContactStep.finalize(p82, p83, p84, p85, p86, v94, v113, p90, p87.SimulationHz, v95, p93, v107);

    if v117.Kind == Enums.SupportKind.Player then
        v112[v117.SourceId] = true;
    end;

    return {
        State = v116,
        Support = v117,
        Events = v118,
        ContactActorIds = v112,
        UnresolvedCount = v111.UnresolvedCount,
        NearbyPlayer = #v96 > 1,
        ExternalDisplacement = math_max_ret
    };
end;

return table.freeze(v1);