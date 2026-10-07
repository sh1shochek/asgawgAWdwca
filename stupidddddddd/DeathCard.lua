-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.DeathCard
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.DeathCard
-- Decompile time: 3.59 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon)
local GetBadgeName = require(ReplicatedStorage.Components.Common.GetBadgeName)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local u71 = nil
local u72 = nil
local u73 = nil
local u74 = nil
local u75 = 0

local function GetWeaponIcon(a1, a2) -- Line: 52 -- upvalues: Skins (val) -- types: a2: number
    return Skins.GetWearImageForFloat(a1, a2) or a1.imageAssetId or ""
end

local function CancelTransitionTween() -- Line: 56 -- upvalues: u74 (ref)
    local v1 = u74
    u74 = nil
    if v1 then
        v1:Cancel()
    end
end

local function PlayTransitionTween(a1, a2) -- Line: 64
    -- upvalues: u74 (ref), TweenService (val), u72 (ref)
    local v1 = u74
    u74 = nil
    if v1 then
        v1:Cancel()
    end
    v1 = TweenService:Create(u72, TweenInfo.new(a1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = a2})
    u74 = v1
    v1:Play()
    return v1
end

local function TweenBloodScreen(a1, a2, a3) -- Line: 76
    -- upvalues: TweenService (val), u71 (ref)
    local v1 = TweenInfo.new(a1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(u71, v1, {BackgroundTransparency = a2}):Play()
    TweenService:Create(u71.ImageLabel, v1, {ImageTransparency = a3}):Play()
end

local function GetCharacterCameraSubject() -- Line: 82
    -- upvalues: CollectionService (val), LocalPlayer (val), CharacterResolver (val)
    local Attribute, v1
    local v2 = nil
    local v3 = (-1 / 0)
    for i, j in CollectionService:GetTagged("Ragdoll") do
        if j:IsA("Model") and j.Name == LocalPlayer.Name then
            v1 = workspace
            if j:IsDescendantOf(v1) then
                Attribute = j:GetAttribute("RagdollCreatedAt")
                if v3 < (if typeof(Attribute) ~= "number" then 0 else Attribute) then
                    v2 = j
                end
            end
        end
    end
    if v2 then
        return CharacterResolver.getCameraPart(v2) or CharacterResolver.getRootPart(v2) or v2:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function u0.updateFrame(a1) -- Line: 108
    -- upvalues: Participants (val), u73 (ref), Skins (val), GetSkinDisplayName (val), GetBadgeName (val)
    -- upvalues: GetBadgeIcon (val)
    local v1 = Participants.FromKey(a1.Killer)
    if v1 and v1.Parent then
        local v2 = Skins.GetSkinInformation(a1.Weapon, a1.Skin)
        local v3 = GetSkinDisplayName(a1.Skin)
        u73.Killed.Text = ("<font color=\"rgb(255,34,16)\">Killed you with their</font> <b>%* | %*</b>"):format(a1.Weapon, v3)
        u73.BadgeFrame.TextLabel.Text = GetBadgeName(v1, (v1:GetAttribute("Team")))
        u73.BadgeIcon.Image = GetBadgeIcon(v1, (v1:GetAttribute("Team")))
        u73.Profile.Avatar.Image = Participants.HeadshotImage(v1)
        u73.Username.Text = Participants.DisplayName(v1)
        u73.ViewportFrame.Icon.Image = if not v2 then "" else Skins.GetWearImageForFloat(v2, a1.Float or 0.9999) or v2.imageAssetId or ""
        return true
    end
    u73.Killed.Text = ""
    u73.BadgeFrame.TextLabel.Text = ""
    u73.BadgeIcon.Image = ""
    u73.Profile.Avatar.Image = ""
    u73.Username.Text = ""
    u73.ViewportFrame.Icon.Image = ""
    return false
end

function u0.openFrame(a1) -- Line: 139
    -- upvalues: u75 (ref), GetCharacterCameraSubject (val), CurrentCamera (val), CameraController (val), u71 (ref)
    -- upvalues: u73 (ref), u74 (ref), u72 (ref), TweenBloodScreen (val), TweenService (val), PlayTransitionTween (val)
    -- upvalues: u0 (val)
    u75 = u75 + 1
    local u3 = u75

    local function isSequenceStale() -- Line: 142 -- upvalues: u75 (upval), u3 (val)
        return u75 ~= u3
    end

    local v1 = GetCharacterCameraSubject()
    if v1 then
        CurrentCamera.CameraSubject = v1
    end
    CurrentCamera.CameraType = Enum.CameraType.Follow
    CameraController.setPerspective(false, false)
    task.wait(0.15)
    if u75 ~= u3 then
        return
    end
    u71.ImageLabel.ImageTransparency = 1
    u71.BackgroundTransparency = 1
    u71.Visible = true
    u73.Position = UDim2.fromScale(0.5, -u73.Size.Y.Scale)
    u73.Visible = a1 ~= false
    local v2 = u74
    u74 = nil
    if v2 then
        v2:Cancel()
    end
    u72.BackgroundTransparency = 1
    u72.Visible = true
    TweenBloodScreen(0.75, 0.75, 0)
    task.wait(0.25)
    if u75 ~= u3 then
        return
    end
    if u73.Visible then
        TweenService:Create(
            u73,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.fromScale(0.5, 0.7)}
        ):Play()
    end
    task.wait(0.35)
    if u75 ~= u3 then
        return
    end
    PlayTransitionTween(0.25, 0)
    TweenBloodScreen(0.25, 1, 1)
    task.delay(if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then 2 else 8, function() -- Line: 189 -- upvalues: u75 (upval), u3 (val), u0 (upval)
        if u75 ~= u3 then
            return
        end
        u0.closeFrame()
    end)
end

function u0.closeFrame() -- Line: 197
    -- upvalues: u75 (ref), u71 (ref), u73 (ref), PlayTransitionTween (val), u74 (ref), u72 (ref)
    u75 = u75 + 1
    u71.ImageLabel.ImageTransparency = 1
    u71.BackgroundTransparency = 1
    u71.Visible = false
    u73.Position = UDim2.fromScale(0.5, -u73.Size.Y.Scale)
    u73.Visible = false
    local u23 = PlayTransitionTween(1, 1)
    u23.Completed:Connect(function() -- Line: 209 -- upvalues: u74 (upval), u23 (val), u72 (upval)
        if u74 ~= u23 then
            return
        end
        u74 = nil
        u72.BackgroundTransparency = 1
        u72.Visible = false
    end)
end

function u0.Initialize(a1, a2) -- Line: 223 -- upvalues: u71 (ref), u72 (ref), u73 (ref), LocalPlayer (val), u0 (val)
    u71 = a1.Gameplay.Middle.BloodScreen
    u72 = a1.Gameplay.Middle.Transition
    u73 = a2
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 228 -- upvalues: u0 (upval)
        u0.closeFrame()
    end)
end

function u0.Start() -- Line: 233 -- upvalues: Remotes (val), LocalPlayer (val), u0 (val)
    Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 234 -- upvalues: LocalPlayer (upval), u0 (upval)
        if LocalPlayer.UserId == tonumber(a1.Victim) then
            u0.openFrame(u0.updateFrame(a1))
        end
    end)
    Remotes.UI.ShowDeathCard.Listen(function(a1) -- Line: 240 -- upvalues: LocalPlayer (upval), u0 (upval)
        if LocalPlayer.UserId == tonumber(a1.Victim) then
            u0.updateFrame(a1)
        end
    end)
end

return u0