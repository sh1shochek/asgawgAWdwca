-- ReplicatedStorage.Classes.Spectate
-- Script path: ReplicatedStorage.Classes.Spectate
-- Decompile time: 20.30 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local GetWeaponCameraKick = require(ReplicatedStorage.Components.Common.GetWeaponCameraKick)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera)
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local Freecam = require(ReplicatedStorage.Classes.Freecam)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Bullet = require(ReplicatedStorage.Components.Weapon.Classes.Bullet)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Spring = require(ReplicatedStorage.Shared.Spring)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Debris = workspace:WaitForChild("Debris")
local CurrentCamera = workspace.CurrentCamera
local u125 = RaycastParams.new()
u125.FilterType = Enum.RaycastFilterType.Exclude
u125.IgnoreWater = true
local u128 = {
    ["Heavy Swing"] = true,
    BackStab = true,
    Swing1 = true,
    Swing2 = true,
    Inspect = true,
    Reload = true,
    Throw = true,
    Use = true,
}
local u137 = {
    NoSuppressorShoot = true,
    ShootRight = true,
    ShootLeft = true,
    Shoot = true,
    SlamFire = true,
}
local u143 = {37, 60}
local u146 = {["Right Arm"] = true, ["Left Arm"] = true, HumanoidRootPart = true, ViewmodelLight = true}

local function isInspectVariantEvent(a1) -- Line: 108 -- types: a1: string
    local v1 = true
    if a1 ~= "Inspect" then
        v1 = string.match(a1, "^Inspect%d+$") ~= nil
    end
    return v1
end

local function getTransparencyState(a1, a2) -- Line: 112 -- types: a2: userdata
    local v1 = a1.Transparencies[a2]
    if not v1 then
        v1 = {Transparency = a2.Transparency, Textures = {}}
        a1.Transparencies[a2] = v1
    end
    return v1
end

local function cacheAndHideInstance(a1, a2) -- Line: 124 -- upvalues: getTransparencyState (val) -- types: a2: userdata
    if a2:IsA("BasePart") then
        local v1 = getTransparencyState(a1, a2)
        for i, j in a2:GetChildren() do
            if j:IsA("Texture") and not table.find(v1.Textures, j) then
                table.insert(v1.Textures, j)
                j.Parent = nil
            end
        end
        if not (a2.Transparency < 1) then
            return
        end
        a2.Transparency = 1
        return
    end
    if not a2:IsA("Texture") then
        if a2:IsA("BillboardGui") then
            a2.Enabled = false
        end
        return
    end
    local Parent = a2.Parent
    if Parent and Parent:IsA("BasePart") then
        local v2 = getTransparencyState(a1, Parent)
        if not table.find(v2.Textures, a2) then
            table.insert(v2.Textures, a2)
        end
        a2.Parent = nil
        return
    end
end

local function updateSpectatedRevolverFireMode(a1, a2) -- Line: 151 -- types: a2: string
    if a1 and a1.Bullet and a1.Properties.ShootingOptions == "Revolver" then
        local FireModes = a1.Properties.FireModes
        local Secondary = FireModes and (not (a2 ~= "Secondary") and FireModes.Secondary or FireModes.Primary)
        a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
        return
    end
end

local function clearSpectatedRevolverChargeState(a1) -- Line: 162
    if a1 and a1.Bullet and a1.Properties.ShootingOptions == "Revolver" then
        local FireModes = a1.Properties.FireModes
        local Secondary = FireModes and (FireModes.Secondary or FireModes.Primary)
        a1.Bullet:setSpreadConfig(Secondary and Secondary.Spread or a1.Properties.Spread)
    end
    a1.IsChargeFiring = false
    a1.ChargeStartTick = 0
end

local function syncSpectatedWeaponState(a1, a2) -- Line: 168
    if not a1 then
        return
    end
    a1.IsSuppressed = a2.IsSuppressed
    a1.Rounds = a2.Rounds
    a1.Capacity = a2.Capacity
    a1.RechargeStartTime = a2.RechargeStartTime
end

local function syncSpectatedRechargeAfterShot(a1) -- Line: 179
    if a1 and a1.Properties and a1.Properties.RechargeTime then
        a1.Rounds = math.max(((tonumber(a1.Rounds)) or (tonumber(a1.Properties.Rounds)) or 0) - 1, 0)
        a1.RechargeStartTime = workspace:GetServerTimeNow()
        return
    end
end

local function recreateSpectatedShotEffects(a1) -- Line: 191
    -- upvalues: CurrentCamera (val), Debris (val), u125 (val), CreateTracer (val), CreateZeusBeam (val)
    -- upvalues: DataController (val), LocalPlayer (val), Camera (val)
    local v1 = {a1.Character, CurrentCamera, Debris}
    local Map = workspace:FindFirstChild("Map")
    local Barriers = if not Map then nil else Map:FindFirstChild("Barriers")
    if Barriers then
        table.insert(v1, Barriers)
    end
    u125.FilterDescendantsInstances = v1
    local WeaponComponent = a1.WeaponComponent
    local Bullet = WeaponComponent and WeaponComponent.Bullet
    if Bullet and Bullet._updateShotSpread then
        Bullet:_updateShotSpread(WeaponComponent.Properties.AimingOptions, WeaponComponent.IsAiming)
    end
    local v2 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * a1.WeaponComponent.Properties.Range, u125)
    local Distance = v2 and v2.Distance or a1.WeaponComponent.Properties.Range
    local MuzzlePart = a1.WeaponComponent.Viewmodel.Model.Interactables:FindFirstChild("MuzzlePart")
    if MuzzlePart then
        CreateTracer(Distance, MuzzlePart.Position, CurrentCamera.CFrame.LookVector)
        if a1.WeaponComponent.Properties.MuzzleType == "Zeus x27" then
            CreateZeusBeam(MuzzlePart)
        end
        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false then
            local Properties_2 = a1.WeaponComponent.Properties
            Camera(
                MuzzlePart,
                if not Properties_2.HasSuppressor or not a1.CurrentEquipped.IsSuppressed then Properties_2.MuzzleType else "Suppressor"
            )
        end
    end
