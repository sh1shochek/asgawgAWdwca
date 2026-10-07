-- ReplicatedStorage.MovementV2.Client.PlayerContactAdapter
-- Script path: ReplicatedStorage.MovementV2.Client.PlayerContactAdapter
-- Decompile time: 21.77 ms

local Enums = require(script.Parent.Parent.Enums)
local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol)
require(script.Parent.Parent.Types)
local Config = require(script.Parent.Parent.Simulation.Config)
require(script.Parent.Parent.Simulation.DeterminismTrace)
local PlayerContactStep = require(script.Parent.Parent.Simulation.PlayerContactStep)
local PlayerContacts = require(script.Parent.Parent.Simulation.PlayerContacts)
local PlayerHullClearance = require(script.Parent.Parent.Simulation.PlayerHullClearance)
local PlayerLanding = require(script.Parent.Parent.Simulation.PlayerLanding)
require(script.Parent.Parent.Simulation.Types)
require(script.Parent.RemoteBuffer)
local Players = game:GetService("Players")
local v1 = {}
local u79 = PlayerContacts.newScratch()
local u82 = PlayerContacts.DefaultContactEpsilon + PlayerContacts.DefaultSeparationSkin
local u83 = (-1 / 0)

local function playerContactDebugEnabled() -- Line: 45 -- upvalues: DiagnosticProtocol (val), Players (val)
    return DiagnosticProtocol.PlayerContactOutputEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer)
end

local function compareBodyId(a1, a2) -- Line: 50
    return a1.Id < a2.Id
end

local function vectorLabel(a1) -- Line: 54 -- types: a1: vector
    return string.format("%.3f/%.3f/%.3f", a1.X, a1.Y, a1.Z)
end

