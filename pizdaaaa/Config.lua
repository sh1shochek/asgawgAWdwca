-- ReplicatedStorage.Shared.Simulation.Config
-- Script path: ReplicatedStorage.Shared.Simulation.Config
-- Decompile time: 4.44 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
u1.CFG = {};
u1.CollisionHeightDeltaVector = Vector3.new(0, 0, 0);
u1.CollisionHeightDelta = 0;
u1.HalfStandCollisionBox = Vector3.new(0, 0, 0);
u1.HalfDuckCollisionBox = Vector3.new(0, 0, 0);
u1.StandCollisionBox = Vector3.new(0, 0, 0);
u1.DuckCollisionBox = Vector3.new(0, 0, 0);
u1.ConstantsTemplate = table.freeze({
    MaxSpeed = 20.044,
    MaxVelocity = 224.616,
    Speed = 16.044,
    StopSpeed = 5.552,
    JumpImpulse = 20.9583404332,
    Friction = 5.5,
    Acceleration = 5.72,
    AirAcceleration = 12,
    MaxAirStrafeSpeed = 2.082,
    Gravity = 58.7,
    LadderSpeed = 13.88,
    LadderJumpOffSpeed = 18.738,
    LadderIgnoreJumpTime = 0.2,
    LadderAngle = -0.707,
    LadderDampen = 0.2,
    LadderSpeedScale = 0.78,
    LadderModifier = 0.34,
    LadderRangeGrab = 0.1388,
    LadderRangeClimbing = 0.6940000000000001,
    LadderEdgeGrabDistance = 1.6656,
    LadderEdgeGrabHeightDelta = 0.4164,
    StaminaMax = 80,
    StaminaRecoveryRate = 60,
    StaminaLandCost = 0.7204610951008645,
    StaminaJumpCost = 1.1527377521613833,
    StaminaFlinchRecoveryRate = 8,
    DuckModifier = 0.34,
    WalkModifier = 0.52,
    MaxDuckSpeed = 8,
    MinDuckSpeed = 1.5,
    DuckSpeedRecoveryRate = 3,
    DuckSpeedPenalty = 2,
    DuckSpeedFastRecoveryRate = 6,
    DuckSpeedFastRecoveryDistance = 4.4416,
    DuckCooldown = 0.4,
    StandCameraOffset = 2,
    MaxGroundSlope = 0.7,
    StepSize = Vector3.new(0, 1.75, 0),
    DefuseAngle = 0.7,
    DefuseAngleMax = 0.5,
    FlinchStackRecoveryRate = 0.35,
    FlinchStackMin = 0.1,
    FlinchStackMax = 1,
    VelocityModifierRecoveryRate = 0.4,
    VelocityModifierMin = 0,
    VelocityModifierMax = 1
});

