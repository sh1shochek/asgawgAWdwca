-- ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Animation
-- Script path: ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Animation
-- Decompile time: 9.43 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u57 = {"7", "73", "735", "7355", "73556", "735560", "7355608"}
local u65 = {}

local function preloadClips(a1) -- Line: 56
    -- upvalues: u65 (val), GetWeaponProperties (val), ContentProvider (val)
    if u65[a1] then
        return
    end
    u65[a1] = true
    local v1 = GetWeaponProperties(a1)
    local CameraAnimations = v1 and v1.CameraAnimations
    if typeof(CameraAnimations) ~= "Instance" then
        return
    end
    local v2 = {}
    for i, j in CameraAnimations:GetChildren() do
        if j:IsA("Animation") then
            table.insert(v2, j)
        end
    end
    task.spawn(ContentProvider.PreloadAsync, ContentProvider, v2)
end

local function isInspectVariantName(a1) -- Line: 78 -- types: a1: string
    local v1 = true
    if a1 ~= "Inspect" then
        v1 = string.match(a1, "^Inspect%d+$") ~= nil
    end
    return v1
end

local function getVariantBaseName(a1) -- Line: 83 -- types: a1: string
    local v1 = string.gsub(a1, "%d+$", "")
    if v1 == "" then
        return a1
    end
    return v1
end

local function shouldSkipDuplicateSoundEvent(a1, a2) -- Line: 91 -- types: a1: userdata, a2: string
    local v1 = tick()
    local Attribute = a1:GetAttribute("LastSoundEventName")
    local Attribute_2 = a1:GetAttribute("LastSoundEventTick")
    if Attribute == a2 and type(Attribute_2) == "number" then
        local v2 = v1 - Attribute_2
        if v2 >= 0 and v2 <= 0.02 then
            return true
        end
    end
    a1:SetAttribute("LastSoundEventName", a2)
    a1:SetAttribute("LastSoundEventTick", v1)
    return false
end

local function handleAnimationSoundEvent(a1, a2, a3, a4, a5, a6, a7) -- Line: 108
    -- upvalues: shouldSkipDuplicateSoundEvent (val), LocalPlayer (val), FlashEffect (val), PlayerGui (val)
    -- upvalues: Remotes (val)
    if a1.IsDestroyed then
        return
    end
    local v1 = a6 and a6:FindFirstChild(a4)
    if v1 then
        local v2 = #v1:GetChildren()
        if v2 > 0 and not shouldSkipDuplicateSoundEvent(a2, a4) then
            v2 = true
            if a3 ~= "Inspect" then
                v2 = string.match(a3, "^Inspect%d+$") ~= nil
            end
            if not v2 then
                local v3 = string.gsub(a3, "%d+$", "")
                v2 = (if v3 ~= "" then v3 else a3) == "Equip"
            end
            if a7 == LocalPlayer or v2 then
                local u68 = a5:play({Parent = PlayerGui, Name = a4}, (FlashEffect.GetAudioFadeMultiplier()))
                if u68 then
                    a1.ActiveSounds[u68] = a3
                    u68.Ended:Once(function() -- Line: 140 -- upvalues: a1 (val), u68 (val)
                        if not a1.IsDestroyed then
                            a1.ActiveSounds[u68] = nil
                        end
                    end)
                end
            end
            if not v2 and LocalPlayer == a7 then
                if a4 == "Prepare" and a5.SoundGroupName == "R8 Revolver" then
                    return
                end
                Remotes.Sound.ReplicateSound.Send({Class = a5.SoundGroupName, Name = a4})
                return
            end
            return
        end
    end
end

