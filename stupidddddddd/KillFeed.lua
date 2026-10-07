-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.KillFeed
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.KillFeed
-- Decompile time: 6.49 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
require(script:WaitForChild("Types"))
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local u53 = UDim2.new(0.99, 0, 0.18, 0)
local u59 = UDim2.new(0.99, 0, 0.068, 0)
local u63 = UDim.new(0, 5)
local u68 = Color3.fromRGB(255, 0, 0)
local u73 = Color3.fromRGB(165, 183, 212)
local u78 = Color3.fromRGB(219, 199, 126)
local u83 = Color3.fromRGB(255, 255, 255)
local LocalPlayer = Players.LocalPlayer
local u85 = nil
local u86 = {}
local u87 = {
    [2] = "got a Multi Kill",
    [3] = "is on a Killing Spree",
    [4] = "is on a Rampage",
    [5] = "is Dominating",
    [6] = "got a M-M-Monster Kill",
    [7] = "is going Ludicrus",
    [8] = "is Unstoppable",
    [9] = "is Godlike",
}
local u96 = {
    "Weapon",
    "Headshot",
    "NoScope",
    "Smoke",
    "Wallbang",
    "Blind",
    "Jump",
    "FlashAssist",
    "Addition",
    "Assistor",
    "Enemy",
}

local function applyParticipantLabel(a1, a2, a3, a4) -- Line: 67
    -- upvalues: Participants (val), LocalPlayer (val), u68 (val), u73 (val), u78 (val)
    local Attribute = a3:GetAttribute("Team")
    a2.Text = Participants.DisplayName(a3)
    a2.Visible = true
    if LocalPlayer.UserId == a4 then
        a1.UIStroke.Color = u68
    end
    if Attribute == "Counter-Terrorists" then
        a2.TextColor3 = u73
        return
    end
    if Attribute == "Terrorists" then
        a2.TextColor3 = u78
    end
end

local function convertTextLabel(a1, a2, a3) -- Line: 83
    -- upvalues: Participants (val), LocalPlayer (val), u68 (val), u73 (val), u78 (val)
    if not a3 then
        return
    end
    local v1 = Participants.FromKey(a3)
    if v1 and v1.Parent then
        local Attribute = v1:GetAttribute("Team")
        a2.Text = Participants.DisplayName(v1)
        a2.Visible = true
        if LocalPlayer.UserId == a3 then
            a1.UIStroke.Color = u68
        end
        if Attribute == "Counter-Terrorists" then
            a2.TextColor3 = u73
            return
        end
        if Attribute ~= "Terrorists" then
            return
        end
        a2.TextColor3 = u78
        return
    end
    a2.Visible = false
end

local function applyContentPadding(a1) -- Line: 95 -- upvalues: u63 (val) -- types: a1: userdata
    local UIPadding = a1:FindFirstChild("UIPadding")
    if not UIPadding then
        UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = a1
    end
    UIPadding.PaddingLeft = u63
    UIPadding.PaddingRight = u63
end

