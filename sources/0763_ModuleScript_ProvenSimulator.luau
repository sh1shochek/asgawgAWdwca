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

local function applyBunnyHopLandingPenalty(p5: vector, p6: any) -- Line: 94
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

local function clampVelocityComponents(p7: vector, p8: number) -- Line: 114
    local math_clamp_ret = math.clamp(p7.X, -p8, p8);
    local math_clamp_ret2 = math.clamp(p7.Y, -p8, p8);
    local math_clamp_ret3 = math.clamp(p7.Z, -p8, p8);

    return Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
end;

local function isGroundJumpCommandActive(p9, p10, p11) -- Line: 122
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

local function getStaminaFloor(p13) -- Line: 133
    return math.max(0, p13.StaminaMax - p13.StaminaMaxPenalty);
end;

local function getStaminaScale(p14: number, p15: any) -- Line: 138
    local v16 = p14 / math.max(p15.StaminaMax, 1);

    return math.clamp(v16, 0, 1);
end;

local function applyStaminaPenalty(p17: number, p18: number, p19: number, p20: any) -- Line: 143
    local v21 = p18 * (math.max(p19, 0) / p20.HammerUnitToStud);
    local math_max_ret = math.max(0, p20.StaminaMax - p20.StaminaMaxPenalty);

    return math.max(math_max_ret, p17 - v21);
end;

function u1.finishStamina(p22: number, p23: number?, p24: number, p25: any) -- Line: 153
    if p23 ~= nil then
        local v26 = p25.StaminaLandCost * (math.max(-p23, 0) / p25.HammerUnitToStud);
        local math_max_ret = math.max(0, p25.StaminaMax - p25.StaminaMaxPenalty);
        p22 = math.max(math_max_ret, p22 - v26);
    end;

    return math.min(p25.StaminaMax, p22 + p25.StaminaRecoveryRate * p24);
end;

local function createStepState(p27, p28, p29) -- Line: 166
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

local function activateJumpHull(p31: table) -- Line: 198
    if not p31.Config.AutoJumpHull then
        return;
    end;

    p31.Next.JumpHullActive = true;
    p31.Stance = "crouching";
end;

local function beginStep(p32: any, p33: any, p34: number, p35: any, p36: any, p37: any) -- Line: 206
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
    p35:BeginStepBounds(v40.Position, v40.Velocity, math.max(p36.MaxSpeed, p33.BaseMoveSpeed), p34);

    return v38;
end;

local function resolveSpeedAndStance(p41: table) -- Line: 245
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

    local v45 = Next.Stamina / math.max(Config.StaminaMax, 1);
    local math_clamp_ret2 = math.clamp(v45, 0, 1);
    p41.SpeedModifier = 1 * v43 * (math_clamp_ret2 * math_clamp_ret2);
    p41.GroundAccelerationModifier = v44;
    p41.Stance = Next.JumpHullActive and "crouching" or getStance(Next);
end;

local function recoverStartSolid(p46: table) -- Line: 277
    -- upvalues: script_SlideMove (copy), state (copy), line (copy)
    local Next = p46.Next;
    local math_floor_ret = math.floor(0.25 / p46.DeltaTime + 0.5);
    local math_max_ret = math.max(1, math_floor_ret);
    local v47;

    if Next.StuckStepTicks > 0 or p46.Input.Tick % math_max_ret == 0 then
        v47 = script_SlideMove.escapeStartSolid(Next.Position, p46.Stance, p46.World);
    else
        v47 = nil;
    end;

    if v47 ~= nil then
        Next.Position = v47;
    end;

    state("proven.startSolidRecovery", Next, line(1));
end;

