-- ReplicatedStorage.Shared.Managers.WeaponManager.SMG.PPSH-41
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.SMG.PPSH-41
-- Decompile time: 9.08 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "SMG",
    Slot = 1,
    KillAward = 600,
    Price = 1300,
    Damage = 27,
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
    ArmorRatio = 1.26,
    Range = 249.84,
    RangeModifier = 0.8,
    FlinchVelocityModifierLarge = 0,
    FlinchVelocityModifierSmall = 0,
    TracerFrequency = 3,
    CrosshairMinDistance = 7,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.08, 0.08 },
    Reload = {
        Full = 2.25,
        Ammo = 1.383333
    },
    EquipDelay = 1,
    InspectDelay = 5.883333,
    Speed = { 16.656, 16.656 },
    Ammo = 64,
    ClipSize = 64,
    ReserveAmmo = 120,
    Spread = { 0.001, 0.001 },
    Recovery = {
        Duck = 0.236837,
        DuckFinal = 0.236837,
        Stand = 0.331572,
        StandFinal = 0.331572,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 36387,
        Angle = { 0, 0 },
        AngleVariance = { 70, 70 },
        Magnitude = { 18, 18 },
        MagnitudeVariance = { 1, 1 }
    },
    Inaccuracy = {
        Duck = { 0.0105, 0.0105 },
        Stand = { 0.0189, 0.0189 },
        Jump = { 0.03347, 0.03347 },
        JumpInitial = { 0.0459, 0.0459 },
        Land = { 0.00008, 0.00008 },
        Ladder = { 0.16965, 0.16965 },
        Fire = { 0.00288, 0.00288 },
        Move = { 0.05514, 0.05514 }
    },
    Muzzle = "SMG"
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
    Icon = 121420335483051,
    IconHorizontal = 83510034983849,
    LoadoutCategory = "MidTier",
    Tab = "MID-TIER",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "PPSH-41 - A classic high-capacity submachine gun. Designed to overwhelm enemies with a wall of lead from its drum magazine. Chambered in 7.62x25mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;