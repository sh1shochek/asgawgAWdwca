-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Desert Eagle
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Desert Eagle
-- Decompile time: 6.94 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 700,
    Damage = 53,
    HeadshotMultiplier = 3.9,
    HitboxMultipliers = {
        Head = 3.9,
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
    Penetration = 2,
    ArmorRatio = 1.864,
    Range = 284.2624,
    RangeModifier = 0.85,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.25, 0.25 },
    Reload = {
        Full = 2.233333,
        Ammo = 0.8833333
    },
    EquipDelay = 0.7333333,
    InspectDelay = 8.616667,
    Speed = { 15.962, 15.962 },
    Ammo = 7,
    ClipSize = 7,
    ReserveAmmo = 35,
    Spread = { 0.002, 0.002 },
    Recovery = {
        Duck = 0.449927,
        DuckFinal = 0.449927,
        Stand = 0.925,
        StandFinal = 0.925,
        TransitionStartBullet = 3,
        TransitionEndBullet = 10
    },
    Recoil = {
        Seed = 1454,
        Angle = { 0, 0 },
        AngleVariance = { 60, 60 },
        Magnitude = { 62, 62 },
        MagnitudeVariance = { 18, 18 }
    },
    Inaccuracy = {
        Duck = { 0.00218, 0.00218 },
        Stand = { 0.0042, 0.0042 },
        Jump = { 0.04055, 0.37155 },
        JumpInitial = { 0.54882, 0.54882 },
        Land = { 0.000043, 0.00073 },
        Ladder = { 0.152, 0.152 },
        Fire = { 0.1, 0.1 },
        Move = { 0.12, 0.12 }
    },
    Muzzle = "HeavyPistol"
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
    Icon = 93322646083875,
    IconHorizontal = 130484320728025,
    LoadoutCategory = "OtherPistols",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Desert Eagle - An iconic, large-frame semi-automatic pistol. Delivers rifle-like stopping power but requires mastery over its massive recoil. Chambered in .50 AE."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;