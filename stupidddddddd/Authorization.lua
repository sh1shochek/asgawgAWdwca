-- ReplicatedStorage.Packages.DebugTools.Client.Authorization
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Authorization
-- Decompile time: 0.31 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Constants = require(script.Parent.Parent.Shared.Constants)
local v1 = {internal = {}, interface = {}}

function v1.interface.isLocalPlayerAuthorized() -- Line: 10
    -- upvalues: RunService (val), Players (val), Constants (val)
    if RunService:IsStudio() then
        return true
    end
    return Constants.GROUP_RANK <= (Players.LocalPlayer:GetRankInGroup(Constants.GROUP_ID))
end

return v1.interface