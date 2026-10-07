-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.RoundLost
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.RoundLost
-- Decompile time: 0.51 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local LocalPlayer = Players.LocalPlayer
local u29 = nil

function v1.Initialize(a1, a2) -- Line: 25 -- upvalues: u29 (ref), GameState (val), Remotes (val), LocalPlayer (val)
    u29 = a2
    GameState.ListenToState(function(a1, a2) -- Line: 29 -- upvalues: u29 (upval)
        if a1 ~= "Intermission" then
            if a2 == "Round In Progress" then
                u29.Visible = false
            end
        elseif a2 == "Buy Period" or a2 == "Round In Progress" then
            u29.Visible = false
        end
    end)
    Remotes.UI.RoundWinner.Listen(function(a1) -- Line: 36 -- upvalues: LocalPlayer (upval), u29 (upval)
        if LocalPlayer:GetAttribute("Team") ~= a1 then
            u29.Visible = true
        end
    end)
end

return v1