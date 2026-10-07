-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.Votekick
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.Votekick
-- Decompile time: 3.07 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local u43 = nil
local u44 = nil
local u45 = 0
local u46 = false

local function ShouldAutoCloseForState(a1) -- Line: 35 -- types: a1: string?
    local v1 = true
    if a1 ~= "Game Ending" then
        v1 = a1 == "Map Voting"
    end
    return v1
end

function u0.UpdateAmount(a1, a2, a3) -- Line: 39
    -- upvalues: u43 (ref), LocalPlayer (val)
    u43.Option[a1].Amount.Text = ("%*"):format(a2)
    if LocalPlayer.UserId == tonumber(a3) then
        local TextLabel = u43.Result.TextLabel
        local v1 = string.upper(a1)
        TextLabel.Text = ("You voted: <font color=\"%*\">%*</font>"):format(if a1 ~= "Yes" then "rgb(255,49,49)" else "rgb(90, 186, 55)", v1)
        u43.Result.Visible = true
    end
end

function u0.UpdateFrame(a1, a2) -- Line: 50 -- upvalues: Players (val), u43 (ref) -- types: a1: number, a2: number
    local PlayerByUserId = Players:GetPlayerByUserId(a1)
    local PlayerByUserId_2 = Players:GetPlayerByUserId(a2)
    if PlayerByUserId then
        u43.Player.Text = ("Kick player: %*? "):format(PlayerByUserId.Name)
        u43.Frame.Title.Text = ("Vote By: %*"):format(PlayerByUserId_2 and PlayerByUserId_2.Name or "Unknown")
        u43.Option.Yes.Amount.Text = "0"
        u43.Option.No.Amount.Text = "0"
    end
end

function u0.OpenFrame(a1) -- Line: 62
    -- upvalues: u43 (ref), u44 (ref), u46 (ref), u45 (ref), LocalPlayer (val), TweenService (val), u0 (val)
    u43.Position = UDim2.fromScale(-0.08, 0.525)
    u43:SetAttribute("IsVoteKickActive", true)
    u43.Result.Visible = false
    u44 = a1
    u43.Visible = true
    u46 = false
    u45 = u45 + 1
    local u20 = u45
    if LocalPlayer.UserId == a1 then
        u43.Result.TextLabel.Text = "You are being vote kicked."
        u43.Result.Visible = true
    end
    TweenService:Create(
        u43,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.fromScale(0.08, 0.525)}
    ):Play()
    task.delay(30, function() -- Line: 83 -- upvalues: u45 (upval), u20 (val), u0 (upval)
        if u45 == u20 then
            u0.CloseFrame()
        end
    end)
end

function u0.CloseFrame() -- Line: 90 -- upvalues: u45 (ref), u43 (ref), u44 (ref), u46 (ref), TweenService (val)
    u45 = u45 + 1
    local u2 = u45
    u43:SetAttribute("IsVoteKickActive", false)
    u43.Result.Visible = false
    u44 = nil
    u46 = false
    if not u43.Visible then
        u43.Position = UDim2.fromScale(-0.08, 0.525)
        return
    end
    local v1 = TweenService:Create(
        u43,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.fromScale(-0.08, 0.525)}
    )
    v1.Completed:Once(function() -- Line: 107 -- upvalues: u45 (upval), u2 (val), u43 (upval)
        if u45 == u2 then
            u43.Visible = false
        end
    end)
    v1:Play()
end

function u0.CastVote(a1) -- Line: 115
    -- upvalues: u44 (ref), LocalPlayer (val), u46 (ref), Remotes (val)
    if u44 and LocalPlayer.UserId == u44 then
        return
    end
    if u46 then
        return
    end
    u46 = true
    return (not (a1 ~= "Yes") and Remotes.VoteKick.VoteYes or Remotes.VoteKick.VoteNo).Send({Amount = 0, Voter = tostring(LocalPlayer.UserId)})
end

function u0.Initialize(a1, a2) -- Line: 133
    -- upvalues: u43 (ref), GetUserPlatform (val), Remotes (val), u0 (val), GameState (val), ActivateButton (val)
    -- upvalues: UserInputService (val)
    u43 = a2
    u43:SetAttribute("IsVoteKickActive", false)
    u43.Visible = false
    local v1 = table.find(GetUserPlatform(), "Mobile") ~= nil
    local Keybinds = u43:FindFirstChild("Keybinds")
    local MobileNoButton = u43:FindFirstChild("MobileNoButton")
    local MobileYesButton = u43:FindFirstChild("MobileYesButton")
    if Keybinds then
        Keybinds.Visible = not v1
    end
    if MobileNoButton then
        MobileNoButton.Visible = v1
    end
    if MobileYesButton then
        MobileYesButton.Visible = v1
    end
    Remotes.VoteKick.VoteNoUpdate.Listen(function(a1) -- Line: 154 -- upvalues: u0 (upval)
        u0.UpdateAmount("No", a1.Amount, a1.Voter)
    end)
    Remotes.VoteKick.VoteYesUpdate.Listen(function(a1) -- Line: 157 -- upvalues: u0 (upval)
        u0.UpdateAmount("Yes", a1.Amount, a1.Voter)
    end)
    Remotes.VoteKick.StartVote.Listen(function(a1) -- Line: 160 -- upvalues: GameState (upval), u0 (upval)
        local v1 = GameState.GetState()
        local v2 = true
        if v1 ~= "Game Ending" then
            v2 = v1 == "Map Voting"
        end
        if v2 then
            return
        end
        v2 = tonumber(a1.TargetUserId)
        v1 = tonumber(a1.VoterUserId)
        u0.UpdateFrame(v2, v1)
        u0.OpenFrame(v2)
    end)
    Remotes.VoteKick.EndVote.Listen(function() -- Line: 169 -- upvalues: u0 (upval)
        u0.CloseFrame()
    end)
    GameState.ListenToState(function(a1, a2) -- Line: 172 -- upvalues: u0 (upval)
        local v1 = true
        if a2 ~= "Game Ending" then
            v1 = a2 == "Map Voting"
        end
        if v1 then
            u0.CloseFrame()
        end
    end)
    if v1 and MobileNoButton and MobileYesButton then
        ActivateButton(MobileNoButton)
        ActivateButton(MobileYesButton)
        MobileNoButton.Activated:Connect(function() -- Line: 182 -- upvalues: u0 (upval)
            u0.CastVote("No")
        end)
        MobileYesButton.Activated:Connect(function() -- Line: 185 -- upvalues: u0 (upval)
            u0.CastVote("Yes")
        end)
        return
    end
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 190
        -- upvalues: u43 (upval), UserInputService (upval), u0 (upval)
        if not a2
            and u43.Visible
            and not UserInputService:GetFocusedTextBox()
            and a1.UserInputType == Enum.UserInputType.Keyboard then
            if a1.KeyCode == Enum.KeyCode.K then
                u0.CastVote("Yes")
                return
            end
            if a1.KeyCode == Enum.KeyCode.L then
                u0.CastVote("No")
            end
            return
        end
    end)
end

return u0