-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local LocalPlayer = Players.LocalPlayer;
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);

return table.freeze({
    Name = "Choose Team",
    Group = "Default",
    Category = "UI Keys",

    Callback = function(p1: any, p2: userdata) -- Line: 21, Name: onInput
        -- upvalues: LocalPlayer (copy), IsPlayingTeam (copy), TeamSelection (copy), CharacterResolver (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        local Attribute = LocalPlayer:GetAttribute("IsSpectating");

        if not IsPlayingTeam(LocalPlayer:GetAttribute("Team")) and Attribute ~= true then
            return;
        end;

        if Attribute then
            TeamSelection.openFrame();

            return;
        end;

        if CharacterResolver.getLocalCharacter() then
            TeamSelection.ToggleTeamSelection();
        end;
    end
});