local function reasonCountsLabel(a1) -- Line: 58 -- types: a1: table
    local v1 = {}
    for i, j in a1 do
        v1[#v1 + 1] = (("%*:%*"):format(i, j))
    end
    table.sort(v1)
    if #v1 == 0 then
        return "none"
    end
    return (table.concat(v1, ","))
end

local function bodyHalfSize(a1, a2) -- Line: 67
    local PlayerSizeDucking = if a1 ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

local function sweptIntervalsOverlap(a1, a2, a3, a4, a5, a6, a7) -- Line: 71
    -- upvalues: 
    local v1 = math.min(a1, a2) - a3
    local v2 = math.max(a1, a2) + a3
    local v3 = math.min(a4, a5) - a6
    local v4 = math.max(a4, a5) + a6
    local v5 = false
    if v1 <= v4 + a7 then
        v5 = v3 <= v2 + a7
    end
    return v5
end

local function couldContact(a1, a2, a3, a4) -- Line: 87 -- upvalues: u82 (val) -- types: a4: vector?
    local v1 = a4
    if not v1 then
        local PlayerSizeDucking = if a1.Stance ~= "Ducking" then a3.PlayerSizeStanding else a3.PlayerSizeDucking
        v1 = PlayerSizeDucking * 0.5
    end
    local PlayerSizeDucking_2 = if a2.Stance ~= "Ducking" then a3.PlayerSizeStanding else a3.PlayerSizeDucking
    local v2 = PlayerSizeDucking_2 * 0.5
    local X = a1.StartPosition.X
    local X_2 = a1.Position.X
    local X_3 = v1.X
    local X_4 = a2.StartPosition.X
    local X_5 = a2.Position.X
    local X_6 = v2.X
    local v3 = u82
    local v4 = math.min(X, X_2) - X_3
    local v5 = math.max(X, X_2) + X_3
    local v6 = math.min(X_4, X_5) - X_6
    local v7 = false
    if v4 <= math.max(X_4, X_5) + X_6 + v3 then
        v7 = v6 <= v5 + v3
    end
    if v7 then
        local Y = a1.StartPosition.Y
        local Y_2 = a1.Position.Y
        local Y_3 = v1.Y
        local Y_4 = a2.StartPosition.Y
        local Y_5 = a2.Position.Y
        local Y_6 = v2.Y
        v3 = u82
        v4 = math.min(Y, Y_2) - Y_3
        v5 = math.max(Y, Y_2) + Y_3
        v6 = math.min(Y_4, Y_5) - Y_6
        v7 = false
        if v4 <= math.max(Y_4, Y_5) + Y_6 + v3 then
            v7 = v6 <= v5 + v3
        end
        if v7 then
            local Z = a1.StartPosition.Z
            local Z_2 = a1.Position.Z
            local Z_3 = v1.Z
            local Z_4 = a2.StartPosition.Z
            local Z_5 = a2.Position.Z
            local Z_6 = v2.Z
            v3 = u82
            v4 = math.min(Z, Z_2) - Z_3
            v5 = math.max(Z, Z_2) + Z_3
            v6 = math.min(Z_4, Z_5) - Z_6
            v7 = false
            if v4 <= math.max(Z_4, Z_5) + Z_6 + v3 then
                v7 = v6 <= v5 + v3
            end
        end
    end
    return v7
end

local function contactQueryBounds(a1, a2, a3) -- Line: 117 -- upvalues: u82 (val) -- types: a3: vector?
    local v1 = a3
    if not v1 then
        local PlayerSizeDucking = if a1.Stance ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
        v1 = PlayerSizeDucking * 0.5
    end
    local v2 = a2.PlayerSizeStanding * 0.5
    local v3 = a2.PlayerSizeDucking * 0.5
    local v4 = v1 + (Vector3.new(math.max(v2.X, v3.X), math.max(v2.Y, v3.Y), (math.max(v2.Z, v3.Z)))) + Vector3.new(u82, u82, u82)
    local v5 = Vector3.new(
        math.min(a1.StartPosition.X, a1.Position.X),
        math.min(a1.StartPosition.Y, a1.Position.Y),
        (math.min(a1.StartPosition.Z, a1.Position.Z))
    )
    local v6 = Vector3.new(
        math.max(a1.StartPosition.X, a1.Position.X),
        math.max(a1.StartPosition.Y, a1.Position.Y),
        (math.max(a1.StartPosition.Z, a1.Position.Z))
    )
    return v5 - v4, v6 + v4
end

local function newStanceProbe() -- Line: 149 -- upvalues: PlayerHullClearance (val)
    local u0 = {ServerTick = 0, Contacts = {}}
    return function(a1, a2) -- Line: 151 -- upvalues: u0 (val), PlayerHullClearance (upval) -- types: a1: vector
        local ServerTick, v1
        local v2 = assert(u0.Mapping)
        local v3 = assert(u0.RemoteBuffer)
        local v4 = assert(u0.Config)
        local v5, v6 = PlayerHullClearance.bounds(a1, a2, v4)
        local ActorId = nil
        for i, j in v3:queryCollisionActorKeys(v5, v6) do
            ServerTick = u0.ServerTick
            v1 = v3:getCollisionPose(j, ServerTick, 0)
            if v1 ~= nil
                and v1.ActorId ~= v2.ActorId
                and PlayerHullClearance.overlaps(a1, a2, v1.Position, v1.Stance, v4) then
                u0.Contacts[v1.ActorId] = true
                ActorId = if ActorId ~= nil then math.min(ActorId, v1.ActorId) else v1.ActorId
            end
        end
        return ActorId
    end, u0
end

local u94, u95 = newStanceProbe()
local u97, u98 = newStanceProbe()

local function bindProbe(a1, a2, a3, a4, a5, a6) -- Line: 176 -- types: a1: table, a3: number, a6: table
    a1.Mapping = a2
    a1.ServerTick = a3
    a1.RemoteBuffer = a4
    a1.Config = a5
    a1.Contacts = a6
end

function v1.bindStanceProbe(a1, a2, a3, a4) -- Line: 190 -- upvalues: u95 (val), u94 (val) -- types: a2: number
    if not a1.PlayerCollisionsEnabled then
        return nil, nil
    end
    local Contacts = u95.Contacts
    table.clear(Contacts)
    local v1 = u95
    v1.Mapping = a1
    v1.ServerTick = a2
    v1.RemoteBuffer = a3
    v1.Config = a4
    v1.Contacts = Contacts
    return u94, Contacts
end

function v1.resolvePlayerSupportMotion(a1, a2, a3, a4, a5) -- Line: 205
    -- upvalues: Enums (val)
    if a2.Kind == Enums.SupportKind.Player and a2.SourceId ~= 0 then
        local v1 = a3:getCollisionPoseByActorId(a2.SourceId, a4, 0)
        if v1 == nil then
            return nil
        end
        local v2 = a1.Position - a2.Anchor
        local v3 = Vector3.new(v1.Velocity.X, 0, v1.Velocity.Z)
        return {
            Kind = Enums.SupportKind.Player,
            SourceId = a2.SourceId,
            Delta = v1.Position - v2 - v3 * a5,
            Velocity = v1.Velocity,
            Position = v1.Position,
            Stance = v1.Stance,
        }
    end
    return nil
end

function v1.solve(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 232
    -- upvalues: PlayerContacts (val), Config (val), DiagnosticProtocol (val), Players (val), u83 (ref)
    -- upvalues: PlayerLanding (val), contactQueryBounds (val), couldContact (val), vectorLabel (val)
    -- upvalues: compareBodyId (val), u98 (val), u97 (val), u79 (val), reasonCountsLabel (val), PlayerContactStep (val)
    -- upvalues: Enums (val)
    local ActorId_2, Position_4, SourceServerTick, format_2, v1, v2, v3, v4, v5, v6, v7, v8
    local v9 = {
        OwnsMotion = true,
        Id = a6.ActorId,
        StartPosition = a1.Position,
        Position = a3.Position,
        WorldVelocity = PlayerContacts.toWorldVelocity(a3.Velocity, a4),
        Stance = a3.Stance,
    }
    local Position = a3.Position
    local Magnitude = (Position - a1.Position).Magnitude
    local WorldVelocity = v9.WorldVelocity
    local Default = a11 or Config.Default
    local v10 = {v9}
    local PlayerContactOutputEnabled = DiagnosticProtocol.PlayerContactOutputEnabled and DiagnosticProtocol.shouldOutputForPlayer(Players.LocalPlayer) and 0.25 <= os.clock() - u83
    local v11 = if not PlayerContactOutputEnabled then nil else {}
    local v12 = if not PlayerContactOutputEnabled then nil else {}
    if PlayerContactOutputEnabled then
        u83 = os.clock()
    end
    local v13 = PlayerLanding.needsStanding(a3)
    local v14 = PlayerLanding.queryHalfSize(a3, Default)
    local v15, v16 = contactQueryBounds(v9, Default, v14)
    local v17, v18, v19, v20, v21, v22, v23, v24, v25, v26 = a6, a7, a8, a3, a9, a12, a1, a2, a4, a5
    for i, j in a8:queryCollisionActorKeys(v15, v16) do
        v2, v3 = v19:getCollisionPose(j, v18, 0)
        if v2 == nil then
            if v2 == nil and v3 ~= nil and v12 ~= nil then
                v12[v3] = (v12[v3] or 0) + 1
            end
        elseif v2.ActorId ~= v17.ActorId then
            v4 = {
                OwnsMotion = false,
                Id = v2.ActorId,
                StartPosition = v2.Position,
                Position = v2.Position,
                WorldVelocity = v2.Velocity,
                Stance = v2.Stance,
            }
            if couldContact(v9, v4, Default, v14) then
                v10[#v10 + 1] = v4
                if v11 ~= nil then
                    v5 = #v11 + 1
                    format_2 = string.format
                    ActorId_2 = v2.ActorId
                    SourceServerTick = v2.SourceServerTick
                    Position_4 = v4.Position
                    v11[v5] = (format_2(
                        "a%d src=%u raw=%s replicatedVel=%s",
                        ActorId_2,
                        SourceServerTick,
                        string.format("%.3f/%.3f/%.3f", Position_4.X, Position_4.Y, Position_4.Z),
                        vectorLabel(v2.Velocity)
                    ))
                end
            end
        elseif v2 == nil and v3 ~= nil and v12 ~= nil then
            v12[v3] = (v12[v3] or 0) + 1
        end
    end
    table.sort(v10, compareBodyId)
    if v13 then
        v1 = u98
        v1.Mapping = v17
        v1.ServerTick = v18
        v1.RemoteBuffer = v19
        v1.Config = Default
        v1.Contacts = {}
        PlayerLanding.prepare(v20, v9, v10, v21, Default, u97, v22)
    end
    v1 = PlayerContacts.solve(v10, {
        CanOccupy = if a10 ~= nil then function(a1, a2) -- Line: 315 -- upvalues: a10 (val)
            return a10(a1, a1.Position, a2)
        end else nil,
        Config = Default,
        TraceRecorder = v22,
        TraceBodyId = v17.ActorId,
        Scratch = u79,
    })
    local v27 = math.max((v9.Position - Position).Magnitude - Magnitude - PlayerContacts.DefaultSeparationSkin, 0)
    v2 = {}
    for k, n in v1.Contacts do
        if n.A == v17.ActorId then
            v2[n.B] = true
        elseif n.B == v17.ActorId then
            v2[n.A] = true
        end
    end
    v3 = v1.SupportsById[v17.ActorId]
    if v3 ~= nil then
        v2[v3.SourceId] = true
    end
    v4 = false
    if v12 ~= nil then
        v4 = next(v12) ~= nil
    end
    v5 = true
    if not (0 < v1.SweptContactCount) then
        v5 = true
        if next(v2) == nil then
            v5 = true
            if not (0 < v1.UnresolvedCount) then
                v5 = v4
            end
        end
    end
    if PlayerContactOutputEnabled and v5 then
        v6 = print
        local format = string.format
        local ActorId = v17.ActorId
        local StartPosition = v9.StartPosition
        local v28 = string.format("%.3f/%.3f/%.3f", StartPosition.X, StartPosition.Y, StartPosition.Z)
        local Position_2 = v20.Position
        local v29 = string.format("%.3f/%.3f/%.3f", Position_2.X, Position_2.Y, Position_2.Z)
        local Position_3 = v9.Position
        local v30 = string.format("%.3f/%.3f/%.3f", Position_3.X, Position_3.Y, Position_3.Z)
        local v31 = string.format("%.3f/%.3f/%.3f", WorldVelocity.X, WorldVelocity.Y, WorldVelocity.Z)
        local WorldVelocity_2 = v9.WorldVelocity
        v6(format(
            "[MovementV2.PlayerContact] CLIENT tick=%u actor=%d start=%s provisional=%s final=%s velBefore=%s velAfter=%s external=%.4f bodies=%d swept=%d unresolved=%d latestRemote=%s misses=%s remotes=[%s]",
            v18,
            ActorId,
            v28,
            v29,
            v30,
            v31,
            string.format("%.3f/%.3f/%.3f", WorldVelocity_2.X, WorldVelocity_2.Y, WorldVelocity_2.Z),
            v27,
            #v10,
            v1.SweptContactCount,
            v1.UnresolvedCount,
            if v19:latestServerTick() ~= nil then tostring((v19:latestServerTick())) else "nil",
            reasonCountsLabel(assert(v12)),
            table.concat(assert(v11), "; ")
        ))
    end
    v6, v7, v8 = PlayerContactStep.finalize(v23, v24, v20, v25, v26, v9, v3, v21, v17.SimulationHz, Default, v22, nil)
    v25 = v7
    if v25.Kind == Enums.SupportKind.Player then
        v2[v25.SourceId] = true
    end
    return {
        State = v6,
        Support = v25,
        Events = v8,
        ContactActorIds = v2,
        UnresolvedCount = v1.UnresolvedCount,
        NearbyPlayer = #v10 > 1,
        ExternalDisplacement = v27,
    }
end

return (table.freeze(v1))