end

local function getPresentedView(a1) -- Line: 229 -- upvalues: ReplicatedStorage (val)
    return require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(a1.Player) or a1.CameraPart.CFrame
end

local function destroyFreecam(a1) -- Line: 234
    if a1.FreecamInstance then
        a1.FreecamInstance:Stop()
        a1.FreecamInstance:Destroy()
        a1.FreecamInstance = nil
    end
end

local function destroyWeaponComponent(a1) -- Line: 242
    if a1.Bullet then
        a1.Bullet:destroy()
        a1.Bullet = nil
    end
    if a1.Janitor then
        a1.Janitor:Destroy()
    end
end

local function destroySpectatedWeaponComponent(a1) -- Line: 254
    if a1.WeaponComponent then
        local WeaponComponent = a1.WeaponComponent
        if WeaponComponent.Bullet then
            WeaponComponent.Bullet:destroy()
            WeaponComponent.Bullet = nil
        end
        if WeaponComponent.Janitor then
            WeaponComponent.Janitor:Destroy()
        end
        a1.WeaponComponent = nil
    end
    local v1 = nil
    local v2 = nil
    for i, j in a1.ParkedWeapons, v1, v2 do
        if j.Bullet then
            j.Bullet:destroy()
            j.Bullet = nil
        end
        if j.Janitor then
            j.Janitor:Destroy()
        end
    end
    table.clear(a1.ParkedWeapons)
    table.clear(a1.ParkedOrder)
end

local function parkSpectatedWeaponComponent(a1) -- Line: 267
    local WeaponComponent = a1.WeaponComponent
    a1.WeaponComponent = nil
    local Viewmodel = WeaponComponent.Viewmodel
    local Identifier = WeaponComponent.Identifier
    if Viewmodel and Identifier and not a1.ParkedWeapons[Identifier] then
        if WeaponComponent
            and WeaponComponent.Bullet
            and WeaponComponent.Properties.ShootingOptions == "Revolver" then
            local FireModes = WeaponComponent.Properties.FireModes
            local Secondary = FireModes and (FireModes.Secondary or FireModes.Primary)
            WeaponComponent.Bullet:setSpreadConfig(Secondary and Secondary.Spread or WeaponComponent.Properties.Spread)
        end
        WeaponComponent.IsChargeFiring = false
        WeaponComponent.ChargeStartTick = 0
        if WeaponComponent.CharacterAnimator then
            WeaponComponent.CharacterAnimator:destroy()
            WeaponComponent.CharacterAnimator = nil
        end
        if Viewmodel.Bobble and Viewmodel.Bobble.IsAiming then
            Viewmodel:unaim()
        end
        Viewmodel:unequip()
        a1.ParkedWeapons[Identifier] = WeaponComponent
        table.insert(a1.ParkedOrder, Identifier)
        local v1 = #a1.ParkedOrder
        if v1 > 6 then
            v1 = table.remove(a1.ParkedOrder, 1)
            local v2 = a1.ParkedWeapons[v1]
            if v2.Bullet then
                v2.Bullet:destroy()
                v2.Bullet = nil
            end
            if v2.Janitor then
                v2.Janitor:Destroy()
            end
            a1.ParkedWeapons[v1] = nil
        end
        return
    end
    if WeaponComponent.Bullet then
        WeaponComponent.Bullet:destroy()
        WeaponComponent.Bullet = nil
    end
    if WeaponComponent.Janitor then
        WeaponComponent.Janitor:Destroy()
    end
end

local function takeParkedWeaponComponent(a1, a2) -- Line: 297 -- types: a2: string
    local v1 = a1.ParkedWeapons[a2]
    if v1 then
        a1.ParkedWeapons[a2] = nil
        table.remove(a1.ParkedOrder, (table.find(a1.ParkedOrder, a2)))
    end
    return v1
end

function u0:UpdateCameraCFrame(a2) -- Line: 309 -- upvalues: Spring (val) -- types: a2: userdata
    if not self.CameraPositionSpring or not self.CameraRotationSpring then
        self.CameraRotationSpring = Spring.new(1, 35, a2.LookVector)
        self.CameraPositionSpring = Spring.new(1, 35, a2.Position)
    elseif 8 < (a2.Position - self.CameraPositionSpring:getPosition()).Magnitude then
        self.CameraRotationSpring:reset(a2.LookVector)
        self.CameraPositionSpring:reset(a2.Position)
    end
    self.CameraRotationSpring:setGoal(a2.LookVector)
    self.CameraPositionSpring:setGoal(a2.Position)
end

function u0:UpdateSuppressorState(a2) -- Line: 324
    local Silencer = a2.Viewmodel.Model:FindFirstChild("Silencer", true)
    if Silencer and a2.Properties.HasSuppressor then
        Silencer.Transparency = if not self.CurrentEquipped.IsSuppressed then 1 else 0
    end
