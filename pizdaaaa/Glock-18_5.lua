-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Glock-18
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Glock-18
-- Decompile time: 6.62 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 200,
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
    Automatic = false,
    Bullets = 1,
    Penetration = 1,
    ArmorRatio = 0.94,
    Range = 284.2624,
    RangeModifier = 0.85,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = { 1, 1 },
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.15, 0.5 },
    Reload = {
        Full = 1.966667,
        Ammo = 1.033333
    },
    EquipDelay = 0.8166667,
    InspectDelay = 7.55,
    Speed = { 16.656, 16.656 },
    Ammo = 20,
    ClipSize = 20,
    ReserveAmmo = 120,
    Spread = { 0.002, 0.015 },
    Recovery = {
        Duck = 0.2,
        DuckFinal = 0.33,
        Stand = 0.2,
        StandFinal = 0.33,
        TransitionStartBullet = 0,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 4484,
        Angle = { 0, 0 },
        AngleVariance = { 20, 20 },
        Magnitude = { 18, 30 },
        MagnitudeVariance = { 0, 5 }
    },
    Inaccuracy = {
        Duck = { 0.0042, 0.003 },
        Stand = { 0.0056, 0.0056 },
        Jump = { 0.08787, 0.08787 },
        JumpInitial = { 0.09662, 0.09662 },
        Land = { 0.000185, 0.000185 },
        Ladder = { 0.137, 0.11925 },
        Fire = { 0.056, 0.045 },
        Move = { 0.01, 0.01295 }
    },
    AltFunction = {
        Name = "Burst",
        DelayBetweenSwitch = 0.3,
        DelayBetweenBursts = 0.05,
        BaseBurstAmount = 3
    },
    Muzzle = "Pistol"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true
    },
    Icon = 77342029832358,
    IconHorizontal = 132981893698378,
    LoadoutCategory = "StartingPistol",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Glock-18 - A versatile polymer-framed pistol capable of three-round burst fire. Known for its high magazine capacity and lightweight design. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;