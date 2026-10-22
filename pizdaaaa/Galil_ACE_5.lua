-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.Galil ACE
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.Galil ACE
-- Decompile time: 6.91 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 1800,
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
    Automatic = true,
    Bullets = 1,
    Penetration = 2,
    ArmorRatio = 1.55,
    Range = 568.5248,
    RangeModifier = 0.98,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = 3,
    CrosshairMinDistance = 4,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.09, 0.09 },
    Reload = {
        Full = 3.483333,
        Ammo = 1.933333
    },
    EquipDelay = 1.5,
    InspectDelay = 4.5,
    Speed = { 14.921, 14.921 },
    Ammo = 35,
    ClipSize = 35,
    ReserveAmmo = 90,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.15,
        DuckFinal = 0.47,
        Stand = 0.3,
        StandFinal = 0.5,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 51191,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 21, 21 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.00658, 0.00484 },
        Stand = { 0.00877, 0.00778 },
        Jump = { 0.14978, 0.14978 },
        JumpInitial = { 0.10539, 0.10539 },
        Land = { 0.000256, 0.000256 },
        Ladder = { 0.11358, 0.11358 },
        Fire = { 0.007, 0.00585 },
        Move = { 0.12356, 0.10652 }
    },
    Muzzle = "Rifle"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true
    },
    Icon = 110981843310946,
    IconHorizontal = 84027416531227,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Galil ACE - A modernized Galil featuring updated ergonomics and rail systems. A cost-effective alternative to other assault rifles. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;