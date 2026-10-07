-- ReplicatedStorage.Components.Weapon
-- Script path: ReplicatedStorage.Components.Weapon
-- Decompile time: 78.79 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera)
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter)
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local PlayerHitPrediction = require(ReplicatedStorage.Components.Common.PlayerHitPrediction)
local ReplicateCharacterAction = require(ReplicatedStorage.Components.Common.ReplicateCharacterAction)
local GetWeaponCameraKick = require(ReplicatedStorage.Components.Common.GetWeaponCameraKick)
local WeaponTimings = require(ReplicatedStorage.Components.Common.WeaponTimings)
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local SoundController = require(ReplicatedStorage.Controllers.SoundController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local HintController = require(ReplicatedStorage.Controllers.HintController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Bullet = require(script.Classes.Bullet)
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Other = Sound.new("Other")
local u178 = {37, 60}
local u181 = {Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2}
local u184 = {Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2}
local u193 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true
;(workspace:GetAttributeChangedSignal("VIPInfiniteAmmoEnabled")):Connect(function() -- Line: 79 -- upvalues: u193 (ref)
    u193 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true
end)
local u204 = {}
for i, v in ipairs(ReplicatedStorage.Database.Custom.Weapons:GetChildren()) do
    if v:IsA("ModuleScript") then
        u204[v.Name] = (require(v))
    end
end

local function botVictimKey(a1) -- Line: 100 -- upvalues: Participants (val) -- types: a1: userdata
    local v1 = a1 and a1:FindFirstAncestorOfClass("Model")
    local Attribute = if not v1 then nil else if v1:GetAttribute("Bot") ~= true then nil else v1:GetAttribute("CombatantId")
    if typeof(Attribute) == "number" then
        return (Participants.BotKey(Attribute))
    end
    return nil
end

local function isPlayer(a1) -- Line: 109 -- upvalues: CharacterResolver (val) -- types: a1: userdata
    local v1 = a1 and a1:FindFirstAncestorOfClass("Model")
    local v2 = false
    if v1 ~= nil then
        v2 = true
        if CharacterResolver.getPlayerFromCharacter(v1) == nil then
            v2 = true
            if v1:GetAttribute("Bot") ~= true then
                v2 = CharacterResolver.isTutorialDummy(v1)
            end
        end
    end
    return v2
end

local function isEquippedLocal(a1) -- Line: 121
    return not a1.IsDestroyed and a1.IsEquipped == true
end

local function isJustEquipped(a1) -- Line: 127 -- upvalues: WeaponTimings (val)
    return tick() - a1.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT
end

local function getEquipPulloutDuration(a1) -- Line: 133 -- upvalues: WeaponTimings (val)
    local v1 = a1.Viewmodel.Animation:getAnimation("Equip")
    return WeaponTimings.PulloutSeconds(if not v1 then nil else v1.Length)
end

local function isLocalPlayerDefusing() -- Line: 140 -- upvalues: LocalPlayer (val)
    local v1 = true
    if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
        v1 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
    end
    return v1
end

local function clearFireInputState(a1) -- Line: 146
    a1.IsFireHeld = false
    a1.FireInputBinding = nil
    a1.IsAlternativeFireHeld = false
    a1.AlternativeFireInputBinding = nil
    a1.HasPendingChargeRequest = false
end

local function cancelThreadField(a1, a2) -- Line: 156 -- types: a2: string
    local v1 = a1[a2]
    if v1 then
        task.cancel(v1)
        a1[a2] = nil
    end
end

local function disconnectField(a1, a2) -- Line: 164 -- types: a2: string
    local v1 = a1[a2]
    if v1 and v1.Connected then
        v1:Disconnect()
    end
    a1[a2] = nil
end

local function refreshHeldBinding(a1, a2, a3) -- Line: 173
    -- upvalues: InputController (val)
    local v1 = a1[a3]
    if a1[a2] == true and v1 and not InputController.isBindingPressed(v1) then
        a1[a2] = false
        a1[a3] = nil
    end
    return a1[a2] == true
end

local function playOtherSound(a1) -- Line: 182 -- upvalues: Other (val), LocalPlayer (val) -- types: a1: string
    return Other:play({Parent = LocalPlayer.PlayerGui, Name = a1})
end

local function setSniperScoped(a1, a2) -- Line: 192 -- types: a2: boolean
    if a1.Name == "SSG 08" or a1.Name == "AWP" then
        a1.IsSniperScoped = a2
        if a1.Name == "AWP" and a1.Player then
            a1.Player:SetAttribute("IsSniperScoped", a2)
        end
    end
end

local function restoreDefaultFovUnlessSceneActive() -- Line: 204
    -- upvalues: ReplicatedStorage (val), CameraController (val), Constants (val)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    if not CaseSceneController.IsActive()
        and not MenuSceneController.IsActive()
        and not BlackMarketSceneController.IsActive() then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    end
end

local function getPressedActionBinding(a1, a2) -- Line: 219
    -- upvalues: InputController (val)
    local v1 = InputController.getActionKeybinds(a1)
    for i, v in ipairs(v1) do
        if InputController.isBindingPressed(v) then
            return v
        end
    end
    if a2 and #v1 == 0 then
        for i2, i3 in ipairs(a2) do
            if InputController.isBindingPressed(i3) then
                return i3
            end
        end
    end
    return nil
end

local function isRevolverWeapon(a1) -- Line: 244
    return a1.Properties.ShootingOptions == "Revolver"
end

local function getRevolverFireMode(a1, a2) -- Line: 250
    local FireModes = a1.Properties.FireModes
    if not FireModes then
        return nil
    end
    return not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary
end

local function getActiveFireRate(a1, a2) -- Line: 264
    local FireModes = a1.Properties.FireModes
    local Secondary = if FireModes then not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
    return Secondary and Secondary.FireRate or a1.Properties.FireRate or 0.1
end

local function applyActiveSpreadProfile(a1, a2) -- Line: 271
    if not a1.Bullet then
        return
    end
    local FireModes = a1.Properties.FireModes
    local Secondary = if FireModes then not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
    a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
end

local function buildActiveRecoilPattern(a1, a2) -- Line: 281
    local Recoil = a1.Properties.Recoil
    if not Recoil then
        return nil
    end
    local Properties = a1.Properties
    if a1.Properties.ShootingOptions == "Revolver" and a2 then
        Properties = table.clone(a1.Properties)
        local FireModes = a1.Properties.FireModes
        local Secondary = if FireModes then not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
        local FireRate = Secondary and Secondary.FireRate or a1.Properties.FireRate or 0.1
        Properties.FireRate = FireRate
    end
    return Recoil.Pattern(Properties)
end

local function applyActiveRecoilProfile(a1, a2) -- Line: 296 -- upvalues: buildActiveRecoilPattern (val)
    local Recoil = a1.Recoil
    if not Recoil then
        return
    end
    local v1 = a1.Properties.ShootingOptions == "Revolver" and a2 or "Default"
    local FireModes = a1.Properties.FireModes
    local Secondary = if FireModes then not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
    local FireRate = Secondary and Secondary.FireRate or a1.Properties.FireRate or 0.1
    local v2 = Recoil.Functions[v1]
    if not v2 then
        v2 = buildActiveRecoilPattern(a1, a2)
        if not v2 then
            return
        end
        Recoil.Functions[v1] = v2
    end
    local ActiveFireRate = Recoil.ActiveFireRate
    if ActiveFireRate > 0 and FireRate > 0 and ActiveFireRate ~= FireRate then
        Recoil.Time = Recoil.Time / ActiveFireRate * FireRate
    end
    Recoil.Function = v2
    Recoil.ActiveFireRate = FireRate
end

local function applyActiveWeaponModeProfiles(a1, a2) -- Line: 322 -- upvalues: applyActiveRecoilProfile (val)
    if a1.Bullet then
        local FireModes = a1.Properties.FireModes
        local Secondary = if FireModes then not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
        a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
    end
    applyActiveRecoilProfile(a1, a2)
end

local function applyRevolverRestingWeaponModeProfiles(a1) -- Line: 327 -- upvalues: applyActiveRecoilProfile (val)
    if a1.Properties.ShootingOptions == "Revolver" then
        if a1.Bullet then
            local FireModes = a1.Properties.FireModes
            local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
            a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
        end
        applyActiveRecoilProfile(a1, "Secondary")
    end
end

local function applyRevolverChargeStartSpread(a1, a2) -- Line: 333
    if a1.Bullet and a2 and a2.ChargeStartSpread then
        local Spread = a2.Spread or a1.Properties.Spread
        if not Spread then
            return
        end
        a1.Bullet:setBaseSpreadForConfig(a2.ChargeStartSpread, Spread)
        return
    end
end

local function startRechargeTimer(a1) -- Line: 348 -- upvalues: u193 (ref)
    local RechargeTime = a1.Properties.RechargeTime
    local Rounds = a1.Properties.Rounds
    if RechargeTime and Rounds then
        local RechargeThread = a1.RechargeThread
        if RechargeThread then
            task.cancel(RechargeThread)
            a1.RechargeThread = nil
        end
        if u193 then
            a1.Rounds = Rounds
            a1.RechargeStartTime = nil
            return
        end
        if Rounds <= a1.Rounds then
            a1.RechargeStartTime = nil
            return
        end
        local ServerTimeNow = workspace:GetServerTimeNow()
        local Identifier = a1.Identifier
        local v1 = a1.RechargeStartTime or ServerTimeNow
        local v2 = math.max(RechargeTime - (math.max(ServerTimeNow - v1, 0)), 0)
        a1.RechargeStartTime = v1
        if not (v2 <= 0) then
            a1.RechargeThread = task.delay(v2, function() -- Line: 381 -- upvalues: a1 (val), Identifier (val), Rounds (val)
                if not a1.IsDestroyed and a1.Identifier == Identifier then
                    a1.RechargeThread = nil
                    a1.Rounds = Rounds
                    a1.RechargeStartTime = nil
                    return
                end
            end)
            return
        end
        a1.Rounds = Rounds
        a1.RechargeStartTime = nil
        return
    end
end

local function resolveFireAnimationNames(a1, a2, a3, a4) -- Line: 394 -- types: a2: string, a3: string
    local v1 = a2
    local v2 = a3
    local FireModes = a1.Properties.FireModes
    local Secondary = if FireModes then not (a4 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
    if not Secondary then
        return v1, v2
    end
    local Animation = Secondary.Animation
    if Animation and a1.Viewmodel and a1.Viewmodel.Animation and a1.Viewmodel.Animation:getAnimation(Animation) then
        v1 = Animation
    end
    local CharacterAnimation = Secondary.CharacterAnimation
    if CharacterAnimation and a1.CharacterAnimator and a1.CharacterAnimator:getAnimation(CharacterAnimation) then
        v2 = CharacterAnimation
    end
    return v1, v2
end

local function clearRevolverChargeTracking(a1) -- Line: 432
    local ChargeThread = a1.ChargeThread
    if ChargeThread then
        task.cancel(ChargeThread)
        a1.ChargeThread = nil
    end
    local ChargeShootConnection = a1.ChargeShootConnection
    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect()
    end
    a1.ChargeShootConnection = nil
end

local function resetRevolverChargeState(a1) -- Line: 439
    local ChargeThread = a1.ChargeThread
    if ChargeThread then
        task.cancel(ChargeThread)
        a1.ChargeThread = nil
    end
    local ChargeShootConnection = a1.ChargeShootConnection
    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect()
    end
    a1.ChargeShootConnection = nil
    a1.HasPendingChargeRequest = false
    a1.IsChargeFiring = false
    a1.ChargeStartTick = 0
    a1.CurrentWalkSpeedOverride = nil
end

local function stopRevolverChargeAnimation(a1, a2) -- Line: 450
    -- upvalues: resolveFireAnimationNames (val)
    if a1.Viewmodel and a1.Viewmodel.Animation and a1.CharacterAnimator then
        local v1, v2 = resolveFireAnimationNames(a1, "Shoot", "Shoot", "Primary")
        a1.Viewmodel.Animation:cancelCrossfade()
        a1.Viewmodel.Animation:stop(v1)
        a1.CharacterAnimator:stop(v2)
        if a2 ~= false and a1.IsEquipped then
            a1.Viewmodel.Animation:play("Idle")
            a1.CharacterAnimator:play("Idle")
        end
        return
    end
end

local function completeRevolverChargeShot(a1) -- Line: 470
    -- upvalues: CharacterResolver (val), GameState (val), LocalPlayer (val), applyActiveRecoilProfile (val)
    if not a1.IsDestroyed and a1.IsEquipped and a1.IsChargeFiring then
        local v1 = CharacterResolver.getLocalCharacter()
        local Attribute = not v1 or v1:GetAttribute("Dead")
        if not Attribute and GameState.GetState() ~= "Buy Period" then
            local v2 = true
            if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
                v2 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
            end
            if not v2 then
                a1.CurrentWalkSpeedOverride = nil
                if 0 < a1.Rounds then
                    a1:shoot("Primary")
                    return
                end
                local ChargeThread = a1.ChargeThread
                if ChargeThread then
                    task.cancel(ChargeThread)
                    a1.ChargeThread = nil
                end
                local ChargeShootConnection = a1.ChargeShootConnection
                if ChargeShootConnection and ChargeShootConnection.Connected then
                    ChargeShootConnection:Disconnect()
                end
                a1.ChargeShootConnection = nil
                a1.HasPendingChargeRequest = false
                a1.IsChargeFiring = false
                a1.ChargeStartTick = 0
                a1.CurrentWalkSpeedOverride = nil
                if a1.Properties.ShootingOptions == "Revolver" then
                    if a1.Bullet then
                        local FireModes = a1.Properties.FireModes
                        local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
                        a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
                    end
                    applyActiveRecoilProfile(a1, "Secondary")
                end
                a1:reload()
                return
            end
        end
        a1:cancelRevolverCharge(false, not Attribute)
        return
    end
end

local function scheduleInspectEnd(a1, a2) -- Line: 496 -- types: a2: number
    a1.InspectDelayThread = task.delay(a2, function() -- Line: 497 -- upvalues: a1 (val)
        if not a1.IsDestroyed then
            a1.InspectDelayThread = nil
            a1.IsInspecting = false
        end
    end)
end

local function resetActionState(a1) -- Line: 507
    a1.IsFireHeld = false
    a1.FireInputBinding = nil
    a1.IsAlternativeFireHeld = false
    a1.AlternativeFireInputBinding = nil
    a1.HasPendingChargeRequest = false
    a1.IsBurstShooting = false
    a1.IsInspectFadingOut = false
    a1.IsInspecting = false
    a1.IsReloading = false
    a1.IsShooting = false
    a1.IsAiming = false
    a1.IsChargeFiring = false
    a1.IsAdjustingSuppressor = false
    a1.CurrentWalkSpeedOverride = nil
    a1.ChargeStartTick = 0
    a1.ChargeThread = nil
    a1.ChargeShootConnection = nil
end

local function adjustSuppressor(a1, a2, a3, a4) -- Line: 525
    -- upvalues: WeaponTimings (val), ReplicateCharacterAction (val)
    if not (tick() - a1.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT)
        and not a1.IsAdjustingSuppressor
        and not a1.IsShooting
        and not a1.IsReloading
        and not a1.IsAiming then
        a1.IsAdjustingSuppressor = true
        a1.IsBurstShooting = false
        a1.IsInspecting = false
        a1.IsReloading = false
        a1.IsShooting = false
        a1.IsAiming = false
        if a4 then
            a1.ScopeStartTick = 0
        end
        a1:stopAllAnimations()
        a1.Viewmodel.Animation:play(a2)
        a1.CharacterAnimator:play(a2)
        ReplicateCharacterAction(a3)
        return
    end
end

function u0.getSpread(a1) -- Line: 547
    return a1.Bullet:getTrueSpread()
end

function u0.getCrosshairDisplayState(a1) -- Line: 553
    return nil
end

function u0:getBaseSpread() -- Line: 559
    return self.Bullet:getBaseSpread()
end

function u0:cancelRevolverCharge(a2, a3) -- Line: 565
    -- upvalues: applyActiveRecoilProfile (val), stopRevolverChargeAnimation (val), ReplicateCharacterAction (val)
    local IsChargeFiring = self.IsChargeFiring
    local ChargeThread = self.ChargeThread
    if ChargeThread then
        task.cancel(ChargeThread)
        self.ChargeThread = nil
    end
    local ChargeShootConnection = self.ChargeShootConnection
    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect()
    end
    self.ChargeShootConnection = nil
    self.HasPendingChargeRequest = false
    self.IsChargeFiring = false
    self.ChargeStartTick = 0
    self.CurrentWalkSpeedOverride = nil
    if self.Properties.ShootingOptions == "Revolver" then
        if self.Bullet then
            local FireModes = self.Properties.FireModes
            local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
            self.Bullet:setSpreadConfig(Secondary and Secondary.Spread or self.Properties.Spread)
        end
        applyActiveRecoilProfile(self, "Secondary")
    end
    if IsChargeFiring then
        stopRevolverChargeAnimation(self, a3)
        if a3 ~= false and self.IsEquipped and not self.IsDestroyed then
            ReplicateCharacterAction("RevolverChargeCancel")
        end
    end
    if a2 ~= true then
        self.IsFireHeld = false
        self.FireInputBinding = nil
    end
end

function u0:startRevolverCharge(a2) -- Line: 585
    -- upvalues: WeaponTimings (val), CharacterResolver (val), GameState (val), LocalPlayer (val)
    -- upvalues: applyActiveRecoilProfile (val), resolveFireAnimationNames (val), completeRevolverChargeShot (val)
    -- upvalues: Remotes (val), ReplicateCharacterAction (val)
    if not (self.Properties.ShootingOptions == "Revolver") then
        return
    end
    local FireModes = self.Properties.FireModes
    local Primary = if FireModes then FireModes.Primary else nil
    if Primary and Primary.InputBehavior == "Charge" then
        self:stopRevolverSecondaryFire()
        local v1 = tick() - self.WeaponEquippedTick
        local v2 = self.Viewmodel.Animation:getAnimation("Equip")
        local PulloutSeconds = WeaponTimings.PulloutSeconds
        if v1 <= PulloutSeconds(if not v2 then nil else v2.Length) then
            return
        end
        v1 = CharacterResolver.getLocalCharacter()
        if v1 and v1:GetAttribute("Dead") then
            return
        end
        if GameState.GetState() ~= "Buy Period" then
            local v3 = true
            if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
                v3 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
            end
            if not v3 then
                if not self.IsAdjustingSuppressor and not self.IsReloading and not self.IsChargeFiring then
                    if self.IsShooting then
                        v3 = tick() - self.ShootRequestTick
                        local FireModes_2 = self.Properties.FireModes
                        local Primary_2 = if FireModes_2 then FireModes_2.Primary else nil
                        local FireRate = Primary_2 and Primary_2.FireRate or self.Properties.FireRate or 0.1
                        if (math.max(0, FireRate - v3)) <= 0.15 then
                            self.IsFireHeld = true
                            self.FireInputBinding = a2
                            self.HasPendingChargeRequest = true
                        end
                        return
                    end
                    if self.Rounds <= 0 then
                        self.IsFireHeld = false
                        self.FireInputBinding = nil
                        self:reload()
                        return
                    end
                    self.IsFireHeld = true
                    self.FireInputBinding = a2
                    self.HasPendingChargeRequest = false
                    self.IsChargeFiring = true
                    self.ChargeStartTick = tick()
                    local HoldWalkSpeed = Primary.HoldWalkSpeed or self.Properties.WalkSpeed
                    self.CurrentWalkSpeedOverride = HoldWalkSpeed
                    if self.Bullet then
                        local FireModes_3 = self.Properties.FireModes
                        local Primary_3 = if FireModes_3 then FireModes_3.Primary else nil
                        self.Bullet:setSpreadConfig(Primary_3 and Primary_3.Spread or self.Properties.Spread)
                    end
                    applyActiveRecoilProfile(self, "Primary")
                    if self.Bullet and Primary and Primary.ChargeStartSpread then
                        local Spread_2 = Primary.Spread or self.Properties.Spread
                        if Spread_2 then
                            self.Bullet:setBaseSpreadForConfig(Primary.ChargeStartSpread, Spread_2)
                        end
                    end
                    if self.IsInspecting or self.IsInspectFadingOut then
                        self:cancelInspect(nil, nil, true)
                    end
                    local ChargeThread = self.ChargeThread
                    if ChargeThread then
                        task.cancel(ChargeThread)
                        self.ChargeThread = nil
                    end
                    local ChargeShootConnection = self.ChargeShootConnection
                    if ChargeShootConnection and ChargeShootConnection.Connected then
                        ChargeShootConnection:Disconnect()
                    end
                    self.ChargeShootConnection = nil
                    self:stopAllAnimations()
                    v3, v2 = resolveFireAnimationNames(self, "Shoot", "Shoot", "Primary")
                    local v4 = self.Viewmodel.Animation:play(v3)
                    if v4 then
                        v4:AdjustSpeed(1)
                        self.ChargeShootConnection = (v4:GetMarkerReachedSignal("Shoot")):Connect(function() -- Line: 655 -- upvalues: completeRevolverChargeShot (upval), self (val)
                            completeRevolverChargeShot(self)
                        end)
                    end
                    local v5 = self.CharacterAnimator:play(v2)
                    if v5 then
                        v5:AdjustSpeed(1)
                    end
                    Remotes.Sound.ReplicateSound.Send({Name = "Prepare", Class = self.Name})
                    ReplicateCharacterAction("RevolverChargeStart")
                    if not v4 then
                        self.ChargeThread = task.delay(Primary.ChargeTime or 0, function() -- Line: 672 -- upvalues: completeRevolverChargeShot (upval), self (val)
                            completeRevolverChargeShot(self)
                        end)
                    end
                    return
                end
                return
            end
        end
        self.IsFireHeld = false
        self.FireInputBinding = nil
        self.IsAlternativeFireHeld = false
        self.AlternativeFireInputBinding = nil
        self.HasPendingChargeRequest = false
        return
    end
end

function u0:startRevolverSecondaryFire(a2) -- Line: 680
    -- upvalues: GameState (val), LocalPlayer (val), applyActiveRecoilProfile (val)
    if not (self.Properties.ShootingOptions == "Revolver") then
        return
    end
    if GameState.GetState() ~= "Buy Period" then
        local v1 = true
        if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
            v1 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
        end
        if not v1 then
            self:cancelRevolverCharge(false, false)
            self.IsAlternativeFireHeld = true
            self.AlternativeFireInputBinding = a2
            if self.Bullet then
                local FireModes = self.Properties.FireModes
                local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
                self.Bullet:setSpreadConfig(Secondary and Secondary.Spread or self.Properties.Spread)
            end
            applyActiveRecoilProfile(self, "Secondary")
            if not self.IsShooting and not self.IsReloading and not self.IsAdjustingSuppressor then
                if 0 < self.Rounds then
                    self:shoot("Secondary")
                    return
                end
                self:reload()
                return
            end
            return
        end
    end
    self.IsFireHeld = false
    self.FireInputBinding = nil
    self.IsAlternativeFireHeld = false
    self.AlternativeFireInputBinding = nil
    self.HasPendingChargeRequest = false
end

function u0:stopRevolverSecondaryFire() -- Line: 708 -- upvalues: applyActiveRecoilProfile (val)
    self.IsAlternativeFireHeld = false
    self.AlternativeFireInputBinding = nil
    if not self.IsChargeFiring and self.Properties.ShootingOptions == "Revolver" then
        if self.Bullet then
            local FireModes = self.Properties.FireModes
            local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
            self.Bullet:setSpreadConfig(Secondary and Secondary.Spread or self.Properties.Spread)
        end
        applyActiveRecoilProfile(self, "Secondary")
    end
end

function u0:stopAllAnimations() -- Line: 718
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

function u0.removeSuppressor(a1) -- Line: 738 -- upvalues: adjustSuppressor (val)
    adjustSuppressor(a1, "RemoveSuppressor", "Remove Suppressor", true)
end

function u0.addSuppressor(a1) -- Line: 742 -- upvalues: adjustSuppressor (val)
    adjustSuppressor(a1, "AddSuppressor", "Add Suppressor", false)
end

function u0:scope(a2) -- Line: 748
    -- upvalues: WeaponTimings (val), Other (val), LocalPlayer (val), CameraController (val), Constants (val)
    -- upvalues: u178 (val), Remotes (val)
    if self.Viewmodel then
        local v1 = tick() - self.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT
        if not v1 then
            v1 = self.Properties.AimingOptions == "AutomaticScope"
            if not self.IsAdjustingSuppressor and not self.IsReloading then
                if self.IsShooting and not v1 then
                    return
                end
                if not self.IsDestroyed then
                    if self.Properties.HasScope then
                        if not self.IsAiming then
                            self:stopAllAnimations()
                        end
                        self.IsBurstShooting = false
                        self.IsInspecting = false
                        self.IsReloading = false
                        self.IsShooting = false
                        if not self.IsAiming then
                            self.ScopeStartTick = tick()
                        end
                        self.IsAiming = true
                        if self.Name == "SSG 08" or self.Name == "AWP" then
                            self.IsSniperScoped = true
                            if self.Name == "AWP" and self.Player then
                                self.Player:SetAttribute("IsSniperScoped", true)
                            end
                        end
                        if self.Properties.AimingOptions == "SniperScope" then
                            if not self.Viewmodel.Hidden then
                                self.Viewmodel:hide()
                            end
                            Other:play({Name = "Toggle Scope", Parent = LocalPlayer.PlayerGui})
                            local CurrentScopeIncrement = 1
                            if a2 then
                                self.CurrentScopeIncrement = self.CurrentScopeIncrement + 1
                                if 3 <= self.CurrentScopeIncrement then
                                    self:unscope(nil, nil, "Toggle Scope")
                                    return
                                end
                                CurrentScopeIncrement = self.CurrentScopeIncrement
                            end
                            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - u178[CurrentScopeIncrement])
                            Remotes.Inventory.UpdateScopeIncrement.Send({SoundName = "Toggle Scope", Increment = CurrentScopeIncrement})
                            return
                        end
                        if self.Properties.AimingOptions == "AutomaticScope" then
                            if self.CurrentScopeIncrement == 1 then
                                self:unscope()
                                return
                            end
                            self.CurrentScopeIncrement = 1
                            if not self.Viewmodel.Hidden then
                                self.Viewmodel:hide()
                            end
                            self.Viewmodel:aim()
                            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * self.CurrentScopeIncrement)
                            Remotes.Inventory.UpdateScopeIncrement.Send({SoundName = "Scope In", Increment = self.CurrentScopeIncrement})
                            Other:play({Name = "Scope In", Parent = LocalPlayer.PlayerGui})
                        end
                    end
                    return
                end
            end
            return
        end
    end
end

function u0:unscope(a2, a3, a4) -- Line: 830
    -- upvalues: WeaponTimings (val), Remotes (val), restoreDefaultFovUnlessSceneActive (val), CameraController (val)
    -- upvalues: Constants (val), Other (val), LocalPlayer (val)
    local v1
    if a3 then
        if self.Properties.HasScope then
            if self.IsAiming then
                self:stopAllAnimations()
            end
            if 0 < self.CurrentScopeIncrement or self.IsAiming then
                v1 = a4
                if v1 == nil and self.Properties.AimingOptions == "AutomaticScope" then
                    v1 = "Scope Out"
                end
                Remotes.Inventory.UpdateScopeIncrement.Send({Increment = 0, SoundName = v1})
            end
            if not a2 then
                self.CurrentScopeIncrement = 0
            end
            self.IsInspecting = false
            self.IsReloading = false
            self.IsAiming = false
            self.ScopeStartTick = 0
            if self.Name == "SSG 08" or self.Name == "AWP" then
                self.IsSniperScoped = false
                if self.Name == "AWP" and self.Player then
                    self.Player:SetAttribute("IsSniperScoped", false)
                end
            end
            if self.Properties.AimingOptions == "SniperScope" then
                if self.Viewmodel.Hidden then
                    self.Viewmodel:unhide()
                end
                restoreDefaultFovUnlessSceneActive()
                if a2 then
                    self.CurrentScopeIncrement = math.clamp(self.CurrentScopeIncrement - 1, 0, 3)
                    return
                end
            elseif self.Properties.AimingOptions == "AutomaticScope" then
                self.CurrentScopeIncrement = 0
                self.Viewmodel:unaim()
                if self.Viewmodel.Hidden then
                    self.Viewmodel:unhide()
                end
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * self.CurrentScopeIncrement)
                Other:play({Name = "Scope Out", Parent = LocalPlayer.PlayerGui})
            end
        end
        return
    end
    v1 = tick() - self.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT
    if not v1 and not self.IsAdjustingSuppressor then
        if self.Properties.HasScope then
            if self.IsAiming then
                self:stopAllAnimations()
            end
            if 0 < self.CurrentScopeIncrement or self.IsAiming then
                v1 = a4
                if v1 == nil and self.Properties.AimingOptions == "AutomaticScope" then
                    v1 = "Scope Out"
                end
                Remotes.Inventory.UpdateScopeIncrement.Send({Increment = 0, SoundName = v1})
            end
            if not a2 then
                self.CurrentScopeIncrement = 0
            end
            self.IsInspecting = false
            self.IsReloading = false
            self.IsAiming = false
            self.ScopeStartTick = 0
            if self.Name == "SSG 08" or self.Name == "AWP" then
                self.IsSniperScoped = false
                if self.Name == "AWP" and self.Player then
                    self.Player:SetAttribute("IsSniperScoped", false)
                end
            end
            if self.Properties.AimingOptions == "SniperScope" then
                if self.Viewmodel.Hidden then
                    self.Viewmodel:unhide()
                end
                restoreDefaultFovUnlessSceneActive()
                if a2 then
                    self.CurrentScopeIncrement = math.clamp(self.CurrentScopeIncrement - 1, 0, 3)
                    return
                end
            elseif self.Properties.AimingOptions == "AutomaticScope" then
                self.CurrentScopeIncrement = 0
                self.Viewmodel:unaim()
                if self.Viewmodel.Hidden then
                    self.Viewmodel:unhide()
                end
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * self.CurrentScopeIncrement)
                Other:play({Name = "Scope Out", Parent = LocalPlayer.PlayerGui})
            end
        end
        return
    end