local function resolveWish(p48: table) -- Line: 291
    -- upvalues: ProvenMath (copy), state (copy), line (copy)
    local Next = p48.Next;
    local State = p48.State;
    local Input = p48.Input;
    local Config = p48.Config;
    local v49 = ProvenMath.moveVectorToWorld(Input.MoveVector, Input.LookYaw);
    local MaxSpeed = Config.MaxSpeed;

    if typeof(Input.BaseMoveSpeed) == "number" then
        MaxSpeed = math.clamp(Input.BaseMoveSpeed, 0, Config.MaxBaseMoveSpeed);
    end;

    local v50 = MaxSpeed <= Config.PositionSnapEpsilon;
    local v51;

    if v50 then
        Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0);
        v49 = Vector3.new(0, 0, 0);
        v51 = Vector3.new(0, 0, 0);
    else
        v51 = v49;
    end;

    state("proven.movementLock", Next, line(1));

    if Config.BunnyHopInputBufferTicks <= 0 or v50 then
        Next.JumpBufferTicksRemaining = 0;
    else
        Next.JumpBufferTicksRemaining = math.max(0, State.JumpBufferTicksRemaining - 1);

        if Input.Jump and not State.JumpHeld then
            Next.JumpBufferTicksRemaining = math.min(Config.BunnyHopInputBufferTicks, 255);
        end;
    end;

    state("proven.jumpBuffer", Next, line(1));
    local v52 = MaxSpeed * p48.SpeedModifier;
    local v53, v54;

    if v51.Magnitude <= 0 then
        v53 = 0;
        v54 = 0;
    else
        v51 = v51.Unit;
        v54 = v52;
        v53 = v54;
        v49 = v51;
        local v55 = v54;
        v54 = v53;
        v55 = v53;
        v53 = v54;
    end;

    p48.MovementLocked = v50;
    p48.JumpInputAllowed = not v50;
    p48.WishDir = v51;
    p48.RawWishDir = v49;
    p48.WishSpeed = v53;
    p48.MaxGroundSpeed = v52;
    p48.RawWishSpeed = v54;
    p48.PreMovePosition = Next.Position;
    p48.RememberedWallNormal = Next.WallNormal;
    p48.WallConstraintWarmStartNormal = State.MovementType ~= "Walking" and Vector3.new(0, 0, 0) or Next.WallNormal;
    local v56;

    if Config.BunnyHopInputBufferTicks > 0 then
        v56 = Next.JumpBufferTicksRemaining > 0;
    else
        v56 = false;
    end;

    if Input.Jump and (Config.AutoBunnyHop or not Next.JumpHeld) or v56 then
        v56 = Input.Tick - Next.LastJumpTick > 1;
    end;

    p48.GroundJumpCommandActive = v56;
end;

