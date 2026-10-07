-- ReplicatedStorage.Components.Melee
-- Script path: ReplicatedStorage.Components.Melee
-- Decompile time: 9.35 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController)
local SoundController = require(ReplicatedStorage.Controllers.SoundController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction)
local WeaponTimings = require(ReplicatedStorage.Components.Common.WeaponTimings)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter)
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local function isPlayer(a1) -- Line: 91 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    return CharacterResolver.isPlayerCharacter(a1 and a1:FindFirstAncestorOfClass("Model") or nil)
end

local function cancelThreadField(a1, a2) -- Line: 97 -- types: a2: string
    local v1 = a1[a2]
    if v1 then
        task.cancel(v1)
        a1[a2] = nil
    end
end

local function isCurrentEquipped(a1) -- Line: 107 -- upvalues: HttpService (val), LocalPlayer (val) -- types: a1: string
    return HttpService:JSONDecode((LocalPlayer:GetAttribute("CurrentEquipped")) or "[]").Identifier == a1
end

local function isBackStab(a1, a2) -- Line: 113 -- upvalues: CharacterResolver (val) -- types: a1: userdata, a2: userdata
    local v1 = CharacterResolver.getRootPart(a1)
    local v2 = CharacterResolver.getRootPart(a2)
    if v1 and v2 then
        return 100 < (math.deg((math.acos((v2.CFrame.LookVector:Dot((v1.Position - v2.Position).Unit))))))
    end
end

local function getBotVictimKey(a1) -- Line: 126 -- upvalues: ReplicatedStorage (val) -- types: a1: userdata
    local v1 = a1:FindFirstAncestorOfClass("Model")
    while v1 ~= nil do
        if v1:GetAttribute("Bot") == true then
            break
        end
        v1 = v1:FindFirstAncestorOfClass("Model")
    end
    local Combatants = ReplicatedStorage:FindFirstChild("Combatants")
    local v2 = if v1 == nil or Combatants == nil then nil else Combatants:FindFirstChild((tostring((v1:GetAttribute("CombatantId")))))
    local Attribute_2 = if v2 == nil then nil else v2:GetAttribute("UserId")
    if typeof(Attribute_2) == "number" then
        return Attribute_2
    end
    return nil
end

local function scheduleInspectEnd(a1, a2) -- Line: 141 -- types: a2: number
    a1.InspectDelayThread = task.delay(a2, function() -- Line: 142 -- upvalues: a1 (val)
        if not a1.IsDestroyed then
            a1.InspectDelayThread = nil
            a1.IsInspecting = false
        end
    end)
end

local function resetActionState(a1) -- Line: 152
    a1.IsInspectFadingOut = false
    a1.IsInspecting = false
    a1.IsShooting = false
    a1.IsFireHeld = false
end

function u0:stopAllAnimations() -- Line: 162
    if self.CharacterAnimator and self.Viewmodel and self.Viewmodel.Animation then
        self.Viewmodel.Animation:cancelCrossfade()
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
        return
    end
end

function u0.reload(a1) -- Line: 182
    if a1.IsInspecting or a1.IsInspectFadingOut then
        a1:cancelInspect(0.25)
    end
end

