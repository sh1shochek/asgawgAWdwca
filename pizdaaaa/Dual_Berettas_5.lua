-- ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Dual Berettas
-- Script path: ReplicatedStorage.Shared.Managers.WeaponManager.Pistols.Dual Berettas
-- Decompile time: 5.19 ms

-- Decompiled with Potassium's decompiler.

return {
    Data = {
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
        ArmorRatio = 1.15,
        Range = 284.2624,
        RangeModifier = 0.79,
        FlinchVelocityModifierLarge = 0.5,
        FlinchVelocityModifierSmall = 0.65,
        TracerFrequency = 1,
        CrosshairMinDistance = 4,
        CrosshairDeltaDistance = 3,
        FireRate = { 0.12, 0.12 },
        Reload = {
            Full = 3.783333,
            Ammo = 1.633333
        },
        EquipDelay = 0.6833333,
        InspectDelay = 6.166667,
        Speed = { 16.656, 16.656 },
        Ammo = 30,
        ClipSize = 30,
        ReserveAmmo = 120,
        Spread = { 0.002, 0.002 },
        Recovery = {
            Duck = 0.437491,
            DuckFinal = 0.437491,
            Stand = 0.524989,
            StandFinal = 0.524989,
            TransitionStartBullet = 3,
            TransitionEndBullet = 10
        },
        Recoil = {
            Seed = 24563,
            Angle = { 0, 0 },
            AngleVariance = { 20, 20 },
            Magnitude = { 27, 27 },
            MagnitudeVariance = { 4, 4 }
        },
        Inaccuracy = {
            Duck = { 0.00525, 0.0075 },
            Stand = { 0.007, 0.01 },
            Jump = { 0.15842, 0.15842 },
            JumpInitial = { 0.09586, 0.09586 },
            Land = { 0.000255, 0.000255 },
            Ladder = { 0.102, 0.102 },
            Fire = { 0.01116, 0.01196 },
            Move = { 0.01785, 0.01785 }
        },
        Muzzle = "Pistol",
        DroppedWeaponHitbox = Vector3.new(0.2, 0.05, 0.2)
    },
    GuiInformation = {
        Sides = {
            T = true,
            CT = true
        },
        Icon = 116158189526872,
        IconHorizontal = 130510965833386,
        LoadoutCategory = "OtherPistols",
        Tab = "PISTOLS",
        ALLTab = "EQUIPMENT ALL EQUIPMENT",
        Description = "Dual Berettas - Firing two large-mag pistols simultaneously lowers accuracy and increases load times, but provides an unmatched rate of fire. Chambered in 9mm."
    },
    Assets = {
        Viewmodel = script.Viewmodel,
        CharacterModel = script.CharacterModel,
        InspectModel = script.InspectModel,
        DropModel = script.DropModel
    }
};