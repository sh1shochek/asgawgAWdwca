-- ReplicatedStorage.Database.Custom.Weapons.Zeus x27
-- Script path: ReplicatedStorage.Database.Custom.Weapons.Zeus x27
-- Decompile time: 0.62 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RecoilPatterns = require(ReplicatedStorage.Database.Components.Common.RecoilPatterns)
require(ReplicatedStorage.Database.Custom.Types)
local WeaponAnimations = ReplicatedStorage.Assets:WaitForChild("WeaponAnimations")
local Zeus = WeaponAnimations:FindFirstChild("Zeus x27") or WeaponAnimations:FindFirstChild("Zeus X27") or WeaponAnimations:FindFirstChild("Zeus") or WeaponAnimations:FindFirstChild("Taser") or WeaponAnimations:WaitForChild("P250")
local freeze = table.freeze
local v1 = {
    HasSuppressor = false,
    Automatic = false,
    Droppable = true,
    HasScope = false,
    Slot = "Melee",
    WallbangMultiplier = 0,
    Class = "Weapon",
    ShootingOptions = "Default",
    Team = "Both",
    AimingOptions = "None",
    Type = "Pistol",
    MuzzleType = "Zeus x27",
    ReverseIcon = "rbxassetid://131579417467777",
    Icon = "rbxassetid://71464446190434",
    Cost = 200,
    InventoryIconData = {
        Position = UDim2.fromScale(0.5, 0.48),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.95, 0.95),
    },
    BulletsPerShot = 1,
    FireRate = 0.15,
    Range = 13.584,
    RangeModifier = 0.011416,
    RechargeTime = 30,
    ArmorPenetration = 1,
    Penetration = 0.14,
    Spread = {
        Range = NumberRange.new(0.2, 3.5),
        PerShot = 0,
        RecoverySpeed = 10,
        MovementMultiplier = 0.04,
    },
}
local v2 = {}
local P250 = RecoilPatterns["Zeus x27"] or RecoilPatterns.P250
v2.Pattern = P250
v2.RecoverySpeed = 8
v2.CameraScale = 0.2
v2.Damper = 1
v2.Speed = 20
v2.Scale = 0.35
v1.Recoil = v2
v1.WalkSpeed = 17.776
v1.RagdollMultiplier = 42
v1.DamagePerPart = {Torso = 500, Head = 500, Arms = 500, Legs = 500}
v1.ReloadAnimationCount = 1
v1.Capacity = 0
v1.Rounds = 1
v1.CharacterAnimations = Zeus.CharacterAnimations
v1.CameraAnimations = Zeus.CameraAnimations
v1.ShowCrosshair = true
return freeze(v1)