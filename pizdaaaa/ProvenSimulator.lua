-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator
-- Decompile time: 15.61 ms

-- Decompiled with Potassium's decompiler.

require(script.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.ProvenMath);
require(script.Parent.DeterminismTrace);
local script_Trace = require(script.Trace);
local script_TraceRules = require(script.TraceRules);
local script_Duck = require(script.Duck);
local script_SlideMove = require(script.SlideMove);
local script_GroundMove = require(script.GroundMove);
local script_AirMove = require(script.AirMove);
local script_Ladder = require(script.Ladder);
local u1 = {};
local line = script_Trace.line;
local state = script_Trace.state;
local vector = script_Trace.vector;
local clampHorizontal = ProvenMath.clampHorizontal;
local horizontalMagnitude = ProvenMath.horizontalMagnitude;
local getStance = script_Duck.getStance;
local getUncrouchClearance = script_Duck.getUncrouchClearance;
local tryPlayerMove = script_SlideMove.tryPlayerMove;
local groundProbeWithRetry = script_GroundMove.groundProbeWithRetry;
local getLadderNormal = script_Ladder.getLadderNormal;
local GROUND_PROBE_START_BUMP = script_TraceRules.GROUND_PROBE_START_BUMP;
local WALL_RECOVERY_SEPARATION = script_SlideMove.WALL_RECOVERY_SEPARATION;
local isPointTestBlocked = script_TraceRules.isPointTestBlocked;
local getTraceClipNormal = script_TraceRules.getTraceClipNormal;
local getWallConstraintNormal = script_TraceRules.getWallConstraintNormal;
local getTraceSurfaceVelocity = script_TraceRules.getTraceSurfaceVelocity;
local getTraceSurfaceFriction = script_TraceRules.getTraceSurfaceFriction;
local getImpactWallConstraintNormal = script_TraceRules.getImpactWallConstraintNormal;
local isDynamicPlayerSupportTrace = script_TraceRules.isDynamicPlayerSupportTrace;
local isRecoverableFloorSupportTrace = script_TraceRules.isRecoverableFloorSupportTrace;
local getResolvedSupportPosition = script_TraceRules.getResolvedSupportPosition;
local isWalkableGround = script_TraceRules.isWalkableGround;
local getTraceGroundNormal = script_TraceRules.getTraceGroundNormal;
local getLandingSnapDistance = script_TraceRules.getLandingSnapDistance;
local shouldRejectAirLanding = script_TraceRules.shouldRejectAirLanding;
local supportTraceMatchesPosition = script_TraceRules.supportTraceMatchesPosition;
local u2 = {};
local u3 = {};
local u4 = {};

local function applyBunnyHopLandingPenalty(p5: vector, p6: any) -- Line: 95
    local BunnyHopPenaltyThreshold = p6.BunnyHopPenaltyThreshold;

    if BunnyHopPenaltyThreshold <= 0 then
        return p5;
    end;

    local math_sqrt_ret = math.sqrt(p5.X * p5.X + p5.Z * p5.Z);

    if math_sqrt_ret <= BunnyHopPenaltyThreshold then
        return p5;
    end;

    local math_max_ret = math.max(p6.BunnyHopMinVelocityRetain, 1 - (p6.BunnyHopPenaltyBase + (math_sqrt_ret - BunnyHopPenaltyThreshold) * p6.BunnyHopPenaltyScale));
    local math_clamp_ret = math.clamp(math_max_ret, 0, 1);

    return Vector3.new(p5.X * math_clamp_ret, p5.Y, p5.Z * math_clamp_ret);
end;

u1.applyLandingVelocity = applyBunnyHopLandingPenalty;

local function clampVelocityComponents(p7: vector, p8: number) -- Line: 115
    local math_clamp_ret = math.clamp(p7.X, -p8, p8);
    local math_clamp_ret2 = math.clamp(p7.Y, -p8, p8);
    local math_clamp_ret3 = math.clamp(p7.Z, -p8, p8);

    return Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
end;

local function isGroundJumpCommandActive(p9, p10, p11) -- Line: 123
    local v12;

    if p11.BunnyHopInputBufferTicks > 0 then
        v12 = p9.JumpBufferTicksRemaining > 0;
    else
        v12 = false;
    end;

    if p10.Jump and (p11.AutoBunnyHop or not p9.JumpHeld) or v12 then
        v12 = p10.Tick - p9.LastJumpTick > 1;
    end;

    return v12;
end;

local function getStaminaFloor(p13) -- Line: 134
    return math.max(0, p13.StaminaMax - p13.StaminaMaxPenalty);
end;

local function getStaminaScale(p14: number, p15: any) -- Line: 139
    local v16 = p14 / math.max(p15.StaminaMax, 1);

    return math.clamp(v16, 0, 1);
end;