local function connectTrackSoundEvents(a1, a2, a3) -- Line: 166
    -- upvalues: handleAnimationSoundEvent (val)
    local Sound = a1.Sound
    local Sounds = Sound.Sounds
    local Player = a1.Player
    local u6 = {}
    local u10 = setmetatable({}, {__mode = "v"})
    u10.instance = a1
    table.insert(u6, (a2.KeyframeReached:Connect(function(a1) -- Line: 179
        -- upvalues: u10 (val), handleAnimationSoundEvent (upval), a2 (val), a3 (val), Sound (val), Sounds (val)
        -- upvalues: Player (val)
        local instance = u10.instance
        if not instance then
            return
        end
        handleAnimationSoundEvent(instance, a2, a3, a1, Sound, Sounds, Player)
    end)))
    if Sounds then
        for i, v in ipairs(Sounds:GetChildren()) do
            if v:IsA("Folder") then
                local Name = v.Name
                table.insert(u6, ((a2:GetMarkerReachedSignal(Name)):Connect(function() -- Line: 202
                    -- upvalues: Name (val), u10 (val), handleAnimationSoundEvent (upval), a2 (val), a3 (val)
                    -- upvalues: Sound (val), Sounds (val), Player (val)
                    local instance = u10.instance
                    if not instance then
                        return
                    end
                    handleAnimationSoundEvent(instance, a2, a3, Name, Sound, Sounds, Player)
                end)))
            end
        end
    end
    return function() -- Line: 209 -- upvalues: u6 (val)
        for i, v in ipairs(u6) do
            v:Disconnect()
        end
        table.clear(u6)
    end
end

function u0:getAnimation(a2) -- Line: 219 -- types: a2: string
    self:ensureLoaded()
    return self.Animations[a2]
end

function u0.hasInspectAnimation(a1) -- Line: 227
    a1:ensureLoaded()
    local Inspect = a1.VariantGroups.Inspect
    if Inspect and #Inspect > 0 then
        return true
    end
    return a1.Animations.Inspect ~= nil
end

local function computeVariantProbabilities(a1) -- Line: 239 -- types: a1: table
    local v1 = #a1
    local v2 = {}
    local v3 = 0
    local v4 = 0
    for i, v in ipairs(a1) do
        if v.weight ~= nil then
            v4 = v4 + math.max(v.weight, 0)
        else
            v3 = v3 + 1
        end
    end
    local v5 = math.max(0, 1 - v3 / v1)
    local v6 = v1 - v3
    for i2, i3 in ipairs(a1) do
        if i3.weight == nil then
            v2[i2] = 1 / v1
        elseif not (v4 > 0) then
            v2[i2] = v5 / v6
        else
            v2[i2] = v5 * (math.max(i3.weight, 0) / v4)
        end
    end
    return v2
end

