-- ReplicatedStorage.Controllers.InputController.Actions.SwitchViewmodelHand
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.SwitchViewmodelHand
-- Decompile time: 0.33 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand)
require(script.Parent.Parent.Types)
return table.freeze({
    Name = "Switch Viewmodel Left/Right Hand",
    Group = "Gameplay",
    Category = "Weapon Keys",
    Callback = function(a1) -- Line: 12 -- upvalues: Players (val), SpectateController (val), ViewmodelHand (val)
        if a1 ~= Enum.UserInputState.Begin then
            return
        end
        if not Players.LocalPlayer:GetAttribute("IsPlayerChatting") and not SpectateController.IsSpectatingNow() then
            ViewmodelHand.Toggle()
            return
        end
    end,
})