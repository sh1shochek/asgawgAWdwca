-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator
-- Decompile time: 16.52 ms

require(script.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.ProvenMath)
require(script.Parent.DeterminismTrace)
local Trace = require(script.Trace)
local TraceRules = require(script.TraceRules)
local Duck = require(script.Duck)
local SlideMove = require(script.SlideMove)
local GroundMove = require(script.GroundMove)
local AirMove = require(script.AirMove)
local Ladder = require(script.Ladder)
local u43 = {}
local line = Trace.line
local state = Trace.state
local vector = Trace.vector
local clampHorizontal = ProvenMath.clampHorizontal
local horizontalMagnitude = ProvenMath.horizontalMagnitude
local getStance = Duck.getStance
local getUncrouchClearance = Duck.getUncrouchClearance
local tryPlayerMove = SlideMove.tryPlayerMove
local groundProbeWithRetry = GroundMove.groundProbeWithRetry
local getLadderNormal = Ladder.getLadderNormal
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP
local WALL_RECOVERY_SEPARATION = SlideMove.WALL_RECOVERY_SEPARATION
local isPointTestBlocked = TraceRules.isPointTestBlocked
local getTraceClipNormal = TraceRules.getTraceClipNormal
local getWallConstraintNormal = TraceRules.getWallConstraintNormal
local getTraceSurfaceVelocity = TraceRules.getTraceSurfaceVelocity
local getTraceSurfaceFriction = TraceRules.getTraceSurfaceFriction
local getImpactWallConstraintNormal = TraceRules.getImpactWallConstraintNormal
local isDynamicPlayerSupportTrace = TraceRules.isDynamicPlayerSupportTrace
local isRecoverableFloorSupportTrace = TraceRules.isRecoverableFloorSupportTrace
local getResolvedSupportPosition = TraceRules.getResolvedSupportPosition
local isWalkableGround = TraceRules.isWalkableGround
local getTraceGroundNormal = TraceRules.getTraceGroundNormal
local getLandingSnapDistance = TraceRules.getLandingSnapDistance
local shouldRejectAirLanding = TraceRules.shouldRejectAirLanding
local supportTraceMatchesPosition = TraceRules.supportTraceMatchesPosition
local u70 = {}
local u71 = {}
local u72 = {}

local function applyBunnyHopLandingPenalty(a1, a2) -- Line: 94 -- types: a1: vector
    local BunnyHopPenaltyThreshold = a2.BunnyHopPenaltyThreshold
    if BunnyHopPenaltyThreshold <= 0 then
        return a1
    end
    local v1 = math.sqrt(a1.X * a1.X + a1.Z * a1.Z)
    if v1 <= BunnyHopPenaltyThreshold then
        return a1
    end
    local v2 = math.clamp(
        math.max(a2.BunnyHopMinVelocityRetain, 1 - (a2.BunnyHopPenaltyBase + (v1 - BunnyHopPenaltyThreshold) * a2.BunnyHopPenaltyScale)),
        0,
        1
    )
    return (Vector3.new(a1.X * v2, a1.Y, a1.Z * v2))
end

u43.applyLandingVelocity = applyBunnyHopLandingPenalty

local function clampVelocityComponents(a1, a2) -- Line: 114 -- types: a1: vector, a2: number
    return (Vector3.new(math.clamp(a1.X, -a2, a2), math.clamp(a1.Y, -a2, a2), (math.clamp(a1.Z, -a2, a2))))
end

local function isGroundJumpCommandActive(a1, a2, a3) -- Line: 122
    local Jump = a2.Jump and (a3.AutoBunnyHop or not a1.JumpHeld)
    local v1 = false
    if 0 < a3.BunnyHopInputBufferTicks then
        v1 = 0 < a1.JumpBufferTicksRemaining
    end
    return if Jump then 1 < a2.Tick - a1.LastJumpTick else v1 and 1 < a2.Tick - a1.LastJumpTick
end

local function getStaminaFloor(a1) -- Line: 133
    return (math.max(0, a1.StaminaMax - a1.StaminaMaxPenalty))
end

local function getStaminaScale(a1, a2) -- Line: 138 -- types: a1: number
    return (math.clamp(a1 / math.max(a2.StaminaMax, 1), 0, 1))
end

local function applyStaminaPenalty(a1, a2, a3, a4) -- Line: 143 -- types: a1: number, a2: number, a3: number
    return (math.max(math.max(0, a4.StaminaMax - a4.StaminaMaxPenalty), a1 - a2 * ((math.max(a3, 0)) / a4.HammerUnitToStud)))
end

