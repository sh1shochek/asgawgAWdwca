-- ReplicatedStorage.Controllers.InputController.Actions.TeamMessage
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.TeamMessage
-- Decompile time: 0.24 ms

local Players = game:GetService("Players")
local ActionTemplates = require(script.Parent.Parent.ActionTemplates)
local LocalPlayer = Players.LocalPlayer
return ActionTemplates.chat("Team Message", function() -- Line: 9 -- upvalues: LocalPlayer (val)
    local Attribute = LocalPlayer:GetAttribute("Team")
    if not Attribute or Attribute == "Spectators" then
        return 1
    end
    return 0
end)