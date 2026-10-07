-- ReplicatedStorage.Controllers.Observers.Game.BombPlanted.Bomb
-- Script path: ReplicatedStorage.Controllers.Observers.Game.BombPlanted.Bomb
-- Decompile time: 3.72 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CurrentCamera = workspace.CurrentCamera
local u54 = {KillTs = true, DefuseB = true}

local function computeInterval(a1, a2) -- Line: 55 -- types: a1: number, a2: number
    local v1 = a1 / a2 * 0.9 + 0.1
    if v1 <= 0.15 then
        v1 = 0.15
    end
    return v1
end

local function toggleFlashingLight(a1) -- Line: 63 -- types: a1: userdata?
    if a1 and a1:FindFirstChild("Attachment") and a1.Attachment:FindFirstChild("PointLight") then
        local PointLight = a1.Attachment.PointLight
        PointLight.Enabled = not PointLight.Enabled
    end
end

local function syncTutorialMarkers(a1) -- Line: 71 -- upvalues: LocalPlayer (val), IsTutorialMode (val), u54 (val)
    local Attribute = LocalPlayer:GetAttribute("TutorialStep")
    local Attribute_2 = a1.Model:GetAttribute("Defused")
    local IsDefused = a1.IsDefused
    if not IsDefused then
        if Attribute_2 == nil then
            IsDefused = a1.Model:GetAttribute("Exploding") == true
        else
            IsDefused = true
            if Attribute_2 == false then
                IsDefused = a1.Model:GetAttribute("Exploding") == true
            end
        end
    end
    local v1 = IsTutorialMode() and not IsDefused and u54[Attribute] == true
    local TutorialBombOutline = a1.Model:FindFirstChild("TutorialBombOutline")
    if v1 and not TutorialBombOutline then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "TutorialBombOutline"
        Highlight.FillTransparency = 1
        Highlight.OutlineColor = Color3.fromRGB(235, 40, 40)
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Adornee = a1.Model
        Highlight.Parent = a1.Model
        return
    end
    if not v1 and TutorialBombOutline then
        TutorialBombOutline:Destroy()
    end
end

function u0:updateHeartbeat(a2) -- Line: 98 -- upvalues: CurrentCamera (val)
    if self.Model:GetAttribute("IsGettingDefused") then
        self.Model:SetAttribute("CanDefuse", false)
        return
    end
    if a2.PrimaryPart and self.Model.PrimaryPart then
        if 5 < (a2.PrimaryPart.Position - self.Model.PrimaryPart.Position).Magnitude then
            self.Model:SetAttribute("CanDefuse", false)
            return
        end
        local v1 = self.Model.PrimaryPart.Position - CurrentCamera.CFrame.Position
        local Magnitude = v1.Magnitude
        if not (Magnitude > 0) then
            self.Model:SetAttribute("CanDefuse", false)
            return
        end
        v1 = v1 / Magnitude
        self.Model:SetAttribute("CanDefuse", 0.966 <= (CurrentCamera.CFrame.LookVector:Dot(v1)))
        return
    end
end

