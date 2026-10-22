-- ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.Sawed-Off
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Heavy.Sawed-Off
-- Decompile time: 3.48 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Shotgun",
    Slot = 1,
    KillAward = 900,
    Price = 1100,
    Damage = 32,
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
        Shotgun = true,
        Start = 0.45,
        Middle = 0.6666667,
        End = 0.7166666
    },
    EquipDelay = 0.75,
    InspectDelay = 7.316667,
    Speed = { 14.574, 14.574 },
    Ammo = 7,
    ClipSize = 7,
    ReserveAmmo = 32,
    Spread = { 0.10462, 0.10462 },
    SpreadOffsets = {
        [0] = { 5.82396841, 0.11307734 },
        [1] = { 1.65720952, 0.17599906 },
        [2] = { 3.00092006, 0.25053427 },
        [3] = { 5.57971096, 0.48113653 },
        [4] = { 3.97671366, 0.62013865 },
        [5] = { 0.90204841, 0.74681538 },
        [6] = { 2.40872645, 0.77651137 },
        [7] = { 2.79779267, 0.97942436 },
        [8] = { 2.38408542, 0.08409616 },
        [9] = { 4.36722374, 0.1321153 },
        [10] = { 5.14142609, 0.2957733 },
        [11] = { 3.84705186, 0.4201135 },
        [12] = { 3.24923134, 0.52229726 },
        [13] = { 5.42632675, 0.73827785 },
        [14] = { 1.36524093, 0.77912885 },
        [15] = { 0.81290197, 0.90713042 },
        [16] = { 4.36670256, 0.08560038 },
        [17] = { 3.10539913, 0.22433169 },
        [18] = { 1.4511379, 0.28274053 },
        [19] = { 4.3969655, 0.43981257 },
        [20] = { 0.0551153, 0.59268624 },
        [21] = { 2.64720607, 0.69595104 },
        [22] = { 4.90287733, 0.83419424 },
        [23] = { 2.75655723, 0.94328529 },
        [24] = { 4.9673233, 0.12207694 },
        [25] = { 0.80700552, 0.1453018 },
        [26] = { 2.69457722, 0.27665496 },
        [27] = { 5.30867386, 0.47129163 },
        [28] = { 2.7698071, 0.50050008 },
        [29] = { 6.07170486, 0.68092358 },
        [30] = { 6.20193815, 0.77299309 },
        [31] = { 1.35296309, 0.98958892 },
        [32] = { 5.64273548, 0.12347418 },
        [33] = { 3.01267505, 0.1952533 },
        [34] = { 1.50128341, 0.37210554 },
        [35] = { 0.94016153, 0.44439977 },
        [36] = { 3.8447473, 0.55302608 },
        [37] = { 0.40334585, 0.68007243 },
        [38] = { 1.06152058, 0.83199131 },
        [39] = { 5.54949808, 0.95919222 },
        [40] = { 0.02841359, 0.08380064 },
        [41] = { 5.04516411, 0.22606045 },
        [42] = { 1.32227385, 0.27767581 },
        [43] = { 2.39030933, 0.43699422 },
        [44] = { 5.36675024, 0.52071273 },
        [45] = { 1.20732009, 0.70163625 },
        [46] = { 0.43100733, 0.86327565 },
        [47] = { 2.56785655, 0.98860526 },
        [48] = { 1.13224947, 0.0532895 },
        [49] = { 4.17428446, 0.23120731 },
        [50] = { 4.49599981, 0.30907497 },
        [51] = { 0.52215284, 0.44401562 },
        [52] = { 4.29623365, 0.52501267 },
        [53] = { 0.58109462, 0.70489502 },
        [54] = { 3.02379799, 0.83914918 },
        [55] = { 5.86923361, 0.98302251 },
        [56] = { 0.63363987, 0.10145654 },
        [57] = { 6.1118207, 0.23487855 },
        [58] = { 3.55587268, 0.36464301 },
        [59] = { 5.75829029, 0.48576283 },
        [60] = { 2.06802297, 0.56811649 },
        [61] = { 2.26967025, 0.7094143 },
        [62] = { 1.12887919, 0.7843169 },
        [63] = { 5.15884113, 0.89177513 }
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
        Seed = 1089,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 143, 143 },
        MagnitudeVariance = { 22, 22 }
    },
    Inaccuracy = {
        Duck = { 0.00525, 0.00525 },
        Stand = { 0.012, 0.012 },
        Jump = { 0.0577, 0.0577 },
        JumpInitial = { 0.05012, 0.05012 },
        Land = { 0.000108, 0.000108 },
        Ladder = { 0.036, 0.036 },
        Fire = { 0.00972, 0.00972 },
        Move = { 0.0252, 0.0252 }
    },
    Muzzle = "Heavy"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true
    },
    Icon = 128256827671663,
    IconHorizontal = 104613794906232,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Sawed-Off - A modified pump shotgun with a drastically shortened barrel and stock. Offers devastating stopping power at point-blank range while being easily concealed. Chambered in 12-gauge."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;