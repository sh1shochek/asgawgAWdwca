-- ReplicatedStorage.Controllers.SoundController.MovementSounds
-- Script path: ReplicatedStorage.Controllers.SoundController.MovementSounds
-- Decompile time: 5.36 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local Sound = require(ReplicatedStorage.Classes.Sound)
local Materials = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact.Components.Materials)
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local u51 = {}
u51[1] = (Vector3.new(0, 0, 0))
u51[2] = (Vector3.new(0.800000011920929, 0, 0))
u51[3] = (Vector3.new(-0.800000011920929, 0, 0))
u51[4] = (Vector3.new(0, 0, 0.800000011920929))
u51[5] = (Vector3.new(0, 0, -0.800000011920929))
local u57 = {
    Concrete = "LandingConcrete",
    Brick = "LandingConcrete",
    Cobblestone = "LandingConcrete",
    Basalt = "LandingConcrete",
    Limestone = "LandingConcrete",
    Pavement = "LandingConcrete",
    Asphalt = "LandingConcrete",
    Rock = "LandingConcrete",
    Slate = "LandingConcrete",
    Granite = "LandingConcrete",
    Marble = "LandingConcrete",
    Pebble = "LandingConcrete",
    CeramicTiles = "LandingConcrete",
    Ground = "LandingDirt",
    Mud = "LandingDirt",
    Glass = "LandingGlass",
    Gravel = "LandingGravel",
    Rubber = "LandingRubber",
    Plastic = "LandingRubber",
    Sand = "LandingSand",
    Snow = "LandingSand",
    Grass = "LandingGrass",
    LeafyGrass = "LandingGrass",
    Metal = "LandingMetal",
    DiamondPlate = "LandingMetal",
    CorrodedMetal = "LandingMetal",
    ["Corroded Metal"] = "LandingMetal",
    Wood = "Wood",
    WoodPlanks = "WoodPlanks",
    Fabric = "LandingDirt",
    Carpet = "LandingDirt",
    Cardboard = "LandingDirt",
}
local u90 = nil
local u92 = RaycastParams.new()
u92.FilterType = Enum.RaycastFilterType.Exclude
u92.IgnoreWater = true

local function GetFloorMaterial(a1, a2, a3) -- Line: 116
    -- upvalues: GetRayIgnore (val), u92 (val), u51 (val)
    local v1, v2
    local v3 = GetRayIgnore()
    if not table.find(v3, a1) then
        table.insert(v3, a1)
    end
    u92.FilterDescendantsInstances = v3
    local v4 = Vector3.new(0, -(a3 or 3.1), 0)
    for i, v in ipairs(u51) do
        v1 = a2 + v
        v2 = workspace:Raycast(v1, v4, u92)
        if v2 and 0.7 < v2.Normal.Y then
            return v2.Material.Name
        end
    end
    return "Air"
end

local function ResolveFloorMaterial(a1, a2, a3, a4) -- Line: 140 -- types: a2: string, a3: boolean, a4: boolean
    if a2 ~= "Air" then
        return a2
    end
    if not a3 then
        return "Air"
    end
    if a4 then
        local CurrentFloorMaterial = a1.CurrentFloorMaterial
        if CurrentFloorMaterial and CurrentFloorMaterial ~= "" and CurrentFloorMaterial ~= "Air" then
            return CurrentFloorMaterial
        end
    end
    return "Concrete"
end

local function GetVolumeMultiplier(a1, a2) -- Line: 167 -- upvalues: FlashEffect (val) -- types: a2: boolean?
    return (if not a2 then 1 else 0.4) * (a1.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1)
end

local function PlayFootstepSound(a1, a2, a3) -- Line: 175
    -- upvalues: u90 (ref), Materials (val)
    if u90 and a2 ~= "" and a2 ~= "Air" then
        local v1 = a2
        if u90.Sounds and not u90.Sounds:FindFirstChild(v1) then
            v1 = Materials[a2] or "Ground"
        end
        if u90.Sounds and not u90.Sounds:FindFirstChild(v1) then
            warn(string.format("[FloorSound] Missing sound for category: '%s' (material: %s)", v1, a2))
            return nil
        end
        return u90:play({Parent = a1, Name = v1}, a3)
    end
    return nil