local function rollVariant(a1, a2) -- Line: 271
    -- upvalues: computeVariantProbabilities (val)
    if a1 and #a1 ~= 0 then
        if #a1 == 1 then
            return a1[1].name
        end
        local v1 = computeVariantProbabilities(a1)
        local v2 = math.random()
        local v3 = 0
        for i, v in ipairs(a1) do
            v3 = v3 + v1[i]
            if v2 < v3 then
                return v.name
            end
        end
        return a1[#a1].name
    end
    return a2
end

function u0.pickVariant(a1, a2) -- Line: 297 -- upvalues: rollVariant (val) -- types: a2: string
    a1:ensureLoaded()
    return (rollVariant(a1.VariantGroups[a2], a2))
end

function u0.pickInspectVariant(a1) -- Line: 307 -- upvalues: rollVariant (val)
    a1:ensureLoaded()
    local v1 = os.clock()
    if a1.LastInspectVariant
        and a1.LastInspectCancelTime
        and v1 - a1.LastInspectCancelTime <= 1
        and a1.Animations[a1.LastInspectVariant] then
        return a1.LastInspectVariant
    end
    local v2 = rollVariant(a1.VariantGroups.Inspect, "Inspect")
    a1.LastInspectVariant = v2
    return v2
end

function u0.markInspectCancel(a1) -- Line: 328
    a1.LastInspectCancelTime = os.clock()
end

function u0.adjustAnimationSpeed(a1, a2, a3) -- Line: 334 -- types: a2: string, a3: number
    local v1 = a1:getAnimation(a2)
    if v1 then
        v1:AdjustSpeed(v1.Length / a3)
    end
end

function u0:play(a2, ...) -- Line: 343 -- types: a2: string
    local v1 = self:getAnimation(a2)
    if v1 then
        v1:Play(...)
    end
    return v1
end

function u0.stop(a1, a2, a3) -- Line: 353 -- types: a2: string, a3: number?
    local v1 = a1.Animations[a2]
    if v1 and v1.IsPlaying then
        v1:Stop(a3 or 0)
    end
end

local function hermiteEaseOut(a1) -- Line: 363 -- types: a1: number
    return a1 * 3 * a1 - a1 * 2 * a1 * a1
end

function u0:cancelCrossfade() -- Line: 369
    if self.CrossfadeConnection then
        self.CrossfadeConnection:Disconnect()
        self.CrossfadeConnection = nil
    end
    if self.CrossfadeTempTrack then
        self.CrossfadeTempTrack:Stop(0)
        self.CrossfadeTempTrack:Destroy()
        self.CrossfadeTempTrack = nil
    end
end

function u0.crossfadeRestart(a1, a2, a3) -- Line: 383
    -- upvalues: connectTrackSoundEvents (val), RunServiceController (val)
    local u3 = a3 or 0.25
    a1:cancelCrossfade()
    local VariantGroups = a1.VariantGroups
    local v1 = string.gsub(a2, "%d+$", "")
    local v2 = VariantGroups[if v1 ~= "" then v1 else a2]
    if v2 then
        local v3
        for i, v in ipairs(v2) do
            if v.name ~= a2 then
                v3 = a1.Animations[v.name]
                if v3 and v3.IsPlaying then
                    v3:Stop(0)
                end
            end
        end
    end
    local u48 = a1:getAnimation(a2)
    if not u48 then
        return nil
    end
    if not u48.IsPlaying then
        u48:Play(0, 1, 1)
        return u48
    end
    local u60 = math.max(u48.WeightCurrent, 0.5)
    local Animation = u48.Animation
    local v4 = false
    local u69 = nil
    if Animation then
        local success, result = pcall(function() -- Line: 418 -- upvalues: a1 (val), Animation (val)
            return a1.Animator:LoadAnimation(Animation)
        end)
        v4 = success
        u69 = result
    end
    if v4 and u69 then
        local u78 = connectTrackSoundEvents(a1, u69, a2)
        u69:Play(0, 0.01, 1)
        u69.TimePosition = 0
        a1.CrossfadeTempTrack = u69
        local u87 = tick()
        a1.CrossfadeConnection = RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade"), function() -- Line: 437 -- upvalues: a1 (val), u78 (val), u87 (val), u3 (val), u48 (val), u60 (val), u69 (ref)
            if a1.IsDestroyed then
                u78()
                a1:cancelCrossfade()
                return
            end
            local v1 = math.clamp((tick() - u87) / u3, 0, 1)
            local v2 = v1 * 3 * v1 - v1 * 2 * v1 * v1
            u48:AdjustWeight(u60 * (1 - v2), 0)
            u69:AdjustWeight(math.max(v2, 0.01), 0)
            if v1 >= 1 then
                u78()
                local TimePosition = u69.TimePosition
                u48:Stop(0)
                u48:Play(0, 1, 1)
                u48.TimePosition = TimePosition
                u48:AdjustWeight(1, 0)
                a1:cancelCrossfade()
            end
        end)
        return u48
    end
    u48:Stop(0)
    u48:Play(0, 1, 1)
    return u48
end

