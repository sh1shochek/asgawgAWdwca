-- ReplicatedStorage.Controllers.SoundController
-- Script path: ReplicatedStorage.Controllers.SoundController
-- Decompile time: 16.41 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Sound = require(ReplicatedStorage.Classes.Sound)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local MovementSounds = require(script.MovementSounds)
local CurrentCamera = Workspace.CurrentCamera
local u74 = {}
local u75 = {"Knife", "Bayonet", "Karambit", "Daggers"}
local u80 = {
    Headshot = 1,
    Humiliation = 2,
    MultiKill = 3,
    KillSpree = 4,
    Rampage = 5,
    Dominating = 6,
    ["Monster Kill"] = 7,
    LudicrusKill = 8,
    Unstoppable = 9,
    Godlike = 10,
}
local u91 = {
    [2] = "MultiKill",
    [3] = "KillSpree",
    [4] = "Rampage",
    [5] = "Dominating",
    [6] = "Monster Kill",
    [7] = "LudicrusKill",
    [8] = "Unstoppable",
    [9] = "Godlike",
}
local u100 = 0
local u101 = nil
local u102 = 0
local u103 = nil

local function isMenuOpen() -- Line: 97 -- upvalues: MenuState (val)
    return MenuState.GetCurrentScreen() ~= nil
end

local function isKnifeWeapon(a1) -- Line: 101 -- upvalues: u75 (val) -- types: a1: string
    for i, v in ipairs(u75) do
        if string.find(a1, v) then
            return true
        end
    end
    return false
end

local function getSliderMultiplier(a1) -- Line: 110
    -- upvalues: DataController (val), LocalPlayer (val)
    return (DataController.Get(LocalPlayer, a1) or 50) / 50
end

local function getMasterMultiplier() -- Line: 114 -- upvalues: DataController (val), LocalPlayer (val)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
end

local function storeBaseVolume(a1, a2) -- Line: 119
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
    local Volume = a1.Volume
    local v2 = a2 > 0 and v1 > 0 and Volume / (a2 * v1) or Volume
    a1:SetAttribute("BaseVolume", v2)
    return v2
end

local function listenWhileAlive(a1, a2, a3) -- Line: 130
    -- upvalues: DataController (val), LocalPlayer (val)
    local u8 = DataController.CreateListener(LocalPlayer, a2, a3)
    local u14 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", a3)
    a1.Destroying:Once(function() -- Line: 133 -- upvalues: DataController (upval), LocalPlayer (upval), a2 (val), u8 (val), u14 (val)
        DataController.RemoveListener(LocalPlayer, a2, u8)
        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", u14)
    end)
end

local function stopCurrentAccolade() -- Line: 139 -- upvalues: u101 (ref), u102 (ref)
    if u101 then
        local v1 = u101
        u101 = nil
        u102 = 0
        if v1.Parent then
            v1:Stop()
            v1:Destroy()
        end
    end
end

local function pickAccolade(a1) -- Line: 151 -- upvalues: u91 (val), u100 (ref), u80 (val), isKnifeWeapon (val)
    local v1 = u91[math.min(u100, 9)]
    local v2 = v1 and u80[v1] or 0
    if a1.Headshot and v2 < 1 then
        v1 = "Headshot"
        v2 = 1
    end
    if a1.Weapon and isKnifeWeapon(a1.Weapon) and v2 < 2 then
        v1 = "Humiliation"
        v2 = 2
    end
    return v1, v2
end

local function stopBombPlantedMusic() -- Line: 164 -- upvalues: u103 (ref)
    if u103 then
        if u103.Parent then
            u103:Stop()
            u103:Destroy()
        end
        u103 = nil
    end
end

