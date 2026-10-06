-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Signal = require(ReplicatedStorage.Packages.Signal);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    disabled = "Disabled",
    off = "Disabled",
    ["push to talk"] = "Push To Talk",
    pushtotalk = "Push To Talk",
    ptt = "Push To Talk",
    ["open mic"] = "Open Microphone",
    openmic = "Open Microphone",
    ["open microphone"] = "Open Microphone",
    openmicrophone = "Open Microphone"
};
local u3 = Signal.new();
local u4 = {
    IsPushToTalkHeld = false,
    IsVoiceInputRefreshQueued = false,
    LastVoiceInputScanTime = 0,
    ShouldRecreateVoiceInputs = false,
    VoiceActivityConnection = nil,
    VoiceMode = "Disabled",
    PlayerConnections = {},
    SpeakingPlayers = {},
    Trackers = {}
};
u1.Name = "Voice Chat";
u1.Group = "Default";
u1.Category = "Communication Options";
u1.SpeakingChanged = u3;

function u1.GetVoiceMode(p5) -- Line: 75
    -- upvalues: u2 (copy)
    if typeof(p5) ~= "string" then
        return "Disabled";
    end;

    local string_lower_ret = string.lower(p5);
    local string_gsub_ret = string.gsub(string_lower_ret, "[%s_%-%./]+", " ");
    local string_gsub_ret2 = string.gsub(string_gsub_ret, "^%s+", "");
    local string_gsub_ret3 = string.gsub(string_gsub_ret2, "%s+$", "");
    local string_gsub_ret4 = string.gsub(string_gsub_ret3, "%s+", "");

    return u2[string_gsub_ret3] or u2[string_gsub_ret4] or "Disabled";
end;

function u1.SetVoiceMode(p6) -- Line: 89
    -- upvalues: u4 (copy), u1 (copy)
    u4.VoiceMode = u1.GetVoiceMode(p6);
    u4.IsPushToTalkHeld = false;
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end;

function u1.SetPushToTalkHeld(p7: boolean) -- Line: 96
    -- upvalues: u4 (copy), u1 (copy)
    u4.IsPushToTalkHeld = p7;
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end;

