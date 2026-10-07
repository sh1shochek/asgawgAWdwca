-- ReplicatedStorage.Controllers.InputController.Actions.VoiceChat
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.VoiceChat
-- Decompile time: 4.05 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Signal = require(ReplicatedStorage.Packages.Signal)
local LocalPlayer = Players.LocalPlayer
local u24 = {
    disabled = "Disabled",
    off = "Disabled",
    ["push to talk"] = "Push To Talk",
    pushtotalk = "Push To Talk",
    ptt = "Push To Talk",
    ["open mic"] = "Open Microphone",
    openmic = "Open Microphone",
    ["open microphone"] = "Open Microphone",
    openmicrophone = "Open Microphone",
}
local u35 = Signal.new()
local u36 = {
    IsPushToTalkHeld = false,
    IsVoiceInputRefreshQueued = false,
    LastVoiceInputScanTime = 0,
    ShouldRecreateVoiceInputs = false,
    VoiceMode = "Disabled",
    PlayerConnections = {},
    SpeakingPlayers = {},
    Trackers = {},
}
u0.Name = "Voice Chat"
u0.Group = "Default"
u0.Category = "Communication Options"
u0.SpeakingChanged = u35

function u0.GetVoiceMode(a1) -- Line: 75 -- upvalues: u24 (val)
    if typeof(a1) ~= "string" then
        return "Disabled"
    end
    local v1 = string.gsub(string.gsub(string.gsub(string.lower(a1), "[%s_%-%./]+", " "), "^%s+", ""), "%s+$", "")
    local v2 = string.gsub(v1, "%s+", "")
    return u24[v1] or u24[v2] or "Disabled"
end

function u0.SetVoiceMode(a1) -- Line: 89 -- upvalues: u36 (val), u0 (val)
    u36.VoiceMode = u0.GetVoiceMode(a1)
    u36.IsPushToTalkHeld = false
    u0.SyncVoiceMuted()
    u0.SyncVoiceActivity()
end

function u0.SetPushToTalkHeld(a1) -- Line: 96 -- upvalues: u36 (val), u0 (val) -- types: a1: boolean
    u36.IsPushToTalkHeld = a1
    u0.SyncVoiceMuted()
    u0.SyncVoiceActivity()
end

function u0.IsVoiceTransmitting() -- Line: 102 -- upvalues: LocalPlayer (val), u36 (val)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return false
    end
    if u36.VoiceMode == "Open Microphone" then
        return true
    end
    local IsPushToTalkHeld = false
    if u36.VoiceMode == "Push To Talk" then
        IsPushToTalkHeld = u36.IsPushToTalkHeld
    end
    return IsPushToTalkHeld
end

function u0.IsPlayerSpeaking(a1) -- Line: 114 -- upvalues: u36 (val) -- types: a1: userdata
    return u36.SpeakingPlayers[a1] == true
end

function u0.SetPlayerSpeaking(a1, a2) -- Line: 118
    -- upvalues: u0 (val), u36 (val), u35 (val)
    if u0.IsPlayerSpeaking(a1) == a2 then
        return
    end
    local v1 = if not a2 then nil else true
    u36.SpeakingPlayers[a1] = v1
    u35:Fire(a1, a2)
end

function u0.GetVoiceInput(a1) -- Line: 127 -- upvalues: LocalPlayer (val) -- types: a1: userdata?
    return ((a1 or LocalPlayer):FindFirstChildWhichIsA("AudioDeviceInput"))
end

function u0.CanLocalPlayerHear(a1) -- Line: 132 -- upvalues: LocalPlayer (val)
    local success, result = pcall(a1.GetUserIdAccessList, a1)
    if not success then
        return nil
    end
    local v1 = table.find(result, LocalPlayer.UserId) ~= nil
    if a1.AccessType == Enum.AccessModifierType.Deny then
        return not v1
    end
    return v1
end

function u0.SetVoiceMuted(a1) -- Line: 142 -- upvalues: u0 (val) -- types: a1: boolean
    local v1 = u0.GetVoiceInput()
    if v1 then
        v1.Muted = a1
    end
end

function u0.DestroyTracker(a1) -- Line: 149 -- upvalues: u36 (val), u0 (val) -- types: a1: userdata
    local v1 = u36.Trackers[a1]
    if not v1 then
        return
    end
    v1.Wire:Destroy()
    v1.Analyzer:Destroy()
    u36.Trackers[a1] = nil
    u0.SetPlayerSpeaking(a1, false)