local function updateBombPlantedMusicVolume(a1) -- Line: 174
    -- upvalues: u103 (ref), DataController (val), LocalPlayer (val)
    if u103 and u103.Parent then
        local v1 = (tonumber(a1) or 50) / 50
        local v2 = (tonumber((DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) or 100) / 100
        local Attribute = u103:GetAttribute("BaseVolume")
        local Volume = if typeof(Attribute) ~= "number" then u103.Volume else Attribute
        u103.Volume = Volume * v1 * v2
    end
end

local function GetRollOffDistance(a1, a2) -- Line: 188 -- types: a2: number
    return a1 and a1.Properties and a1.Properties.RollOffMaxDistance or a2
end

local function GetWeaponAudio(a1) -- Line: 192 -- upvalues: u74 (val), ReplicatedStorage (val) -- types: a1: string
    if u74[a1] then
        return u74[a1]
    end
    local v1 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(a1)
    if v1 then
        local success, result = pcall(require, v1)
        if success and result then
            u74[a1] = result
            return result
        end
    end
    return nil
end

v1.SetBombPlantedMusicVolume = updateBombPlantedMusicVolume

function v1.GetWeaponShootRange(a1, a2) -- Line: 214
    -- upvalues: u74 (val), ReplicatedStorage (val)
    local v1
    if not u74[a1] then
        local v2 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(a1)
        if not v2 then
            v1 = nil
        else
            local success, result = pcall(require, v2)
            if not success or not result then
                v1 = nil
            else
                u74[a1] = result
                v1 = result
            end
        end
    else
        v1 = u74[a1]
    end
    if not v1 then
        if a2 then
            return 50
        end
        return 120
    end
    if a2 and v1.Silencer then
        local Silencer = v1.Silencer
        return Silencer and Silencer.Properties and Silencer.Properties.RollOffMaxDistance or 50
    end
    local Shoot = v1.Shoot
    return Shoot and Shoot.Properties and Shoot.Properties.RollOffMaxDistance or 120
end

function v1.GetMeleeRange(a1) -- Line: 227 -- upvalues: u74 (val), ReplicatedStorage (val) -- types: a1: string
    local v1
    if not u74[a1] then
        local v2 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(a1)
        if not v2 then
            v1 = nil
        else
            local success, result = pcall(require, v2)
            if not success or not result then
                v1 = nil
            else
                u74[a1] = result
                v1 = result
            end
        end
    else
        v1 = u74[a1]
    end
    if not v1 then
        return 50
    end
    local HitOne = v1.HitOne
    return HitOne and HitOne.Properties and HitOne.Properties.RollOffMaxDistance or 50
end

function v1.Initialize() -- Line: 238
    -- upvalues: ReplicatedStorage (val), Sound (val), Router (val), MenuState (val), CurrentCamera (val)
    -- upvalues: DataController (val), LocalPlayer (val), RunServiceController (val), GameState (val), Remotes (val)
    -- upvalues: FlashEffect (val), DebugFlags (val), u103 (ref), CharacterResolver (val), listenWhileAlive (val)
    -- upvalues: updateBombPlantedMusicVolume (val), CollectionService (val), u100 (ref), u101 (ref), u102 (ref)
    -- upvalues: u91 (val), u80 (val), isKnifeWeapon (val)
    for i, v in ipairs(ReplicatedStorage.Database.Audio:GetDescendants()) do
        if v:IsA("ModuleScript") then
            Sound.createSoundGroup(v)
        end
    end
    task.spawn(Sound.WarmPersistentSounds)
    Router.observerRouter("RunRoundSound", function(a1) -- Line: 249 -- upvalues: MenuState (upval), Sound (upval), CurrentCamera (upval) -- types: a1: string
        if MenuState.GetCurrentScreen() ~= nil then
            return
        end
        return (Sound.new("Round")):playOneTime({Parent = CurrentCamera, Name = a1})
    end)
    Router.observerRouter("PlayCountdownTimer", function() -- Line: 260 -- upvalues: DataController (upval), LocalPlayer (upval), MenuState (upval), Sound (upval)
        local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Main Menu Volume") or 100) / 100
        if not (MenuState.GetCurrentScreen() ~= nil) and v1 > 0 then
            (Sound.new("Interface")):playOneTime({Name = "Countdown Timer", Parent = LocalPlayer.PlayerGui}, v1)
        end
        return nil
    end)
    local u31 = nil
    local u32 = nil
    local u33 = nil

    local function getBuyPhaseFadeMultiplier(a1) -- Line: 276 -- types: a1: number
        if a1 < 6 then
            return 1
        end
        return (math.max(0, 1 - (a1 - 6) * 0.2))
    end

    local function disconnectBuyPhaseFade() -- Line: 283 -- upvalues: u32 (ref)
        if u32 then
            u32:Disconnect()
            u32 = nil
        end
    end

    local function stopBuyPhaseSound() -- Line: 290 -- upvalues: u31 (ref), u32 (ref), u33 (ref)
        if u31 then
            if u32 then
                u32:Disconnect()
                u32 = nil
            end
            if u31.Parent then
                u31:Stop()
                u31:Destroy()
            end
            u31 = nil
            u33 = nil
        end
    end

    local function updateBuyPhaseVolume(a1) -- Line: 302
        -- upvalues: u31 (ref), DataController (upval), LocalPlayer (upval), u33 (ref), u32 (ref)
        if u31 and u31.Parent then
            local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50
            local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
            local Attribute = u31:GetAttribute("BaseVolume") or u31.Volume
            local v3 = 1
            if a1 and u33 then
                local v4 = tick() - u33
                v3 = if not (v4 < 6) then math.max(0, 1 - (v4 - 6) * 0.2) else 1
            end
            u31.Volume = Attribute * v1 * v2 * v3
            if a1 and u33 then
                local v5 = tick() - u33
                if (if not (v5 < 6) then math.max(0, 1 - (v5 - 6) * 0.2) else 1) <= 0 and u31 then
                    if u32 then
                        u32:Disconnect()
                        u32 = nil
                    end
                    if u31.Parent then
                        u31:Stop()
                        u31:Destroy()
                    end
                    u31 = nil
                    u33 = nil
                end
            end
            return
        end
    end

    local function playBuyPhaseSound() -- Line: 321
        -- upvalues: LocalPlayer (upval), u31 (ref), u32 (ref), u33 (ref), DataController (upval), Sound (upval)
        -- upvalues: CurrentCamera (upval), RunServiceController (upval), updateBuyPhaseVolume (val)
        local Attribute = LocalPlayer:GetAttribute("Team")
        if Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" then
            return
        end
        if u31 then
            if u32 then
                u32:Disconnect()
                u32 = nil
            end
            if u31.Parent then
                u31:Stop()
                u31:Destroy()
            end
            u31 = nil
            u33 = nil
        end
        local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50
        u31 = (Sound.new("Round")):play({Name = "Buy Phase", Parent = CurrentCamera}, v1)
        if not u31 then
            return
        end
        local u42 = u31
        u42.Destroying:Once(function() -- Line: 342 -- upvalues: u31 (upval), u42 (val), u33 (upval)
            if u31 == u42 then
                u31 = nil
                u33 = nil
            end
        end)
        local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        local Volume = u42.Volume
        u42:SetAttribute("BaseVolume", v1 > 0 and v2 > 0 and Volume / (v1 * v2) or Volume)
        u33 = tick()
        task.spawn(function() -- Line: 352
            -- upvalues: u32 (upval), RunServiceController (upval), u31 (upval), u33 (upval)
            -- upvalues: updateBuyPhaseVolume (upval)
            u32 = RunServiceController.BindToHeartbeat("SoundController.BuyPhaseFade", function() -- Line: 353 -- upvalues: u31 (upval), u32 (upval), u33 (upval), updateBuyPhaseVolume (upval)
                if u31 and u31.Parent then
                    if not u33 then
                        return
                    end
                    local v1 = tick() - u33
                    local v2 = v1 >= 6
                    updateBuyPhaseVolume(v2)
                    if v2 then
                        if not u31 then
                            if u32 then
                                u32:Disconnect()
                                u32 = nil
                            end
                        elseif u31.Parent then
                            if (if not (v1 < 6) then math.max(0, 1 - (v1 - 6) * 0.2) else 1) <= 0 and u32 then
                                u32:Disconnect()
                                u32 = nil
                            end
                        elseif u32 then
                            u32:Disconnect()
                            u32 = nil
                        end
                    end
                    return
                end
                if u32 then
                    u32:Disconnect()
                    u32 = nil
                end
            end)
        end)
    end

    GameState.ListenToState(function(a1, a2) -- Line: 377 -- upvalues: playBuyPhaseSound (val), u31 (ref), u32 (ref), u33 (ref)
        if a2 == "Buy Period" then
            playBuyPhaseSound()
            return
        end
        if u31 then
            if u32 then
                u32:Disconnect()
                u32 = nil
            end
            if u31.Parent then
                u31:Stop()
                u31:Destroy()
            end
            u31 = nil
            u33 = nil
        end
    end)

    local function onBuyPhaseSettingChanged() -- Line: 385 -- upvalues: updateBuyPhaseVolume (val), u32 (ref)
        updateBuyPhaseVolume(u32 ~= nil)
    end

    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round Start Volume", onBuyPhaseSettingChanged)
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", onBuyPhaseSettingChanged)
    Remotes.Sound.ReplicateSound.Listen(function(a1) -- Line: 391
        -- upvalues: FlashEffect (upval), DebugFlags (upval), u103 (upval), Sound (upval), CharacterResolver (upval)
        -- upvalues: LocalPlayer (upval), MenuState (upval), GameState (upval), DataController (upval)
        -- upvalues: listenWhileAlive (upval), updateBombPlantedMusicVolume (upval)
        local Volume, Volume_2, u269, u293, v1, v2, v3, v4, v5, v6, v7
        local v8 = FlashEffect.GetAudioFadeMultiplier()
        if DebugFlags.IsEnabled("WeaponFX") then
            v1 = a1 and a1.Name and tostring(a1.Name) or ""
            local v9 = a1 and a1.Class and tostring(a1.Class) or ""
            v2 = string.lower(v1)
            if string.find(v2, "shoot", 1, true) or string.find(v2, "fire", 1, true) then
                warn(("[WeaponFX][Client][Sound] recv class=%s name=%s flashed=%s parent=%s position=%s path=%s"):format(
                    v9,
                    v1,
                    tostring((FlashEffect.IsFlashed())),
                    tostring(a1 and a1.Parent),
                    tostring(a1 and a1.Position),
                    (tostring(a1 and a1.Path))
                ))
            end
        end
        v1 = false
        if a1.Name == "Bomb Planted Music" then
            v1 = a1.Class == "Counter-Terrorists"
        end
        if v1 and u103 then
            if u103.Parent then
                u103:Stop()
                u103:Destroy()
            end
            u103 = nil
        end
        if a1.Position then
            (Sound.new(a1.Class)):PlaySoundAtPosition({Position = a1.Position, Class = a1.Class, Name = a1.Name}, tonumber(a1.Duration), v8)
            return
        end
        if not a1.Parent and not a1.Path then
            return
        end
        local Parent_2 = a1.Parent
        if Parent_2 and Parent_2:IsA("BasePart") and Parent_2.Name == "Head" then
            local Parent_3 = Parent_2.Parent
            if Parent_3
                and Parent_3:IsA("Model")
                and Parent_3:IsDescendantOf(workspace)
                and (CharacterResolver.getPlayerFromCharacter(Parent_3)) == LocalPlayer then
                if DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][Sound] skipped local duplicate head sound name=%s class=%s"):format(
                        tostring(a1.Name),
                        (tostring(a1.Class))
                    ))
                end
                return
            end
        end
        if a1.Name ~= "Bomb Planted" and a1.Name ~= "Bomb Defused" and a1.Name ~= "Hostage Rescued" then
            if a1.Name == "Counter-Terrorists Win" then
                v2 = a1.Class == "Round"
            else
                v2 = false
                if a1.Name == "Terrorists Win" then
                    v2 = a1.Class == "Round"
                end
            end
            v3 = v8
            if v1 then
                if GameState.GetState() == "Round In Progress" then
                    v4 = MenuState.GetCurrentScreen() ~= nil
                    if not v4 then
                        v4 = Sound.new(a1.Class)
                        v6 = {Parent = a1.Parent, Name = a1.Name, Path = a1.Path}
                        u269 = v4:playOneTime(v6, v8 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50))
                        if not u269 then
                            return
                        end
                        if not v2 then
                            if v1 then
                                u103 = u269
                                v5 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50
                                v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                                Volume_2 = u269.Volume
                                u269:SetAttribute("BaseVolume", v5 > 0 and v6 > 0 and Volume_2 / (v5 * v6) or Volume_2)
                                listenWhileAlive(u269, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 501
                                    -- upvalues: u103 (upval), updateBombPlantedMusicVolume (upval)
                                    -- upvalues: DataController (upval), LocalPlayer (upval)
                                    if u103 and u103.Parent then
                                        updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50)
                                    end
                                end)
                            end
                            return
                        end
                        v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                        v7 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                        Volume = u269.Volume
                        if not (v6 > 0) or not (v7 > 0) then
                            u293 = Volume
                        else
                            u293 = Volume / (v6 * v7)
                            if not u293 then
                                u293 = Volume
                            end
                        end
                        u269:SetAttribute("BaseVolume", u293)
                        listenWhileAlive(u269, "Settings.Audio.Music.Round End Volume", function() -- Line: 490 -- upvalues: u269 (val), DataController (upval), LocalPlayer (upval), u293 (val)
                            if u269 and u269.Parent then
                                local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                                local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                                local Attribute = u269:GetAttribute("BaseVolume") or u293
                                u269.Volume = Attribute * v1 * v2
                            end
                        end)
                        return
                    end
                end
                return
            end
            if v2 then
                if MenuState.GetCurrentScreen() ~= nil then
                    return
                end
                v3 = v8 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50)
            end
            v4 = Sound.new(a1.Class)
            v6 = {Parent = a1.Parent, Name = a1.Name, Path = a1.Path}
            u269 = v4:playOneTime(v6, v3)
            if not u269 then
                return
            end
            if not v2 then
                if v1 then
                    u103 = u269
                    v5 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50
                    v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                    Volume_2 = u269.Volume
                    u269:SetAttribute("BaseVolume", v5 > 0 and v6 > 0 and Volume_2 / (v5 * v6) or Volume_2)
                    listenWhileAlive(u269, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 501
                        -- upvalues: u103 (upval), updateBombPlantedMusicVolume (upval), DataController (upval)
                        -- upvalues: LocalPlayer (upval)
                        if u103 and u103.Parent then
                            updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50)
                        end
                    end)
                end
                return
            end
            v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
            v7 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
            Volume = u269.Volume
            if not (v6 > 0) or not (v7 > 0) then
                u293 = Volume
            else
                u293 = Volume / (v6 * v7)
                if not u293 then
                    u293 = Volume
                end
            end
            u269:SetAttribute("BaseVolume", u293)
            listenWhileAlive(u269, "Settings.Audio.Music.Round End Volume", function() -- Line: 490 -- upvalues: u269 (val), DataController (upval), LocalPlayer (upval), u293 (val)
                if u269 and u269.Parent then
                    local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                    local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                    local Attribute = u269:GetAttribute("BaseVolume") or u293
                    u269.Volume = Attribute * v1 * v2
                end
            end)
            return
        end
        if MenuState.GetCurrentScreen() ~= nil then
            return
        end
        if a1.Name == "Counter-Terrorists Win" then
            v2 = a1.Class == "Round"
        else
            v2 = false
            if a1.Name == "Terrorists Win" then
                v2 = a1.Class == "Round"
            end
        end
        v3 = v8
        if v1 then
            if GameState.GetState() == "Round In Progress" then
                v4 = MenuState.GetCurrentScreen() ~= nil
                if not v4 then
                    v4 = Sound.new(a1.Class)
                    v6 = {Parent = a1.Parent, Name = a1.Name, Path = a1.Path}
                    u269 = v4:playOneTime(v6, v8 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50))
                    if not u269 then
                        return
                    end
                    if not v2 then
                        if v1 then
                            u103 = u269
                            v5 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50
                            v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                            Volume_2 = u269.Volume
                            u269:SetAttribute("BaseVolume", v5 > 0 and v6 > 0 and Volume_2 / (v5 * v6) or Volume_2)
                            listenWhileAlive(u269, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 501
                                -- upvalues: u103 (upval), updateBombPlantedMusicVolume (upval), DataController (upval)
                                -- upvalues: LocalPlayer (upval)
                                if u103 and u103.Parent then
                                    updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50)
                                end
                            end)
                        end
                        return
                    end
                    v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                    v7 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                    Volume = u269.Volume
                    if not (v6 > 0) or not (v7 > 0) then
                        u293 = Volume
                    else
                        u293 = Volume / (v6 * v7)
                        if not u293 then
                            u293 = Volume
                        end
                    end
                    u269:SetAttribute("BaseVolume", u293)
                    listenWhileAlive(u269, "Settings.Audio.Music.Round End Volume", function() -- Line: 490 -- upvalues: u269 (val), DataController (upval), LocalPlayer (upval), u293 (val)
                        if u269 and u269.Parent then
                            local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                            local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                            local Attribute = u269:GetAttribute("BaseVolume") or u293
                            u269.Volume = Attribute * v1 * v2
                        end
                    end)
                    return
                end
            end
            return
        end
        if v2 then
            if MenuState.GetCurrentScreen() ~= nil then
                return
            end
            v3 = v8 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50)
        end
        v4 = Sound.new(a1.Class)
        v6 = {Parent = a1.Parent, Name = a1.Name, Path = a1.Path}
        u269 = v4:playOneTime(v6, v3)
        if not u269 then
            return
        end
        if not v2 then
            if v1 then
                u103 = u269
                v5 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50
                v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                Volume_2 = u269.Volume
                u269:SetAttribute("BaseVolume", v5 > 0 and v6 > 0 and Volume_2 / (v5 * v6) or Volume_2)
                listenWhileAlive(u269, "Settings.Audio.Music.Bomb/Hostage Volume", function() -- Line: 501
                    -- upvalues: u103 (upval), updateBombPlantedMusicVolume (upval), DataController (upval)
                    -- upvalues: LocalPlayer (upval)
                    if u103 and u103.Parent then
                        updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50)
                    end
                end)
            end
            return
        end
        v6 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
        v7 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        Volume = u269.Volume
        if not (v6 > 0) or not (v7 > 0) then
            u293 = Volume
        else
            u293 = Volume / (v6 * v7)
            if not u293 then
                u293 = Volume
            end
        end
        u269:SetAttribute("BaseVolume", u293)
        listenWhileAlive(u269, "Settings.Audio.Music.Round End Volume", function() -- Line: 490 -- upvalues: u269 (val), DataController (upval), LocalPlayer (upval), u293 (val)
            if u269 and u269.Parent then
                local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                local Attribute = u269:GetAttribute("BaseVolume") or u293
                u269.Volume = Attribute * v1 * v2
            end
        end)
    end)

    local function setupBombDefuseListener() -- Line: 510 -- upvalues: CollectionService (upval), u103 (upval)
        local u5 = CollectionService:GetTagged("Bomb")[1]
        if u5 and u5:IsDescendantOf(workspace) then
            local u10 = nil
            local v1 = (u5:GetAttributeChangedSignal("Defused")):Connect(function() -- Line: 514 -- upvalues: u5 (val), u103 (upval), u10 (ref)
                if u5:GetAttribute("Defused") then
                    if u103 then
                        if u103.Parent then
                            u103:Stop()
                            u103:Destroy()
                        end
                        u103 = nil
                    end
                    if u10 then
                        u10:Disconnect()
                    end
                end
            end)
        end
    end

    ;(CollectionService:GetInstanceAddedSignal("Bomb")):Connect(function() -- Line: 525 -- upvalues: setupBombDefuseListener (val)
        setupBombDefuseListener()
    end)
    task.defer(setupBombDefuseListener)
    GameState.ListenToState(function(a1, a2) -- Line: 530 -- upvalues: u103 (upval)
        if a2 ~= "Round In Progress" and u103 then
            if u103.Parent then
                u103:Stop()
                u103:Destroy()
            end
            u103 = nil
        end
    end)
    Remotes.UI.UIPlayerKilled.Listen(function(a1) -- Line: 537
        -- upvalues: LocalPlayer (upval), u100 (upval), u101 (upval), u102 (upval), u91 (upval), u80 (upval)
        -- upvalues: isKnifeWeapon (upval), Sound (upval)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return
        end
        local v1 = tostring(LocalPlayer.UserId)
        if a1.Victim == v1 then
            u100 = 0
            if u101 then
                local v2 = u101
                u101 = nil
                u102 = 0
                if v2.Parent then
                    v2:Stop()
                    v2:Destroy()
                end
            end
            return
        end
        if a1.Killer ~= v1 then
            return
        end
        u100 = u100 + 1
        local v3 = u91[math.min(u100, 9)]
        local Headshot = v3 and u80[v3] or 0
        if a1.Headshot and Headshot < u80.Headshot then
            v3 = "Headshot"
            Headshot = u80.Headshot
        end
        if a1.Weapon and isKnifeWeapon(a1.Weapon) and Headshot < u80.Humiliation then
            v3 = "Humiliation"
            Headshot = u80.Humiliation
        end
        local u58 = v3
        local u60 = Headshot
        if u58 and not (u60 < u102) then
            if u101 then
                v3 = u101
                u101 = nil
                u102 = 0
                if v3.Parent then
                    v3:Stop()
                    v3:Destroy()
                end
            end
            task.delay(0.2, function() -- Line: 559
                -- upvalues: u60 (val), u102 (upval), u101 (upval), Sound (upval), LocalPlayer (upval), u58 (val)
                if u60 < u102 then
                    return
                end
                if u101 then
                    local v1 = u101
                    u101 = nil
                    u102 = 0
                    if v1.Parent then
                        v1:Stop()
                        v1:Destroy()
                    end
                end
                local u23 = (Sound.new("Deathmatch")):play({Parent = LocalPlayer.PlayerGui, Name = u58})
                if u23 then
                    u101 = u23
                    u102 = u60

                    local function clearIfCurrent() -- Line: 572 -- upvalues: u101 (upval), u23 (val), u102 (upval)
                        if u101 == u23 then
                            u101 = nil
                            u102 = 0
                        end
                    end

                    u23.Ended:Once(clearIfCurrent)
                    u23.Destroying:Once(clearIfCurrent)
                end
            end)
            return
        end
    end)
    Remotes.Sound.StopSoundAtPosition.Listen(function(a1) -- Line: 585
        local Debris = workspace:FindFirstChild("Debris")
        if not Debris then
            return
        end
        for i, v in ipairs(Debris:GetChildren()) do
            if v.Name == "Sound" and v:IsA("BasePart") and (v.Position - a1.Position).Magnitude <= a1.Radius then
                v:Destroy()
            end
        end
    end)
    Router.observerRouter("UpdatePlayerNoiseCone", function() -- Line: 603
        return nil
    end)
