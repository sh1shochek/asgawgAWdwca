-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AWP
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AWP
-- Decompile time: 9.00 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 100,
    Price = 4750,
    Damage = 115,
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
    ArmorRatio = 1.95,
    Range = 568.5248,
    RangeModifier = 0.99,
    FlinchVelocityModifierLarge = 0.35,
    FlinchVelocityModifierSmall = 0.4,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 1.455, 1.455 },
    Reload = {
        Full = 3.066667,
        Ammo = 1.35
    },
    EquipDelay = 1.05,
    InspectDelay = 5.6,
    Speed = { 13.88, 6.94 },
    Ammo = 5,
    ClipSize = 5,
    ReserveAmmo = 30,
    Spread = { 0.0002, 0.0002 },
    Recovery = {
        Duck = 0.24671,
        DuckFinal = 0.24671,
        Stand = 0.34539,
        StandFinal = 0.34539,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 4100,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 78, 25 },
        MagnitudeVariance = { 15, 2 }
    },
    Inaccuracy = {
        Duck = { 0.0606, 0.0015 },
        Stand = { 0.12, 0.003 },
        Jump = { 0.13383, 0.13383 },
        JumpInitial = { 0.17286, 0.17286 },
        Land = { 0.000307, 0.0001 },
        Ladder = { 0.1365, 0.1365 },
        Fire = { 0.05385, 0.05385 },
        Move = { 0.25, 0.25 }
    },
    AltFunction = {
        Name = "Scope",
        Type = "Sniper",
        ClosesAfterFire = true,
        Zoom = {
            First = 40,
            Second = 10
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
    Icon = 113148917969890,
    IconHorizontal = 128322472496551,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "AWP - A world-famous bolt-action sniper rifle known for its \'one shot, one kill\' reputation. Unmatched power over long-range sightlines. Chambered in .338 Lapua Magnum."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;