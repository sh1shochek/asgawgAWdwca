-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.RoundWon
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.RoundWon
-- Decompile time: 4.09 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Participants = require(ReplicatedStorage.Components.Common.Participants)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local u48 = {}
local u49 = false
local u50 = nil
local v1 = {}

local function formatMVPReason(a1) -- Line: 67 -- types: a1: string?
    if a1 and a1 ~= "Unknown" then
        return (("MVP | %*"):format(a1))
    end
    return "MVP"
end

local function arePlayersAliveOnBothTeams() -- Line: 75 -- upvalues: Players (val), CharacterResolver (val)
    local Attribute
    local v1 = 0
    local v2 = 0
    for i, v in ipairs(Players:GetPlayers()) do
        Attribute = v:GetAttribute("Team")
        if Attribute == "Counter-Terrorists" then
            if v:GetAttribute("IsSpectating") ~= true and CharacterResolver.isAlivePlayer(v) then
                if Attribute ~= "Counter-Terrorists" then
                    v2 = v2 + 1
                else
                    v1 = v1 + 1
                end
            end
        elseif Attribute == "Terrorists"
            and v:GetAttribute("IsSpectating") ~= true
            and CharacterResolver.isAlivePlayer(v) then
            if Attribute ~= "Counter-Terrorists" then
                v2 = v2 + 1
            else
                v1 = v1 + 1
            end
        end
    end
    local v3 = false
    if v1 > 0 then
        v3 = v2 > 0
    end
    return v3
end

local function stopMVPMusic() -- Line: 97 -- upvalues: LocalPlayer (val), u50 (ref)
    local MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP")
    if MVP and MVP:IsA("Sound") then
        MVP:Stop()
        MVP:Destroy()
    end
    u50 = nil
end

local function getMVPVolumeMultiplier() -- Line: 107 -- upvalues: DataController (val), LocalPlayer (val)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50
end

local function getMasterVolumeMultiplier() -- Line: 112 -- upvalues: DataController (val), LocalPlayer (val)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
end

local function updateMVPMusicVolume() -- Line: 117 -- upvalues: u50 (ref), DataController (val), LocalPlayer (val)
    if u50 and u50.Parent then
        local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50
        local v2 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        local Attribute = u50:GetAttribute("BaseVolume") or u50.Volume
        u50.Volume = Attribute * v1 * v2
        return
    end
end

local function playMVPMusic() -- Line: 128
    -- upvalues: MenuState (val), LocalPlayer (val), DataController (val), arePlayersAliveOnBothTeams (val), u50 (ref)
    -- upvalues: Sound (val)
    if MenuState.GetCurrentScreen() ~= nil then
        return
    end
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local MVP = PlayerGui:FindFirstChild("MVP")
    if MVP and MVP:IsA("Sound") and MVP.IsPlaying then
        return
    end
    if DataController.Get(LocalPlayer, "Settings.Audio.Other.Mute MVP Music when players on both teams are alive") == true
        and arePlayersAliveOnBothTeams() then
        return
    end
    local v1 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50
    local v2 = {Name = "MVP", Parent = PlayerGui}
    u50 = (Sound.new("Round")):play(v2, v1)
    if u50 then
        local v3 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        local Volume = u50.Volume
        v2 = v1 > 0 and v3 > 0 and Volume / (v1 * v3) or Volume
        u50:SetAttribute("BaseVolume", v2)
        u50.Destroying:Once(function() -- Line: 163 -- upvalues: u50 (upval)
            u50 = nil
        end)
    end
end

local function hideAllRoundWonAndMVPFrames() -- Line: 169 -- upvalues: u48 (val)
    local v1 = nil
    local v2 = nil
    for i, j in u48, v1, v2 do
        j.roundWonFrame.Visible = false
        if j.playerMVPCTFrame then
            j.playerMVPCTFrame.Visible = false
        end
        if j.playerMVPTFrame then
            j.playerMVPTFrame.Visible = false
        end
    end
end