local function moveOnLadder(p57: table) -- Line: 342
    -- upvalues: script_Ladder (copy), state (copy), line (copy), getLadderNormal (copy), getTraceSurfaceVelocity (copy), u2 (copy), vector (copy)
    local Next = p57.Next;
    local Input = p57.Input;
    local Config = p57.Config;
    local World = p57.World;
    local DeltaTime = p57.DeltaTime;
    local v58 = nil;
    local v59 = p57.JumpInputAllowed and Next.OnGround and p57.GroundJumpCommandActive;
    debug.profilebegin("Sim.ladderFind");

    if p57.MovementLocked or p57.State.MovementType ~= "Ladder" then
        if not (p57.MovementLocked or (v59 or p57.RawWishSpeed <= Config.PositionSnapEpsilon)) then
            v58 = script_Ladder.findLadderTrace(Next.Position, p57.Stance, World, Config, p57.RawWishDir, Next.WallNormal, Config.LadderAttachDistance, true);
        end;
    else
        v58 = script_Ladder.findLadderTrace(Next.Position, p57.Stance, World, Config, p57.RawWishDir, Next.WallNormal, Config.LadderDetachDistance, false);
    end;

    debug.profileend();
    state("proven.ladderFind", Next, line(1));

    if v58 == nil then
        Next.MovementType = "Walking";

        return false;
    end;

    local v60 = getLadderNormal(v58, Next.WallNormal);

    if p57.JumpInputAllowed and (Input.Jump and not Next.JumpHeld) then
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
        Next.MovementType = "Walking";
        Next.WallNormal = Vector3.new(0, 0, 0);
        Next.Velocity = v60 * Config.LadderJumpOffSpeed + getTraceSurfaceVelocity(v58);
        Next.LastJumpTick = Input.Tick;
        Next.JumpBufferTicksRemaining = 0;

        if p57.Config.AutoJumpHull then
            p57.Next.JumpHullActive = true;
            p57.Stance = "crouching";
        end;

        state("proven.ladderJumpOff", Next, line(1));

        return false;
    end;

    local v61 = script_Ladder.simulateLadderMove(Next.Position, Input, DeltaTime, World, Config, p57.Stance, v58, Next.WallNormal, Next.OnGround, u2);

    if v61.detached then
        p57.UsedLadderMove = true;
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
        Next.MovementType = "Walking";
        Next.JumpHullActive = false;
        p57.MovedPosition = v61.position;
        p57.MovedVelocity = v61.velocity;
        p57.MovedTouchedWall = v61.touchedWall;
        p57.MovedImpactTrace = v61.impactTrace;
        vector("proven.ladderDetach", v61.position, v61.velocity, 0, 0, line(1));

        return false;
    end;

    Next.Position = v61.position;
    Next.Velocity = v61.velocity;
    Next.OnGround = false;
    Next.GroundSupportIsDynamicPlayer = false;
    Next.GroundNormal = Vector3.new(0, 1, 0);
    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
    Next.WallNormal = getLadderNormal(v61.contactTrace or v58, v60);
    Next.MovementType = "Ladder";
    Next.JumpHullActive = false;
    Next.StuckStepTicks = 0;
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime);
    Next.JumpHeld = Input.Jump;
    state("proven.ladderMoveReturn", Next, line(1));

    return true;
end;

local function prevalidatePlayerSupport(p62: table) -- Line: 444
    -- upvalues: groundProbeWithRetry (copy), isWalkableGround (copy), isDynamicPlayerSupportTrace (copy), state (copy), line (copy)
    local Next = p62.Next;
    local Config = p62.Config;
    debug.profilebegin("Sim.playerSupportPrevalidation");
    local v63 = groundProbeWithRetry(Next.Position, Config.GroundProbeDistance, p62.Stance, p62.World, Config, false, true);
    local v64 = isWalkableGround(v63, Config);
    debug.profileend();

    if v64 then
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(v63);
    else
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
    end;

    state("proven.playerSupportPrevalidation", Next, line(1));
end;

