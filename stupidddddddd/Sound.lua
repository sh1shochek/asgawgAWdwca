-- ReplicatedStorage.Classes.Sound
-- Script path: ReplicatedStorage.Classes.Sound
-- Decompile time: 8.80 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DataController = require((ReplicatedStorage:WaitForChild("Controllers")):WaitForChild("DataController"))
require(script:WaitForChild("Types"))
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool)
local u62 = ReplicatedStorage:FindFirstChild("Sounds") or Instance.new("Folder", ReplicatedStorage)
u62.Name = "Sounds"
local Debris = workspace:WaitForChild("Debris")
local u69 = {Interface = true, ["Main Menu"] = true, Store = true, ArmsDealer = true}
local Gameplay = SoundService:FindFirstChild("Gameplay")
if not Gameplay then
    local SoundGroup = Instance.new("SoundGroup")
    SoundGroup.Name = "Gameplay"
    SoundGroup.Parent = SoundService
    Gameplay = SoundGroup
end
local Part = Instance.new("Part")
Part.Size = Vector3.new(1, 1, 1)
Part.CanCollide = false
Part.CanTouch = false
Part.CanQuery = false
Part.CastShadow = false
Part.Anchored = true
Part.Transparency = 1
Part.Name = "Sound"
local u101 = ObjectPool.new(Part, {
    InitialSize = 8,
    MaxRetained = 32,
    Reset = function(a1) -- Line: 65 -- types: a1: userdata
        a1.CFrame = CFrame.identity
    end,
})
local u102 = {}
local u103 = 1
local u104 = nil
local u105 = nil
local u106 = {}
local u107 = {}

