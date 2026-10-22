-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SSG-08
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SSG-08
-- Decompile time: 4.21 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SniperRifle",
    Slot = 1,
    KillAward = 300,
    Price = 1700,
    Damage = 88,
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
    Bullets = 1,
    Penetration = 2.5,
    ArmorRatio = 1.7,
    Range = 568.5248,
    RangeModifier = 0.98,
    FlinchVelocityModifierLarge = 0.35,
    FlinchVelocityModifierSmall = 0.4,
    TracerFrequency = 1,
    CrosshairMinDistance = 5,
    CrosshairDeltaDistance = 3,
    FireRate = { 1.25, 1.25 },
    Reload = {
        Full = 3.066667,
        Ammo = 1.333333
    },
    EquipDelay = 1.05,
    InspectDelay = 7.416667,
    Speed = { 15.962, 15.962 },
    Ammo = 10,
    ClipSize = 10,
    ReserveAmmo = 90,
    Spread = { 0.00028, 0.00023 },
    Recovery = {
        Duck = 0.055783,
        DuckFinal = 0.055783,
        Stand = 0.142096,
        StandFinal = 0.142096,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 1278,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 33, 25 },
        MagnitudeVariance = { 15, 2 }
    },
    Inaccuracy = {
        Duck = { 0.02378, 0.0028 },
        Stand = { 0.05, 0.0045 },
        Jump = { 0.00572, 0.00572 },
        JumpInitial = { 0.20872, 0.20872 },
        Land = { 0.000215, 0.000215 },
        Ladder = { 0.09549, 0.09549 },
        Fire = { 0.02292, 0.02292 },
        Move = { 0.18, 0.18 }
    },
    AltFunction = {
        Name = "Scope",
        Type = "Sniper",
        ClosesAfterFire = true,
        Zoom = {
            First = 40,
            Second = 15
        },
        DelayBetweenSwitch = 0.225
    },
    Muzzle = "Sniper"
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
    Icon = 77084621490263,
    IconHorizontal = 96142540919110,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "SSG-08 - A lightweight, bolt-action sniper rifle. Offers high mobility and quick handling, making it excellent for agile scouting. Chambered in 7.62mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;