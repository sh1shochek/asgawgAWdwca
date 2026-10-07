-- ReplicatedStorage.Interface.Screens.Gameplay.Top.Bomb Defusal
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Top.Bomb Defusal
-- Decompile time: 11.57 ms

local u0 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u72 = Color3.fromRGB(85, 255, 85)
local u77 = Color3.fromRGB(250, 31, 31)
local u82 = Color3.fromRGB(85, 255, 85)
local u87 = Color3.fromRGB(230, 36, 36)
local u94 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
local u95 = {"Counter-Terrorists", "Terrorists"}
local u102 = Color3.fromRGB(255, 255, 255)
local u107 = Color3.fromRGB(165, 20, 20)
local u108 = {"IsSpectating", "Dead", "Health"}
local u112 = {}
local u113 = {}
local u114 = {}
local u115 = {}
local u116 = {}
local u117 = {["Counter-Terrorists"] = {}, Terrorists = {}}
local u120 = nil
local u121 = nil
local u122 = nil
local u123 = nil
local u124 = nil

local function clearFrame(a1) -- Line: 77
    for i, j in a1:GetChildren() do
        if j.ClassName == "Frame" and j.Name ~= "MorePlayers" then
            j:Destroy()
        end
    end
end

local function IsPlayableTeam(a1) -- Line: 85
    local v1 = true
    if a1 ~= "Counter-Terrorists" then
        v1 = a1 == "Terrorists"
    end
    return v1
end

local function GetPlayerAlive(a1) -- Line: 89 -- upvalues: Participants (val) -- types: a1: userdata
    local v1 = false
    if a1:GetAttribute("IsSpectating") ~= true then
        v1 = Participants.IsAlive(a1)
    end
    return v1
end

local function RefreshTeamHud(a1) -- Line: 93
    -- upvalues: u116 (val), u117 (val), u114 (val), PlayerInfo (val), Participants (val)
    local v1, v2
    local v3 = u116[a1]
    local v4 = u117[a1]
    local v5 = 0
    for i, v in ipairs(v4) do
        if u114[v] == true then
            v5 = v5 + 1
        end
    end
    v3.playerCountLabel.Text = tostring(v5)
    local v6 = #v4
    local v7 = if not (v6 > 10) then v6 else 9
    local v8 = if not v2 then 0 else v6 - 9
    v3.morePlayersFrame.Visible = v8 > 0
    v3.morePlayersAmountLabel.Text = ("+%*"):format(v8)
    for i2, i3 in ipairs(v4) do
        v1 = PlayerInfo.getTemplateByUserId(Participants.Key(i3))
        if v1 and v1.Parent == v3.holder then
            v1.Visible = i2 <= v7
        end
    end
end

local function RefreshAllTeamHuds() -- Line: 121 -- upvalues: u95 (val), RefreshTeamHud (val)
    for i, v in ipairs(u95) do
        RefreshTeamHud(v)
    end
end

local function RemovePlayerFromRoster(a1) -- Line: 127 -- upvalues: u115 (val), u117 (val) -- types: a1: userdata
    local v1 = u115[a1]
    u115[a1] = nil
    local v2 = true
    if v1 ~= "Counter-Terrorists" then
        v2 = v1 == "Terrorists"
    end
    if not v2 then
        return nil
    end
    v2 = u117[v1]
    for i, v in ipairs(v2) do
        if v == a1 then
            table.remove(v2, i)
            return v1
        end
    end
    return v1
end

local function SetPlayerRosterTeam(a1, a2) -- Line: 145
    -- upvalues: u115 (val), RemovePlayerFromRoster (val), u117 (val)
    if u115[a1] == a2 then
        return nil
    end
    local v1 = RemovePlayerFromRoster(a1)
    u115[a1] = a2
    table.insert(u117[a2], a1)
    return v1
end

