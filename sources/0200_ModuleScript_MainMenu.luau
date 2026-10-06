-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local IsPlayingTeam = require(ReplicatedStorage.Components.Common.IsPlayingTeam);
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local LocalPlayer = Players.LocalPlayer;
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);

return table.freeze({
    Name = "Main Menu",
    Group = "Default",
    Category = "UI Keys",

    Callback = function(p1: any, p2: userdata) -- Line: 26, Name: onInput
        -- upvalues: LocalPlayer (copy), CloseButtonRegistry (copy), IsTutorialMode (copy), IsPlayingTeam (copy), Top (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p2.KeyCode == Enum.KeyCode.ButtonB then
            if p1 ~= Enum.UserInputState.Begin then
                return;
            end;

            if CloseButtonRegistry.CloseFrame() or CloseButtonRegistry.IsDoublePressed() then
                return;
            end;
        end;

        if IsTutorialMode() then
            return;
        end;

        if (IsPlayingTeam(LocalPlayer:GetAttribute("Team")) or LocalPlayer:GetAttribute("IsSpectating") == true) and p1 == Enum.UserInputState.Begin then
            Top.ToggleMenu();
        end;
    end
});