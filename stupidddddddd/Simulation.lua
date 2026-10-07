-- ReplicatedStorage.MovementV2.Simulation
-- Script path: ReplicatedStorage.MovementV2.Simulation
-- Decompile time: 6.52 ms

local Buttons = require(script.Parent.Buttons)
local Serial = require(script.Parent.Serial)
local DamageTag = require(script.Parent.DamageTag)
local Enums = require(script.Parent.Enums)
require(script.Parent.Types)
local Config = require(script.Config)
local DeterminismTrace = require(script.DeterminismTrace)
local PlayerContacts = require(script.PlayerContacts)
require(script.PlayerHullClearance)
local PlayerSupportQuery = require(script.PlayerSupportQuery)
local ProvenCollisionAdapter = require(script.ProvenCollisionAdapter)
local ProvenSimulator = require(script.ProvenSimulator)
local Solver = require(script.Solver)
local State = require(script.State)
local Types_2 = require(script.Types)
local v1 = {}

local function activeSupportVelocity(a1, a2) -- Line: 31 -- upvalues: Enums (val)
    if a1.Kind ~= 0 and a1.SourceId ~= 0 then
        local Velocity = if a2 == nil then a1.Velocity else if a2.Kind ~= a1.Kind then a1.Velocity else if a2.SourceId ~= a1.SourceId then a1.Velocity else a2.Velocity
        if a1.Kind == Enums.SupportKind.Player then
            return (Vector3.new(Velocity.X, 0, Velocity.Z))
        end
        return Velocity
    end
    return (Vector3.new(0, 0, 0))
end

local function applySupportCarry(a1, a2, a3, a4, a5, a6) -- Line: 44
    -- upvalues: Enums (val), Solver (val)
    if a1.OnGround
        and a2.Kind ~= 0
        and a2.SourceId ~= 0
        and a3 ~= nil
        and a3.Kind == a2.Kind
        and a3.SourceId == a2.SourceId
        and not (a3.Delta.Magnitude <= a5.PlaneEpsilon) then
        local Delta = a3.Delta
        if a2.Kind == Enums.SupportKind.Mover then
            local Velocity = a3.Velocity
            Delta = Delta - Vector3.new(Velocity.X, 0, Velocity.Z) * a6
        end
        local v1 = Solver.slideDisplacement(a1.Position, Delta, a1.Stance, a4, a2, 1, 1, a5)
        a1.Position = v1.Position
        return v1.Blocked, v1.StartSolid, v1.WallNormal
    end
    return false, false, (Vector3.new(0, 0, 0))
end

local u68 = {SourceId = 0, Anchor = Vector3.new(0, 0, 0), Velocity = Vector3.new(0, 0, 0)}
u68.Kind = Enums.SupportKind.Mover

local function applyMoverPush(a1, a2, a3, a4) -- Line: 87 -- upvalues: Enums (val), u68 (val), Solver (val)
    local FindMoverPush = a3.FindMoverPush
    local PenetratesMover = a3.PenetratesMover
    if FindMoverPush ~= nil and PenetratesMover ~= nil then
        local v1, v2, v3
        local v4 = nil
        local v5 = 0
        local v6, v7, v8, v9 = a3, a1, a2, a4
        while true do
            v2, v3 = FindMoverPush(v6, v7.Position, v7.Stance, v5, 0.01)
            if v2 == nil then
                break
            end
            if v8.Kind ~= Enums.SupportKind.Mover or v8.SourceId ~= v2 then
                u68.SourceId = v2
                v1 = Solver.slideDisplacement(v7.Position, v3, v7.Stance, v6, u68, 1, 1, v9)
                if not PenetratesMover(v6, v2, v1.Position, v7.Stance) then
                    v7.Position = v1.Position
                else
                    v4 = v4 or v2
                end
            end
        end
        return v4
    end
    return nil
end

local u72 = {}
local u73 = {}
local u74 = {}