end

function u0:UpdateSuppressor() -- Line: 333
    if self.WeaponComponent and self.WeaponComponent.Viewmodel then
        local Silencer = self.WeaponComponent.Viewmodel.Model:FindFirstChild("Silencer", true)
        if not Silencer then
            return
        end
        local Animation = self.WeaponComponent.Viewmodel.Animation
        local v1 = Animation:getAnimation("RemoveSuppressor")
        local u22 = Animation:getAnimation("AddSuppressor")
        local Janitor = self.WeaponComponent.Janitor
        if Janitor then
            local function connectEnded(a1, a2) -- Line: 346
                -- upvalues: Janitor (val), Silencer (val)
                Janitor:Add((a1.Ended:Connect(function() -- Line: 347 -- upvalues: a2 (val), Silencer (upval)
                    if a2 == (Silencer.Transparency < 1) then
                        Silencer.Transparency = if not a2 then 1 else 0
                    end
                end)))
            end

            Janitor:Add(((v1:GetMarkerReachedSignal("ScrewOnEnd")):Connect(function() -- Line: 354 -- upvalues: Silencer (val)
                Silencer.Transparency = 1
            end)))
            local Ended = v1.Ended
            local u38 = false
            Janitor:Add((Ended:Connect(function() -- Line: 347 -- upvalues: u38 (val), Silencer (val)
                if u38 == (Silencer.Transparency < 1) then
                    Silencer.Transparency = if not u38 then 1 else 0
                end
            end)))
            Janitor:Add(((u22:GetPropertyChangedSignal("IsPlaying")):Connect(function() -- Line: 358 -- upvalues: u22 (val), Silencer (val)
                if u22.IsPlaying then
                    task.delay(0.016666666666666666, function() -- Line: 360 -- upvalues: Silencer (upval)
                        Silencer.Transparency = 0
                    end)
                end
            end)))
            local Ended_2 = u22.Ended
            local u58 = true
            Janitor:Add((Ended_2:Connect(function() -- Line: 347 -- upvalues: u58 (val), Silencer (val)
                if u58 == (Silencer.Transparency < 1) then
                    Silencer.Transparency = if not u58 then 1 else 0
                end
            end)))
        end
        self:UpdateSuppressorState(self.WeaponComponent)
        return
    end
end

function u0:Switch(a2) -- Line: 373
    -- upvalues: CharacterResolver (val), CurrentCamera (val), CameraController (val)
    -- upvalues: destroySpectatedWeaponComponent (val), Constants (val), Freecam (val), Remotes (val)
    if not CharacterResolver.isAliveCharacter(self.Character) then
        if self.Character.Parent ~= nil and not self.Character:IsDescendantOf(workspace) then
            self.PendingPerspective = a2
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        end
        return
    end
    self.PendingPerspective = nil
    self.PerspectiveState = a2
    if self.FreecamInstance then
        self.FreecamInstance:Stop()
        self.FreecamInstance:Destroy()
        self.FreecamInstance = nil
    end
    if a2 == "First-Person" then
        self.TransparencyState = true
        self:SetCharacterTransparency(true)
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CameraSubject = self.CameraPart
        if self.CurrentEquipped then
            self:SetEquipped(self.CurrentEquipped, false)
        end
        self:UpdateScopeState()
        CameraController.setPerspective(true, false)
    elseif a2 == "Third-Person" or a2 == "Free-Cam" then
        self.TransparencyState = false
        self:SetCharacterTransparency(false)
        if a2 == "Third-Person" then
            CurrentCamera.CameraType = Enum.CameraType.Follow
            CurrentCamera.CameraSubject = self.CameraPart
        end
        destroySpectatedWeaponComponent(self)
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
        if a2 ~= "Third-Person" then
            local v1 = self.Janitor:Add((Freecam.new()))
            self.FreecamInstance = v1
            v1:Start()
        else
            CameraController.setPerspective(false, false, 8)
        end
    end
    Remotes.Spectate.SetSpectatePerspective.Send(self.PerspectiveState)
end

