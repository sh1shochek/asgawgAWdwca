-- ReplicatedStorage.Controllers.InputController.Actions.MainMenu
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.MainMenu
-- Decompile time: 0.76 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local LocalPlayer = Players.LocalPlayer
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
return table.freeze({
    Name = "Main Menu",
    Group = "Default",
    Category = "UI Keys",
    Callback = function(a1, a2) -- Line: 26
        -- upvalues: LocalPlayer (val), CloseButtonRegistry (val), IsTutorialMode (val), IsPlayingTeam (val), Top (val)
        local v1
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return
        end
        if a2.KeyCode ~= Enum.KeyCode.ButtonB then
            if IsTutorialMode() then
                return
            end
            v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team")) or LocalPlayer:GetAttribute("IsSpectating") == true
            if v1 and a1 == Enum.UserInputState.Begin then
                Top.ToggleMenu()
            end
            return
        end
        if a1 ~= Enum.UserInputState.Begin then
            return
        end
        if not CloseButtonRegistry.CloseFrame() and not CloseButtonRegistry.IsDoublePressed() then
            if IsTutorialMode() then
                return
            end
            v1 = IsPlayingTeam(LocalPlayer:GetAttribute("Team")) or LocalPlayer:GetAttribute("IsSpectating") == true
            if v1 and a1 == Enum.UserInputState.Begin then
                Top.ToggleMenu()
            end
            return
        end
    end,
})