local function toProvenState(a1, a2, a3, a4) -- Line: 136 -- upvalues: Enums (val), Buttons (val) -- types: a2: vector
    local Velocity = if not a1.OnGround then a1.Velocity else a1.Velocity + a2
    local v1 = a4 or {}
    if a4 then
        table.clear(a4)
    end
    v1.Position = a1.Position
    v1.Velocity = Velocity
    v1.OnGround = a1.OnGround
    local OnGround = a1.OnGround and a3.Kind == Enums.SupportKind.Player
    v1.GroundSupportIsDynamicPlayer = OnGround
    v1.GroundNormal = a1.GroundNormal
    v1.GroundSurfaceFriction = a1.GroundSurfaceFriction
    v1.WallNormal = a1.WallNormal
    v1.DuckAmount = a1.DuckAmount
    v1.DuckTimeMsecs = a1.DuckTimeMsecs
    v1.IsDucking = a1.IsDucking
    v1.DuckHeld = Buttons.has(a1.PreviousButtons, Buttons.Duck)
    v1.DuckFatigueLevel = a1.DuckSpeed * 10
    v1.DuckFatigueTimerMsecs = a1.DuckCooldownSeconds * 1000
    v1.MovementType = a1.MovementMode
    v1.Stamina = a1.Stamina
    v1.LastJumpTick = if a1.LastJumpCommandNumber ~= 4294967295 then a1.LastJumpCommandNumber else -1024
    v1.JumpHeld = Buttons.has(a1.PreviousButtons, Buttons.Jump)
    v1.JumpBufferTicksRemaining = a1.JumpBufferTicksRemaining
    v1.JumpHullActive = a1.JumpHullActive
    v1.StuckStepTicks = a1.StuckStepTicks
    return v1
end

local function toProvenInput(a1, a2, a3, a4) -- Line: 165 -- upvalues: Buttons (val) -- types: a2: number, a3: number
    local v1 = a4 or {}
    if a4 then
        table.clear(a4)
    end
    v1.Tick = a1.CommandNumber
    v1.MoveVector = a1.Move
    v1.LookYaw = a1.LookYaw
    v1.VerticalLook = a1.VerticalLook
    v1.Jump = Buttons.has(a1.Buttons, Buttons.Jump)
    v1.Duck = Buttons.has(a1.Buttons, Buttons.Duck)
    v1.Walk = Buttons.has(a1.Buttons, Buttons.Walk)
    v1.BaseMoveSpeed = a2 * a3
    return v1
end

local function outputStance(a1) -- Line: 181
    if not (0.999 <= a1.DuckAmount) and a1.JumpHullActive ~= true then
        return "Standing"
    end
    return "Ducking"
end

