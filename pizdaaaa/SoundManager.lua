-- ReplicatedStorage.Shared.Managers.SoundManager
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager
-- Decompile time: 25.59 ms

-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
require(script.Attenuation);
local script_SoundData = require(script.SoundData);
local Footsteps = require(script.SoundData.Footsteps);
local script_Modifiers = require(script.Modifiers);
local script_RoomReverb = require(script.RoomReverb);
local script_Surfaces = require(script.Surfaces);
local script_WeaponSounds = require(script.WeaponSounds);
local u1 = RunService:IsClient();
local u2 = {
    Modifiers = script_Modifiers,
    Surfaces = script_Surfaces,
    WeaponSounds = script_WeaponSounds
};
local u3 = {};

function u2.GetGroup(p4: string) -- Line: 81
    -- upvalues: u3 (copy)
    return u3[p4];
end;

function u2.SetVolume(p5: string, p6: number) -- Line: 85
    -- upvalues: u3 (copy)
    local v7 = u3[p5];

    if v7 then
        v7.Volume = math.clamp(p6, 0, 10);
    end;
end;

local Entries = script_SoundData.Entries;
local u8 = {};

local function GetTemplate(p9: string, p10: any) -- Line: 101
    -- upvalues: u8 (copy), u3 (copy)
    local v11 = u8[p9];

    if not v11 then
        v11 = Instance.new("Sound");
        v11.Volume = p10.Volume;
        v11.RollOffMode = p10.RollOff;
        v11.RollOffMinDistance = p10.MinDistance;
        v11.RollOffMaxDistance = p10.MaxDistance;
        v11.SoundGroup = u3[p10.Group];
        u8[p9] = v11;
    end;

    return v11;
end;

local v12 = {};
local u13 = {};
local u14 = {};

local function BuildGroups() -- Line: 58
    -- upvalues: script_SoundData (copy), u3 (copy), SoundService (copy)
    for _, v in script_SoundData.Groups do
        local v15 = u3[v.Name];

        if not v15 then
            v15 = Instance.new("SoundGroup");
            v15.Name = v.Name;
        end;

        if v.Parent == "" then
            v15.Parent = SoundService;
        else
            local v16 = u3[v.Parent];
            local v17 = `[SoundManager] "{v.Name}" no parent "{v.Parent}"`;
            assert(v16, v17);
            v15.Parent = v16;
        end;

        u3[v.Name] = v15;
    end;
end;

local u18 = nil;
local u19 = {
    Master = "Master Volume",
    UI = "UI Volume",
    Music = "Master Music Volume"
};
local u20 = nil;
local u21 = nil;
local u22 = nil;

for i in Entries do
    table.insert(v12, i);
end;

table.sort(v12);
local v23 = {};
local v24 = {};
local v25 = 0;

for _, v in v12 do
    local v26 = v:match("^(.*)%.[^%.]+$") or v;

    if not v23[v26] then
        v25 = v25 + 1;
        v23[v26] = v25;
        v24[v26] = 0;
        u14[v25] = {};
    end;

    local v27 = v23[v26];
    local v28 = v24[v26] + 1;
    assert(v27 <= 255, "[SoundManager]  >255 namespace, u8 full");
    local v29 = `[SoundManager]  >255 namespace "{v26}", u8 full`;
    assert(v28 <= 255, v29);
    v24[v26] = v28;
    u13[v] = table.freeze({
        Category = v27,
        Sound = v28
    });
    u14[v27][v28] = v;
end;

function u2.Pack(p30: string) -- Line: 159
    -- upvalues: u13 (copy)
    local v31 = u13[p30];

    if not v31 then
        warn((`[SoundManager] Pack unknown: {p30}`));
    end;

    return v31;
end;

function u2.Unpack(p32: table) -- Line: 169
    -- upvalues: u14 (copy)
    local v33 = u14[p32.Category];

    if v33 then
        v33 = v33[p32.Sound];
    end;

    return v33;
end;

local u34 = {};

