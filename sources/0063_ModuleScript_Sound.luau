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
local u7 = 1;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = {};

local function PickSound(p12) -- Line: 95
    local Children = p12:GetChildren();

    return Children[math.random(1, #Children)];
end;

local function GetPersistentSoundsFolder() -- Line: 102
    -- upvalues: u9 (ref), SoundService (copy)
    if u9 and u9.Parent then
        return u9;
    end;

    local PersistentSounds = SoundService:FindFirstChild("PersistentSounds");

    if not PersistentSounds then
        PersistentSounds = Instance.new("Folder");
        PersistentSounds.Name = "PersistentSounds";
        PersistentSounds.Parent = SoundService;
    end;

    u9 = PersistentSounds;

    return PersistentSounds;
end;

local function GetPersistentInstance(p13: userdata) -- Line: 119
    -- upvalues: u10 (copy), u11 (copy), u9 (ref), SoundService (copy)
    local v14 = u10[p13];

    if v14 and v14:IsDescendantOf(game) then
        return v14;
    end;

    if v14 then
        u11[v14] = nil;
    end;

    local v15 = p13:Clone();
    local v16;

    if u9 and u9.Parent then
        v16 = u9;
    else
        v16 = SoundService:FindFirstChild("PersistentSounds");

        if not v16 then
            v16 = Instance.new("Folder");
            v16.Name = "PersistentSounds";
            v16.Parent = SoundService;
        end;

        u9 = v16;
    end;

    v15.Parent = v16;
    u10[p13] = v15;

    return v15;
end;

local function ClaimPersistentPlay(p17: userdata) -- Line: 137
    -- upvalues: u11 (copy)
    local v18 = (u11[p17] or 0) + 1;
    u11[p17] = v18;

    return v18;
end;

local function TranslateSoundPath(p19: string) -- Line: 146
    local string_split_ret = string.split(p19, ".");
    local v20 = game;

    for i = 2, #string_split_ret do
        local u21 = string_split_ret[i];

        if v20 == game then
            local success, result = pcall(function() -- Line: 153
                -- upvalues: u21 (copy)
                return game:GetService(u21);
            end);
            v20 = success and result and result or game:FindFirstChild(u21);
        else
            v20 = v20:FindFirstChild(u21);
        end;

        local v22;

        if v20 then
            v22 = i;
        else
            error((`Path: "{p19}" does not exist`));
            v22 = i;
        end;
    end;

    return v20;
end;

local function CreateSoundInstance(p23: string, p24: string, p25: any) -- Line: 170
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = p25.RollOffMaxDistance or 10000;
    Sound.RollOffMinDistance = p25.RollOffMinDistance or 10;
    Sound.TimePosition = p25.TimePosition or 0;
    Sound.RollOffMode = Enum.RollOffMode.Inverse;
    Sound.Looped = p25.Looped or false;
    Sound.SoundId = `rbxassetid://{p24}`;
    Sound.Volume = p25.Volume or 0.5;
    Sound.Name = p23;
    local Pitch = p25.Pitch;

    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Name = "PitchShift";
        PitchShiftSoundEffect.Octave = math.clamp(Pitch, 0.5, 2);
        PitchShiftSoundEffect.Parent = Sound;
    end;

    if p25.Persistent then
        Sound:SetAttribute("Persistent", true);
    end;

    return Sound;
end;

local function GetMasterVolumeMultiplier() -- Line: 197
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v26 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;

    return (tonumber(v26) or 100) / 100;
end;

local function ApplyTrackedVolume(p27: userdata, p28: table) -- Line: 202
    -- upvalues: u7 (ref)
    p27.Volume = p28.BaseVolume * u7 * p28.OtherMultiplier;
    p27:SetAttribute("MasterVolumeMultiplier", u7);
end;

local function EnsureMasterVolumeListener() -- Line: 207
    -- upvalues: u8 (ref), u7 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    if u8 then
        return;
    end;

    local v29 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    u7 = (tonumber(v29) or 100) / 100;
    u8 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p30) -- Line: 213
        -- upvalues: u7 (ref), u6 (ref)
        u7 = (tonumber(p30) or 100) / 100;

        for i, v in pairs(u6) do
            if i.Parent then
                i.Volume = v.BaseVolume * u7 * v.OtherMultiplier;
                i:SetAttribute("MasterVolumeMultiplier", u7);
            else
                u6[i] = nil;
            end;
        end;
    end);
end;