function u0:shoot(a2) -- Line: 191
    -- upvalues: CharacterResolver (val), WeaponTimings (val), Router (val), SoundController (val), GetRayIgnore (val)
    -- upvalues: CurrentCamera (val), getBotVictimKey (val), CreateImpact (val), CreateBloodSplatter (val)
    -- upvalues: isBackStab (val), BreakGlass (val), CreateMarker (val), Remotes (val), ReplicateCharacterAction (val)
    -- upvalues: HapticsController (val), HttpService (val), LocalPlayer (val), InputController (val)
    local v1 = CharacterResolver.getPlayerCharacter(self.Player)
    local v2 = tick() - self.WeaponEquippedTick
    if not (v2 <= WeaponTimings.MELEE_EQUIP_LOCKOUT) and v1 and CharacterResolver.isAliveCharacter(v1) then
        if self.Properties.FireRate and not self.IsShooting then
            if self.IsInspecting or self.IsInspectFadingOut then
                self:cancelInspect(0.25)
            end
            self:stopAllAnimations()
            self.IsInspecting = false
            self.IsInspectFadingOut = false
            self.IsShooting = true
            Router.broadcastRouter("UpdatePlayerNoiseCone", "Melee", v1.PrimaryPart.Position, SoundController.GetMeleeRange(self.Name), nil)
            v2 = RaycastParams.new()
            v2.FilterType = Enum.RaycastFilterType.Exclude
            v2.FilterDescendantsInstances = GetRayIgnore()
            v2.IgnoreWater = true
            local v3 = CurrentCamera.CFrame.LookVector * self.Properties.Range
            local Position_2 = CurrentCamera.CFrame.Position
            local v4 = workspace:Raycast(Position_2, v3, v2) or workspace:Spherecast(Position_2, 1.5, v3, v2)
            local v5 = ("Swing%*"):format((math.random(1, 2)))
            v5 = if not a2 then v5 else "Heavy Swing"
            if v4 then
                local Instance = v4.Instance
                local v6 = CharacterResolver.getPlayerFromInstance(Instance)
                local v7 = if v6 ~= nil then nil else getBotVictimKey(Instance)
                local Position_3 = v4.Position
                local Material = v4.Material
                local Normal = v4.Normal
                local isPlayerCharacter = CharacterResolver.isPlayerCharacter
                if not isPlayerCharacter(Instance and Instance:FindFirstAncestorOfClass("Model") or nil) then
                    local Parent = Instance.Parent
                    CreateImpact(Instance, Material.Name, Position_3, Normal, false, true, true)
                    if not Parent then
                        if not Instance:HasTag("BreakableGlass") then
                            CreateMarker(Instance, "Melee", Position_3, Normal)
                        end
                    elseif Parent:HasTag("BreakableGlass") then
                        BreakGlass(Instance, Position_3, v3.Unit)
                    elseif not Instance:HasTag("BreakableGlass") then
                        CreateMarker(Instance, "Melee", Position_3, Normal)
                    end
                else
                    local v8 = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter")
                    CreateImpact(Instance, v8, Position_3, Normal, false, true, true)
                    if v8 == "Blood Splatter" then
                        CreateBloodSplatter(Position_3, CurrentCamera.CFrame.LookVector)
                    end
                    if a2
                        and isBackStab(CharacterResolver.getLocalCharacter(), (Instance:FindFirstAncestorOfClass("Model"))) then
                        v5 = "BackStab"
                    end
                end
                local Send = Remotes.Melee.MeleeAttack.Send
                local v9 = {
                    Direction = CurrentCamera.CFrame.LookVector * self.Properties.Range,
                    Material = v4.Material.Name,
                    Distance = v4.Distance,
                }
                v9.Instance = if v6 ~= nil then nil else if v7 ~= nil then nil else Instance
                v9.VictimUserId = if v6 == nil then v7 else v6.UserId
                v9.HitPartName = if v6 ~= nil then Instance.Name else if v7 == nil then nil else Instance.Name
                v9.Position = v4.Position
                v9.Normal = v4.Normal
                v9.MeleeAttack = v5
                v9.Identifier = self.Identifier
                Send(v9)
            end
            ReplicateCharacterAction(v5)
            self.Viewmodel.Animation:play(v5)
            v5 = if v5 == "Swing1" then "Swing" else if v5 ~= "Swing" then v5 else "Swing"
            HapticsController.vibrate(Enum.VibrationMotor.Small, 1.15, 0.2)
            self.CharacterAnimator:play(v5)
            task.delay(self.Properties.FireRate * (if not a2 then 1 else 2.05), function() -- Line: 289 -- upvalues: self (val), HttpService (upval), LocalPlayer (upval), InputController (upval)
                if not self.IsDestroyed then
                    self.IsShooting = false
                    local Identifier = self.Identifier
                    if not (HttpService:JSONDecode((LocalPlayer:GetAttribute("CurrentEquipped")) or "[]").Identifier == Identifier) then
                        return
                    end
                    local IsFireHeld = InputController.isActionPressed("Fire", {Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2}) or self.IsFireHeld
                    local v1 = InputController.isActionPressed("Secondary Fire", {Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2})
                    if IsFireHeld or v1 then
                        self:shoot(v1)
                    end
                end
            end)
            return
        end
        return
    end
end

function u0:cancelInspect(a2, a3) -- Line: 313 -- types: a2: number?, a3: number?
    if not self.IsInspecting and not self.IsInspectFadingOut then
        return
    end
    local InspectDelayThread = self.InspectDelayThread
    if InspectDelayThread then
        task.cancel(InspectDelayThread)
        self.InspectDelayThread = nil
    end
    local u16 = a2 or 1.2
    self.IsInspectFadingOut = true
    self.IsInspecting = false
    self.Viewmodel.Animation:markInspectCancel()
    local CancelDelayThread = self.CancelDelayThread
    if CancelDelayThread then
        task.cancel(CancelDelayThread)
        self.CancelDelayThread = nil
    end
    local FadeCompleteThread = self.FadeCompleteThread
    if FadeCompleteThread then
        task.cancel(FadeCompleteThread)
        self.FadeCompleteThread = nil
    end
    self.CancelDelayThread = task.delay(a3 or 0.3, function() -- Line: 334 -- upvalues: self (val), u16 (val)
        if self.IsDestroyed or not self.IsInspectFadingOut then
            return
        end
        self.Viewmodel.Animation:crossfadeTo("Idle", u16)
        self.FadeCompleteThread = task.delay(u16, function() -- Line: 346 -- upvalues: self (upval)
            if not self.IsDestroyed then
                self.FadeCompleteThread = nil
                self.IsInspectFadingOut = false
            end
        end)
    end)