function u0:SetEquipped(a2, a3) -- Line: 429
    -- upvalues: parkSpectatedWeaponComponent (val), WeaponComponent (val), Participants (val), Bullet (val)
    local WeaponComponent_2 = self.WeaponComponent and self.WeaponComponent.Identifier
    self.CurrentEquipped = a2
    if WeaponComponent_2 == a2.Identifier then
        local WeaponComponent_3 = self.WeaponComponent
        if WeaponComponent_3 then
            WeaponComponent_3.IsSuppressed = a2.IsSuppressed
            WeaponComponent_3.Rounds = a2.Rounds
            WeaponComponent_3.Capacity = a2.Capacity
            WeaponComponent_3.RechargeStartTime = a2.RechargeStartTime
        end
        self:UpdateSuppressorState(self.WeaponComponent)
        return
    end
    if self.WeaponComponent then
        self:SetWeaponViewmodelTransparency(false)
        parkSpectatedWeaponComponent(self)
    end
    if self.PerspectiveState ~= "First-Person" then
        self.CurrentEquippedChanged:Fire(self.CurrentEquipped)
        return
    end
    local Identifier = a2.Identifier
    local v1 = self.ParkedWeapons[Identifier]
    if v1 then
        self.ParkedWeapons[Identifier] = nil
        table.remove(self.ParkedOrder, (table.find(self.ParkedOrder, Identifier)))
    end
    if v1 then
        if v1.StatTrack ~= a2.StatTrack then
            v1:updateStatTrackCounter(a2.StatTrack)
        end
        if v1 then
            v1.IsSuppressed = a2.IsSuppressed
            v1.Rounds = a2.Rounds
            v1.Capacity = a2.Capacity
            v1.RechargeStartTime = a2.RechargeStartTime
        end
        self.WeaponComponent = v1
        self.TransparencyState = true
        self:SetCharacterTransparency(true)
        v1.Viewmodel:equip(not a3)
        if v1.Properties.HasSuppressor then
            self:UpdateSuppressorState(v1)
        end
        self:UpdateScopeState()
        self.CurrentEquippedChanged:Fire(self.CurrentEquipped)
        return
    end
    local success, result = pcall(function() -- Line: 466 -- upvalues: WeaponComponent (upval), self (val)
        return WeaponComponent.new(
            self.Player,
            self.CurrentEquipped.Identifier,
            self.CurrentEquipped._id,
            1,
            self.CurrentEquipped.Name,
            self.CurrentEquipped.Skin,
            self.CurrentEquipped.Float,
            self.CurrentEquipped.StatTrack,
            self.CurrentEquipped.NameTag,
            self.CurrentEquipped.OriginalOwner,
            self.CurrentEquipped.Charm,
            self.CurrentEquipped.Stickers,
            if not self.IsBot then nil else self.Character
        )
    end)
    if success and result then
        if result.Properties and result.Properties.Spread then
            local v2 = Bullet.new(result, result.Properties)
            result.Bullet = v2
            if result.Janitor then
                result.Janitor:Add(v2, "destroy", "SpectateBullet")
            end
        end
        if result then
            result.IsSuppressed = a2.IsSuppressed
            result.Rounds = a2.Rounds
            result.Capacity = a2.Capacity
            result.RechargeStartTime = a2.RechargeStartTime
        end
        self.WeaponComponent = result
        self.TransparencyState = true
        self:SetCharacterTransparency(true)
        local Viewmodel = result.Viewmodel
        if Viewmodel then
            Viewmodel:equip(not a3)
            if result.Properties.HasSuppressor then
                self:UpdateSuppressor()
            end
        end
        self:UpdateScopeState()
        self.CurrentEquippedChanged:Fire(self.CurrentEquipped)
        return
    end
    warn((("[Spectate] Failed to create viewmodel for %* (%* | %*): %*"):format(
        Participants.Name(self.Player),
        self.CurrentEquipped.Name,
        self.CurrentEquipped.Skin,
        (tostring(result))
    )))
    self.TransparencyState = false
    if not pcall(function() -- Line: 493 -- upvalues: self (val)
        local v0, v1
        self:SetCharacterTransparency(false)
        return
    end) then
        warn("[Spectate] Failed to restore character transparency after viewmodel creation failure")
    end
    self:Switch("Third-Person")
    self.CurrentEquippedChanged:Fire(self.CurrentEquipped)
end

function u0:UpdateScopeState() -- Line: 536 -- upvalues: CameraController (val), Constants (val), u143 (val)
    if self.PerspectiveState == "First-Person" and self.CurrentEquipped then
        local Name = self.CurrentEquipped.Name
        local v1 = true
        if Name ~= "AWP" then
            v1 = Name == "SSG 08"
        end
        local v2 = true
        if Name ~= "AUG" then
            v2 = Name == "SG 553"
        end
        local Character = if not self.IsBot then self.Player else self.Character
        local v3 = Character:GetAttribute("ScopeIncrement") or 0
        local v4 = v3 > 0
        local WeaponComponent = self.WeaponComponent and self.WeaponComponent.Viewmodel
        if v1 then
            local Bobble = WeaponComponent and WeaponComponent.Bobble and WeaponComponent.Bobble.ScopeReticlePart
            local SurfaceGui = Bobble and Bobble:FindFirstChildOfClass("SurfaceGui")
            if SurfaceGui then
                SurfaceGui.Enabled = false
            end
            local v5 = v4 and v3 <= 2
            CameraController.updateCameraFOV(if not v5 then Constants.DEFAULT_CAMERA_FOV else Constants.DEFAULT_CAMERA_FOV - u143[v3])
            self:SetWeaponViewmodelTransparency(v5)
            return
        end
        if not v2 then
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
            self:SetWeaponViewmodelTransparency(false)
            return
        end
        if not WeaponComponent then
            return
        end
        if v4 then
            if not WeaponComponent.Hidden then
                WeaponComponent:hide()
            end
            if WeaponComponent.Bobble
                and WeaponComponent.Bobble.Scope
                and WeaponComponent.Bobble.ScopeReticlePart then
                WeaponComponent:aim()
            end
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15)
            return
        end
        if WeaponComponent.Hidden then
            WeaponComponent:unhide()
        end
        if WeaponComponent.Bobble and WeaponComponent.Bobble.Scope and WeaponComponent.Bobble.ScopeReticlePart then
            WeaponComponent:unaim()
        end
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
        return
    end
end