function u43.finishStamina(a1, a2, a3, a4) -- Line: 153 -- types: a1: number, a2: number?, a3: number
    if a2 ~= nil then
        local v1 = a4.StaminaLandCost * ((math.max(-a2, 0)) / a4.HammerUnitToStud)
        a1 = math.max(math.max(0, a4.StaminaMax - a4.StaminaMaxPenalty), a1 - v1)
    end
    return (math.min(a4.StaminaMax, a1 + a4.StaminaRecoveryRate * a3))
end

local function createStepState(a1, a2, a3) -- Line: 166
    local v1 = a3 or {}
    if a3 then
        table.clear(a3)
    end
    v1.Position = a1.Position
    v1.Velocity = a1.Velocity
    v1.OnGround = a1.OnGround
    local OnGround = a1.OnGround and a1.GroundSupportIsDynamicPlayer == true
    v1.GroundSupportIsDynamicPlayer = OnGround
    v1.GroundNormal = a1.GroundNormal
    v1.GroundSurfaceFriction = a1.GroundSurfaceFriction
    v1.WallNormal = a1.WallNormal
    v1.DuckAmount = a1.DuckAmount
    v1.DuckTimeMsecs = a1.DuckTimeMsecs
    v1.IsDucking = a1.IsDucking == true
    v1.DuckHeld = a2.Duck == true
    v1.DuckFatigueLevel = a1.DuckFatigueLevel
    v1.DuckFatigueTimerMsecs = a1.DuckFatigueTimerMsecs
    v1.MovementType = a1.MovementType
    v1.Stamina = a1.Stamina
    v1.LastJumpTick = a1.LastJumpTick
    v1.JumpHeld = a1.JumpHeld
    v1.JumpBufferTicksRemaining = a1.JumpBufferTicksRemaining
    v1.JumpHullActive = a1.JumpHullActive == true
    v1.StuckStepTicks = a1.StuckStepTicks
    return v1
end

local function activateJumpHull(a1) -- Line: 198 -- types: a1: table
    if not a1.Config.AutoJumpHull then
        return
    end
    a1.Next.JumpHullActive = true
    a1.Stance = "crouching"
end

local function beginStep(a1, a2, a3, a4, a5, a6) -- Line: 206
    -- upvalues: u71 (val), createStepState (val), u72 (val), state (val), line (val)
    local v1 = u71
    table.clear(v1)
    v1.State = a1
    v1.Input = a2
    v1.DeltaTime = a3
    v1.World = a4
    v1.Config = a5
    v1.UsedLadderMove = false
    v1.JumpedFromGround = false
    v1.MovedRelativeGroundVelocity = Vector3.new(0, 0, 0)
    local v2 = createStepState(a1, a2, if a6 ~= nil then nil else u72)
    v1.Next = v2
    state("proven.createStepState", v2, line(1))
    if not a5.AutoJumpHull or v2.OnGround or v2.MovementType == "Ladder" then
        v2.JumpHullActive = false
    end
    local OnGround = a1.OnGround and a1.GroundSupportIsDynamicPlayer == true
    v1.HadDynamicPlayerSupport = OnGround
    local Velocity = v2.Velocity
    local MaxVelocity = a5.MaxVelocity
    v2.Velocity = Vector3.new(
        math.clamp(Velocity.X, -MaxVelocity, MaxVelocity),
        math.clamp(Velocity.Y, -MaxVelocity, MaxVelocity),
        (math.clamp(Velocity.Z, -MaxVelocity, MaxVelocity))
    )
    state("proven.velocityInputClamp", v2, line(1))
    a4:BeginStepBounds(v2.Position, v2.Velocity, math.max(a5.MaxSpeed, a2.BaseMoveSpeed), a3)
    return v1
end

local function resolveSpeedAndStance(a1) -- Line: 245 -- upvalues: getStance (val) -- types: a1: table
    local Next = a1.Next
    local Input = a1.Input
    local Config = a1.Config
    local v1 = math.clamp(Next.DuckAmount, 0, 1)
    local OnGround = Next.OnGround
    if OnGround then
        OnGround = true
        if not (v1 > 0) then
            OnGround = Next.IsDucking
        end
    end
    local v2 = 1
    local CrouchModifier = 1
    if OnGround then
        v2 = 1 + (Config.CrouchModifier - 1) * v1
        CrouchModifier = Config.CrouchModifier
    end
    if Input.Walk then
        v2 = math.min(v2, Config.WalkModifier)
        if not OnGround then
            CrouchModifier = Config.WalkModifier
        end
    end
    local v3 = 1 * v2
    local v4 = math.clamp(Next.Stamina / math.max(Config.StaminaMax, 1), 0, 1)
    a1.SpeedModifier = v3 * (v4 * v4)
    a1.GroundAccelerationModifier = CrouchModifier
    a1.Stance = if not Next.JumpHullActive then getStance(Next) else "crouching"
