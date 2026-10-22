-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MAC-10
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MAC-10
-- Decompile time: 8.66 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1050,
    Damage = 29,
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
    ArmorRatio = 1.15,
    Range = 249.84,
    RangeModifier = 0.8,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 3,
    CrosshairMinDistance = 9,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.075, 0.075 },
    Reload = {
        Full = 2.533333,
        Ammo = 0.9666666
    },
    EquipDelay = 1.233333,
    InspectDelay = 6.6,
    Speed = { 16.656, 16.656 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 100,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.285521,
        DuckFinal = 0.285521,
        Stand = 0.399729,
        StandFinal = 0.399729,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 34079,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 18, 18 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.00998, 0.00998 },
        Stand = { 0.01795, 0.01795 },
        Jump = { 0.0333, 0.0333 },
        JumpInitial = { 0.03499, 0.03499 },
        Land = { 0.000069, 0.000069 },
        Ladder = { 0.03426, 0.03426 },
        Fire = { 0.00476, 0.00476 },
        Move = { 0.02798, 0.02798 }
    },
    Muzzle = "SMG"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true
    },
    Icon = 132624796970784,
    IconHorizontal = 72879107579572,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "MAC-10 - A boxy, compact machine pistol with a frantic rate of fire. Highly effective for run-and-gun tactics at close range. Chambered in .45 ACP."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;