local function scheduleFadeOut(a1) -- Line: 105 -- upvalues: TweenService (val), Debris (val)
    task.delay(5, function() -- Line: 106 -- upvalues: TweenService (upval), a1 (val), Debris (upval)
        TweenService:Create(a1, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(a1.UIStroke, TweenInfo.new(1), {Transparency = 1}):Play()
        Debris:AddItem(a1, 1)
    end)
end

local function createStreakTemplate(a1, a2) -- Line: 117
    -- upvalues: ReplicatedStorage (val), u96 (val), u63 (val), Participants (val), Debris (val), LocalPlayer (val)
    -- upvalues: u68 (val), u73 (val), u78 (val), u83 (val), u85 (ref), TweenService (val)
    local u9 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone()
    local Contents = u9.Contents
    for i, v in ipairs(u96) do
        Contents[v].Visible = false
    end
    local UIPadding = Contents:FindFirstChild("UIPadding")
    if not UIPadding then
        UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = Contents
    end
    UIPadding.PaddingLeft = u63
    UIPadding.PaddingRight = u63
    local Player = Contents.Player
    local v1 = Participants.FromKey(a1)
    if v1 and v1.Parent then
        local Attribute = v1:GetAttribute("Team")
        Player.Text = Participants.DisplayName(v1)
        Player.Visible = true
        if LocalPlayer.UserId == a1 then
            u9.UIStroke.Color = u68
        end
        if Attribute == "Counter-Terrorists" then
            Player.TextColor3 = u73
        elseif Attribute == "Terrorists" then
            Player.TextColor3 = u78
        end
        local Enemy = Contents.Enemy
        Enemy.Text = a2
        Enemy.TextColor3 = u83
        Enemy.Visible = true
        Player.LayoutOrder = 0
        Enemy.LayoutOrder = 1
        u9.Visible = true
        u9.Parent = u85
        task.delay(5, function() -- Line: 106 -- upvalues: TweenService (upval), u9 (val), Debris (upval)
            TweenService:Create(u9, TweenInfo.new(1), {GroupTransparency = 1}):Play()
            TweenService:Create(u9.UIStroke, TweenInfo.new(1), {Transparency = 1}):Play()
            Debris:AddItem(u9, 1)
        end)
        return
    end
    Debris:AddItem(u9, 0)
end

function u0.createTemplate(a1) -- Line: 157
    -- upvalues: ReplicatedStorage (val), u85 (ref), u63 (val), Participants (val), LocalPlayer (val), u68 (val)
    -- upvalues: u73 (val), u78 (val), TweenService (val), Debris (val)
    local v1
    local v2 = require(ReplicatedStorage.Database.Custom.Weapons[a1.Weapon])
    u85.Visible = true
    local u18 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone()
    local Contents = u18.Contents
    local UIPadding = Contents:FindFirstChild("UIPadding")
    if not UIPadding then
        UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = Contents
    end
    UIPadding.PaddingLeft = u63
    UIPadding.PaddingRight = u63
    local Player = u18.Contents.Player
    local v3 = tonumber(a1.Killer)
    if v3 then
        v1 = Participants.FromKey(v3)
        if not v1 or not v1.Parent then
            Player.Visible = false
        else
            local Attribute = v1:GetAttribute("Team")
            Player.Text = Participants.DisplayName(v1)
            Player.Visible = true
            if LocalPlayer.UserId == v3 then
                u18.UIStroke.Color = u68
            end
            if Attribute == "Counter-Terrorists" then
                Player.TextColor3 = u73
            elseif Attribute == "Terrorists" then
                Player.TextColor3 = u78
            end
        end
    end
    local Enemy = u18.Contents.Enemy
    v3 = tonumber(a1.Victim)
    if v3 then
        v1 = Participants.FromKey(v3)
        if not v1 or not v1.Parent then
            Enemy.Visible = false
        else
            local Attribute_2 = v1:GetAttribute("Team")
            Enemy.Text = Participants.DisplayName(v1)
            Enemy.Visible = true
            if LocalPlayer.UserId == v3 then
                u18.UIStroke.Color = u68
            end
            if Attribute_2 == "Counter-Terrorists" then
                Enemy.TextColor3 = u73
            elseif Attribute_2 == "Terrorists" then
                Enemy.TextColor3 = u78
            end
        end
    end
    if not a1.Assistor then
        u18.Contents.Assistor.Visible = false
        u18.Contents.Addition.Visible = false
        u18.Contents.FlashAssist.Visible = false
    else
        local Assistor = u18.Contents.Assistor
        v3 = tonumber(a1.Assistor)
        if v3 then
            v1 = Participants.FromKey(v3)
            if not v1 or not v1.Parent then
                Assistor.Visible = false
            else
                local Attribute_3 = v1:GetAttribute("Team")
                Assistor.Text = Participants.DisplayName(v1)
                Assistor.Visible = true
                if LocalPlayer.UserId == v3 then
                    u18.UIStroke.Color = u68
                end
                if Attribute_3 == "Counter-Terrorists" then
                    Assistor.TextColor3 = u73
                elseif Attribute_3 == "Terrorists" then
                    Assistor.TextColor3 = u78
                end
            end
        end
        u18.Contents.Addition.Visible = true
        u18.Contents.FlashAssist.Visible = a1.FlashAssist == true
    end
    u18.Contents.Weapon.Image = v2.ReverseIcon
    u18.Contents.Headshot.Visible = a1.Headshot
    u18.Contents.NoScope.Visible = a1.NoScope == true
    u18.Contents.Smoke.Visible = a1.Smoke == true
    u18.Contents.Blind.Visible = a1.Blind == true
    u18.Contents.Wallbang.Visible = a1.Wallbang == true
    u18.Contents.Jump.Visible = a1.Jump == true
    ;(u18.Contents:GetPropertyChangedSignal("AbsoluteSize")):Connect(function() -- Line: 189 -- upvalues: u18 (val)
        local Player = u18.Contents.Player
        if Player and 0 < Player.AbsoluteSize.Y then
            local v1 = Player.AbsoluteSize.Y * 0.84 * 1.67
            u18.Contents.Headshot.Size = UDim2.new(0, v1, 0, v1)
            u18.Contents.NoScope.Size = UDim2.new(0, v1 * 0.8333333333333334, 0, v1 * 0.8333333333333334)
            u18.Contents.Smoke.Size = UDim2.new(0, v1 * 1.1111111111111112, 0, v1 * 0.7777777777777778)
            u18.Contents.Wallbang.Size = UDim2.new(0, v1 * 1.1111111111111112, 0, v1 * 1.1111111111111112)
            u18.Contents.Blind.Size = UDim2.new(0, v1 * 0.8333333333333334, 0, v1 * 0.8333333333333334)
            u18.Contents.Jump.Size = UDim2.new(0, v1, 0, v1)
            u18.Contents.FlashAssist.Size = UDim2.new(0, v1, 0, v1)
        end
    end)
    local Contents_2 = u18.Contents
    local u240 = 0

    local function placeNext(a1) -- Line: 213 -- upvalues: u240 (ref) -- types: a1: userdata
        a1.LayoutOrder = u240
        u240 = u240 + 1
    end

    if a1.Blind == true then
        Contents_2.Blind.LayoutOrder = u240
        u240 = u240 + 1
    end
    Contents_2.Player.LayoutOrder = u240
    u240 = u240 + 1
    if a1.Assistor then
        Contents_2.Addition.LayoutOrder = u240
        u240 = u240 + 1
        if a1.FlashAssist == true then
            Contents_2.FlashAssist.LayoutOrder = u240
            u240 = u240 + 1
        end
        Contents_2.Assistor.LayoutOrder = u240
        u240 = u240 + 1
    end
    if a1.Jump == true then
        Contents_2.Jump.LayoutOrder = u240
        u240 = u240 + 1
    end
    Contents_2.Weapon.LayoutOrder = u240
    u240 = u240 + 1
    for i, v in ipairs({"NoScope", "Smoke", "Wallbang", "Headshot"}) do
        if a1[v] == true then
            Contents_2[v].LayoutOrder = u240
            u240 = u240 + 1
        end
    end
    Contents_2.Enemy.LayoutOrder = u240
    u18.Visible = true
    u18.Parent = u85
    task.delay(5, function() -- Line: 106 -- upvalues: TweenService (upval), u18 (val), Debris (upval)
        TweenService:Create(u18, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(u18.UIStroke, TweenInfo.new(1), {Transparency = 1}):Play()
        Debris:AddItem(u18, 1)
    end)
end

function u0.Initialize(a1, a2) -- Line: 249
    -- upvalues: u85 (ref), GetUserPlatform (val), u53 (val), u59 (val), ReplicatedStorage (val), Remotes (val)
    -- upvalues: u0 (val), u86 (val), u87 (val), createStreakTemplate (val), GameState (val)
    a2.Position = if not (table.find(GetUserPlatform(), "Mobile") ~= nil) then u59 else u53
    local Kill = (((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("UI")):WaitForChild("KillFeed")):WaitForChild("Kill")
    Kill.AutoLocalize = false
    for i, j in Kill:GetDescendants() do
        if j:IsA("GuiBase2d") then
            j.AutoLocalize = false
        end
    end
    Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 265 -- upvalues: u0 (upval), u86 (upval), u87 (upval), createStreakTemplate (upval)
        u0.createTemplate(a1)
        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            local Killer = a1.Killer
            u86[a1.Victim] = 0
            local v1 = (u86[Killer] or 0) + 1
            u86[Killer] = v1
            local v2 = u87[math.min(v1, 9)]
            if v2 then
                local v3 = tonumber(Killer)
                createStreakTemplate(v3, v2)
            end
        end
    end)
    GameState.ListenToState(function() -- Line: 285 -- upvalues: u86 (upval)
        table.clear(u86)
    end)
end

return u0