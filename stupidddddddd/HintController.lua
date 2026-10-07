-- ReplicatedStorage.Controllers.HintController
-- Script path: ReplicatedStorage.Controllers.HintController
-- Decompile time: 0.69 ms

local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Hints = ((ReplicatedStorage:WaitForChild("Assets")):WaitForChild("UI")):WaitForChild("Hints")
Hints:WaitForChild("Static")
Hints:WaitForChild("Ranged")
;(((Players.LocalPlayer:WaitForChild("PlayerGui")):WaitForChild("MainGui", (1 / 0))):WaitForChild("Gameplay")):WaitForChild("Middle")

function v1.createHint(a1, a2, a3, a4, a5, a6) end

function v1.clearHint(a1, a2) end

Remotes.Hints.BombSiteEntered.Listen(function() end)
Remotes.Hints.ClearHint.Listen(function() end)
return v1