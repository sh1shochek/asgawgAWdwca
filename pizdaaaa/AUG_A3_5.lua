-- ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AUG A3
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Rifles.AUG A3
-- Decompile time: 5.55 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Type = "Rifle",
    Slot = 1,
    KillAward = 300,
    Price = 3300,
    Damage = 28,
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
    ArmorRatio = 1.8,
    Range = 568.5248,
    RangeModifier = 0.98,
    FlinchVelocityModifierLarge = 0.4,
    FlinchVelocityModifierSmall = 0.55,
    TracerFrequency = { 3, 3 },
    CrosshairMinDistance = 3,
    CrosshairDeltaDistance = 3,
    FireRate = { 0.1, 0.1 },
    Reload = {
        Full = 3.266667,
        Ammo = 1.666667
    },
    EquipDelay = 1.033333,
    InspectDelay = 5.166667,
    Speed = { 15.268, 10.41 },
    Ammo = 30,
    ClipSize = 30,
    ReserveAmmo = 90,
    Spread = { 0.0005, 0.0003 },
    Recovery = {
        Duck = 0.30552,
        DuckFinal = 0.30552,
        Stand = 0.429727,
        StandFinal = 0.429727,
        TransitionStartBullet = 2,
        TransitionEndBullet = 5
    },
    Recoil = {
        Seed = 24204,
        Angle = { 0, 0 },
        AngleVariance = { 60, 60 },
        Magnitude = { 24, 16 },
        MagnitudeVariance = { 0, 0 }
    },
    Inaccuracy = {
        Duck = { 0.00368, 0.00311 },
        Stand = { 0.0049, 0.00368 },
        Jump = { 0.10599, 0.10599 },
        JumpInitial = { 0.10156, 0.10156 },
        Land = { 0.000208, 0.000208 },
        Ladder = { 0.11004, 0.10004 },
        Fire = { 0.00729, 0.00729 },
        Move = { 0.13545, 0.10545 }
    },
    AltFunction = {
        Name = "ScopeRifle",
        Offset = CFrame.new(-0.24984, 0.004858, -0.10826400000000001) * CFrame.new(0, 0, -0.6940000000000001) * CFrame.fromAxisAngle(Vector3.new(0, 0, -1), -0.0005235987755982988) * CFrame.fromAxisAngle(Vector3.new(-1, 0, 0), 0.013613568165555772) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.0017453292519943296) * CFrame.new(0, 0, 0.6940000000000001),
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
        CT = true
    },
    Icon = 95858136431736,
    IconHorizontal = 78883991167232,
    LoadoutCategory = "Rifles",
    Tab = "RIFLES",
    ALLTab = "EQUIPMENT ALL EQUIPMENT",
    Description = "AUG A3 - A scoped assault rifle that provides low spread and high accuracy at long ranges. The bullpup design offers excellent armor penetration. Chambered in 5.56mm."
};
v1.Assets = {
    Viewmodel = script.Viewmodel,
    CharacterModel = script.CharacterModel,
    InspectModel = script.InspectModel
};

return v1;