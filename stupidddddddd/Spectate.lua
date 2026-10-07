-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Spectate
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Spectate
-- Decompile time: 4.10 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local u84 = {Menu = "Main Menu", TeamSelect = "Choose Team"}
local u85 = nil
local u86 = nil
local u93 = table.find(GetUserPlatform(), "Mobile") ~= nil
local u94 = true
local u97 = Janitor.new()

local function updateADRDisplay(a1, a2) -- Line: 61
    -- upvalues: Participants (val), u85 (ref), Colors (val)
    local Attribute = a1:GetAttribute("Team")
    if not Attribute then
        return
    end
    if a2 == nil and Participants.IsBot(a1) and a1:GetAttribute("ADR") == nil then
        u85.ADR.Text = ""
        return
    end
    local v1 = Colors["Team Color"][Attribute]
    local v2 = math.floor((a2 or a1:GetAttribute("ADR") or 0) * 10) / 10
    local v3 = math.floor(v1.R * 255)
    local v4 = math.floor(v1.G * 255)
    local v5 = math.floor(v1.B * 255)
    u85.ADR.Text = ("<font color=\"rgb(%*, %*, %*)\">ADR:</font> %*"):format(v3, v4, v5, v2)
end

local function isRoundBasedGamemode() -- Line: 81
    local Attribute = workspace:GetAttribute("Gamemode")
    local v1 = false
    if Attribute ~= nil then
        v1 = Attribute ~= "Deathmatch"
    end
    return v1
end

local function updateRespawnNextVisibility() -- Line: 86 -- upvalues: u85 (ref), LocalPlayer (val), IsPlayingTeam (val)
    if not u85 then
        return
    end
    local Attribute = LocalPlayer:GetAttribute("Team")
    local RespawnNext = u85.RespawnNext
    local v1 = IsPlayingTeam(Attribute)
    if v1 then
        local Attribute_2 = workspace:GetAttribute("Gamemode")
        v1 = false
        if Attribute_2 ~= nil then
            v1 = Attribute_2 ~= "Deathmatch"
        end
    end
    RespawnNext.Visible = v1
end

local function updateSpectateTips() -- Line: 94 -- upvalues: u85 (ref), u94 (ref), u93 (val), u84 (val), Tips (val)
    if not u85 then
        return
    end
    local Tips_2 = u85:FindFirstChild("Tips")
    if Tips_2 and Tips_2:IsA("GuiObject") then
        local v1 = u94 and not u93
        Tips_2.Visible = v1
        local RespawnNext = u85.RespawnNext
        if v1 then
            local Keybind, v2, v3
            for k, v in pairs(u84) do
                v3 = Tips_2:FindFirstChild(k)
                if v3 and v3:IsA("GuiObject") then
                    Keybind = v3:FindFirstChild("Keybind")
                    v2 = false
                    if Keybind and Keybind:IsA("GuiButton") then
                        v2 = Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding(v))
                    end
                    v3.Visible = v2
                end
            end
        end
        RespawnNext.Position = UDim2.new(
            RespawnNext.Position.X.Scale,
            RespawnNext.Position.X.Offset,
            if not v1 then -0.2 else Tips_2.Position.Y.Scale - RespawnNext.Size.Y.Scale / 2,
            0
        )
        return
    end
end

function u0.UpdateFrame(a1) -- Line: 130
    -- upvalues: SpectateController (val), u85 (ref), Participants (val), Colors (val), GetBadgeIcon (val), u97 (val)
    -- upvalues: Observers (val), updateADRDisplay (val), GetSkinDisplayName (val)
    local v1 = SpectateController.GetCurrentSpectateInstance()
    u85.Player.Player.Avatar.Image = Participants.HeadshotImage(a1)
    u85.Username.Text = Participants.Name(a1)
    local Attribute = a1:GetAttribute("Team")
    if Attribute then
        local v2 = Colors["Team Color"][Attribute]
        u85.Username.TextColor3 = v2
        u85.Badge.Image = GetBadgeIcon(a1, Attribute)
        u85.Frame1.BackgroundColor3 = v2
        u85.Frame2.BackgroundColor3 = v2
        u85.Player.Outline.ImageColor3 = v2
    end
    u97:Cleanup()
    u97:Add((Observers.observeAttribute(a1, "ADR", function(a1_2) -- Line: 148 -- upvalues: updateADRDisplay (upval), a1 (val)
        if typeof(a1_2) == "number" then
            updateADRDisplay(a1, a1_2)
        end
    end)))
    updateADRDisplay(a1)
    if not v1 then
        return
    end
    if v1.CurrentEquipped then
        local CurrentEquipped = v1.CurrentEquipped
        u85.Skin.Text = GetSkinDisplayName(CurrentEquipped.Skin)
        GetSkinDisplayName.ApplyNameLabel(
            u85.Weapon,
            GetSkinDisplayName.GetWeaponDisplayName(CurrentEquipped.Name, CurrentEquipped.NameTag),
            CurrentEquipped.NameTag
        )
    end
    u97:Add((v1.CurrentEquippedChanged:Connect(function(a1) -- Line: 170 -- upvalues: u85 (upval), GetSkinDisplayName (upval)
        if a1 then
            u85.Skin.Text = GetSkinDisplayName(a1.Skin or "")
            GetSkinDisplayName.ApplyNameLabel(u85.Weapon, GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag), a1.NameTag)
        end
    end)))
end

function u0.OpenFrame() -- Line: 182
    -- upvalues: u86 (ref), u85 (ref), LocalPlayer (val), IsPlayingTeam (val), updateSpectateTips (val)
    u86.Gameplay.Bottom.Middle.Team.Visible = false
    u85.Visible = true
    if u85 then
        local Attribute = LocalPlayer:GetAttribute("Team")
        local RespawnNext = u85.RespawnNext
        local v1 = IsPlayingTeam(Attribute)
        if v1 then
            local Attribute_2 = workspace:GetAttribute("Gamemode")
            v1 = false
            if Attribute_2 ~= nil then
                v1 = Attribute_2 ~= "Deathmatch"
            end
        end
        RespawnNext.Visible = v1
    end
    updateSpectateTips()
end

function u0.CloseFrame() -- Line: 189
    -- upvalues: u85 (ref), u97 (val), LocalPlayer (val), Workspace (val), ReplicatedStorage (val)
    u85.Visible = false
    u97:Cleanup()
    local Character = LocalPlayer.Character
    local Attribute = LocalPlayer:GetAttribute("Team")
    if Character and Character:IsDescendantOf(Workspace) and Attribute and Attribute ~= "Spectators" then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Team).OpenFrame()
    end
end

function u0.Initialize(a1, a2) -- Line: 204 -- upvalues: u86 (ref), u85 (ref)
    u86 = a1
    u85 = a2
end

function u0.Start() -- Line: 208
    -- upvalues: SpectateController (val), u0 (val), LocalPlayer (val), updateRespawnNextVisibility (val)
    -- upvalues: DataController (val), u94 (ref), updateSpectateTips (val), UserInputService (val)
    SpectateController.ListenToSpectate:Connect(function(a1) -- Line: 209 -- upvalues: u0 (upval)
        if not a1 then
            u0.CloseFrame()
            return
        end
        u0.UpdateFrame(a1)
        u0.OpenFrame()
    end)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(updateRespawnNextVisibility)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(updateRespawnNextVisibility)
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(a1) -- Line: 222 -- upvalues: u94 (upval), updateSpectateTips (upval) -- types: a1: boolean?
        u94 = a1 ~= false
        updateSpectateTips()
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", updateSpectateTips)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(updateSpectateTips)
end

return u0