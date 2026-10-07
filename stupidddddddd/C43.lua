-- ReplicatedStorage.Components.C4
-- Script path: ReplicatedStorage.Components.C4
-- Decompile time: 6.58 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local Debris = workspace:WaitForChild("Debris")
local u75 = nil
local u76 = (-1 / 0)
local u78 = RaycastParams.new()
u78.FilterType = Enum.RaycastFilterType.Exclude
u78.IgnoreWater = true

local function PlayerCanPlantC4() -- Line: 86
    -- upvalues: CharacterResolver (val), u78 (val), CurrentCamera (val), Debris (val), RuntimeKinematics (val)
    -- upvalues: Players (val)
    local v1 = CharacterResolver.getLocalCharacter()
    local v2 = {v1, CurrentCamera, Debris}
    u78.FilterDescendantsInstances = v2
    if CharacterResolver.isAliveCharacter(v1) and RuntimeKinematics.isOnGround(v1) then
        local PrimaryPart = v1.PrimaryPart
        if not PrimaryPart then
            return false
        end
        v2 = {CurrentCamera, Debris}
        for i, v in ipairs(Players:GetPlayers()) do
            if v.Character then
                table.insert(v2, v.Character)
            end
        end
        local Map = workspace:FindFirstChild("Map")
        local Barriers = if not Map then nil else Map:FindFirstChild("Barriers")
        if Barriers then
            table.insert(v2, Barriers)
        end
        u78.FilterDescendantsInstances = v2
        local v3 = workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -5, -0), u78)
        if v3 and v3.Instance:HasTag("PlantArea") and v3.Instance:GetAttribute("Site") then
            return true
        end
        return false
    end
    return false
end

local function GetHoldToPlantMessage() -- Line: 122 -- upvalues: UserInputService (val), ReplicatedStorage (val)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return "Keep holding the <b>Shoot</b> button until the bomb is planted"
    end
    local Fire = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips).GetActionKeyText("Fire")
    if Fire then
        return (("Keep holding <b>%*</b> until the bomb is planted"):format(Fire))
    end
    return "Keep holding the fire button until the bomb is planted"
end

local function NotifyPlantCancelled(a1) -- Line: 135
    -- upvalues: IsTutorialMode (val), UserInputService (val), ReplicatedStorage (val), CharacterResolver (val)
    -- upvalues: u76 (ref), Router (val)
    local v1 = nil
    if a1 ~= nil or not IsTutorialMode() then
        if a1 == "LeftPlantArea" and CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
            v1 = "Stay on the ground inside the bombsite until the bomb is planted"
        end
    elseif UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
        local Fire = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips).GetActionKeyText("Fire")
        v1 = if not Fire then "Keep holding the fire button until the bomb is planted" else ("Keep holding <b>%*</b> until the bomb is planted"):format(Fire)
    else
        v1 = "Keep holding the <b>Shoot</b> button until the bomb is planted"
    end
    if v1 and not (os.clock() - u76 < 2) then
        u76 = os.clock()
        Router.broadcastRouter("CreateNotification", "Plant Cancelled", v1, 3)
        return
    end
end

local function NotifyPlantOffSite() -- Line: 150
    -- upvalues: CharacterResolver (val), IsTutorialMode (val), u76 (ref), RuntimeKinematics (val), Router (val)
    local v1 = CharacterResolver.getLocalCharacter()
    if IsTutorialMode() and CharacterResolver.isAliveCharacter(v1) then
        if os.clock() - u76 < 2 then
            return
        end
        u76 = os.clock()
        Router.broadcastRouter(
            "CreateNotification",
            "Can't Plant Here",
            if not RuntimeKinematics.isOnGround(v1) then "Stand on the ground inside the bombsite to plant the bomb" else "Plant the bomb at the bombsite",
            3
        )
        return
    end
end

function u0:stopAllAnimations() -- Line: 168
    if self.CharacterAnimator and self.Viewmodel and self.Viewmodel.Animation then
        for k, v in pairs(self.CharacterAnimator.Animations) do
            if v.IsPlaying and v.Name ~= "Idle" then
                self.CharacterAnimator:stop(k)
            end
        end
        for k2, i in pairs(self.Viewmodel.Animation.Animations) do
            if i.IsPlaying and i.Name ~= "Idle" then
                self.Viewmodel.Animation:stop(k2)
            end
        end
        self.Viewmodel.Animation:stopSounds()
        return
    end
end

function u0.reload(a1) end

