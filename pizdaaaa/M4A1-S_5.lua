-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.M4A1-S
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.M4A1-S
-- Decompile time: 7.00 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 2900,
    Damage = 38,
    HeadshotMultiplier = 3.475,
    HitboxMultipliers = {
        Head = 3.475,
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
    RangeModifier = 0.94,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.4,
    TracerFrequency = { 0, 3 },
    CrosshairMinDistance = 4,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.1, 0.1 },
    Reload = {
        Full = 2.233333,
        Ammo = 1.016667
    },
    EquipDelay = 0.85,
    InspectDelay = 5.5,
    Speed = { 15.615, 15.615 },
    Ammo = 20,
    ClipSize = 20,
    ReserveAmmo = 80,
    Spread = { 0.0005, 0.0006 },
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
        AngleVariance = { 65, 65 },
        Magnitude = { 21, 25 },
        MagnitudeVariance = { 0, 3 }
    },
    Inaccuracy = {
        Duck = { 0.0041, 0.0041 },
        Stand = { 0.0049, 0.0049 },
        Jump = { 0.0997, 0.0997 },
        JumpInitial = { 0.09677, 0.09677 },
        Land = { 0.000197, 0.000197 },
        Ladder = { 0.113672, 0.110994 },
        Fire = { 0.007, 0.012 },
        Move = { 0.122, 0.09288 }
    },
    AltFunction = {
        Name = "Silencer",
        DelayBetweenSwitch = 0.3,
        SilencerApply = {
            Full = 4.416667,
            Apply = 2.2
        },
        SilencerRemove = {
            Full = 4.416667,
            Remove = 1.216667
        }
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
    Icon = 127020921486806,
    IconHorizontal = 101776623713550,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "M4A1-S - A suppressed variant of the M4 carbine. Offers superior recoil control and stealth with a slightly smaller magazine. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;