local function applyStaminaPenalty(p17: number, p18: number, p19: number, p20: any) -- Line: 144
    local v21 = p18 * (math.max(p19, 0) / p20.HammerUnitToStud);
    local math_max_ret = math.max(0, p20.StaminaMax - p20.StaminaMaxPenalty);

    return math.max(math_max_ret, p17 - v21);
end;

function u1.finishStamina(p22: number, p23: number?, p24: number, p25: any) -- Line: 154
    if p23 ~= nil then
        local v26 = p25.StaminaLandCost * (math.max(-p23, 0) / p25.HammerUnitToStud);
        local math_max_ret = math.max(0, p25.StaminaMax - p25.StaminaMaxPenalty);
        p22 = math.max(math_max_ret, p22 - v26);
    end;

    return math.min(p25.StaminaMax, p22 + p25.StaminaRecoveryRate * p24);
end;

local function createStepState(p27, p28, p29) -- Line: 167
    local v30 = p29 or {};

    if p29 then
        table.clear(p29);
    end;

    v30.Position = p27.Position;
    v30.Velocity = p27.Velocity;
    v30.OnGround = p27.OnGround;
    v30.GroundSupportIsDynamicPlayer = p27.OnGround and p27.GroundSupportIsDynamicPlayer == true;
    v30.GroundNormal = p27.GroundNormal;
    v30.GroundSurfaceFriction = p27.GroundSurfaceFriction;
    v30.WallNormal = p27.WallNormal;
    v30.DuckAmount = p27.DuckAmount;
    v30.DuckTimeMsecs = p27.DuckTimeMsecs;
    v30.IsDucking = p27.IsDucking == true;
    v30.DuckHeld = p28.Duck == true;
    v30.DuckFatigueLevel = p27.DuckFatigueLevel;
    v30.DuckFatigueTimerMsecs = p27.DuckFatigueTimerMsecs;
    v30.MovementType = p27.MovementType;
    v30.Stamina = p27.Stamina;
    v30.LastJumpTick = p27.LastJumpTick;
    v30.JumpHeld = p27.JumpHeld;
    v30.JumpBufferTicksRemaining = p27.JumpBufferTicksRemaining;
    v30.JumpHullActive = p27.JumpHullActive == true;
    v30.StuckStepTicks = p27.StuckStepTicks;

    return v30;
end;

local function activateJumpHull(p31: table) -- Line: 199
    if not p31.Config.AutoJumpHull then
        return;
    end;

    p31.Next.JumpHullActive = true;
    p31.Stance = "crouching";
end;

local function beginStep(p32: any, p33: any, p34: number, p35: any, p36: any, p37: any) -- Line: 207
    -- upvalues: u3 (copy), createStepState (copy), u4 (copy), state (copy), line (copy)
    local v38 = u3;
    table.clear(v38);
    v38.State = p32;
    v38.Input = p33;
    v38.DeltaTime = p34;
    v38.World = p35;
    v38.Config = p36;
    v38.UsedLadderMove = false;
    v38.JumpedFromGround = false;
    v38.MovedRelativeGroundVelocity = Vector3.new(0, 0, 0);
    local v39;

    if p37 == nil then
        v39 = u4;
    else
        v39 = nil;
    end;

    local v40 = createStepState(p32, p33, v39);
    v38.Next = v40;
    state("proven.createStepState", v40, line(1));

    if not (p36.AutoJumpHull and (not v40.OnGround and v40.MovementType ~= "Ladder")) then
        v40.JumpHullActive = false;
    end;

    v38.HadDynamicPlayerSupport = p32.OnGround and p32.GroundSupportIsDynamicPlayer == true;
    local Velocity = v40.Velocity;
    local MaxVelocity = p36.MaxVelocity;
    local math_clamp_ret = math.clamp(Velocity.X, -MaxVelocity, MaxVelocity);
    local math_clamp_ret2 = math.clamp(Velocity.Y, -MaxVelocity, MaxVelocity);
    local math_clamp_ret3 = math.clamp(Velocity.Z, -MaxVelocity, MaxVelocity);
    v40.Velocity = Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
    state("proven.velocityInputClamp", v40, line(1));
    p35:BeginStepBounds(v40.Position, v40.Velocity, math.max(p36.MaxSpeed, p33.BaseMoveSpeed, not p33.Sprint and 0 or p36.SprintSpeed), p34);

    return v38;
end;

