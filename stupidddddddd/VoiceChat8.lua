-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.VoiceChat
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.VoiceChat
-- Decompile time: 4.06 ms

local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VoiceChat = require(ReplicatedStorage.Controllers.InputController.Actions.VoiceChat)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u33 = {"IsSpectating", "Team", "CompetitivePlayerColor", "Dead", "Health"}
local u39 = nil
local u40 = nil
local u41 = {}
local u42 = nil

local function compareVisibleEntries(a1, a2) -- Line: 63 -- types: a1: table, a2: table
    if a1.IsSpeaking ~= a2.IsSpeaking then
        return a1.IsSpeaking
    end
    if a1.LastSpokeAt == a2.LastSpokeAt then
        return a1.Player.UserId < a2.Player.UserId
    end
    return a2.LastSpokeAt < a1.LastSpokeAt
end

local function updateVisibleTemplates(a1) -- Line: 75
    -- upvalues: u41 (val), compareVisibleEntries (val), u39 (ref), u42 (ref)
    local IsSpeaking, v1, v2
    local v3 = {}
    local v4 = a1
    for k, v in pairs(u41) do
        IsSpeaking = v.IsSpeaking
        if not IsSpeaking and v.StoppedAt then
            IsSpeaking = v4 - v.StoppedAt < 2.85
        end
        if not IsSpeaking then
            v.Alpha = 1
            v.Frame.Visible = false
        else
            table.insert(v3, v)
        end
    end
    table.sort(v3, compareVisibleEntries)
    local v5 = 0
    for i, i2 in ipairs(v3) do
        v2 = i <= 3
        i2.Frame.LayoutOrder = i
        i2.Frame.Visible = v2
        if v2 then
            v5 = v5 + 1
            if i2.IsSpeaking then
                i2.Alpha = 0
            elseif i2.StoppedAt then
                v1 = (v4 - i2.StoppedAt - 2.5) / 0.35
                i2.Alpha = math.clamp(v1, 0, 1)
            else
                i2.Alpha = 0
            end
            for k2, j in pairs(i2.OriginalTransparency) do
                if k2.Parent then
                    for k3, k4 in pairs(j) do
                        k2[k3] = k4 + (1 - k4) * i2.Alpha
                    end
                end
            end
        end
    end
    if u39 then
        u39.Visible = v5 > 0
    end
    if #v3 == 0 and u42 then
        u42:Disconnect()
        u42 = nil
    end
end

local function ensureRenderConnection() -- Line: 131
    -- upvalues: u42 (ref), RunServiceController (val), updateVisibleTemplates (val)
    if u42 then
        return
    end
    u42 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136 -- upvalues: updateVisibleTemplates (upval)
        updateVisibleTemplates(os.clock())
    end)
end

local function updateEntry(a1, a2) -- Line: 141
    -- upvalues: Colors (val), CharacterResolver (val)
    local Attribute = a1.Player:GetAttribute("Team")
    local Attribute_2 = a1.Player:GetAttribute("CompetitivePlayerColor")
    if not Attribute_2 and Attribute then
        Attribute_2 = Colors["Team Color"][Attribute]
    end
    if a2 ~= nil then
        a1.SpeakingIcon.Visible = a2
        a1.NotSpeakingIcon.Visible = not a2
    end
    local v1 = true
    if a1.Player:GetAttribute("IsSpectating") ~= true then
        v1 = a1.Player:GetAttribute("Team") == "Spectators"
    end
    a1.DeadFrame.Visible = v1 or not CharacterResolver.isAlivePlayer(a1.Player)
    if Attribute_2 then
        a1.ColorGraphic.BackgroundColor3 = Attribute_2
    end
end