function u0:SetWeaponViewmodelTransparency(a2) -- Line: 592 -- upvalues: u146 (val) -- types: a2: boolean
    if self.WeaponComponent and self.WeaponComponent.Viewmodel and self.WeaponComponent.Viewmodel.Model then
        local v1
        local Model = self.WeaponComponent.Viewmodel.Model
        if not self.WeaponTransparencyCache then
            self.WeaponTransparencyCache = {}
        end
        local v2, v3 = a2, self
        for i, v in ipairs(Model:GetDescendants()) do
            if v:IsA("BasePart") and not u146[v.Name] then
                if not v2 then
                    v1 = v3.WeaponTransparencyCache[v]
                    if v1 ~= nil then
                        v.Transparency = v1
                        v3.WeaponTransparencyCache[v] = nil
                    end
                else
                    if not v3.WeaponTransparencyCache[v] then
                        v3.WeaponTransparencyCache[v] = v.Transparency
                    end
                    v.Transparency = 1
                end
            end
        end
        return
    end
end

function u0:SetCharacterTransparency(a2) -- Line: 623
    -- upvalues: Janitor (val), cacheAndHideInstance (val), RemoveFromArray (val)
    local Descendants = self.Character:GetDescendants()
    if self.IsBot then
        self.Character:SetAttribute("SpectatedFirstPerson", if not a2 then nil else true)
    end
    if a2 then
        if not self.TransparencyJanitor then
            local v1 = self.Janitor:Add((Janitor.new()))
            self.TransparencyJanitor = v1
            v1:Add((self.Character.DescendantAdded:Connect(function(a1) -- Line: 635 -- upvalues: self (val), cacheAndHideInstance (upval) -- types: a1: userdata
                if self.TransparencyState then
                    cacheAndHideInstance(self, a1)
                end
            end)))
        end
        for i3, j in ipairs(Descendants) do
            cacheAndHideInstance(self, j)
        end
        return
    end
    if self.TransparencyJanitor then
        self.TransparencyJanitor:Destroy()
        self.TransparencyJanitor = nil
    end
    for k, v in pairs(self.Transparencies) do
        if k and k.Parent then
            k.Transparency = v.Transparency
            RemoveFromArray(v.Textures, function(a1, a2) -- Line: 654 -- upvalues: k (val) -- types: a2: userdata
                a2.Parent = k
                return true
            end)
        end
    end
    for i, i2 in ipairs(Descendants) do
        if i2:IsA("BillboardGui") then
            i2.Enabled = true
        end
    end
end

