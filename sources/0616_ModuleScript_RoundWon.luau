-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = false;
local u3 = nil;
local v4 = {};

local function formatMVPReason(p5: string?) -- Line: 67
    return (not p5 or p5 == "Unknown") and "MVP" or `MVP | {p5}`;
end;

local function arePlayersAliveOnBothTeams() -- Line: 75
    -- upvalues: Players (copy), CharacterResolver (copy)
    local v6 = 0;
    local v7 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        local Attribute = v:GetAttribute("Team");

        if not (Attribute ~= "Counter-Terrorists" and Attribute ~= "Terrorists" or (v:GetAttribute("IsSpectating") == true or not CharacterResolver.isAlivePlayer(v))) then
            if Attribute == "Counter-Terrorists" then
                v7 = v7 + 1;
            else
                v6 = v6 + 1;
            end;
        end;
    end;

    local v8;

    if v7 > 0 then
        v8 = v6 > 0;
    else
        v8 = false;
    end;

    return v8;
end;

local function stopMVPMusic() -- Line: 97
    -- upvalues: LocalPlayer (copy), u3 (ref)
    local MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP");

    if MVP and MVP:IsA("Sound") then
        MVP:Stop();
        MVP:Destroy();
    end;

    u3 = nil;
end;

local function getMVPVolumeMultiplier() -- Line: 107
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50;
end;

local function getMasterVolumeMultiplier() -- Line: 112
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
end;

local function updateMVPMusicVolume() -- Line: 117
    -- upvalues: u3 (ref), DataController (copy), LocalPlayer (copy)
    if not (u3 and u3.Parent) then
        return;
    end;

    local v9 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50;
    local v10 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    u3.Volume = (u3:GetAttribute("BaseVolume") or u3.Volume) * v9 * v10;
end;

local function playMVPMusic() -- Line: 128
    -- upvalues: MenuState (copy), LocalPlayer (copy), DataController (copy), arePlayersAliveOnBothTeams (copy), u3 (ref), Sound (copy)
    if MenuState.GetCurrentScreen() ~= nil then
        return;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local MVP = PlayerGui:FindFirstChild("MVP");

    if MVP and (MVP:IsA("Sound") and MVP.IsPlaying) then
        return;
    end;

    if DataController.Get(LocalPlayer, "Settings.Audio.Other.Mute MVP Music when players on both teams are alive") == true and arePlayersAliveOnBothTeams() then
        return;
    end;

    local v11 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.MVP Volume") or 50) / 50;
    u3 = Sound.new("Round"):play({
        Name = "MVP",
        Parent = PlayerGui
    }, v11);

    if u3 then
        local v12 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local Volume = u3.Volume;

        if v11 > 0 and v12 > 0 then
            Volume = Volume / (v11 * v12) or Volume;
        end;

        u3:SetAttribute("BaseVolume", Volume);
        u3.Destroying:Once(function() -- Line: 163
            -- upvalues: u3 (ref)
            u3 = nil;
        end);
    end;
end;

local function hideAllRoundWonAndMVPFrames() -- Line: 169
    -- upvalues: u1 (copy)
    for _, v in u1 do
        v.roundWonFrame.Visible = false;

        if v.playerMVPCTFrame then
            v.playerMVPCTFrame.Visible = false;
        end;

        if v.playerMVPTFrame then
            v.playerMVPTFrame.Visible = false;
        end;
    end;
end;

local function updateMVPFrame(p13: userdata, p14: string, p15: string) -- Line: 181
    -- upvalues: Participants (copy)
    local MVP = p13:FindFirstChild("MVP");

    if MVP then
        MVP = MVP:FindFirstChild("Text");
    end;

    if MVP then
        MVP.Text = p14;
    end;

    local Name = p13:FindFirstChild("Name");

    if Name then
        Name.Text = p15;
    end;

    local Player = p13:FindFirstChild("Player");

    if Player then
        Player = Player:FindFirstChild("Player");
    end;

    local v16;

    if Player then
        v16 = Participants.FromName(p15);
    else
        v16 = Player;
    end;

    if Player and v16 then
        Player.Image = Participants.HeadshotImage(v16, 420);
    end;
end;

local function onRoundWinner(p17) -- Line: 201
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    for _, v in u1 do
        local v18;

        if p17 == v.winningTeam then
            v18 = Attribute == p17;
        else
            v18 = false;
        end;

        v.roundWonFrame.Visible = v18;
    end;
end;

local function onRoundMVP(p19) -- Line: 208
    -- upvalues: Participants (copy), u1 (copy), updateMVPFrame (copy), playMVPMusic (copy)
    if not (p19 and (p19.Team and (p19.PlayerName and p19.Reason))) then
        return;
    end;

    local Team = p19.Team;
    local PlayerName = p19.PlayerName;
    local Reason = p19.Reason;

    if Team ~= "Counter-Terrorists" and Team ~= "Terrorists" then
        return;
    end;

    if not Participants.FromName(PlayerName) then
        return;
    end;

    local v20 = (not Reason or Reason == "Unknown") and "MVP" or `MVP | {Reason}`;
    local v21 = Team == "Counter-Terrorists";

    for _, v in u1 do
        local v22;

        if v21 then
            v22 = v.playerMVPCTFrame;
        else
            v22 = v.playerMVPTFrame;
        end;

        local v23;

        if v21 then
            v23 = v.playerMVPTFrame;
        else
            v23 = v.playerMVPCTFrame;
        end;

        if v22 then
            updateMVPFrame(v22, v20, PlayerName);
            v22.Visible = true;

            if v23 then
                v23.Visible = false;
            end;

            playMVPMusic();
        end;
    end;
end;

local function ensureListenersInitialized() -- Line: 248
    -- upvalues: u2 (ref), DataController (copy), LocalPlayer (copy), updateMVPMusicVolume (copy), GameState (copy), hideAllRoundWonAndMVPFrames (copy), u3 (ref), Remotes (copy), onRoundWinner (copy), onRoundMVP (copy)
    if u2 then
        return;
    end;

    u2 = true;
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMVPMusicVolume);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.MVP Volume", updateMVPMusicVolume);
    GameState.ListenToState(function(p24, p25) -- Line: 257
        -- upvalues: hideAllRoundWonAndMVPFrames (ref), LocalPlayer (ref), u3 (ref)
        if p24 == "Intermission" and p25 == "Buy Period" or p25 == "Round In Progress" then
            hideAllRoundWonAndMVPFrames();
            local MVP = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MVP");

            if MVP and MVP:IsA("Sound") then
                MVP:Stop();
                MVP:Destroy();
            end;

            u3 = nil;
        end;
    end);
    Remotes.UI.RoundWinner.Listen(onRoundWinner);
    Remotes.UI.RoundMVP.Listen(onRoundMVP);
end;

function v4.create(u26: string) -- Line: 271
    -- upvalues: u1 (copy), ensureListenersInitialized (copy)
    return {
        Initialize = function(p27: any, p28: userdata) -- Line: 274, Name: Initialize
            -- upvalues: u1 (ref), u26 (copy), ensureListenersInitialized (ref)
            u1[u26] = {
                winningTeam = u26,
                roundWonFrame = p28,
                playerMVPCTFrame = p27.Gameplay.Middle:FindFirstChild("PlayerMVPCT"),
                playerMVPTFrame = p27.Gameplay.Middle:FindFirstChild("PlayerMVPT")
            };
            ensureListenersInitialized();
        end
    };
end;

return v4;