local function updateMVPFrame(a1, a2, a3) -- Line: 181
    -- upvalues: Participants (val)
    local MVP = a1:FindFirstChild("MVP")
    local Text = MVP and MVP:FindFirstChild("Text")
    if Text then
        Text.Text = a2
    end
    local Name = a1:FindFirstChild("Name")
    if Name then
        Name.Text = a3
    end
    local Player = a1:FindFirstChild("Player")
    local Player_2 = Player and Player:FindFirstChild("Player")
    local v1 = Player_2 and Participants.FromName(a3)
    if Player_2 and v1 then
        Player_2.Image = Participants.HeadshotImage(v1, 420)
    end
end

local function onRoundWinner(a1) -- Line: 201 -- upvalues: LocalPlayer (val), u48 (val)
    local roundWonFrame, v1
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v2 = nil
    local v3 = nil
    local v4 = a1
    for i, j in u48, v2, v3 do
        roundWonFrame = j.roundWonFrame
        v1 = false
        if v4 == j.winningTeam then
            v1 = Attribute == v4
        end
        roundWonFrame.Visible = v1
    end
end

local function onRoundMVP(a1) -- Line: 208
    -- upvalues: Participants (val), u48 (val), updateMVPFrame (val), playMVPMusic (val)
    if a1 and a1.Team and a1.PlayerName and a1.Reason then
        local playerMVPCTFrame, playerMVPTFrame
        local Team = a1.Team
        local PlayerName = a1.PlayerName
        local Reason = a1.Reason
        if Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
            return
        end
        if not Participants.FromName(PlayerName) then
            return
        end
        local v1 = if not Reason then "MVP" else if Reason ~= "Unknown" then ("MVP | %*"):format(Reason) else "MVP"
        local v2 = Team == "Counter-Terrorists"
        local v3 = nil
        local v4 = nil
        for i, j in u48, v3, v4 do
            playerMVPCTFrame = if not v2 then j.playerMVPTFrame else j.playerMVPCTFrame
            playerMVPTFrame = if not v2 then j.playerMVPCTFrame else j.playerMVPTFrame
            if playerMVPCTFrame then
                updateMVPFrame(playerMVPCTFrame, v1, PlayerName)
                playerMVPCTFrame.Visible = true
                if playerMVPTFrame then
                    playerMVPTFrame.Visible = false
                end
                playMVPMusic()
            end
        end
        return
    end
end

local function ensureListenersInitialized() -- Line: 248
    -- upvalues: u49 (ref), DataController (val), LocalPlayer (val), updateMVPMusicVolume (val), GameState (val)
    -- upvalues: hideAllRoundWonAndMVPFrames (val), u50 (ref), Remotes (val), onRoundWinner (val), onRoundMVP (val)
    if u49 then
        return
    end
    u49 = true
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMVPMusicVolume)
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.MVP Volume", updateMVPMusicVolume)
    GameState.ListenToState(function(a1, a2) -- Line: 257 -- upvalues: hideAllRoundWonAndMVPFrames (upval), LocalPlayer (upval), u50 (upval)
        local MVP
        if a1 ~= "Intermission" then
            if a2 == "Round In Progress" then
                hideAllRoundWonAndMVPFrames()
                MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP")
                if MVP and MVP:IsA("Sound") then
                    MVP:Stop()
                    MVP:Destroy()
                end
                u50 = nil
            end
        elseif a2 == "Buy Period" or a2 == "Round In Progress" then
            hideAllRoundWonAndMVPFrames()
            MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP")
            if MVP and MVP:IsA("Sound") then
                MVP:Stop()
                MVP:Destroy()
            end
            u50 = nil
        end
    end)
    Remotes.UI.RoundWinner.Listen(onRoundWinner)
    Remotes.UI.RoundMVP.Listen(onRoundMVP)
end

function v1.create(a1) -- Line: 271 -- upvalues: u48 (val), ensureListenersInitialized (val) -- types: a1: string
    return {
        Initialize = function(a1_2, a2) -- Line: 274
            -- upvalues: u48 (upval), a1 (val), ensureListenersInitialized (upval)
            u48[a1] = {
                winningTeam = a1,
                roundWonFrame = a2,
                playerMVPCTFrame = a1_2.Gameplay.Middle:FindFirstChild("PlayerMVPCT"),
                playerMVPTFrame = a1_2.Gameplay.Middle:FindFirstChild("PlayerMVPT"),
            }
            ensureListenersInitialized()
        end,
    }
end

return v1