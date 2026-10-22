-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.CZ75-Auto
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.CZ75-Auto
-- Decompile time: 5.11 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 500,
    Damage = 31,
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
    ArmorRatio = 1.553,
    Range = 284.2624,
    RangeModifier = 0.85,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.1, 0.1 },
    Reload = {
        Full = 2.933333,
        Ammo = 1.416667
    },
    EquipDelay = 1.166667,
    InspectDelay = 4.166667,
    Speed = { 16.656, 16.656 },
    Ammo = 12,
    ClipSize = 12,
    ReserveAmmo = 12,
    Spread = { 0.003, 0.003 },
    Recovery = {
        Duck = 0.2275,
        DuckFinal = 0.287823,
        Stand = 0.2425,
        StandFinal = 0.345388,
        TransitionStartBullet = 3,
        TransitionEndBullet = 10
    },
    Recoil = {
        Seed = 9788,
        Angle = { 0, 0 },
        AngleVariance = { 120, 180 },
        Magnitude = { 31, 27 },
        MagnitudeVariance = { 6, 12 }
    },
    Inaccuracy = {
        Duck = { 0.0076, 0.0076 },
        Stand = { 0.01043, 0.01043 },
        Jump = { 0.09296, 0.09296 },
        JumpInitial = { 0.09662, 0.09662 },
        Land = { 0.00019, 0.00019 },
        Ladder = { 0.138, 0.138 },
        Fire = { 0.035, 0.025 },
        Move = { 0.01341, 0.01341 }
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
    Icon = 136860440087514,
    IconHorizontal = 119568499682206,
    LoadoutCategory = "OtherPistols",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "CZ75-Auto - A fully-automatic variant of the CZ75. Trades magazine capacity for a blistering rate of fire, capable of shredding targets in seconds. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;