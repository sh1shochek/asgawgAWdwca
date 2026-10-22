-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.Famas F1
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.Famas F1
-- Decompile time: 11.32 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 1950,
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
    Penetration = 2,
    ArmorRatio = 1.4,
    Range = 568.5248,
    RangeModifier = 0.96,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = { 3, 3 },
    CrosshairMinDistance = 4,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.09, 0.55 },
    Reload = {
        Full = 3.4,
        Ammo = 1.85
    },
    EquipDelay = 0.85,
    InspectDelay = 5.733333,
    Speed = { 15.268, 15.268 },
    Ammo = 25,
    ClipSize = 25,
    ReserveAmmo = 90,
    Spread = { 0.0006, 0.0006 },
    Recovery = {
        Duck = 0.12,
        DuckFinal = 0.48,
        Stand = 0.25,
        StandFinal = 0.5,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 39623,
        Angle = { 0, 0 },
        AngleVariance = { 60, 50 },
        Magnitude = { 20, 20 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.0055, 0.00325 },
        Stand = { 0.00759, 0.00369 },
        Jump = { 0.11039, 0.11039 },
        JumpInitial = { 0.09477, 0.09477 },
        Land = { 0.000205, 0.000205 },
        Ladder = { 0.118716, 0.118716 },
        Fire = { 0.00605, 0.00335 },
        Move = { 0.09934, 0.09934 }
    },
    AltFunction = {
        Name = "Burst",
        DelayBetweenSwitch = 0.3,
        DelayBetweenBursts = 0.075,
        BaseBurstAmount = 3
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
    Icon = 139630548706956,
    IconHorizontal = 124612650211720,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Famas F1 - A French bullpup rifle recognized by its large carrying handle. Offers a specialized burst-fire mode for tight groupings. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;