local function TrackMasterVolume(u31: userdata, p32: number, p33: number?) -- Line: 226
    -- upvalues: u8 (ref), u7 (ref), DataController (copy), LocalPlayer (copy), u6 (copy)
    local v34 = p33 or 1;
    local v35 = {
        BaseVolume = p32,
        OtherMultiplier = v34
    };

    if not u8 then
        local v36 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u7 = (tonumber(v36) or 100) / 100;
        u8 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p37) -- Line: 213
            -- upvalues: u7 (ref), u6 (ref)
            u7 = (tonumber(p37) or 100) / 100;

            for i, v in pairs(u6) do
                if i.Parent then
                    i.Volume = v.BaseVolume * u7 * v.OtherMultiplier;
                    i:SetAttribute("MasterVolumeMultiplier", u7);
                else
                    u6[i] = nil;
                end;
            end;
        end);
    end;

    local v38 = u6[u31] == nil;
    u6[u31] = v35;
    u31:SetAttribute("BaseVolume", p32);
    u31:SetAttribute("OtherVolumeMultiplier", v34);
    u31.Volume = v35.BaseVolume * u7 * v35.OtherMultiplier;
    u31:SetAttribute("MasterVolumeMultiplier", u7);

    if v38 then
        u31.Destroying:Once(function() -- Line: 243
            -- upvalues: u6 (ref), u31 (copy)
            u6[u31] = nil;
        end);
    end;
end;

