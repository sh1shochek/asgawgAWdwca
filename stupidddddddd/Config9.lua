-- ReplicatedStorage.MovementV2.Simulation.Config
-- Script path: ReplicatedStorage.MovementV2.Simulation.Config
-- Decompile time: 1.30 ms

local SpeedProfile = require(script.Parent.Parent.SpeedProfile)
local Config = require(script.Parent.Parent.Config)
local u12 = {}
local HammerUnitToStud = SpeedProfile.HammerUnitToStud
u12.Default = table.freeze({
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
    PlaneEpsilon = 1e-05,
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
    LadderDampenAngle = -0.707,
})
local DefaultSimulationHz = Config.DefaultSimulationHz
local u95 = {}

local function casualDeathmatchProfile(a1) -- Line: 158 -- upvalues: u95 (val), u12 (val) -- types: a1: number
    local v1 = u95[a1]
    if v1 ~= nil then
        return v1
    end
    local v2 = table.clone(u12.Default)
    v2.BunnyHopInputBufferTicks = math.max(1, (math.floor(a1 * 0.1 + 0.5)))
    v2.AutoJumpHull = true
    v2.AutoJumpLedgeAssistHeight = v2.HammerUnitToStud * 18
    v2.AutoJumpLedgeAssistLiftSpeed = v2.HammerUnitToStud * 600
    v2.BunnyHopSpeedCap = 24.5
    v2.BunnyHopPenaltyThreshold = 19
    v2.BunnyHopPenaltyBase = 0.1
    v2.BunnyHopPenaltyScale = 0.03
    v2.BunnyHopMinVelocityRetain = 0.4
    local v3 = table.freeze(v2)
    u95[a1] = v3
    return v3
end

local function surfProfile() -- Line: 182 -- upvalues: u12 (val)
    local v1 = table.clone(u12.Default)
    v1.AirAccelerate = 150
    v1.GroundAccelerate = 5
    v1.Friction = 4
    v1.StaminaJumpCost = 0
    v1.StaminaLandCost = 0
    v1.AutoBunnyHop = true
    return table.freeze(v1)
end

u12.Competitive = u12.Default
u12.CasualDeathmatch = casualDeathmatchProfile(DefaultSimulationHz)
local v1 = table.clone(u12.Default)
v1.AirAccelerate = 150
v1.GroundAccelerate = 5
v1.Friction = 4
v1.StaminaJumpCost = 0
v1.StaminaLandCost = 0
v1.AutoBunnyHop = true
u12.Surf = table.freeze(v1)

function u12.resolveServerGamemode(a1, a2) -- Line: 197
    -- upvalues: DefaultSimulationHz (val), casualDeathmatchProfile (val), u12 (val)
    local v1 = a2 or DefaultSimulationHz
    local v2 = false
    if type(v1) == "number" then
        v2 = false
        if v1 == v1 then
            v2 = false
            if v1 > 0 then
                v2 = v1 < (1 / 0)
            end
        end
    end
    assert(v2, "MovementV2 simulation Hz must be finite and positive")
    if a1 ~= "Casual" and a1 ~= "Deathmatch" then
        if a1 == "Surf" then
            return u12.Surf
        end
        return u12.Competitive
    end
    return (casualDeathmatchProfile(v1))
end

return table.freeze(u12)