local function SetPlayerAliveState(a1, a2) -- Line: 156
    -- upvalues: u114 (val), u115 (val), RefreshTeamHud (val)
    if u114[a1] == a2 then
        return
    end
    u114[a1] = a2
    local v1 = u115[a1]
    local v2 = true
    if v1 ~= "Counter-Terrorists" then
        v2 = v1 == "Terrorists"
    end
    if v2 then
        RefreshTeamHud(v1)
    end
end

local function RefreshPlayerAliveState(a1) -- Line: 168
    -- upvalues: Participants (val), u114 (val), u115 (val), RefreshTeamHud (val)
    local v1 = false
    if a1:GetAttribute("IsSpectating") ~= true then
        v1 = Participants.IsAlive(a1)
    end
    if u114[a1] == v1 then
        return
    end
    u114[a1] = v1
    local v2 = u115[a1]
    local v3 = true
    if v2 ~= "Counter-Terrorists" then
        v3 = v2 == "Terrorists"
    end
    if v3 then
        RefreshTeamHud(v2)
    end
end

local function ResetRosterState() -- Line: 172
    -- upvalues: u95 (val), u117 (val), u115 (val), u114 (val), RefreshTeamHud (val)
    for i, v in ipairs(u95) do
        table.clear(u117[v])
    end
    table.clear(u115)
    table.clear(u114)
    for i2, i3 in ipairs(u95) do
        RefreshTeamHud(i3)
    end
end

local function UpdateFrameVisibility() -- Line: 182 -- upvalues: u121 (ref), u120 (ref)
    local Attribute = workspace:GetAttribute("Gamemode")
    local v1 = true
    if Attribute ~= "Hostage Rescue" then
        v1 = Attribute == "Bomb Defusal"
    end
    local v2 = not u121.Gameplay.Middle.TeamSelection.Visible
    u120.Visible = v1 and v2
end

local function StopBombGlow() -- Line: 190 -- upvalues: u124 (ref), u120 (ref)
    if u124 then
        u124:Cancel()
        u124 = nil
    end
    u120.Time.Bomb.Glow.ImageTransparency = 0.75
end

local function StartBombGlow() -- Line: 199 -- upvalues: u124 (ref), u120 (ref), TweenService (val), u94 (val)
    if u124 then
        return
    end
    u120.Time.Bomb.Glow.ImageTransparency = 0.75
    u124 = TweenService:Create(u120.Time.Bomb.Glow, u94, {ImageTransparency = 0})
    u124:Play()
end

local function UpdateBombDisplay() -- Line: 211
    -- upvalues: u122 (ref), u124 (ref), u120 (ref), u77 (val), u87 (val), u82 (val), u72 (val), StartBombGlow (val)
    local v1
    local v2 = u122
    if not v2 then
        if u124 then
            u124:Cancel()
            u124 = nil
        end
        u120.Time.Bomb.Glow.ImageTransparency = 0.75
        u120.Time.Bomb.Glow.ImageColor3 = u77
        u120.Time.Bomb.ImageColor3 = u87
        u120.Time.Timer.Visible = true
        u120.Time.Bomb.Visible = false
        return
    end
    u120.Time.Timer.Visible = false
    u120.Time.Bomb.Visible = true
    local v3 = v2:GetAttribute("Defused") == true and u82 or u87
    local v4 = v1 and u72 or u77
    u120.Time.Bomb.Glow.ImageColor3 = v4
    u120.Time.Bomb.ImageColor3 = v3
    if not v1 then
        StartBombGlow()
        return
    end
    if u124 then
        u124:Cancel()
        u124 = nil
    end
    u120.Time.Bomb.Glow.ImageTransparency = 0.75
end

local function SetCurrentBomb(a1) -- Line: 240
    -- upvalues: u123 (ref), u122 (ref), UpdateBombDisplay (val)
    if u123 then
        u123:Disconnect()
        u123 = nil
    end
    u122 = a1
    if u122 then
        u123 = (u122:GetAttributeChangedSignal("Defused")):Connect(UpdateBombDisplay)
    end
    UpdateBombDisplay()
end