end

function u0:cancelInspect(a2, a3, a4) -- Line: 888 -- types: a2: number?, a3: number?, a4: boolean?
    if not self.IsInspecting and not self.IsInspectFadingOut then
        return
    end
    local InspectDelayThread = self.InspectDelayThread
    if InspectDelayThread then
        task.cancel(InspectDelayThread)
        self.InspectDelayThread = nil
    end
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
    if a4 then
        self.IsInspecting = false
        self.IsInspectFadingOut = false
        self.Viewmodel.Animation:markInspectCancel()
        self.Viewmodel.Animation:cancelCrossfade()
        return
    end
    local u50 = a2 or 0.25
    self.IsInspectFadingOut = true
    self.IsInspecting = false
    self.Viewmodel.Animation:markInspectCancel()
    self.CancelDelayThread = task.delay(a3 or 0.3, function() -- Line: 917 -- upvalues: self (val), u50 (val)
        if self.IsDestroyed or not self.IsInspectFadingOut then
            return
        end
        self.Viewmodel.Animation:crossfadeTo("Idle", u50)
        self.FadeCompleteThread = task.delay(u50, function() -- Line: 929 -- upvalues: self (upval)
            if not self.IsDestroyed then
                self.FadeCompleteThread = nil
                self.IsInspectFadingOut = false
            end
        end)
    end)