local function resolveSpeedAndStance(p41: table) -- Line: 246
    -- upvalues: getStance (copy)
    local Next = p41.Next;
    local Input = p41.Input;
    local Config = p41.Config;
    local math_clamp_ret = math.clamp(Next.DuckAmount, 0, 1);
    local v42 = Next.OnGround and (math_clamp_ret > 0 and true or Next.IsDucking);
    local v43, v44;

    if v42 then
        v43 = 1 + (Config.CrouchModifier - 1) * math_clamp_ret;
        v44 = Config.CrouchModifier;
    else
        v43 = 1;
        v44 = 1;
    end;

    if Input.Walk then
        v43 = math.min(v43, Config.WalkModifier);

        if not v42 then
            v44 = Config.WalkModifier;
        end;
    end;

    local v45;

    if Input.Sprint == true then
        v45 = not (Input.Walk or v42) and Input.MoveVector.Y < 0;
    else
        v45 = false;
    end;

    p41.Sprinting = v45;
    local v46 = Next.Stamina / math.max(Config.StaminaMax, 1);
    local math_clamp_ret2 = math.clamp(v46, 0, 1);
    p41.SpeedModifier = 1 * v43 * (math_clamp_ret2 * math_clamp_ret2);
    p41.GroundAccelerationModifier = v44;
    p41.Stance = Next.JumpHullActive and "crouching" or getStance(Next);
end;

local function recoverStartSolid(p47: table) -- Line: 281
    -- upvalues: script_SlideMove (copy), state (copy), line (copy)
    local Next = p47.Next;
    local math_floor_ret = math.floor(0.25 / p47.DeltaTime + 0.5);
    local math_max_ret = math.max(1, math_floor_ret);
    local v48;

    if Next.StuckStepTicks > 0 or p47.Input.Tick % math_max_ret == 0 then
        v48 = script_SlideMove.escapeStartSolid(Next.Position, p47.Stance, p47.World);
    else
        v48 = nil;
    end;

    if v48 ~= nil then
        Next.Position = v48;
    end;

    state("proven.startSolidRecovery", Next, line(1));
end;

local function resolveWish(p49: table) -- Line: 295
    -- upvalues: ProvenMath (copy), state (copy), line (copy)
    local Next = p49.Next;
    local State = p49.State;
    local Input = p49.Input;
    local Config = p49.Config;
    local v50 = ProvenMath.moveVectorToWorld(Input.MoveVector, Input.LookYaw);
    local MaxSpeed = Config.MaxSpeed;

    if typeof(Input.BaseMoveSpeed) == "number" then
        MaxSpeed = math.clamp(Input.BaseMoveSpeed, 0, Config.MaxBaseMoveSpeed);
    end;

    local v51 = MaxSpeed <= Config.PositionSnapEpsilon;
    local v52;

    if v51 then
        Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0);
        v50 = Vector3.new(0, 0, 0);
        v52 = Vector3.new(0, 0, 0);
    elseif p49.Sprinting then
        MaxSpeed = Config.SprintSpeed;
        v52 = v50;
    else
        v52 = v50;
    end;

    state("proven.movementLock", Next, line(1));

    if Config.BunnyHopInputBufferTicks <= 0 or v51 then
        Next.JumpBufferTicksRemaining = 0;
    else
        Next.JumpBufferTicksRemaining = math.max(0, State.JumpBufferTicksRemaining - 1);

        if Input.Jump and not State.JumpHeld then
            Next.JumpBufferTicksRemaining = math.min(Config.BunnyHopInputBufferTicks, 255);
        end;
    end;

    state("proven.jumpBuffer", Next, line(1));
    local v53 = MaxSpeed * p49.SpeedModifier;
    local v54, v55;

    if v50.Magnitude <= 0 then
        v54 = 0;
        v55 = 0;
    else
        v50 = v50.Unit;
        v55 = v53;
        v54 = v55;
        v52 = v50;
        local v56 = v55;
        v55 = v54;
        v56 = v54;
        v54 = v55;
    end;

    p49.MovementLocked = v51;
    p49.JumpInputAllowed = not v51;
    p49.WishDir = v50;
    p49.RawWishDir = v52;
    p49.WishSpeed = v54;
    p49.MaxGroundSpeed = v53;
    p49.RawWishSpeed = v55;
    p49.PreMovePosition = Next.Position;
    p49.RememberedWallNormal = Next.WallNormal;
    p49.WallConstraintWarmStartNormal = State.MovementType ~= "Walking" and Vector3.new(0, 0, 0) or Next.WallNormal;
    local v57;

    if Config.BunnyHopInputBufferTicks > 0 then
        v57 = Next.JumpBufferTicksRemaining > 0;
    else
        v57 = false;
    end;

    if Input.Jump and (Config.AutoBunnyHop or not Next.JumpHeld) or v57 then
        v57 = Input.Tick - Next.LastJumpTick > 1;
    end;

    p49.GroundJumpCommandActive = v57;
end;

