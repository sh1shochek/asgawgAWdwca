-- ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.MAG-7
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.MAG-7
-- Decompile time: 4.51 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Shotgun",
    Slot = 1,
    KillAward = 900,
    Price = 1300,
    Damage = 30,
    HeadshotMultiplier = 4,
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
    Automatic = false,
    Bullets = 8,
    Penetration = 1,
    ArmorRatio = 1.5,
    Range = 97.16,
    RangeModifier = 0.45,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.45,
    TracerFrequency = 1,
    CrosshairMinDistance = 9,
    CrosshairDeltaDistance = 4,
    FireRate = { 0.85, 0.85 },
    Reload = {
        Full = 2.533333,
        Ammo = 1.316667
    },
    EquipDelay = 0.7,
    InspectDelay = 7.783333,
    Speed = { 15.615, 15.615 },
    Ammo = 5,
    ClipSize = 5,
    ReserveAmmo = 32,
    Spread = { 0.0675, 0.0675 },
    SpreadOffsets = {
        [0] = { 0.40777177, 0.09660275 },
        [1] = { 0.98282862, 0.1420861 },
        [2] = { 2.06741548, 0.26497918 },
        [3] = { 1.03733039, 0.44404027 },
        [4] = { 1.34897327, 0.56998676 },
        [5] = { 6.20899773, 0.68671179 },
        [6] = { 4.08165932, 0.80739373 },
        [7] = { 0.63069803, 0.91516143 },
        [8] = { 3.38452411, 0.05971572 },
        [9] = { 3.58481884, 0.1602027 },
        [10] = { 0.26156715, 0.35244563 },
        [11] = { 3.68448544, 0.48088133 },
        [12] = { 3.3307898, 0.5489502 },
        [13] = { 4.74795198, 0.73286098 },
        [14] = { 1.47392714, 0.75747871 },
        [15] = { 0.94194674, 0.98467559 },
        [16] = { 6.09496641, 0.01706559 },
        [17] = { 1.64010143, 0.20880482 },
        [18] = { 3.27017951, 0.3291215 },
        [19] = { 0.58566666, 0.3784053 },
        [20] = { 2.69357347, 0.51071745 },
        [21] = { 0.27732548, 0.70576441 },
        [22] = { 0.12936631, 0.85283065 },
        [23] = { 3.95480967, 0.94764119 },
        [24] = { 4.95089531, 0.08658711 },
        [25] = { 0.15197498, 0.13061045 },
        [26] = { 3.22872853, 0.25146532 },
        [27] = { 2.56952286, 0.39941046 },
        [28] = { 3.48178196, 0.53662604 },
        [29] = { 2.40349507, 0.66991645 },
        [30] = { 2.37395024, 0.81105798 },
        [31] = { 3.69276762, 0.90076441 },
        [32] = { 3.16825199, 0.0666886 },
        [33] = { 5.09546995, 0.14781728 },
        [34] = { 5.92130089, 0.31548125 },
        [35] = { 6.22895193, 0.49236485 },
        [36] = { 3.33102942, 0.5284484 },
        [37] = { 1.58608508, 0.63498968 },
        [38] = { 0.83199358, 0.8009392 },
        [39] = { 4.50051498, 0.98999232 },
        [40] = { 2.17687869, 0.07669531 },
        [41] = { 5.85860491, 0.14785026 },
        [42] = { 3.26160765, 0.29446447 },
        [43] = { 2.23250556, 0.46303418 },
        [44] = { 5.4342556, 0.56028926 },
        [45] = { 4.79082727, 0.66102278 },
        [46] = { 6.02728558, 0.85975599 },
        [47] = { 0.84972316, 0.9504025 },
        [48] = { 4.8212409, 0.08474021 },
        [49] = { 1.08377635, 0.20669658 },
        [50] = { 3.48280191, 0.36617523 },
        [51] = { 2.63658786, 0.41487077 },
        [52] = { 1.3990314, 0.56410998 },
        [53] = { 3.74393082, 0.71804196 },
        [54] = { 6.18898582, 0.75719106 },
        [55] = { 1.63501644, 0.99634552 },
        [56] = { 1.92566752, 0.10368526 },
        [57] = { 2.25709963, 0.21540415 },
        [58] = { 5.43729258, 0.27212259 },
        [59] = { 3.79207897, 0.39539972 },
        [60] = { 1.17277288, 0.57989144 },
        [61] = { 3.12073755, 0.68947965 },
        [62] = { 0.63746393, 0.75959587 },
        [63] = { 3.99848032, 0.94265318 }
    },
    Recovery = {
        Duck = 0.285521,
        DuckFinal = 0.285521,
        Stand = 0.399729,
        StandFinal = 0.399729,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 12518,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 165, 165 },
        MagnitudeVariance = { 25, 25 }
    },
    Inaccuracy = {
        Duck = { 0.00525, 0.00525 },
        Stand = { 0.012, 0.012 },
        Jump = { 0.05009, 0.05009 },
        JumpInitial = { 0.05264, 0.05264 },
        Land = { 0.000103, 0.000103 },
        Ladder = { 0.13426, 0.13426 },
        Fire = { 0.01119, 0.01119 },
        Move = { 0.02398, 0.02398 }
    },
    Muzzle = "Heavy"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 75465423836610,
    IconHorizontal = 92644632368344,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "MAG-7 - A compact, pump-action shotgun designed for high-maneuverability in confined spaces. Features a unique vertical magazine feed in the pistol grip for rapid reloading. Chambered in 12-gauge."
};
v1.Assets = {
    Viewmodel = script:WaitForChild("Viewmodel"),
    CharacterModel = script:WaitForChild("CharacterModel"),
    InspectModel = script:WaitForChild("InspectModel")
};

return v1;