end

function u0.inspect(a1) -- Line: 940 -- upvalues: WeaponTimings (val), ReplicateCharacterAction (val)
    if tick() - a1.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return
    end
    if a1.IsChargeFiring then
        a1:cancelRevolverCharge(false, false)
    end
    a1:stopRevolverSecondaryFire()
    if not a1.IsAdjustingSuppressor and not a1.IsShooting and not a1.IsReloading and not a1.IsAiming then
        local v1, v2
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
        a1.IsBurstShooting = false
        a1.IsInspecting = true
        a1.IsReloading = false
        a1.IsShooting = false
        a1.ScopeStartTick = 0
        a1.IsAiming = false
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
            a1.InspectDelayThread = task.delay(v2.Length, function() -- Line: 497 -- upvalues: a1 (val)
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
            a1.InspectDelayThread = task.delay(v2.Length, function() -- Line: 497 -- upvalues: a1 (val)
                if not a1.IsDestroyed then
                    a1.InspectDelayThread = nil
                    a1.IsInspecting = false
                end
            end)
        end
        return
    end
end

function u0.fireBurst(a1) -- Line: 1002 -- upvalues: WeaponTimings (val), HintController (val)
    a1.IsBurstShooting = true
    task.spawn(function() -- Line: 1005 -- upvalues: WeaponTimings (upval), a1 (val), HintController (upval)
        local BURST_SHOT_COUNT = WeaponTimings.BURST_SHOT_COUNT
        for i = 1, BURST_SHOT_COUNT do
            if not a1.IsEquipped then
                break
            end
            a1:shoot()
            if a1.Rounds <= 0 then
                HintController:createHint("Reload")
            end
            task.wait(WeaponTimings.BURST_SHOT_INTERVAL)
        end
        task.wait(WeaponTimings.BURST_COOLDOWN)
        a1.IsBurstShooting = false
    end)
end

function u0.updateFireMode(a1) -- Line: 1027
    -- upvalues: WeaponTimings (val), Other (val), LocalPlayer (val), ReplicateCharacterAction (val), Router (val)
    if tick() - a1.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return
    end
    if not a1.IsShooting and not a1.IsReloading and not a1.IsBurstShooting and not a1.IsChargeFiring then
        Other:play({Name = "Switch Fire Mode", Parent = LocalPlayer.PlayerGui})
        a1:stopAllAnimations()
        a1.Viewmodel.Animation:play("Switch")
        a1.AlternativeSwitchTick = tick()
        a1.AlternativeShootingOption = if a1.AlternativeShootingOption ~= "Burst" then "Burst" else "Default"
        ReplicateCharacterAction("Switch Fire Mode")
        local v1 = if not a1.Properties.Automatic then "Switched to semi-automatic" else "Switched to automatic"
        Router.broadcastRouter(
            "CreateNotification",
            "Switched Fire Mode",
            not (a1.AlternativeShootingOption ~= "Default") and v1 or "Switched to burst-fire mode",
            2.5
        )
        return
    end
end

function u0.drop(a1) -- Line: 1062
    -- upvalues: GameState (val), IsTutorialMode (val), Remotes (val), GetCharacterVelocity (val)
    -- upvalues: CharacterResolver (val), CurrentCamera (val)
    if workspace:GetAttribute("Gamemode") ~= "Deathmatch"
        and GameState.GetState() ~= "Warmup"
        and not IsTutorialMode()
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

function u0:reload() -- Line: 1083
    -- upvalues: IsTutorialMode (val), WeaponTimings (val), playOtherSound (val), HttpService (val)
    -- upvalues: ReplicateCharacterAction (val), Remotes (val), HintController (val)
    local Attribute = workspace:GetAttribute("Gamemode")
    local u8 = true
    if Attribute ~= "Deathmatch" then
        u8 = IsTutorialMode()
    end
    local u15 = u8
    if u15 then
        u15 = self.Properties.ReloadAnimationCount == 1
    end
    if tick() - self.WeaponEquippedTick <= WeaponTimings.EQUIP_ACTION_LOCKOUT then
        return
    end
    if self.IsChargeFiring then
        self:cancelRevolverCharge(false, false)
    end
    self:stopRevolverSecondaryFire()
    if not self.IsAdjustingSuppressor and not self.IsReloading and not self.IsShooting then
        if self.Properties.Rounds ~= self.Rounds and not self.Properties.RechargeTime then
            if self.Capacity <= 0 and not u15 then
                if self.IsInspecting or self.IsInspectFadingOut then
                    self:cancelInspect(0.25)
                end
                return playOtherSound("No Ammo")
            end
            if self.IsAiming then
                self:unscope()
            end
            if self.Properties.Rounds and self.Properties.ReloadAnimationCount then
                local v1
                if self.IsInspecting or self.IsInspectFadingOut then
                    self:cancelInspect(nil, nil, true)
                end
                self:stopAllAnimations()
                self.ReloadStartTick = tick()
                self.IsBurstShooting = false
                self.IsInspecting = false
                self.IsReloading = true
                self.IsShooting = false
                self.CurrentWalkSpeedOverride = nil
                if not (1 < self.Properties.ReloadAnimationCount) then
                    local u213 = HttpService:GenerateGUID(false)
                    self.CurrentReloadIdentity = u213
                    local u219 = self.Viewmodel.Animation:play("Reload")
                    assert(u219, (("Client failed to fetch reload animation for %*."):format(self.Name)))
                    self.CharacterAnimator:play("Reload")
                    ReplicateCharacterAction("Reload")
                    ;(u219:GetMarkerReachedSignal("MagOut")):Once(function() -- Line: 1187 -- upvalues: Remotes (upval), self (val)
                        Remotes.Inventory.CreateMagazine.Send(self.Identifier)
                    end)
                    ;(u219:GetMarkerReachedSignal("MagIn")):Once(function() -- Line: 1190
                        -- upvalues: self (val), u213 (val), Remotes (upval), HintController (upval), u15 (val)
                        -- upvalues: u8 (val)
                        local v1 = self
                        local v2 = not v1.IsDestroyed and v1.IsEquipped == true
                        if v2 and self.CurrentReloadIdentity == u213 then
                            v2 = math.abs(self.Properties.Rounds - self.Rounds)
                            Remotes.Inventory.ReloadWeapon.Send({
                                Identifier = self.Identifier,
                                Rounds = self.Rounds,
                                Capacity = self.Capacity,
                            })
                            HintController:clearHint("Reload")
                            if u15 then
                                self.Rounds = self.Properties.Rounds
                                self.Capacity = self.Properties.Capacity
                                return
                            end
                            if 0 < self.Capacity - v2 then
                                self.Rounds = self.Properties.Rounds
                                if u8 then
                                    return
                                end
                                self.Capacity = math.max(0, self.Capacity - v2)
                                return
                            end
                            if self.Capacity - v2 <= 0 then
                                self.Rounds = self.Rounds + self.Capacity
                                if not u8 then
                                    self.Capacity = 0
                                end
                            end
                            return
                        end
                    end)
                    local ReloadTrackFinishedConnection = self.ReloadTrackFinishedConnection
                    if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
                        ReloadTrackFinishedConnection:Disconnect()
                    end
                    self.ReloadTrackFinishedConnection = nil
                    self.ReloadTrackFinishedConnection = (u219:GetPropertyChangedSignal("IsPlaying")):Connect(function() -- Line: 1217 -- upvalues: self (val), u219 (val)
                        if self.IsDestroyed then
                            return
                        end
                        if not u219.IsPlaying and self.WeaponEquippedTick < self.ReloadStartTick then
                            self.IsReloading = false
                        end
                        local v1 = self
                        local ReloadTrackFinishedConnection = v1.ReloadTrackFinishedConnection
                        if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
                            ReloadTrackFinishedConnection:Disconnect()
                        end
                        v1.ReloadTrackFinishedConnection = nil
                    end)
                    return
                end
                local u97 = self.Properties.Rounds / self.Properties.ReloadAnimationCount
                local u168 = HttpService:GenerateGUID(false)
                self.CurrentReloadIdentity = u168
                task.wait((self.Viewmodel.Animation:play("ReloadStart")).Length * 0.75)
                for i = 1, (math.ceil((self.Properties.Rounds - self.Rounds) / u97)) do
                    if self.IsReloading and self.CurrentReloadIdentity == u168 then
                        if self.Properties.Rounds <= self.Rounds then
                            break
                        end
                        v1 = self.Viewmodel.Animation:play("ReloadAction")
                        if not v1 then
                            error((("Client failed to fetch reload animation for %*."):format(self.Name)))
                        end
                        continue
                    end
                    return
                end
                if self.IsReloading and self.CurrentReloadIdentity == u168 then
                    (self.Viewmodel.Animation:play("ReloadEnd")).Ended:Once(function() -- Line: 1176 -- upvalues: self (val)
                        self.IsReloading = false
                    end)
                    return
                end
                return
            end
            return
        end
        if self.IsInspecting or self.IsInspectFadingOut then
            self:cancelInspect(0.25)
        end
        return
    end
end

function u0:shoot(a2) -- Line: 1232
    -- upvalues: LocalPlayer (val), WeaponTimings (val), CharacterResolver (val), GameState (val), u0 (ref), u204 (val)
    -- upvalues: Other (val), CameraController (val), u193 (ref), resolveFireAnimationNames (val)
    -- upvalues: startRechargeTimer (val), SoundController (val), Router (val), applyActiveRecoilProfile (val)
    -- upvalues: Remotes (val), DataController (val), CreateZeusBeam (val), Camera (val), CreateTracer (val)
    -- upvalues: CreateImpact (val), CreateBloodSplatter (val), botVictimKey (val), PlayerHitPrediction (val)
    -- upvalues: BreakGlass (val), CreateMarker (val), GetWeaponCameraKick (val), ReplicateCharacterAction (val)
    -- upvalues: HapticsController (val), InputController (val)
    local FireRate
    local v1 = a2 or "Primary"
    local FireModes = self.Properties.FireModes
    local Secondary = if FireModes then not (v1 ~= "Secondary") and FireModes.Secondary or FireModes.Primary else nil
    if not Secondary then
        FireRate = self.Properties.FireRate
        if not FireRate then
            FireRate = 0.1
        end
    else
        FireRate = Secondary.FireRate
        if not FireRate then
            FireRate = self.Properties.FireRate
            if not FireRate then
                FireRate = 0.1
            end
        end
    end
    local IsChargeFiring = self.Properties.ShootingOptions == "Revolver"
    if IsChargeFiring then
        IsChargeFiring = false
        if v1 == "Primary" then
            IsChargeFiring = self.IsChargeFiring
        end
    end
    local v2 = self.Viewmodel.Animation:getAnimation("Equip")
    local v3 = true
    if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
        v3 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
    end
    if v3 then
        self.IsFireHeld = false
        self.FireInputBinding = nil
        self.IsAlternativeFireHeld = false
        self.AlternativeFireInputBinding = nil
        self.HasPendingChargeRequest = false
        if self.IsChargeFiring then
            self:cancelRevolverCharge(false, false)
        end
        return
    end
    if not (tick() - self.WeaponEquippedTick <= v2.Length * WeaponTimings.EQUIP_PULLOUT_FRACTION) then
        if CharacterResolver.getLocalCharacter() and CharacterResolver.getLocalCharacter():GetAttribute("Dead") then
            return
        end
        if GameState.GetState() == "Buy Period" then
            return
        end
        if not pcall(function() -- Line: 1259 -- upvalues: self (val)
            local Properties
            Properties = self.Properties
            Properties.FireRate = Properties.FireRate + 1e-07
            return
        end) then
            local BulletsPerShot_2, ChargeShootConnection, ChargeThread, Exit, FireModes_2, FireModes_3, Instance, Interactables, IsAiming, IsAiming_3, Material, MuzzlePartL, NextShotDue, Normal, Parent, Pivot, Position, Position_3, Recoil, Rounds, Secondary_2, Secondary_3, ShootDelayThread, ShootRequestTick, UserId, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
            if u204 and u204[self.Name] then
                v22 = u204[self.Name]
                if not (self.Properties.FireRate < v22.FireRate)
                    and not (v22.BulletsPerShot < self.Properties.BulletsPerShot)
                    and not (v22.Range < self.Properties.Range)
                    and not (v22.Penetration < self.Properties.Penetration) then
                    if self.Properties.FireRate
                        and self.Properties.BulletsPerShot
                        and not self.IsAdjustingSuppressor then
                        if self.IsReloading and self.Properties.MuzzleType ~= "ShotGun" then
                            return
                        end
                        v22 = CharacterResolver.getPlayerCharacter(self.Player)
                        if v22 and self.CharacterAnimator then
                            if self.AlternativeShootingOption ~= "Burst" then
                                self.ShootRequestTick = tick()
                            end
                            if self.IsShooting and self.AlternativeShootingOption == "Default" then
                                return
                            end
                            Interactables = self.Viewmodel.Model:FindFirstChild("Interactables")
                            if not Interactables then
                                return
                            end
                            if self.Rounds <= 0 then
                                self:reload()
                                return
                            end
                            Rounds = self.Properties.Rounds
                            if Rounds and self.Rounds <= Rounds * 0.2 then
                                Other:play({Name = "Low Ammo Fire", Parent = LocalPlayer.PlayerGui})
                            end
                            v4 = if not self.IsAiming then "Shoot" else if self.Properties.AimingOptions ~= "AutomaticScope" then "Shoot" else "AimShoot"
                            v5 = if not self.Properties.HasSuppressor then "Shoot" else if self.IsSuppressed then "Shoot" else "NoSuppressorShoot"
                            CameraController.toWeaponFirePosition()
                            if not IsChargeFiring then
                                if self.IsInspecting or self.IsInspectFadingOut then
                                    self:cancelInspect(nil, nil, true)
                                end
                            end
                            if not IsChargeFiring then
                                self:stopAllAnimations()
                            end
                            self.CurrentReloadIdentity = nil
                            self.IsInspecting = false
                            self.IsInspectFadingOut = false
                            self.IsReloading = false
                            self.IsShooting = true
                            ChargeThread = self.ChargeThread
                            if ChargeThread then
                                task.cancel(ChargeThread)
                                self.ChargeThread = nil
                            end
                            ChargeShootConnection = self.ChargeShootConnection
                            if ChargeShootConnection and ChargeShootConnection.Connected then
                                ChargeShootConnection:Disconnect()
                            end
                            self.ChargeShootConnection = nil
                            self.HasPendingChargeRequest = false
                            self.IsChargeFiring = false
                            self.ChargeStartTick = 0
                            self.CurrentWalkSpeedOverride = nil
                            if not u193 then
                                self.Rounds = self.Rounds - 1
                            end
                            self.RechargeStartTime = workspace:GetServerTimeNow()
                            if self.Properties.ShootingOptions == "Dual" then
                                self.ShootingHand = if self.ShootingHand ~= "Left" then "Left" else "Right"
                                v4 = "Shoot" .. self.ShootingHand
                                v5 = "Shoot" .. self.ShootingHand
                            end
                            v6, v7 = resolveFireAnimationNames(self, v5, v4, v1)
                            v8 = if not IsChargeFiring then self.Viewmodel.Animation:pickVariant(v6) else v6
                            if self.Properties.MuzzleType ~= "ShotGun" then
                                self.CharacterAnimator:adjustAnimationSpeed(v7, FireRate)
                            end
                            if 150 < self.Rounds then
                                return
                            end
                            startRechargeTimer(self)
                            Router.broadcastRouter(
                                "UpdatePlayerNoiseCone",
                                "Weapon",
                                v22.PrimaryPart.Position,
                                SoundController.GetWeaponShootRange(
                                    self.Name,
                                    (self.Properties.HasSuppressor and self.IsSuppressed) == true
                                ),
                                nil
                            )
                            if self.Bullet then
                                FireModes_2 = self.Properties.FireModes
                                Secondary_2 = if FireModes_2 then not (v1 ~= "Secondary") and FireModes_2.Secondary or FireModes_2.Primary else nil
                                self.Bullet:setSpreadConfig(Secondary_2 and Secondary_2.Spread or self.Properties.Spread)
                            end
                            applyActiveRecoilProfile(self, v1)
                            MuzzlePartL = if self.Properties.ShootingOptions ~= "Dual" then Interactables.MuzzlePart else not (self.ShootingHand ~= "Left") and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR") or Interactables.MuzzlePart
                            Position_3 = MuzzlePartL.Position
                            v9 = {}
                            v10 = {}
                            debug.profilebegin("Weapon.BuildShootPacket")
                            BulletsPerShot_2 = self.Properties.BulletsPerShot
                            for i52 = 1, BulletsPerShot_2 do
                                v13 = self.Bullet:create(self.Properties.AimingOptions, self.IsAiming)
                                if v13 then
                                    table.insert(v9, v13)
                                    table.insert(v10, {Direction = v13.Direction, Origin = v13.Origin})
                                end
                            end
                            debug.profileend()
                            if IsChargeFiring and self.Properties.ShootingOptions == "Revolver" then
                                if self.Bullet then
                                    FireModes_3 = self.Properties.FireModes
                                    Secondary_3 = if FireModes_3 then FireModes_3.Secondary or FireModes_3.Primary else nil
                                    self.Bullet:setSpreadConfig(Secondary_3 and Secondary_3.Spread or self.Properties.Spread)
                                end
                                applyActiveRecoilProfile(self, "Secondary")
                            end
                            debug.profilebegin("Weapon.SendShootPacket")
                            self.ShotSeq = self.ShotSeq + 1
                            Remotes.Inventory.ShootWeapon.Send({
                                IsSniperScoped = self.IsSniperScoped,
                                ShootingHand = self.ShootingHand,
                                Identifier = self.Identifier,
                                Seq = self.ShotSeq,
                                Bullets = v10,
                                ViewTick = Router.broadcastRouter("GetRemoteViewTick"),
                            })
                            debug.profileend()
                            debug.profilebegin("Weapon.ShootVFX")
                            v11 = DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false
                            v12 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false
                            if v12 then
                                IsAiming_3 = false
                                if self.Properties.AimingOptions == "AutomaticScope" then
                                    IsAiming_3 = self.IsAiming
                                end
                                v12 = not IsAiming_3
                            end
                            v13 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true
                            if self.Properties.MuzzleType == "Zeus x27" then
                                CreateZeusBeam(MuzzlePartL)
                            end
                            if v12 and #v9 > 0 then
                                Camera(
                                    MuzzlePartL,
                                    if not self.Properties.HasSuppressor then self.Properties.MuzzleType else if not self.IsSuppressed then self.Properties.MuzzleType else "Suppressor"
                                )
                            end
                            for i6, i62 in ipairs(v9) do
                                v18 = false
                                if v11 then
                                    CreateTracer(i62.Distance, Position_3, i62.Direction)
                                end
                                v19 = false
                                for i7, i72 in ipairs(i62.Hits) do
                                    Instance = i72.Instance
                                    Position = i72.Position
                                    Material = i72.Material
                                    Normal = i72.Normal
                                    Exit = i72.Exit
                                    v21 = Instance and Instance:FindFirstAncestorOfClass("Model")
                                    v20 = false
                                    if v21 ~= nil then
                                        v20 = true
                                        if CharacterResolver.getPlayerFromCharacter(v21) == nil then
                                            v20 = true
                                            if v21:GetAttribute("Bot") ~= true then
                                                v20 = CharacterResolver.isTutorialDummy(v21)
                                            end
                                        end
                                    end
                                    if not v20 then
                                        if not Exit then
                                            v19 = true
                                        end
                                        if not v14 then
                                            v20 = not Exit and not v18
                                            if v20 then
                                                v18 = true
                                            end
                                            CreateImpact(
                                                Instance,
                                                Material,
                                                Position,
                                                Normal,
                                                Exit,
                                                false,
                                                true,
                                                nil,
                                                nil,
                                                nil,
                                                nil,
                                                not v20
                                            )
                                        end
                                        Parent = Instance.Parent
                                        if not Parent or not Parent:HasTag("BreakableGlass") then
                                            if not v14 and not Instance:HasTag("BreakableGlass") then
                                                if not Parent or not Parent:HasTag("BreakableGlass") then
                                                    CreateMarker(Instance, "Bullet", Position, Normal)
                                                end
                                            end
                                        elseif not Exit then
                                            BreakGlass(Instance, Position, i62.Direction)
                                        elseif not v14 and not Instance:HasTag("BreakableGlass") then
                                            if not Parent or not Parent:HasTag("BreakableGlass") then
                                                CreateMarker(Instance, "Bullet", Position, Normal)
                                            end
                                        end
                                        if Parent
                                            and Parent:HasTag("BreakableDoor")
                                            and (self.Properties.Penetration or 0) <= 0 then
                                            break
                                        end
                                    elseif v13 then
                                        v20 = CharacterResolver.getPlayerFromInstance(Instance)
                                        v21 = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter")
                                        CreateImpact(Instance, v21, Position, Normal, Exit, false, true, nil, v19, nil, v14)
                                        if v21 == "Blood Splatter" and not Exit and not v14 then
                                            CreateBloodSplatter(Position, i62.Direction)
                                        end
                                        UserId = if not v20 then botVictimKey(Instance) else v20.UserId
                                        if UserId and not Exit then
                                            PlayerHitPrediction.Record(self.ShotSeq, UserId, Instance.Name, Position)
                                        end
                                    end
                                end
                            end
                            debug.profileend()
                            debug.profilebegin("Weapon.ShootTail")
                            if self.Viewmodel.Model.CameraShake then
                                CameraController.weaponKick(GetWeaponCameraKick(self.Viewmodel.Model.CameraShake))
                            end
                            self.Viewmodel.Bobble:addScopeKick()
                            if self.Viewmodel.applyCharmImpulse then
                                Pivot = self.Viewmodel.Model:GetPivot()
                                if self.Viewmodel.Mirror then
                                    Pivot = self.Viewmodel.Mirror:ToNormalPose(Pivot)
                                end
                                self.Viewmodel:applyCharmImpulse(Pivot.LookVector * -1 + Pivot.UpVector * 0.3)
                            end
                            if self.Recoil then
                                Recoil = self.Recoil
                                Recoil.Time = Recoil.Time + FireRate
                            end
                            ReplicateCharacterAction(if not IsChargeFiring then v6 else "RevolverChargeRelease")
                            IsAiming = self.IsAiming
                            if IsAiming then
                                IsAiming = self.Properties.AimingOptions == "SniperScope"
                            end
                            if IsAiming then
                                self:unscope(true)
                            end
                            debug.profilebegin("Weapon.ShootAnimations")
                            v15 = if not IsChargeFiring then self.Viewmodel.Animation:play(v8) else self.Viewmodel.Animation:getAnimation(v6)
                            if not IsChargeFiring then
                                self.CharacterAnimator:play(v7)
                            elseif not v15 or not v15.IsPlaying then
                                v16 = self.Viewmodel.Animation:play(v6)
                                self.CharacterAnimator:play(v7)
                            end
                            debug.profileend()
                            debug.profilebegin("Weapon.ShootHaptics")
                            HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225)
                            debug.profileend()
                            ShootDelayThread = self.ShootDelayThread
                            if ShootDelayThread then
                                task.cancel(ShootDelayThread)
                                self.ShootDelayThread = nil
                            end
                            v16 = os.clock()
                            NextShotDue = self.NextShotDue
                            v17 = if not NextShotDue then v16 + FireRate else if not (v16 - NextShotDue < 0.035) then v16 + FireRate else NextShotDue + FireRate
                            self.NextShotDue = v17
                            ShootRequestTick = self.ShootRequestTick
                            self.ShootDelayThread = task.delay(v17 - v16, function() -- Line: 1578
                                -- upvalues: self (val), IsAiming (val), DataController (upval), LocalPlayer (upval)
                                -- upvalues: InputController (upval), FireRate (val), ShootRequestTick (val)
                                local v1, v2
                                if self.IsDestroyed then
                                    return
                                end
                                self.IsShooting = false
                                self.ShootDelayThread = nil
                                local v3 = self
                                if v3.IsDestroyed or not (v3.IsEquipped == true) then
                                    return
                                end
                                if IsAiming
                                    and self.WeaponEquippedTick < self.ShootRequestTick
                                    and 0 < self.Rounds
                                    and DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true then
                                    self:scope(true)
                                end
                                local v4 = self.Properties.ShootingOptions == "Revolver"
                                if not v4 then
                                    v4 = tick()
                                    v3 = math.min(0.15, FireRate)
                                    v1 = false
                                    if ShootRequestTick < self.ShootRequestTick then
                                        v1 = v4 - self.ShootRequestTick <= v3
                                    end
                                    local v5 = self
                                    local FireInputBinding_4 = v5.FireInputBinding
                                    if v5.IsFireHeld == true
                                        and FireInputBinding_4
                                        and not InputController.isBindingPressed(FireInputBinding_4) then
                                        v5.IsFireHeld = false
                                        v5.FireInputBinding = nil
                                    end
                                    v2 = v5.IsFireHeld == true
                                    if self.Properties.Automatic and v2
                                        or not self.Properties.Automatic and v1 and not v2 then
                                        if self.Properties.ShootingOptions == "Burst"
                                            and self.AlternativeShootingOption == "Burst" then
                                            return
                                        end
                                        if 0 < self.Rounds then
                                            self:shoot()
                                            return
                                        end
                                        self:reload()
                                        return
                                    end
                                    return
                                end
                                v3 = self
                                local AlternativeFireInputBinding = v3.AlternativeFireInputBinding
                                if v3.IsAlternativeFireHeld == true
                                    and AlternativeFireInputBinding
                                    and not InputController.isBindingPressed(AlternativeFireInputBinding) then
                                    v3.IsAlternativeFireHeld = false
                                    v3.AlternativeFireInputBinding = nil
                                end
                                v4 = v3.IsAlternativeFireHeld == true
                                local FireModes = self.Properties.FireModes
                                local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
                                if v4 and Secondary and Secondary.HoldRepeat then
                                    if 0 < self.Rounds then
                                        self:shoot("Secondary")
                                        return
                                    end
                                    self:reload()
                                    return
                                end
                                v2 = self
                                local FireInputBinding = v2.FireInputBinding
                                if v2.IsFireHeld == true
                                    and FireInputBinding
                                    and not InputController.isBindingPressed(FireInputBinding) then
                                    v2.IsFireHeld = false
                                    v2.FireInputBinding = nil
                                end
                                v1 = v2.IsFireHeld == true
                                local FireModes_2 = self.Properties.FireModes
                                local Primary = if FireModes_2 then FireModes_2.Primary else nil
                                if v1 and Primary and Primary.HoldRepeat then
                                    if 0 < self.Rounds then
                                        self:startRevolverCharge(self.FireInputBinding)
                                        return
                                    end
                                    self:reload()
                                    return
                                end
                                if self.HasPendingChargeRequest == true then
                                    self.HasPendingChargeRequest = false
                                    if v1 then
                                        self:startRevolverCharge(self.FireInputBinding)
                                    end
                                end
                            end)
                            debug.profileend()
                            return
                        end
                        return
                    end
                    return
                end
                u0 = {}
                while true do end
            end
            if self.Properties.FireRate and self.Properties.BulletsPerShot and not self.IsAdjustingSuppressor then
                if self.IsReloading and self.Properties.MuzzleType ~= "ShotGun" then
                    return
                end
                v22 = CharacterResolver.getPlayerCharacter(self.Player)
                if v22 and self.CharacterAnimator then
                    if self.AlternativeShootingOption ~= "Burst" then
                        self.ShootRequestTick = tick()
                    end
                    if self.IsShooting and self.AlternativeShootingOption == "Default" then
                        return
                    end
                    Interactables = self.Viewmodel.Model:FindFirstChild("Interactables")
                    if not Interactables then
                        return
                    end
                    if self.Rounds <= 0 then
                        self:reload()
                        return
                    end
                    Rounds = self.Properties.Rounds
                    if Rounds and self.Rounds <= Rounds * 0.2 then
                        Other:play({Name = "Low Ammo Fire", Parent = LocalPlayer.PlayerGui})
                    end
                    v4 = if not self.IsAiming then "Shoot" else if self.Properties.AimingOptions ~= "AutomaticScope" then "Shoot" else "AimShoot"
                    v5 = if not self.Properties.HasSuppressor then "Shoot" else if self.IsSuppressed then "Shoot" else "NoSuppressorShoot"
                    CameraController.toWeaponFirePosition()
                    if not IsChargeFiring then
                        if self.IsInspecting or self.IsInspectFadingOut then
                            self:cancelInspect(nil, nil, true)
                        end
                    end
                    if not IsChargeFiring then
                        self:stopAllAnimations()
                    end
                    self.CurrentReloadIdentity = nil
                    self.IsInspecting = false
                    self.IsInspectFadingOut = false
                    self.IsReloading = false
                    self.IsShooting = true
                    ChargeThread = self.ChargeThread
                    if ChargeThread then
                        task.cancel(ChargeThread)
                        self.ChargeThread = nil
                    end
                    ChargeShootConnection = self.ChargeShootConnection
                    if ChargeShootConnection and ChargeShootConnection.Connected then
                        ChargeShootConnection:Disconnect()
                    end
                    self.ChargeShootConnection = nil
                    self.HasPendingChargeRequest = false
                    self.IsChargeFiring = false
                    self.ChargeStartTick = 0
                    self.CurrentWalkSpeedOverride = nil
                    if not u193 then
                        self.Rounds = self.Rounds - 1
                    end
                    self.RechargeStartTime = workspace:GetServerTimeNow()
                    if self.Properties.ShootingOptions == "Dual" then
                        self.ShootingHand = if self.ShootingHand ~= "Left" then "Left" else "Right"
                        v4 = "Shoot" .. self.ShootingHand
                        v5 = "Shoot" .. self.ShootingHand
                    end
                    v6, v7 = resolveFireAnimationNames(self, v5, v4, v1)
                    v8 = if not IsChargeFiring then self.Viewmodel.Animation:pickVariant(v6) else v6
                    if self.Properties.MuzzleType ~= "ShotGun" then
                        self.CharacterAnimator:adjustAnimationSpeed(v7, FireRate)
                    end
                    if 150 < self.Rounds then
                        return
                    end
                    startRechargeTimer(self)
                    Router.broadcastRouter(
                        "UpdatePlayerNoiseCone",
                        "Weapon",
                        v22.PrimaryPart.Position,
                        SoundController.GetWeaponShootRange(self.Name, (self.Properties.HasSuppressor and self.IsSuppressed) == true),
                        nil
                    )
                    if self.Bullet then
                        FireModes_2 = self.Properties.FireModes
                        Secondary_2 = if FireModes_2 then not (v1 ~= "Secondary") and FireModes_2.Secondary or FireModes_2.Primary else nil
                        self.Bullet:setSpreadConfig(Secondary_2 and Secondary_2.Spread or self.Properties.Spread)
                    end
                    applyActiveRecoilProfile(self, v1)
                    MuzzlePartL = if self.Properties.ShootingOptions ~= "Dual" then Interactables.MuzzlePart else not (self.ShootingHand ~= "Left") and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR") or Interactables.MuzzlePart
                    Position_3 = MuzzlePartL.Position
                    v9 = {}
                    v10 = {}
                    debug.profilebegin("Weapon.BuildShootPacket")
                    BulletsPerShot_2 = self.Properties.BulletsPerShot
                    for i8 = 1, BulletsPerShot_2 do
                        v13 = self.Bullet:create(self.Properties.AimingOptions, self.IsAiming)
                        if v13 then
                            table.insert(v9, v13)
                            table.insert(v10, {Direction = v13.Direction, Origin = v13.Origin})
                        end
                    end
                    debug.profileend()
                    if IsChargeFiring and self.Properties.ShootingOptions == "Revolver" then
                        if self.Bullet then
                            FireModes_3 = self.Properties.FireModes
                            Secondary_3 = if FireModes_3 then FireModes_3.Secondary or FireModes_3.Primary else nil
                            self.Bullet:setSpreadConfig(Secondary_3 and Secondary_3.Spread or self.Properties.Spread)
                        end
                        applyActiveRecoilProfile(self, "Secondary")
                    end
                    debug.profilebegin("Weapon.SendShootPacket")
                    self.ShotSeq = self.ShotSeq + 1
                    Remotes.Inventory.ShootWeapon.Send({
                        IsSniperScoped = self.IsSniperScoped,
                        ShootingHand = self.ShootingHand,
                        Identifier = self.Identifier,
                        Seq = self.ShotSeq,
                        Bullets = v10,
                        ViewTick = Router.broadcastRouter("GetRemoteViewTick"),
                    })
                    debug.profileend()
                    debug.profilebegin("Weapon.ShootVFX")
                    v11 = DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false
                    v12 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false
                    if v12 then
                        IsAiming_3 = false
                        if self.Properties.AimingOptions == "AutomaticScope" then
                            IsAiming_3 = self.IsAiming
                        end
                        v12 = not IsAiming_3
                    end
                    v13 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true
                    if self.Properties.MuzzleType == "Zeus x27" then
                        CreateZeusBeam(MuzzlePartL)
                    end
                    if v12 and #v9 > 0 then
                        Camera(
                            MuzzlePartL,
                            if not self.Properties.HasSuppressor then self.Properties.MuzzleType else if not self.IsSuppressed then self.Properties.MuzzleType else "Suppressor"
                        )
                    end
                    for i9, i92 in ipairs(v9) do
                        v18 = false
                        if v11 then
                            CreateTracer(i92.Distance, Position_3, i92.Direction)
                        end
                        v19 = false
                        for i10, i102 in ipairs(i92.Hits) do
                            Instance = i102.Instance
                            Position = i102.Position
                            Material = i102.Material
                            Normal = i102.Normal
                            Exit = i102.Exit
                            v21 = Instance and Instance:FindFirstAncestorOfClass("Model")
                            v20 = false
                            if v21 ~= nil then
                                v20 = true
                                if CharacterResolver.getPlayerFromCharacter(v21) == nil then
                                    v20 = true
                                    if v21:GetAttribute("Bot") ~= true then
                                        v20 = CharacterResolver.isTutorialDummy(v21)
                                    end
                                end
                            end
                            if not v20 then
                                if not Exit then end
                                if not v14 then
                                    v20 = not Exit and not v18
                                    if v20 then end
                                    CreateImpact(Instance, Material, Position, Normal, Exit, false, true, nil, nil, nil, nil, not v20)
                                end
                                Parent = Instance.Parent
                                if not Parent or not Parent:HasTag("BreakableGlass") then
                                    if not v14 and not Instance:HasTag("BreakableGlass") then
                                        if not Parent or not Parent:HasTag("BreakableGlass") then
                                            CreateMarker(Instance, "Bullet", Position, Normal)
                                        end
                                    end
                                elseif not Exit then
                                    BreakGlass(Instance, Position, i92.Direction)
                                elseif not v14 and not Instance:HasTag("BreakableGlass") then
                                    if not Parent or not Parent:HasTag("BreakableGlass") then
                                        CreateMarker(Instance, "Bullet", Position, Normal)
                                    end
                                end
                                if Parent
                                    and Parent:HasTag("BreakableDoor")
                                    and (self.Properties.Penetration or 0) <= 0 then
                                    break
                                end
                            elseif v13 then
                                v20 = CharacterResolver.getPlayerFromInstance(Instance)
                                v21 = CharacterResolver.getImpactMaterial(Instance, "Blood Splatter")
                                CreateImpact(Instance, v21, Position, Normal, Exit, false, true, nil, v19, nil, v14)
                                if v21 == "Blood Splatter" and not Exit and not v14 then
                                    CreateBloodSplatter(Position, i92.Direction)
                                end
                                UserId = if not v20 then botVictimKey(Instance) else v20.UserId
                                if UserId and not Exit then
                                    PlayerHitPrediction.Record(self.ShotSeq, UserId, Instance.Name, Position)
                                end
                            end
                        end
                    end
                    debug.profileend()
                    debug.profilebegin("Weapon.ShootTail")
                    if self.Viewmodel.Model.CameraShake then
                        CameraController.weaponKick(GetWeaponCameraKick(self.Viewmodel.Model.CameraShake))
                    end
                    self.Viewmodel.Bobble:addScopeKick()
                    if self.Viewmodel.applyCharmImpulse then
                        Pivot = self.Viewmodel.Model:GetPivot()
                        if self.Viewmodel.Mirror then
                            Pivot = self.Viewmodel.Mirror:ToNormalPose(Pivot)
                        end
                        self.Viewmodel:applyCharmImpulse(Pivot.LookVector * -1 + Pivot.UpVector * 0.3)
                    end
                    if self.Recoil then
                        Recoil = self.Recoil
                        Recoil.Time = Recoil.Time + FireRate
                    end
                    ReplicateCharacterAction(if not IsChargeFiring then v6 else "RevolverChargeRelease")
                    IsAiming = self.IsAiming
                    if IsAiming then
                        IsAiming = self.Properties.AimingOptions == "SniperScope"
                    end
                    if IsAiming then
                        self:unscope(true)
                    end
                    debug.profilebegin("Weapon.ShootAnimations")
                    v15 = if not IsChargeFiring then self.Viewmodel.Animation:play(v8) else self.Viewmodel.Animation:getAnimation(v6)
                    if not IsChargeFiring then
                        self.CharacterAnimator:play(v7)
                    elseif not v15 or not v15.IsPlaying then
                        v16 = self.Viewmodel.Animation:play(v6)
                        self.CharacterAnimator:play(v7)
                    end
                    debug.profileend()
                    debug.profilebegin("Weapon.ShootHaptics")
                    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225)
                    debug.profileend()
                    ShootDelayThread = self.ShootDelayThread
                    if ShootDelayThread then
                        task.cancel(ShootDelayThread)
                        self.ShootDelayThread = nil
                    end
                    v16 = os.clock()
                    NextShotDue = self.NextShotDue
                    v17 = if not NextShotDue then v16 + FireRate else if not (v16 - NextShotDue < 0.035) then v16 + FireRate else NextShotDue + FireRate
                    self.NextShotDue = v17
                    ShootRequestTick = self.ShootRequestTick
                    self.ShootDelayThread = task.delay(v17 - v16, function() -- Line: 1578
                        -- upvalues: self (val), IsAiming (val), DataController (upval), LocalPlayer (upval)
                        -- upvalues: InputController (upval), FireRate (val), ShootRequestTick (val)
                        local v1, v2
                        if self.IsDestroyed then
                            return
                        end
                        self.IsShooting = false
                        self.ShootDelayThread = nil
                        local v3 = self
                        if v3.IsDestroyed or not (v3.IsEquipped == true) then
                            return
                        end
                        if IsAiming
                            and self.WeaponEquippedTick < self.ShootRequestTick
                            and 0 < self.Rounds
                            and DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true then
                            self:scope(true)
                        end
                        local v4 = self.Properties.ShootingOptions == "Revolver"
                        if not v4 then
                            v4 = tick()
                            v3 = math.min(0.15, FireRate)
                            v1 = false
                            if ShootRequestTick < self.ShootRequestTick then
                                v1 = v4 - self.ShootRequestTick <= v3
                            end
                            local v5 = self
                            local FireInputBinding_4 = v5.FireInputBinding
                            if v5.IsFireHeld == true
                                and FireInputBinding_4
                                and not InputController.isBindingPressed(FireInputBinding_4) then
                                v5.IsFireHeld = false
                                v5.FireInputBinding = nil
                            end
                            v2 = v5.IsFireHeld == true
                            if self.Properties.Automatic and v2
                                or not self.Properties.Automatic and v1 and not v2 then
                                if self.Properties.ShootingOptions == "Burst"
                                    and self.AlternativeShootingOption == "Burst" then
                                    return
                                end
                                if 0 < self.Rounds then
                                    self:shoot()
                                    return
                                end
                                self:reload()
                                return
                            end
                            return
                        end
                        v3 = self
                        local AlternativeFireInputBinding = v3.AlternativeFireInputBinding
                        if v3.IsAlternativeFireHeld == true
                            and AlternativeFireInputBinding
                            and not InputController.isBindingPressed(AlternativeFireInputBinding) then
                            v3.IsAlternativeFireHeld = false
                            v3.AlternativeFireInputBinding = nil
                        end
                        v4 = v3.IsAlternativeFireHeld == true
                        local FireModes = self.Properties.FireModes
                        local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
                        if v4 and Secondary and Secondary.HoldRepeat then
                            if 0 < self.Rounds then
                                self:shoot("Secondary")
                                return
                            end
                            self:reload()
                            return
                        end
                        v2 = self
                        local FireInputBinding = v2.FireInputBinding
                        if v2.IsFireHeld == true
                            and FireInputBinding
                            and not InputController.isBindingPressed(FireInputBinding) then
                            v2.IsFireHeld = false
                            v2.FireInputBinding = nil
                        end
                        v1 = v2.IsFireHeld == true
                        local FireModes_2 = self.Properties.FireModes
                        local Primary = if FireModes_2 then FireModes_2.Primary else nil
                        if v1 and Primary and Primary.HoldRepeat then
                            if 0 < self.Rounds then
                                self:startRevolverCharge(self.FireInputBinding)
                                return
                            end
                            self:reload()
                            return
                        end
                        if self.HasPendingChargeRequest == true then
                            self.HasPendingChargeRequest = false
                            if v1 then
                                self:startRevolverCharge(self.FireInputBinding)
                            end
                        end
                    end)
                    debug.profileend()
                    return
                end
                return
            end
            return
        else
            u0 = {}
            while true do end
        end
    end
