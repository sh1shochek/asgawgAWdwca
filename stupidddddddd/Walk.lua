-- ReplicatedStorage.Controllers.InputController.Actions.Walk
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Walk
-- Decompile time: 0.76 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local v1 = Enum.ContextActionPriority.High.Value + 1
;(LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting")):Connect(function() -- Line: 21 -- upvalues: LocalPlayer (val), CharacterController (val)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.walk(false)
    end
end)
return table.freeze({
    Name = "Walk",
    Group = "Default",
    Category = "Movement Keys",
    BindPriority = v1,
    Callback = function(a1, a2) -- Line: 30
        -- upvalues: LocalPlayer (val), CharacterResolver (val), DataController (val), CharacterController (val)
        if LocalPlayer:GetAttribute("IsPlayerChatting")
            or not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) then
            return
        end
        if DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Walk Mode") == "Toggle" then
            if a1 ~= Enum.UserInputState.Begin then
                return
            end
            CharacterController.walk(not (CharacterController.GetWalkState() or false))
            return
        end
        if a1 == Enum.UserInputState.Begin then
            CharacterController.walk(true)
            return
        end
        if a1 == Enum.UserInputState.End then
            CharacterController.walk(false)
        end
    end,
})