local function moveOnGround(p65: table) -- Line: 468
    -- upvalues: script_GroundMove (copy), getTraceSurfaceFriction (copy), state (copy), line (copy), u2 (copy)
    local Next = p65.Next;
    local Input = p65.Input;
    local Config = p65.Config;
    local World = p65.World;
    debug.profilebegin("Sim.groundMove");
    local GroundSupportVelocity, v66 = script_GroundMove.getGroundSupportVelocity(Next.Position, p65.Stance, World, Config);
    local v67;

    if v66 == nil then
        v67 = Next.GroundSurfaceFriction;
    else
        v67 = getTraceSurfaceFriction(v66, Config);
    end;

    Next.GroundSurfaceFriction = v67;

    if p65.MovementLocked then
        Next.Velocity = GroundSupportVelocity;
    end;

    state("proven.groundSupportVelocity", Next, line(1));
    local v68 = Next.Velocity - GroundSupportVelocity;

    if p65.JumpInputAllowed and p65.GroundJumpCommandActive then
        local v69 = Next.Stamina / math.max(Config.StaminaMax, 1);
        local math_clamp_ret = math.clamp(v69, 0, 1);
        local v70 = Config.JumpSpeed * math_clamp_ret;
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.Velocity = Vector3.new(v68.X + GroundSupportVelocity.X, v70, v68.Z + GroundSupportVelocity.Z);
        Next.LastJumpTick = Input.Tick;
        Next.JumpBufferTicksRemaining = 0;
        local Stamina = Next.Stamina;
        local v71 = Config.StaminaJumpCost * (math.max(v70, 0) / Config.HammerUnitToStud);
        local math_max_ret = math.max(0, Config.StaminaMax - Config.StaminaMaxPenalty);
        Next.Stamina = math.max(math_max_ret, Stamina - v71);
        p65.JumpedFromGround = true;

        if p65.Config.AutoJumpHull then
            p65.Next.JumpHullActive = true;
            p65.Stance = "crouching";
        end;

        state("proven.groundJump", Next, line(1));
    else
        Next.Velocity = Vector3.new(v68.X, 0, v68.Z) + GroundSupportVelocity;
        local v72, v73, v74, v75, v76, v77, _, v78, v79 = script_GroundMove.walkMove(Next.Position, Next.Velocity, p65.WishDir, p65.WishSpeed, p65.MaxGroundSpeed, p65.DeltaTime, World, Config, p65.Stance, GroundSupportVelocity, v67, p65.GroundAccelerationModifier, u2);
        p65.GroundMoveResult = v76;
        p65.MovedPosition = v72;
        p65.MovedVelocity = v73;
        p65.MovedTouchedWall = v78;
        p65.MovedImpactTrace = v79;
        p65.MovedRelativeGroundVelocity = v74;
        p65.ReusableGroundTrace = v77;
        p65.WalkPreClipVelocity = v75;
        Next.Velocity = v73;
        state("proven.walkMoveCommit", Next, line(1));
    end;

    debug.profileend();
end;

local function moveInAir(p80: table) -- Line: 535
    -- upvalues: getStance (copy), script_AirMove (copy), u2 (copy), vector (copy), line (copy)
    local Next = p80.Next;
    local Config = p80.Config;
    debug.profilebegin("Sim.airMove");
    local v81;

    if Config.AutoJumpLedgeAssistHeight > Config.PositionSnapEpsilon then
        v81 = Config.AutoJumpLedgeAssistLiftSpeed > Config.PositionSnapEpsilon;
    else
        v81 = false;
    end;

    local v82 = Next.JumpHullActive and getStance(Next) == "standing";
    local v83, v84, v85, v86, v87 = script_AirMove.airMove(Next.Position, Next.Velocity, p80.WishDir, p80.WishSpeed, p80.DeltaTime, p80.World, Config, p80.Stance, v81, v82, Next.GroundSurfaceFriction, p80.WallConstraintWarmStartNormal, u2);
    p80.MovedPosition = v83;
    p80.MovedVelocity = v84;
    p80.MovedTouchedWall = v86;
    p80.MovedImpactTrace = v87;
    vector("proven.airMoveResult", v83, v84, 0, v85 and 1 or 0, line(1));
    debug.profileend();
end;

local function moveOffLadder(p88: table) -- Line: 565
    -- upvalues: state (copy), line (copy), prevalidatePlayerSupport (copy), moveOnGround (copy), moveInAir (copy)
    local Next = p88.Next;
    Next.Velocity = Next.Velocity + Vector3.new(0, -p88.Config.Gravity * p88.DeltaTime * 0.5, 0);
    state("proven.gravityFirstHalf", Next, line(1));

    if Next.OnGround and p88.HadDynamicPlayerSupport then
        prevalidatePlayerSupport(p88);
    end;

    if Next.OnGround then
        moveOnGround(p88);
    end;

    if not Next.OnGround then
        moveInAir(p88);
    end;
end;

