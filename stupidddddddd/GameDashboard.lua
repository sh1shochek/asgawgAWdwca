-- ReplicatedStorage.Interface.Screens.Menu.GameDashboard
-- Script path: ReplicatedStorage.Interface.Screens.Menu.GameDashboard
-- Decompile time: 3.01 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local Votekick = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick)
local LocalPlayer = Players.LocalPlayer
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection)
local u55 = nil
local u56 = nil

local function ClearFrame(a1) -- Line: 36 -- types: a1: userdata
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
end

local function IsActiveTeamPlayer(a1) -- Line: 46 -- upvalues: Votekick (val) -- types: a1: userdata
    return Votekick.GetActiveTeam(a1:GetAttribute("Team")) ~= nil
end

local function GetActiveTeamPlayerCount() -- Line: 52 -- upvalues: Players (val), Votekick (val)
    local v1 = 0
    for i, v in ipairs(Players:GetPlayers()) do
        if Votekick.GetActiveTeam(v:GetAttribute("Team")) ~= nil then
            v1 = v1 + 1
        end
    end
    return v1
end

function u0.PlayerAdded(a1) -- Line: 65
    -- upvalues: LocalPlayer (val), Votekick (val), u56 (ref), ReplicatedStorage (val), Router (val), Remotes (val)
    if LocalPlayer ~= a1 then
        local v1 = Votekick.GetActiveTeam(a1:GetAttribute("Team")) ~= nil
        if v1 then
            if not u56.Menu.VoteKick.Container:FindFirstChild((tostring(a1.UserId))) then
                v1 = ReplicatedStorage.Assets.UI.VoteKick.PlayerTemplate:Clone()
                v1.PlayerIcon.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(a1.UserId)
                v1.PlayerInfo.Username.Text = ("@%*"):format(a1.Name)
                v1.PlayerInfo.Nickname.Text = a1.DisplayName
                v1.Parent = u56.Menu.VoteKick.Container
                v1.Name = tostring(a1.UserId)
                v1.MouseButton1Click:Connect(function() -- Line: 77 -- upvalues: Router (upval), Remotes (upval), a1 (val), u56 (upval)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    Remotes.VoteKick.CallVote.Send((tostring(a1.UserId)))
                    u56.Menu.VoteKick.Visible = false
                end)
            end
            return
        end
    end
end

function u0.RefreshVoteKickEntries() -- Line: 87 -- upvalues: ClearFrame (val), u56 (ref), Players (val), u0 (val)
    ClearFrame(u56.Menu.VoteKick.Container)
    for i, v in ipairs(Players:GetPlayers()) do
        u0.PlayerAdded(v)
    end
end

function u0.OpenChooseTeam() -- Line: 97 -- upvalues: LocalPlayer (val), TeamSelection (val)
    local Attribute = LocalPlayer:GetAttribute("IsSpectating")
    local Attribute_2 = LocalPlayer:GetAttribute("Team")
    local v1 = true
    if Attribute_2 ~= "Counter-Terrorists" then
        v1 = true
        if Attribute_2 ~= "Terrorists" then
            v1 = Attribute == true
        end
    end
    if not v1 then
        return
    end
    if Attribute then
        TeamSelection.openFrame()
        return
    end
    if LocalPlayer.Character then
        TeamSelection.ToggleTeamSelection()
    end
end

function u0.Initialize(a1, a2) -- Line: 122 -- upvalues: u56 (ref), u55 (ref), u0 (val), Players (val)
    u56 = a1
    u55 = a2
    u0.RefreshVoteKickEntries()
    Players.PlayerAdded:Connect(function(a1) -- Line: 127 -- upvalues: u0 (upval)
        u0.PlayerAdded(a1)
    end)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 130 -- upvalues: u56 (upval)
        local v1 = u56.Menu.VoteKick.Container:FindFirstChild((tostring(a1.UserId)))
        if v1 then
            v1:Destroy()
        end
    end)
end

function u0.Start() -- Line: 140
    -- upvalues: ActivateButton (val), u56 (ref), CloseButtonRegistry (val), Router (val), u55 (ref), u0 (val)
    -- upvalues: Votekick (val), LocalPlayer (val), DataController (val), GetActiveTeamPlayerCount (val)
    ActivateButton(u56.Menu.VoteKick.Buttons.Close)
    CloseButtonRegistry.Add(u56.Menu.VoteKick, u56.Menu.VoteKick.Buttons.Close, function() -- Line: 143 -- upvalues: Router (upval), u56 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u56.Menu.VoteKick.Visible = false
    end)
    ActivateButton(u55.ChooseTeam)
    u55.ChooseTeam.MouseButton1Click:Connect(function() -- Line: 149 -- upvalues: u0 (upval)
        u0.OpenChooseTeam()
    end)
    ActivateButton(u55.VoteKick)
    u55.VoteKick.MouseButton1Click:Connect(function() -- Line: 154
        -- upvalues: Router (upval), u56 (upval), Votekick (upval), LocalPlayer (upval), DataController (upval)
        -- upvalues: GetActiveTeamPlayerCount (upval), u0 (upval)
        local v1
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local VoteKick = u56.Menu:FindFirstChild("VoteKick")
        if not VoteKick then
            return
        end
        local v2 = Votekick.GetActiveTeam(LocalPlayer:GetAttribute("Team"))
        if LocalPlayer:GetAttribute("IsSpectating") and not v2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You cannot vote kick while spectating as a spectator.")
            return
        end
        if not v2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You must be on a team to start a vote kick.")
            return
        end
        local v3 = DataController.Get(LocalPlayer, "Level")
        if not (if typeof(v3) ~= "table" then nil else tonumber(v3.Level)) then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Your data is still loading. Please try again in a moment.")
            return
        end
        if v1 < Votekick.MIN_LEVEL then
            Router.broadcastRouter(
                "CreateMenuNotification",
                "Error",
                (("You need to be level %* to vote kick players."):format(Votekick.MIN_LEVEL))
            )
            return
        end
        if GetActiveTeamPlayerCount() < Votekick.MINIMUM_ACTIVE_PLAYERS then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough active players to start a vote kick.")
            return
        end
        pcall(function() -- Line: 188 -- upvalues: u0 (upval)
            u0.RefreshVoteKickEntries()
        end)
        VoteKick.Visible = true
    end)
end

return u0