end

local function recoverStartSolid(a1) -- Line: 277
    -- upvalues: SlideMove (val), state (val), line (val)
    local Next = a1.Next
    local v1 = math.max(1, (math.floor(0.25 / a1.DeltaTime + 0.5)))
    local v2 = nil
    if 0 < Next.StuckStepTicks or a1.Input.Tick % v1 == 0 then
        v2 = SlideMove.escapeStartSolid(Next.Position, a1.Stance, a1.World)
    end
    if v2 ~= nil then
        Next.Position = v2
    end
    state("proven.startSolidRecovery", Next, line(1))
end

local function resolveWish(a1) -- Line: 291 -- upvalues: ProvenMath (val), state (val), line (val) -- types: a1: table
    local v1
    local Next = a1.Next
    local State = a1.State
    local Input = a1.Input
    local Config = a1.Config
    local Unit = ProvenMath.moveVectorToWorld(Input.MoveVector, Input.LookYaw)
    local v2 = Unit
    local MaxSpeed = Config.MaxSpeed
    if typeof(Input.BaseMoveSpeed) == "number" then
        MaxSpeed = math.clamp(Input.BaseMoveSpeed, 0, Config.MaxBaseMoveSpeed)
    end
    if MaxSpeed <= Config.PositionSnapEpsilon then
        Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0)
        Unit = Vector3.new(0, 0, 0)
        v2 = Vector3.new(0, 0, 0)
    end
    state("proven.movementLock", Next, line(1))
    if Config.BunnyHopInputBufferTicks <= 0 then
        Next.JumpBufferTicksRemaining = 0
    elseif not v1 then
        Next.JumpBufferTicksRemaining = math.max(0, State.JumpBufferTicksRemaining - 1)
        if Input.Jump and not State.JumpHeld then
            Next.JumpBufferTicksRemaining = math.min(Config.BunnyHopInputBufferTicks, 255)
        end
    else
        Next.JumpBufferTicksRemaining = 0
    end
    state("proven.jumpBuffer", Next, line(1))
    local v3 = MaxSpeed * a1.SpeedModifier
    local v4 = v3
    local v5 = v3
    if not (Unit.Magnitude <= 0) then
        Unit = Unit.Unit
        v2 = Unit
    else
        v3 = 0
        v5 = 0
    end
    a1.MovementLocked = v1
    a1.JumpInputAllowed = not v1
    a1.WishDir = Unit
    a1.RawWishDir = v2
    a1.WishSpeed = v3
    a1.MaxGroundSpeed = v4
    a1.RawWishSpeed = v5
    a1.PreMovePosition = Next.Position
    a1.RememberedWallNormal = Next.WallNormal
    a1.WallConstraintWarmStartNormal = if State.MovementType ~= "Walking" then Vector3.new(0, 0, 0) else Next.WallNormal
    local Jump = Input.Jump and (Config.AutoBunnyHop or not Next.JumpHeld)
    local v6 = false
    if 0 < Config.BunnyHopInputBufferTicks then
        v6 = 0 < Next.JumpBufferTicksRemaining
    end
    a1.GroundJumpCommandActive = if Jump then 1 < Input.Tick - Next.LastJumpTick else v6 and 1 < Input.Tick - Next.LastJumpTick
end