local function recoverWedgedGroundMove(p89: table, p90: vector) -- Line: 581
    -- upvalues: horizontalMagnitude (copy), getWallConstraintNormal (copy), getTraceClipNormal (copy), WALL_RECOVERY_SEPARATION (copy), tryPlayerMove (copy), u2 (copy), isPointTestBlocked (copy)
    local Next = p89.Next;
    local Config = p89.Config;
    local DeltaTime = p89.DeltaTime;
    local GroundMoveResult = p89.GroundMoveResult;
    local MovedImpactTrace = p89.MovedImpactTrace;
    local v91;

    if GroundMoveResult then
        v91 = GroundMoveResult.direct;
    else
        v91 = nil;
    end;

    local v92;

    if GroundMoveResult then
        v92 = GroundMoveResult.step;
    else
        v92 = nil;
    end;

    local v93;

    if v91 == nil then
        v93 = false;
    else
        v93 = v91.horizontalDistanceSq > 0.0004;
    end;

    if not v93 and v92 ~= nil then
        v93 = v92.horizontalDistanceSq > 0.0004;
    end;

    if v91 then
        MovedImpactTrace = v91.impactTrace;
    end;

    local v94;

    if MovedImpactTrace == nil or MovedImpactTrace.normal.Y >= Config.WalkableFloor then
        v94 = false;
    else
        v94 = MovedImpactTrace.startSolid or (MovedImpactTrace.allSolid or MovedImpactTrace.fraction <= Config.PositionSnapEpsilon);
    end;

    local v95;

    if v91 then
        v95 = v91.touchedWall;
    else
        v95 = p89.MovedTouchedWall;
    end;

    local v96 = v95 and (v94 and (p89.WishSpeed > Config.PositionSnapEpsilon and not v93));

    if v96 then
        if horizontalMagnitude(Next.Velocity) <= 0.35 then
            v96 = math.abs(Next.Velocity.Y) <= Config.VelocityEpsilon;
        else
            v96 = false;
        end;
    end;

    local v97 = MovedImpactTrace == nil and Vector3.new(0, 0, 0) or getWallConstraintNormal(getTraceClipNormal(MovedImpactTrace, Config), Config);
    local v98 = (v97.Magnitude <= 1e-6 or p90.Magnitude <= 1e-6) and true or v97.Unit:Dot(p90.Unit) >= 0.95;
    local WalkPreClipVelocity = p89.WalkPreClipVelocity;

    if v96 and (WalkPreClipVelocity ~= nil and (p90.Magnitude > 1e-6 and v98)) then
        local v99 = WalkPreClipVelocity - p90 * WalkPreClipVelocity:Dot(p90);
        local Vector3_new_ret = Vector3.new(v99.X, 0, v99.Z);
        local Magnitude = Vector3_new_ret.Magnitude;

        if Config.PositionSnapEpsilon < Magnitude then
            local v100 = p90 * WALL_RECOVERY_SEPARATION;
            local v101 = p89.PreMovePosition + v100;
            local v102, v103 = tryPlayerMove(v101, Vector3_new_ret, DeltaTime, p89.World, Config, p89.Stance, false, u2);
            local v104 = v102.X - v101.X;
            local v105 = v102.Z - v101.Z;
            local math_sqrt_ret = math.sqrt(v104 * v104 + v105 * v105);
            local math_max_ret = math.max(Config.PositionSnapEpsilon, Magnitude * DeltaTime * 0.5);
            local v106 = horizontalMagnitude(v103);
            local v107 = v102 - v100;
            local v108;

            if math_max_ret <= math_sqrt_ret and Config.PositionSnapEpsilon < v106 then
                v108 = isPointTestBlocked(p89.World:PointTest(v107, p89.Stance));
            else
                v108 = false;
            end;

            if math_max_ret <= math_sqrt_ret and (Config.PositionSnapEpsilon < v106 and not v108) then
                Next.Position = v107;
                Next.Velocity = Vector3.new(v103.X, Next.Velocity.Y, v103.Z);
                Next.WallNormal = p89.RememberedWallNormal;
                v96 = false;
            end;
        end;
    end;

    if not v96 then
        Next.StuckStepTicks = 0;

        return;
    end;

    Next.Velocity = Vector3.new(0, Next.Velocity.Y, 0);
    Next.StuckStepTicks = math.min(Next.StuckStepTicks + 1, 255);
