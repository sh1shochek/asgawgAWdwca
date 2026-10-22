-- ReplicatedStorage.Shared.GameConfiguration
-- Script path: ReplicatedStorage.Shared.GameConfiguration
-- Decompile time: 11.52 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    IsRunning = false
};
local RunService = game:GetService("RunService");
local Signal = require(script.Parent.Utility.Signal);
local ValueCodec = require(script.Parent.ValueCodec);
local u2 = {
    Game = {
        TickRate = 64,
        MaxTickRate = 240,
        TimeScale = 1,
        LegSolveTicks = 3
    },
    Optimization = {
        SkipLadderFrameCheck = true,
        SkipLadderFrameCheckAmount = 2,
        LadderSkipIfGroundedAndStationary = true,
        StepUpSkipIfHeadBlocked = true,
        StepUpSkipIfHeightNotChanged = true,
        StepUpSkipIfPositionChangeVeryLow = true,
        StepUpSkipIfLowHorizontalVelocity = true,
        StepUpProbeIterations = 2,
        StepDownSkipIfStepUpResult = true,
        StepDownFrameSkip = true,
        StepDownFrameAmount = 2,
        StepReuseLandingNormal = true,
        SleepStateSkip = true,
        GroundFrameSkip = false,
        GroundFrameSkipAmount = 3,
        NoGroundFrameSkipAmount = 4,
        ProjectVelocityEpsilonSkip = true,
        UnduckHeadroomCacheSkip = true,
        HullBroadphase = true,
        StuckCheckMemo = true,
        HullMaxDistance = 8
    },
    Network = {
        CommandBackup = 4,
        CommandResend = 32,
        PingCheckTime = 64,
        PingDataAmount = 16,
        DiedServerFrameWaitMultiplier = 1,
        ReconciliationWaitMultiplier = 1,
        EntitySnapshotWaitMultiplier = 1,
        FakeCommandApply = false,
        MaxUserCmdProcessTicks = 12,
        MaxCommandQueueDepth = 0,
        IdleCommand = false,
        IdleCommandWaitMultiplier = 5,
        IdleCommandSendRate = 10
    },
    Character = {
        MaxCommandSpeedThreshold = 0.35,
        MaxTickDelta = 0.2,
        MaxCommandsPerFrame = 7,
        StandCollisionSize = Vector3.new(2, 5, 2),
        DuckCollisionSize = Vector3.new(2, 3.75, 2),
        SolidPlayers = false,
        FallDamage = true,
        AutoBunnyHop = false,
        EnableBunnyHop = false,
        BunnyHopMaxSpeedFactor = 1.1,
        ScopedAccelerationScale = 1.0875,
        MaxFallingSpeed = -120
    },
    Camera = {
        AimPunch = true,
        FlinchPunchScale = 3,
        NoArmorPunchDamageScale = 0.1,
        NoArmorPunchMinimumPitch = 4,
        HeadshotPunchScale = 0.2,
        HeadshotMinPitch = 12,
        HeadshotMaximumRoll = 9,
        HeadShotMinimumRoll = -9,
        ChestArmorPunchAngle = 0.025,
        ChestNoArmorPunchAngle = 0.1,
        ChestMinimumPitch = 4,
        ViewPunch = true,
        ViewPunchDecay = 18,
        ViewPunchRollAngle = 0,
        ViewPunchRollSpeed = 200
    },
    Weapon = {
        Spread = true,
        Recoil = true,
        RecoilViewPunchExtra = 0.055,
        ViewRecoilTracking = 0.45,
        InaccuracyMaxFallingPenalty = 2,
        AirInaccuracyScale = 1,
        AirAccuracyPenaltyScale = 1,
        AirRecoveryTimeScale = 4,
        MovementThreshold = 0.95,
        JumpSpeedThreshold = 0.25,
        MovementCurveExponent = 0.25,
        RecoilDecayBase = 2.302585092994046,
        RecoilDecayExponetial = 8,
        RecoilDecayLinear = 18,
        RecoilVelocityDecay = 4.5,
        RecoilDecayThreshold = 1,
        RecoilDecayCoefficient = 2,
        RecoilScale = 2,
        SpreadScale = 1,
        NonIdleSpreadScale = 1.4,
        HitboxRecoilScale = 1,
        KnifeRangeRightClick = 2.2208,
        KnifeRangeLeftClick = 3.3312,
        KnifeCastBoxSize = Vector3.new(0.35, 0.35, 0.35),
        KnifeRewindSlack = 8,
        InfiniteAmmo = false,
        MinimumPenetrationStartDistance = 208.2,
        MaxPenetrationDistance = 6.246,
        PenetrationLossDivisor = 0.1156,
        DistanceFallOff = 34.7,
        WarmupDrop = false,
        DropForwardMultiplierVelocity = 18,
        DropUpMultiplierVelocity = 14,
        DropOwnerMultiplierVelocity = 0.5,
        DropStartMultiplier = 5,
        DropBasicPitch = 0,
        DropHitPad = Vector3.new(0.25, 0.25, 0.25),
        DropBulletImpulse = 24,
        DropTumble = 3.5,
        PushTumble = 3
    },
    HitTagging = {
        MaxWeaponSpeed = 17.35,
        ScaleSpeedThreshold = 8.328000000000001,
        RatioSpeedThreshold = 5.5520000000000005,
        FlinchVelocityModifierLarge = 0,
        FlinchVelocityModifierSmall = 0,
        TaggingScale = 1.125,
        PredictableDamageTagTicks = 4,
        MinimumWeaponScaler = 0.15,
        WeaponScalerMultiplier = 0.8,
        WeaponScalerAddend = 0.08,
        MinimumClampRatioDivisor = 4,
        MinimumClampFloor = 0.2,
        MaximumClampFloor = 0.65
    },
    BuyZone = {
        Anywhere = false
    },
    Plants = {
        Anywhere = false
    },
    Bomb = {
        Data = {
            de_dust2 = {
                Damage = 500
            },
            de_mirage = {
                Damage = 650
            },
            de_seaside = {
                Damage = 500
            },
            de_vertigo = {
                Damage = 500
            },
            Default = {
                Damage = 650
            }
        },
        CanPickup = {
            CT = false,
            T = true
        },
        CanDefuse = {
            CT = true,
            T = false
        },
        CanPlant = {
            CT = false,
            T = true
        },
        BlowTimer = 40,
        DefuseTime = 10,
        DefuseLockIn = 0.05,
        DetonationGrace = 1,
        DefuseRange = 4.303
    },
    Particles = {
        BulletholeLifetime = 30
    },
    Entities = {},
    Team = {
        TeamLimitEnabled = true
    },
    Damage = {
        Teammate = false,
        FriendlyFireBulletScale = 0.1,
        FriendlyFireGrenadeScale = 0.25,
        FriendlyFireSelfGrenadeScale = 1,
        FriendlyFireOtherScale = 0.25,
        ArmorBonusMultiplier = 0.5,
        ArmorRatioDivisor = 0.5,
        BlastArmorRatio = 0.5,
        MinimumDamageToAssist = 25,
        HitboxMultipliers = {
            Head = 4,
            UpperTorso = 1,
            LowerTorso = 1.25,
            LeftUpperArm = 1,
            LeftLowerArm = 1,
            LeftHand = 1,
            RightUpperArm = 1,
            RightLowerArm = 1,
            RightHand = 1,
            LeftUpperLeg = 0.75,
            LeftLowerLeg = 0.75,
            LeftFoot = 0.75,
            RightUpperLeg = 0.75,
            RightLowerLeg = 0.75,
            RightFoot = 0.75
        },
        HitboxArmorApply = {
            RequireHelmet = {
                Head = true,
                UpperTorso = false,
                LowerTorso = false,
                LeftUpperArm = false,
                LeftLowerArm = false,
                LeftHand = false,
                RightUpperArm = false,
                RightLowerArm = false,
                RightHand = false,
                LeftUpperLeg = false,
                LeftLowerLeg = false,
                LeftFoot = false,
                RightUpperLeg = false,
                RightLowerLeg = false,
                RightFoot = false
            },
            ApplyArmor = {
                Head = true,
                UpperTorso = true,
                LowerTorso = true,
                LeftUpperArm = true,
                LeftLowerArm = true,
                LeftHand = true,
                RightUpperArm = true,
                RightLowerArm = true,
                RightHand = true,
                LeftUpperLeg = false,
                LeftLowerLeg = false,
                LeftFoot = false,
                RightUpperLeg = false,
                RightLowerLeg = false,
                RightFoot = false
            }
        }
    },
    Physics = {
        DroppedTickDivisor = 3,
        Gravity = 58.975,
        Restitution = 0.15,
        Friction = 10,
        GroundNormal = 0.7,
        SleepSpeed = 0.1,
        MaxSpeed = 100,
        RestRoll = 1.5707963267948966,
        RollSmooth = 12,
        RestPitch = 0,
        BombRestPitch = 1.5707963267948966,
        PredictDistance = 40,
        NormalSmooth = 8,
        AngularDamping = 2.5,
        SettleAngVel = 0.5,
        MaxFallingVelocity = -70
    },
    Ragdoll = {
        Enabled = true,
        PredictMaxPing = 200,
        Gravity = 45.64,
        MaxVelocity = 138.8,
        MaxAngularVelocity = 62.832,
        LaunchVelocityClamp = 54.132,
        TotalMass = 85,
        SolverIterations = 8,
        JointFriction = 1,
        Restitution = 0,
        SelfCollision = false,
        Friction = 24,
        AngularFriction = 6,
        SleepAfterTime = 0.1,
        MaxCount = 20,
        FadeSpeed = 2.353
    },
    LagCompensation = {
        InterpolationIntervals = 3,
        SnapshotAckEvery = 3,
        ClockResyncThreshold = 0.25,
        ClockDriftStep = 0.001,
        MaxHeadroom = 0.125,
        HeadroomDecay = 0.08,
        HeadroomAttackFraction = 0.5,
        MaxExtrapolation = 0,
        SnapshotTimeout = 0.5,
        IdleSnapshotIntervals = 1.5,
        ClientHistorySeconds = 1.25,
        ClientHistoryMinSnapshots = 32,
        MathHitboxes = true
    },
    Interaction = {
        PickupPad = 0.75,
        PickupRange = 8.8832,
        PickupFallbackRange = 5.5520000000000005,
        PickupRewindSlack = 5,
        PickupRewindFov = 120,
        DropPickupDelay = 0.1,
        DropOwnerPickupDelay = 1.5
    },
    FOW = {
        Enabled = true,
        CullDroppedWeapons = false,
        PvsOnly = false,
        Pvs = false,
        BudgetMs = 4,
        HoldMs = 1000,
        MaxResultAgeMs = 400,
        FilterTeammates = false,
        FilterTeammateCosmetics = false,
        ReuseEpsilon = 0.01,
        HiddenRefreshTicks = 1,
        Workers = 1,
        WorkerBudgetMs = 8,
        WorkerTimeoutMs = 250,
        MaxPairsPerJob = 96,
        ShoulderBase = 0,
        ShoulderRttScalePerMs = 0.044416,
        ShoulderCap = 0,
        TargetLeadMs = 50
    }
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
u1.Updated = Signal.new();
local buffer_create_ret = buffer.create(4);

local function Quantize(p6: number) -- Line: 782
    -- upvalues: buffer_create_ret (copy)
    if p6 % 1 == 0 then
        return p6;
    end;

    buffer.writef32(buffer_create_ret, 0, p6);

    return buffer.readf32(buffer_create_ret, 0);
end;

local function Coerce(p7: any, p8: string) -- Line: 793
    -- upvalues: ValueCodec (copy)
    local v9 = typeof(p7);

    if v9 == "number" then
        return tonumber(p8);
    end;

    if v9 == "boolean" then
        if p8 == "1" or p8 == "true" then
            return true;
        end;

        if p8 == "0" or p8 == "false" then
            return false;
        end;

        return nil;
    end;

    if v9 == "string" then
        return p8;
    end;

    if v9 ~= "Vector3" then
        if v9 ~= "table" then
            return nil;
        end;

        local v10 = ValueCodec.Decode(p8);

        if typeof(v10) == "table" then
            return v10;
        end;

        return nil;
    end;

    local v11, v12, v13 = p8:match("^(-?[%d%.]+),(-?[%d%.]+),(-?[%d%.]+)$");

    if not v11 then
        return nil;
    end;

    local v14 = tonumber(v11);
    local v15 = tonumber(v12);
    local v16 = tonumber(v13);

    return vector.create(v14, v15, v16);
end;

local u17 = {};

local function NormalizeType(p18: string) -- Line: 837
    return p18 == "Vector3" and "Vector3" or p18;
end;

function u1.GetEntityTiming(p19: number?) -- Line: 848
    -- upvalues: u2 (copy)
    local LagCompensation = u2.LagCompensation;
    local math_max_ret = math.max(u2.Game.TickRate, 1);
    local math_max_ret2 = math.max(u2.Network.EntitySnapshotWaitMultiplier, 1);
    local v20 = math_max_ret2 / math_max_ret;
    local math_min_ret = math.min(LagCompensation.InterpolationIntervals, p19 or (1 / 0));
    local math_max_ret3 = math.max(math_min_ret, 0);
    local v21 = v20 * (math_max_ret3 - 1) + 1 / math_max_ret;
    local math_max_ret4 = math.max(LagCompensation.MaxHeadroom, 0);
    local v22 = {
        TickRate = math_max_ret,
        SnapshotWaitMultiplier = math_max_ret2,
        SnapshotInterval = v20,
        InterpolationDelay = v20 * math_max_ret3 + 1 / math_max_ret,
        MarginFloor = v21,
        HeadroomAttackMargin = v21 * math.clamp(LagCompensation.HeadroomAttackFraction, 0, 1),
        MaxHeadroom = math_max_ret4,
        MaxRenderBuffer = v21 > 0 and math_max_ret4 and math_max_ret4 or 0,
        HeadroomDecay = math.max(LagCompensation.HeadroomDecay, 0)
    };
    local math_floor_ret = math.floor(LagCompensation.SnapshotAckEvery);
    v22.SnapshotAckEvery = math.max(math_floor_ret, 1);
    v22.ClockResyncThreshold = math.max(LagCompensation.ClockResyncThreshold, 0);
    v22.ClockDriftStep = math.max(LagCompensation.ClockDriftStep, 0);
    v22.MaxExtrapolation = math.max(LagCompensation.MaxExtrapolation, 0);
    v22.SnapshotTimeout = math.max(LagCompensation.SnapshotTimeout, 0);
    v22.IdleSnapshotIntervals = math.max(LagCompensation.IdleSnapshotIntervals, 0);
    v22.ClientHistorySeconds = math.max(LagCompensation.ClientHistorySeconds, 0);
    local math_floor_ret2 = math.floor(LagCompensation.ClientHistoryMinSnapshots);
    v22.ClientHistoryMinSnapshots = math.max(math_floor_ret2, 1);

    return v22;
end;

function u1.Get(p23: string, p24: string) -- Line: 877
    -- upvalues: u2 (copy)
    local v25 = u2[p23];

    if not v25 then
        return;
    end;

    local v26 = v25[p24];

    if v26 ~= nil then
        return v26;
    end;
end;

function u1.Set(p27: string, p28: string, p29: any) -- Line: 894
    -- upvalues: u2 (copy), Coerce (copy), buffer_create_ret (copy), u17 (copy), RunService (copy), u3 (ref), u1 (copy)
    local v30 = u2[p27];

    if not v30 then
        return false, `unknown category: {p27}`;
    end;

    local v31 = v30[p28];

    if v31 == nil then
        return false, `unknown value: {p27}.{p28}`;
    end;

    if typeof(p29) == "string" and typeof(v31) ~= "string" then
        p29 = Coerce(v31, p29);
    end;

    if p29 ~= nil then
        local v32 = typeof(p29);
        local v33 = typeof(v31);

        if (v32 == "Vector3" and "Vector3" or v32) == (v33 == "Vector3" and "Vector3" or v33) then
            if typeof(p29) == "number" and p29 % 1 ~= 0 then
                buffer.writef32(buffer_create_ret, 0, p29);
                p29 = buffer.readf32(buffer_create_ret, 0);
            end;

            v30[p28] = p29;
            local v34 = u17[p27];

            if not v34 then
                v34 = {};
                u17[p27] = v34;
            end;

            v34[p28] = p29;

            if RunService:IsServer() and u3 then
                u3.ConfigChanged.FireAll({
                    {
                        Category = p27,
                        Key = p28,
                        Value = p29
                    }
                });
            end;

            u1.Updated:FastFire();

            return true;
        end;
    end;

    return false, `{p27}.{p28} expects {typeof(v31)}`;
end;

function u1.GetOverrides() -- Line: 969
    -- upvalues: u17 (copy)
    local v35 = {};

    for i, v in u17 do
        local v36 = i;

        for i2, v2 in v do
            table.insert(v35, {
                Category = v36,
                Key = i2,
                Value = v2
            });
        end;
    end;

    return v35;
end;

u1.Coerce = Coerce;

function u1.GetConfig() -- Line: 987
    -- upvalues: u2 (copy)
    return u2;
end;

function u1.Init(p37) -- Line: 993
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u2 (copy), buffer_create_ret (copy)
    u3 = p37:GetModule("Network");
    u4 = p37:GetModule("Table");
    u5 = p37:GetModule("Tick");

    for i, v in u2 do
        if typeof(v) == "table" then
            local v38 = i;

            for i2, v2 in v do
                if typeof(v2) == "number" then
                    local v39 = u2[v38];
                    local v40;

                    if v2 % 1 == 0 then
                        v40 = v2;
                    else
                        buffer.writef32(buffer_create_ret, 0, v2);
                        v40 = buffer.readf32(buffer_create_ret, 0);
                    end;

                    v39[i2] = v40;
                end;
            end;
        end;
    end;
end;

function u1.Start(p41) -- Line: 1013
    -- upvalues: RunService (copy), u3 (ref), u1 (copy), u5 (ref)
    if RunService:IsClient() then
        u3.Player.StartGameRunning.On(function() -- Line: 1015
            -- upvalues: u1 (ref), u5 (ref)
            print(("Starting the game: %s"):format(DateTime.now():FormatLocalTime("LTS", "en-us")));
            u1.IsRunning = true;
            u5:EventStart();
        end);
        u3.ConfigChanged.On(function(p42) -- Line: 1024
            -- upvalues: u1 (ref)
            for _, v in p42 do
                local v43, v44 = u1.Set(v.Category, v.Key, v.Value);

                if not v43 then
                    warn((`[GameConfiguration] dropped {v.Category}.{v.Key}: {v44}`));
                end;
            end;
        end);
    end;
end;

return u1;