end

function u0:equip() -- Line: 1658
    -- upvalues: CameraController (val), WeaponTimings (val), GameState (val), LocalPlayer (val), InputController (val)
    -- upvalues: getPressedActionBinding (val), u184 (val), u181 (val), applyActiveRecoilProfile (val)
    self.IsEquipped = true
    CameraController.resetWeaponRecoil()
    if self.Bullet then
        self.Bullet:setActive(true)
    end
    if self.Viewmodel.Hidden then
        self.Viewmodel:unhide()
    end
    self.Viewmodel.Animation:stopAnimations()
    self.CharacterAnimator:stopAnimations()
    self.CharacterAnimator:play("Idle")
    self.CharacterAnimator:play("Equip")
    self.WeaponEquippedTick = tick()
    self.Viewmodel:equip(false)
    self.Janitor:Remove("EquipDelayFire")
    local delay = task.delay
    local v1 = self.Viewmodel.Animation:getAnimation("Equip")
    local u68 = delay(WeaponTimings.PulloutSeconds(if not v1 then nil else v1.Length), function() -- Line: 1675
        -- upvalues: self (val), GameState (upval), LocalPlayer (upval), InputController (upval)
        -- upvalues: getPressedActionBinding (upval), u184 (upval), u181 (upval)
        if not self.IsDestroyed and self.IsEquipped and GameState.GetState() ~= "Buy Period" then
            local v1 = true
            if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
                v1 = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
            end
            if v1 then
                v1 = self
                v1.IsFireHeld = false
                v1.FireInputBinding = nil
                v1.IsAlternativeFireHeld = false
                v1.AlternativeFireInputBinding = nil
                v1.HasPendingChargeRequest = false
                return
            end
            v1 = self.Properties.ShootingOptions == "Revolver"
            if not v1 then
                if not InputController.isActionActive("Fire") then
                    return
                end
                v1 = getPressedActionBinding("Fire", u181)
                if v1 then
                    if self.Properties.ShootingOptions == "Revolver" then
                        self:startRevolverCharge(v1)
                        return
                    end
                    self.IsFireHeld = true
                    self.FireInputBinding = v1
                    self:shoot()
                end
                return
            end
            if not self.IsAlternativeFireHeld and not InputController.isActionActive("SecondaryFire") then
                if not InputController.isActionActive("Fire") then
                    return
                end
                v1 = getPressedActionBinding("Fire", u181)
                if v1 then
                    if self.Properties.ShootingOptions == "Revolver" then
                        self:startRevolverCharge(v1)
                        return
                    end
                    self.IsFireHeld = true
                    self.FireInputBinding = v1
                    self:shoot()
                end
                return
            end
            local AlternativeFireInputBinding = self.AlternativeFireInputBinding or getPressedActionBinding("SecondaryFire", u184)
            if not AlternativeFireInputBinding and not self.IsAlternativeFireHeld then
                if not InputController.isActionActive("Fire") then
                    return
                end
                v1 = getPressedActionBinding("Fire", u181)
                if v1 then
                    if self.Properties.ShootingOptions == "Revolver" then
                        self:startRevolverCharge(v1)
                        return
                    end
                    self.IsFireHeld = true
                    self.FireInputBinding = v1
                    self:shoot()
                end
                return
            end
            self:startRevolverSecondaryFire(AlternativeFireInputBinding)
            return
        end
    end)
    self.Janitor:Add(function() -- Line: 1710 -- upvalues: u68 (val)
        task.cancel(u68)
    end, false, "EquipDelayFire")
    self.CurrentScopeIncrement = 0
    self.ScopeStartTick = 0
    self.IsFireHeld = false
    self.FireInputBinding = nil
    self.IsAlternativeFireHeld = false
    self.AlternativeFireInputBinding = nil
    self.HasPendingChargeRequest = false
    self.IsBurstShooting = false
    self.IsInspectFadingOut = false
    self.IsInspecting = false
    self.IsReloading = false
    self.IsShooting = false
    self.IsAiming = false
    self.IsChargeFiring = false
    self.IsAdjustingSuppressor = false
    self.CurrentWalkSpeedOverride = nil
    self.ChargeStartTick = 0
    self.ChargeThread = nil
    self.ChargeShootConnection = nil
    if self.Properties.ShootingOptions == "Revolver" then
        if self.Bullet then
            local FireModes = self.Properties.FireModes
            local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
            self.Bullet:setSpreadConfig(Secondary and Secondary.Spread or self.Properties.Spread)
        end
        applyActiveRecoilProfile(self, "Secondary")
    end
    if self.Name == "SSG 08" or self.Name == "AWP" then
        self.IsSniperScoped = false
        if self.Name == "AWP" and self.Player then
            self.Player:SetAttribute("IsSniperScoped", false)
        end
    end
