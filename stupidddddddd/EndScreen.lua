-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.EndScreen
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.EndScreen
-- Decompile time: 3.81 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Observers = require(ReplicatedStorage.Packages.Observers)
local u47 = nil
local u48 = nil
local u49 = nil
local u50 = nil

local function clearFrame(a1, a2) -- Line: 38 -- types: a1: userdata, a2: string
    for i, v in ipairs(a1:GetChildren()) do
        if v.ClassName == a2 then
            v:Destroy()
        end
    end
end

local function updateVotingFrame(a1) -- Line: 46 -- upvalues: u48 (ref), Players (val) -- types: a1: table?
    local Attribute
    local v1 = a1
    for i, v in ipairs((u48.MapVote:GetChildren())) do
        if v:IsA("ImageButton") then
            Attribute = v1 and v1[v.Name] or v:GetAttribute("Amount")
            if Attribute then
                v.Main.Amount.Text = ("<font color=\"rgb(219,199,126)\">%*</font>/%*"):format(Attribute, #(Players:GetPlayers()))
                v:SetAttribute("Amount", Attribute)
            end
        end
    end
end

local function tweenVoteStroke(a1, a2, a3) -- Line: 61 -- upvalues: TweenService (val) -- types: a2: number, a3: number
    TweenService:Create(a1.Main.UIStroke, TweenInfo.new(0.5), {Transparency = a2}):Play()
    TweenService:Create(a1.Main.UIStroke, TweenInfo.new(0.5), {Thickness = a3}):Play()
end

local function cancelMapVoteBar() -- Line: 70 -- upvalues: u50 (ref)
    if u50 then
        u50:Cancel()
        u50 = nil
    end
end

local function createVoteButton(a1, a2) -- Line: 77
    -- upvalues: ReplicatedStorage (val), Players (val), u48 (ref), u47 (ref), Remotes (val), tweenVoteStroke (val)
    -- upvalues: TweenService (val)
    local v1 = ReplicatedStorage.Database.Custom.GameStats.Maps:WaitForChild(a2, 10)
    if not v1 then
        warn((("Failed to load map module for %* - map may not exist or hasn't replicated yet"):format(a2)))
        return
    end
    local v2 = require(v1)
    if v2 and v2.Icon then
        local u30 = ReplicatedStorage.Assets.UI.EndScreen.VoteTemplate:Clone()
        u30.Main.Amount.Text = ("<font color=\"rgb(219,199,126)\">0</font>/%*"):format(#(Players:GetPlayers()))
        u30.Main.Icon.Image = v2.Icon
        u30.Parent = u48.MapVote
        u30.Main.Selection.Text = a2
        u30:SetAttribute("Amount", 0)
        u30.Title.Visible = a1 == 1
        u30.Voted.Visible = false
        u30.Name = a2
        u30.Button.MouseButton1Click:Connect(function() -- Line: 102
            -- upvalues: u47 (upval), a2 (val), Remotes (upval), tweenVoteStroke (upval), u30 (val), u48 (upval)
            if u47 ~= a2 then
                Remotes.Map.SubmitMapVote.Send(a2)
                tweenVoteStroke(u30, 0, 5.5)
                if u47 then
                    local v1 = u47
                    tweenVoteStroke(u48.MapVote:FindFirstChild(v1), 0.75, 1.5)
                end
                u47 = a2
            end
        end)
        u30.Button.MouseEnter:Connect(function() -- Line: 112 -- upvalues: TweenService (upval), u30 (val)
            TweenService:Create(u30.Main.Icon.UIScale, TweenInfo.new(0.5), {Scale = 1.1}):Play()
        end)
        u30.Button.MouseLeave:Connect(function() -- Line: 115 -- upvalues: TweenService (upval), u30 (val)
            TweenService:Create(u30.Main.Icon.UIScale, TweenInfo.new(0.5), {Scale = 1}):Play()
        end)
        return
    end
    warn((("Map %* is missing Icon property"):format(a2)))
end

function u0.CloseFrame() -- Line: 123
    -- upvalues: u48 (ref), CameraController (val), LocalPlayer (val), ReplicatedStorage (val), u49 (ref)
    local Visible = u48.Visible
    u48.Visible = false
    CameraController.setForceLockOverride("EndScreen", false)
    if Visible then
        local Attribute = LocalPlayer:GetAttribute("Team")
        if not LocalPlayer.Character or not Attribute or Attribute == "Spectators" then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).openFrame()
            return
        end
    end
    if not require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() and not u49.Menu.Visible then
        return
    end
    require(ReplicatedStorage.Interface.Screens.Menu.Top).ResetToMainMenu()
    if not u49.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true)
        u49.Menu.Visible = true
    end
    u49.Gameplay.Visible = false
end

function u0.Initialize(a1, a2) -- Line: 164
    -- upvalues: u48 (ref), u49 (ref), clearFrame (val), Remotes (val), u50 (ref), u47 (ref), createVoteButton (val)
    -- upvalues: updateVotingFrame (val), u0 (val), Observers (val), GetTimerFormat (val), GameState (val)
    -- upvalues: TweenService (val)
    u48 = a2
    u49 = a1
    clearFrame(u48.MapVote, "ImageButton")
    Remotes.Map.StartMapVote.Listen(function(a1) -- Line: 168
        -- upvalues: u50 (upval), clearFrame (upval), u48 (upval), u47 (upval), createVoteButton (upval)
        if u50 then
            u50:Cancel()
            u50 = nil
        end
        clearFrame(u48.MapVote, "ImageButton")
        u47 = nil
        for i, v in ipairs(a1) do
            createVoteButton(i, v)
        end
    end)
    Remotes.Map.UpdateMapVote.Listen(updateVotingFrame)
    Remotes.Map.EndMapVote.Listen(function(a1) -- Line: 177 -- upvalues: u50 (upval), u0 (upval) -- types: a1: string
        if u50 then
            u50:Cancel()
            u50 = nil
        end
        u0.CloseFrame()
    end)
    Observers.observePlayer(function() -- Line: 182 -- upvalues: updateVotingFrame (upval)
        updateVotingFrame()
        return function() -- Line: 184 -- upvalues: updateVotingFrame (upval)
            updateVotingFrame()
        end
    end)
    Observers.observeAttribute(workspace, "Timer", function(a1) -- Line: 188
        -- upvalues: u48 (upval), GetTimerFormat (upval), GameState (upval), u50 (upval), TweenService (upval)
        u48.Top.Timer.Text = GetTimerFormat(a1)
        if GameState.GetState() == "Map Voting" and not u50 then
            local Extra = u48.Top:FindFirstChild("Extra")
            if Extra and a1 > 0 then
                Extra.Size = UDim2.new(0, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset)
                local v1 = TweenService:Create(Extra, TweenInfo.new(a1 * 1.15, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, Extra.Size.Y.Scale, Extra.Size.Y.Offset),
                })
                u50 = v1
                v1:Play()
            end
        end
    end)
    if GameState.GetState() == "Map Voting" then
        local v1 = false
        for i, v in ipairs(u48.MapVote:GetChildren()) do
            if v:IsA("ImageButton") then
                v1 = true
                break
            end
        end
        if not v1 then
            Remotes.Map.RequestMapVote.Send()
        end
    end
end

return u0