function u0.new(a1) -- Line: 132
    -- upvalues: u0 (val), Janitor (val), Sound (val), HttpService (val), RunServiceController (val), Router (val)
    -- upvalues: ReplicatedStorage (val), CharacterResolver (val), CameraController (val), HapticsController (val)
    -- upvalues: LocalPlayer (val), IsTutorialMode (val), syncTutorialMarkers (val)
    local u4 = setmetatable({}, u0)
    u4.Janitor = Janitor.new()
    u4.Sound = Sound.new("C4")
    u4.Janitor:Add(function() -- Line: 137 -- upvalues: u4 (val)
        u4.Sound:destroy()
    end)
    u4.Model = a1
    u4.Data = HttpService:JSONDecode((a1:GetAttribute("BombPlanted")))
    local Time_2 = not (typeof(u4.Data.Time) ~= "number") and u4.Data.Time or workspace:GetServerTimeNow()
    u4.TimeUntilExplode = math.max(not (typeof(u4.Data.TimeUntilExplode) ~= "number") and u4.Data.TimeUntilExplode or 40, 0.1)
    u4.ExplodeAt = Time_2 + u4.TimeUntilExplode
    u4.NextBeepAt = workspace:GetServerTimeNow()
    u4.IsDefused = false
    local v1 = RunServiceController.CreateBindingName("Observers.Game.BombPlanted")
    Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been planted.", 2.5)
    for i, v in ipairs(u4.Model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanQuery = true
        end
    end
    u4.Janitor:Add(((u4.Model:GetAttributeChangedSignal("Defused")):Connect(function() -- Line: 162 -- upvalues: Router (upval), u4 (val)
        Router.broadcastRouter("Cancel Defuse Bomb")
        Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been defused.", 2.5)
        u4.IsDefused = true
    end)))
    u4.Janitor:Add(((u4.Model:GetAttributeChangedSignal("Exploding")):Connect(function() -- Line: 169 -- upvalues: Router (upval), ReplicatedStorage (upval)
        Router.broadcastRouter("Cancel Defuse Bomb")
        local DefuseBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb)
        if DefuseBomb.SetDefuseBlockedUntil then
            DefuseBomb.SetDefuseBlockedUntil(workspace:GetServerTimeNow() + 5)
        end
    end)))
    u4.Janitor:Add(((u4.Model:GetAttributeChangedSignal("Exploded")):Connect(function() -- Line: 179
        -- upvalues: CharacterResolver (upval), CameraController (upval), u4 (val), HapticsController (upval)
        local v1 = CharacterResolver.getLocalCharacter()
        if v1 and CharacterResolver.isAliveCharacter(v1) then
            CameraController.BombExploded((u4.Model:GetPivot().Position - v1:GetPivot().Position).Magnitude)
            HapticsController.vibrate(Enum.VibrationMotor.Large, 1.5, 0.25)
        end
    end)))
    u4.Janitor:Add((RunServiceController.BindToHeartbeat(("%*.DefuseCheck"):format(v1), function(a1) -- Line: 187 -- upvalues: CharacterResolver (upval), LocalPlayer (upval), u4 (val) -- types: a1: number
        local v1 = CharacterResolver.getLocalCharacter()
        if CharacterResolver.isAliveCharacter(v1) and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
            u4:updateHeartbeat(v1)
        end
    end)))
    u4.Janitor:Add((RunServiceController.BindToHeartbeat(("%*.Beep"):format(v1), function(a1) -- Line: 194 -- upvalues: u4 (val) -- types: a1: number
        local ServerTimeNow = workspace:GetServerTimeNow()
        local v1 = math.max(u4.ExplodeAt - ServerTimeNow, 0)
        local Weapon = u4.Model:FindFirstChild("Weapon") and u4.Model.Weapon:FindFirstChild("FlashingLight")
        if not u4.IsDefused and not (v1 <= 0) then
            if u4.NextBeepAt <= ServerTimeNow then
                local v2 = v1 / u4.TimeUntilExplode * 0.9 + 0.1
                if v2 <= 0.15 then
                    v2 = 0.15
                end
                u4.NextBeepAt = ServerTimeNow + v2
                if Weapon
                    and Weapon:FindFirstChild("Attachment")
                    and Weapon.Attachment:FindFirstChild("PointLight") then
                    local PointLight = Weapon.Attachment.PointLight
                    PointLight.Enabled = not PointLight.Enabled
                end
                local PrimaryPart = u4.Model.PrimaryPart
                if PrimaryPart then
                    u4.Sound:play({Name = "Beep", Parent = PrimaryPart})
                end
            end
            return
        end
        if Weapon and Weapon:FindFirstChild("Attachment") and Weapon.Attachment:FindFirstChild("PointLight") then
            local PointLight_2 = Weapon.Attachment.PointLight
            PointLight_2.Enabled = not PointLight_2.Enabled
        end
    end)))
    if IsTutorialMode() then
        local function sync() -- Line: 219 -- upvalues: syncTutorialMarkers (upval), u4 (val)
            syncTutorialMarkers(u4)
        end

        u4.Janitor:Add(((LocalPlayer:GetAttributeChangedSignal("TutorialStep")):Connect(sync)))
        u4.Janitor:Add(((u4.Model:GetAttributeChangedSignal("Defused")):Connect(sync)))
        u4.Janitor:Add(((u4.Model:GetAttributeChangedSignal("Exploding")):Connect(sync)))
        u4.Janitor:Add(function() -- Line: 225 -- upvalues: u4 (val)
            local TutorialBombOutline = u4.Model:FindFirstChild("TutorialBombOutline")
            if TutorialBombOutline then
                TutorialBombOutline:Destroy()
            end
        end)
        syncTutorialMarkers(u4)
    end
    return u4
end

function u0:destroy() -- Line: 240
    self.Janitor:Destroy()
end

return u0