function u1.IsVoiceTransmitting() -- Line: 102
    -- upvalues: LocalPlayer (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        return false;
    end;

    if u4.VoiceMode == "Open Microphone" then
        return true;
    end;

    local v8;

    if u4.VoiceMode == "Push To Talk" then
        v8 = u4.IsPushToTalkHeld;
    else
        v8 = false;
    end;

    return v8;
end;

function u1.IsPlayerSpeaking(p9: userdata) -- Line: 114
    -- upvalues: u4 (copy)
    return u4.SpeakingPlayers[p9] == true;
end;

function u1.SetPlayerSpeaking(p10: userdata, p11: boolean) -- Line: 118
    -- upvalues: u1 (copy), u4 (copy), u3 (copy)
    if u1.IsPlayerSpeaking(p10) == p11 then
        return;
    end;

    u4.SpeakingPlayers[p10] = p11 and true or nil;
    u3:Fire(p10, p11);
end;

function u1.GetVoiceInput(p12: userdata?) -- Line: 127
    -- upvalues: LocalPlayer (copy)
    return (p12 or LocalPlayer):FindFirstChildWhichIsA("AudioDeviceInput");
end;

function u1.CanLocalPlayerHear(p13) -- Line: 132
    -- upvalues: LocalPlayer (copy)
    local success, result = pcall(p13.GetUserIdAccessList, p13);

    if not success then
        return nil;
    end;

    local v14 = table.find(result, LocalPlayer.UserId) ~= nil;

    if p13.AccessType == Enum.AccessModifierType.Deny then
        return not v14;
    end;

    return v14;
end;

function u1.SetVoiceMuted(p15: boolean) -- Line: 142
    -- upvalues: u1 (copy)
    local VoiceInput = u1.GetVoiceInput();

    if VoiceInput then
        VoiceInput.Muted = p15;
    end;
end;

function u1.DestroyTracker(p16: userdata) -- Line: 149
    -- upvalues: u4 (copy), u1 (copy)
    local v17 = u4.Trackers[p16];

    if not v17 then
        return;
    end;

    v17.Wire:Destroy();
    v17.Analyzer:Destroy();
    u4.Trackers[p16] = nil;
    u1.SetPlayerSpeaking(p16, false);
end;

function u1.QueueVoiceInputRefresh(p18: boolean?, p19: boolean?) -- Line: 161
    -- upvalues: u4 (copy), u1 (copy)
    u4.ShouldRecreateVoiceInputs = u4.ShouldRecreateVoiceInputs or p18 == true;

    if p19 then
        task.delay(0.25, function() -- Line: 165
            -- upvalues: u1 (ref)
            u1.QueueVoiceInputRefresh(true);
        end);
    end;

    if u4.IsVoiceInputRefreshQueued then
        return;
    end;

    u4.IsVoiceInputRefreshQueued = true;
    task.defer(function() -- Line: 176
        -- upvalues: u4 (ref), u1 (ref)
        local ShouldRecreateVoiceInputs = u4.ShouldRecreateVoiceInputs;
        u4.IsVoiceInputRefreshQueued = false;
        u4.ShouldRecreateVoiceInputs = false;

        if ShouldRecreateVoiceInputs then
            local v20 = {};

            for i, v in pairs(u4.Trackers) do
                local v21 = u1.CanLocalPlayerHear(v.Input);

                if v21 == nil or v21 ~= v.CanHear then
                    table.insert(v20, i);
                end;
            end;

            for _, v in ipairs(v20) do
                u1.DestroyTracker(v);
            end;
        end;

        u1.SyncVoiceInputs(true);
        u1.SyncVoiceActivity();
    end);
end;

function u1.TrackVoiceInput(p22: userdata, p23: any) -- Line: 200
    -- upvalues: u4 (copy), u1 (copy), LocalPlayer (copy)
    local v24 = u4.Trackers[p22];

    if v24 and v24.Input == p23 then
        return;
    end;

    u1.DestroyTracker(p22);
    local AudioAnalyzer = Instance.new("AudioAnalyzer");
    AudioAnalyzer.Name = `{p22.Name}VoiceChatAnalyzer`;
    AudioAnalyzer.SpectrumEnabled = false;
    AudioAnalyzer.Parent = LocalPlayer;
    local Wire = Instance.new("Wire");
    Wire.Name = "VoiceChatAnalyzerWire";
    Wire.SourceInstance = p23;
    Wire.SourceName = "Output";
    Wire.TargetInstance = AudioAnalyzer;
    Wire.TargetName = "Input";
    Wire.Parent = AudioAnalyzer;
    u4.Trackers[p22] = {
        LastVoiceActivityTime = 0,
        Analyzer = AudioAnalyzer,
        CanHear = u1.CanLocalPlayerHear(p23),
        Input = p23,
        Wire = Wire
    };

    if p22 == LocalPlayer then
        u1.SyncVoiceMuted();
    end;
end;

function u1.SyncVoiceInputs(p25: boolean?) -- Line: 234
    -- upvalues: u4 (copy), u1 (copy), Players (copy)
    local os_clock_ret = os.clock();

    if not p25 and os_clock_ret - u4.LastVoiceInputScanTime < 0.2 then
        return;
    end;

    u4.LastVoiceInputScanTime = os_clock_ret;

    for i in pairs(u4.Trackers) do
        if not i.Parent then
            u1.DestroyTracker(i);
        end;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        local v26 = u4.Trackers[v];
        local VoiceInput = u1.GetVoiceInput(v);

        if VoiceInput then
            u1.TrackVoiceInput(v, VoiceInput);
        elseif v26 then
            u1.DestroyTracker(v);
        end;
    end;
end;

function u1.ObservePlayer(p27: userdata) -- Line: 260
    -- upvalues: u4 (copy), u1 (copy)
    if u4.PlayerConnections[p27] then
        return;
    end;

    local v28 = {};
    u4.PlayerConnections[p27] = v28;

    local function refreshVoiceAccess() -- Line: 268
        -- upvalues: u1 (ref)
        u1.QueueVoiceInputRefresh(true, true);
    end;

    local function refreshVoiceInput(p29: userdata) -- Line: 272
        -- upvalues: u1 (ref)
        if p29:IsA("AudioDeviceInput") then
            u1.QueueVoiceInputRefresh();
        end;
    end;

    local AttributeChangedSignal = p27:GetAttributeChangedSignal("Team");
    table.insert(v28, AttributeChangedSignal:Connect(refreshVoiceAccess));
    local AttributeChangedSignal2 = p27:GetAttributeChangedSignal("IsSpectating");
    table.insert(v28, AttributeChangedSignal2:Connect(refreshVoiceAccess));
    table.insert(v28, p27.ChildAdded:Connect(refreshVoiceInput));
    table.insert(v28, p27.ChildRemoved:Connect(refreshVoiceInput));
    u1.QueueVoiceInputRefresh();
end;

function u1.UnobservePlayer(p30: userdata) -- Line: 286
    -- upvalues: u4 (copy), u1 (copy)
    local v31 = u4.PlayerConnections[p30];

    if not v31 then
        u1.DestroyTracker(p30);

        return;
    end;

    u4.PlayerConnections[p30] = nil;

    for _, v in ipairs(v31) do
        v:Disconnect();
    end;

    table.clear(v31);
    u1.DestroyTracker(p30);
end;

function u1.SyncPlayerVoiceActivity(p32: userdata, p33: table) -- Line: 303
    -- upvalues: LocalPlayer (copy), u1 (copy)
    if p32 == LocalPlayer and not u1.IsVoiceTransmitting() then
        p33.LastVoiceActivityTime = 0;
        u1.SetPlayerSpeaking(p32, false);

        return;
    end;

    local os_clock_ret = os.clock();
    local math_max_ret = math.max(p33.Analyzer.RmsLevel, p33.Analyzer.PeakLevel);

    if not u1.IsPlayerSpeaking(p32) then
        if math_max_ret >= 0.0008 then
            p33.LastVoiceActivityTime = os_clock_ret;
            u1.SetPlayerSpeaking(p32, true);
        end;

        return;
    end;

    if math_max_ret >= 0.0005 then
        p33.LastVoiceActivityTime = os_clock_ret;

        return;
    end;

    if os_clock_ret - p33.LastVoiceActivityTime >= 0.7 then
        u1.SetPlayerSpeaking(p32, false);
    end;
end;

function u1.SyncVoiceActivity() -- Line: 332
    -- upvalues: u1 (copy), u4 (copy)
    u1.SyncVoiceInputs();

    for i, v in pairs(u4.Trackers) do
        u1.SyncPlayerVoiceActivity(i, v);
    end;
end;

function u1.StartVoiceActivityLoop() -- Line: 340
    -- upvalues: u4 (copy), RunServiceController (copy), u1 (copy)
    if not u4.VoiceActivityConnection then
        u4.VoiceActivityConnection = RunServiceController.BindToPostSimulation("InputController.VoiceChat.SyncVoiceActivity", u1.SyncVoiceActivity);
    end;
end;

function u1.SyncVoiceMuted() -- Line: 349
    -- upvalues: LocalPlayer (copy), u1 (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u1.SetVoiceMuted(true);

        return;
    end;

    if u4.VoiceMode == "Open Microphone" then
        u1.SetVoiceMuted(false);

        return;
    end;

    u1.SetVoiceMuted(u4.VoiceMode ~= "Push To Talk" and true or not u4.IsPushToTalkHeld);
end;

function u1.OnInput(p34: any, p35: userdata) -- Line: 359
    -- upvalues: LocalPlayer (copy), u1 (copy), u4 (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        u1.SetPushToTalkHeld(false);

        return;
    end;

    if u4.VoiceMode ~= "Push To Talk" then
        u1.SyncVoiceMuted();

        return;
    end;

    if p34 == Enum.UserInputState.Begin then
        u1.SetPushToTalkHeld(true);

        return;
    end;

    if p34 == Enum.UserInputState.End or p34 == Enum.UserInputState.Cancel then
        u1.SetPushToTalkHeld(false);
    end;
end;

Players.PlayerAdded:Connect(u1.ObservePlayer);
Players.PlayerRemoving:Connect(u1.UnobservePlayer);
workspace:GetAttributeChangedSignal("VoiceAccessRevision"):Connect(function() -- Line: 380
    -- upvalues: u1 (copy)
    u1.QueueVoiceInputRefresh(true, true);
end);

for _, v in ipairs(Players:GetPlayers()) do
    u1.ObservePlayer(v);
end;

LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 388
    -- upvalues: u1 (copy)
    u1.SyncVoiceMuted();
    u1.SyncVoiceActivity();
end);
DataController.CreateListener(LocalPlayer, "Settings.Audio.Voice Chat.Voice Chat Activation Mode", u1.SetVoiceMode);
u1.StartVoiceActivityLoop();
u1.SyncVoiceMuted();
u1.SyncVoiceInputs(true);
u1.SyncVoiceActivity();
u1.Callback = u1.OnInput;

return table.freeze(u1);