local function moveOnLadder(a1) -- Line: 342
    -- upvalues: Ladder (val), state (val), line (val), getLadderNormal (val), getTraceSurfaceVelocity (val), u70 (val)
    -- upvalues: vector (val)
    local Next = a1.Next
    local Input = a1.Input
    local Config = a1.Config
    local World = a1.World
    local DeltaTime = a1.DeltaTime
    local v1 = nil
    local JumpInputAllowed = a1.JumpInputAllowed and Next.OnGround and a1.GroundJumpCommandActive
    debug.profilebegin("Sim.ladderFind")
    if a1.MovementLocked then
        if not a1.MovementLocked and not JumpInputAllowed and Config.PositionSnapEpsilon < a1.RawWishSpeed then
            v1 = Ladder.findLadderTrace(
                Next.Position,
                a1.Stance,
                World,
                Config,
                a1.RawWishDir,
                Next.WallNormal,
                Config.LadderAttachDistance,
                true
            )
        end
    elseif a1.State.MovementType == "Ladder" then
        v1 = Ladder.findLadderTrace(Next.Position, a1.Stance, World, Config, a1.RawWishDir, Next.WallNormal, Config.LadderDetachDistance, false)
    elseif not a1.MovementLocked and not JumpInputAllowed and Config.PositionSnapEpsilon < a1.RawWishSpeed then
        v1 = Ladder.findLadderTrace(Next.Position, a1.Stance, World, Config, a1.RawWishDir, Next.WallNormal, Config.LadderAttachDistance, true)
    end
    debug.profileend()
    state("proven.ladderFind", Next, line(1))
    if v1 == nil then
        Next.MovementType = "Walking"
        return false
    end
    local v2 = getLadderNormal(v1, Next.WallNormal)
    if a1.JumpInputAllowed and Input.Jump and not Next.JumpHeld then
        Next.OnGround = false
        Next.GroundSupportIsDynamicPlayer = false
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault
        Next.MovementType = "Walking"
        Next.WallNormal = Vector3.new(0, 0, 0)
        Next.Velocity = v2 * Config.LadderJumpOffSpeed + getTraceSurfaceVelocity(v1)
        Next.LastJumpTick = Input.Tick
        Next.JumpBufferTicksRemaining = 0
        if a1.Config.AutoJumpHull then
            a1.Next.JumpHullActive = true
            a1.Stance = "crouching"
        end
        state("proven.ladderJumpOff", Next, line(1))
        return false
    end
    local v3 = Ladder.simulateLadderMove(Next.Position, Input, DeltaTime, World, Config, a1.Stance, v1, Next.WallNormal, Next.OnGround, u70)
    if v3.detached then
        a1.UsedLadderMove = true
        Next.OnGround = false
        Next.GroundSupportIsDynamicPlayer = false
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault
        Next.MovementType = "Walking"
        Next.JumpHullActive = false
        a1.MovedPosition = v3.position
        a1.MovedVelocity = v3.velocity
        a1.MovedTouchedWall = v3.touchedWall
        a1.MovedImpactTrace = v3.impactTrace
        vector("proven.ladderDetach", v3.position, v3.velocity, 0, 0, line(1))
        return false
    end
    Next.Position = v3.position
    Next.Velocity = v3.velocity
    Next.OnGround = false
    Next.GroundSupportIsDynamicPlayer = false
    Next.GroundNormal = Vector3.new(0, 1, 0)
    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault
    Next.WallNormal = getLadderNormal(v3.contactTrace or v1, v2)
    Next.MovementType = "Ladder"
    Next.JumpHullActive = false
    Next.StuckStepTicks = 0
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime)
    Next.JumpHeld = Input.Jump
    state("proven.ladderMoveReturn", Next, line(1))
    return true
end

local function prevalidatePlayerSupport(a1) -- Line: 444
    -- upvalues: groundProbeWithRetry (val), isWalkableGround (val), isDynamicPlayerSupportTrace (val), state (val)
    -- upvalues: line (val)
    local Next = a1.Next
    local Config = a1.Config
    debug.profilebegin("Sim.playerSupportPrevalidation")
    local v1 = groundProbeWithRetry(Next.Position, Config.GroundProbeDistance, a1.Stance, a1.World, Config, false, true)
    local v2 = isWalkableGround(v1, Config)
    debug.profileend()
    if not v2 then
        Next.OnGround = false
        Next.GroundSupportIsDynamicPlayer = false
    else
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(v1)
    end
    state("proven.playerSupportPrevalidation", Next, line(1))
end

local function moveOnGround(a1) -- Line: 468
    -- upvalues: GroundMove (val), getTraceSurfaceFriction (val), state (val), line (val), u70 (val)
    local v1, v2
    local Next = a1.Next
    local Input = a1.Input
    local Config = a1.Config
    local World = a1.World
    debug.profilebegin("Sim.groundMove")
    local v3, v4 = GroundMove.getGroundSupportVelocity(Next.Position, a1.Stance, World, Config)
    local v5 = v3
    local v6 = v4
    local GroundSurfaceFriction = if v6 == nil then Next.GroundSurfaceFriction else getTraceSurfaceFriction(v6, Config)
    Next.GroundSurfaceFriction = GroundSurfaceFriction
    if a1.MovementLocked then
        Next.Velocity = v5
    end
    state("proven.groundSupportVelocity", Next, line(1))
    v4 = Next.Velocity - v5
    if not a1.JumpInputAllowed or not a1.GroundJumpCommandActive then
        local v7, v8, v9, v10, v11, v12
        Next.Velocity = Vector3.new(v4.X, 0, v4.Z) + v5
        v12, v1, v7, v8, v9, v2, _, v10, v11 = GroundMove.walkMove(
            Next.Position,
            Next.Velocity,
            a1.WishDir,
            a1.WishSpeed,
            a1.MaxGroundSpeed,
            a1.DeltaTime,
            World,
            Config,
            a1.Stance,
            v5,
            GroundSurfaceFriction,
            a1.GroundAccelerationModifier,
            u70
        )
        a1.GroundMoveResult = v9
        a1.MovedPosition = v12
        a1.MovedVelocity = v1
        a1.MovedTouchedWall = v10
        a1.MovedImpactTrace = v11
        a1.MovedRelativeGroundVelocity = v7
        a1.ReusableGroundTrace = v2
        a1.WalkPreClipVelocity = v8
        Next.Velocity = v1
        state("proven.walkMoveCommit", Next, line(1))
    else
        v1 = Config.JumpSpeed * (math.clamp(Next.Stamina / math.max(Config.StaminaMax, 1), 0, 1))
        Next.OnGround = false
        Next.GroundSupportIsDynamicPlayer = false
        Next.Velocity = Vector3.new(v4.X + v5.X, v1, v4.Z + v5.Z)
        Next.LastJumpTick = Input.Tick
        Next.JumpBufferTicksRemaining = 0
        local Stamina_2 = Next.Stamina
        v2 = Config.StaminaJumpCost * ((math.max(v1, 0)) / Config.HammerUnitToStud)
        Next.Stamina = math.max(math.max(0, Config.StaminaMax - Config.StaminaMaxPenalty), Stamina_2 - v2)
        a1.JumpedFromGround = true
        if a1.Config.AutoJumpHull then
            a1.Next.JumpHullActive = true
            a1.Stance = "crouching"
        end
        state("proven.groundJump", Next, line(1))
    end
    debug.profileend()