local function moveOnLadder(p58: table) -- Line: 348
    -- upvalues: script_Ladder (copy), state (copy), line (copy), getLadderNormal (copy), getTraceSurfaceVelocity (copy), u2 (copy), vector (copy)
    local Next = p58.Next;
    local Input = p58.Input;
    local Config = p58.Config;
    local World = p58.World;
    local DeltaTime = p58.DeltaTime;
    local v59 = nil;
    local v60 = p58.JumpInputAllowed and Next.OnGround and p58.GroundJumpCommandActive;
    debug.profilebegin("Sim.ladderFind");

    if p58.MovementLocked or p58.State.MovementType ~= "Ladder" then
        if not (p58.MovementLocked or (v60 or p58.RawWishSpeed <= Config.PositionSnapEpsilon)) then
            v59 = script_Ladder.findLadderTrace(Next.Position, p58.Stance, World, Config, p58.RawWishDir, Next.WallNormal, Config.LadderAttachDistance, true);
        end;
    else
        v59 = script_Ladder.findLadderTrace(Next.Position, p58.Stance, World, Config, p58.RawWishDir, Next.WallNormal, Config.LadderDetachDistance, false);
    end;

    debug.profileend();
    state("proven.ladderFind", Next, line(1));

    if v59 == nil then
        Next.MovementType = "Walking";

        return false;
    end;

    local v61 = getLadderNormal(v59, Next.WallNormal);

    if p58.JumpInputAllowed and (Input.Jump and not Next.JumpHeld) then
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
        Next.MovementType = "Walking";
        Next.WallNormal = Vector3.new(0, 0, 0);
        Next.Velocity = v61 * Config.LadderJumpOffSpeed + getTraceSurfaceVelocity(v59);
        Next.LastJumpTick = Input.Tick;
        Next.JumpBufferTicksRemaining = 0;

        if p58.Config.AutoJumpHull then
            p58.Next.JumpHullActive = true;
            p58.Stance = "crouching";
        end;

        state("proven.ladderJumpOff", Next, line(1));

        return false;
    end;

    local v62 = script_Ladder.simulateLadderMove(Next.Position, Input, DeltaTime, World, Config, p58.Stance, v59, Next.WallNormal, Next.OnGround, u2);

    if v62.detached then
        p58.UsedLadderMove = true;
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
        Next.MovementType = "Walking";
        Next.JumpHullActive = false;
        p58.MovedPosition = v62.position;
        p58.MovedVelocity = v62.velocity;
        p58.MovedTouchedWall = v62.touchedWall;
        p58.MovedImpactTrace = v62.impactTrace;
        vector("proven.ladderDetach", v62.position, v62.velocity, 0, 0, line(1));

        return false;
    end;

    Next.Position = v62.position;
    Next.Velocity = v62.velocity;
    Next.OnGround = false;
    Next.GroundSupportIsDynamicPlayer = false;
    Next.GroundNormal = Vector3.new(0, 1, 0);
    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
    Next.WallNormal = getLadderNormal(v62.contactTrace or v59, v61);
    Next.MovementType = "Ladder";
    Next.JumpHullActive = false;
    Next.StuckStepTicks = 0;
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime);
    Next.JumpHeld = Input.Jump;
    state("proven.ladderMoveReturn", Next, line(1));

    return true;
end;

local function prevalidatePlayerSupport(p63: table) -- Line: 450
    -- upvalues: groundProbeWithRetry (copy), isWalkableGround (copy), isDynamicPlayerSupportTrace (copy), state (copy), line (copy)
    local Next = p63.Next;
    local Config = p63.Config;
    debug.profilebegin("Sim.playerSupportPrevalidation");
    local v64 = groundProbeWithRetry(Next.Position, Config.GroundProbeDistance, p63.Stance, p63.World, Config, false, true);
    local v65 = isWalkableGround(v64, Config);
    debug.profileend();

    if v65 then
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(v64);
    else
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
    end;

    state("proven.playerSupportPrevalidation", Next, line(1));
end;

