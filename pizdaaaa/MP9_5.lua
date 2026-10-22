-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP9
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP9
-- Decompile time: 7.62 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1250,
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
    ArmorRatio = 1.2,
    Range = 249.84,
    RangeModifier = 0.87,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 3,
    CrosshairMinDistance = 7,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.07, 0.07 },
    Reload = {
        Full = 2.833333,
        Ammo = 1.233333
    },
    EquipDelay = 0.95,
    InspectDelay = 4.883333,
    Speed = { 16.656, 16.656 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 120,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.184207,
        DuckFinal = 0.184207,
        Stand = 0.25789,
        StandFinal = 0.25789,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 50729,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 21, 21 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.008, 0.008 },
        Stand = { 0.01215, 0.01215 },
        Jump = { 0.05, 0.05 },
        JumpInitial = { 0.03728, 0.03728 },
        Land = { 0.000056, 0.000056 },
        Ladder = { 0.148913, 0.148913 },
        Fire = { 0.0037, 0.0037 },
        Move = { 0.05808, 0.05808 }
    },
    Muzzle = "SMG"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 127671442135412,
    IconHorizontal = 104781707426369,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "MP9 - An extremely compact and lightweight SMG. Its high rate of fire and fast reload speed are deadly in close-quarters. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;