end

function u0:unequip() -- Line: 1722 -- upvalues: CameraController (val), restoreDefaultFovUnlessSceneActive (val)
    self.IsEquipped = false
    CameraController.resetWeaponRecoil()
    if self.Bullet then
        self.Bullet:setActive(false)
    end
    self:cancelRevolverCharge(false, false)
    self:stopRevolverSecondaryFire()
    self.Janitor:Remove("EquipDelayFire")
    local ShootDelayThread = self.ShootDelayThread
    if ShootDelayThread then
        task.cancel(ShootDelayThread)
        self.ShootDelayThread = nil
    end
    restoreDefaultFovUnlessSceneActive()
    self.CharacterAnimator:stopAnimations()
    self.Viewmodel:unequip()
    if self.IsAiming or 0 < self.CurrentScopeIncrement then
        self:unscope(nil, true)
    end
    if self.Viewmodel.Hidden then
        self.Viewmodel:unhide()
    end
    self.IsFireHeld = false
    self.FireInputBinding = nil
    self.IsAlternativeFireHeld = false
    self.AlternativeFireInputBinding = nil
    self.HasPendingChargeRequest = false
    self.IsBurstShooting = false
    self.IsInspectFadingOut = false
    self.IsInspecting = false
    self.IsReloading = false
    self.IsShooting = false
    self.IsAiming = false
    self.IsChargeFiring = false
    self.IsAdjustingSuppressor = false
    self.CurrentWalkSpeedOverride = nil
    self.ChargeStartTick = 0
    self.ChargeThread = nil
    self.ChargeShootConnection = nil
    if self.Name == "SSG 08" or self.Name == "AWP" then
        self.IsSniperScoped = false
        if self.Name == "AWP" and self.Player then
            self.Player:SetAttribute("IsSniperScoped", false)
        end
    end
    if self.Recoil then
        self.Recoil.Function = self.Recoil.Functions.Default
        self.Recoil.ActiveFireRate = self.Properties.FireRate or 0.1
        self.Recoil.Value = Vector2.zero
        self.Recoil.RecoveryValue = Vector2.zero
        self.Recoil.RecoveryTime = 0
        self.Recoil.RecoveryStartTime = 0
        self.Recoil.Time = 0
    end