local function RefreshConfiguration() -- Line: 96
    -- upvalues: u1 (copy), u2 (ref)
    local CFG = u1.CFG;
    CFG.CameraAimPunch = u2.Get("Camera", "AimPunch");
    CFG.CameraViewPunch = u2.Get("Camera", "ViewPunch");
    CFG.ViewPunchDecay = u2.Get("Camera", "ViewPunchDecay");
    CFG.ViewPunchRollAngle = u2.Get("Camera", "ViewPunchRollAngle");
    CFG.ViewPunchRollSpeed = u2.Get("Camera", "ViewPunchRollSpeed");
    CFG.RecoilDecayExponetial = u2.Get("Weapon", "RecoilDecayExponetial");
    CFG.RecoilDecayLinear = u2.Get("Weapon", "RecoilDecayLinear");
    CFG.RecoilVelocityDecay = u2.Get("Weapon", "RecoilVelocityDecay");
    CFG.RecoilViewPunchExtra = u2.Get("Weapon", "RecoilViewPunchExtra");
    CFG.RecoilScale = u2.Get("Weapon", "RecoilScale") * (u2.Get("Weapon", "HitboxRecoilScale") or 1);
    CFG.ViewRecoilTracking = u2.Get("Weapon", "ViewRecoilTracking");
    CFG.BunnyHopMaxSpeedFactor = u2.Get("Character", "BunnyHopMaxSpeedFactor");
    CFG.ScopedAccelerationScale = u2.Get("Character", "ScopedAccelerationScale") or 1;
    CFG.FallDamage = u2.Get("Character", "FallDamage");
    CFG.EnableBunnyHop = u2.Get("Character", "EnableBunnyHop");
    CFG.AutoBunnyHop = u2.Get("Character", "AutoBunnyHop");
    CFG.TickRate = u2.Get("Game", "TickRate");
    CFG.BombCanDefuse = u2.Get("Bomb", "CanDefuse");
    CFG.PickupRange = u2.Get("Interaction", "PickupRange");
    CFG.PickupFallbackRange = u2.Get("Interaction", "PickupFallbackRange");
    CFG.PickupRewindSlack = u2.Get("Interaction", "PickupRewindSlack");
    CFG.PickupPad = u2.Get("Interaction", "PickupPad");
    CFG.GroundFrameSkip = u2.Get("Optimization", "GroundFrameSkip");
    CFG.NoGroundFrameSkipAmount = u2.Get("Optimization", "NoGroundFrameSkipAmount");
    CFG.GroundFrameSkipAmount = u2.Get("Optimization", "GroundFrameSkipAmount");
    CFG.SkipLadderFrameCheck = u2.Get("Optimization", "SkipLadderFrameCheck");
    CFG.SkipLadderFrameCheckAmount = u2.Get("Optimization", "SkipLadderFrameCheckAmount");
    CFG.LadderSkipIfGroundedAndStationary = u2.Get("Optimization", "LadderSkipIfGroundedAndStationary");
    CFG.SleepStateSkip = u2.Get("Optimization", "SleepStateSkip");
    CFG.StepDownFrameSkip = u2.Get("Optimization", "StepDownFrameSkip");
    CFG.StepDownFrameAmount = u2.Get("Optimization", "StepDownFrameAmount");
    CFG.StepDownSkipIfStepUpResult = u2.Get("Optimization", "StepDownSkipIfStepUpResult");
    CFG.StepReuseLandingNormal = u2.Get("Optimization", "StepReuseLandingNormal");
    CFG.StepUpSkipIfHeadBlocked = u2.Get("Optimization", "StepUpSkipIfHeadBlocked");
    CFG.StepUpSkipIfPositionChangeVeryLow = u2.Get("Optimization", "StepUpSkipIfPositionChangeVeryLow");
    CFG.StepUpSkipIfHeightNotChanged = u2.Get("Optimization", "StepUpSkipIfHeightNotChanged");
    CFG.StepUpSkipIfLowHorizontalVelocity = u2.Get("Optimization", "StepUpSkipIfLowHorizontalVelocity");
    CFG.StepUpProbeIterations = u2.Get("Optimization", "StepUpProbeIterations");
    CFG.ProjectVelocityEpsilonSkip = u2.Get("Optimization", "ProjectVelocityEpsilonSkip");
    CFG.UnduckHeadroomCacheSkip = u2.Get("Optimization", "UnduckHeadroomCacheSkip");
    CFG.StuckCheckMemo = u2.Get("Optimization", "StuckCheckMemo");
    CFG.HullMaxDistance = u2.Get("Optimization", "HullMaxDistance") or 0;
    CFG.LadderIgnoreJumpTicks = math.ceil(0.2 * CFG.TickRate);
    local v3 = u2.Get("Character", "StandCollisionSize");
    local v4 = u2.Get("Character", "DuckCollisionSize");
    u1.CollisionHeightDelta = v3.Y - v4.Y;
    u1.CollisionHeightDeltaVector = Vector3.new(0, 1, 0) * u1.CollisionHeightDelta;
    CFG.SolidPlayers = u2.Get("Character", "SolidPlayers");
    u1.HalfStandCollisionBox = v3 * 0.5;
    u1.HalfDuckCollisionBox = v4 * 0.5;
    u1.StandCollisionBox = v3;
    u1.DuckCollisionBox = v4;
    CFG.DefuseRange = u2.Get("Bomb", "DefuseRange");
    CFG.DefuseTime = u2.Get("Bomb", "DefuseTime");
    CFG.DefuseLockIn = u2.Get("Bomb", "DefuseLockIn");
    CFG.InterpolationDelay = u2.GetEntityTiming().InterpolationDelay;
    CFG.PredictableDamageTagTicks = u2.Get("HitTagging", "PredictableDamageTagTicks");
end;

function u1.Init(p5) -- Line: 196
    -- upvalues: u2 (ref), RefreshConfiguration (copy)
    u2 = p5:GetModule("GameConfiguration");
    RefreshConfiguration();
    u2.Updated:Connect(RefreshConfiguration);
end;

return u1;