-- ReplicatedStorage.MovementV2.Simulation.PlayerContactStep
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerContactStep
-- Decompile time: 7.61 ms

local Enums = require(script.Parent.Parent.Enums)
require(script.Parent.Parent.Types)
require(script.Parent.Config)
require(script.Parent.Types)
local DeterminismTrace = require(script.Parent.DeterminismTrace)
local ProvenMath = require(script.Parent.ProvenMath)
local PlayerContacts = require(script.Parent.PlayerContacts)
local PlayerLanding = require(script.Parent.PlayerLanding)
require(script.Parent.PlayerHullClearance)
local ProvenSimulator = require(script.Parent.ProvenSimulator)
local v1 = {}

local function cloneSupport(a1) -- Line: 24
    return {
        Kind = a1.Kind,
        SourceId = a1.SourceId,
        Anchor = a1.Anchor,
        Velocity = a1.Velocity,
    }
end

local function emptySupport() -- Line: 33 -- upvalues: Enums (val)
    return {
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0),
        Kind = Enums.SupportKind.None,
    }
end

local function clearGround(a1, a2, a3) -- Line: 42 -- upvalues: Enums (val) -- types: a2: vector
    a1.OnGround = false
    a1.GroundNormal = Vector3.new(0, 1, 0)
    a1.GroundSurfaceFriction = a3.SurfaceFrictionDefault
    a1.Velocity = a2
    return {
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0),
        Kind = Enums.SupportKind.None,
    }
end

local function applyGroundVelocity(a1, a2, a3, a4, a5, a6) -- Line: 50
    -- upvalues: PlayerContacts (val), ProvenMath (val)
    local v1 = {
        Kind = a3.Kind,
        SourceId = a3.SourceId,
        Anchor = a3.Anchor,
        Velocity = a3.Velocity,
    }
    local v2 = ProvenMath.clipVelocity(PlayerContacts.fromWorldVelocity(a2, v1), a4)
    if (math.abs(a4.Y - 1)) <= a6.PlaneEpsilon then
        v2 = Vector3.new(v2.X, 0, v2.Z)
    end
    a1.OnGround = true
    a1.MovementMode = "Walking"
    a1.GroundNormal = a4
    a1.GroundSurfaceFriction = math.max(a5, 0)
    a1.Velocity = v2
    return v1, v2 + v1.Velocity
end

