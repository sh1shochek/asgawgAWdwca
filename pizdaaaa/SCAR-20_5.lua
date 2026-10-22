-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SCAR-20
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SCAR-20
-- Decompile time: 10.56 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 5000,
    Damage = 80,
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
    Penetration = 2.5,
    ArmorRatio = 1.65,
    Range = 568.5248,
    RangeModifier = 0.98,
    FlinchVelocityModifierLarge = 0.35,
    FlinchVelocityModifierSmall = 0.4,
    TracerFrequency = 1,
    CrosshairMinDistance = 6,
    CrosshairDeltaDistance = 4,
    FireRate = { 0.25, 0.25 },
    Reload = {
        Full = 4,
        Ammo = 2.233333
    },
    EquipDelay = 1.133333,
    InspectDelay = 6.783333,
    Speed = { 14.921, 8.328 },
    Ammo = 20,
    ClipSize = 20,
    ReserveAmmo = 90,
    Spread = { 0.0003, 0.0003 },
    Recovery = {
        Duck = 0.388808,
        DuckFinal = 0.388808,
        Stand = 0.544331,
        StandFinal = 0.544331,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 19364,
        Angle = { 0, 0 },
        AngleVariance = { 30, 30 },
        Magnitude = { 31, 31 },
        MagnitudeVariance = { 4, 4 }
    },
    Inaccuracy = {
        Duck = { 0.01935, 0.0015 },
        Stand = { 0.0258, 0.002 },
        Jump = { 0.15377, 0.15377 },
        JumpInitial = { 0.10769, 0.10769 },
        Land = { 0.000262, 0.000262 },
        Ladder = { 0.11639, 0.11639 },
        Fire = { 0.01861, 0.01861 },
        Move = { 0.15048, 0.15048 }
    },
    AltFunction = {
        Name = "Scope",
        Type = "Sniper",
        ClosesAfterFire = false,
        Zoom = {
            First = 40,
            Second = 15
        },
        DelayBetweenSwitch = 0.3
    },
    Muzzle = "Sniper"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 99523679101085,
    IconHorizontal = 91661422219754,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "SCAR-20 - A semi-automatic marksman rifle designed for rapid long-range fire. Allows the user to engage multiple targets quickly. Chambered in 7.62mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;