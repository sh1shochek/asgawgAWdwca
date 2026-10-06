-- Decompiled with Potassium's decompiler.

local SpeedProfile = require(script.Parent.Parent.SpeedProfile);
local Config = require(script.Parent.Parent.Config);
local u1 = {};
local HammerUnitToStud = SpeedProfile.HammerUnitToStud;
u1.Default = table.freeze({
    HammerUnitToStud = HammerUnitToStud,
    PlayerSizeStanding = Vector3.new(32, 72, 32) * HammerUnitToStud,
    PlayerSizeDucking = Vector3.new(32, 54, 32) * HammerUnitToStud,
    Gravity = 800 * HammerUnitToStud,
    JumpSpeed = 301.993377 * HammerUnitToStud,
    GroundAccelerate = 5.5,
    AirAccelerate = 12,
    AirSpeedCap = 30 * HammerUnitToStud,
    Friction = 5.2,
    StopSpeed = 80 * HammerUnitToStud,
    WalkModifier = SpeedProfile.WalkModifier,
    CrouchModifier = SpeedProfile.CrouchModifier,
    WalkableFloor = 0.7,
    GroundProbeDistance = 2 * HammerUnitToStud,
    GroundProbeStartBump = 0.03,
    GroundClearVelocity = 140 * HammerUnitToStud,
    MaxStepHeight = 18 * HammerUnitToStud,
    MaxBumps = 4,
    MaxClipPlanes = 5,
    PositionSnapEpsilon = 0.001,
    VelocityEpsilon = 0.05,
    PlaneEpsilon = 0.00001,
    MaxVelocity = 3500 * HammerUnitToStud,
    DefaultBaseMoveSpeed = SpeedProfile.DefaultBaseSpeed,
    MaxBaseMoveSpeed = SpeedProfile.TopSpeed,
    SurfaceFrictionDefault = 1,
    LadderAttachDistance = 2 * HammerUnitToStud,
    LadderSpeed = 200 * HammerUnitToStud,
    LadderJumpOffSpeed = 270 * HammerUnitToStud,
    Overbounce = 1,
    BunnyHopInputBufferTicks = 0,
    AutoJumpHull = false,
    AutoBunnyHop = false,
    AutoJumpLedgeAssistHeight = 0,
    AutoJumpLedgeAssistLiftSpeed = 0,
    BunnyHopSpeedCap = 0,
    BunnyHopAirAccelerate = 0,
    BunnyHopAirSpeedCap = 0,
    BunnyHopPenaltyThreshold = 0,
    BunnyHopPenaltyBase = 0,
    BunnyHopPenaltyScale = 0,
    BunnyHopMinVelocityRetain = 1,
    MaxSpeed = SpeedProfile.DefaultBaseSpeed,
    TimeToDuckMsecs = 200,
    TimeToUnDuckMsecs = 200,
    DuckJumpOriginShiftFraction = 0.2,
    DuckSpeedIdeal = 8,
    DuckSpeedRecoveryRate = 3,
    DuckSpeedFastRecoveryRate = 6,
    DuckSpeedDuckMultiplier = 0.8,
    DuckSpeedUnduckMinimum = 1.5,
    DuckSpamPenalty = 2,
    DuckSpamMinSpeed = 1.5,
    TimeBetweenDucksMsecs = 400,
    StaminaMax = 100,
    StaminaMaxPenalty = 80,
    StaminaRecoveryRate = 60,
    StaminaJumpCost = 0.08,
    StaminaLandCost = 0.05,
    LadderDetachDistance = 10 * HammerUnitToStud,
    LadderClimbModifier = 0.34,
    LadderLateralScale = 0.78,
    LadderDampen = 0.2,
    LadderDampenAngle = -0.707
});
local DefaultSimulationHz = Config.DefaultSimulationHz;
local u2 = {};

local function casualDeathmatchProfile(p3: number) -- Line: 158
    -- upvalues: u2 (copy), u1 (copy)
    local v4 = u2[p3];

    if v4 ~= nil then
        return v4;
    end;

    local table_clone_ret = table.clone(u1.Default);
    local math_floor_ret = math.floor(p3 * 0.1 + 0.5);
    table_clone_ret.BunnyHopInputBufferTicks = math.max(1, math_floor_ret);
    table_clone_ret.AutoJumpHull = true;
    table_clone_ret.AutoJumpLedgeAssistHeight = table_clone_ret.HammerUnitToStud * 18;
    table_clone_ret.AutoJumpLedgeAssistLiftSpeed = table_clone_ret.HammerUnitToStud * 600;
    table_clone_ret.BunnyHopSpeedCap = 24.5;
    table_clone_ret.BunnyHopPenaltyThreshold = 19;
    table_clone_ret.BunnyHopPenaltyBase = 0.1;
    table_clone_ret.BunnyHopPenaltyScale = 0.03;
    table_clone_ret.BunnyHopMinVelocityRetain = 0.4;
    local table_freeze_ret = table.freeze(table_clone_ret);
    u2[p3] = table_freeze_ret;

    return table_freeze_ret;
end;

local function surfProfile() -- Line: 182
    -- upvalues: u1 (copy)
    local table_clone_ret = table.clone(u1.Default);
    table_clone_ret.AirAccelerate = 150;
    table_clone_ret.GroundAccelerate = 5;
    table_clone_ret.Friction = 4;
    table_clone_ret.StaminaJumpCost = 0;
    table_clone_ret.StaminaLandCost = 0;
    table_clone_ret.AutoBunnyHop = true;

    return table.freeze(table_clone_ret);
end;

u1.Competitive = u1.Default;
u1.CasualDeathmatch = casualDeathmatchProfile(DefaultSimulationHz);
local table_clone_ret = table.clone(u1.Default);
table_clone_ret.AirAccelerate = 150;
table_clone_ret.GroundAccelerate = 5;
table_clone_ret.Friction = 4;
table_clone_ret.StaminaJumpCost = 0;
table_clone_ret.StaminaLandCost = 0;
table_clone_ret.AutoBunnyHop = true;
u1.Surf = table.freeze(table_clone_ret);

function u1.resolveServerGamemode(p5: any, p6: number?) -- Line: 197
    -- upvalues: DefaultSimulationHz (copy), casualDeathmatchProfile (copy), u1 (copy)
    local v7 = p6 or DefaultSimulationHz;
    local v8;

    if type(v7) == "number" and (v7 == v7 and v7 > 0) then
        v8 = v7 < (1 / 0);
    else
        v8 = false;
    end;

    assert(v8, "MovementV2 simulation Hz must be finite and positive");

    if p5 == "Casual" or p5 == "Deathmatch" then
        return casualDeathmatchProfile(v7);
    end;

    if p5 == "Surf" then
        return u1.Surf;
    end;

    return u1.Competitive;
end;

return table.freeze(u1);