function u0:AddSpectateEvent(a2) -- Line: 671
    -- upvalues: recreateSpectatedShotEffects (val), u137 (val), GetWeaponCameraKick (val)
    -- upvalues: syncSpectatedRechargeAfterShot (val), u128 (val)
    if self.WeaponComponent and self.WeaponComponent.Viewmodel then
        local v1, v2
        local Animation = self.WeaponComponent.Viewmodel.Animation
        local WeaponComponent = self.WeaponComponent
        if a2 == "RevolverChargeStart" then
            if WeaponComponent
                and WeaponComponent.Bullet
                and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                local FireModes = WeaponComponent.Properties.FireModes
                local Primary = FireModes and FireModes.Primary
                WeaponComponent.Bullet:setSpreadConfig(Primary and Primary.Spread or WeaponComponent.Properties.Spread)
            end
            WeaponComponent.IsChargeFiring = true
            WeaponComponent.ChargeStartTick = tick()
            Animation:stopAnimations()
            Animation:play("Shoot")
            Animation:play("Idle")
            return
        end
        if a2 == "RevolverChargeCancel" then
            if WeaponComponent
                and WeaponComponent.Bullet
                and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                local FireModes_2 = WeaponComponent.Properties.FireModes
                local Secondary = FireModes_2 and (FireModes_2.Secondary or FireModes_2.Primary)
                WeaponComponent.Bullet:setSpreadConfig(Secondary and Secondary.Spread or WeaponComponent.Properties.Spread)
            end
            WeaponComponent.IsChargeFiring = false
            WeaponComponent.ChargeStartTick = 0
            Animation:stopAnimations()
            Animation:play("Idle")
            return
        end
        if a2 == "RevolverChargeRelease" then
            if WeaponComponent
                and WeaponComponent.Bullet
                and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                local FireModes_3 = WeaponComponent.Properties.FireModes
                local Primary_2 = FireModes_3 and FireModes_3.Primary
                WeaponComponent.Bullet:setSpreadConfig(Primary_2 and Primary_2.Spread or WeaponComponent.Properties.Spread)
            end
            recreateSpectatedShotEffects(self)
            if WeaponComponent
                and WeaponComponent.Bullet
                and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                local FireModes_4 = WeaponComponent.Properties.FireModes
                local Secondary_2 = FireModes_4 and (FireModes_4.Secondary or FireModes_4.Primary)
                WeaponComponent.Bullet:setSpreadConfig(Secondary_2 and Secondary_2.Spread or WeaponComponent.Properties.Spread)
            end
            WeaponComponent.IsChargeFiring = false
            WeaponComponent.ChargeStartTick = 0
            return
        end
        if u137[a2] then
            if self.IsBot then
                local CameraShake = WeaponComponent.Viewmodel.Model:FindFirstChild("CameraShake")
                if CameraShake then
                    local v3
                    v2, v3 = GetWeaponCameraKick(CameraShake)
                    self.KickRotationSpring:setDampingRatio(v2.Damper)
                    self.KickRotationSpring:setFrequency(v2.Speed)
                    self.KickRotationSpring:setPosition(v2.Value * 0.017453292519943295)
                    self.KickPositionSpring:setDampingRatio(v3.Damper)
                    self.KickPositionSpring:setFrequency(v3.Speed)
                    self.KickPositionSpring:setPosition(v3.Value)
                end
                WeaponComponent.Viewmodel.Bobble:addScopeKick()
            end
            if WeaponComponent.Properties.ShootingOptions == "Revolver" then
                v1 = if a2 ~= "SlamFire" then "Primary" else "Secondary"
                if WeaponComponent
                    and WeaponComponent.Bullet
                    and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                    local FireModes_5 = WeaponComponent.Properties.FireModes
                    local Secondary_3 = FireModes_5 and (not (v1 ~= "Secondary") and FireModes_5.Secondary or FireModes_5.Primary)
                    WeaponComponent.Bullet:setSpreadConfig(Secondary_3 and Secondary_3.Spread or WeaponComponent.Properties.Spread)
                end
                if v1 == "Secondary" then
                    if WeaponComponent
                        and WeaponComponent.Bullet
                        and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                        local FireModes_6 = WeaponComponent.Properties.FireModes
                        local Secondary_4 = FireModes_6 and (FireModes_6.Secondary or FireModes_6.Primary)
                        WeaponComponent.Bullet:setSpreadConfig(Secondary_4 and Secondary_4.Spread or WeaponComponent.Properties.Spread)
                    end
                end
                WeaponComponent.IsChargeFiring = false
                WeaponComponent.ChargeStartTick = 0
            end
            syncSpectatedRechargeAfterShot(WeaponComponent)
            Animation:stopAnimations()
            Animation:play(if not Animation:getAnimation(a2) then "Shoot" else a2)
            Animation:play("Idle")
            recreateSpectatedShotEffects(self)
            if WeaponComponent.Properties.ShootingOptions == "Revolver" and a2 ~= "SlamFire" then
                if WeaponComponent
                    and WeaponComponent.Bullet
                    and WeaponComponent.Properties.ShootingOptions == "Revolver" then
                    local FireModes_7 = WeaponComponent.Properties.FireModes
                    local Secondary_5 = FireModes_7 and (FireModes_7.Secondary or FireModes_7.Primary)
                    WeaponComponent.Bullet:setSpreadConfig(Secondary_5 and Secondary_5.Spread or WeaponComponent.Properties.Spread)
                end
                WeaponComponent.IsChargeFiring = false
                WeaponComponent.ChargeStartTick = 0
                return
            end
            return
        end
        if a2 ~= "Remove Suppressor" and a2 ~= "Add Suppressor" then
            if a2 == "Switch Fire Mode" then
                Animation:stopAnimations()
                Animation:play("Switch")
                Animation:play("Idle")
                return
            end
            if a2 == "StartThrow" then
                Animation:stopAnimations()
                Animation:play("StartThrow")
                v1 = Animation:play("ThrowIdle")
                if not v1 then
                    return
                end
                v1.Looped = true
                return
            end
            if a2 ~= "Cancel Plant" and a2 ~= "CancelThrow" then
                if u128[a2] then
                    v1 = a2
                    v2 = true
                    if a2 ~= "Inspect" then
                        v2 = string.match(a2, "^Inspect%d+$") ~= nil
                    end
                    if v2 and not Animation:getAnimation(a2) then
                        v1 = "Inspect"
                    end
                    Animation:stopAnimations()
                    Animation:play(v1)
                    Animation:play("Idle")
                else
                    v1 = true
                    if a2 ~= "Inspect" then
                        v1 = string.match(a2, "^Inspect%d+$") ~= nil
                    end
                    if v1 then
                        v1 = a2
                        v2 = true
                        if a2 ~= "Inspect" then
                            v2 = string.match(a2, "^Inspect%d+$") ~= nil
                        end
                        if v2 and not Animation:getAnimation(a2) then
                            v1 = "Inspect"
                        end
                        Animation:stopAnimations()
                        Animation:play(v1)
                        Animation:play("Idle")
                    end
                end
                return
            end
            Animation:stopAnimations()
            Animation:play("Idle")
            return
        end
        Animation:stopAnimations()
        Animation:play((string.gsub(a2, " ", "")))
        Animation:play("Idle")
        return
    end
end

local function updateSpectatorAutomaticScope(a1, a2) -- Line: 758 -- types: a2: number
    if a1.PerspectiveState == "First-Person" and a1.CurrentEquipped then
        local Name = a1.CurrentEquipped.Name
        if Name ~= "AUG" and Name ~= "SG 553" then
            return
        end
        local Character = if not a1.IsBot then a1.Player else a1.Character
        if (Character:GetAttribute("ScopeIncrement") or 0) <= 0 then
            return
        end
        local WeaponComponent = a1.WeaponComponent
        local Viewmodel = WeaponComponent and WeaponComponent.Viewmodel
        if Viewmodel and Viewmodel.Bobble and Viewmodel.Bobble.IsAiming and WeaponComponent.Bullet then
            local v1 = WeaponComponent.Bullet:getBaseSpread() or 0
            local v2 = math.abs(v1 - (a1.LastSpreadValue or 0))
            local v3 = (a1.LastScopeUpdateTime or 0) + a2
            if v2 < 0.01 and v3 < 0.03333333333333333 then
                a1.LastScopeUpdateTime = v3
                return
            end
            a1.LastScopeUpdateTime = 0
            a1.LastSpreadValue = v1
            local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart
            local SurfaceGui = ScopeReticlePart and ScopeReticlePart:FindFirstChildOfClass("SurfaceGui")
            local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
            local Frame_2 = Frame and Frame:FindFirstChild("Frame")
            if Frame_2 then
                local v4 = math.clamp(v1, 0, 2) * 2
                Frame_2.Size = UDim2.fromScale(v4 + 2.5, v4 + 2.5)
                Frame_2.Position = UDim2.fromScale(0.5, 0.5)
            end
            return
        end
        return
    end
