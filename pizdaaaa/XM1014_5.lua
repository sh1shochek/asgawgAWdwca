-- ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.XM1014
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.XM1014
-- Decompile time: 5.02 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Shotgun",
    Slot = 1,
    KillAward = 600,
    Price = 2000,
    Damage = 20,
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
    Automatic = true,
    Bullets = 6,
    Penetration = 1,
    ArmorRatio = 1.6,
    Range = 208.2,
    RangeModifier = 0.7,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.45,
    TracerFrequency = 1,
    CrosshairMinDistance = 9,
    CrosshairDeltaDistance = 4,
    FireRate = { 0.35, 0.35 },
    Reload = {
        Shotgun = true,
        Start = 0.5,
        Middle = 0.8666667,
        End = 0.9333333
    },
    EquipDelay = 0.9166667,
    InspectDelay = 6.433333,
    Speed = { 14.921, 14.921 },
    Ammo = 7,
    ClipSize = 7,
    ReserveAmmo = 32,
    Spread = { 0.06413, 0.06413 },
    SpreadOffsets = {
        [0] = { 1.0928899, 0.14298435 },
        [1] = { 1.63161349, 0.28292516 },
        [2] = { 4.83743906, 0.48693991 },
        [3] = { 2.77586865, 0.50471175 },
        [4] = { 3.72224307, 0.78194523 },
        [5] = { 5.50289249, 0.86976916 },
        [6] = { 5.25468922, 0.07177775 },
        [7] = { 0.89359212, 0.30440572 },
        [8] = { 2.66759157, 0.43102476 },
        [9] = { 5.60026169, 0.51430738 },
        [10] = { 4.64350271, 0.83240885 },
        [11] = { 5.60231495, 0.98242319 },
        [12] = { 3.70323586, 0.05213001 },
        [13] = { 2.21594715, 0.29232219 },
        [14] = { 4.90960121, 0.36861548 },
        [15] = { 4.94423723, 0.57080257 },
        [16] = { 2.81403589, 0.76989233 },
        [17] = { 4.65105057, 0.83739513 },
        [18] = { 3.02136135, 0.07315432 },
        [19] = { 3.42908931, 0.23165134 },
        [20] = { 1.78949618, 0.41248387 },
        [21] = { 2.79537582, 0.56638765 },
        [22] = { 1.88388491, 0.70596647 },
        [23] = { 4.639709, 0.96412468 },
        [24] = { 6.22465801, 0.09885355 },
        [25] = { 4.39424086, 0.20600629 },
        [26] = { 3.2836051, 0.36384085 },
        [27] = { 5.77651119, 0.62930745 },
        [28] = { 3.18605208, 0.79851961 },
        [29] = { 3.57771277, 0.98613149 },
        [30] = { 5.32185745, 0.11468606 },
        [31] = { 2.97417712, 0.17759918 },
        [32] = { 3.26814795, 0.47251552 },
        [33] = { 2.04845524, 0.53840095 },
        [34] = { 4.25500727, 0.7914356 },
        [35] = { 2.33224773, 0.90417194 },
        [36] = { 2.78944945, 0.07598107 },
        [37] = { 1.10941839, 0.21839955 },
        [38] = { 1.17107284, 0.41854233 },
        [39] = { 5.72271061, 0.57888925 },
        [40] = { 0.23291333, 0.8307808 },
        [41] = { 0.53419107, 0.837309 },
        [42] = { 1.62189889, 0.02866738 },
        [43] = { 1.03875804, 0.29758674 },
        [44] = { 2.57245469, 0.43859878 },
        [45] = { 5.9212079, 0.62128323 },
        [46] = { 0.69374686, 0.81329942 },
        [47] = { 5.3327632, 0.89185852 },
        [48] = { 4.49420738, 0.13255426 },
        [49] = { 4.48053217, 0.22628701 },
        [50] = { 4.2488637, 0.38429534 },
        [51] = { 4.04579496, 0.57450926 },
        [52] = { 3.78311205, 0.75490159 },
        [53] = { 3.7173605, 0.85046387 },
        [54] = { 3.407233, 0.11000674 },
        [55] = { 2.68064952, 0.17526871 },
        [56] = { 4.70240307, 0.38560861 },
        [57] = { 3.03894281, 0.50013632 },
        [58] = { 3.7475872, 0.79348081 },
        [59] = { 3.30919981, 0.86519212 },
        [60] = { 5.47717571, 0.14635447 },
        [61] = { 0.41454673, 0.20769717 },
        [62] = { 5.77935886, 0.43849787 },
        [63] = { 1.95419919, 0.58580071 }
    },
    Recovery = {
        Duck = 0.361835,
        DuckFinal = 0.361835,
        Stand = 0.506569,
        StandFinal = 0.506569,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 24862,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 80, 80 },
        MagnitudeVariance = { 20, 20 }
    },
    Inaccuracy = {
        Duck = { 0.00525, 0.00525 },
        Stand = { 0.012, 0.012 },
        Jump = { 0.13083, 0.13083 },
        JumpInitial = { 0.10038, 0.10038 },
        Land = { 0.000232, 0.000232 },
        Ladder = { 0.07721, 0.07721 },
        Fire = { 0.00883, 0.00883 },
        Move = { 0.05404, 0.05404 }
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
    Icon = 115303862329731,
    IconHorizontal = 78511979539734,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "XM1014 - A military-grade semi-automatic shotgun built for sustained close-quarters engagements. Delivers a rapid rate of fire for devastating follow-up shots without the need to pump. Chambered in 12-gauge."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;