function u0.CreateTemplate(a1) -- Line: 258
    -- upvalues: Profiler (val), u0 (val), PlayerInfo (val), u120 (ref), u112 (val)
    Profiler.scope("UI.BombDefusal.CreateTemplate", function() -- Line: 259 -- upvalues: a1 (val), u0 (upval), PlayerInfo (upval), u120 (upval), u112 (upval)
        local Attribute = workspace:GetAttribute("Gamemode")
        local Attribute_2 = a1:GetAttribute("Team")
        if Attribute == "Bomb Defusal" or Attribute == "Hostage Rescue" then
            u0.CleanupTemplate(a1)
            local v1 = PlayerInfo.createTemplate(a1, u120[Attribute_2])
            if v1 then
                u112[a1] = v1
            end
        end
    end)
end

function u0.CleanupTemplate(a1) -- Line: 273 -- upvalues: u112 (val), PlayerInfo (val) -- types: a1: userdata
    local v1 = u112[a1]
    u112[a1] = nil
    if v1 then
        PlayerInfo.cleanupTemplate(a1)
        v1:Destroy()
    end
end

function u0.PlayerAdded(a1) -- Line: 282
    -- upvalues: u113 (val), Janitor (val), u115 (val), RemovePlayerFromRoster (val), u117 (val), u114 (val)
    -- upvalues: Participants (val), u0 (val), RefreshTeamHud (val), LocalPlayer (val), u95 (val), PlayerInfo (val)
    -- upvalues: u108 (val)
    local v1 = u113[a1]
    if v1 then
        v1:Destroy()
    end
    local v2 = Janitor.new()
    u113[a1] = v2

    local function handleTeamUpdate() -- Line: 291
        -- upvalues: a1 (val), u115 (upval), RemovePlayerFromRoster (upval), u117 (upval), u114 (upval)
        -- upvalues: Participants (upval), u0 (upval), RefreshTeamHud (upval), LocalPlayer (upval), u95 (upval)
        -- upvalues: PlayerInfo (upval)
        local v1
        local Attribute = a1:GetAttribute("Team")
        local v2 = true
        if Attribute ~= "Counter-Terrorists" then
            v2 = Attribute == "Terrorists"
        end
        if not v2 then
            v2 = RemovePlayerFromRoster(a1)
            u114[a1] = nil
            u0.CleanupTemplate(a1)
            if v2 then
                RefreshTeamHud(v2)
            end
            return
        end
        local v3 = a1
        if u115[v3] ~= Attribute then
            v1 = RemovePlayerFromRoster(v3)
            u115[v3] = Attribute
            table.insert(u117[Attribute], v3)
            v2 = v1
        else
            v2 = nil
        end
        v3 = u114
        local v4 = a1
        local v5 = false
        if v4:GetAttribute("IsSpectating") ~= true then
            v5 = Participants.IsAlive(v4)
        end
        v3[a1] = v5
        u0.CreateTemplate(a1)
        if v2 then
            RefreshTeamHud(v2)
        end
        RefreshTeamHud(Attribute)
        if a1 == LocalPlayer then
            local Attribute_2, v6
            v3 = Participants.GetAll()
            v1 = nil
            v5 = nil
            for i, j in v3, v1, v5 do
                if j ~= LocalPlayer then
                    Attribute_2 = j:GetAttribute("Team")
                    v6 = true
                    if Attribute_2 ~= "Counter-Terrorists" then
                        v6 = Attribute_2 == "Terrorists"
                    end
                    if not v6 then
                        u0.CleanupTemplate(j)
                    else
                        u0.CreateTemplate(j)
                    end
                end
            end
            for i2, v in ipairs(u95) do
                RefreshTeamHud(v)
            end
        end
        PlayerInfo.refreshCompetitiveColors()
    end

    v2:Add(((a1:GetAttributeChangedSignal("Team")):Connect(handleTeamUpdate)))
    for i, v in ipairs(u108) do
        v2:Add(((a1:GetAttributeChangedSignal(v)):Connect(function() -- Line: 332 -- upvalues: a1 (val), Participants (upval), u114 (upval), u115 (upval), RefreshTeamHud (upval)
            local v1 = a1
            local v2 = false
            if v1:GetAttribute("IsSpectating") ~= true then
                v2 = Participants.IsAlive(v1)
            end
            if u114[v1] == v2 then
                return
            end
            u114[v1] = v2
            local v3 = u115[v1]
            local v4 = true
            if v3 ~= "Counter-Terrorists" then
                v4 = v3 == "Terrorists"
            end
            if v4 then
                RefreshTeamHud(v3)
            end
        end)))
    end
    v2:Add(function() -- Line: 336 -- upvalues: RemovePlayerFromRoster (upval), a1 (val), u114 (upval), RefreshTeamHud (upval)
        local v1 = RemovePlayerFromRoster(a1)
        u114[a1] = nil
        if v1 then
            RefreshTeamHud(v1)
        end
    end)
    handleTeamUpdate()
