-- ReplicatedStorage.Controllers.InputController.Actions.Scoreboard
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Scoreboard
-- Decompile time: 0.35 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard)
return table.freeze({
    Name = "Scoreboard",
    Group = "Default",
    Category = "UI Keys",
    Callback = function(a1, a2) -- Line: 19 -- upvalues: LocalPlayer (val), Leaderboard (val) -- types: a2: userdata
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return
        end
        if a1 == Enum.UserInputState.Begin then
            Leaderboard.openFrame()
            return
        end
        if a1 == Enum.UserInputState.End then
            Leaderboard.closeFrame()
        end
    end,
})