end

local function moveInAir(a1) -- Line: 535
    -- upvalues: getStance (val), AirMove (val), u70 (val), vector (val), line (val)
    local Next = a1.Next
    local Config = a1.Config
    debug.profilebegin("Sim.airMove")
    local v1 = false
    if Config.PositionSnapEpsilon < Config.AutoJumpLedgeAssistHeight then
        v1 = Config.PositionSnapEpsilon < Config.AutoJumpLedgeAssistLiftSpeed
    end
    local v2, v3, v4, v5, v6 = AirMove.airMove(
        Next.Position,
        Next.Velocity,
        a1.WishDir,
        a1.WishSpeed,
        a1.DeltaTime,
        a1.World,
        Config,
        a1.Stance,
        v1,
        Next.JumpHullActive and getStance(Next) == "standing",
        Next.GroundSurfaceFriction,
        a1.WallConstraintWarmStartNormal,
        u70
    )
    a1.MovedPosition = v2
    a1.MovedVelocity = v3
    a1.MovedTouchedWall = v5
    a1.MovedImpactTrace = v6
    vector("proven.airMoveResult", v2, v3, 0, if not v4 then 0 else 1, line(1))
    debug.profileend()
end

local function moveOffLadder(a1) -- Line: 565
    -- upvalues: state (val), line (val), prevalidatePlayerSupport (val), moveOnGround (val), moveInAir (val)
    local Next = a1.Next
    Next.Velocity = Next.Velocity + Vector3.new(0, -a1.Config.Gravity * a1.DeltaTime * 0.5, 0)
    state("proven.gravityFirstHalf", Next, line(1))
    if Next.OnGround and a1.HadDynamicPlayerSupport then
        prevalidatePlayerSupport(a1)
    end
    if Next.OnGround then
        moveOnGround(a1)
    end
    if not Next.OnGround then
        moveInAir(a1)
    end
end