end

function u0.QueueVoiceInputRefresh(a1, a2) -- Line: 161
    -- upvalues: u36 (val), u0 (val)
    local v1 = u36
    local ShouldRecreateVoiceInputs = u36.ShouldRecreateVoiceInputs or a1 == true
    v1.ShouldRecreateVoiceInputs = ShouldRecreateVoiceInputs
    if a2 then
        task.delay(0.25, function() -- Line: 165 -- upvalues: u0 (upval)
            u0.QueueVoiceInputRefresh(true)
        end)
    end
    if u36.IsVoiceInputRefreshQueued then
        return
    end
    u36.IsVoiceInputRefreshQueued = true
    task.defer(function() -- Line: 176 -- upvalues: u36 (upval), u0 (upval)
        local ShouldRecreateVoiceInputs = u36.ShouldRecreateVoiceInputs
        u36.IsVoiceInputRefreshQueued = false
        u36.ShouldRecreateVoiceInputs = false
        if ShouldRecreateVoiceInputs then
            local v1
            local v2 = {}
            for k, v in pairs(u36.Trackers) do
                v1 = u0.CanLocalPlayerHear(v.Input)
                if v1 == nil or v1 ~= v.CanHear then
                    table.insert(v2, k)
                end
            end
            for i, i2 in ipairs(v2) do
                u0.DestroyTracker(i2)
            end
        end
        u0.SyncVoiceInputs(true)
        u0.SyncVoiceActivity()
    end)
end

function u0.TrackVoiceInput(a1, a2) -- Line: 200
    -- upvalues: u36 (val), u0 (val), LocalPlayer (val)
    local v1 = u36.Trackers[a1]
    if v1 and v1.Input == a2 then
        return
    end
    u0.DestroyTracker(a1)
    local AudioAnalyzer = Instance.new("AudioAnalyzer")
    AudioAnalyzer.Name = ("%*VoiceChatAnalyzer"):format(a1.Name)
    AudioAnalyzer.SpectrumEnabled = false
    AudioAnalyzer.Parent = LocalPlayer
    local Wire = Instance.new("Wire")
    Wire.Name = "VoiceChatAnalyzerWire"
    Wire.SourceInstance = a2
    Wire.SourceName = "Output"
    Wire.TargetInstance = AudioAnalyzer
    Wire.TargetName = "Input"
    Wire.Parent = AudioAnalyzer
    u36.Trackers[a1] = {
        LastVoiceActivityTime = 0,
        Analyzer = AudioAnalyzer,
        CanHear = u0.CanLocalPlayerHear(a2),
        Input = a2,
        Wire = Wire,
    }
    if a1 == LocalPlayer then
        u0.SyncVoiceMuted()
    end
end

function u0.SyncVoiceInputs(a1) -- Line: 234 -- upvalues: u36 (val), u0 (val), Players (val) -- types: a1: boolean?
    local v1, v2
    local v3 = os.clock()
    if not a1 and v3 - u36.LastVoiceInputScanTime < 0.2 then
        return
    end
    u36.LastVoiceInputScanTime = v3
    for k in pairs(u36.Trackers) do
        if not k.Parent then
            u0.DestroyTracker(k)
        end
    end
    for i, v in ipairs(Players:GetPlayers()) do
        v1 = u36.Trackers[v]
        v2 = u0.GetVoiceInput(v)
        if v2 then
            u0.TrackVoiceInput(v, v2)
        elseif v1 then
            u0.DestroyTracker(v)
        end
    end
end

function u0.ObservePlayer(a1) -- Line: 260 -- upvalues: u36 (val), u0 (val) -- types: a1: userdata
    if u36.PlayerConnections[a1] then
        return
    end
    local v1 = {}
    u36.PlayerConnections[a1] = v1

    local function refreshVoiceAccess() -- Line: 268 -- upvalues: u0 (upval)
        u0.QueueVoiceInputRefresh(true, true)
    end

    local function refreshVoiceInput(a1) -- Line: 272 -- upvalues: u0 (upval) -- types: a1: userdata
        if a1:IsA("AudioDeviceInput") then
            u0.QueueVoiceInputRefresh()
        end
    end

    table.insert(v1, ((a1:GetAttributeChangedSignal("Team")):Connect(refreshVoiceAccess)))
    table.insert(v1, ((a1:GetAttributeChangedSignal("IsSpectating")):Connect(refreshVoiceAccess)))
    table.insert(v1, (a1.ChildAdded:Connect(refreshVoiceInput)))
    table.insert(v1, (a1.ChildRemoved:Connect(refreshVoiceInput)))
    u0.QueueVoiceInputRefresh()
