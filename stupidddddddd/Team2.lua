-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Team
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Team
-- Decompile time: 4.26 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u42 = Color3.fromRGB(36, 41, 47)
local u47 = Color3.fromRGB(89, 79, 50)
local u52 = Color3.fromRGB(135, 155, 177)
local u53 = nil
local u54 = nil

local function getPlateColor() -- Line: 38 -- upvalues: LocalPlayer (val), u47 (val), u42 (val)
    if LocalPlayer:GetAttribute("Team") == "Terrorists" then
        return u47
    end
    return u42
end

local function applyPreferenceColorToFrame(a1) -- Line: 44 -- upvalues: u53 (ref) -- types: a1: userdata
    u53.Team.Outline.ImageColor3 = a1
    u53.Line1.ImageColor3 = a1
    u53.Line2.ImageColor3 = a1
end

local function applyTeamPresentation() -- Line: 62
    -- upvalues: GetPreferenceColor (val), u53 (ref), LocalPlayer (val), u47 (val), u42 (val)
    local v1 = GetPreferenceColor()
    u53.Team.Outline.ImageColor3 = v1
    u53.Line1.ImageColor3 = v1
    u53.Line2.ImageColor3 = v1
    local Attribute = LocalPlayer:GetAttribute("Team")
    u53.Team.Team.CT.Visible = Attribute == "Counter-Terrorists"
    u53.Team.Team.T.Visible = Attribute == "Terrorists"
    u53.Team.Team.ImageColor3 = if LocalPlayer:GetAttribute("Team") ~= "Terrorists" then u42 else u47
end

local function applyPreferenceColorToCard(a1, a2) -- Line: 73 -- types: a2: userdata
    a1.Amount.TextColor3 = a2
    a1.ImageColor3 = a2
    for i, j in a1:QueryDescendants("UIStroke, ImageLabel") do
        if not j:IsA("UIStroke") then
            j.ImageColor3 = a2
        else
            j.Color = a2
        end
    end
end

local function tweenKillHighlight(a1, a2, a3) -- Line: 86
    -- upvalues: TweenService (val), u53 (ref)
    local v1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(a1.Animation, v1, {ImageTransparency = a2}):Play()
    TweenService:Create(u53.Team.Team, v1, {ImageColor3 = a3}):Play()
end

