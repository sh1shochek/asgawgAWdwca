-- ReplicatedStorage.Components.Common.GetPreferenceColor
-- Script path: ReplicatedStorage.Components.Common.GetPreferenceColor
-- Decompile time: 0.50 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local u28 = Colors["Team Color"]["Counter-Terrorists"]
return function() -- Line: 25 -- upvalues: DataController (val), LocalPlayer (val), Colors (val), u28 (val)
    local v1 = DataController.Get(LocalPlayer, "Settings.Game.HUD.Color")
    local Attribute = LocalPlayer:GetAttribute("Team")
    return Colors[v1] and Colors[v1][Attribute] or u28
end