local function createEntry(a1) -- Line: 161
    -- upvalues: u41 (val), u40 (ref), u39 (ref), u33 (val), updateEntry (val)
    if u41[a1] then
        return u41[a1]
    end
    if u40 and u39 then
        local v1, v2
        local v3 = u40:Clone()
        v3.Name = tostring(a1.UserId)
        v3.Visible = false
        v3.Parent = u39
        local DisplayName = v3.DisplayName
        local Profile = v3.Profile
        DisplayName.Text = a1.DisplayName
        Profile.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(a1.UserId)
        local u145 = {Alpha = 1, IsSpeaking = false, LastSpokeAt = 0, ColorGraphic = v3.ColorDot.Graphic}
        u145.Connections = {}
        u145.DeadFrame = Profile.IsKilled
        u145.Frame = v3
        u145.NotSpeakingIcon = v3.IsNotSpeaking
        u145.OriginalTransparency = {}
        u145.Player = a1
        u145.SpeakingIcon = v3.IsSpeaking
        local v4 = {v3}
        for i, v in ipairs(v3:GetDescendants()) do
            table.insert(v4, v)
        end
        for i2, i3 in ipairs(v4) do
            v2 = {}
            if i3:IsA("GuiObject") then
                v2.BackgroundTransparency = i3.BackgroundTransparency
            end
            if i3:IsA("TextLabel") or i3:IsA("TextButton") or i3:IsA("TextBox") then
                v2.TextTransparency = i3.TextTransparency
                v2.TextStrokeTransparency = i3.TextStrokeTransparency
            end
            if i3:IsA("ImageLabel") or i3:IsA("ImageButton") then
                v2.ImageTransparency = i3.ImageTransparency
            end
            if i3:IsA("UIStroke") then
                v2.Transparency = i3.Transparency
            end
            if next(v2) then
                u145.OriginalTransparency[i3] = v2
            end
        end
        for i4, j in ipairs(u33) do
            table.insert(u145.Connections, ((v1:GetAttributeChangedSignal(j)):Connect(function() -- Line: 229 -- upvalues: updateEntry (upval), u145 (val)
                updateEntry(u145)
            end)))
        end
        u41[v1] = u145
        updateEntry(u145, false)
        return u145
    end
    return nil
end

local function destroyEntry(a1) -- Line: 240 -- upvalues: u41 (val), updateVisibleTemplates (val) -- types: a1: userdata
    local v1 = u41[a1]
    if not v1 then
        return
    end
    u41[a1] = nil
    for i, v in ipairs(v1.Connections) do
        v:Disconnect()
    end
    table.clear(v1.Connections)
    v1.Frame:Destroy()
    updateVisibleTemplates(os.clock())
end

local function setPlayerSpeaking(a1, a2) -- Line: 257
    -- upvalues: u41 (val), createEntry (val), updateEntry (val), updateVisibleTemplates (val), u42 (ref)
    -- upvalues: RunServiceController (val)
    local v1 = u41[a1] or createEntry(a1)
    if not v1 then
        return
    end
    v1.IsSpeaking = a2
    if not a2 then
        v1.StoppedAt = os.clock()
    else
        v1.Alpha = 0
        v1.LastSpokeAt = os.clock()
        v1.StoppedAt = nil
    end
    updateEntry(v1, a2)
    updateVisibleTemplates(os.clock())
    if u42 then
        return
    end
    u42 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136 -- upvalues: updateVisibleTemplates (upval)
        updateVisibleTemplates(os.clock())
    end)
end

function v1.Initialize(a1, a2) -- Line: 282 -- upvalues: u39 (ref), u40 (ref) -- types: a1: userdata, a2: userdata
    local Template = a2.Template
    u40 = Template
    Template.Visible = false
    a2.Visible = false
end

function v1.Start() -- Line: 292
    -- upvalues: u40 (ref), VoiceChat (val), setPlayerSpeaking (val), Players (val), createEntry (val)
    -- upvalues: destroyEntry (val), u41 (val), updateEntry (val), updateVisibleTemplates (val), u42 (ref)
    -- upvalues: RunServiceController (val)
    local v1
    if not u40 then
        return
    end
    VoiceChat.SpeakingChanged:Connect(setPlayerSpeaking)
    Players.PlayerAdded:Connect(createEntry)
    Players.PlayerRemoving:Connect(destroyEntry)
    for i, v in ipairs(Players:GetPlayers()) do
        createEntry(v)
        if VoiceChat.IsPlayerSpeaking(v) then
            v1 = u41[v] or createEntry(v)
            if v1 then
                v1.IsSpeaking = true
                v1.Alpha = 0
                v1.LastSpokeAt = os.clock()
                v1.StoppedAt = nil
                updateEntry(v1, true)
                updateVisibleTemplates(os.clock())
                if not u42 then
                    u42 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 136 -- upvalues: updateVisibleTemplates (upval)
                        updateVisibleTemplates(os.clock())
                    end)
                end
            end
        end
    end
    updateVisibleTemplates(os.clock())
end

return v1