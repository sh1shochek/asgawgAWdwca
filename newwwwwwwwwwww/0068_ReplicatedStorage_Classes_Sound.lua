-- Sound (ModuleScript)
-- full path: ReplicatedStorage.Classes.Sound

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
    local v24 = game;

    for i = 2, #string_split_ret do
        local u25 = string_split_ret[i];

        if v24 == game then
            local success, result = pcall(function() -- Line: 180
                -- upvalues: u25 (copy)
                return game:GetService(u25);
            end);
            v24 = success and result and result or game:FindFirstChild(u25);
        else
            v24 = v24:FindFirstChild(u25);
        end;

        local v26;

        if v24 then
            v26 = i;
        else
            error((`Path: "{p23}" does not exist`));
            v26 = i;
        end;
    end;

    return v24;
end;

local function CreateSoundInstance(p27: string, p28: string, p29: any) -- Line: 197
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = p29.RollOffMaxDistance or 10000;
    Sound.RollOffMinDistance = p29.RollOffMinDistance or 10;
    Sound.TimePosition = p29.TimePosition or 0;
    Sound.RollOffMode = p29.RollOffMode or Enum.RollOffMode.Inverse;
    Sound.Looped = p29.Looped or false;
    Sound.SoundId = `rbxassetid://{p28}`;
    Sound.Volume = p29.Volume or 0.5;
    Sound.Name = p27;
    local Pitch = p29.Pitch;

    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Name = "PitchShift";
        PitchShiftSoundEffect.Octave = math.clamp(Pitch, 0.5, 2);
        PitchShiftSoundEffect.Parent = Sound;
    end;

    if p29.Persistent then
        Sound:SetAttribute("Persistent", true);
    end;

    if p29.WarmOnUse then
        Sound:SetAttribute("WarmOnUse", true);
    end;

    return Sound;
end;

local function GetMasterVolumeMultiplier() -- Line: 227
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v30 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;

    return (tonumber(v30) or 100) / 100;
end;

local function ApplyTrackedVolume(p31: userdata, p32: table) -- Line: 232
    -- upvalues: u11 (ref)
    p31.Volume = p32.BaseVolume * u11 * p32.OtherMultiplier;
    p31:SetAttribute("MasterVolumeMultiplier", u11);
end;

local function EnsureMasterVolumeListener() -- Line: 237
    -- upvalues: u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    if u12 then
        return;
    end;

    local v33 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    u11 = (tonumber(v33) or 100) / 100;
    u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p34) -- Line: 243
        -- upvalues: u11 (ref), u6 (ref)
        u11 = (tonumber(p34) or 100) / 100;

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

local function TrackMasterVolume(u35: userdata, p36: number, p37: number?) -- Line: 256
    -- upvalues: u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    local v38 = p37 or 1;
    local v39 = {
        BaseVolume = p36,
        OtherMultiplier = v38
    };

    if not u12 then
        local v40 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u11 = (tonumber(v40) or 100) / 100;
        u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p41) -- Line: 243
            -- upvalues: u11 (ref), u6 (ref)
            u11 = (tonumber(p41) or 100) / 100;

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

    local v42 = u6[u35] == nil;
    u6[u35] = v39;
    u35:SetAttribute("BaseVolume", p36);
    u35:SetAttribute("OtherVolumeMultiplier", v38);
    u35.Volume = v39.BaseVolume * u11 * v39.OtherMultiplier;
    u35:SetAttribute("MasterVolumeMultiplier", u11);

    if v42 then
        u35.Destroying:Once(function() -- Line: 273
            -- upvalues: u6 (ref), u35 (copy)
            u6[u35] = nil;
        end);
    end;
end;

local function IsVoiceable(p43: userdata) -- Line: 281
    -- upvalues: u9 (copy), u10 (copy)
    local v44 = u9[p43];

    if v44 ~= nil then
        return v44;
    end;

    local v45 = not p43.Looped;

    for _, child in p43:GetChildren() do
        if child:IsA("PitchShiftSoundEffect") and not u10[p43] then
            u10[p43] = child;
        else
            v45 = false;
        end;
    end;

    u9[p43] = v45;

    return v45;
end;

