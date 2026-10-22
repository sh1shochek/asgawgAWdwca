-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.P90
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.P90
-- Decompile time: 5.87 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 300,
    Price = 2350,
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
    Automatic = true,
    Bullets = 1,
    Penetration = 1,
    ArmorRatio = 1.38,
    Range = 256.78,
    RangeModifier = 0.86,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 3,
    CrosshairMinDistance = 7,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.07, 0.07 },
    Reload = {
        Full = 3.033333,
        Ammo = 1.666667
    },
    EquipDelay = 1,
    InspectDelay = 3.745763,
    Speed = { 15.962, 15.962 },
    Ammo = 50,
    ClipSize = 50,
    ReserveAmmo = 100,
    Spread = { 0.001, 0.001 },
    Recovery = {
        Duck = 0.265784,
        DuckFinal = 0.265784,
        Stand = 0.372098,
        StandFinal = 0.372098,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 6213,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 16, 16 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.01024, 0.01024 },
        Stand = { 0.01843, 0.01843 },
        Jump = { 0.09008, 0.09008 },
        JumpInitial = { 0.1046, 0.1046 },
        Land = { 0.000082, 0.000082 },
        Ladder = { 0.13217, 0.13217 },
        Fire = { 0.00285, 0.00285 },
        Move = { 0.062, 0.062 }
    },
    Muzzle = "SMG"
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
    Icon = 128956823727103,
    IconHorizontal = 112640762739116,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "P90 - Identified by its unique top-mounted horizontal magazine. Carries massive ammunition for high-volume fire on the move. Chambered in 5.7x28mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;