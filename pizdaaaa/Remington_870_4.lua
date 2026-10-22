-- ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.Remington 870
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.Remington 870
-- Decompile time: 5.20 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Shotgun",
    Slot = 1,
    KillAward = 900,
    Price = 1050,
    Damage = 26,
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
    Bullets = 9,
    Penetration = 1,
    ArmorRatio = 1,
    Range = 208.2,
    RangeModifier = 0.7,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.45,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 6,
    FireRate = { 0.88, 0.88 },
    Reload = {
        Shotgun = true,
        Start = 0.45,
        Middle = 0.6666667,
        End = 0.7166666
    },
    EquipDelay = 0.75,
    InspectDelay = 7.316667,
    Speed = { 15.268, 15.268 },
    Ammo = 8,
    ClipSize = 8,
    ReserveAmmo = 32,
    Spread = { 0.0675, 0.0675 },
    SpreadOffsets = {
        [0] = { 2.11694956, 0.07245234 },
        [1] = { 4.24082279, 0.12685637 },
        [2] = { 4.3620162, 0.31400371 },
        [3] = { 3.11610675, 0.41854671 },
        [4] = { 1.0630275, 0.52645856 },
        [5] = { 3.20638943, 0.62941879 },
        [6] = { 1.72218287, 0.68182969 },
        [7] = { 4.3750968, 0.78006154 },
        [8] = { 3.40221357, 0.95989358 },
        [9] = { 4.23649549, 0.04238127 },
        [10] = { 4.62885857, 0.1543933 },
        [11] = { 0.5922479, 0.22576421 },
        [12] = { 0.18076877, 0.42949402 },
        [13] = { 3.31168985, 0.55490363 },
        [14] = { 1.23936975, 0.58816594 },
        [15] = { 2.25582194, 0.75697064 },
        [16] = { 2.83027864, 0.84784561 },
        [17] = { 5.47072029, 0.91721106 },
        [18] = { 4.51384735, 0.02301201 },
        [19] = { 4.02942753, 0.22176147 },
        [20] = { 0.89895922, 0.24076085 },
        [21] = { 1.9437573, 0.37600648 },
        [22] = { 2.12026882, 0.48730144 },
        [23] = { 3.01759768, 0.64007223 },
        [24] = { 1.5227797, 0.73352569 },
        [25] = { 5.33666563, 0.81157535 },
        [26] = { 3.80852199, 0.90834457 },
        [27] = { 5.69834709, 0.07282057 },
        [28] = { 2.27722669, 0.20728672 },
        [29] = { 5.78398514, 0.28011599 },
        [30] = { 0.60268897, 0.39365906 },
        [31] = { 3.46959186, 0.4708305 },
        [32] = { 2.85099506, 0.62207544 },
        [33] = { 2.98841548, 0.76286012 },
        [34] = { 5.1692152, 0.86785001 },
        [35] = { 2.05508018, 0.98038012 },
        [36] = { 2.39266801, 0.02623818 },
        [37] = { 1.58134341, 0.14699015 },
        [38] = { 3.75412822, 0.25932252 },
        [39] = { 1.05802536, 0.41814271 },
        [40] = { 3.1748476, 0.48242536 },
        [41] = { 2.7041223, 0.63034409 },
        [42] = { 4.54671812, 0.69044209 },
        [43] = { 1.01026022, 0.81145161 },
        [44] = { 4.27918911, 0.96792859 },
        [45] = { 1.07373822, 0.08864832 },
        [46] = { 1.18343759, 0.1481446 },
        [47] = { 3.36157417, 0.24793407 },
        [48] = { 3.83581305, 0.34778124 },
        [49] = { 4.07896996, 0.46473506 },
        [50] = { 0.9790839, 0.6651687 },
        [51] = { 2.46424437, 0.70847207 },
        [52] = { 4.56447983, 0.8644833 },
        [53] = { 3.79979515, 0.98811334 },
        [54] = { 0.36656353, 0.00554999 },
        [55] = { 5.30185795, 0.15050198 },
        [56] = { 1.36558354, 0.23306532 },
        [57] = { 0.65842694, 0.37097651 },
        [58] = { 0.99727261, 0.46246624 },
        [59] = { 0.36460882, 0.55896437 },
        [60] = { 3.18972683, 0.68186891 },
        [61] = { 0.18966699, 0.85561723 },
        [62] = { 4.74039221, 0.98127526 },
        [63] = { 6.16706085, 0.03816351 }
    },
    Recovery = {
        Duck = 0.328941,
        DuckFinal = 0.328941,
        Stand = 0.460517,
        StandFinal = 0.460517,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 7763,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 143, 143 },
        MagnitudeVariance = { 22, 22 }
    },
    Inaccuracy = {
        Duck = { 0.00525, 0.00525 },
        Stand = { 0.012, 0.012 },
        Jump = { 0.12631, 0.12631 },
        JumpInitial = { 0.1097, 0.1097 },
        Land = { 0.000236, 0.000236 },
        Ladder = { 0.07875, 0.07875 },
        Fire = { 0.00972, 0.00972 },
        Move = { 0.05512, 0.05512 }
    },
    Muzzle = "Heavy"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true,
        CT = true
    },
    Icon = 114926983801723,
    IconHorizontal = 79170135549001,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Remington 870 - A legendary pump-action shotgun renowned for its rugged reliability and versatility. Its steel receiver and smooth action make it a global standard. Chambered in 12-gauge."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;