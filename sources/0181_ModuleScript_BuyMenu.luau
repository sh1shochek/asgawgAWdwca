-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local LocalPlayer = Players.LocalPlayer;
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);

return table.freeze({
    Name = "Buy Menu",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1: any, p2: userdata) -- Line: 20, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterResolver (copy), BuyMenu (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
            BuyMenu.toggleFrame();
        end;
    end
});