end;

local function commitMove(p109: table) -- Line: 674
    -- upvalues: state (copy), line (copy), clampHorizontal (copy), getWallConstraintNormal (copy), getImpactWallConstraintNormal (copy), recoverWedgedGroundMove (copy)
    local Next = p109.Next;
    local Config = p109.Config;
    debug.profilebegin("Sim.postMove");
    Next.Position = p109.MovedPosition;
    local MovedVelocity = p109.MovedVelocity;
    local MaxVelocity = Config.MaxVelocity;
    local math_clamp_ret = math.clamp(MovedVelocity.X, -MaxVelocity, MaxVelocity);
    local math_clamp_ret2 = math.clamp(MovedVelocity.Y, -MaxVelocity, MaxVelocity);
    local math_clamp_ret3 = math.clamp(MovedVelocity.Z, -MaxVelocity, MaxVelocity);
    Next.Velocity = Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
    state("proven.postMoveCommit", Next, line(1));

    if Config.BunnyHopSpeedCap > 0 and (not Next.OnGround and Next.MovementType == "Walking") then
        Next.Velocity = clampHorizontal(Next.Velocity, Config.BunnyHopSpeedCap);
    end;

    local v110 = getWallConstraintNormal(p109.RememberedWallNormal, Config);

    if p109.RawWishSpeed <= Config.PositionSnapEpsilon then
        Next.WallNormal = Vector3.new(0, 0, 0);
    elseif p109.MovedTouchedWall then
        Next.WallNormal = getImpactWallConstraintNormal(p109.MovedImpactTrace, Config);
    else
        Next.WallNormal = Vector3.new(0, 0, 0);
    end;

    if Next.OnGround then
        recoverWedgedGroundMove(p109, v110);
    else
        Next.StuckStepTicks = 0;
    end;

    state("proven.wallRecovery", Next, line(1));
    debug.profileend();
end;

local function finishRisingTick(p111: table) -- Line: 702
    -- upvalues: state (copy), line (copy)
    local Next = p111.Next;
    local Config = p111.Config;
    local DeltaTime = p111.DeltaTime;

    if not (not Next.OnGround and Next.Velocity.Y > Config.GroundClearVelocity) then
        return false;
    end;

    if not p111.UsedLadderMove then
        Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0);
    end;

    Next.GroundSurfaceFriction = Config.SurfaceFrictionDefault;
    Next.GroundSupportIsDynamicPlayer = false;
    Next.Stamina = math.min(Config.StaminaMax, Next.Stamina + Config.StaminaRecoveryRate * DeltaTime);
    Next.JumpHeld = p111.Input.Jump;
    state("proven.risingReturn", Next, line(1));

    return true;
end;

local function traceGroundDecision(p112: table, p113: any, p114: string, p115: number) -- Line: 719
    -- upvalues: script_Trace (copy), getResolvedSupportPosition (copy), getTraceGroundNormal (copy), vector (copy), line (copy)
    if not script_Trace.isActive() then
        return;
    end;

    local v116;

    if p113 then
        v116 = p113.hullRecord;
    else
        v116 = p113;
    end;

    local v117;

    if p113 and typeof(p113.SourceId) == "number" then
        v117 = p113.SourceId;
    else
        v117 = (not v116 or typeof(v116.sourceId) ~= "number") and 0 or v116.sourceId;
    end;

    vector(p114, getResolvedSupportPosition(p113, p112.Next.Position), getTraceGroundNormal(p113) or Vector3.new(0, 0, 0), p115, v117, line(2));
end;