local function recoverWedgedGroundMove(a1, a2) -- Line: 581
    -- upvalues: horizontalMagnitude (val), getWallConstraintNormal (val), getTraceClipNormal (val)
    -- upvalues: WALL_RECOVERY_SEPARATION (val), tryPlayerMove (val), u70 (val), isPointTestBlocked (val)
    local Next = a1.Next
    local Config = a1.Config
    local DeltaTime = a1.DeltaTime
    local GroundMoveResult = a1.GroundMoveResult
    local MovedImpactTrace = a1.MovedImpactTrace
    local v1 = Config.PositionSnapEpsilon < a1.WishSpeed
    local direct = if not GroundMoveResult then nil else GroundMoveResult.direct
    local step = if not GroundMoveResult then nil else GroundMoveResult.step
    local v2 = false
    if direct ~= nil then
        v2 = 0.0004 < direct.horizontalDistanceSq
    end
    if not v2 and step ~= nil then
        v2 = 0.0004 < step.horizontalDistanceSq
    end
    local impactTrace = if not direct then MovedImpactTrace else direct.impactTrace
    local startSolid = false
    if impactTrace ~= nil then
        startSolid = false
        if impactTrace.normal.Y < Config.WalkableFloor then
            startSolid = impactTrace.startSolid or impactTrace.allSolid or impactTrace.fraction <= Config.PositionSnapEpsilon
        end
    end
    local touchedWall = if not direct then a1.MovedTouchedWall else direct.touchedWall
    if touchedWall then
        touchedWall = startSolid
        if touchedWall then
            touchedWall = v1
            if touchedWall then
                touchedWall = not v2
                if touchedWall then
                    touchedWall = false
                    if (horizontalMagnitude(Next.Velocity)) <= 0.35 then
                        touchedWall = (math.abs(Next.Velocity.Y)) <= Config.VelocityEpsilon
                    end
                end
            end
        end
    end
    local v3 = true
    local v4 = if impactTrace == nil then Vector3.new(0, 0, 0) else getWallConstraintNormal(getTraceClipNormal(impactTrace, Config), Config)
    if 1e-06 < v4.Magnitude and 1e-06 < a2.Magnitude then
        v3 = 0.95 <= (v4.Unit:Dot(a2.Unit))
    end
    local WalkPreClipVelocity = a1.WalkPreClipVelocity
    if touchedWall and WalkPreClipVelocity ~= nil and 1e-06 < a2.Magnitude and v3 then
        local v5 = WalkPreClipVelocity - a2 * WalkPreClipVelocity:Dot(a2)
        v5 = Vector3.new(v5.X, 0, v5.Z)
        local Magnitude = v5.Magnitude
        if Config.PositionSnapEpsilon < Magnitude then
            local v6 = a2 * WALL_RECOVERY_SEPARATION
            local v7 = a1.PreMovePosition + v6
            local v8, v9 = tryPlayerMove(v7, v5, DeltaTime, a1.World, Config, a1.Stance, false, u70)
            local v10 = v8.X - v7.X
            local v11 = v8.Z - v7.Z
            local v12 = math.sqrt(v10 * v10 + v11 * v11)
            local v13 = math.max(Config.PositionSnapEpsilon, Magnitude * DeltaTime * 0.5)
            local v14 = horizontalMagnitude(v9)
            local v15 = v8 - v6
            local v16 = false
            if v13 <= v12 and Config.PositionSnapEpsilon < v14 then
                v16 = isPointTestBlocked(a1.World:PointTest(v15, a1.Stance))
            end
            if v13 <= v12 and Config.PositionSnapEpsilon < v14 and not v16 then
                Next.Position = v15
                Next.Velocity = Vector3.new(v9.X, Next.Velocity.Y, v9.Z)
                Next.WallNormal = a1.RememberedWallNormal
                touchedWall = false
            end
        end
    end
    if not touchedWall then
        Next.StuckStepTicks = 0
        return
    end
    Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0)
    Next.StuckStepTicks = math.min(Next.StuckStepTicks + 1, 255)
end

local function commitMove(a1) -- Line: 674
    -- upvalues: state (val), line (val), clampHorizontal (val), getWallConstraintNormal (val)
    -- upvalues: getImpactWallConstraintNormal (val), recoverWedgedGroundMove (val)
    local Next = a1.Next
    local Config = a1.Config
    debug.profilebegin("Sim.postMove")
    Next.Position = a1.MovedPosition
    local MovedVelocity = a1.MovedVelocity
    local MaxVelocity = Config.MaxVelocity
    Next.Velocity = Vector3.new(
        math.clamp(MovedVelocity.X, -MaxVelocity, MaxVelocity),
        math.clamp(MovedVelocity.Y, -MaxVelocity, MaxVelocity),
        (math.clamp(MovedVelocity.Z, -MaxVelocity, MaxVelocity))
    )
    state("proven.postMoveCommit", Next, line(1))
    if 0 < Config.BunnyHopSpeedCap and not Next.OnGround and Next.MovementType == "Walking" then
        Next.Velocity = clampHorizontal(Next.Velocity, Config.BunnyHopSpeedCap)
    end
    local v1 = getWallConstraintNormal(a1.RememberedWallNormal, Config)
    if a1.RawWishSpeed <= Config.PositionSnapEpsilon or not a1.MovedTouchedWall then
        Next.WallNormal = Vector3.new(0, 0, 0)
    else
        Next.WallNormal = getImpactWallConstraintNormal(a1.MovedImpactTrace, Config)
    end
    if not Next.OnGround then
        Next.StuckStepTicks = 0
    else
        recoverWedgedGroundMove(a1, v1)
    end
    state("proven.wallRecovery", Next, line(1))
    debug.profileend()
end

local function finishRisingTick(a1) -- Line: 702 -- upvalues: state (val), line (val) -- types: a1: table
    local Next = a1.Next
    local Config = a1.Config
    local DeltaTime = a1.DeltaTime
    if Next.OnGround or not (Config.GroundClearVelocity < Next.Velocity.Y) then
        return false
    end
    if not a1.UsedLadderMove then
        Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0)
    end
    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault
    Next.GroundSupportIsDynamicPlayer = false
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime)
    Next.JumpHeld = a1.Input.Jump
    state("proven.risingReturn", Next, line(1))
    return true
