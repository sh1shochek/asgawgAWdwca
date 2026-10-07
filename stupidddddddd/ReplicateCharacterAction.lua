-- ReplicatedStorage.Components.Common.ReplicateCharacterAction
-- Script path: ReplicatedStorage.Components.Common.ReplicateCharacterAction
-- Decompile time: 0.42 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local LocalPlayer = Players.LocalPlayer
return function(a1) -- Line: 15
    -- upvalues: CharacterActions (val), CharacterGeneration (val), LocalPlayer (val), Remotes (val)
    local v1 = CharacterActions.ToId(a1)
    if not v1 then
        return
    end
    local v2 = CharacterGeneration.Get(LocalPlayer.Character)
    if v2 == nil then
        return
    end
    Remotes.Character.Action.Send({UserId = 0, Generation = v2, ActionId = v1})
end