function u0.shoot(a1) -- Line: 192
    -- upvalues: PlayerCanPlantC4 (val), NotifyPlantOffSite (val), ReplicateCharacterAction (val), Remotes (val)
    -- upvalues: Router (val)
    if a1.IsPlanting then
        return
    end
    local v1 = tick()
    if v1 - a1.PlantStartedTick < 0.5 then
        return
    end
    a1.Janitor:Remove("BombAnimationEnded")
    if not PlayerCanPlantC4() then
        NotifyPlantOffSite()
        return
    end
    a1.IsInspecting = false
    a1.IsPlanting = true
    a1.PlantStartedTick = v1
    a1:stopAllAnimations()
    ReplicateCharacterAction("Use")
    local v2 = a1.Viewmodel.Animation:play("Use")
    a1.CharacterAnimator:play("Use")
    Remotes.C4.Start.Send(a1.Identifier)
    Router.broadcastRouter("Plant Bomb")
    a1.Janitor:Add(v2.Ended:Connect(function() -- Line: 224 -- upvalues: a1 (val), PlayerCanPlantC4 (upval), Remotes (upval), Router (upval)
        if a1.IsPlanting then
            if PlayerCanPlantC4() then
                Remotes.C4.Planted.Send(a1.Identifier)
                a1.IsPlanting = false
            end
            Router.broadcastRouter("Cancel Bomb Plant")
        end
    end), "Disconnect", "BombAnimationEnded")
end

function u0:cancel(a2) -- Line: 238
    -- upvalues: ReplicateCharacterAction (val), Remotes (val), Router (val), NotifyPlantCancelled (val)
    if not self.IsPlanting then
        return
    end
    self.Viewmodel.Model.Weapon.Interactive.SurfaceGui.TextLabel.Text = "*******"
    self.IsPlanting = false
    self:stopAllAnimations()
    ReplicateCharacterAction("Cancel Plant")
    Remotes.C4.Cancel.Send(self.Identifier)
    Router.broadcastRouter("Cancel Bomb Plant")
    self.Janitor:Remove("BombAnimationEnded")
    NotifyPlantCancelled(a2)
end

function u0.inspect(a1) -- Line: 260 -- upvalues: ReplicateCharacterAction (val)
    if not a1.IsInspecting and not a1.IsPlanting then
        a1.IsInspecting = true
        a1:stopAllAnimations()
        local v1 = a1.Viewmodel.Animation:play("Inspect")
        ReplicateCharacterAction("Inspect")
        task.delay(v1.Length, function() -- Line: 271 -- upvalues: a1 (val)
            a1.IsInspecting = false
        end)
        return
    end
end

function u0.drop(a1) -- Line: 278
    -- upvalues: GameState (val), IsTutorialMode (val), Remotes (val), GetCharacterVelocity (val)
    -- upvalues: CharacterResolver (val), CurrentCamera (val)
    if workspace:GetAttribute("Gamemode") ~= "Deathmatch"
        and GameState.GetState() ~= "Warmup"
        and not IsTutorialMode()
        and not a1.IsPlanting
        and a1.Properties.Droppable then
        a1:unequip()
        Remotes.Inventory.DropWeapon.Send({
            CharacterVelocity = GetCharacterVelocity(CharacterResolver.getLocalCharacter()),
            Direction = CurrentCamera.CFrame.LookVector,
            Identifier = a1.Identifier,
        })
        return true
    end
    return false
end

function u0:equip() -- Line: 300 -- upvalues: u75 (ref)
    self.Viewmodel.Animation:stopAnimations()
    self.CharacterAnimator:stopAnimations()
    self.CharacterAnimator:play("Idle")
    self.CharacterAnimator:play("Equip")
    self.Viewmodel:equip(false)
    u75 = self
end

function u0:unequip() -- Line: 311 -- upvalues: u75 (ref)
    if self.IsPlanting then
        self:cancel("Unequipped")
    end
    self.CharacterAnimator:stopAnimations()
    self.Viewmodel:unequip()
    if u75 and u75 == self then
        u75 = nil
    end
end

function u0.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 325
    -- upvalues: WeaponComponent (val), u0 (val), RunServiceController (val), PlayerCanPlantC4 (val)
    local v1 = WeaponComponent.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
    local u30 = setmetatable(v1, u0)
    u30.IsInspecting = false
    u30.IsPlanting = false
    u30.PlantStartedTick = 0
    u30.Janitor:Add((RunServiceController.BindToHeartbeat(("Components.C4.%*.PlantValidation"):format(a2), function(a1) -- Line: 351 -- upvalues: u30 (val), PlayerCanPlantC4 (upval) -- types: a1: number
        if u30.IsPlanting and not PlayerCanPlantC4() then
            u30:cancel("LeftPlantArea")
        end
    end)))
    return u30
end

function u0.destroy(a1) -- Line: 365 -- upvalues: u75 (ref), WeaponComponent (val)
    if a1.IsDestroyed then
        return
    end
    a1.IsDestroyed = true
    if a1.IsPlanting then
        a1:cancel("Destroyed")
    end
    if u75 and u75 == a1 then
        u75 = nil
    end
    if a1.Janitor then
        a1.Janitor:Destroy()
        a1.Janitor = nil
    end
    a1.PlantStartedTick = nil
    a1.IsInspecting = nil
    a1.IsPlanting = nil
    WeaponComponent.destroy(a1)
end

Remotes.C4.ForceCancel.Listen(function() -- Line: 396 -- upvalues: u75 (ref)
    if u75 and u75.IsPlanting then
        u75:cancel("Server")
    end
end)
return u0