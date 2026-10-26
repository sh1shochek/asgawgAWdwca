-- ReplicatedStorage.Classes.Sound
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local SoundService = game:GetService("SoundService");
local HttpService = game:GetService("HttpService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("DataController"));
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local u2 = ReplicatedStorage:FindFirstChild("Sounds") or Instance.new("Folder", ReplicatedStorage);
u2.Name = "Sounds";
local Debris = workspace:WaitForChild("Debris");
local u3 = {
    Interface = true,
    ["Main Menu"] = true,
    Store = true,
    ArmsDealer = true
};
local Gameplay = SoundService:FindFirstChild("Gameplay");

if not Gameplay then
    Gameplay = Instance.new("SoundGroup");
    Gameplay.Name = "Gameplay";
    Gameplay.Parent = SoundService;
end;

local Part = Instance.new("Part");
Part.Size = Vector3.new(1, 1, 1);
Part.CanCollide = false;
Part.CanTouch = false;
Part.CanQuery = false;
Part.CastShadow = false;
Part.Anchored = true;
Part.Transparency = 1;
Part.Name = "Sound";
local u5 = ObjectPool.new(Part, {
    InitialSize = 8,
    MaxRetained = 32,

    Reset = function(p4: userdata) -- Line: 65, Name: Reset
        p4.CFrame = CFrame.identity;
    end
});
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = 1;
local u12 = nil;
local u13 = nil;
local u14 = {};
local u15 = {};

local function PickSound(p16) -- Line: 122
    local Children = p16:GetChildren();

    return Children[math.random(1, #Children)];
end;

local function GetPersistentSoundsFolder() -- Line: 129
    -- upvalues: u13 (ref), SoundService (copy)
    if u13 and u13.Parent then
        return u13;
    end;

    local PersistentSounds = SoundService:FindFirstChild("PersistentSounds");

    if not PersistentSounds then
        PersistentSounds = Instance.new("Folder");
        PersistentSounds.Name = "PersistentSounds";
        PersistentSounds.Parent = SoundService;
    end;

    u13 = PersistentSounds;

    return PersistentSounds;
end;

local function GetPersistentInstance(p17: userdata) -- Line: 146
    -- upvalues: u14 (copy), u15 (copy), u13 (ref), SoundService (copy)
    local v18 = u14[p17];

    if v18 and v18:IsDescendantOf(game) then
        return v18;
    end;

    if v18 then
        u15[v18] = nil;
    end;

    local v19 = p17:Clone();
    local v20;

    if u13 and u13.Parent then
        v20 = u13;
    else
        v20 = SoundService:FindFirstChild("PersistentSounds");

        if not v20 then
            v20 = Instance.new("Folder");
            v20.Name = "PersistentSounds";
            v20.Parent = SoundService;
        end;

        u13 = v20;
    end;

    v19.Parent = v20;
    u14[p17] = v19;

    return v19;
end;

local function ClaimPersistentPlay(p21: userdata) -- Line: 164
    -- upvalues: u15 (copy)
    local v22 = (u15[p21] or 0) + 1;
    u15[p21] = v22;

    return v22;
end;

local function TranslateSoundPath(p23: string) -- Line: 173
    local string_split_ret = string.split(p23, ".");
    local l_game = game;

    for i = 2, #string_split_ret do
        local u24 = string_split_ret[i];

        if l_game == game then
            local success, result = pcall(function() -- Line: 180
                -- upvalues: u24 (copy)
                return game:GetService(u24);
            end);
            l_game = success and result and result or game:FindFirstChild(u24);
        else
            l_game = l_game:FindFirstChild(u24);
        end;

        local v25;

        if l_game then
            v25 = i;
        else
            error((`Path: "{p23}" does not exist`));
            v25 = i;
        end;
    end;

    return l_game;
end;

local function CreateSoundInstance(p26: string, p27: string, p28: any) -- Line: 197
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = p28.RollOffMaxDistance or 10000;
    Sound.RollOffMinDistance = p28.RollOffMinDistance or 10;
    Sound.TimePosition = p28.TimePosition or 0;
    Sound.RollOffMode = p28.RollOffMode or Enum.RollOffMode.Inverse;
    Sound.Looped = p28.Looped or false;
    Sound.SoundId = `rbxassetid://{p27}`;
    Sound.Volume = p28.Volume or 0.5;
    Sound.Name = p26;
    local Pitch = p28.Pitch;

    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Name = "PitchShift";
        PitchShiftSoundEffect.Octave = math.clamp(Pitch, 0.5, 2);
        PitchShiftSoundEffect.Parent = Sound;
    end;

    if p28.Persistent then
        Sound:SetAttribute("Persistent", true);
    end;

    if p28.WarmOnUse then
        Sound:SetAttribute("WarmOnUse", true);
    end;

    return Sound;
end;

local function GetMasterVolumeMultiplier() -- Line: 227
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v29 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;

    return (tonumber(v29) or 100) / 100;
end;

local function ApplyTrackedVolume(p30: userdata, p31: table) -- Line: 232
    -- upvalues: u11 (ref)
    p30.Volume = p31.BaseVolume * u11 * p31.OtherMultiplier;
    p30:SetAttribute("MasterVolumeMultiplier", u11);
end;

local function EnsureMasterVolumeListener() -- Line: 237
    -- upvalues: u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    if u12 then
        return;
    end;

    local v32 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    u11 = (tonumber(v32) or 100) / 100;
    u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p33) -- Line: 243
        -- upvalues: u11 (ref), u6 (ref)
        u11 = (tonumber(p33) or 100) / 100;

        for i, v in pairs(u6) do
            if i.Parent then
                i.Volume = v.BaseVolume * u11 * v.OtherMultiplier;
                i:SetAttribute("MasterVolumeMultiplier", u11);
            else
                u6[i] = nil;
            end;
        end;
    end);
end;

local function TrackMasterVolume(u34: userdata, p35: number, p36: number?) -- Line: 256
    -- upvalues: u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    local v37 = p36 or 1;
    local v38 = {
        BaseVolume = p35,
        OtherMultiplier = v37
    };

    if not u12 then
        local v39 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u11 = (tonumber(v39) or 100) / 100;
        u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p40) -- Line: 243
            -- upvalues: u11 (ref), u6 (ref)
            u11 = (tonumber(p40) or 100) / 100;

            for i, v in pairs(u6) do
                if i.Parent then
                    i.Volume = v.BaseVolume * u11 * v.OtherMultiplier;
                    i:SetAttribute("MasterVolumeMultiplier", u11);
                else
                    u6[i] = nil;
                end;
            end;
        end);
    end;

    local v41 = u6[u34] == nil;
    u6[u34] = v38;
    u34:SetAttribute("BaseVolume", p35);
    u34:SetAttribute("OtherVolumeMultiplier", v37);
    u34.Volume = v38.BaseVolume * u11 * v38.OtherMultiplier;
    u34:SetAttribute("MasterVolumeMultiplier", u11);

    if v41 then
        u34.Destroying:Once(function() -- Line: 273
            -- upvalues: u6 (ref), u34 (copy)
            u6[u34] = nil;
        end);
    end;