function u2.GetAudibleRange(p35: table) -- Line: 179
    -- upvalues: u2 (copy), Entries (copy), u34 (copy)
    local v36 = u2.Unpack(p35);
    local v37;

    if v36 then
        v37 = Entries[v36];
    else
        v37 = v36;
    end;

    if not v37 or v37.Level == 0 then
        return nil;
    end;

    local v38 = u34[v36];

    if not v38 then
        v38 = v37.Volume <= 0 and 0 or v37.MaxDistance * (v37.RangeScale or 1);
        u34[v36] = v38;
    end;

    return v38;
end;

local function AddVoice(p39: any, p40: string, p41: number) -- Line: 205
    -- upvalues: Entries (copy)
    local v42 = Entries[p40];

    if v42 and v42.Level ~= 0 then
        table.insert(p39, {
            Volume = v42.Volume * p41,
            Range = v42.MaxDistance * (v42.RangeScale or 1)
        });
    end;
end;

local u43 = {};
local u44 = {};

for _, v in Footsteps.Surfaces do
    local v45 = v.Volume or 1;
    local v46 = Entries[v.Step];

    if v46 and v46.Level ~= 0 then
        table.insert(u44, {
            Volume = v46.Volume * v45,
            Range = v46.MaxDistance * (v46.RangeScale or 1)
        });
    end;

    local v47 = v.LandVolume or 1;
    local v48 = Entries[v.Land];

    if v48 and v48.Level ~= 0 then
        table.insert(u43, {
            Volume = v48.Volume * v47,
            Range = v48.MaxDistance * (v48.RangeScale or 1)
        });
    end;
end;

local v49 = Entries["Misc.Land"];

if v49 and v49.Level ~= 0 then
    table.insert(u43, {
        Volume = v49.Volume * 1,
        Range = v49.MaxDistance * (v49.RangeScale or 1)
    });
end;

function u2.GetFootstepRange(p50: number, p51: boolean) -- Line: 220
    -- upvalues: u43 (copy), u44 (copy)
    local v52 = 0;
    local v53;

    if p51 then
        v53 = u43;
    else
        v53 = u44;
    end;

    for _, v in v53 do
        if v.Volume * p50 > 0 then
            v52 = math.max(v52, v.Range);
        end;
    end;

    return v52;
end;

local u54 = {};
local u55 = {};

for i, v in script_WeaponSounds do
    local v56 = v;
    local v57 = {};

    for i2, v2 in v do
        local v58 = u13[v2];

        if v58 then
            v57[i2] = v58;
        end;
    end;

    u54[i] = table.freeze(v57);

    if v56.fire then
        u55[v56.fire] = true;
    end;

    if v56.fire_unsilenced then
        u55[v56.fire_unsilenced] = true;
    end;
end;

table.freeze(u54);
table.freeze(u55);
u2.WeaponSoundIds = u54;

function u2.GetWeaponSound(p59: string, p60: string) -- Line: 258
    -- upvalues: script_WeaponSounds (copy), u54 (copy)
    local v61 = script_WeaponSounds[p59];

    if v61 then
        v61 = v61[p60];
    end;

    if not v61 then
        return nil, nil;
    end;

    local v62 = u54[p59];

    if v62 then
        v62 = v62[p60];
    end;

    return v61, v62;
end;

function u2.GetWeaponFireSound(p63: string, p64: boolean?) -- Line: 270
    -- upvalues: script_WeaponSounds (copy), u54 (copy)
    local v65 = script_WeaponSounds[p63];

    if not v65 then
        return nil, nil;
    end;

    local v66 = (p64 or not v65.fire_unsilenced) and "fire" or "fire_unsilenced";
    local v67 = v65[v66];

    if not v67 then
        return nil, nil;
    end;

    local v68 = u54[p63];

    if v68 then
        v68 = v68[v66];
    end;

    return v67, v68;
end;

function u2.ResolveWeaponEvent(p69: string, p70: string, p71: string) -- Line: 288
    -- upvalues: script_WeaponSounds (copy)
    local v72 = script_WeaponSounds[p69];

    if not v72 then
        return nil;
    end;

    if p71 ~= "fire" then
        return v72[p71];
    end;

    if p70 == "Unsilenced" then
        return v72.fire_unsilenced or v72.fire;
    end;

    return v72.fire;
