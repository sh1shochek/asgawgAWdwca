-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.P2000
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.P2000
-- Decompile time: 3.63 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 200,
    Damage = 35,
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
    ArmorRatio = 1.01,
    Range = 284.2624,
    RangeModifier = 0.91,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.17, 0.17 },
    Reload = {
        Full = 1.966667,
        Ammo = 1.033333
    },
    EquipDelay = 0.8166667,
    InspectDelay = 7.55,
    Speed = { 16.656, 16.656 },
    Ammo = 13,
    ClipSize = 13,
    ReserveAmmo = 52,
    Spread = { 0.002, 0.0015 },
    Recovery = {
        Duck = 0.291277,
        DuckFinal = 0.291277,
        Stand = 0.349532,
        StandFinal = 0.349532,
        TransitionStartBullet = 3,
        TransitionEndBullet = 10
    },
    Recoil = {
        Seed = 5426,
        Angle = { 0, 0 },
        AngleVariance = { 0, 0 },
        Magnitude = { 26, 26 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0.00368, 0.00368 },
        Stand = { 0.0049, 0.0049 },
        Jump = { 0.09448, 0.09448 },
        JumpInitial = { 0.0966, 0.0966 },
        Land = { 0.000191, 0.000198 },
        Ladder = { 0.13832, 0.1199 },
        Fire = { 0.05, 0.01315 },
        Move = { 0.013, 0.01387 }
    },
    Muzzle = "Pistol"
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true
    },
    Icon = 124572348980882,
    IconHorizontal = 102021838083248,
    LoadoutCategory = "StartingPistol",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "P2000 - An accurate and controllable default sidearm, perfect for the first round of engagement. Offers manageable recoil and solid accuracy. Chambered in .357 SIG."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;