end

function u0.inspect(a1) -- Line: 357 -- upvalues: ReplicateCharacterAction (val)
    local v1, v2
    if a1.IsShooting then
        return
    end
    if a1.IsInspecting and not a1.IsInspectFadingOut then
        return
    end
    if a1.IsInspectFadingOut == true then
        a1.IsInspectFadingOut = false
        local CancelDelayThread = a1.CancelDelayThread
        if CancelDelayThread then
            task.cancel(CancelDelayThread)
            a1.CancelDelayThread = nil
        end
        local FadeCompleteThread = a1.FadeCompleteThread
        if FadeCompleteThread then
            task.cancel(FadeCompleteThread)
            a1.FadeCompleteThread = nil
        end
        a1.Viewmodel.Animation:cancelCrossfade()
    end
    a1.IsInspecting = true
    a1.IsShooting = false
    local InspectDelayThread = a1.InspectDelayThread
    if InspectDelayThread then
        task.cancel(InspectDelayThread)
        a1.InspectDelayThread = nil
    end
    local v3 = a1.Viewmodel.Animation:pickInspectVariant()
    if not v1 then
        a1:stopAllAnimations()
        v2 = a1.Viewmodel.Animation:play(v3)
        ReplicateCharacterAction("Inspect")
        a1.InspectDelayThread = task.delay(v2.Length, function() -- Line: 142 -- upvalues: a1 (val)
            if not a1.IsDestroyed then
                a1.InspectDelayThread = nil
                a1.IsInspecting = false
            end
        end)
        return
    end
    if not a1.Viewmodel.Animation:crossfadeRestart(v3, 0.25) then
        a1:stopAllAnimations()
        a1.Viewmodel.Animation:play(v3)
    end
    ReplicateCharacterAction("Inspect")
    v2 = a1.Viewmodel.Animation:getAnimation(v3)
    if v2 then
        a1.InspectDelayThread = task.delay(v2.Length, function() -- Line: 142 -- upvalues: a1 (val)
            if not a1.IsDestroyed then
                a1.InspectDelayThread = nil
                a1.IsInspecting = false
            end
        end)
    end
end

function u0.drop(a1) -- Line: 406
    -- upvalues: GameState (val), Remotes (val), GetCharacterVelocity (val), CharacterResolver (val)
    -- upvalues: CurrentCamera (val)
    if workspace:GetAttribute("Gamemode") ~= "Deathmatch"
        and GameState.GetState() ~= "Warmup"
        and workspace:GetAttribute("VIPKnifeDropEnabled") == true then
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

function u0:equip() -- Line: 428
    self.Viewmodel.Animation:stopAnimations()
    self.CharacterAnimator:stopAnimations()
    self.CharacterAnimator:play("Idle")
    self.CharacterAnimator:play("Equip")
    self.WeaponEquippedTick = tick()
    self.Viewmodel:equip(false)
    self.IsInspectFadingOut = false
    self.IsInspecting = false
    self.IsShooting = false
    self.IsFireHeld = false
end

function u0:unequip() -- Line: 440
    self.CharacterAnimator:stopAnimations()
    self.Viewmodel:unequip()
    self.IsInspectFadingOut = false
    self.IsInspecting = false
    self.IsShooting = false
    self.IsFireHeld = false
end

function u0.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 449
    -- upvalues: WeaponComponent (val), u0 (val)
    local v1 = WeaponComponent.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
    local v2 = setmetatable(v1, u0)
    v2.IsInspectFadingOut = false
    v2.IsInspecting = false
    v2.IsShooting = false
    v2.IsFireHeld = false
    v2.AlternativeSwitchTick = 0
    v2.WeaponEquippedTick = 0
    return v2
end

function u0.destroy(a1) -- Line: 496 -- upvalues: WeaponComponent (val)
    if a1.IsDestroyed then
        return
    end
    a1.IsDestroyed = true
    local InspectDelayThread = a1.InspectDelayThread
    if InspectDelayThread then
        task.cancel(InspectDelayThread)
        a1.InspectDelayThread = nil
    end
    local CancelDelayThread = a1.CancelDelayThread
    if CancelDelayThread then
        task.cancel(CancelDelayThread)
        a1.CancelDelayThread = nil
    end
    local FadeCompleteThread = a1.FadeCompleteThread
    if FadeCompleteThread then
        task.cancel(FadeCompleteThread)
        a1.FadeCompleteThread = nil
    end
    if a1.Janitor then
        a1.Janitor:Destroy()
        a1.Janitor = nil
    end
    a1.IsInspectFadingOut = nil
    a1.IsInspecting = nil
    a1.IsShooting = nil
    a1.IsFireHeld = nil
    a1.AlternativeSwitchTick = nil
    a1.WeaponEquippedTick = nil
    WeaponComponent.destroy(a1)
end

return u0