function u1.play(p39: any, p40: any, p41: number?) -- Line: 252
    -- upvalues: HttpService (copy), TranslateSoundPath (copy), u10 (copy), u11 (copy), u9 (ref), SoundService (copy), TrackMasterVolume (copy)
    local v42 = p40.Parent or p40.Path;
    local v43 = `Sound couldn't locate sound parent for {p40.Name}`;
    assert(v42, v43);

    if not p39.Sounds then
        return nil;
    end;

    local v44 = p39.Sounds:FindFirstChild(p40.Name);

    if v44 then
        local v45 = HttpService:GenerateGUID(false);
        local Parent = p40.Parent;

        if p40.Path and not Parent then
            Parent = TranslateSoundPath(p40.Path);
        end;

        if not Parent then
            return nil;
        end;

        local Children = v44:GetChildren();
        local v46 = Children[math.random(1, #Children)];

        if v46:GetAttribute("Persistent") == true then
            local u47 = u10[v46];

            if not (u47 and u47:IsDescendantOf(game)) then
                if u47 then
                    u11[u47] = nil;
                end;

                u47 = v46:Clone();
                local v48;

                if u9 and u9.Parent then
                    v48 = u9;
                else
                    v48 = SoundService:FindFirstChild("PersistentSounds");

                    if not v48 then
                        v48 = Instance.new("Folder");
                        v48.Name = "PersistentSounds";
                        v48.Parent = SoundService;
                    end;

                    u9 = v48;
                end;

                u47.Parent = v48;
                u10[v46] = u47;
            end;

            if not u47.IsPlaying then
                local u49 = (u11[u47] or 0) + 1;
                u11[u47] = u49;
                u47.Parent = Parent;
                u47.TimePosition = 0;
                TrackMasterVolume(u47, v46.Volume, p41);
                u47:Play();
                u47.Ended:Once(function() -- Line: 286
                    -- upvalues: u11 (ref), u47 (copy), u49 (copy), u9 (ref), SoundService (ref)
                    if u11[u47] == u49 then
                        local v50;

                        if u9 and u9.Parent then
                            v50 = u9;
                        else
                            v50 = SoundService:FindFirstChild("PersistentSounds");

                            if not v50 then
                                v50 = Instance.new("Folder");
                                v50.Name = "PersistentSounds";
                                v50.Parent = SoundService;
                            end;

                            u9 = v50;
                        end;

                        u47.Parent = v50;
                    end;
                end);

                return u47;
            end;
        end;

        local u51 = v46:Clone();
        u51.Parent = Parent;
        u51.Name = v45;
        TrackMasterVolume(u51, u51.Volume, p41);
        u51:Play();
        u51.Ended:Once(function() -- Line: 300
            -- upvalues: u51 (copy)
            u51:Destroy();
        end);

        return u51;
    end;
end;

function u1.playOneTime(p52: any, p53: any, p54: number?) -- Line: 308
    return p52:play(p53, p54);
end;

function u1.PlaySoundAtPosition(u55: any, p56: any, p57: number?, p58: number?, p59: boolean?, p60: boolean?) -- Line: 314
    -- upvalues: u5 (copy), Debris (copy), HttpService (copy), TrackMasterVolume (copy)
    if u55.IsDestroyed then
        return;
    end;

    local v61 = u55.Sounds and u55.Sounds:FindFirstChild(p56.Name);

    if not v61 then
        u55:destroy();

        return;
    end;

    local u62, u63 = u5:Acquire();
    u55.Janitor:Add(function() -- Line: 334
        -- upvalues: u5 (ref), u62 (copy), u63 (copy)
        u5:Release(u62, u63);
    end);
    u62.Position = p56.Position;
    u62.CollisionGroup = "Debris";
    u62.Parent = Debris;
    local Janitor2 = u55.Janitor;
    local Children = v61:GetChildren();
    local u64 = Janitor2:Add(Children[math.random(1, #Children)]:Clone());
    local Volume = u64.Volume;
    u64.Name = HttpService:GenerateGUID(false);
    u64.Parent = u62;

    if (p56.Name == "Headshot" and true or p56.Name == "Helmet Headshot") and p59 then
        u64.RollOffMode = Enum.RollOffMode.InverseTapered;
        u64.RollOffMaxDistance = 10000;
        u64.RollOffMinDistance = 10000;

        if p60 then
            Volume = Volume * 0;
        end;
    end;

    TrackMasterVolume(u64, Volume, p58);
    u64:Play();

    if u64.Looped and p57 then
        u55.Janitor:Add(task.delay(p57, function() -- Line: 363
            -- upvalues: u55 (copy)
            u55:destroy();
        end), true);
    else
        u55.Janitor:Add(u64.Ended:Once(function() -- Line: 369
            -- upvalues: u55 (copy)
            u55:destroy();
        end));
    end;

    u55.Janitor:Add(u64.AncestryChanged:Connect(function() -- Line: 375
        -- upvalues: u64 (copy), u55 (copy)
        if not u64.Parent then
            u55:destroy();
        end;
    end));
end;

u1.GameplaySoundGroup = Gameplay;

function u1.WarmPersistentSounds() -- Line: 389
    -- upvalues: u2 (ref), u10 (copy), u11 (copy), u9 (ref), SoundService (copy), ContentProvider (copy)
    for _, descendant in u2:GetDescendants() do
        if descendant:IsA("Sound") and descendant:GetAttribute("Persistent") == true then
            local u65 = u10[descendant];

            if not (u65 and u65:IsDescendantOf(game)) then
                if u65 then
                    u11[u65] = nil;
                end;

                u65 = descendant:Clone();
                local v66;

                if u9 and u9.Parent then
                    v66 = u9;
                else
                    v66 = SoundService:FindFirstChild("PersistentSounds");

                    if not v66 then
                        v66 = Instance.new("Folder");
                        v66.Name = "PersistentSounds";
                        v66.Parent = SoundService;
                    end;

                    u9 = v66;
                end;

                u65.Parent = v66;
                u10[descendant] = u65;
            end;

            local u67 = (u11[u65] or 0) + 1;
            u11[u65] = u67;
            pcall(function() -- Line: 397
                -- upvalues: ContentProvider (ref), u65 (copy)
                ContentProvider:PreloadAsync({ u65 });
            end);

            if u11[u65] == u67 and not u65.IsPlaying then
                u65.Volume = 0;
                u65:Play();
                task.delay(0.5, function() -- Line: 407
                    -- upvalues: u11 (ref), u65 (copy), u67 (copy), descendant (copy)
                    if u11[u65] == u67 then
                        u65:Stop();
                        u65.TimePosition = 0;
                        u65.Volume = descendant.Volume;
                    end;
                end);
            end;
        end;
    end;
end;

function u1.createSoundGroup(p68: userdata) -- Line: 419
    -- upvalues: u2 (ref), u3 (copy), Gameplay (ref), CreateSoundInstance (copy)
    local v69 = require(p68);
    local Folder = Instance.new("Folder", u2);
    Folder.Name = p68.Name;
    local v70;

    if u3[p68.Name] then
        v70 = nil;
    else
        v70 = Gameplay;
    end;

    for i, v in pairs(v69) do
        if typeof(v) == "table" and typeof(v.Identifiers) == "table" then
            local Folder2 = Instance.new("Folder", Folder);
            Folder2.Name = i;
            local v71 = v;

            for i2, v2 in ipairs(v.Identifiers) do
                local v72 = CreateSoundInstance(i2, v2, v71.Properties);
                v72.SoundGroup = v70;
                v72.Parent = Folder2;
            end;
        end;
    end;
end;

function u1.new(p73: string) -- Line: 443
    -- upvalues: u1 (copy), Janitor (copy), u2 (ref)
    local v74 = setmetatable({}, u1);
    v74.Janitor = Janitor.new();
    v74.IsDestroyed = false;
    v74.SoundGroupName = p73;
    v74.Sounds = u2:WaitForChild(p73, 10);

    return v74;
end;

function u1.destroy(p75) -- Line: 455
    if p75.IsDestroyed then
        return;
    end;

    p75.IsDestroyed = true;
    p75.Janitor:Destroy();
    p75.SoundGroupName = nil;
    p75.Janitor = nil;
    p75.Sounds = nil;
end;

return u1;