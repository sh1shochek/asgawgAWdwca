-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.USP-S
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.USP-S
-- Decompile time: 3.62 ms

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
    TracerFrequency = { 0, 1 },
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.17, 0.17 },
    Reload = {
        Full = 1.966667,
        Ammo = 1.05
    },
    EquipDelay = 0.8166667,
    InspectDelay = 7.55,
    Speed = { 16.656, 16.656 },
    Ammo = 12,
    ClipSize = 12,
    ReserveAmmo = 24,
    Spread = { 0.0015, 0.0025 },
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
        Magnitude = { 23, 29 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0.00368, 0.00368 },
        Stand = { 0.0049, 0.0049 },
        Jump = { 0.09448, 0.09448 },
        JumpInitial = { 0.0966, 0.0966 },
        Land = { 0.000198, 0.000191 },
        Ladder = { 0.1199, 0.13832 },
        Fire = { 0.052, 0.071 },
        Move = { 0.01387, 0.01387 }
    },
    AltFunction = {
        Name = "Silencer",
        DelayBetweenSwitch = 0.3,
        SilencerApply = {
            Full = 4.166667,
            Apply = 1.366667
        },
        SilencerRemove = {
            Full = 2.733333,
            Remove = 0.283333
        }
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
    Icon = 95082781820312,
    IconHorizontal = 86980467045933,
    LoadoutCategory = "StartingPistol",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "USP-S - A precision tactical pistol featuring a detachable silencer. Rewards disciplined shooters with pinpoint accuracy and stealth. Chambered in .45 ACP."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;