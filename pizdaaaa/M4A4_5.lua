-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.M4A4
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.M4A4
-- Decompile time: 7.46 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 2900,
    Damage = 33,
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
    ArmorRatio = 1.4,
    Range = 568.5248,
    RangeModifier = 0.97,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = 3,
    CrosshairMinDistance = 4,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.09, 0.09 },
    Reload = {
        Full = 2.233333,
        Ammo = 1.016667
    },
    EquipDelay = 0.85,
    InspectDelay = 5.5,
    Speed = { 15.615, 15.615 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 90,
    Spread = { 0.0006, 0.00045 },
    Recovery = {
        Duck = 0.2421,
        DuckFinal = 0.332888,
        Stand = 0.338941,
        StandFinal = 0.466044,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 38965,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 23, 23 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0.0041, 0.00368 },
        Stand = { 0.0049, 0.0049 },
        Jump = { 0.09727, 0.09727 },
        JumpInitial = { 0.09441, 0.09441 },
        Land = { 0.000192, 0.000197 },
        Ladder = { 0.110994, 0.113672 },
        Fire = { 0.007, 0.00634 },
        Move = { 0.13788, 0.122 }
    },
    Muzzle = "Rifle"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 74638537684133,
    IconHorizontal = 100848375948816,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "M4A4 - The standard-issue fully automatic carbine for tactical units. Preferred for defense due to its high ammo capacity. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;