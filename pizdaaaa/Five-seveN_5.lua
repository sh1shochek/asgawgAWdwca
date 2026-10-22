-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Five-seveN
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Five-seveN
-- Decompile time: 6.90 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 500,
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
    Bullets = 1,
    Penetration = 1,
    ArmorRatio = 1.823,
    Range = 284.2624,
    RangeModifier = 0.81,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.15, 0.3 },
    Reload = {
        Full = 1.966667,
        Ammo = 1
    },
    EquipDelay = 0.8166667,
    InspectDelay = 7.55,
    Speed = { 16.656, 16.656 },
    Ammo = 20,
    ClipSize = 20,
    ReserveAmmo = 100,
    Spread = { 0.002, 0.002 },
    Recovery = {
        Duck = 0.2,
        DuckFinal = 0.5,
        Stand = 0.2,
        StandFinal = 0.5,
        TransitionStartBullet = 0,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 33244,
        Angle = { 0, 0 },
        AngleVariance = { 5, 5 },
        Magnitude = { 25, 25 },
        MagnitudeVariance = { 4, 4 }
    },
    Inaccuracy = {
        Duck = { 0.00683, 0.00683 },
        Stand = { 0.0091, 0.0091 },
        Jump = { 0.0897, 0.0897 },
        JumpInitial = { 0.09988, 0.09988 },
        Land = { 0.00019, 0.00019 },
        Ladder = { 0.138, 0.138 },
        Fire = { 0.025, 0.03245 },
        Move = { 0.04, 0.01341 }
    },
    Muzzle = "Pistol"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 90514877633079,
    IconHorizontal = 103047103081406,
    LoadoutCategory = "OtherPistols",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Five-seveN - A modern Belgian pistol designed to defeat body armor. Features a high-capacity magazine and very low recoil. Chambered in 5.7x28mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;