end

local function StopFootstepSound(a1) -- Line: 200 -- types: a1: userdata?
    if a1 and a1.Playing then
        a1:Stop()
    end
end

local function ResetAirborneTracking(a1) -- Line: 208
    a1.IsAirborne = false
    a1.AirborneStartTime = 0
    a1.PeakAirborneVelocityY = 0
end

local function BeginAirborneTracking(a1, a2, a3) -- Line: 216 -- types: a2: number, a3: number
    if a1.IsAirborne then
        a1.PeakAirborneVelocityY = math.min(a1.PeakAirborneVelocityY, a3)
        return
    end
    a1.IsAirborne = true
    a1.AirborneStartTime = a2
    a1.PeakAirborneVelocityY = a3
end

local function ConsumeLandingWindow(a1, a2) -- Line: 229 -- types: a2: number
    local v1 = if not a1.IsAirborne then 0 else a2 - a1.AirborneStartTime
    local PeakAirborneVelocityY = a1.PeakAirborneVelocityY
    a1.IsAirborne = false
    a1.AirborneStartTime = 0
    a1.PeakAirborneVelocityY = 0
    return v1, PeakAirborneVelocityY
end

local function PlayLandingSound(a1, a2, a3, a4) -- Line: 238
    -- upvalues: GetFloorMaterial (val), FlashEffect (val), PlayFootstepSound (val), u57 (val)
    local v1 = tick()
    if v1 - a1.LastFloorSoundTime < 0.1 then
        return
    end
    a1.LastFloorSoundTime = v1
    local v2 = (if not (a1.Player:GetAttribute("IsCrouching")) then 1 else 0.4) * (a1.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1)
    PlayFootstepSound(a2, u57[a4 or GetFloorMaterial(a3, a2.Position)] or "LandingConcrete", v2)
end

local function PlayJumpSound(a1, a2, a3) -- Line: 260
    -- upvalues: FlashEffect (val), PlayFootstepSound (val)
    local v1 = tick()
    if v1 - a1.LastFloorSoundTime < 0.1 then
        return
    end
    local CurrentFootstepSound = a1.CurrentFootstepSound
    if CurrentFootstepSound and CurrentFootstepSound.Playing then
        CurrentFootstepSound:Stop()
    end
    a1.CurrentFootstepSound = nil
    a1.LastFloorSoundTime = v1
    local v2 = (if not a1.Player:GetAttribute("IsCrouching") then 1 else 0.4) * (a1.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1)
    PlayFootstepSound(a2, "Jump", v2)
    PlayFootstepSound(a2, a3, v2)
end

function u0.SetCharacter(a1, a2) -- Line: 278
    -- upvalues: CharacterResolver (val), RuntimeKinematics (val)
    if a2 then
        local v1 = CharacterResolver.getRootPart(a2)
        if v1 and a2.Parent then
            local v2, v3
            a1.PrimaryPart = v1
            a1.Character = a2
            a1.TimePassed = 0.25
            _, _, _, v2, v3 = RuntimeKinematics.resolve(a2, v1)
            a1.IsAirborne = not v3
            a1.AirborneStartTime = if not a1.IsAirborne then 0 else tick()
            a1.PeakAirborneVelocityY = if not a1.IsAirborne then 0 else v2
            return
        end
        return
    end
    local CurrentFootstepSound = a1.CurrentFootstepSound
    if CurrentFootstepSound and CurrentFootstepSound.Playing then
        CurrentFootstepSound:Stop()
    end
    a1.CurrentFootstepSound = nil
    a1.CurrentFloorMaterial = nil
    a1.PrimaryPart = nil
    a1.TimePassed = 0.25
    a1.Character = nil
    a1.IsAirborne = false
    a1.AirborneStartTime = 0
    a1.PeakAirborneVelocityY = 0
end