local function evaluateGroundTrace(p118: table, p119: any, p120: number) -- Line: 732
    -- upvalues: isWalkableGround (copy), traceGroundDecision (copy), getLandingSnapDistance (copy), isRecoverableFloorSupportTrace (copy), shouldRejectAirLanding (copy), getTraceGroundNormal (copy)
    local Next = p118.Next;
    local Config = p118.Config;

    if not isWalkableGround(p119, Config) then
        traceGroundDecision(p118, p119, "proven.groundDecision.noWalkableSupport", -1);

        return false, nil;
    end;

    if p118.PreProbeOnGround then
        traceGroundDecision(p118, p119, "proven.groundDecision.retainOwnedSupport", 0);

        return true, nil;
    end;

    local v121 = getLandingSnapDistance(Next.Position, p119);
    local v122 = isRecoverableFloorSupportTrace(p119, Config, p120);

    if (p119.startSolid or (p119.allSolid or p119.fraction <= Config.PositionSnapEpsilon)) and not v122 then
        traceGroundDecision(p118, p119, "proven.groundDecision.rejectEmbeddedNonFloor", v121);

        return false, "embeddedNonFloor";
    end;

    if p120 < v121 then
        traceGroundDecision(p118, p119, "proven.groundDecision.rejectSnapDistance", v121);

        return false, "snapDistance";
    end;

    if p118.JumpedFromGround or not shouldRejectAirLanding(Next.Velocity, getTraceGroundNormal(p119), v121, p120, Config.VelocityEpsilon) then
        traceGroundDecision(p118, p119, "proven.groundDecision.acceptAirLanding", v121);

        return true, nil;
    end;

    traceGroundDecision(p118, p119, "proven.groundDecision.rejectMovingAway", v121);

    return false, "movingAwayFromSurface";
end;

