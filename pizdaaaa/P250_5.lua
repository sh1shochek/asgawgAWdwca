-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.P250
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.P250
-- Decompile time: 8.37 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 300,
    Damage = 38,
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
    ArmorRatio = 1.28,
    Range = 284.2624,
    RangeModifier = 0.9,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.15, 0.3 },
    Reload = {
        Full = 1.966667,
        Ammo = 1.033333
    },
    EquipDelay = 0.8166667,
    InspectDelay = 7.55,
    Speed = { 16.656, 16.656 },
    Ammo = 13,
    ClipSize = 13,
    ReserveAmmo = 26,
    Spread = { 0.002, 0.002 },
    Recovery = {
        Duck = 0.287823,
        DuckFinal = 0.287823,
        Stand = 0.345388,
        StandFinal = 0.345388,
        TransitionStartBullet = 3,
        TransitionEndBullet = 10
    },
    Recoil = {
        Seed = 9788,
        Angle = { 0, 0 },
        AngleVariance = { 10, 10 },
        Magnitude = { 26, 26 },
        MagnitudeVariance = { 3, 3 }
    },
    Inaccuracy = {
        Duck = { 0.00683, 0.00683 },
        Stand = { 0.0091, 0.0091 },
        Jump = { 0.09296, 0.09296 },
        JumpInitial = { 0.09662, 0.09662 },
        Land = { 0.00019, 0.00019 },
        Ladder = { 0.138, 0.138 },
        Fire = { 0.05245, 0.05245 },
        Move = { 0.02, 0.01341 }
    },
    Muzzle = "Pistol"
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
    Icon = 124572348980882,
    IconHorizontal = 102021838083248,
    LoadoutCategory = "OtherPistols",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "P250 - A reliable, modular sidearm that balances low cost with high performance. Offers better armor penetration than standard starting pistols. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;