local function moveOnGround(p66: table) -- Line: 474
    -- upvalues: script_GroundMove (copy), getTraceSurfaceFriction (copy), state (copy), line (copy), u2 (copy)
    local Next = p66.Next;
    local Input = p66.Input;
    local Config = p66.Config;
    local World = p66.World;
    debug.profilebegin("Sim.groundMove");
    local GroundSupportVelocity, v67 = script_GroundMove.getGroundSupportVelocity(Next.Position, p66.Stance, World, Config);
    local v68;

    if v67 == nil then
        v68 = Next.GroundSurfaceFriction;
    else
        v68 = getTraceSurfaceFriction(v67, Config);
    end;

    Next.GroundSurfaceFriction = v68;

    if p66.MovementLocked then
        Next.Velocity = GroundSupportVelocity;
    end;

    state("proven.groundSupportVelocity", Next, line(1));
    local v69 = Next.Velocity - GroundSupportVelocity;

    if p66.JumpInputAllowed and p66.GroundJumpCommandActive then
        local v70 = Next.Stamina / math.max(Config.StaminaMax, 1);
        local math_clamp_ret = math.clamp(v70, 0, 1);
        local v71 = Config.JumpSpeed * math_clamp_ret;
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.Velocity = Vector3.new(v69.X + GroundSupportVelocity.X, v71, v69.Z + GroundSupportVelocity.Z);
        Next.LastJumpTick = Input.Tick;
        Next.JumpBufferTicksRemaining = 0;
        local Stamina = Next.Stamina;
        local v72 = Config.StaminaJumpCost * (math.max(v71, 0) / Config.HammerUnitToStud);
        local math_max_ret = math.max(0, Config.StaminaMax - Config.StaminaMaxPenalty);
        Next.Stamina = math.max(math_max_ret, Stamina - v72);
        p66.JumpedFromGround = true;

        if p66.Config.AutoJumpHull then
            p66.Next.JumpHullActive = true;
            p66.Stance = "crouching";
        end;

        state("proven.groundJump", Next, line(1));
    else
        Next.Velocity = Vector3.new(v69.X, 0, v69.Z) + GroundSupportVelocity;
        local v73, v74, v75, v76, v77, v78, _, v79, v80 = script_GroundMove.walkMove(Next.Position, Next.Velocity, p66.WishDir, p66.WishSpeed, p66.MaxGroundSpeed, p66.DeltaTime, World, Config, p66.Stance, GroundSupportVelocity, v68, p66.GroundAccelerationModifier, u2);
        p66.GroundMoveResult = v77;
        p66.MovedPosition = v73;
        p66.MovedVelocity = v74;
        p66.MovedTouchedWall = v79;
        p66.MovedImpactTrace = v80;
        p66.MovedRelativeGroundVelocity = v75;
        p66.ReusableGroundTrace = v78;
        p66.WalkPreClipVelocity = v76;
        Next.Velocity = v74;
        state("proven.walkMoveCommit", Next, line(1));
    end;

    debug.profileend();
end;

local function moveInAir(p81: table) -- Line: 541
    -- upvalues: getStance (copy), script_AirMove (copy), u2 (copy), vector (copy), line (copy)
    local Next = p81.Next;
    local Config = p81.Config;
    debug.profilebegin("Sim.airMove");
    local v82;

    if Config.AutoJumpLedgeAssistHeight > Config.PositionSnapEpsilon then
        v82 = Config.AutoJumpLedgeAssistLiftSpeed > Config.PositionSnapEpsilon;
    else
        v82 = false;
    end;

    local v83 = Next.JumpHullActive and getStance(Next) == "standing";
    local v84, v85, v86, v87, v88 = script_AirMove.airMove(Next.Position, Next.Velocity, p81.WishDir, p81.WishSpeed, p81.DeltaTime, p81.World, Config, p81.Stance, v82, v83, Next.GroundSurfaceFriction, p81.WallConstraintWarmStartNormal, u2);
    p81.MovedPosition = v84;
    p81.MovedVelocity = v85;
    p81.MovedTouchedWall = v87;
    p81.MovedImpactTrace = v88;
    vector("proven.airMoveResult", v84, v85, 0, v86 and 1 or 0, line(1));
    debug.profileend();
end;

local function moveOffLadder(p89: table) -- Line: 571
    -- upvalues: state (copy), line (copy), prevalidatePlayerSupport (copy), moveOnGround (copy), moveInAir (copy)
    local Next = p89.Next;
    Next.Velocity = Next.Velocity + Vector3.new(0, -p89.Config.Gravity * p89.DeltaTime * 0.5, 0);
    state("proven.gravityFirstHalf", Next, line(1));

    if Next.OnGround and p89.HadDynamicPlayerSupport then
        prevalidatePlayerSupport(p89);
    end;

    if Next.OnGround then
        moveOnGround(p89);
    end;

    if not Next.OnGround then
        moveInAir(p89);
    end;
end;

