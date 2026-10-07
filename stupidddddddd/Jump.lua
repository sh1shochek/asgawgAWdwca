-- ReplicatedStorage.Controllers.InputController.Actions.Jump
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Jump
-- Decompile time: 0.53 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local LocalPlayer = Players.LocalPlayer
return table.freeze({
    Name = "Jump",
    Group = "Gameplay",
    Category = "Movement Keys",
    BindPriority = Enum.ContextActionPriority.High.Value + 1,
    Callback = function(a1, a2) -- Line: 21 -- upvalues: LocalPlayer (val), CharacterController (val) -- types: a2: userdata
        if a1 == Enum.UserInputState.Begin then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return
            end
            if a2.UserInputType == Enum.UserInputType.MouseWheel then
                CharacterController.jump()
                return
            end
            CharacterController.jump(true)
            return
        end
        if a1 ~= Enum.UserInputState.End and a1 ~= Enum.UserInputState.Cancel then
            return
        end
        if a2.UserInputType == Enum.UserInputType.MouseWheel then
            return
        end
        CharacterController.jump(false)
    end,
})