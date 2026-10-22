-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.UMP-45
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.UMP-45
-- Decompile time: 5.76 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1200,
    Damage = 35,
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
    ArmorRatio = 1.3,
    Range = 256.78,
    RangeModifier = 0.75,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 3,
    CrosshairMinDistance = 6,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.09, 0.09 },
    Reload = {
        Full = 4,
        Ammo = 2.35
    },
    EquipDelay = 1.033333,
    InspectDelay = 6.066667,
    Speed = { 15.962, 15.962 },
    Ammo = 25,
    ClipSize = 25,
    ReserveAmmo = 100,
    Spread = { 0.001, 0.001 },
    Recovery = {
        Duck = 0.249995,
        DuckFinal = 0.249995,
        Stand = 0.349993,
        StandFinal = 0.349993,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 59299,
        Angle = { 0, 0 },
        AngleVariance = { 40, 40 },
        Magnitude = { 23, 23 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.01007, 0.01007 },
        Stand = { 0.01813, 0.01813 },
        Jump = { 0.03725, 0.03725 },
        JumpInitial = { 0.04721, 0.04721 },
        Land = { 0.000085, 0.000085 },
        Ladder = { 0.04235, 0.04235 },
        Fire = { 0.00342, 0.00342 },
        Move = { 0.05752, 0.05752 }
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
    Icon = 75319793188834,
    IconHorizontal = 97747164267995,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "UMP-45 - A slower-firing, hard-hitting SMG. Functions like a compact rifle, offering strong mid-range damage. Chambered in .45 ACP."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;