end

function u0.Render(a1, a2, a3) -- Line: 805
    -- upvalues: ReplicatedStorage (val), CharacterGeneration (val), CurrentCamera (val), CameraController (val)
    -- upvalues: updateSpectatorAutomaticScope (val)
    local v1
    if a1.PerspectiveState == "Free-Cam" then
        return
    end
    if not a3 and a1.IsBot then
        local BotCharacters = require(ReplicatedStorage.Controllers.CharacterController.BotCharacters)
        v1 = a1.Character:GetAttribute("ActorId")
        local v2 = CharacterGeneration.Get(a1.Character)
        if type(v1) == "number" and v2 then
            a3 = BotCharacters.GetCamera(v1, v2)
        end
    end
    if not a3 and not a1.IsBot and not a1.HasRemoteCamera then
        a3 = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(a1.Player)
    end
    if a3 then
        a1:UpdateCameraCFrame(a3)
    end
    if a1.CameraPositionSpring and a1.CameraRotationSpring then
        a1.CameraPositionSpring:update(a2)
        a1.CameraRotationSpring:update(a2)
        if a1.PerspectiveState == "First-Person" then
            CurrentCamera.CFrame = CFrame.lookAt(
                a1.CameraPositionSpring:getPosition(),
                (a1.CameraPositionSpring:getPosition()) + a1.CameraRotationSpring:getPosition()
            )
            if a3 then
                CurrentCamera.CFrame = a3
            end
            if a1.IsBot then
                a1.KickRotationSpring:update(a2)
                a1.KickPositionSpring:update(a2)
                local v3 = a1.KickRotationSpring:getPosition()
                v1 = CurrentCamera
                v1.CFrame = v1.CFrame * ((CFrame.new(a1.KickPositionSpring:getPosition())) * CFrame.Angles(v3.X, v3.Y, v3.Z))
                CurrentCamera.FieldOfView = CameraController.getTargetFOV()
            end
            if a1.WeaponComponent and a1.WeaponComponent.Viewmodel then
                a1.WeaponComponent.Viewmodel:render(a2)
            end
            local WeaponComponent = a1.WeaponComponent
            if WeaponComponent and WeaponComponent.Bullet and WeaponComponent.Bullet.updateSpread then
                WeaponComponent.Bullet:updateSpread(a2)
            end
            updateSpectatorAutomaticScope(a1, a2)
        end
    end
end