function v1.finalize(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 73
    -- upvalues: PlayerLanding (val), PlayerContacts (val), Enums (val), DeterminismTrace (val), ProvenMath (val)
    -- upvalues: applyGroundVelocity (val), ProvenSimulator (val)
    local v1, v2, v3, v4
    if PlayerLanding.needsStanding(a3) then
        if a6.Stance ~= "Standing" then
            a7 = nil
        else
            a3.Stance = "Standing"
            a3.JumpHullActive = false
        end
    end
    local v5 = PlayerContacts.toWorldVelocity(a3.Velocity, a4)
    local Landed = a5.Landed
    local ImpactVelocityY = a5.ImpactVelocityY
    local OnGround = a1.OnGround
    if OnGround then
        OnGround = false
        if a2.Kind == Enums.SupportKind.Player then
            OnGround = a3.OnGround
            if OnGround then
                OnGround = false
                if a4.Kind == Enums.SupportKind.Player then
                    OnGround = a4.SourceId == a2.SourceId
                end
            end
        end
    end
    local v6 = a6.Position ~= a3.Position
    local v7 = a6.WorldVelocity ~= v5
    a3.Position = a6.Position
    local WorldVelocity = a6.WorldVelocity
    DeterminismTrace.checkpoint(a11, "runtime.playerContacts.bodyCommit", a3, a4, nil)
    if not v6 and not v7 and a7 == nil and a4.Kind ~= Enums.SupportKind.Player then
        DeterminismTrace.checkpoint(a11, "runtime.playerContacts.groundFinalize", a3, a4, nil)
        DeterminismTrace.checkpoint(a11, "runtime.playerContacts.eventsFinalize", a3, a4, nil)
        return a3, a4, a5
    end
    local v8 = if not a3.OnGround then nil else a4
    if a7 == nil then
        local Position_2, Stance_2, v9, v10
        if not OnGround or a4.Kind ~= Enums.SupportKind.Player then
            if v6 or a4.Kind == Enums.SupportKind.Player then
                v2 = a8:FindGround(a3.Position, a3.Stance, a10.GroundProbeDistance, 1, v8)
                v3 = false
                if v2 ~= nil then
                    v3 = false
                    if a10.WalkableFloor <= v2.Normal.Y then
                        v3 = WorldVelocity.Y - v2.Support.Velocity.Y <= a10.GroundClearVelocity
                    end
                end
                if v3 and v2 ~= nil and PlayerLanding.needsStanding(a3) then
                    v2 = PlayerLanding.restoreWorldGround(v2, a8, a10, a12, a11)
                    v9 = false
                    if v2 ~= nil then
                        v9 = false
                        if a10.WalkableFloor <= v2.Normal.Y then
                            v9 = WorldVelocity.Y - v2.Support.Velocity.Y <= a10.GroundClearVelocity
                        end
                    end
                    if v9 then
                        a3.Stance = "Standing"
                        a3.JumpHullActive = false
                    end
                end
                if not v3 or v2 == nil then
                    a3.OnGround = false
                    a3.GroundNormal = Vector3.new(0, 1, 0)
                    a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
                    a3.Velocity = WorldVelocity
                    v4 = {
                        SourceId = 0,
                        Anchor = Vector3.new(0, 0, 0),
                        Velocity = Vector3.new(0, 0, 0),
                    }
                    v4.Kind = Enums.SupportKind.None
                else
                    a3.Position = v2.Position
                    Position_2 = v2.Position
                    Stance_2 = a3.Stance
                    a6.Position = Position_2
                    a6.Stance = Stance_2
                    v9, v10 = applyGroundVelocity(a3, WorldVelocity, v2.Support, v2.Normal, v2.SurfaceFriction, a10)
                    v4 = v9
                end
            elseif not a3.OnGround then
                a3.OnGround = false
                a3.GroundNormal = Vector3.new(0, 1, 0)
                a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
                a3.Velocity = WorldVelocity
                v4 = {
                    SourceId = 0,
                    Anchor = Vector3.new(0, 0, 0),
                    Velocity = Vector3.new(0, 0, 0),
                }
                v4.Kind = Enums.SupportKind.None
            else
                v2, v3 = applyGroundVelocity(a3, WorldVelocity, a4, a3.GroundNormal, a3.GroundSurfaceFriction, a10)
                v4 = v2
            end
        elseif a4.SourceId == a2.SourceId then
            v3 = ProvenMath.clipVelocity(a3.Velocity + (a6.WorldVelocity - v5), (Vector3.new(0, 1, 0)))
            v3 = Vector3.new(v3.X, 0, v3.Z)
            v9 = a4
            v4 = {
                Kind = v9.Kind,
                SourceId = v9.SourceId,
                Anchor = v9.Anchor,
                Velocity = v9.Velocity,
            }
            a3.OnGround = true
            a3.MovementMode = "Walking"
            a3.GroundNormal = Vector3.new(0, 1, 0)
            a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
            a3.Velocity = v3
            v1 = v3 + v4.Velocity
        elseif v6 or a4.Kind == Enums.SupportKind.Player then
            v2 = a8:FindGround(a3.Position, a3.Stance, a10.GroundProbeDistance, 1, v8)
            v3 = false
            if v2 ~= nil then
                v3 = false
                if a10.WalkableFloor <= v2.Normal.Y then
                    v3 = WorldVelocity.Y - v2.Support.Velocity.Y <= a10.GroundClearVelocity
                end
            end
            if v3 and v2 ~= nil and PlayerLanding.needsStanding(a3) then
                v2 = PlayerLanding.restoreWorldGround(v2, a8, a10, a12, a11)
                v9 = false
                if v2 ~= nil then
                    v9 = false
                    if a10.WalkableFloor <= v2.Normal.Y then
                        v9 = WorldVelocity.Y - v2.Support.Velocity.Y <= a10.GroundClearVelocity
                    end
                end
                if v9 then
                    a3.Stance = "Standing"
                    a3.JumpHullActive = false
                end
            end
            if not v3 or v2 == nil then
                a3.OnGround = false
                a3.GroundNormal = Vector3.new(0, 1, 0)
                a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
                a3.Velocity = WorldVelocity
                v4 = {
                    SourceId = 0,
                    Anchor = Vector3.new(0, 0, 0),
                    Velocity = Vector3.new(0, 0, 0),
                }
                v4.Kind = Enums.SupportKind.None
            else
                a3.Position = v2.Position
                Position_2 = v2.Position
                Stance_2 = a3.Stance
                a6.Position = Position_2
                a6.Stance = Stance_2
                v9, v10 = applyGroundVelocity(a3, WorldVelocity, v2.Support, v2.Normal, v2.SurfaceFriction, a10)
                v4 = v9
            end
        elseif not a3.OnGround then
            a3.OnGround = false
            a3.GroundNormal = Vector3.new(0, 1, 0)
            a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
            a3.Velocity = WorldVelocity
            v4 = {
                SourceId = 0,
                Anchor = Vector3.new(0, 0, 0),
                Velocity = Vector3.new(0, 0, 0),
            }
            v4.Kind = Enums.SupportKind.None
        else
            v2, v3 = applyGroundVelocity(a3, WorldVelocity, a4, a3.GroundNormal, a3.GroundSurfaceFriction, a10)
            v4 = v2
        end
    elseif not OnGround or a7.SourceId ~= a2.SourceId then
        v2, v3 = applyGroundVelocity(a3, WorldVelocity, a7, Vector3.new(0, 1, 0), a10.SurfaceFrictionDefault, a10)
        v4 = v2
    else
        v3 = ProvenMath.clipVelocity(a3.Velocity + (a6.WorldVelocity - v5), (Vector3.new(0, 1, 0)))
        v3 = Vector3.new(v3.X, 0, v3.Z)
        v4 = {
            Kind = a7.Kind,
            SourceId = a7.SourceId,
            Anchor = a7.Anchor,
            Velocity = a7.Velocity,
        }
        a3.OnGround = true
        a3.MovementMode = "Walking"
        a3.GroundNormal = Vector3.new(0, 1, 0)
        a3.GroundSurfaceFriction = a10.SurfaceFrictionDefault
        a3.Velocity = v3
        v1 = v3 + v4.Velocity
    end
    DeterminismTrace.checkpoint(a11, "runtime.playerContacts.groundFinalize", a3, v4, nil)
    if a3.OnGround and 0.999 <= a3.DuckAmount then
        a3.JumpHullActive = false
    end
    local OnGround_2 = not a1.OnGround and a3.OnGround
    local OnGround_3 = a1.OnGround and not a3.OnGround
    local Y_3 = if not OnGround_2 then nil else ImpactVelocityY or a1.Velocity.Y
    if not Landed then
        if OnGround_2 and not Landed and Y_3 ~= nil then
            a3.Stamina = ProvenSimulator.finishStamina(a1.Stamina, Y_3, 1 / a9, a10)
            a3.Velocity = ProvenSimulator.applyLandingVelocity(a3.Velocity, a10)
        end
    elseif not OnGround_2 then
        a3.Stamina = ProvenSimulator.finishStamina(a1.Stamina, nil, 1 / a9, a10)
    elseif OnGround_2 and not Landed and Y_3 ~= nil then
        a3.Stamina = ProvenSimulator.finishStamina(a1.Stamina, Y_3, 1 / a9, a10)
        a3.Velocity = ProvenSimulator.applyLandingVelocity(a3.Velocity, a10)
    end
    a5.Landed = OnGround_2
    a5.LeftGround = OnGround_3
    a5.ImpactVelocityY = Y_3
    DeterminismTrace.checkpoint(a11, "runtime.playerContacts.eventsFinalize", a3, v4, nil)
    assert(a3.OnGround == (v4.Kind ~= Enums.SupportKind.None), "post-contact ground invariant is broken")
    return a3, v4, a5
end

return table.freeze(v1)