function v1.step(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 185
    -- upvalues: Config (val), DeterminismTrace (val), State (val), Enums (val), PlayerSupportQuery (val), u72 (val)
    -- upvalues: applySupportCarry (val), applyMoverPush (val), activeSupportVelocity (val)
    -- upvalues: ProvenCollisionAdapter (val), toProvenState (val), u73 (val), toProvenInput (val), u74 (val)
    -- upvalues: ProvenSimulator (val), DamageTag (val), Serial (val), Buttons (val)
    local v1, v2, v3
    local v4 = false
    if a4 == a4 then
        v4 = false
        if a4 > 0 then
            v4 = a4 < (1 / 0)
        end
    end
    assert(v4, "MovementV2 simulation step must be finite and positive")
    assert(a2.Kind == 0 == (a2.SourceId == 0), "MovementV2 support identity is not canonical")
    assert(a1.OnGround == (a2.Kind ~= 0), "MovementV2 state/support ground invariant is broken")
    local Default = a7 or Config.Default
    DeterminismTrace.checkpoint(a8, "simulation.input", a1, a2, a3)
    v4 = State.cloneSupport(a2)
    local v5 = a5
    if v4.Kind == Enums.SupportKind.Player
        and a6 ~= nil
        and a6.Kind == v4.Kind
        and a6.SourceId == v4.SourceId
        and a6.Position ~= nil
        and a6.Stance ~= nil then
        v5 = PlayerSupportQuery.new(a5, v4, a6, Default)
    end
    local v6, v7, v8 = applySupportCarry(if not (a8 == nil) then State.clone(a1) else State.cloneInto(u72, a1), v4, a6, v5, Default, a4)
    DeterminismTrace.checkpoint(a8, "simulation.supportCarry", v2, v4, a6)
    local v9 = applyMoverPush(v2, v4, a5, Default)
    DeterminismTrace.checkpoint(a8, "simulation.moverPush", v2, v4, nil)
    local v10 = activeSupportVelocity(v4, a6)
    local Velocity = if not a1.OnGround then a1.Velocity else a1.Velocity + v10
    local v11 = ProvenCollisionAdapter.acquire(v5, Default, v4, a8, if not a1.OnGround then nil else v10, a9)
    local v12 = toProvenState(v2, v10, v4, if not v1 then nil else u73)
    local v13 = toProvenInput(a3, a1.BaseMoveSpeed, a1.VelocityModifier, if not v1 then nil else u74)
    DeterminismTrace.checkpoint(a8, "simulation.provenInput", v12, v4, a3)
    local v14, v15 = ProvenSimulator.step(v12, v13, a4, v11, Default, a8)
    DeterminismTrace.checkpoint(a8, "simulation.provenOutput", v14, nil, nil)
    local v16 = if 0.999 <= v14.DuckAmount then "Ducking" else if v14.JumpHullActive ~= true then "Standing" else "Ducking"
    local v17 = State.noneSupport()
    local OnGround_2 = v14.OnGround
    local Velocity_2 = v14.Velocity
    local GroundNormal = v14.GroundNormal
    local GroundSurfaceFriction = v14.GroundSurfaceFriction
    if OnGround_2 then
        v3 = v11:ResolveGroundTrace(v15, v14.Position)
        if v3 == nil then
            v3 = v5:FindGround(v14.Position, v16, math.max(Default.GroundProbeDistance, Default.MaxStepHeight), 1, v4)
        end
        if v3 == nil then
            OnGround_2 = false
            GroundSurfaceFriction = Default.SurfaceFrictionDefault
        else
            v17 = State.cloneSupport(v3.Support)
            local v18 = v14.Velocity - v3.Support.Velocity
            Velocity_2 = Vector3.new(v18.X, 0, v18.Z)
            GroundNormal = v3.Normal
            GroundSurfaceFriction = v3.SurfaceFriction
        end
    end
    v3 = {
        Position = v14.Position,
        Velocity = Velocity_2,
        LookYaw = a3.LookYaw,
        VerticalLook = a3.VerticalLook,
        BaseMoveSpeed = a1.BaseMoveSpeed,
        WeaponMoveSpeed = a1.WeaponMoveSpeed,
        WeaponScopedMoveSpeed = a1.WeaponScopedMoveSpeed,
        VelocityModifier = DamageTag.recover(a1.VelocityModifier, a4),
        MovementTick = Serial.addUInt32(a1.MovementTick, 1),
        MovementMode = v14.MovementType,
        Stance = v16,
        OnGround = OnGround_2,
        GroundNormal = if not OnGround_2 then Vector3.new(0, 1, 0) else GroundNormal,
        WallNormal = if not (0 < v8.Magnitude) then v14.WallNormal else v8,
        GroundSurfaceFriction = GroundSurfaceFriction,
        DuckAmount = v14.DuckAmount,
        DuckTimeMsecs = v14.DuckTimeMsecs,
        IsDucking = v14.IsDucking,
        DuckSpeed = v14.DuckFatigueLevel / 10,
        DuckCooldownSeconds = v14.DuckFatigueTimerMsecs / 1000,
        Stamina = v14.Stamina,
        LastJumpCommandNumber = if not (v14.LastJumpTick < 0) then v14.LastJumpTick else 4294967295,
        PreviousButtons = a3.Buttons,
        JumpBufferTicksRemaining = v14.JumpBufferTicksRemaining,
        JumpHullActive = v14.JumpHullActive,
        StuckStepTicks = v14.StuckStepTicks,
    }
    DeterminismTrace.checkpoint(a8, "simulation.outputConversion", v3, v17, nil)
    local OnGround_3 = not a1.OnGround and v3.OnGround
    local OnGround_4 = a1.OnGround and not v3.OnGround
    return v3, v17, {
        Jumped = OnGround_4 and Buttons.has(a3.Buttons, Buttons.Jump) and Default.VelocityEpsilon < v14.Velocity.Y,
        Landed = OnGround_3,
        LeftGround = OnGround_4,
        ImpactVelocityY = if not OnGround_3 then nil else Velocity.Y,
        Blocked = v6,
        StartSolid = v7,
        BlockedByMoverId = v9,
    }
end

v1.Config = Config
v1.DeterminismTrace = DeterminismTrace
v1.PlayerContacts = PlayerContacts
v1.Solver = Solver
v1.State = State
v1.Types = Types_2
return table.freeze(v1)