end

function v1.Start() -- Line: 610
    -- upvalues: MovementSounds (val), LocalPlayer (val), CharacterResolver (val), u100 (ref), u101 (ref), u102 (ref)
    -- upvalues: ReplicatedStorage (val), Sound (val), RunServiceController (val)
    local u3 = MovementSounds.new(LocalPlayer)
    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 612 -- upvalues: u100 (upval), u101 (upval), u102 (upval), u3 (val) -- types: a1: userdata?
        if a1 then
            u100 = 0
            if u101 then
                local v1 = u101
                u101 = nil
                u102 = 0
                if v1.Parent then
                    v1:Stop()
                    v1:Destroy()
                end
            end
        end
        u3:SetCharacter(a1)
        return function() -- Line: 618 -- upvalues: u3 (upval)
            u3:SetCharacter(nil)
        end
    end)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    local u14 = {}
    local v1 = {IsActive = MenuSceneController.IsTeamSelectSceneActive}
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    local InspectController = require(ReplicatedStorage.Controllers.InspectController)
    u14[1] = MenuSceneController
    u14[2] = v1
    u14[3] = CaseSceneController
    u14[4] = InspectController
    u14[5] = (require(ReplicatedStorage.Controllers.BlackMarketSceneController))
    local GameplaySoundGroup = Sound.GameplaySoundGroup
    local u35 = false

    local function isAnySceneActive() -- Line: 635 -- upvalues: u14 (val)
        for i, j in u14 do
            if j.IsActive() then
                return true
            end
        end
        return false
    end

    RunServiceController.BindToHeartbeat("SoundController.MovementSounds", function(a1) -- Line: 644 -- upvalues: u3 (val), u14 (val), u35 (ref), GameplaySoundGroup (val) -- types: a1: number
        local v1
        u3:Update(a1)
        for i, j in u14 do
            if j.IsActive() then
                v1 = true
                if v1 ~= u35 then
                    u35 = v1
                    GameplaySoundGroup.Volume = if not v1 then 1 else 0
                end
                return
            end
        end
        v1 = false
        if v1 ~= u35 then
            u35 = v1
            GameplaySoundGroup.Volume = if not v1 then 1 else 0
        end
    end)
end

return v1