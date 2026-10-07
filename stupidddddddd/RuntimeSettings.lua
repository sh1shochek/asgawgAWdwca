-- ReplicatedStorage.MovementV2.Simulation.RuntimeSettings
-- Script path: ReplicatedStorage.MovementV2.Simulation.RuntimeSettings
-- Decompile time: 0.33 ms

local Workspace = game:GetService("Workspace")
local Config = require(script.Parent.Config)
return table.freeze({
    getMovementConfig = function(a1) -- Line: 9 -- upvalues: Workspace (val), Config (val) -- types: a1: number?
        local Attribute = Workspace:GetAttribute("ServerGamemode")
        if Attribute == "Surf" then
            return Config.resolveServerGamemode(Attribute, a1)
        end
        local Attribute_2 = Workspace:GetAttribute("VIPCompetitiveMovementEnabled")
        if typeof(Attribute_2) == "boolean" then
            return Config.resolveServerGamemode(if not Attribute_2 then "Casual" else "Competitive", a1)
        end
        return Config.resolveServerGamemode(Attribute, a1)
    end,
})