end

local function traceGroundDecision(a1, a2, a3, a4) -- Line: 719
    -- upvalues: Trace (val), getResolvedSupportPosition (val), getTraceGroundNormal (val), vector (val), line (val)
    if not Trace.isActive() then
        return
    end
    local hullRecord = a2 and a2.hullRecord
    local SourceId_2 = if not a2 then if not hullRecord then 0 else if typeof(hullRecord.sourceId) ~= "number" then 0 else hullRecord.sourceId else if typeof(a2.SourceId) == "number" then a2.SourceId else if not hullRecord then 0 else if typeof(hullRecord.sourceId) ~= "number" then 0 else hullRecord.sourceId
    vector(a3, getResolvedSupportPosition(a2, a1.Next.Position), getTraceGroundNormal(a2) or Vector3.new(0, 0, 0), a4, SourceId_2, line(2))
end

local function evaluateGroundTrace(a1, a2, a3) -- Line: 732
    -- upvalues: isWalkableGround (val), traceGroundDecision (val), getLandingSnapDistance (val)
    -- upvalues: isRecoverableFloorSupportTrace (val), shouldRejectAirLanding (val), getTraceGroundNormal (val)
    local Next = a1.Next
    local Config = a1.Config
    if not isWalkableGround(a2, Config) then
        traceGroundDecision(a1, a2, "proven.groundDecision.noWalkableSupport", -1)
        return false, nil
    end
    if a1.PreProbeOnGround then
        traceGroundDecision(a1, a2, "proven.groundDecision.retainOwnedSupport", 0)
        return true, nil
    end
    local v1 = getLandingSnapDistance(Next.Position, a2)
    local v2 = isRecoverableFloorSupportTrace(a2, Config, a3)
    if not a2.startSolid and not a2.allSolid and not (a2.fraction <= Config.PositionSnapEpsilon) then
        if a3 < v1 then
            traceGroundDecision(a1, a2, "proven.groundDecision.rejectSnapDistance", v1)
            return false, "snapDistance"
        end
        if not a1.JumpedFromGround
            and shouldRejectAirLanding(Next.Velocity, getTraceGroundNormal(a2), v1, a3, Config.VelocityEpsilon) then
            traceGroundDecision(a1, a2, "proven.groundDecision.rejectMovingAway", v1)
            return false, "movingAwayFromSurface"
        end
        traceGroundDecision(a1, a2, "proven.groundDecision.acceptAirLanding", v1)
        return true, nil
    end
    if not v2 then
        traceGroundDecision(a1, a2, "proven.groundDecision.rejectEmbeddedNonFloor", v1)
        return false, "embeddedNonFloor"
    end
    if a3 < v1 then
        traceGroundDecision(a1, a2, "proven.groundDecision.rejectSnapDistance", v1)
        return false, "snapDistance"
    end
    if not a1.JumpedFromGround
        and shouldRejectAirLanding(Next.Velocity, getTraceGroundNormal(a2), v1, a3, Config.VelocityEpsilon) then
        traceGroundDecision(a1, a2, "proven.groundDecision.rejectMovingAway", v1)
        return false, "movingAwayFromSurface"
    end
    traceGroundDecision(a1, a2, "proven.groundDecision.acceptAirLanding", v1)
    return true, nil
end

