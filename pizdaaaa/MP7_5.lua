-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP7
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.MP7
-- Decompile time: 8.17 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1400,
    Damage = 30,
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
    TracerFrequency = 3,
    CrosshairMinDistance = 6,
    CrosshairDeltaDistance = 2,
    FireRate = { 0.08, 0.08 },
    Reload = {
        Full = 2.966667,
        Ammo = 1.366667
    },
    EquipDelay = 1.083333,
    InspectDelay = 4.883333,
    Speed = { 15.268, 15.268 },
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
        Move = { 0.03972, 0.03972 }
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
    Icon = 71374165722479,
    IconHorizontal = 132243524456830,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "MP7 - A modern, versatile SMG serving as a bridge between a pistol and a rifle. Offers great range and armor penetration. Chambered in 4.6x30mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;