function u0.createAnimationFrame(a1) -- Line: 95
    -- upvalues: LocalPlayer (val), u53 (ref), ReplicatedStorage (val), applyPreferenceColorToCard (val)
    -- upvalues: GetPreferenceColor (val), TweenService (val), tweenKillHighlight (val), u52 (val), u47 (val), u42 (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    if Attribute and Attribute ~= "Spectators" then
        local CTCard, v1, v2, v3, v4, v5, v6, v7
        local v8 = #u53.Cards:GetChildren() + 1
        if v8 > 5 then
            return
        end
        if Attribute ~= "Counter-Terrorists" then
            CTCard = false
            if Attribute == "Terrorists" then
                CTCard = ReplicatedStorage.Assets.UI.Team.TCard
            end
        else
            CTCard = ReplicatedStorage.Assets.UI.Team.CTCard
            if not CTCard then
                CTCard = false
                if Attribute == "Terrorists" then
                    CTCard = ReplicatedStorage.Assets.UI.Team.TCard
                end
            end
        end
        local u156 = CTCard:Clone()
        u156.Amount.Text = tostring(v8)
        u156.Position = UDim2.fromScale(0.5, 1)
        u156.Name = tostring(v8)
        u156.Animation.ImageTransparency = 1
        u156.Animation.Visible = false
        u156.Parent = u53.Cards
        u156.Rotation = -10
        u156.Visible = true
        applyPreferenceColorToCard(u156, GetPreferenceColor())
        for i, j in u53.Cards:GetChildren() do
            v7 = (tonumber(j.Name)) - (math.floor((v8 + 1) / 2))
            v1 = not (v8 == 1) and v7 * 0.2617993877991494 or 0
            v2 = if not (v8 >= 3) then 0.85 else if j.Name ~= "1" then if j.Name ~= "2" then 0.85 else 0.75 else 0.75
            v3 = if not (v8 >= 3) then 0.05 else if j.Name ~= "1" then if j.Name ~= "2" then 0.05 else 0.125 else 0.25
            v4 = TweenService
            v5 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            v6 = {
                Position = UDim2.fromScale(math.sin(v1) * v2 + 0.5, math.cos(v1) * v3 + 0.45),
                Rotation = math.deg(v1),
            }
            v4:Create(j, v5, v6):Play()
        end
        tweenKillHighlight(u156, 0.2, u52)
        task.delay(0.5, function() -- Line: 142
            -- upvalues: u156 (val), tweenKillHighlight (upval), LocalPlayer (upval), u47 (upval), u42 (upval)
            if u156 and u156:FindFirstChild("Animation") then
                tweenKillHighlight(u156, 1, if LocalPlayer:GetAttribute("Team") ~= "Terrorists" then u42 else u47)
                return
            end
        end)
        return
    end
end

function u0.OpenFrame() -- Line: 152
    -- upvalues: u54 (ref), u53 (ref), GetPreferenceColor (val), LocalPlayer (val), u47 (val), u42 (val)
    u54.Gameplay.Bottom.Middle.Spectate.Visible = false
    u53.Cards.Visible = true
    u53.Visible = true
    local v1 = GetPreferenceColor()
    u53.Team.Outline.ImageColor3 = v1
    u53.Line1.ImageColor3 = v1
    u53.Line2.ImageColor3 = v1
    local Attribute = LocalPlayer:GetAttribute("Team")
    u53.Team.Team.CT.Visible = Attribute == "Counter-Terrorists"
    u53.Team.Team.T.Visible = Attribute == "Terrorists"
    u53.Team.Team.ImageColor3 = if LocalPlayer:GetAttribute("Team") ~= "Terrorists" then u42 else u47
end

function u0.CloseFrame() -- Line: 159 -- upvalues: u53 (ref)
    u53.Cards:ClearAllChildren()
    u53.Cards.Visible = false
    u53.Visible = false
end

function u0.Initialize(a1, a2) -- Line: 168
    -- upvalues: u54 (ref), u53 (ref), GetPreferenceColor (val), LocalPlayer (val), u47 (val), u42 (val)
    -- upvalues: applyPreferenceColorToCard (val), DataController (val)
    u54 = a1
    u53 = a2

    local function refreshTeamColors() -- Line: 179
        -- upvalues: GetPreferenceColor (upval), u53 (upval), LocalPlayer (upval), u47 (upval), u42 (upval)
        -- upvalues: applyPreferenceColorToCard (upval)
        local v1 = GetPreferenceColor()
        u53.Team.Outline.ImageColor3 = v1
        u53.Line1.ImageColor3 = v1
        u53.Line2.ImageColor3 = v1
        local Attribute = LocalPlayer:GetAttribute("Team")
        u53.Team.Team.CT.Visible = Attribute == "Counter-Terrorists"
        u53.Team.Team.T.Visible = Attribute == "Terrorists"
        u53.Team.Team.ImageColor3 = if LocalPlayer:GetAttribute("Team") ~= "Terrorists" then u42 else u47
        v1 = GetPreferenceColor()
        for i, j in u53.Cards:GetChildren() do
            if j:IsA("ImageLabel")
                and j:FindFirstChild("Amount")
                and j:FindFirstChild("Skull1")
                and j:FindFirstChild("Skull2")
                and j:FindFirstChild("Animation") then
                applyPreferenceColorToCard(j, v1)
            end
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshTeamColors)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshTeamColors)
end

function u0.Start() -- Line: 205 -- upvalues: LocalPlayer (val), u0 (val), Remotes (val), u53 (ref)
    LocalPlayer.CharacterAdded:Connect(u0.OpenFrame)
    LocalPlayer.CharacterRemoving:Connect(u0.CloseFrame)
    if not LocalPlayer.Character or LocalPlayer:GetAttribute("IsSpectating") then
        u0.CloseFrame()
    else
        u0.OpenFrame()
    end
    Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 225 -- upvalues: u53 (upval), LocalPlayer (upval), u0 (upval)
        if u53.Visible and LocalPlayer.UserId == tonumber(a1.Killer) then
            u0.createAnimationFrame(a1)
        end
    end)
end

return u0