-- ReplicatedStorage.Shared.Managers.WeaponManager.Knives.Cleaver
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Knives.Cleaver
-- Decompile time: 3.81 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Melee",
    Slot = 3,
    KillAward = 1500,
    Price = 0,
    Damage = 50,
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
    ArmorRatio = 1.7,
    Range = 284.2624,
    RangeModifier = 0.99,
    FlinchVelocityModifierLarge = 0.3,
    FlinchVelocityModifierSmall = 0.3,
    TracerFrequency = 0,
    CrosshairMinDistance = 7,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.4, 1 },
    Reload = {
        Full = 3,
        Ammo = 2.4
    },
    EquipDelay = 0.9666666,
    InspectDelay = 8.15,
    Speed = { 17.35, 17.35 },
    Ammo = 0,
    ClipSize = 0,
    ReserveAmmo = 0,
    Spread = { 0, 0 },
    Recovery = {
        Duck = 1,
        DuckFinal = 1,
        Stand = 1,
        StandFinal = 1,
        TransitionStartBullet = 0,
        TransitionEndBullet = 0
    },
    Recoil = {
        Seed = 26701,
        Angle = { 0, 0 },
        AngleVariance = { 0, 0 },
        Magnitude = { 0, 0 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0, 0 },
        Stand = { 0, 0 },
        Jump = { 0, 0 },
        JumpInitial = { 0, 0 },
        Land = { 0, 0 },
        Ladder = { 0, 0 },
        Fire = { 0, 0 },
        Move = { 0, 0 }
    }
};
local X = script:WaitForChild("CharacterModel"):GetExtentsSize().X;
local Z = script:WaitForChild("CharacterModel"):GetExtentsSize().Z;
v2.DroppedWeaponHitbox = Vector3.new(X, 0.05, Z);
v1.Data = v2;
v1.GuiInformation = {
    Sides = {
        CT = true,
        T = true
    },
    Icon = 91397834897266,
    IconHorizontal = 79270649122459,
    LoadoutCategory = "Melee",
    Tab = "MELEE",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "Cleaver is a smart, reliable tool designed to simplify complex tasks. Its intuitive interface and flexible features help individuals and teams work faster, stay organized, and achieve results every day."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script:FindFirstChild("InspectModel")
};

return v1;