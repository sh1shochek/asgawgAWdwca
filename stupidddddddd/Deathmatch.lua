-- ReplicatedStorage.Interface.Screens.Gameplay.Top.Deathmatch
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Top.Deathmatch
-- Decompile time: 3.10 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local PlayerInfo = require(ReplicatedStorage.Interface.Screens.Gameplay.Top.PlayerInfo)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local u56 = Color3.fromRGB(255, 255, 255)
local u61 = Color3.fromRGB(165, 20, 20)
local u62 = nil
local u63 = nil
local u64 = {}
local u65 = {}

local function clearFrame(a1) -- Line: 46
    for i, v in ipairs(a1:GetChildren()) do
        if v.ClassName == "Frame" and v.Name ~= "MorePlayers" then
            v:Destroy()
        end
    end
end

local function compareLayoutOrder(a1, a2) -- Line: 54 -- types: a1: userdata, a2: userdata
    return a1.LayoutOrder < a2.LayoutOrder
end

local function updateFrameVisibility() -- Line: 59 -- upvalues: u62 (ref), u63 (ref), compareLayoutOrder (val)
    if u62 and u63 then
        local v1
        local v2 = u62
        local v3 = false
        if (workspace:GetAttribute("Gamemode")) == "Deathmatch" then
            v3 = not u63.Gameplay.Middle.TeamSelection.Visible
        end
        v2.Visible = v3
        if not u62.Visible then
            return
        end
        local MorePlayers = u62.Players.MorePlayers
        v3 = {}
        for i, v in ipairs(u62.Players:GetChildren()) do
            if v.ClassName == "Frame" and v.Name ~= "MorePlayers" then
                table.insert(v3, v)
            end
        end
        table.sort(v3, compareLayoutOrder)
        for i2, i3 in ipairs(v3) do
            v1 = i2 <= 5
            i3.Visible = v1
        end
        local v4 = math.max(#v3 - 5, 0)
        MorePlayers.Visible = v4 > 0
        MorePlayers.Content.Amount.Text = ("+%*"):format(v4)
        return
    end
end

function u0.createTemplate(a1) -- Line: 94
    -- upvalues: Profiler (val), u0 (val), PlayerInfo (val), u62 (ref), u64 (val), updateFrameVisibility (val)
    Profiler.scope("UI.Deathmatch.CreateTemplate", function() -- Line: 95
        -- upvalues: a1 (val), u0 (upval), PlayerInfo (upval), u62 (upval), u64 (upval), updateFrameVisibility (upval)
        local Attribute = workspace:GetAttribute("Gamemode")
        local Attribute_2 = a1:GetAttribute("Team")
        if Attribute == "Deathmatch" then
            if Attribute_2 == "Terrorists" or Attribute_2 == "Counter-Terrorists" then
                u0.cleanupPlayerTemplate(a1)
                local v1 = PlayerInfo.createTemplate(a1, u62.Players)
                if v1 then
                    u64[a1] = v1
                end
                updateFrameVisibility()
            end
        end
    end)
end

function u0.cleanupPlayerTemplate(a1) -- Line: 112
    -- upvalues: u64 (val), PlayerInfo (val), updateFrameVisibility (val)
    local v1 = u64[a1]
    u64[a1] = nil
    if v1 then
        PlayerInfo.cleanupTemplate(a1)
        v1:Destroy()
        updateFrameVisibility()
    end
end

function u0.playerAdded(a1) -- Line: 123
    -- upvalues: u65 (val), Janitor (val), PlayerInfo (val), Participants (val), u0 (val), updateFrameVisibility (val)
    local v1 = u65[a1]
    if v1 then
        v1:Destroy()
    end
    local v2 = Janitor.new()
    u65[a1] = v2

    local function applyLifeStateToTemplate() -- Line: 132
        -- upvalues: PlayerInfo (upval), Participants (upval), a1 (val)
        local v1 = PlayerInfo.getTemplateByUserId(Participants.Key(a1))
        if not v1 then
            return
        end
        local v2 = not Participants.IsAlive(a1) or a1:GetAttribute("IsSpectating") == true
        PlayerInfo.applyTemplateLifeState(v1, v2)
    end

    v2:Add(((a1:GetAttributeChangedSignal("Team")):Connect(function() -- Line: 142 -- upvalues: a1 (val), u0 (upval), applyLifeStateToTemplate (val)
        local Attribute = a1:GetAttribute("Team")
        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            u0.cleanupPlayerTemplate(a1)
            return
        end
        u0.createTemplate(a1)
        applyLifeStateToTemplate()
    end)))
    v2:Add(((a1:GetAttributeChangedSignal("IsSpectating")):Connect(applyLifeStateToTemplate)))
    v2:Add(((a1:GetAttributeChangedSignal("Dead")):Connect(applyLifeStateToTemplate)))
    v2:Add(((a1:GetAttributeChangedSignal("Health")):Connect(applyLifeStateToTemplate)))
    v2:Add(((a1:GetAttributeChangedSignal("Score")):Connect(function() -- Line: 156 -- upvalues: updateFrameVisibility (upval)
        task.defer(updateFrameVisibility)
    end)))
    local Attribute = a1:GetAttribute("Team")
    if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
        u0.cleanupPlayerTemplate(a1)
        return
    end
    u0.createTemplate(a1)
    applyLifeStateToTemplate()
end

function u0.Initialize(a1, a2) -- Line: 166
    -- upvalues: u63 (ref), u62 (ref), Observers (val), u56 (val), GetTimerFormat (val), u61 (val), Router (val)
    -- upvalues: updateFrameVisibility (val)
    u62 = a2
    Observers.observeAttribute(workspace, "Timer", function(a1) -- Line: 169 -- upvalues: u62 (upval), u56 (upval), GetTimerFormat (upval), u61 (upval), Router (upval)
        local Attribute = workspace:GetAttribute("Gamemode")
        local Attribute_2 = workspace:GetAttribute("GameState")
        u62.Time.Timer.TextColor3 = u56
        u62.Time.Timer.Text = GetTimerFormat(a1)
        if Attribute == "Deathmatch" and Attribute_2 ~= "Warmup" and a1 <= 10 then
            u62.Time.Timer.TextColor3 = u61
            Router.broadcastRouter("PlayCountdownTimer")
        end
    end)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(updateFrameVisibility)
    ;(a1.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible")):Connect(updateFrameVisibility)
    updateFrameVisibility()
end

function u0.Start() -- Line: 184
    -- upvalues: clearFrame (val), u62 (ref), Players (val), u0 (val), u65 (val), updateFrameVisibility (val)
    -- upvalues: Participants (val)
    clearFrame(u62.Players)
    for i, j in Players:GetPlayers() do
        u0.playerAdded(j)
    end
    Players.PlayerAdded:Connect(u0.playerAdded)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 191 -- upvalues: u65 (upval), u0 (upval), updateFrameVisibility (upval) -- types: a1: userdata
        local v1 = u65[a1]
        u65[a1] = nil
        if v1 then
            v1:Destroy()
        end
        u0.cleanupPlayerTemplate(a1)
        updateFrameVisibility()
    end)
    Participants.Observe(function(a1) -- Line: 203 -- upvalues: Participants (upval), u0 (upval) -- types: a1: userdata
        if Participants.IsBot(a1) then
            u0.playerAdded(a1)
        end
    end, function(a1) -- Line: 207
        -- upvalues: Participants (upval), u65 (upval), u0 (upval), updateFrameVisibility (upval)
        if Participants.IsBot(a1) then
            local v1 = u65[a1]
            u65[a1] = nil
            if v1 then
                v1:Destroy()
            end
            u0.cleanupPlayerTemplate(a1)
            updateFrameVisibility()
        end
    end)
end

return u0