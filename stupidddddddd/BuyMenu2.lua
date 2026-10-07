-- ReplicatedStorage.Controllers.InputController.Actions.BuyMenu
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.BuyMenu
-- Decompile time: 0.40 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local LocalPlayer = Players.LocalPlayer
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu)
return table.freeze({
    Name = "Buy Menu",
    Group = "Gameplay",
    Category = "Weapon Keys",
    Callback = function(a1, a2) -- Line: 20
        -- upvalues: LocalPlayer (val), CharacterResolver (val), BuyMenu (val)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and a1 == Enum.UserInputState.Begin then
            if CharacterResolver.isAliveCharacter(CharacterResolver.getLocalCharacter()) then
                BuyMenu.toggleFrame()
            end
            return
        end
    end,
})