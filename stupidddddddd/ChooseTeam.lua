-- ReplicatedStorage.Controllers.InputController.Actions.ChooseTeam
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.ChooseTeam
-- Decompile time: 0.51 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam)
local LocalPlayer = Players.LocalPlayer
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection)
return table.freeze({
    Name = "Choose Team",
    Group = "Default",
    Category = "UI Keys",
    Callback = function(a1, a2) -- Line: 21
        -- upvalues: LocalPlayer (val), IsPlayingTeam (val), TeamSelection (val), CharacterResolver (val)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and a1 == Enum.UserInputState.Begin then
            local Attribute = LocalPlayer:GetAttribute("IsSpectating")
            if not IsPlayingTeam(LocalPlayer:GetAttribute("Team")) and Attribute ~= true then
                return
            end
            if Attribute then
                TeamSelection.openFrame()
                return
            end
            if CharacterResolver.getLocalCharacter() then
                TeamSelection.ToggleTeamSelection()
            end
            return
        end
    end,
})