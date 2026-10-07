-- ReplicatedStorage.Database.Custom.Weapons.R8 Revolver
-- Script path: ReplicatedStorage.Database.Custom.Weapons.R8 Revolver
-- Decompile time: 0.62 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RecoilPatterns = require(ReplicatedStorage.Database.Components.Common.RecoilPatterns)
require(ReplicatedStorage.Database.Custom.Types)
local freeze = table.freeze
local v1 = {
    HasSuppressor = false,
    Automatic = false,
    Droppable = true,
    HasScope = false,
    Slot = "Secondary",
    WallbangMultiplier = 0.8,
    Class = "Weapon",
    ShootingOptions = "Revolver",
    Team = "Both",
    AimingOptions = "None",
    Type = "Pistol",
    MuzzleType = "Pistol",
    ReverseIcon = "rbxassetid://127392244236728",
    Icon = "rbxassetid://112745953600473",
    Cost = 600,
    BulletsPerShot = 1,
    FireRate = 0.706,
    Range = 1200,
    RangeModifier = 0.98,
    ArmorPenetration = 0.92,
    Penetration = 0.14,
    Spread = {
        Range = NumberRange.new(0.52, 12.5),
        PerShot = 12,
        RecoverySpeed = 3.5,
        MovementMultiplier = 0.56,
    },
    FireModes = {
        Primary = {
            InputBehavior = "Charge",
            ChargeTime = 0.2,
            ChargeStartSpread = 0.9,
            CancelOnRelease = true,
            HoldRepeat = true,
            FireRate = 0.43,
            HoldWalkSpeed = 14.544,
            Spread = {
                Range = NumberRange.new(0.52, 12.5),
                PerShot = 12,
                RecoverySpeed = 3.5,
                MovementMultiplier = 0.56,
            },
        },
        Secondary = {
            InputBehavior = "Immediate",
            HoldRepeat = true,
            FireRate = 0.4,
            Animation = "SlamFire",
            CharacterAnimation = "SlamFire",
            Spread = {
                Range = NumberRange.new(12, 28),
                PerShot = 12,
                RecoverySpeed = 4.5,
                MovementMultiplier = 0.6,
            },
        },
    },
}
local v2 = {}
local v3 = RecoilPatterns["R8 Revolver"] or RecoilPatterns["Glock-18"]
v2.Pattern = v3
v2.RecoverySpeed = 2.2
v2.CameraScale = 0.85
v2.Damper = 0.7
v2.Speed = 16
v2.Scale = 1.8
v1.Recoil = v2
v1.WalkSpeed = 17.776
v1.RagdollMultiplier = 45
v1.DamagePerPart = {Torso = 86, Head = 256, Arms = 69, Legs = 51}
v1.ReloadAnimationCount = 1
v1.Capacity = 16
v1.Rounds = 8
v1.CharacterAnimations = ReplicatedStorage.Assets.WeaponAnimations["R8 Revolver"].CharacterAnimations
v1.CameraAnimations = ReplicatedStorage.Assets.WeaponAnimations["R8 Revolver"].CameraAnimations
v1.ShowCrosshair = true
return freeze(v1)