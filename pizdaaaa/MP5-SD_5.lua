-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP5-SD
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP5-SD
-- Decompile time: 12.20 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1400,
    Damage = 28,
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
    ArmorRatio = 1.25,
    Range = 249.84,
    RangeModifier = 0.87,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 0,
    CrosshairMinDistance = 6,
    CrosshairDeltaDistance = 2,
    FireRate = { 0.08, 0.08 },
    Reload = {
        Full = 3.6,
        Ammo = 2.033333
    },
    EquipDelay = 1.483333,
    InspectDelay = 4.166667,
    Speed = { 16.309, 15.268 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 120,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.312494,
        DuckFinal = 0.312494,
        Stand = 0.437491,
        StandFinal = 0.437491,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 61649,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 16, 16 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.0085, 0.0085 },
        Stand = { 0.0135, 0.0135 },
        Jump = { 0.0596, 0.0596 },
        JumpInitial = { 0.05541, 0.05541 },
        Land = { 0.000115, 0.000115 },
        Ladder = { 0.05756, 0.05756 },
        Fire = { 0.00218, 0.00218 },
        Move = { 0.06, 0.03972 }
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
    Icon = 127472581793398,
    IconHorizontal = 126901112931486,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "MP5-SD - An iconic submachine gun featuring an integrated suppressor. Allows for high-mobility play while staying off the radar. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;