local function NewPositionalVoice() -- Line: 298
    -- upvalues: u8 (copy), u7 (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "SoundVoice";
    local Sound = Instance.new("Sound");
    Sound.Parent = Attachment;
    Attachment.Parent = workspace.Terrain;
    local u46 = {
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
        -- upvalues: u46 (copy), u8 (ref)
        if u46.Busy then
            u46.Busy = false;
            u8[#u8 + 1] = u46;
        end;
    end);
    u7[#u7 + 1] = u46;

    return u46;
end;

local function NewVoicePitchShift(p47: table) -- Line: 321
    local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
    PitchShiftSoundEffect.Parent = p47.Sound;
    p47.PitchShift = PitchShiftSoundEffect;

    return PitchShiftSoundEffect;
end;

local function IsVoiceIntact(p48: table) -- Line: 328
    local v49;

    if p48.Attachment.Parent == nil then
        v49 = false;
    else
        v49 = p48.Sound.Parent == p48.Attachment;
    end;

    return v49;
end;

local function AcquirePositionalVoice() -- Line: 334
    -- upvalues: u8 (copy), u7 (copy), NewPositionalVoice (copy)
    local table_remove_ret = table.remove(u8);

    while table_remove_ret do
        local v50;

        if table_remove_ret.Attachment.Parent == nil then
            v50 = false;
        else
            v50 = table_remove_ret.Sound.Parent == table_remove_ret.Attachment;
        end;

        if v50 then
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
            local v51;

            if v.Attachment.Parent == nil then
                v51 = false;
            else
                v51 = v.Sound.Parent == v.Attachment;
            end;

            if v51 then
                v.Busy = true;

                return v;
            end;
        end;
    end;

    return nil;
end;

local function PlayOnPositionalVoice(p52: userdata, p53: vector, p54: number, p55: number?, p56: boolean) -- Line: 360
    -- upvalues: IsVoiceable (copy), AcquirePositionalVoice (copy), u10 (copy), u12 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    if not IsVoiceable(p52) then
        return false;
    end;

    local v57 = AcquirePositionalVoice();

    if not v57 then
        return false;
    end;

    local Sound = v57.Sound;
    v57.Attachment.WorldPosition = p53;

    if Sound.SoundId ~= p52.SoundId then
        Sound.SoundId = p52.SoundId;
    end;

    if p56 then
        Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
        Sound.RollOffMaxDistance = 10000;
        Sound.RollOffMinDistance = 10000;
    else
        Sound.RollOffMode = p52.RollOffMode;
        Sound.RollOffMaxDistance = p52.RollOffMaxDistance;
        Sound.RollOffMinDistance = p52.RollOffMinDistance;
    end;

    Sound.SoundGroup = p52.SoundGroup;
    Sound.PlaybackSpeed = p52.PlaybackSpeed;
    local v58 = u10[p52];

    if v58 then
        local PitchShift = v57.PitchShift;

        if not PitchShift then
            PitchShift = Instance.new("PitchShiftSoundEffect");
            PitchShift.Parent = v57.Sound;
            v57.PitchShift = PitchShift;
        end;

        PitchShift.Octave = v58.Octave;
        PitchShift.Enabled = true;
    elseif v57.PitchShift then
        v57.PitchShift.Enabled = false;
    end;

    Sound.TimePosition = p52.TimePosition;

    if not u12 then
        local v59 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u11 = (tonumber(v59) or 100) / 100;
        u12 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p60) -- Line: 243
            -- upvalues: u11 (ref), u6 (ref)
            u11 = (tonumber(p60) or 100) / 100;

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

    local Volume = v57.Volume;
    Volume.BaseVolume = p54;
    Volume.OtherMultiplier = p55 or 1;
    u6[Sound] = Volume;
    Sound.Volume = p54 * u11 * Volume.OtherMultiplier;
    Sound:Play();

    return true;
end;

function u1.play(p61: any, p62: any, p63: number?) -- Line: 412
    -- upvalues: HttpService (copy), TranslateSoundPath (copy), u14 (copy), u15 (copy), u13 (ref), SoundService (copy), TrackMasterVolume (copy)
    local v64 = p62.Parent or p62.Path;
    local v65 = `Sound couldn't locate sound parent for {p62.Name}`;
    assert(v64, v65);

    if not p61.Sounds then
        return nil;
    end;

    local v66 = p61.Sounds:FindFirstChild(p62.Name);

    if v66 then
        local v67 = HttpService:GenerateGUID(false);
        local Parent = p62.Parent;

        if p62.Path and not Parent then
            Parent = TranslateSoundPath(p62.Path);
        end;

        if not Parent then
            return nil;
        end;

        local Children = v66:GetChildren();
        local v68 = Children[math.random(1, #Children)];

        if v68:GetAttribute("Persistent") == true then
            local u69 = u14[v68];

            if not (u69 and u69:IsDescendantOf(game)) then
                if u69 then
                    u15[u69] = nil;
                end;

                u69 = v68:Clone();
                local v70;

                if u13 and u13.Parent then
                    v70 = u13;
                else
                    v70 = SoundService:FindFirstChild("PersistentSounds");

                    if not v70 then
                        v70 = Instance.new("Folder");
                        v70.Name = "PersistentSounds";
                        v70.Parent = SoundService;
                    end;

                    u13 = v70;
                end;

                u69.Parent = v70;
                u14[v68] = u69;
            end;

            if not u69.IsPlaying then
                local u71 = (u15[u69] or 0) + 1;
                u15[u69] = u71;
                u69.Parent = Parent;
                u69.TimePosition = 0;
                TrackMasterVolume(u69, v68.Volume, p63);
                u69:Play();
                u69.Ended:Once(function() -- Line: 446
                    -- upvalues: u15 (ref), u69 (copy), u71 (copy), u13 (ref), SoundService (ref)
                    if u15[u69] == u71 then
                        local v72;

                        if u13 and u13.Parent then
                            v72 = u13;
                        else
                            v72 = SoundService:FindFirstChild("PersistentSounds");

                            if not v72 then
                                v72 = Instance.new("Folder");
                                v72.Name = "PersistentSounds";
                                v72.Parent = SoundService;
                            end;

                            u13 = v72;
                        end;

                        u69.Parent = v72;
                    end;
                end);

                return u69;
            end;
        end;

        local u73 = v68:Clone();
        u73.Parent = Parent;
        u73.Name = v67;
        TrackMasterVolume(u73, u73.Volume, p63);
        u73:Play();
        u73.Ended:Once(function() -- Line: 460
            -- upvalues: u73 (copy)
            u73:Destroy();
        end);

        return u73;
    end;
end;

function u1.playOn(p74: any, p75: userdata, p76: string, p77: number?) -- Line: 471
    -- upvalues: TrackMasterVolume (copy)
    local v78 = p74.Sounds and p74.Sounds:FindFirstChild(p76);

    if not v78 or #v78:GetChildren() == 0 then
        return false;
    end;

    local Children = v78:GetChildren();
    local v79 = Children[math.random(1, #Children)];

    if p75.SoundId ~= v79.SoundId then
        p75.SoundId = v79.SoundId;
    end;

    p75.RollOffMode = v79.RollOffMode;
    p75.RollOffMinDistance = v79.RollOffMinDistance;
    p75.RollOffMaxDistance = v79.RollOffMaxDistance;
    p75.SoundGroup = v79.SoundGroup;
    p75.Looped = false;
    p75.TimePosition = 0;
    TrackMasterVolume(p75, v79.Volume, p77);
    p75:Play();

    return true;
end;

function u1.playOneTime(p80: any, p81: any, p82: number?) -- Line: 491
    return p80:play(p81, p82);
end;

function u1.PlaySoundAtPosition(u83: any, p84: any, p85: number?, p86: number?, p87: boolean?, p88: boolean?) -- Line: 497
    -- upvalues: PlayOnPositionalVoice (copy), u5 (copy), Debris (copy), HttpService (copy), TrackMasterVolume (copy)
    if u83.IsDestroyed then
        return;
    end;

    local v89 = u83.Sounds and u83.Sounds:FindFirstChild(p84.Name);

    if not v89 then
        u83:destroy();

        return;
    end;

    local Children = v89:GetChildren();
    local v90 = Children[math.random(1, #Children)];
    local v91 = (p84.Name == "Headshot" and true or p84.Name == "Helmet Headshot") and p87 == true;
    local v92;

    if v91 and p88 then
        v92 = v90.Volume * 0;
    else
        v92 = v90.Volume;
    end;

    if PlayOnPositionalVoice(v90, p84.Position, v92, p86, v91) then
        return;
    end;

    local u93, u94 = u5:Acquire();
    u83.Janitor:Add(function() -- Line: 536
        -- upvalues: u5 (ref), u93 (copy), u94 (copy)
        u5:Release(u93, u94);
    end);
    u93.Position = p84.Position;
    u93.CollisionGroup = "Debris";
    u93.Parent = Debris;
    local u95 = u83.Janitor:Add(v90:Clone());
    local Volume = u95.Volume;
    u95.Name = HttpService:GenerateGUID(false);
    u95.Parent = u93;

    if v91 then
        u95.RollOffMode = Enum.RollOffMode.InverseTapered;
        u95.RollOffMaxDistance = 10000;
        u95.RollOffMinDistance = 10000;

        if p88 then
            Volume = Volume * 0;
        end;
    end;

    TrackMasterVolume(u95, Volume, p86);
    u95:Play();

    if u95.Looped and p85 then
        u83.Janitor:Add(task.delay(p85, function() -- Line: 562
            -- upvalues: u83 (copy)
            u83:destroy();
        end), true);
    else
        u83.Janitor:Add(u95.Ended:Once(function() -- Line: 568
            -- upvalues: u83 (copy)
            u83:destroy();
        end));
    end;

    u83.Janitor:Add(u95.AncestryChanged:Connect(function() -- Line: 574
        -- upvalues: u95 (copy), u83 (copy)
        if not u95.Parent then
            u83:destroy();
        end;
    end));
end;

u1.GameplaySoundGroup = Gameplay;

local function WarmPersistentTemplate(u96: userdata) -- Line: 588
    -- upvalues: u14 (copy), u15 (copy), u13 (ref), SoundService (copy), ContentProvider (copy)
    local u97 = u14[u96];

    if not (u97 and u97:IsDescendantOf(game)) then
        if u97 then
            u15[u97] = nil;
        end;

        u97 = u96:Clone();
        local v98;

        if u13 and u13.Parent then
            v98 = u13;
        else
            v98 = SoundService:FindFirstChild("PersistentSounds");

            if not v98 then
                v98 = Instance.new("Folder");
                v98.Name = "PersistentSounds";
                v98.Parent = SoundService;
            end;

            u13 = v98;
        end;

        u97.Parent = v98;
        u14[u96] = u97;
    end;

    local u99 = (u15[u97] or 0) + 1;
    u15[u97] = u99;
    pcall(function() -- Line: 592
        -- upvalues: ContentProvider (ref), u97 (copy)
        ContentProvider:PreloadAsync({ u97 });
    end);

    if u15[u97] ~= u99 or u97.IsPlaying then
        return;
    end;

    u97.Volume = 0;
    u97:Play();
    task.delay(0.5, function() -- Line: 602
        -- upvalues: u15 (ref), u97 (copy), u99 (copy), u96 (copy)
        if u15[u97] == u99 then
            u97:Stop();
            u97.TimePosition = 0;
            u97.Volume = u96.Volume;
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

function u1.WarmPersistentSound(p100: string, p101: string) -- Line: 624
    -- upvalues: u2 (ref), WarmPersistentTemplate (copy)
    local v102 = u2:WaitForChild(p100):FindFirstChild(p101);

    if not v102 then
        return;
    end;

    for _, child in v102:GetChildren() do
        if child:IsA("Sound") and child:GetAttribute("Persistent") == true then
            WarmPersistentTemplate(child);
        end;
    end;
end;

function u1.createSoundGroup(p103: userdata) -- Line: 639
    -- upvalues: u2 (ref), u3 (copy), Gameplay (ref), CreateSoundInstance (copy)
    local v104 = require(p103);
    local Folder = Instance.new("Folder", u2);
    Folder.Name = p103.Name;
    local v105;

    if u3[p103.Name] then
        v105 = nil;
    else
        v105 = Gameplay;
    end;

    for i, v in pairs(v104) do
        if typeof(v) == "table" and typeof(v.Identifiers) == "table" then
            local Folder2 = Instance.new("Folder", Folder);
            Folder2.Name = i;
            local v106 = v;

            for i2, v2 in ipairs(v.Identifiers) do
                local v107 = CreateSoundInstance(i2, v2, v106.Properties);
                v107.SoundGroup = v105;
                v107.Parent = Folder2;
            end;
        end;
    end;
end;

function u1.new(p108: string) -- Line: 663
    -- upvalues: u1 (copy), Janitor (copy), u2 (ref)
    local v109 = setmetatable({}, u1);
    v109.Janitor = Janitor.new();
    v109.IsDestroyed = false;
    v109.SoundGroupName = p108;
    v109.Sounds = u2:WaitForChild(p108, 10);

    return v109;
end;

function u1.destroy(p110) -- Line: 675
    if p110.IsDestroyed then
        return;
    end;

    p110.IsDestroyed = true;
    p110.Janitor:Destroy();
    p110.SoundGroupName = nil;
    p110.Janitor = nil;
    p110.Sounds = nil;
end;

return u1;