function u0.Update(a1, a2, a3) -- Line: 308
    -- upvalues: CharacterResolver (val), RuntimeKinematics (val), GetFloorMaterial (val), PlayJumpSound (val)
    -- upvalues: PlayLandingSound (val), PlayFootstepSound (val), FlashEffect (val)
    local PrimaryPart = a1.PrimaryPart
    local Character = a1.Character
    local Player = a1.Player
    if PrimaryPart and Character and Character.Parent and CharacterResolver.isAliveCharacter(Character) then
        local v1, v2, v3, v4, v5, v6
        local v7 = tick()
        v5, _, v6, _, v1 = RuntimeKinematics.resolve(Character, PrimaryPart)
        if not v1 then
            if not a1.IsAirborne and 2 < v5.Y then
                v2 = GetFloorMaterial(Character, PrimaryPart.Position, 6.2)
                if v2 == "Air" then
                    v2 = a1.CurrentFloorMaterial or "Concrete"
                end
                PlayJumpSound(a1, PrimaryPart, v2)
            end
            local Y = v5.Y
            if a1.IsAirborne then
                a1.PeakAirborneVelocityY = math.min(a1.PeakAirborneVelocityY, Y)
            else
                a1.IsAirborne = true
                a1.AirborneStartTime = v7
                a1.PeakAirborneVelocityY = Y
            end
        elseif a1.IsAirborne then
            local v8
            v2, v8 = RuntimeKinematics.getPosition(Character, PrimaryPart)
            v4 = GetFloorMaterial(Character, v2, if not v8 then 6.2 else 3.1)
            a1.CurrentFloorMaterial = if v4 == "Air" then "Concrete" else v4
            local v9 = if not a1.IsAirborne then 0 else v7 - a1.AirborneStartTime
            local PeakAirborneVelocityY_2 = a1.PeakAirborneVelocityY
            a1.IsAirborne = false
            a1.AirborneStartTime = 0
            a1.PeakAirborneVelocityY = 0
            if v9 >= 0.08 and PeakAirborneVelocityY_2 <= -2.5 then
                PlayLandingSound(a1, PrimaryPart, Character, v3)
            end
        end
        local Attribute = Player:GetAttribute("IsCrouching")
        if not Player:GetAttribute("IsWalking") and not Attribute then
            if Player:GetAttribute("IsSniperScoped") == true then
                return
            end
            local v10 = if not Attribute then 7.5 else 3.5
            v3 = if not Attribute then 0.3 else 0.55
            a1.TimePassed = a1.TimePassed + a2
            if v3 <= a1.TimePassed then
                a1.TimePassed = a1.TimePassed - v3
                if v7 - a1.LastFloorSoundTime < 0.1 then
                    return
                end
                if v10 <= v6 then
                    local v11 = GetFloorMaterial(Character, PrimaryPart.Position, 3.1)
                    if v11 ~= "Air" then
                        v4 = v11
                    elseif v1 then
                        local CurrentFloorMaterial = a1.CurrentFloorMaterial
                        v4 = if not CurrentFloorMaterial then "Concrete" else if CurrentFloorMaterial == "" then "Concrete" else if CurrentFloorMaterial == "Air" then "Concrete" else CurrentFloorMaterial
                    else
                        v4 = "Air"
                    end
                    if v1 then
                        a1.CurrentFloorMaterial = v4
                    end
                    a1.LastFloorSoundTime = v7
                    a1.CurrentFootstepSound = PlayFootstepSound(
                        PrimaryPart,
                        v4,
                        (if not Attribute then 1 else 0.4) * (a1.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1)
                    )
                end
            end
            return
        end
        return
    end
end

function u0.new(a1) -- Line: 392 -- upvalues: u0 (val), LocalPlayer (val), u90 (ref), Sound (val) -- types: a1: userdata
    local v1 = setmetatable({}, u0)
    v1.IsLocalPlayer = a1 == LocalPlayer
    v1.Player = a1
    v1.PrimaryPart = nil
    v1.Character = nil
    v1.TimePassed = 0.25
    v1.CurrentFootstepSound = nil
    v1.CurrentFloorMaterial = nil
    v1.LastFloorSoundTime = 0
    v1.IsAirborne = false
    v1.AirborneStartTime = 0
    v1.PeakAirborneVelocityY = 0
    if not u90 then
        u90 = Sound.new("FloorSounds")
    end
    return v1
end

return u0