function u0.new(a1, a2, a3, a4) -- Line: 866
    -- upvalues: u0 (val), CharacterResolver (val), Participants (val), Janitor (val), Signal (val), Spring (val)
    -- upvalues: CurrentCamera (val), ReplicatedStorage (val), LocalPlayer (val), HttpService (val), Remotes (val)
    -- upvalues: Ragdoll (val), CameraController (val), Constants (val), destroySpectatedWeaponComponent (val)
    local u7 = setmetatable({}, u0)
    local v1 = CharacterResolver.resolve(a2)
    assert(v1, (("[Spectate] Invalid player character rig for %*"):format((Participants.Name(a1)))))
    local v2 = a3 or "First-Person"
    u7.Janitor = Janitor.new()
    u7.CurrentEquippedChanged = u7.Janitor:Add((Signal.new()))
    u7.StopSpectating = u7.Janitor:Add((Signal.new()))
    u7.RootPart = v1.RootPart
    u7.CameraPart = v1.CameraPart
    u7.Character = a2
    u7.Player = a1
    u7.IsBot = a4 == true
    u7.KickRotationSpring = Spring.new(1, 1, (Vector3.new(0, 0, 0)))
    u7.KickPositionSpring = Spring.new(1, 1, (Vector3.new(0, 0, 0)))
    u7.PerspectiveState = v2
    u7.TransparencyState = v2 == "First-Person"
    u7.Transparencies = {}
    u7.WeaponTransparencyCache = {}
    u7.ParkedWeapons = {}
    u7.ParkedOrder = {}
    u7.LastScopeUpdateTime = 0
    u7.LastSpreadValue = 0
    u7:SetCharacterTransparency(u7.TransparencyState)
    u7:Switch(u7.PerspectiveState)
    if not u7.IsBot and u7.PerspectiveState == "First-Person" and u7.Character:IsDescendantOf(workspace) then
        CurrentCamera.CFrame = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(u7.Player) or u7.CameraPart.CFrame
    end
    LocalPlayer.ReplicationFocus = u7.RootPart
    u7.Janitor:Add(function() -- Line: 909 -- upvalues: LocalPlayer (upval)
        LocalPlayer.ReplicationFocus = nil
    end)
    if u7.Player:GetAttribute("CurrentEquipped") then
        u7:SetEquipped(HttpService:JSONDecode((u7.Player:GetAttribute("CurrentEquipped"))), false)
    end
    u7.Janitor:Add(((u7.Player:GetAttributeChangedSignal("CurrentEquipped")):Connect(function() -- Line: 917 -- upvalues: u7 (val), HttpService (upval)
        local Attribute = u7.Player:GetAttribute("CurrentEquipped")
        if Attribute then
            u7:SetEquipped(HttpService:JSONDecode(Attribute), true)
            task.defer(function() -- Line: 922 -- upvalues: u7 (upval)
                if u7.TransparencyState and u7.PerspectiveState == "First-Person" then
                    u7:SetCharacterTransparency(true)
                end
            end)
        end
    end)))
    if not u7.IsBot then
        u7.Janitor:Add((Remotes.Spectate.UpdateCameraCFrame.Listen(function(a1) -- Line: 945 -- upvalues: u7 (val)
            if a1.UserId ~= u7.Player.UserId then
                return
            end
            u7.HasRemoteCamera = true
            u7:UpdateCameraCFrame(a1.CameraCFrame)
        end)))
        if u7.Player:GetAttribute("ScopeIncrement") then
            u7:UpdateScopeState()
        end
        u7.Janitor:Add(((u7.Player:GetAttributeChangedSignal("ScopeIncrement")):Connect(function() -- Line: 956 -- upvalues: u7 (val)
            u7:UpdateScopeState()
        end)))
    else
        u7.Janitor:Add(((require(ReplicatedStorage.Controllers.CharacterController.BotCharacters)).CombatEvent:Connect(function(a1) -- Line: 933 -- upvalues: u7 (val)
            if a1.ActorId == u7.Character:GetAttribute("ActorId") then
                u7:AddSpectateEvent(if a1.Kind ~= "Shoot" then a1.Kind else "Shoot")
            end
        end)))
        u7.Janitor:Add(((u7.Player:GetAttributeChangedSignal("ObjectiveAction")):Connect(function() -- Line: 938 -- upvalues: u7 (val)
            u7:AddSpectateEvent(if (u7.Player:GetAttribute("ObjectiveAction")) ~= "Planting" then "Cancel Plant" else "Use")
        end)))
    end

    local function stopSpectating() -- Line: 961 -- upvalues: u7 (val)
        u7.StopSpectating:Fire()
    end

    if (CharacterResolver.getHealth(u7.Character)) <= 0 then
        task.defer(stopSpectating)
    end
    u7.Janitor:Add(((u7.Character:GetAttributeChangedSignal("Health")):Connect(function() -- Line: 969 -- upvalues: CharacterResolver (upval), u7 (val)
        if (CharacterResolver.getHealth(u7.Character)) <= 0 then
            u7.StopSpectating:Fire()
        end
    end)))
    if u7.Character:GetAttribute("Dead") then
        task.defer(stopSpectating)
    end
    u7.Janitor:Add(((u7.Character:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 979 -- upvalues: u7 (val)
        if u7.Character:GetAttribute("Dead") then
            u7.StopSpectating:Fire()
        end
    end)))
    u7.Janitor:Add((Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 986 -- upvalues: Participants (upval), u7 (val)
        local Victim = a1.Victim
        if Victim and tostring((Participants.Key(u7.Player))) == Victim then
            u7.StopSpectating:Fire()
        end
    end)))
    u7.Janitor:Add((u7.Character.AncestryChanged:Connect(function(a1, a2) -- Line: 994 -- upvalues: u7 (val), CurrentCamera (upval), ReplicatedStorage (upval)
        if not a2 then
            u7.StopSpectating:Fire()
            return
        end
        local PendingPerspective = u7.PendingPerspective
        if PendingPerspective then
            local Character = u7.Character
            local v1 = workspace
            if Character:IsDescendantOf(v1) then
                u7:Switch(PendingPerspective)
                if PendingPerspective == "First-Person" and not u7.IsBot and not u7.CameraPositionSpring then
                    v1 = u7
                    CurrentCamera.CFrame = require(ReplicatedStorage.Controllers.CharacterController.RemoteCharacters).GetCamera(v1.Player) or v1.CameraPart.CFrame
                end
            end
        end
    end)))
    u7.Janitor:Add(function() -- Line: 1009
        -- upvalues: u7 (val), CharacterResolver (upval), Ragdoll (upval), CameraController (upval), Constants (upval)
        u7.TransparencyState = false
        local v1 = true
        if u7.Character:GetAttribute("Dead") == false then
            v1 = (CharacterResolver.getHealth(u7.Character)) <= 0
        end
        if v1 then
            Ragdoll.HideCharacterLocally(u7.Character)
        elseif next(u7.Transparencies) ~= nil then
            u7:SetCharacterTransparency(false)
        end
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    end)
    u7.Janitor:Add(function() -- Line: 1022 -- upvalues: destroySpectatedWeaponComponent (upval), u7 (val)
        destroySpectatedWeaponComponent(u7)
    end)
    u7.Janitor:Add(function() -- Line: 1025 -- upvalues: u7 (val)
        local v1 = u7
        if v1.FreecamInstance then
            v1.FreecamInstance:Stop()
            v1.FreecamInstance:Destroy()
            v1.FreecamInstance = nil
        end
    end)
    return u7
end

function u0.newBot(a1, a2, a3) -- Line: 1033 -- upvalues: u0 (val) -- types: a1: userdata, a2: userdata
    assert(a2:GetAttribute("Bot") == true, "Expected a bot presentation")
    return u0.new(a1, a2, a3, true)
end

function u0:Destroy() -- Line: 1041
    self.Janitor:Destroy()
end

return u0