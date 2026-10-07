-- ReplicatedStorage.Database.Custom.Finishers.Melted
-- Script path: ReplicatedStorage.Database.Custom.Finishers.Melted
-- Decompile time: 0.67 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Rig = require(ReplicatedStorage.Classes.Ragdoll.Rig)
local Goop = ReplicatedStorage.Assets.Finishers.Goop

local function Activate(a1, a2) -- Line: 18 -- upvalues: Rig (val), Goop (val)
    local LowerTorso = a1.CharacterModel:FindFirstChild("LowerTorso")
    if not LowerTorso then
        return
    end
    Rig.DisableJoint(a1.CharacterModel, "Waist")
    local UpperTorso = a1.CharacterModel:FindFirstChild("UpperTorso")
    if UpperTorso and UpperTorso:IsA("BasePart") then
        UpperTorso.AssemblyLinearVelocity = UpperTorso.AssemblyLinearVelocity + Vector3.new(math.random(-3, 3), math.random(0, 3), (math.random(-3, 3)))
    end
    local v1 = Goop:Clone()
    v1.Weld.Part1 = LowerTorso
    v1.Parent = a1.CharacterModel
end

return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 44 -- upvalues: Ragdoll (val), Activate (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        Activate(u6, a2)
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 49 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}