end

function u0:createSuppressor() -- Line: 1758 -- upvalues: Remotes (val)
    local Viewmodel = self.Viewmodel and self.Viewmodel.Model
    if not Viewmodel then
        return
    end
    local Silencer = Viewmodel:FindFirstChild("Silencer", true)
    if not Silencer then
        return
    end
    Silencer.Transparency = if not self.IsSuppressed then 1 else 0
    local Identifier = self.Identifier

    local function v1(a1) -- Line: 1774
        -- upvalues: self (val), Silencer (val), Remotes (upval), Identifier (val)
        if self.IsDestroyed then
            return
        end
        Silencer.Transparency = a1
        Remotes.Inventory.UpdateWeaponSuppressor.Send({Identifier = Identifier, State = a1 == 0})
    end

    local u19 = false
    local v2 = self.Viewmodel.Animation:getAnimation("RemoveSuppressor")
    local u31 = self.Viewmodel.Animation:getAnimation("AddSuppressor")
    self.Janitor:Add(((v2:GetMarkerReachedSignal("ScrewOnEnd")):Connect(function() -- Line: 1789 -- upvalues: self (val), Silencer (val), Remotes (upval), Identifier (val)
        if self.IsDestroyed then
            return
        end
        Silencer.Transparency = 1
        Remotes.Inventory.UpdateWeaponSuppressor.Send({State = false, Identifier = Identifier})
    end)))
    self.Janitor:Add((v2.Ended:Connect(function() -- Line: 1792 -- upvalues: self (val), Silencer (val), Remotes (upval), Identifier (val)
        self.IsAdjustingSuppressor = false
        if not (Silencer.Transparency < 1) then
            if not self.IsDestroyed then
                Silencer.Transparency = 1
                Remotes.Inventory.UpdateWeaponSuppressor.Send({State = false, Identifier = Identifier})
            end
            self.IsSuppressed = false
        end
    end)))
    self.Janitor:Add(((u31:GetMarkerReachedSignal("ScrewOnEnd")):Connect(function() -- Line: 1801 -- upvalues: u19 (ref), self (val), Silencer (val), Remotes (upval), Identifier (val)
        u19 = true
        if not self.IsDestroyed then
            Silencer.Transparency = 0
            Remotes.Inventory.UpdateWeaponSuppressor.Send({State = true, Identifier = Identifier})
        end
        self.IsSuppressed = true
    end)))
    self.Janitor:Add(((u31:GetPropertyChangedSignal("IsPlaying")):Connect(function() -- Line: 1806 -- upvalues: u31 (val), u19 (ref), Silencer (val)
        if u31.IsPlaying then
            u19 = false
            task.delay(0.016666666666666666, function() -- Line: 1809 -- upvalues: u31 (upval), Silencer (upval)
                if u31.IsPlaying then
                    Silencer.Transparency = 0
                end
            end)
        end
    end)))
    self.Janitor:Add((u31.Ended:Connect(function() -- Line: 1816 -- upvalues: self (val), u19 (ref), Silencer (val)
        self.IsAdjustingSuppressor = false
        if not u19 then
            Silencer.Transparency = 1
        end
    end)))