end;

local function IsVoiceable(p42: userdata) -- Line: 281
    -- upvalues: u9 (copy), u10 (copy)
    local v43 = u9[p42];

    if v43 ~= nil then
        return v43;
    end;

    local v44 = not p42.Looped;

    for _, child in p42:GetChildren() do
        if child:IsA("PitchShiftSoundEffect") and not u10[p42] then
            u10[p42] = child;
        else
            v44 = false;
        end;
    end;

    u9[p42] = v44;

    return v44;
end;

local function NewPositionalVoice() -- Line: 298
    -- upvalues: u8 (copy), u7 (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "SoundVoice";
    local Sound = Instance.new("Sound");
    Sound.Parent = Attachment;
    Attachment.Parent = workspace.Terrain;
    local u45 = {
        PitchShift = nil,
        Busy = true,
        Attachment = Attachment,
        Sound = Sound,
        Volume = {
            BaseVolume = 0,
            OtherMultiplier = 1
        }
    };
    Sound.Ended:Connect(function() -- Line: 311
        -- upvalues: u45 (copy), u8 (ref)
        if u45.Busy then
            u45.Busy = false;
            u8[#u8 + 1] = u45;
        end;
    end);
    u7[#u7 + 1] = u45;

    return u45;
end;

local function NewVoicePitchShift(p46: table) -- Line: 321
    local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
    PitchShiftSoundEffect.Parent = p46.Sound;
    p46.PitchShift = PitchShiftSoundEffect;

    return PitchShiftSoundEffect;
end;

local function IsVoiceIntact(p47: table) -- Line: 328
    local v48;

    if p47.Attachment.Parent == nil then
        v48 = false;
    else
        v48 = p47.Sound.Parent == p47.Attachment;
    end;

    return v48;
end;

local function AcquirePositionalVoice() -- Line: 334
    -- upvalues: u8 (copy), u7 (copy), NewPositionalVoice (copy)
    local table_remove_ret = table.remove(u8);

    while table_remove_ret do
        local v49;

        if table_remove_ret.Attachment.Parent == nil then
            v49 = false;
        else
            v49 = table_remove_ret.Sound.Parent == table_remove_ret.Attachment;
        end;

        if v49 then
            table_remove_ret.Busy = true;

            return table_remove_ret;
        end;

        local table_find_ret = table.find(u7, table_remove_ret);

        if table_find_ret then
            table.remove(u7, table_find_ret);
        end;

        table_remove_ret = table.remove(u8);
    end;

    if #u7 < 96 then
        return NewPositionalVoice();
    end;

    for _, v in u7 do
        if not v.Sound.Playing then
            local v50;

            if v.Attachment.Parent == nil then
                v50 = false;
            else
                v50 = v.Sound.Parent == v.Attachment;
            end;

            if v50 then
                v.Busy = true;

                return v;
            end;
        end;
    end;

    return nil;
end;

local function PlayOnPositionalVoice(p51: userdata, p52: vector, p53: number, p54: number?, p55: boolean) -- Line: 360
    -- upvalues: IsVoiceable (copy), AcquirePositionalVoice (copy), u10 (copy), u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    if not IsVoiceable(p51) then
        return false;
    end;

    local v56 = AcquirePositionalVoice();

    if not v56 then
        return false;
    end;

    local Sound = v56.Sound;
    v56.Attachment.WorldPosition = p52;

    if Sound.SoundId ~= p51.SoundId then
        Sound.SoundId = p51.SoundId;
    end;

    if p55 then
        Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
        Sound.RollOffMaxDistance = 10000;
        Sound.RollOffMinDistance = 10000;
    else
        Sound.RollOffMode = p51.RollOffMode;
        Sound.RollOffMaxDistance = p51.RollOffMaxDistance;
        Sound.RollOffMinDistance = p51.RollOffMinDistance;
    end;

    Sound.SoundGroup = p51.SoundGroup;
    Sound.PlaybackSpeed = p51.PlaybackSpeed;
    local v57 = u10[p51];

    if v57 then
        local PitchShift = v56.PitchShift;

        if not PitchShift then
            PitchShift = Instance.new("PitchShiftSoundEffect");
            PitchShift.Parent = v56.Sound;
            v56.PitchShift = PitchShift;
        end;

        PitchShift.Octave = v57.Octave;
        PitchShift.Enabled = true;
    elseif v56.PitchShift then
        v56.PitchShift.Enabled = false;
    end;

    Sound.TimePosition = p51.TimePosition;

    if not u12 then
        local v58 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u11 = (tonumber(v58) or 100) / 100;
        u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p59) -- Line: 243
            -- upvalues: u11 (ref), u6 (ref)
            u11 = (tonumber(p59) or 100) / 100;

            for i, v in pairs(u6) do
                if i.Parent then
                    i.Volume = v.BaseVolume * u11 * v.OtherMultiplier;
                    i:SetAttribute("MasterVolumeMultiplier", u11);
                else
                    u6[i] = nil;
                end;
            end;
        end);
    end;

    local Volume = v56.Volume;
    Volume.BaseVolume = p53;
    Volume.OtherMultiplier = p54 or 1;
    u6[Sound] = Volume;
    Sound.Volume = p53 * u11 * Volume.OtherMultiplier;
    Sound:Play();

    return true;
end;

function u1.play(p60: any, p61: any, p62: number?) -- Line: 412
    -- upvalues: HttpService (copy), TranslateSoundPath (copy), u14 (copy), u15 (copy), u13 (ref), SoundService (copy), TrackMasterVolume (copy)
    local v63 = p61.Parent or p61.Path;
    local v64 = `Sound couldn't locate sound parent for {p61.Name}`;
    assert(v63, v64);

    if not p60.Sounds then
        return nil;
    end;

    local v65 = p60.Sounds:FindFirstChild(p61.Name);

    if v65 then
        local v66 = HttpService:GenerateGUID(false);
        local Parent = p61.Parent;

        if p61.Path and not Parent then
            Parent = TranslateSoundPath(p61.Path);
        end;

        if not Parent then
            return nil;
        end;

        local Children = v65:GetChildren();
        local v67 = Children[math.random(1, #Children)];

        if v67:GetAttribute("Persistent") == true then
            local u68 = u14[v67];

            if not (u68 and u68:IsDescendantOf(game)) then
                if u68 then
                    u15[u68] = nil;
                end;

                u68 = v67:Clone();
                local v69;

                if u13 and u13.Parent then
                    v69 = u13;
                else
                    v69 = SoundService:FindFirstChild("PersistentSounds");

                    if not v69 then
                        v69 = Instance.new("Folder");
                        v69.Name = "PersistentSounds";
                        v69.Parent = SoundService;
                    end;

                    u13 = v69;
                end;

                u68.Parent = v69;
                u14[v67] = u68;
            end;

            if not u68.IsPlaying then
                local u70 = (u15[u68] or 0) + 1;
                u15[u68] = u70;
                u68.Parent = Parent;
                u68.TimePosition = 0;
                TrackMasterVolume(u68, v67.Volume, p62);
                u68:Play();
                u68.Ended:Once(function() -- Line: 446
                    -- upvalues: u15 (ref), u68 (copy), u70 (copy), u13 (ref), SoundService (ref)
                    if u15[u68] == u70 then
                        local v71;

                        if u13 and u13.Parent then
                            v71 = u13;
                        else
                            v71 = SoundService:FindFirstChild("PersistentSounds");

                            if not v71 then
                                v71 = Instance.new("Folder");
                                v71.Name = "PersistentSounds";
                                v71.Parent = SoundService;
                            end;

                            u13 = v71;
                        end;

                        u68.Parent = v71;
                    end;
                end);

                return u68;
            end;
        end;

        local u72 = v67:Clone();
        u72.Parent = Parent;
        u72.Name = v66;
        TrackMasterVolume(u72, u72.Volume, p62);
        u72:Play();
        u72.Ended:Once(function() -- Line: 460
            -- upvalues: u72 (copy)
            u72:Destroy();
        end);

        return u72;
    end;
end;

function u1.playOn(p73: any, p74: userdata, p75: string, p76: number?) -- Line: 471
    -- upvalues: TrackMasterVolume (copy)
    local v77 = p73.Sounds and p73.Sounds:FindFirstChild(p75);

    if not v77 or #v77:GetChildren() == 0 then
        return false;
    end;

    local Children = v77:GetChildren();
    local v78 = Children[math.random(1, #Children)];

    if p74.SoundId ~= v78.SoundId then
        p74.SoundId = v78.SoundId;
    end;

    p74.RollOffMode = v78.RollOffMode;
    p74.RollOffMinDistance = v78.RollOffMinDistance;
    p74.RollOffMaxDistance = v78.RollOffMaxDistance;
    p74.SoundGroup = v78.SoundGroup;
    p74.Looped = false;
    p74.TimePosition = 0;
    TrackMasterVolume(p74, v78.Volume, p76);
    p74:Play();

    return true;
end;

function u1.playOneTime(p79: any, p80: any, p81: number?) -- Line: 491
    return p79:play(p80, p81);
end;

function u1.PlaySoundAtPosition(u82: any, p83: any, p84: number?, p85: number?, p86: boolean?, p87: boolean?) -- Line: 497
    -- upvalues: PlayOnPositionalVoice (copy), u5 (copy), Debris (copy), HttpService (copy), TrackMasterVolume (copy)
    if u82.IsDestroyed then
        return;
    end;

    local v88 = u82.Sounds and u82.Sounds:FindFirstChild(p83.Name);

    if not v88 then
        u82:destroy();

        return;
    end;

    local Children = v88:GetChildren();
    local v89 = Children[math.random(1, #Children)];
    local v90 = (p83.Name == "Headshot" and true or p83.Name == "Helmet Headshot") and p86 == true;
    local v91;

    if v90 and p87 then
        v91 = v89.Volume * 0;
    else
        v91 = v89.Volume;
    end;

    if PlayOnPositionalVoice(v89, p83.Position, v91, p85, v90) then
        return;
    end;

    local u92, u93 = u5:Acquire();
    u82.Janitor:Add(function() -- Line: 536
        -- upvalues: u5 (ref), u92 (copy), u93 (copy)
        u5:Release(u92, u93);
    end);
    u92.Position = p83.Position;
    u92.CollisionGroup = "Debris";
    u92.Parent = Debris;
    local u94 = u82.Janitor:Add(v89:Clone());
    local Volume = u94.Volume;
    u94.Name = HttpService:GenerateGUID(false);
    u94.Parent = u92;

    if v90 then
        u94.RollOffMode = Enum.RollOffMode.InverseTapered;
        u94.RollOffMaxDistance = 10000;
        u94.RollOffMinDistance = 10000;

        if p87 then
            Volume = Volume * 0;
        end;
    end;

    TrackMasterVolume(u94, Volume, p85);
    u94:Play();

    if u94.Looped and p84 then
        u82.Janitor:Add(task.delay(p84, function() -- Line: 562
            -- upvalues: u82 (copy)
            u82:destroy();
        end), true);
    else
        u82.Janitor:Add(u94.Ended:Once(function() -- Line: 568
            -- upvalues: u82 (copy)
            u82:destroy();
        end));
    end;

    u82.Janitor:Add(u94.AncestryChanged:Connect(function() -- Line: 574
        -- upvalues: u94 (copy), u82 (copy)
        if not u94.Parent then
            u82:destroy();
        end;
    end));
end;

u1.GameplaySoundGroup = Gameplay;

local function WarmPersistentTemplate(u95: userdata) -- Line: 588
    -- upvalues: u14 (copy), u15 (copy), u13 (ref), SoundService (copy), ContentProvider (copy)
    local u96 = u14[u95];

    if not (u96 and u96:IsDescendantOf(game)) then
        if u96 then
            u15[u96] = nil;
        end;

        u96 = u95:Clone();
        local v97;

        if u13 and u13.Parent then
            v97 = u13;
        else
            v97 = SoundService:FindFirstChild("PersistentSounds");

            if not v97 then
                v97 = Instance.new("Folder");
                v97.Name = "PersistentSounds";
                v97.Parent = SoundService;
            end;

            u13 = v97;
        end;

        u96.Parent = v97;
        u14[u95] = u96;
    end;

    local u98 = (u15[u96] or 0) + 1;
    u15[u96] = u98;
    pcall(function() -- Line: 592
        -- upvalues: ContentProvider (ref), u96 (copy)
        ContentProvider:PreloadAsync({ u96 });
    end);

    if u15[u96] ~= u98 or u96.IsPlaying then
        return;
    end;

    u96.Volume = 0;
    u96:Play();
    task.delay(0.5, function() -- Line: 602
        -- upvalues: u15 (ref), u96 (copy), u98 (copy), u95 (copy)
        if u15[u96] == u98 then
            u96:Stop();
            u96.TimePosition = 0;
            u96.Volume = u95.Volume;
        end;
    end);
end;

function u1.WarmPersistentSounds() -- Line: 611
    -- upvalues: u2 (ref), WarmPersistentTemplate (copy)
    for _, descendant in u2:GetDescendants() do
        if descendant:IsA("Sound") and (descendant:GetAttribute("Persistent") == true and descendant:GetAttribute("WarmOnUse") ~= true) then
            WarmPersistentTemplate(descendant);
        end;
    end;
end;

function u1.WarmPersistentSound(p99: string, p100: string) -- Line: 624
    -- upvalues: u2 (ref), WarmPersistentTemplate (copy)
    local v101 = u2:WaitForChild(p99):FindFirstChild(p100);

    if not v101 then
        return;
    end;

    for _, child in v101:GetChildren() do
        if child:IsA("Sound") and child:GetAttribute("Persistent") == true then
            WarmPersistentTemplate(child);
        end;
    end;
end;

function u1.createSoundGroup(p102: userdata) -- Line: 639
    -- upvalues: u2 (ref), u3 (copy), Gameplay (ref), CreateSoundInstance (copy)
    local v103 = require(p102);
    local Folder = Instance.new("Folder", u2);
    Folder.Name = p102.Name;
    local v104;

    if u3[p102.Name] then
        v104 = nil;
    else
        v104 = Gameplay;
    end;

    for i, v in pairs(v103) do
        if typeof(v) == "table" and typeof(v.Identifiers) == "table" then
            local Folder2 = Instance.new("Folder", Folder);
            Folder2.Name = i;
            local v105 = v;

            for i2, v2 in ipairs(v.Identifiers) do
                local v106 = CreateSoundInstance(i2, v2, v105.Properties);
                v106.SoundGroup = v104;
                v106.Parent = Folder2;
            end;
        end;
    end;
end;

function u1.new(p107: string) -- Line: 663
    -- upvalues: u1 (copy), Janitor (copy), u2 (ref)
    local v108 = setmetatable({}, u1);
    v108.Janitor = Janitor.new();
    v108.IsDestroyed = false;
    v108.SoundGroupName = p107;
    v108.Sounds = u2:WaitForChild(p107, 10);

    return v108;
end;

function u1.destroy(p109) -- Line: 675
    if p109.IsDestroyed then
        return;
    end;

    p109.IsDestroyed = true;
    p109.Janitor:Destroy();
    p109.SoundGroupName = nil;
    p109.Janitor = nil;
    p109.Sounds = nil;
end;

return u1;