end

function u0.Initialize(a1, a2) -- Line: 350
    -- upvalues: u121 (ref), u120 (ref), u95 (val), u116 (val), Observers (val), PlayerInfo (val), Remotes (val)
    -- upvalues: Participants (val), u114 (val), u115 (val), RefreshTeamHud (val), GameState (val), u102 (val)
    -- upvalues: GetTimerFormat (val), u107 (val), UpdateFrameVisibility (val), CollectionService (val)
    -- upvalues: SetCurrentBomb (val), u122 (ref), u123 (ref), UpdateBombDisplay (val)
    local v1, v2, v3
    u121 = a1
    u120 = a2
    for i, v in ipairs(u95) do
        v1 = u120[v]
        v2 = u116
        v3 = {
            holder = v1,
            playerCountLabel = u120.Time[v].Players,
            morePlayersFrame = v1.MorePlayers,
            morePlayersAmountLabel = v1.MorePlayers.Amount,
        }
        v2[v] = v3
    end
    Observers.observeAttribute(workspace, "CTScore", function(a1) -- Line: 363 -- upvalues: u120 (upval)
        u120.Time["Counter-Terrorists"].Score.Text = tostring(a1)
        return function() end
    end)
    Observers.observeAttribute(workspace, "TScore", function(a1) -- Line: 368 -- upvalues: u120 (upval)
        u120.Time.Terrorists.Score.Text = tostring(a1)
        return function() end
    end)
    Observers.observeAttribute(workspace, "ServerGamemode", function(a1) -- Line: 373 -- upvalues: PlayerInfo (upval)
        PlayerInfo.refreshCompetitiveColors()
        return function() end
    end)
    Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 378
        -- upvalues: Participants (upval), PlayerInfo (upval), u114 (upval), u115 (upval), RefreshTeamHud (upval)
        local v1
        local v2 = tonumber(a1.Victim)
        local v3 = Participants.FromKey(v2)
        if v3 then
            local v4
            v1 = PlayerInfo.getTemplateByUserId(v2)
            if v1 and v1.Parent then
                v4 = v3:GetAttribute("IsSpectating") == true
                if not Participants.IsAlive(v3) or v4 then
                    PlayerInfo.applyTemplateLifeState(v1, true)
                end
            end
            v4 = false
            if v3:GetAttribute("IsSpectating") ~= true then
                v4 = Participants.IsAlive(v3)
            end
            if u114[v3] ~= v4 then
                u114[v3] = v4
                local v5 = u115[v3]
                local v6 = true
                if v5 ~= "Counter-Terrorists" then
                    v6 = v5 == "Terrorists"
                end
                if v6 then
                    RefreshTeamHud(v5)
                end
            end
        end
        v1 = tonumber(a1.Killer)
        if Participants.FromKey(v1) then
            PlayerInfo.incrementTemplateKills(v1)
        end
    end)
    Remotes.UI.RoundWinner.Listen(function(a1) -- Line: 404 -- upvalues: PlayerInfo (upval)
        PlayerInfo.setTeammateInfoRevealed(true)
    end)
    GameState.ListenToState(function(a1, a2) -- Line: 408 -- upvalues: PlayerInfo (upval) -- types: a1: string?, a2: string
        if a2 == "Buy Period" then
            PlayerInfo.setTeammateInfoRevealed(true)
            return
        end
        if a1 == "Buy Period" and a2 == "Round In Progress" then
            PlayerInfo.setTeammateInfoRevealed(false)
        end
    end)
    Observers.observeAttribute(workspace, "Timer", function(a1) -- Line: 419 -- upvalues: u120 (upval), u102 (upval), GetTimerFormat (upval), u107 (upval)
        local Attribute = workspace:GetAttribute("Gamemode")
        local Attribute_2 = workspace:GetAttribute("GameState")
        u120.Time.Timer.TextColor3 = u102
        u120.Time.Timer.Text = GetTimerFormat(a1)
        if Attribute == "Hostage Rescue" then
            if Attribute_2 ~= "Warmup" and a1 <= 10 then
                u120.Time.Timer.TextColor3 = u107
            end
        elseif Attribute == "Bomb Defusal" and Attribute_2 ~= "Warmup" and a1 <= 10 then
            u120.Time.Timer.TextColor3 = u107
        end
        return function() end
    end, function(a1) -- Line: 434
        return typeof(a1) == "number"
    end)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(UpdateFrameVisibility)
    ;(u121.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible")):Connect(UpdateFrameVisibility)
    ;(CollectionService:GetInstanceAddedSignal("Bomb")):Connect(SetCurrentBomb)
    ;(CollectionService:GetInstanceRemovedSignal("Bomb")):Connect(function(a1) -- Line: 443 -- upvalues: u122 (upval), u123 (upval), UpdateBombDisplay (upval) -- types: a1: userdata
        if a1 == u122 then
            if u123 then
                u123:Disconnect()
                u123 = nil
            end
            u122 = nil
            if u122 then
                u123 = (u122:GetAttributeChangedSignal("Defused")):Connect(UpdateBombDisplay)
            end
            UpdateBombDisplay()
        end
    end)
    local Attribute = workspace:GetAttribute("Gamemode")
    local v4 = true
    if Attribute ~= "Hostage Rescue" then
        v4 = Attribute == "Bomb Defusal"
    end
    local v5 = not u121.Gameplay.Middle.TeamSelection.Visible
    u120.Visible = v4 and v5
    local v6 = CollectionService:GetTagged("Bomb")[1]
    if u123 then
        u123:Disconnect()
        u123 = nil
    end
    u122 = v6
    if u122 then
        u123 = (u122:GetAttributeChangedSignal("Defused")):Connect(UpdateBombDisplay)
    end
    UpdateBombDisplay()
    for i2, i3 in ipairs(u95) do
        RefreshTeamHud(i3)
    end
end

function u0.Start() -- Line: 454
    -- upvalues: clearFrame (val), u120 (ref), ResetRosterState (val), Players (val), u0 (val), u113 (val)
    -- upvalues: Participants (val)
    clearFrame(u120["Counter-Terrorists"])
    clearFrame(u120.Terrorists)
    ResetRosterState()
    for i, j in Players:GetPlayers() do
        u0.PlayerAdded(j)
    end
    Players.PlayerAdded:Connect(u0.PlayerAdded)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 465 -- upvalues: u113 (upval), u0 (upval) -- types: a1: userdata
        local v1 = u113[a1]
        u113[a1] = nil
        if v1 then
            v1:Destroy()
        end
        u0.CleanupTemplate(a1)
    end)
    Participants.Observe(function(a1) -- Line: 476 -- upvalues: Participants (upval), u0 (upval) -- types: a1: userdata
        if Participants.IsBot(a1) then
            u0.PlayerAdded(a1)
        end
    end, function(a1) -- Line: 480 -- upvalues: Participants (upval), u113 (upval), u0 (upval) -- types: a1: userdata
        if Participants.IsBot(a1) then
            local v1 = u113[a1]
            u113[a1] = nil
            if v1 then
                v1:Destroy()
            end
            u0.CleanupTemplate(a1)
        end
    end)
end

return u0