end

function u0:setupRecoil() -- Line: 1826 -- upvalues: RunServiceController (val), CameraController (val)
    local Recoil_2 = self.Properties.Recoil
    if not Recoil_2 then
        return
    end
    local RecoverySpeed = Recoil_2.RecoverySpeed
    local Scale = Recoil_2.Scale
    local Damper = Recoil_2.Damper
    local Speed = Recoil_2.Speed
    local CameraScale = Recoil_2.CameraScale
    local Identifier = self.Identifier
    local v1 = Recoil_2.Pattern(self.Properties)
    self.Recoil = {
        RotationValue = Vector3.new(0, 0, 0),
        Time = 0,
        RecoveryTime = 0,
        RecoveryStartTime = 0,
        Function = v1,
        Functions = {Default = v1},
        Value = Vector2.zero,
        ActiveFireRate = self.Properties.FireRate or 0.1,
        RecoveryValue = Vector2.zero,
    }
    local Recoil = self.Recoil
    self.Janitor:Add(RunServiceController.BindToStepped(("Components.Weapon.%*.Recoil"):format(self.Identifier), function(a1, a2) -- Line: 1859
        -- upvalues: self (val), Recoil (val), RecoverySpeed (val), Scale (val), Identifier (val)
        -- upvalues: CameraController (upval), Damper (val), Speed (val), CameraScale (val)
        if not self.IsDestroyed and self.IsEquipped then
            local v1
            local v2 = Recoil.Function(Recoil.Time)
            if not self.IsShooting then
                v1 = Recoil.RecoveryValue.Magnitude / RecoverySpeed
                if 0 < Recoil.Value.Magnitude and v1 > 0 then
                    Recoil.Value = Recoil.RecoveryValue:Lerp(Vector2.zero, (math.clamp((os.clock() - Recoil.RecoveryStartTime) / v1, 0, 1)))
                end
                if 0 < Recoil.Time then
                    Recoil.Time = math.max(Recoil.Time - Recoil.RecoveryTime * RecoverySpeed * a2, 0)
                end
            else
                Recoil.Value = v2
                Recoil.RecoveryValue = v2
                Recoil.RecoveryTime = Recoil.Time
                Recoil.RecoveryStartTime = os.clock()
            end
            v1 = (Vector3.new(Recoil.Value.Y, Recoil.Value.X, 0)) * math.rad(Scale)
            Recoil.RotationValue = v1
            if not self.IsDestroyed and self.IsEquipped and self.Identifier == Identifier then
                CameraController.setWeaponRecoil({Value = v1, Damper = Damper, Speed = Speed}, CameraScale)
            end
            return
        end
    end), "Disconnect", "RecoilConnection")