local function PickSound(a1) -- Line: 95
    local Children = a1:GetChildren()
    return Children[math.random(1, #Children)]
end

local function GetPersistentSoundsFolder() -- Line: 102 -- upvalues: u105 (ref), SoundService (val)
    if u105 and u105.Parent then
        return u105
    end
    local PersistentSounds = SoundService:FindFirstChild("PersistentSounds")
    if not PersistentSounds then
        PersistentSounds = Instance.new("Folder")
        PersistentSounds.Name = "PersistentSounds"
        PersistentSounds.Parent = SoundService
    end
    u105 = PersistentSounds
    return PersistentSounds
end

local function GetPersistentInstance(a1) -- Line: 119
    -- upvalues: u106 (val), u107 (val), u105 (ref), SoundService (val)
    local v1
    local v2 = u106[a1]
    if v2 and v2:IsDescendantOf(game) then
        return v2
    end
    if v2 then
        u107[v2] = nil
    end
    local v3 = a1:Clone()
    if not u105 or not u105.Parent then
        local PersistentSounds = SoundService:FindFirstChild("PersistentSounds")
        if not PersistentSounds then
            PersistentSounds = Instance.new("Folder")
            PersistentSounds.Name = "PersistentSounds"
            PersistentSounds.Parent = SoundService
        end
        u105 = PersistentSounds
        v1 = PersistentSounds
    else
        v1 = u105
    end
    v3.Parent = v1
    u106[a1] = v3
    return v3
end

local function ClaimPersistentPlay(a1) -- Line: 137 -- upvalues: u107 (val) -- types: a1: userdata
    local v1 = (u107[a1] or 0) + 1
    u107[a1] = v1
    return v1
end

local function TranslateSoundPath(a1) -- Line: 146 -- types: a1: string
    local result, success
    local v1 = string.split(a1, ".")
    local v2 = game
    local v3 = #v1
    for i = 2, v3 do
        local u13 = v1[i]
        if v2 ~= game then
            v2 = v2:FindFirstChild(u13)
        else
            success, result = pcall(function() -- Line: 153 -- upvalues: u13 (val)
                return game:GetService(u13)
            end)
            v2 = success and result or game:FindFirstChild(u13)
        end
        if not v2 then
            error((("Path: \"%*\" does not exist"):format(a1)))
        end
    end
    return v2
end

local function CreateSoundInstance(a1, a2, a3) -- Line: 170 -- types: a1: string, a2: string
    local Sound = Instance.new("Sound")
    Sound.RollOffMaxDistance = a3.RollOffMaxDistance or 10000
    Sound.RollOffMinDistance = a3.RollOffMinDistance or 10
    Sound.TimePosition = a3.TimePosition or 0
    Sound.RollOffMode = Enum.RollOffMode.Inverse
    Sound.Looped = a3.Looped or false
    Sound.SoundId = ("rbxassetid://%*"):format(a2)
    Sound.Volume = a3.Volume or 0.5
    Sound.Name = a1
    local Pitch = a3.Pitch
    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
        PitchShiftSoundEffect.Name = "PitchShift"
        PitchShiftSoundEffect.Octave = math.clamp(Pitch, 0.5, 2)
        PitchShiftSoundEffect.Parent = Sound
    end
    if a3.Persistent then
        Sound:SetAttribute("Persistent", true)
    end
    return Sound
end

local function GetMasterVolumeMultiplier() -- Line: 197 -- upvalues: DataController (val), LocalPlayer (val)
    return (tonumber((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) or 100) / 100
end

local function ApplyTrackedVolume(a1, a2) -- Line: 202 -- upvalues: u103 (ref) -- types: a1: userdata, a2: table
    a1.Volume = a2.BaseVolume * u103 * a2.OtherMultiplier
    a1:SetAttribute("MasterVolumeMultiplier", u103)
end

local function EnsureMasterVolumeListener() -- Line: 207
    -- upvalues: u104 (ref), u103 (ref), DataController (val), LocalPlayer (val), u102 (val)
    if u104 then
        return
    end
    u103 = (tonumber((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) or 100) / 100
    u104 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(a1) -- Line: 213 -- upvalues: u103 (upval), u102 (upval)
        local v1
        u103 = (tonumber(a1) or 100) / 100
        for k, v in pairs(u102) do
            if not k.Parent then
                u102[k] = nil
            else
                v1 = v.BaseVolume * u103
                k.Volume = v1 * v.OtherMultiplier
                k:SetAttribute("MasterVolumeMultiplier", u103)
            end
        end
    end)
end

local function TrackMasterVolume(a1, a2, a3) -- Line: 226
    -- upvalues: u104 (ref), u103 (ref), DataController (val), LocalPlayer (val), u102 (val)
    local v1 = a3 or 1
    local v2 = {BaseVolume = a2, OtherMultiplier = v1}
    if not u104 then
        u103 = (tonumber((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) or 100) / 100
        u104 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(a1) -- Line: 213 -- upvalues: u103 (upval), u102 (upval)
            local v1
            u103 = (tonumber(a1) or 100) / 100
            for k, v in pairs(u102) do
                if not k.Parent then
                    u102[k] = nil
                else
                    v1 = v.BaseVolume * u103
                    k.Volume = v1 * v.OtherMultiplier
                    k:SetAttribute("MasterVolumeMultiplier", u103)
                end
            end
        end)
    end
    local v3 = u102[a1] == nil
    u102[a1] = v2
    a1:SetAttribute("BaseVolume", a2)
    a1:SetAttribute("OtherVolumeMultiplier", v1)
    a1.Volume = v2.BaseVolume * u103 * v2.OtherMultiplier
    a1:SetAttribute("MasterVolumeMultiplier", u103)
    if v3 then
        a1.Destroying:Once(function() -- Line: 243 -- upvalues: u102 (upval), a1 (val)
            u102[a1] = nil
        end)
    end
end

function u0:play(a2, a3) -- Line: 252
    -- upvalues: HttpService (val), TranslateSoundPath (val), u106 (val), u107 (val), u105 (ref), SoundService (val)
    -- upvalues: TrackMasterVolume (val)
    assert(a2.Parent or a2.Path, (("Sound couldn't locate sound parent for %*"):format(a2.Name)))
    if not self.Sounds then
        return nil
    end
    local v1 = self.Sounds:FindFirstChild(a2.Name)
    if not v1 then
        return
    end
    local v2 = HttpService:GenerateGUID(false)
    local Parent_2 = a2.Parent
    if a2.Path and not Parent_2 then
        Parent_2 = TranslateSoundPath(a2.Path)
    end
    if not Parent_2 then
        return nil
    end
    local Children = v1:GetChildren()
    local v3 = Children[math.random(1, #Children)]
    if v3:GetAttribute("Persistent") == true then
        local u88
        local v4 = u106[v3]
        if not v4 or not v4:IsDescendantOf(game) then
            local v5
            if v4 then
                u107[v4] = nil
            end
            local v6 = v3:Clone()
            if not u105 or not u105.Parent then
                local PersistentSounds = SoundService:FindFirstChild("PersistentSounds")
                if not PersistentSounds then
                    PersistentSounds = Instance.new("Folder")
                    PersistentSounds.Name = "PersistentSounds"
                    PersistentSounds.Parent = SoundService
                end
                u105 = PersistentSounds
                v5 = PersistentSounds
            else
                v5 = u105
            end
            v6.Parent = v5
            u106[v3] = v6
            u88 = v6
        else
            u88 = v4
        end
        if not u88.IsPlaying then
            local u94 = (u107[u88] or 0) + 1
            u107[u88] = u94
            u88.Parent = Parent_2
            u88.TimePosition = 0
            TrackMasterVolume(u88, v3.Volume, a3)
            u88:Play()
            u88.Ended:Once(function() -- Line: 286 -- upvalues: u107 (upval), u88 (val), u94 (val), u105 (upval), SoundService (upval)
                if u107[u88] == u94 then
                    local v1
                    if not u105 or not u105.Parent then
                        local PersistentSounds = SoundService:FindFirstChild("PersistentSounds")
                        if not PersistentSounds then
                            PersistentSounds = Instance.new("Folder")
                            PersistentSounds.Name = "PersistentSounds"
                            PersistentSounds.Parent = SoundService
                        end
                        u105 = PersistentSounds
                        v1 = PersistentSounds
                    else
                        v1 = u105
                    end
                    u88.Parent = v1
                end
            end)
            return u88
        end
    end
    local u128 = v3:Clone()
    u128.Parent = Parent_2
    u128.Name = v2
    TrackMasterVolume(u128, u128.Volume, a3)
    u128:Play()
    u128.Ended:Once(function() -- Line: 300 -- upvalues: u128 (val)
        u128:Destroy()
    end)
    return u128
end

function u0.playOneTime(a1, a2, a3) -- Line: 308 -- types: a3: number?
    return a1:play(a2, a3)
end

function u0.PlaySoundAtPosition(a1, a2, a3, a4, a5, a6) -- Line: 314
    -- upvalues: u101 (val), Debris (val), HttpService (val), TrackMasterVolume (val)
    if a1.IsDestroyed then
        return
    end
    local Sounds = a1.Sounds and a1.Sounds:FindFirstChild(a2.Name)
    if not Sounds then
        a1:destroy()
        return
    end
    local u21, u22 = u101:Acquire()
    a1.Janitor:Add(function() -- Line: 334 -- upvalues: u101 (upval), u21 (val), u22 (val)
        u101:Release(u21, u22)
    end)
    u21.Position = a2.Position
    u21.CollisionGroup = "Debris"
    u21.Parent = Debris
    local Janitor_2 = a1.Janitor
    local Children = Sounds:GetChildren()
    local u46 = Janitor_2:Add((Children[math.random(1, #Children)]:Clone()))
    local Volume = u46.Volume
    u46.Name = HttpService:GenerateGUID(false)
    u46.Parent = u21
    local v1 = true
    if a2.Name ~= "Headshot" then
        v1 = a2.Name == "Helmet Headshot"
    end
    if v1 and a5 then
        u46.RollOffMode = Enum.RollOffMode.InverseTapered
        u46.RollOffMaxDistance = 10000
        u46.RollOffMinDistance = 10000
        if a6 then
            Volume = Volume * 0
        end
    end
    TrackMasterVolume(u46, Volume, a4)
    u46:Play()
    if not u46.Looped or not a3 then
        a1.Janitor:Add((u46.Ended:Once(function() -- Line: 369 -- upvalues: a1 (val)
            a1:destroy()
        end)))
    else
        a1.Janitor:Add(task.delay(a3, function() -- Line: 363 -- upvalues: a1 (val)
            a1:destroy()
        end), true)
    end
    a1.Janitor:Add((u46.AncestryChanged:Connect(function() -- Line: 375 -- upvalues: u46 (val), a1 (val)
        if not u46.Parent then
            a1:destroy()
        end
    end)))
end

u0.GameplaySoundGroup = Gameplay

function u0.WarmPersistentSounds() -- Line: 389
    -- upvalues: u62 (ref), u106 (val), u107 (val), u105 (ref), SoundService (val), ContentProvider (val)
    local PersistentSounds, v1, v2, v3
    for i, j in u62:GetDescendants() do
        if j:IsA("Sound") and j:GetAttribute("Persistent") == true then
            v1 = u106[j]
            if not v1 or not v1:IsDescendantOf(game) then
                if v1 then
                    u107[v1] = nil
                end
                v2 = j:Clone()
                if not u105 or not u105.Parent then
                    PersistentSounds = SoundService:FindFirstChild("PersistentSounds")
                    if not PersistentSounds then
                        PersistentSounds = Instance.new("Folder")
                        PersistentSounds.Name = "PersistentSounds"
                        PersistentSounds.Parent = SoundService
                    end
                    u105 = PersistentSounds
                    v3 = PersistentSounds
                else
                    v3 = u105
                end
                v2.Parent = v3
                u106[j] = v2
                u61 = v2
            else
                local u61 = v1
            end
            local u66 = (u107[u61] or 0) + 1
            u107[u61] = u66
            pcall(function() -- Line: 397 -- upvalues: ContentProvider (upval), u61 (val)
                ContentProvider:PreloadAsync({u61})
            end)
            if u107[u61] == u66 and not u61.IsPlaying then
                u61.Volume = 0
                u61:Play()
                task.delay(0.5, function() -- Line: 407 -- upvalues: u107 (upval), u61 (val), u66 (val), j (val)
                    if u107[u61] == u66 then
                        u61:Stop()
                        u61.TimePosition = 0
                        u61.Volume = j.Volume
                    end
                end)
            end
        end
    end
end

function u0.createSoundGroup(a1) -- Line: 419
    -- upvalues: u62 (ref), u69 (val), Gameplay (ref), CreateSoundInstance (val)
    local v1, v2
    local v3 = require(a1)
    local v4 = Instance.new("Folder", u62)
    v4.Name = a1.Name
    local v5 = if not u69[a1.Name] then Gameplay else nil
    for k, v in pairs(v3) do
        if typeof(v) == "table" and typeof(v.Identifiers) == "table" then
            v2 = Instance.new("Folder", v4)
            v2.Name = k
            for i, i2 in ipairs(v.Identifiers) do
                v1 = CreateSoundInstance(i, i2, v.Properties)
                v1.SoundGroup = v5
                v1.Parent = v2
            end
        end
    end
end

function u0.new(a1) -- Line: 443 -- upvalues: u0 (val), Janitor (val), u62 (ref) -- types: a1: string
    local v1 = setmetatable({}, u0)
    v1.Janitor = Janitor.new()
    v1.IsDestroyed = false
    v1.SoundGroupName = a1
    v1.Sounds = u62:WaitForChild(a1, 10)
    return v1
end

function u0:destroy() -- Line: 455
    if self.IsDestroyed then
        return
    end
    self.IsDestroyed = true
    self.Janitor:Destroy()
    self.SoundGroupName = nil
    self.Janitor = nil
    self.Sounds = nil
end

return u0