local function categorizeGround(p123: table) -- Line: 776
    -- upvalues: getStance (copy), GROUND_PROBE_START_BUMP (copy), supportTraceMatchesPosition (copy), groundProbeWithRetry (copy), evaluateGroundTrace (copy), state (copy), line (copy), getResolvedSupportPosition (copy), isPointTestBlocked (copy), getUncrouchClearance (copy), getTraceSurfaceVelocity (copy), applyBunnyHopLandingPenalty (copy), isDynamicPlayerSupportTrace (copy), getTraceSurfaceFriction (copy), u1 (copy)
    local Next = p123.Next;
    local State = p123.State;
    local Config = p123.Config;
    local World = p123.World;
    local DeltaTime = p123.DeltaTime;
    debug.profilebegin("Sim.groundProbe");
    local OnGround = Next.OnGround;
    p123.PreProbeOnGround = OnGround;
    local v124 = Next.JumpHullActive and getStance(Next) == "standing";
    local v125 = v124 and "standing" or p123.Stance;
    local v126 = not v124 and 0 or (Config.PlayerSizeStanding.Y - Config.PlayerSizeDucking.Y) * 0.5;
    local v127;

    if OnGround then
        v127 = math.max(Config.GroundProbeDistance, Config.MaxStepHeight);
    else
        v127 = Config.GroundProbeDistance;
    end;

    local v128 = v127 + GROUND_PROBE_START_BUMP + Config.PositionSnapEpsilon;
    local ReusableGroundTrace = p123.ReusableGroundTrace;

    if not supportTraceMatchesPosition(ReusableGroundTrace, Next.Position, Config) then
        ReusableGroundTrace = groundProbeWithRetry(Next.Position, v127, v125, World, Config, OnGround, OnGround);
    end;

    local v129 = evaluateGroundTrace(p123, ReusableGroundTrace, v128 + v126);
    state("proven.groundProbeEvaluated", Next, line(1));
    local v130 = getResolvedSupportPosition(ReusableGroundTrace, Next.Position);

    if v124 and (v129 and isPointTestBlocked(World:PointTest(v130, "standing", true))) then
        v129 = false;
    end;

    local v131;

    if v124 and not v129 then
        v131 = groundProbeWithRetry(Next.Position, v127, "crouching", World, Config, OnGround, OnGround);

        if evaluateGroundTrace(p123, v131, v128) then
            v130 = getResolvedSupportPosition(v131, Next.Position);
            local v132, v133 = getUncrouchClearance(v130, World, Config);
            v129 = true;

            if v132 then
                Next.DuckAmount = 1;
                Next.IsDucking = false;
                Next.DuckTimeMsecs = math.max(Config.TimeToUnDuckMsecs, 1);
            else
                v130 = v133;
            end;
        else
            v131 = ReusableGroundTrace;
        end;
    else
        v131 = ReusableGroundTrace;
    end;

    local v134 = nil;

    if v129 then
        local v135 = not OnGround and State.OnGround == false;

        if v135 then
            v134 = State.Velocity.Y;
        end;

        local v136 = getTraceSurfaceVelocity(v131);
        local v137;

        if OnGround then
            v137 = p123.MovedRelativeGroundVelocity;
        else
            v137 = Next.Velocity - v136;
        end;

        if v135 then
            v137 = applyBunnyHopLandingPenalty(v137, Config);
        end;

        Next.OnGround = true;
        Next.GroundSupportIsDynamicPlayer = isDynamicPlayerSupportTrace(v131);
        Next.GroundNormal = v131.normal;
        Next.GroundSurfaceFriction = getTraceSurfaceFriction(v131, Config);
        Next.Position = v130;
        Next.Velocity = Vector3.new(v137.X, 0, v137.Z) + v136;
        Next.JumpHullActive = false;
    else
        Next.OnGround = false;
        Next.GroundSupportIsDynamicPlayer = false;
        Next.GroundSurfaceFriction = Next.Velocity.Y > 0 and 0.25 or Config.SurfaceFrictionDefault;

        if not p123.UsedLadderMove then
            Next.Velocity = Next.Velocity + Vector3.new(0, -Config.Gravity * DeltaTime * 0.5, 0);
        end;
    end;

    state("proven.groundCategorization", Next, line(1));
    Next.Stamina = u1.finishStamina(Next.Stamina, v134, DeltaTime, Config);
    Next.JumpHeld = p123.Input.Jump;
    state("proven.finalState", Next, line(1));
    debug.profileend();

    if v129 then
        return v131;
    end;

    return nil;
end;

function u1.step(p138: any, p139: any, p140: number, p141: any, p142: any, p143: any) -- Line: 888
    -- upvalues: script_Trace (copy), beginStep (copy), script_Duck (copy), state (copy), line (copy), resolveSpeedAndStance (copy), recoverStartSolid (copy), resolveWish (copy), moveOnLadder (copy), moveOffLadder (copy), commitMove (copy), finishRisingTick (copy), categorizeGround (copy)
    script_Trace.bind(p143);
    local v144 = beginStep(p138, p139, p140, p141, p142, p143);
    local Next = v144.Next;
    debug.profilebegin("Sim.duck");
    script_Duck.applyDuckStateForStep(Next, p138, p139, p140, p141, p142);
    debug.profileend();
    state("proven.duckState", Next, line(1));
    resolveSpeedAndStance(v144);
    recoverStartSolid(v144);
    resolveWish(v144);

    if moveOnLadder(v144) then
        script_Trace.bind(nil);

        return Next, nil;
    end;

    if not v144.UsedLadderMove then
        moveOffLadder(v144);
    end;

    commitMove(v144);

    if finishRisingTick(v144) then
        script_Trace.bind(nil);

        return Next, nil;
    end;

    local v145 = categorizeGround(v144);
    script_Trace.bind(nil);

    return Next, v145;
end;

function u1.checkStandingClearance(p146: vector, p147: any, p148: any) -- Line: 926
    -- upvalues: getUncrouchClearance (copy)
    local v149, v150 = getUncrouchClearance(p146, p147, p148);

    return v149, v150;
end;

return table.freeze(u1);