local function recoverWedgedGroundMove(p90: table, p91: vector) -- Line: 587
    -- upvalues: horizontalMagnitude (copy), getWallConstraintNormal (copy), getTraceClipNormal (copy), WALL_RECOVERY_SEPARATION (copy), tryPlayerMove (copy), u2 (copy), isPointTestBlocked (copy)
    local Next = p90.Next;
    local Config = p90.Config;
    local DeltaTime = p90.DeltaTime;
    local GroundMoveResult = p90.GroundMoveResult;
    local MovedImpactTrace = p90.MovedImpactTrace;
    local v92;

    if GroundMoveResult then
        v92 = GroundMoveResult.direct;
    else
        v92 = nil;
    end;

    local v93;

    if GroundMoveResult then
        v93 = GroundMoveResult.step;
    else
        v93 = nil;
    end;

    local v94;

    if v92 == nil then
        v94 = false;
    else
        v94 = v92.horizontalDistanceSq > 0.0004;
    end;

    if not v94 and v93 ~= nil then
        v94 = v93.horizontalDistanceSq > 0.0004;
    end;

    if v92 then
        MovedImpactTrace = v92.impactTrace;
    end;

    local v95;

    if MovedImpactTrace == nil or MovedImpactTrace.normal.Y >= Config.WalkableFloor then
        v95 = false;
    else
        v95 = MovedImpactTrace.startSolid or (MovedImpactTrace.allSolid or MovedImpactTrace.fraction <= Config.PositionSnapEpsilon);
    end;

    local v96;

    if v92 then
        v96 = v92.touchedWall;
    else
        v96 = p90.MovedTouchedWall;
    end;

    local v97 = v96 and (v95 and (p90.WishSpeed > Config.PositionSnapEpsilon and not v94));

    if v97 then
        if horizontalMagnitude(Next.Velocity) <= 0.35 then
            v97 = math.abs(Next.Velocity.Y) <= Config.VelocityEpsilon;
        else
            v97 = false;
        end;
    end;

    local v98 = MovedImpactTrace == nil and Vector3.new(0, 0, 0) or getWallConstraintNormal(getTraceClipNormal(MovedImpactTrace, Config), Config);
    local v99 = (v98.Magnitude <= 1e-6 or p91.Magnitude <= 1e-6) and true or v98.Unit:Dot(p91.Unit) >= 0.95;
    local WalkPreClipVelocity = p90.WalkPreClipVelocity;

    if v97 and (WalkPreClipVelocity ~= nil and (p91.Magnitude > 1e-6 and v99)) then
        local v100 = WalkPreClipVelocity - p91 * WalkPreClipVelocity:Dot(p91);
        local Vector3_new_ret = Vector3.new(v100.X, 0, v100.Z);
        local Magnitude = Vector3_new_ret.Magnitude;

        if Config.PositionSnapEpsilon < Magnitude then
            local v101 = p91 * WALL_RECOVERY_SEPARATION;
            local v102 = p90.PreMovePosition + v101;
            local v103, v104 = tryPlayerMove(v102, Vector3_new_ret, DeltaTime, p90.World, Config, p90.Stance, false, u2);
            local v105 = v103.X - v102.X;
            local v106 = v103.Z - v102.Z;
            local math_sqrt_ret = math.sqrt(v105 * v105 + v106 * v106);
            local math_max_ret = math.max(Config.PositionSnapEpsilon, Magnitude * DeltaTime * 0.5);
            local v107 = horizontalMagnitude(v104);
            local v108 = v103 - v101;
            local v109;

            if math_max_ret <= math_sqrt_ret and Config.PositionSnapEpsilon < v107 then
                v109 = isPointTestBlocked(p90.World:PointTest(v108, p90.Stance));
            else
                v109 = false;
            end;

            if math_max_ret <= math_sqrt_ret and (Config.PositionSnapEpsilon < v107 and not v109) then
                Next.Position = v108;
                Next.Velocity = Vector3.new(v104.X, Next.Velocity.Y, v104.Z);
                Next.WallNormal = p90.RememberedWallNormal;
                v97 = false;
            end;
        end;
    end;

    if not v97 then
        Next.StuckStepTicks = 0;

        return;
    end;

    Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0);
    Next.StuckStepTicks = math.min(Next.StuckStepTicks + 1, 255);
end;

local function commitMove(p110: table) -- Line: 680
    -- upvalues: state (copy), line (copy), clampHorizontal (copy), getWallConstraintNormal (copy), getImpactWallConstraintNormal (copy), recoverWedgedGroundMove (copy)
    local Next = p110.Next;
    local Config = p110.Config;
    debug.profilebegin("Sim.postMove");
    Next.Position = p110.MovedPosition;
    local MovedVelocity = p110.MovedVelocity;
    local MaxVelocity = Config.MaxVelocity;
    local math_clamp_ret = math.clamp(MovedVelocity.X, -MaxVelocity, MaxVelocity);
    local math_clamp_ret2 = math.clamp(MovedVelocity.Y, -MaxVelocity, MaxVelocity);
    local math_clamp_ret3 = math.clamp(MovedVelocity.Z, -MaxVelocity, MaxVelocity);
    Next.Velocity = Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
    state("proven.postMoveCommit", Next, line(1));

    if Config.BunnyHopSpeedCap > 0 and (not Next.OnGround and Next.MovementType == "Walking") then
        Next.Velocity = clampHorizontal(Next.Velocity, Config.BunnyHopSpeedCap);
    end;

    local v111 = getWallConstraintNormal(p110.RememberedWallNormal, Config);

    if p110.RawWishSpeed <= Config.PositionSnapEpsilon then
        Next.WallNormal = Vector3.new(0, 0, 0);
    elseif p110.MovedTouchedWall then
        Next.WallNormal = getImpactWallConstraintNormal(p110.MovedImpactTrace, Config);
    else
        Next.WallNormal = Vector3.new(0, 0, 0);
    end;

    if Next.OnGround then
        recoverWedgedGroundMove(p110, v111);
    else
        Next.StuckStepTicks = 0;
    end;

    state("proven.wallRecovery", Next, line(1));
    debug.profileend();