local function categorizeGround(a1) -- Line: 776
    -- upvalues: getStance (val), GROUND_PROBE_START_BUMP (val), supportTraceMatchesPosition (val)
    -- upvalues: groundProbeWithRetry (val), evaluateGroundTrace (val), state (val), line (val)
    -- upvalues: getResolvedSupportPosition (val), isPointTestBlocked (val), getUncrouchClearance (val)
    -- upvalues: getTraceSurfaceVelocity (val), applyBunnyHopLandingPenalty (val), isDynamicPlayerSupportTrace (val)
    -- upvalues: getTraceSurfaceFriction (val), u43 (val)
    local v1, v2
    local Next = a1.Next
    local State = a1.State
    local Config = a1.Config
    local World = a1.World
    local DeltaTime = a1.DeltaTime
    debug.profilebegin("Sim.groundProbe")
    local OnGround = Next.OnGround
    a1.PreProbeOnGround = OnGround
    local JumpHullActive = Next.JumpHullActive and getStance(Next) == "standing"
    local Stance = if not JumpHullActive then a1.Stance else "standing"
    local v3 = if not JumpHullActive then 0 else (Config.PlayerSizeStanding.Y - Config.PlayerSizeDucking.Y) * 0.5
    local GroundProbeDistance_2 = if not OnGround then Config.GroundProbeDistance else math.max(Config.GroundProbeDistance, Config.MaxStepHeight)
    local v4 = GroundProbeDistance_2 + GROUND_PROBE_START_BUMP + Config.PositionSnapEpsilon
    local ReusableGroundTrace = a1.ReusableGroundTrace
    if not supportTraceMatchesPosition(ReusableGroundTrace, Next.Position, Config) then
        ReusableGroundTrace = groundProbeWithRetry(Next.Position, GroundProbeDistance_2, Stance, World, Config, OnGround, OnGround)
    end
    local v5 = evaluateGroundTrace(a1, ReusableGroundTrace, v4 + v3)
    state("proven.groundProbeEvaluated", Next, line(1))
    local v6 = getResolvedSupportPosition(ReusableGroundTrace, Next.Position)
    if JumpHullActive and v5 and isPointTestBlocked(World:PointTest(v6, "standing", true)) then
        v5 = false
    end
    if JumpHullActive and not v5 then
        local v7 = groundProbeWithRetry(Next.Position, GroundProbeDistance_2, "crouching", World, Config, OnGround, OnGround)
        if evaluateGroundTrace(a1, v7, v4) then
            local v8
            v1 = getResolvedSupportPosition(v7, Next.Position)
            v2, v8 = getUncrouchClearance(v1, World, Config)
            ReusableGroundTrace = v7
            v5 = true
            if not v2 then
                v6 = v8
            else
                v6 = v1
                Next.DuckAmount = 1
                Next.IsDucking = false
                Next.DuckTimeMsecs = math.max(Config.TimeToUnDuckMsecs, 1)
            end
        end
    end
    local Y = nil
    if not v5 then
        Next.OnGround = false
        Next.GroundSupportIsDynamicPlayer = false
        Next.GroundSurfaceFriction = if not (0 < Next.Velocity.Y) then Config.SurfaceFrictionDefault else 0.25
        if not a1.UsedLadderMove then
            Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0)
        end
    else
        v1 = not OnGround and State.OnGround == false
        if v1 then
            Y = State.Velocity.Y
        end
        v2 = getTraceSurfaceVelocity(ReusableGroundTrace)
        local MovedRelativeGroundVelocity = if not OnGround then Next.Velocity - v2 else a1.MovedRelativeGroundVelocity
        if v1 then
            MovedRelativeGroundVelocity = applyBunnyHopLandingPenalty(MovedRelativeGroundVelocity, Config)
        end
        Next.OnGround = true
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(ReusableGroundTrace)
        Next.GroundNormal = ReusableGroundTrace.normal
        Next.GroundSurfaceFriction = getTraceSurfaceFriction(ReusableGroundTrace, Config)
        Next.Position = v6
        Next.Velocity = Vector3.new(MovedRelativeGroundVelocity.X, 0, MovedRelativeGroundVelocity.Z) + v2
        Next.JumpHullActive = false
    end
    state("proven.groundCategorization", Next, line(1))
    Next.Stamina = u43.finishStamina(Next.Stamina, Y, DeltaTime, Config)
    Next.JumpHeld = a1.Input.Jump
    state("proven.finalState", Next, line(1))
    debug.profileend()
    if v5 then
        return ReusableGroundTrace
    end
    return nil
end

function u43.step(a1, a2, a3, a4, a5, a6) -- Line: 888
    -- upvalues: Trace (val), beginStep (val), Duck (val), state (val), line (val), resolveSpeedAndStance (val)
    -- upvalues: recoverStartSolid (val), resolveWish (val), moveOnLadder (val), moveOffLadder (val), commitMove (val)
    -- upvalues: finishRisingTick (val), categorizeGround (val)
    Trace.bind(a6)
    local v1 = beginStep(a1, a2, a3, a4, a5, a6)
    local Next = v1.Next
    debug.profilebegin("Sim.duck")
    Duck.applyDuckStateForStep(Next, a1, a2, a3, a4, a5)
    debug.profileend()
    state("proven.duckState", Next, line(1))
    resolveSpeedAndStance(v1)
    recoverStartSolid(v1)
    resolveWish(v1)
    if moveOnLadder(v1) then
        Trace.bind(nil)
        return Next, nil
    end
    if not v1.UsedLadderMove then
        moveOffLadder(v1)
    end
    commitMove(v1)
    if finishRisingTick(v1) then
        Trace.bind(nil)
        return Next, nil
    end
    local v2 = categorizeGround(v1)
    Trace.bind(nil)
    return Next, v2
end

function u43.checkStandingClearance(a1, a2, a3) -- Line: 926
    -- upvalues: getUncrouchClearance (val)
    local v1, v2 = getUncrouchClearance(a1, a2, a3)
    return v1, v2
end

return table.freeze(u43)