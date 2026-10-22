-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AK-47
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AK-47
-- Decompile time: 8.01 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 2700,
    Damage = 36,
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
    CrosshairDeltaDistance = 4,
    FireRate = { 0.1, 0.1 },
    Reload = {
        Full = 2.716667,
        Ammo = 1.35
    },
    EquipDelay = 1.266667,
    InspectDelay = 4.35,
    Speed = { 14.921, 14.921 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 90,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.305257,
        DuckFinal = 0.419728,
        Stand = 0.368,
        StandFinal = 0.506,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 223,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 30, 30 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0.00481, 0.00481 },
        Stand = { 0.00641, 0.00641 },
        Jump = { 0.14076, 0.14076 },
        JumpInitial = { 0.10094, 0.10094 },
        Land = { 0.000242, 0.000242 },
        Ladder = { 0.14, 0.14 },
        Fire = { 0.0078, 0.0078 },
        Move = { 0.17506, 0.17506 }
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
    Icon = 128350364872474,
    IconHorizontal = 103328569146383,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "AK-47 - A modern, compact AK variant designed for close-quarters combat. Features a folding stock, modular rails, and improved ergonomics while keeping the classic AK reliability. Chambered in 5.45mm or 7.62mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;