end;

local function finishRisingTick(p112: table) -- Line: 708
    -- upvalues: state (copy), line (copy)
    local Next = p112.Next;
    local Config = p112.Config;
    local DeltaTime = p112.DeltaTime;

    if not (not Next.OnGround and Next.Velocity.Y > Config.GroundClearVelocity) then
        return false;
    end;

    if not p112.UsedLadderMove then
        Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0);
    end;

    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
    Next.GroundSupportIsDynamicPlayer = false;
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime);
    Next.JumpHeld = p112.Input.Jump;
    state("proven.risingReturn", Next, line(1));

    return true;
end;

local function traceGroundDecision(p113: table, p114: any, p115: string, p116: number) -- Line: 725
    -- upvalues: script_Trace (copy), getResolvedSupportPosition (copy), getTraceGroundNormal (copy), vector (copy), line (copy)
    if not script_Trace.isActive() then
        return;
    end;

    local v117;

    if p114 then
        v117 = p114.hullRecord;
    else
        v117 = p114;
    end;

    local v118;

    if p114 and typeof(p114.SourceId) == "number" then
        v118 = p114.SourceId;
    else
        v118 = (not v117 or typeof(v117.sourceId) ~= "number") and 0 or v117.sourceId;
    end;

    vector(p115, getResolvedSupportPosition(p114, p113.Next.Position), getTraceGroundNormal(p114) or Vector3.new(0, 0, 0), p116, v118, line(2));
end;

local function evaluateGroundTrace(p119: table, p120: any, p121: number) -- Line: 738
    -- upvalues: isWalkableGround (copy), traceGroundDecision (copy), getLandingSnapDistance (copy), isRecoverableFloorSupportTrace (copy), shouldRejectAirLanding (copy), getTraceGroundNormal (copy)
    local Next = p119.Next;
    local Config = p119.Config;

    if not isWalkableGround(p120, Config) then
        traceGroundDecision(p119, p120, "proven.groundDecision.noWalkableSupport", -1);

        return false, nil;
    end;

    if p119.PreProbeOnGround then
        traceGroundDecision(p119, p120, "proven.groundDecision.retainOwnedSupport", 0);

        return true, nil;
    end;

    local v122 = getLandingSnapDistance(Next.Position, p120);
    local v123 = isRecoverableFloorSupportTrace(p120, Config, p121);

    if (p120.startSolid or (p120.allSolid or p120.fraction <= Config.PositionSnapEpsilon)) and not v123 then
        traceGroundDecision(p119, p120, "proven.groundDecision.rejectEmbeddedNonFloor", v122);

        return false, "embeddedNonFloor";
    end;

    if p121 < v122 then
        traceGroundDecision(p119, p120, "proven.groundDecision.rejectSnapDistance", v122);

        return false, "snapDistance";
    end;

    if p119.JumpedFromGround or not shouldRejectAirLanding(Next.Velocity, getTraceGroundNormal(p120), v122, p121, Config.VelocityEpsilon) then
        traceGroundDecision(p119, p120, "proven.groundDecision.acceptAirLanding", v122);

        return true, nil;
    end;

    traceGroundDecision(p119, p120, "proven.groundDecision.rejectMovingAway", v122);

    return false, "movingAwayFromSurface";
end;

