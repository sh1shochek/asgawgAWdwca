-- ReplicatedStorage.Database.Custom.Finishers.LeSunshine
-- Script path: ReplicatedStorage.Database.Custom.Finishers.LeSunshine
-- Decompile time: 0.83 ms

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

local function Activate(a1, a2) -- Line: 31 -- upvalues: LocalPlayer (val), Finishers (val)
    local v1 = a1.Janitor:Add(script.FinisherGui:Clone(), "Destroy", "FinisherGui")
    v1.Parent = LocalPlayer.PlayerGui
    local v2 = Finishers:play({Name = "LeSunshine", Parent = LocalPlayer.PlayerGui})
    if not v2 then
        return
    end
    a1.Janitor:Add((v2.Ended:Once(function() -- Line: 44 -- upvalues: a1 (val)
        a1.Janitor:Remove("FinisherGui")
    end)))
end

return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 54 -- upvalues: Ragdoll (val), LocalPlayer (val), Activate (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        if (tostring(a2.Victim)) == tostring(LocalPlayer.UserId) then
            Activate(u6, a2)
        end
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 62 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}