end;

local table_freeze_ret = table.freeze({});

local function BuildVoice(p73: string, p74: any, p75: table) -- Line: 312
    local Wave = p74.Wave;
    local v76 = Wave[math.random(#Wave)];
    local v77 = p74.Volume * (p75.Volume or 1);
    local v78 = p74.Pitch * (p75.Pitch or 1);

    if not p75.Modify then
        return v76, v77, v78;
    end;

    local v79 = {
        SoundId = v76,
        Volume = v77,
        PlaybackSpeed = v78
    };
    p75.Modify(v79, p73, p74, p75);

    return v79.SoundId, v79.Volume, v79.PlaybackSpeed;
end;

local u80 = nil;

local function GetHolder() -- Line: 342
    -- upvalues: u80 (ref)
    if u80 and u80.Parent then
        return u80;
    end;

    local v81 = workspace:FindFirstChild("Debris") or workspace;
    local Sounds = v81:FindFirstChild("Sounds");

    if not Sounds then
        Sounds = Instance.new("Folder");
        Sounds.Name = "Sounds";
        Sounds.Parent = v81;
    end;

    u80 = Sounds;

    return Sounds;
end;

local function NewCarrier(p82: string, p83: vector) -- Line: 362
    -- upvalues: u80 (ref)
    local Part = Instance.new("Part");
    Part.Name = p82;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p83);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.AudioCanCollide = false;
    Part.Transparency = 1;
    local v84;

    if u80 and u80.Parent then
        v84 = u80;
    else
        local v85 = workspace:FindFirstChild("Debris") or workspace;
        v84 = v85:FindFirstChild("Sounds");

        if not v84 then
            v84 = Instance.new("Folder");
            v84.Name = "Sounds";
            v84.Parent = v85;
        end;

        u80 = v84;
    end;

    Part.Parent = v84;

    return Part;
end;

local u86 = {};

local function ExpireVoice(p87, p88, p89) -- Line: 382
    -- upvalues: u86 (copy)
    if p87.TimeLength > 0 then
        u86[p89] = p87.TimeLength;
    end;

    p88:Destroy();
end;

local function FinishVoice(p90, p91, p92, p93) -- Line: 387
    -- upvalues: u86 (copy), u21 (ref), ExpireVoice (copy)
    local v94;

    if p90.TimeLength > 0 then
        v94 = p90.TimeLength;
    else
        v94 = u86[p93];
    end;

    u21:Delay((not v94 or p90.PlaybackSpeed <= 0) and 30 or v94 / p90.PlaybackSpeed + p92, ExpireVoice, p90, p91, p93);
end;

function u2.Play(p95: string, p96: table?) -- Line: 393
    -- upvalues: u1 (copy), Entries (copy), table_freeze_ret (copy), u2 (copy), BuildVoice (copy), u8 (copy), u3 (copy), SoundService (copy), u22 (ref), u86 (copy), u21 (ref), ExpireVoice (copy)
    if not u1 then
        return nil;
    end;

    local v97 = Entries[p95];

    if not v97 then
        warn((`[SoundManager] Unknown sound: {p95}`));

        return nil;
    end;

    local v98 = p96 or table_freeze_ret;

    if v98.Position and v97.Level ~= 0 then
        return u2.PlayAudio(p95, v98);
    end;

    local v99, v100, v101 = BuildVoice(p95, v97, v98);
    local v102 = u8[p95];

    if not v102 then
        v102 = Instance.new("Sound");
        v102.Volume = v97.Volume;
        v102.RollOffMode = v97.RollOff;
        v102.RollOffMinDistance = v97.MinDistance;
        v102.RollOffMaxDistance = v97.MaxDistance;
        v102.SoundGroup = u3[v97.Group];
        u8[p95] = v102;
    end;

    local v103 = v102:Clone();
    v103.Name = p95;
    v103.SoundId = v99;
    v103.PlaybackSpeed = v101;
    v103.Volume = v100;
    local v104;

    if v98.Looped == nil then
        v104 = v97.Looped;
    else
        v104 = v98.Looped;
    end;

    v103.Looped = v104;

    if v97.Level == 0 then
        v103.Parent = workspace.CurrentCamera or SoundService;
    else
        v103.Parent = v98.Parent or (workspace.CurrentCamera or SoundService);
    end;

    v103:Play();

    if v98.LocalReplicated and (u22 and (v97.Level ~= 0 and v100 > 0)) then
        u22.CreateSound(v97.MaxDistance * (v97.RangeScale or 1), 0.5);
    end;

    if not v103.Looped then
        local v105;

        if v103.TimeLength > 0 then
            v105 = v103.TimeLength;
        else
            v105 = u86[v99];
        end;

        u21:Delay((not v105 or v103.PlaybackSpeed <= 0) and 30 or v105 / v103.PlaybackSpeed + 0, ExpireVoice, v103, v103, v99);
    end;

    return v103;
end;

local u106 = nil;
local u107 = {};
local NumberRange_new_ret = NumberRange.new(250, 4000);

local function Connect(p108: userdata, p109: userdata, p110: string?, p111: string?) -- Line: 465
    local Wire = Instance.new("Wire");
    Wire.SourceInstance = p108;
    Wire.TargetInstance = p109;

    if p110 then
        Wire.SourceName = p110;
    end;

    if p111 then
        Wire.TargetName = p111;
    end;

    Wire.Parent = p108;
end;

local function ConnectStereoCrossfeed(p112: userdata, p113: userdata) -- Line: 474
    local AudioChannelSplitter = Instance.new("AudioChannelSplitter");
    AudioChannelSplitter.Layout = Enum.AudioChannelLayout.Stereo;
    AudioChannelSplitter.Parent = p113;
    local Wire = Instance.new("Wire");
    Wire.SourceInstance = p112;
    Wire.TargetInstance = AudioChannelSplitter;
    Wire.Parent = p112;
    local AudioChannelMixer = Instance.new("AudioChannelMixer");
    AudioChannelMixer.Layout = Enum.AudioChannelLayout.Stereo;
    AudioChannelMixer.Parent = p113;
    local Wire2 = Instance.new("Wire");
    Wire2.SourceInstance = AudioChannelMixer;
    Wire2.TargetInstance = p113;
    Wire2.Parent = AudioChannelMixer;
    local AudioFader = Instance.new("AudioFader");
    AudioFader.Volume = 0.65;
    AudioFader.Parent = p113;
    local Wire3 = Instance.new("Wire");
    Wire3.SourceInstance = p112;
    Wire3.TargetInstance = AudioFader;
    Wire3.Parent = p112;
    local Wire4 = Instance.new("Wire");
    Wire4.SourceInstance = AudioFader;
    Wire4.TargetInstance = AudioChannelMixer;
    Wire4.Parent = AudioFader;

    for _, v in { "Left", "Right" } do
        local AudioFader2 = Instance.new("AudioFader");
        AudioFader2.Volume = 0.35;
        AudioFader2.Parent = p113;
        local Wire5 = Instance.new("Wire");
        Wire5.SourceInstance = AudioChannelSplitter;
        Wire5.TargetInstance = AudioFader2;

        if v then
            Wire5.SourceName = v;
        end;

        Wire5.Parent = AudioChannelSplitter;
        local v114 = v == "Left" and "Right" or "Left";
        local Wire6 = Instance.new("Wire");
        Wire6.SourceInstance = AudioFader2;
        Wire6.TargetInstance = AudioChannelMixer;

        if v114 then
            Wire6.TargetName = v114;
        end;

        Wire6.Parent = AudioFader2;
    end;
end;

local function GetOutput() -- Line: 502
    -- upvalues: u106 (ref), SoundService (copy), NumberRange_new_ret (copy), script_RoomReverb (copy), ConnectStereoCrossfeed (copy), u107 (copy)
    local v115 = u106;

    if not (v115 and v115.Parent) then
        v115 = Instance.new("AudioDeviceOutput");
        v115.Name = "SoundManagerOutput";
        v115.Parent = SoundService;
        local AudioEqualizer = Instance.new("AudioEqualizer");
        AudioEqualizer.LowGain = 0;
        AudioEqualizer.MidGain = 0;
        AudioEqualizer.HighGain = 0;
        AudioEqualizer.MidRange = NumberRange_new_ret;
        AudioEqualizer.Parent = v115;
        local AudioCompressor = Instance.new("AudioCompressor");
        AudioCompressor.Threshold = -12;
        AudioCompressor.Ratio = 4;
        AudioCompressor.Attack = 0.005;
        AudioCompressor.Release = 0.15;
        AudioCompressor.Parent = v115;
        local v116 = script_RoomReverb.Build(v115);
        local Wire = Instance.new("Wire");
        Wire.SourceInstance = v116;
        Wire.TargetInstance = AudioEqualizer;
        Wire.Parent = v116;
        local Wire2 = Instance.new("Wire");
        Wire2.SourceInstance = AudioEqualizer;
        Wire2.TargetInstance = AudioCompressor;
        Wire2.Parent = AudioEqualizer;
        ConnectStereoCrossfeed(AudioCompressor, v115);

        for _, v in u107 do
            v:Destroy();
        end;

        table.clear(u107);
        u106 = v115;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    for i, v in {
        KontraWorld = v115:FindFirstChildOfClass("AudioReverb") or (v115:FindFirstChildOfClass("AudioEqualizer") or v115),
        KontraWorldOpen = v115:FindFirstChildOfClass("AudioEqualizer") or v115
    } do
        local v117 = u107[i];

        if v117 and not v117.Parent then
            v117 = nil;
        end;

        if workspace_CurrentCamera and not v117 then
            v117 = Instance.new("AudioListener");
            v117.Name = i == "KontraWorld" and "SoundManagerListener" or "SoundManagerListenerOpen";
            v117.AudioInteractionGroup = i;
            local Wire = Instance.new("Wire");
            Wire.SourceInstance = v117;
            Wire.TargetInstance = v;
            Wire.Parent = v117;
            v117.Parent = workspace_CurrentCamera;
        elseif v117 and (workspace_CurrentCamera and v117.Parent ~= workspace_CurrentCamera) then
            v117.Parent = workspace_CurrentCamera;
        end;

        u107[i] = v117;

        if v117 then
            v117.AcousticSimulationEnabled = false;
        end;
    end;

    return v115;
end;

local function GroupGain(p118: string) -- Line: 581
    -- upvalues: u3 (copy)
    local v119 = u3[p118];
    local v120 = 1;

    while v119 and v119:IsA("SoundGroup") do
        v120 = v120 * v119.Volume;
        v119 = v119.Parent;
    end;

    return v120;
end;

local function ApplyDistanceReverb(p121: string, p122: userdata, p123: userdata) -- Line: 609
    -- upvalues: u55 (copy), u20 (ref)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not (workspace_CurrentCamera and (u55 and u55[p121])) then
        return 0;
    end;

    local Magnitude = ((u20 and u20.GetAppliedCFrame() or workspace_CurrentCamera.CFrame).Position - p123.Position).Magnitude;

    if Magnitude <= 25 then
        return 0;
    end;

    local math_clamp_ret = math.clamp((Magnitude - 25) / 225, 0, 1);
    local AudioReverb = Instance.new("AudioReverb");
    AudioReverb.DryLevel = 0;
    AudioReverb.WetLevel = math_clamp_ret * 12 + -24;
    AudioReverb.DecayTime = math_clamp_ret * 1.7999999999999998 + 1;
    AudioReverb.Parent = p122;

    return AudioReverb.DecayTime;
end;

local function ApplyDistanceAir(p124: userdata, p125: userdata, p126: userdata, p127: number) -- Line: 644
    -- upvalues: u20 (ref)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = u20 and u20.GetAppliedCFrame() or workspace_CurrentCamera.CFrame;
    end;

    local v128 = workspace_CurrentCamera and (workspace_CurrentCamera.Position - p126.Position).Magnitude or 0;
    local math_min_ret = math.min(250, p127);
    local math_min_ret2 = math.min(25, math_min_ret / 4);

    if v128 <= math_min_ret2 then
        local Wire = Instance.new("Wire");
        Wire.SourceInstance = p124;
        Wire.TargetInstance = p125;
        Wire.Parent = p124;

        return;
    end;

    local math_clamp_ret = math.clamp((v128 - math_min_ret2) / (math_min_ret - math_min_ret2), 0, 1);
    local AudioFilter = Instance.new("AudioFilter");
    AudioFilter.FilterType = Enum.AudioFilterType.Lowpass12dB;
    AudioFilter.Frequency = 0.15 ^ math_clamp_ret * 20000;
    AudioFilter.Parent = p124;
    local Wire = Instance.new("Wire");
    Wire.SourceInstance = p124;
    Wire.TargetInstance = AudioFilter;
    Wire.Parent = p124;
    local Wire2 = Instance.new("Wire");
    Wire2.SourceInstance = AudioFilter;
    Wire2.TargetInstance = p125;
    Wire2.Parent = AudioFilter;
end;

local function ApplyFootstepSpatial(p129: userdata, p130: vector) -- Line: 668
    -- upvalues: u20 (ref)
    local AudioChannelSplitter = Instance.new("AudioChannelSplitter");
    AudioChannelSplitter.Layout = Enum.AudioChannelLayout.Mono;
    AudioChannelSplitter.Parent = p129;
    local Wire = Instance.new("Wire");
    Wire.SourceInstance = p129;
    Wire.TargetInstance = AudioChannelSplitter;
    Wire.Parent = p129;
    local AudioEqualizer = Instance.new("AudioEqualizer");
    AudioEqualizer.Parent = p129;
    local Wire2 = Instance.new("Wire");
    Wire2.SourceInstance = AudioChannelSplitter;
    Wire2.SourceName = "Center";
    Wire2.TargetInstance = AudioEqualizer;
    Wire2.Parent = AudioChannelSplitter;
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        local v131 = u20 and u20.GetAppliedCFrame() or workspace_CurrentCamera.CFrame;
        local v132 = p130.Y - v131.Position.Y + 2;
        local v133 = (math.abs(v132) - 3) / 8;
        local math_clamp_ret = math.clamp(v133, 0, 1);
        AudioEqualizer.LowGain = (v132 < 0 and 2 or -6) * math_clamp_ret;
        AudioEqualizer.HighGain = (v132 < 0 and -10 or 0) * math_clamp_ret;
    end;

    return AudioEqualizer;
end;

function u2.PlayAudio(p134: string, p135: table?) -- Line: 696
    -- upvalues: u1 (copy), Entries (copy), table_freeze_ret (copy), u2 (copy), BuildVoice (copy), u86 (copy), u55 (copy), u20 (ref), GetOutput (copy), u80 (ref), script_RoomReverb (copy), ApplyFootstepSpatial (copy), ApplyDistanceAir (copy), GroupGain (copy), ApplyDistanceReverb (copy), u21 (ref), ExpireVoice (copy)
    if not u1 then
        return nil;
    end;

    local v136 = Entries[p134];

    if not v136 then
        warn((`[SoundManager] Unknown sound: {p134}`));

        return nil;
    end;

    local v137 = p135 or table_freeze_ret;

    if v136.Level == 0 or not v137.Position then
        return u2.Play(p134, v137);
    end;

    local v138, v139, v140 = BuildVoice(p134, v136, v137);
    local v141;

    if v137.Looped == nil then
        v141 = v136.Looped;
    else
        v141 = v137.Looped;
    end;

    local v142 = {};

    for i = 0, 8 do
        local v143 = i / 8;
        v142[v136.MinDistance + (v136.MaxDistance - v136.MinDistance) * v143] = (1 - v143) ^ 2;
        local _ = i;
    end;

    local v144 = v136.RangeScale or 1;
    local v145 = u86[v138];
    local v146 = u55 and u55[p134] == true;

    if not v141 and (v145 and (v140 > 0 and u20.GetTarget() == 1)) then
        local Position = u20.GetAppliedCFrame().Position;
        local v147 = v136.MaxDistance * v144;

        if vector.magnitude(Position - v137.Position) > v147 + (64 + 256 * (v145 / v140 + (v146 and 2.8 or 0))) then
            return nil;
        end;
    end;

    GetOutput();
    local Position = v137.Position;
    local Part = Instance.new("Part");
    Part.Name = p134;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(Position);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.AudioCanCollide = false;
    Part.Transparency = 1;
    local v148;

    if u80 and u80.Parent then
        v148 = u80;
    else
        local v149 = workspace:FindFirstChild("Debris") or workspace;
        v148 = v149:FindFirstChild("Sounds");

        if not v148 then
            v148 = Instance.new("Folder");
            v148.Name = "Sounds";
            v148.Parent = v149;
        end;

        u80 = v148;
    end;

    Part.Parent = v148;
    local AudioPlayer = Instance.new("AudioPlayer");
    AudioPlayer.Name = p134;
    AudioPlayer.Asset = v138;
    AudioPlayer.Parent = Part;
    local AudioEmitter = Instance.new("AudioEmitter");
    AudioEmitter.AudioInteractionGroup = script_RoomReverb.IsClosed(v137.Position) and "KontraWorld" or "KontraWorldOpen";

    if v144 ~= 1 then
        v142 = {};

        for i, v in v142 do
            v142[i * v144] = v;
        end;
    end;

    AudioEmitter:SetDistanceAttenuation(v142);
    AudioEmitter.Parent = Part;
    local v150;

    if v137.FootstepPosition then
        v150 = ApplyFootstepSpatial(AudioPlayer, v137.FootstepPosition);
    else
        v150 = AudioPlayer;
    end;

    ApplyDistanceAir(v150, AudioEmitter, Part, v136.MaxDistance * v144);
    AudioPlayer.Volume = v139 * GroupGain(v136.Group);
    AudioPlayer.PlaybackSpeed = v140;
    AudioPlayer.Looping = v141;
    local v151 = ApplyDistanceReverb(p134, AudioPlayer, Part);

    if not v141 then
        local v152;

        if AudioPlayer.TimeLength > 0 then
            v152 = AudioPlayer.TimeLength;
        else
            v152 = u86[v138];
        end;

        u21:Delay((not v152 or AudioPlayer.PlaybackSpeed <= 0) and 30 or v152 / AudioPlayer.PlaybackSpeed + v151, ExpireVoice, AudioPlayer, Part, v138);
    end;

    AudioPlayer:Play();

    return AudioPlayer;
end;

function u2.GetSurface(p153) -- Line: 772
    -- upvalues: Footsteps (copy)
    return Footsteps.Surfaces[Footsteps.Materials[p153] or "Default"];
end;

local u154 = {};
local u155 = {};

for _, v in Footsteps.Surfaces do
    u154[v] = {
        [false] = script_Modifiers.Footstep(v, false),
        [true] = script_Modifiers.Footstep(v, true)
    };
    u155[v] = script_Modifiers.Landing(v);
end;

local function PlayWith(p156: string, p157: function, p158: table?) -- Line: 795
    -- upvalues: table_freeze_ret (copy), u2 (copy)
    local v159 = p158 or table_freeze_ret;

    return u2.Play(p156, {
        Position = v159.Position,
        Parent = v159.Parent,
        Volume = v159.Volume,
        Pitch = v159.Pitch,
        Modify = p157,
        LocalReplicated = v159.LocalReplicated,
        FootstepPosition = v159.FootstepPosition
    });
end;

function u2.PlayFootstep(p160: any, p161: boolean, p162: table?) -- Line: 809
    -- upvalues: u2 (copy), PlayWith (copy), u154 (copy)
    local Surface = u2.GetSurface(p160);

    return PlayWith(Surface.Step, u154[Surface][p161 and true or false], p162);
end;

function u2.PlayLadderStep(p163: boolean, p164: table?) -- Line: 819
    -- upvalues: Footsteps (copy), PlayWith (copy), u154 (copy)
    local Ladder = Footsteps.Surfaces.Ladder;

    return PlayWith(Ladder.Step, u154[Ladder][p163 and true or false], p164);
end;

function u2.PlayLanding(p165: any, p166: table?) -- Line: 825
    -- upvalues: u2 (copy), PlayWith (copy), u155 (copy)
    local Surface = u2.GetSurface(p165);

    return PlayWith(Surface.Land, u155[Surface], p166);
end;

function u2.PlaySurfaceImpact(p167: string?, p168: number, p169: table?) -- Line: 841
    -- upvalues: script_Surfaces (copy), u2 (copy)
    local v170 = script_Surfaces.Impact(p167, p168);

    if v170 then
        v170 = u2.Play(v170, p169);
    end;

    return v170;
end;

function u2.GetPickupSound(p171: vector, p172: boolean) -- Line: 861
    -- upvalues: ReplicatedStorage (copy)
    local GameStats = ReplicatedStorage:FindFirstChild("GameStats");

    if GameStats then
        GameStats = GameStats:GetAttribute("State") == "Preparation";
    end;

    if not GameStats then
        local vector_create_ret = vector.create(p171.X, 0, p171.Z);

        if vector.magnitude(vector_create_ret) < 9.382880000000002 then
            return "Other.PickupWeaponSilent", true;
        end;
    end;

    return p172 and "Items.pickup-grenade" or "Items.pickup-weapon", false;
end;

function u2.Precache() -- Line: 886
    -- upvalues: Entries (copy), ContentProvider (copy)
    local v173 = {};
    local v174 = {};

    for _, v in Entries do
        for _, v2 in v.Wave do
            if not v173[v2] then
                v173[v2] = true;
                table.insert(v174, v2);
            end;
        end;
    end;

    ContentProvider:PreloadAsync(v174);
end;

function u2.Init(p175) -- Line: 901
    -- upvalues: u1 (copy), u21 (ref), BuildGroups (copy)
    if not u1 then
        return;
    end;

    u21 = p175:GetModule("Threads");
    BuildGroups();
end;

function u2.Start(p176) -- Line: 910
    -- upvalues: u1 (copy), u20 (ref), u22 (ref), u18 (ref), u19 (copy), u2 (copy), RunService (copy), script_RoomReverb (copy)
    if not u1 then
        return;
    end;

    u20 = p176:GetModule("CameraController");
    local Module = p176:GetModule("Gui");

    if Module and Module.GetComponent then
        u22 = Module.GetComponent("Radar");
        u18 = Module.GetComponent("Settings");
    end;

    if u18 then
        local PlayerSettings = u18:GetPlayerSettings();
        local v177 = PlayerSettings and PlayerSettings.Audio and PlayerSettings.Audio["Volume & Sound"];

        for i, v in u19 do
            local v178;

            if v177 then
                v178 = v177[v];
            else
                v178 = v177;
            end;

            if v178 == nil then
                u2.SetVolume(i, 1);
            else
                u2.SetVolume(i, v178);
            end;

            u18:AddConnection("Audio", "Volume & Sound", v, function(p179: number) -- Line: 934
                -- upvalues: u2 (ref), i (copy)
                u2.SetVolume(i, p179);
            end);
        end;
    end;

    RunService.Heartbeat:Connect(function(p180) -- Line: 941
        -- upvalues: u20 (ref), script_RoomReverb (ref)
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            workspace_CurrentCamera = u20 and u20.GetAppliedCFrame() or workspace_CurrentCamera.CFrame;
        end;

        if workspace_CurrentCamera then
            workspace_CurrentCamera = workspace_CurrentCamera.Position;
        end;

        script_RoomReverb.Update(p180, workspace_CurrentCamera);
    end);
    task.spawn(u2.Precache);
end;

return u2;