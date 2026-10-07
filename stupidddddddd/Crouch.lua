-- ReplicatedStorage.Controllers.InputController.Actions.Crouch
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Crouch
-- Decompile time: 0.52 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local v1 = Enum.ContextActionPriority.High.Value + 1
;(LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting")):Connect(function() -- Line: 19 -- upvalues: LocalPlayer (val), CharacterController (val)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.crouch(false)
    end
end)
return table.freeze({
    Name = "Crouch",
    Group = "Gameplay",
    Category = "Movement Keys",
    BindPriority = v1,
    Callback = function(a1, a2) -- Line: 28 -- upvalues: LocalPlayer (val), CharacterController (val) -- types: a2: userdata
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return
        end
        if a1 == Enum.UserInputState.Begin then
            CharacterController.crouch(true)
            return
        end
        if a1 == Enum.UserInputState.End then
            CharacterController.crouch(false)
        end
    end,
})