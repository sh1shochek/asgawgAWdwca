-- ReplicatedStorage.Database.Custom.Finishers.Fling
-- Script path: ReplicatedStorage.Database.Custom.Finishers.Fling
-- Decompile time: 0.89 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local LocalPlayer = Players.LocalPlayer
local Sound = require(ReplicatedStorage.Classes.Sound)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Finishers = Sound.new("Finishers")

local function IsLocalPlayer(a1) -- Line: 25 -- upvalues: LocalPlayer (val)
    return (tostring(a1)) == tostring(LocalPlayer.UserId)
end

return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 35 -- upvalues: Ragdoll (val), LocalPlayer (val), Finishers (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        if (tostring(a2.Victim)) == tostring(LocalPlayer.UserId) then
            Finishers:play({Name = "Fling", Parent = LocalPlayer.PlayerGui})
        end
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 43 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}