end

function u0.UnobservePlayer(a1) -- Line: 286 -- upvalues: u36 (val), u0 (val) -- types: a1: userdata
    local v1 = u36.PlayerConnections[a1]
    if not v1 then
        u0.DestroyTracker(a1)
        return
    end
    u36.PlayerConnections[a1] = nil
    for i, v in ipairs(v1) do
        v:Disconnect()
    end
    table.clear(v1)
    u0.DestroyTracker(a1)
end

function u0.SyncPlayerVoiceActivity(a1, a2) -- Line: 303
    -- upvalues: LocalPlayer (val), u0 (val)
    if a1 == LocalPlayer and not u0.IsVoiceTransmitting() then
        a2.LastVoiceActivityTime = 0
        u0.SetPlayerSpeaking(a1, false)
        return
    end
    local v1 = os.clock()
    local v2 = math.max(a2.Analyzer.RmsLevel, a2.Analyzer.PeakLevel)
    if not u0.IsPlayerSpeaking(a1) then
        if v2 >= 0.0008 then
            a2.LastVoiceActivityTime = v1
            u0.SetPlayerSpeaking(a1, true)
        end
        return
    end
    if v2 >= 0.0005 then
        a2.LastVoiceActivityTime = v1
        return
    end
    if 0.7 <= v1 - a2.LastVoiceActivityTime then
        u0.SetPlayerSpeaking(a1, false)
    end
end

function u0.SyncVoiceActivity() -- Line: 332 -- upvalues: u0 (val), u36 (val)
    u0.SyncVoiceInputs()
    for k, v in pairs(u36.Trackers) do
        u0.SyncPlayerVoiceActivity(k, v)
    end
end

function u0.StartVoiceActivityLoop() -- Line: 340 -- upvalues: u36 (val), RunServiceController (val), u0 (val)
    if not u36.VoiceActivityConnection then
        u36.VoiceActivityConnection = RunServiceController.BindToPostSimulation("InputController.VoiceChat.SyncVoiceActivity", u0.SyncVoiceActivity)
    end
end

function u0.SyncVoiceMuted() -- Line: 349 -- upvalues: LocalPlayer (val), u0 (val), u36 (val)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u0.SetVoiceMuted(true)
        return
    end
    if u36.VoiceMode == "Open Microphone" then
        u0.SetVoiceMuted(false)
        return
    end
    local SetVoiceMuted = u0.SetVoiceMuted
    local v1 = true
    if u36.VoiceMode == "Push To Talk" then
        v1 = not u36.IsPushToTalkHeld
    end
    SetVoiceMuted(v1)
end

function u0.OnInput(a1, a2) -- Line: 359 -- upvalues: LocalPlayer (val), u0 (val), u36 (val) -- types: a2: userdata
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u0.SetPushToTalkHeld(false)
        return
    end
    if u36.VoiceMode ~= "Push To Talk" then
        u0.SyncVoiceMuted()
        return
    end
    if a1 == Enum.UserInputState.Begin then
        u0.SetPushToTalkHeld(true)
        return
    end
    if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
        u0.SetPushToTalkHeld(false)
    end
end

Players.PlayerAdded:Connect(u0.ObservePlayer)
Players.PlayerRemoving:Connect(u0.UnobservePlayer)
;(workspace:GetAttributeChangedSignal("VoiceAccessRevision")):Connect(function() -- Line: 380 -- upvalues: u0 (val)
    u0.QueueVoiceInputRefresh(true, true)
end)
for i, v in ipairs(Players:GetPlayers()) do
    u0.ObservePlayer(v)
end
;(LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting")):Connect(function() -- Line: 388 -- upvalues: u0 (val)
    u0.SyncVoiceMuted()
    u0.SyncVoiceActivity()
end)
DataController.CreateListener(LocalPlayer, "Settings.Audio.Voice Chat.Voice Chat Activation Mode", u0.SetVoiceMode)
u0.StartVoiceActivityLoop()
u0.SyncVoiceMuted()
u0.SyncVoiceInputs(true)
u0.SyncVoiceActivity()
u0.Callback = u0.OnInput
return table.freeze(u0)