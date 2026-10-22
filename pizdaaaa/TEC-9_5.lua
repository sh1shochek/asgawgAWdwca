-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.TEC-9
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.TEC-9
-- Decompile time: 6.63 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Pistol",
    Slot = 2,
    KillAward = 300,
    Price = 500,
    Damage = 33,
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
    ArmorRatio = 1.812,
    Range = 284.2624,
    RangeModifier = 0.79,
    FlinchVelocityModifierLarge = 0.5,
    FlinchVelocityModifierSmall = 0.65,
    TracerFrequency = 1,
    CrosshairMinDistance = 8,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.12, 0.12 },
    Reload = {
        Full = 2.7,
        Ammo = 1.433333
    },
    EquipDelay = 0.9,
    InspectDelay = 5.55,
    Speed = { 16.656, 16.656 },
    Ammo = 18,
    ClipSize = 18,
    ReserveAmmo = 90,
    Spread = { 0.002, 0.0018 },
    Recovery = {
        Duck = 0.315,
        DuckFinal = 0.315,
        Stand = 0.391,
        StandFinal = 0.391,
        TransitionStartBullet = 3,
        TransitionEndBullet = 10
    },
    Recoil = {
        Seed = 789,
        Angle = { 0, 0 },
        AngleVariance = { 60, 60 },
        Magnitude = { 23, 23 },
        MagnitudeVariance = { 3, 3 }
    },
    Inaccuracy = {
        Duck = { 0.00368, 0.00727 },
        Stand = { 0.0049, 0.00903 },
        Jump = { 0.07978, 0.07978 },
        JumpInitial = { 0.07117, 0.07117 },
        Land = { 0.000211, 0.000211 },
        Ladder = { 0.1206, 0.1206 },
        Fire = { 0.045, 0.03688 },
        Move = { 0.00381, 0.00381 }
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
    Icon = 131664116590709,
    IconHorizontal = 82558165508334,
    LoadoutCategory = "OtherPistols",
    Tab = "PISTOLS",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "TEC-9 - A semi-automatic pistol designed for rapid fire and high mobility. Its high-capacity magazine is ideal for aggressive maneuvers. Chambered in 9mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;