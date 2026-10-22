-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SG 553
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.SG 553
-- Decompile time: 5.26 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 3000,
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
    ArmorRatio = 2,
    Range = 568.5248,
    RangeModifier = 0.98,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = { 3, 3 },
    CrosshairMinDistance = 5,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.11, 0.11 },
    Reload = {
        Full = 3.133333,
        Ammo = 1.533333
    },
    EquipDelay = 0.9,
    InspectDelay = 6.6,
    Speed = { 14.574, 10.41 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 90,
    Spread = { 0.0006, 0.0003 },
    Recovery = {
        Duck = 0.379204,
        DuckFinal = 0.379204,
        Stand = 0.452886,
        StandFinal = 0.452886,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 43500,
        Angle = { 0, 0 },
        AngleVariance = { 60, 60 },
        Magnitude = { 28, 19 },
        MagnitudeVariance = { 2, 2 }
    },
    Inaccuracy = {
        Duck = { 0.00381, 0.00305 },
        Stand = { 0.00581, 0.00381 },
        Jump = { 0.109, 0.109 },
        JumpInitial = { 0.07879, 0.07879 },
        Land = { 0.000188, 0.000188 },
        Ladder = { 0.08366, 0.138758 },
        Fire = { 0.00795, 0.0092 },
        Move = { 0.13601, 0.13601 }
    },
    AltFunction = {
        Name = "ScopeRifle",
        Offset = CFrame.new(-0.35532800000000003, 0.09230200000000001, 0.049968) * CFrame.new(0, 0, -0.5552) * CFrame.fromAxisAngle(Vector3.new(0, 0, -1), 0.012566370614359171) * CFrame.fromAxisAngle(Vector3.new(-1, 0, 0), 0.009075712110370514) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.0006981317007977319) * CFrame.new(0, 0, 0.5552),
        PullUpSpeed = 10,
        PutDownSpeed = 8,
        FOV = 45,
        DelayBetweenSwitch = 0.3
    },
    Muzzle = "Rifle"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        T = true
    },
    Icon = 89617026678372,
    IconHorizontal = 100688760178782,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "SG-553 - A premium scoped assault rifle boasting unparalleled armor penetration and lethal headshot potential. Its scope makes it a devastating long-range threat. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;