function u0.crossfadeTo(a1, a2, a3) -- Line: 470
    -- upvalues: RunServiceController (val)
    local u3 = a3 or 0.25
    a1:cancelCrossfade()
    local u7 = {}
    for k, v in pairs(a1.Animations) do
        if v.IsPlaying and k ~= "Idle" and k ~= a2 then
            table.insert(u7, {track = v, startWeight = v.WeightCurrent})
        end
    end
    local u25 = a1:getAnimation(a2)
    local u27 = a2 == "Idle"
    if not u25 and not u27 then
        return nil
    end
    if not u27 then
        u25:Play(0, 0, 1)
    end
    local u40 = tick()
    a1.CrossfadeConnection = RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade"), function() -- Line: 500 -- upvalues: a1 (val), u40 (val), u3 (val), u7 (val), u27 (val), u25 (val)
        if a1.IsDestroyed then
            a1:cancelCrossfade()
            return
        end
        local v1 = math.clamp((tick() - u40) / u3, 0, 1)
        local v2 = 1 - v1
        local v3 = v2 * 3 * v2 - v2 * 2 * v2 * v2
        for i, v in ipairs(u7) do
            v.track:AdjustWeight(v.startWeight * v3, 0)
        end
        if not u27 then
            u25:AdjustWeight(1 - v3, 0)
        end
        if v1 >= 1 then
            for i2, i3 in ipairs(u7) do
                if i3.track.IsPlaying then
                    i3.track:Stop(0)
                end
            end
            if not u27 then
                if u25 then
                    u25:AdjustWeight(1, 0)
                end
            elseif u25 then
                u25:Play(0, 1, 1)
            elseif u25 then
                u25:AdjustWeight(1, 0)
            end
            a1:cancelCrossfade()
        end
    end)
    return u25
end

function u0:stopAnimations(a2) -- Line: 537 -- types: a2: number?
    self:cancelCrossfade()
    for k, v in pairs(self.Animations) do
        if v.IsPlaying then
            v:Stop(a2 or 0)
        end
    end
    self:stopSounds()
end

function u0:stopSounds() -- Line: 550
    for k, v in pairs(self.ActiveSounds) do
        if not v or not (string.find(v, "Shoot") ~= nil) then
            v1.ActiveSounds[k] = nil
            if k and k.Parent then
                k:Destroy()
            end
        end
    end
end

function u0:unregister(a2) -- Line: 565 -- types: a2: string
    local v1 = self.Animations[a2]
    if not v1 then
        return
    end
    self.Janitor:Remove("AnimationSoundConnections_" .. a2)
    self.Janitor:RemoveNoClean("AnimationCleanup_" .. a2)
    self.Animations[a2] = nil
    if v1.IsPlaying then
        v1:Stop()
    end
    v1:Destroy()
end

function u0:register(a2, a3) -- Line: 583 -- upvalues: connectTrackSoundEvents (val) -- types: a2: string, a3: userdata
    self:unregister(a2)
    local success, result = pcall(function() -- Line: 585 -- upvalues: self (val), a3 (val)
        return self.Animator:LoadAnimation(a3)
    end)
    if success then
        self.Animations[a2] = result
        local u15 = setmetatable({}, {__mode = "v"})
        u15.instance = self
        local Janitor = self.Janitor
        local v1 = "AnimationCleanup_" .. a2
        Janitor:Add(function() -- Line: 593 -- upvalues: u15 (val), a2 (val)
            local instance = u15.instance
            if instance and not instance.IsDestroyed then
                instance:unregister(a2)
            end
        end, true, v1)
        self.Janitor:Add(connectTrackSoundEvents(self, result, a2), true, "AnimationSoundConnections_" .. a2)
    end
end

