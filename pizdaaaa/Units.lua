-- ReplicatedStorage.Shared.FOW.Units
-- Script path: ReplicatedStorage.Shared.FOW.Units
-- Decompile time: 3.81 ms

-- Decompiled with Potassium's decompiler.

local v5 = {
    StudsPerUnit = 0.0694,
    UnitsPerStud = 14.40922190201729,

    Studs = function(p1: number) -- Line: 51, Name: Studs
        return p1 * 0.0694;
    end,

    ShoulderBase = 4.4416,
    ShoulderRttScalePerMs = 0.044416000000000004,
    VerticalOriginOffset = 1.1104,
    HorizontalBoundsPadding = 2.2208,
    TopBoundsPadding = 0.5552,
    MuzzleZ = 4.164000000000001,
    MuzzleLength = table.freeze({
        Pistol = 1.2492,
        Smg = 1.9432,
        Rifle = 2.4984,
        Sniper = 3.6088
    }),
    MaxMuzzleLength = 3.6088,
    StandingPlayerHeight = 4.9968,
    PelvisHeight = 2.6372,
    NearDepth = 0.008675,
    MaxCapsuleRadius = 2.2208,
    MaxCapsuleDistanceFromOrigin = 8.8832,
    Dimensionless = table.freeze({
        RayEpsilon = 0.00001,
        DepthEpsilon = 0.00001,
        ViewMargin = 1.02,
        OuterRadialScale = 1.06,
        GridSize = 32,
        PingStepMs = 25,
        WallClipSteps = 8,
        SamePointEpsilonSq = 0.0001,
        OccluderCacheSize = 96,
        MaxTreeDepth = 64
    }),
    CapsuleCount = 15,
    Up = Vector3.new(0, 1, 0),

    Basis = function(p2: number) -- Line: 148, Name: Basis
        local math_sin_ret = math.sin(p2);
        local math_cos_ret = math.cos(p2);

        return vector.create(-math_sin_ret, 0, -math_cos_ret), vector.create(math_cos_ret, 0, -math_sin_ret);
    end,

    ViewUpReference = Vector3.new(0, 1, 0),
    ViewUpFallback = Vector3.new(1, 0, 0),

    FeetFromCentre = function(p3: vector, p4: number) -- Line: 180, Name: FeetFromCentre
        return p3 - Vector3.new(0, 1, 0) * (p4 * 0.5);
    end
};

return table.freeze(v5);