end

function u0.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 1907
    -- upvalues: WeaponComponent (val), u0 (ref), Bullet (val), applyActiveRecoilProfile (val)
    -- upvalues: restoreDefaultFovUnlessSceneActive (val), CharacterResolver (val), startRechargeTimer (val)
    local v1 = WeaponComponent.new(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
    local v2 = u0
    local u30 = setmetatable(v1, v2)
    u30.IsEquipped = false
    local v3 = a13 or {}
    u30.Bullet = Bullet.new(u30, u30.Properties)
    local Capacity = v3.Capacity or u30.Properties.Capacity
    u30.Capacity = Capacity
    local Rounds = v3.Rounds or u30.Properties.Rounds
    u30.Rounds = Rounds
    u30.RechargeStartTime = v3.RechargeStartTime
    u30.AlternativeShootingOption = "Default"
    u30.AlternativeSwitchTick = 0
    u30.IsBurstShooting = false
    u30.ShootingHand = "Right"
    u30.HasPendingChargeRequest = false
    u30.IsAlternativeFireHeld = false
    u30.IsChargeFiring = false
    u30.IsAdjustingSuppressor = false
    u30.IsInspectFadingOut = false
    u30.IsInspecting = false
    u30.IsReloading = false
    u30.IsShooting = false
    u30.IsAiming = false
    u30.IsFireHeld = false
    local IsSuppressed = if v3.IsSuppressed == nil then u30.Properties.HasSuppressor else v3.IsSuppressed
    u30.IsSuppressed = IsSuppressed
    u30.IsSniperScoped = false
    u30.CurrentScopeIncrement = 0
    u30.WeaponEquippedTick = 0
    u30.ChargeStartTick = 0
    u30.ShootRequestTick = 0
    u30.ShotSeq = 0
    u30.ReloadStartTick = 0
    u30.ScopeStartTick = 0
    u30:setupRecoil()
    if u30.Properties.ShootingOptions == "Revolver" then
        if u30.Bullet then
            local FireModes = u30.Properties.FireModes
            local Secondary = if FireModes then FireModes.Secondary or FireModes.Primary else nil
            u30.Bullet:setSpreadConfig(Secondary and Secondary.Spread or u30.Properties.Spread)
        end
        applyActiveRecoilProfile(u30, "Secondary")
    end
    u30.Janitor:Add(function() -- Line: 1994 -- upvalues: u30 (val), restoreDefaultFovUnlessSceneActive (upval)
        u30:cancelRevolverCharge(false, false)
        u30:stopRevolverSecondaryFire()
        if u30.Bullet then
            u30.Bullet:destroy()
            u30.Bullet = nil
        end
        if u30.IsAiming then
            restoreDefaultFovUnlessSceneActive()
        end
    end)
    if u30.Properties.HasSuppressor then
        if not u30.Viewmodel or not u30.Viewmodel.Model then
            local u130 = nil
            u130 = CharacterResolver.observeCharacter(u30.Player, function(a1) -- Line: 2013 -- upvalues: u30 (val), u130 (ref)
                if not a1 then
                    return nil
                end
                task.defer(function() -- Line: 2018 -- upvalues: u30 (upval), u130 (upval)
                    if not u30.IsDestroyed and u30.Viewmodel and u30.Viewmodel.Model then
                        if u130 then
                            u130()
                            u130 = nil
                        end
                        u30:createSuppressor()
                        return
                    end
                end)
                return nil
            end)
            u30.Janitor:Add(function() -- Line: 2030 -- upvalues: u130 (ref)
                if u130 then
                    u130()
                    u130 = nil
                end
            end)
        else
            u30:createSuppressor()
        end
    end
    local Rounds_2 = u30.Rounds
    local Rounds_3 = u30.Properties.Rounds or u30.Rounds
    if Rounds_2 < Rounds_3 then
        startRechargeTimer(u30)
    end
    return u30
end

function u0:destroy() -- Line: 2050 -- upvalues: WeaponComponent (val)
    if self.IsDestroyed then
        return
    end
    self.IsDestroyed = true
    local ReloadTrackFinishedConnection = self.ReloadTrackFinishedConnection
    if ReloadTrackFinishedConnection and ReloadTrackFinishedConnection.Connected then
        ReloadTrackFinishedConnection:Disconnect()
    end
    self.ReloadTrackFinishedConnection = nil
    local ShootDelayThread = self.ShootDelayThread
    if ShootDelayThread then
        task.cancel(ShootDelayThread)
        self.ShootDelayThread = nil
    end
    local ChargeThread = self.ChargeThread
    if ChargeThread then
        task.cancel(ChargeThread)
        self.ChargeThread = nil
    end
    local RechargeThread = self.RechargeThread
    if RechargeThread then
        task.cancel(RechargeThread)
        self.RechargeThread = nil
    end
    local ChargeShootConnection = self.ChargeShootConnection
    if ChargeShootConnection and ChargeShootConnection.Connected then
        ChargeShootConnection:Disconnect()
    end
    self.ChargeShootConnection = nil
    local InspectDelayThread = self.InspectDelayThread
    if InspectDelayThread then
        task.cancel(InspectDelayThread)
        self.InspectDelayThread = nil
    end
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
    self.Recoil = nil
    if self.Bullet then
        self.Bullet:destroy()
        self.Bullet = nil
    end
    self.Janitor:Destroy()
    self.Janitor = nil
    self.AlternativeShootingOption = nil
    self.AlternativeSwitchTick = nil
    self.CurrentReloadIdentity = nil
    self.CurrentScopeIncrement = nil
    self.WeaponEquippedTick = nil
    self.ChargeStartTick = nil
    self.ShootRequestTick = nil
    self.ReloadStartTick = nil
    self.ShootingHand = nil
    self.CurrentWalkSpeedOverride = nil
    self.HasPendingChargeRequest = nil
    self.IsAlternativeFireHeld = nil
    self.AlternativeFireInputBinding = nil
    self.IsChargeFiring = nil
    self.ChargeThread = nil
    self.ChargeShootConnection = nil
    WeaponComponent.destroy(self)
end

return u0