function u0:construct() -- Line: 605 -- upvalues: GetWeaponProperties (val)
    local v1 = GetWeaponProperties(self.Animation)
    if not v1 then
        return
    end
    local CameraAnimations = v1.CameraAnimations
    if typeof(CameraAnimations) == "Instance" and CameraAnimations:IsA("Folder") then
        local IntValue, Name_2, v2, v3
        self.VariantGroups = {}
        local v4 = self
        for i, v in ipairs(CameraAnimations:GetChildren()) do
            if v:IsA("Animation") then
                v4:register(v.Name, v)
                if v4.Animations[v.Name] then
                    Name_2 = v.Name
                    v2 = string.gsub(Name_2, "%d+$", "")
                    v3 = if v2 ~= "" then v2 else Name_2
                    IntValue = v:FindFirstChildWhichIsA("IntValue") or v:FindFirstChildWhichIsA("NumberValue")
                    v2 = v4.VariantGroups[v3]
                    if not v2 then
                        v4.VariantGroups[v3] = {}
                    end
                    table.insert(v2, {
                        name = v.Name,
                        weight = if not IntValue then nil else IntValue.Value,
                    })
                end
            end
        end
        return
    end
end

function u0.setModel(a1, a2) -- Line: 645 -- upvalues: preloadClips (val) -- types: a2: userdata
    if not a2 then
        return
    end
    a1.Animation = a2.Name
    a1.Model = a2
    a1.Animator = (a2:WaitForChild("AnimationController")):WaitForChild("Animator")
    a1:stopAnimations()
    for i in table.clone(a1.Animations) do
        a1:unregister(i)
    end
    a1.VariantGroups = {}
    a1.Loaded = false
    preloadClips(a2.Name)
    if a1.Animation == "C4" then
        local Weapon = a2:FindFirstChild("Weapon") and a2.Weapon:FindFirstChild("Interactive")
        if Weapon and Weapon:FindFirstChild("SurfaceGui") then
            Weapon.SurfaceGui.TextLabel.Text = "*******"
        end
    end
end

function u0:ensureLoaded() -- Line: 673 -- upvalues: ReplicatedFirst (val), u57 (val), LocalPlayer (val)
    local Model = self.Model
    if not self.Loaded and not self.IsDestroyed and Model and self.Animator then
        self.Loaded = true
        local v1 = not Model:IsDescendantOf(game)
        local Parent = Model.Parent
        if v1 then
            Model.Parent = ReplicatedFirst
        end
        self:construct()
        if v1 then
            Model.Parent = Parent
        end
        if self.Animation == "C4" then
            local Weapon = Model:FindFirstChild("Weapon")
            if Weapon then
                Weapon = Model.Weapon:FindFirstChild("Interactive")
            end
            for k, v in pairs(self.Animations) do
                self.Janitor:Add((v.KeyframeReached:Connect(function(a1) -- Line: 695 -- upvalues: u57 (upval), Weapon (val), self (val), LocalPlayer (upval)
                    if table.find(u57, a1) then
                        if Weapon and Weapon:FindFirstChild("SurfaceGui") then
                            Weapon.SurfaceGui.TextLabel.Text = (string.rep("*", 7 - #a1)) .. a1
                        end
                        self.Sound:play({Parent = LocalPlayer.PlayerGui, Name = a1})
                    end
                end)))
            end
        end
        return
    end
end

function u0.new(a1, a2) -- Line: 712 -- upvalues: u0 (val), Janitor (val) -- types: a1: userdata
    local v1 = setmetatable({}, u0)
    v1.Janitor = Janitor.new()
    v1.IsDestroyed = false
    v1.Player = a1
    v1.ActiveSounds = {}
    v1.Animations = {}
    v1.VariantGroups = {}
    v1.Sound = a2
    return v1
end

function u0.destroy(a1) -- Line: 739
    if not a1.IsDestroyed then
        a1.IsDestroyed = true
        a1:stopAnimations()
        for k in pairs(a1.Animations) do
            a1:unregister(k)
        end
        a1:stopSounds()
        table.clear(a1.ActiveSounds)
        table.clear(a1.Animations)
        table.clear(a1.VariantGroups)
        a1.Animation = nil
        a1.Animator = nil
        a1.Player = nil
        a1.Sound = nil
        a1.Janitor:Destroy()
        a1.Janitor = nil
    end
end

return u0