local function categorizeGround(p124: table) -- Line: 782
    -- upvalues: getStance (copy), GROUND_PROBE_START_BUMP (copy), supportTraceMatchesPosition (copy), groundProbeWithRetry (copy), evaluateGroundTrace (copy), state (copy), line (copy), getResolvedSupportPosition (copy), isPointTestBlocked (copy), getUncrouchClearance (copy), getTraceSurfaceVelocity (copy), applyBunnyHopLandingPenalty (copy), isDynamicPlayerSupportTrace (copy), getTraceSurfaceFriction (copy), u1 (copy)
    local Next = p124.Next;
    local State = p124.State;
    local Config = p124.Config;
    local World = p124.World;
    local DeltaTime = p124.DeltaTime;
    debug.profilebegin("Sim.groundProbe");
    local OnGround = Next.OnGround;
    p124.PreProbeOnGround = OnGround;
    local v125 = Next.JumpHullActive and getStance(Next) == "standing";
    local v126 = v125 and "standing" or p124.Stance;
    local v127 = not v125 and 0 or (Config.PlayerSizeStanding.Y - Config.PlayerSizeDucking.Y) * 0.5;
    local v128;

    if OnGround then
        v128 = math.max(Config.GroundProbeDistance, Config.MaxStepHeight);
    else
        v128 = Config.GroundProbeDistance;
    end;

    local v129 = v128 + GROUND_PROBE_START_BUMP + Config.PositionSnapEpsilon;
    local ReusableGroundTrace = p124.ReusableGroundTrace;

    if not supportTraceMatchesPosition(ReusableGroundTrace, Next.Position, Config) then
        ReusableGroundTrace = groundProbeWithRetry(Next.Position, v128, v126, World, Config, OnGround, OnGround);
    end;

    local v130 = evaluateGroundTrace(p124, ReusableGroundTrace, v129 + v127);
    state("proven.groundProbeEvaluated", Next, line(1));
    local v131 = getResolvedSupportPosition(ReusableGroundTrace, Next.Position);

    if v125 and (v130 and isPointTestBlocked(World:PointTest(v131, "standing", true))) then
        v130 = false;
    end;

    local v132;

    if v125 and not v130 then
        v132 = groundProbeWithRetry(Next.Position, v128, "crouching", World, Config, OnGround, OnGround);

        if evaluateGroundTrace(p124, v132, v129) then
            v131 = getResolvedSupportPosition(v132, Next.Position);
            local v133, v134 = getUncrouchClearance(v131, World, Config);
            v130 = true;

            if v133 then
                Next.DuckAmount = 1;
                Next.IsDucking = false;
                Next.DuckTimeMsecs = math.max(Config.TimeToUnDuckMsecs, 1);
            else
                v131 = v134;
            end;
        else
            v132 = ReusableGroundTrace;
        end;
    else
        v132 = ReusableGroundTrace;
    end;

    local v135 = nil;

    if v130 then
        local v136 = not OnGround and State.OnGround == false;

        if v136 then
            v135 = State.Velocity.Y;
        end;

        local v137 = getTraceSurfaceVelocity(v132);
        local v138;

        if OnGround then
            v138 = p124.MovedRelativeGroundVelocity;
        else
            v138 = Next.Velocity - v137;
        end;

        if v136 then
            v138 = applyBunnyHopLandingPenalty(v138, Config);
        end;

        Next.OnGround = true;
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(v132);
        Next.GroundNormal = v132.normal;
        Next.GroundSurfaceFriction = getTraceSurfaceFriction(v132, Config);
        Next.Position = v131;
        Next.Velocity = Vector3.new(v138.X, 0, v138.Z) + v137;
        Next.JumpHullActive = false;
    else
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Next.Velocity.Y > 0 and 0.25 or Config.SurfaceFrictionDefault;

        if not p124.UsedLadderMove then
            Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0);
        end;
    end;

    state("proven.groundCategorization", Next, line(1));
    Next.Stamina = u1.finishStamina(Next.Stamina, v135, DeltaTime, Config);
    Next.JumpHeld = p124.Input.Jump;
    state("proven.finalState", Next, line(1));
    debug.profileend();

    if v130 then
        return v132;
    end;

    return nil;
end;

function u1.step(p139: any, p140: any, p141: number, p142: any, p143: any, p144: any) -- Line: 894
    -- upvalues: script_Trace (copy), beginStep (copy), script_Duck (copy), state (copy), line (copy), resolveSpeedAndStance (copy), recoverStartSolid (copy), resolveWish (copy), moveOnLadder (copy), moveOffLadder (copy), commitMove (copy), finishRisingTick (copy), categorizeGround (copy)
    script_Trace.bind(p144);
    local v145 = beginStep(p139, p140, p141, p142, p143, p144);
    local Next = v145.Next;
    debug.profilebegin("Sim.duck");
    script_Duck.applyDuckStateForStep(Next, p139, p140, p141, p142, p143);
    debug.profileend();
    state("proven.duckState", Next, line(1));
    resolveSpeedAndStance(v145);
    recoverStartSolid(v145);
    resolveWish(v145);

    if moveOnLadder(v145) then
        script_Trace.bind(nil);

        return Next, nil;
    end;

    if not v145.UsedLadderMove then
        moveOffLadder(v145);
    end;

    commitMove(v145);

    if finishRisingTick(v145) then
        script_Trace.bind(nil);

        return Next, nil;
    end;

    local v146 = categorizeGround(v145);
    script_Trace.bind(nil);

    return Next, v146;
end;

function u1.checkStandingClearance(p147: vector, p148: any, p149: any) -- Line: 932
    -- upvalues: getUncrouchClearance (copy)
    local v150, v151 = getUncrouchClearance(p147, p148, p149);

    return v150, v151;
end;

return table.freeze(u1);