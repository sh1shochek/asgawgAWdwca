-- ReplicatedStorage.Database.Custom.Finishers.Charred
-- Script path: ReplicatedStorage.Database.Custom.Finishers.Charred
-- Decompile time: 0.74 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local u17 = Instance.new("Fire", nil)
u17.Color = Color3.fromRGB(235, 135, 65)
u17.Heat = 12
u17.Size = 10

local function Activate(a1, a2) -- Line: 21 -- upvalues: u17 (val)
    local v1 = a1.Janitor:Add((u17:Clone()))
    v1.Parent = a1.CharacterModel.PrimaryPart
    if a1.CharacterModel:FindFirstChild("CharacterArmor") then
        a1.CharacterModel.CharacterArmor:Destroy()
    end
    for i, v in ipairs(a1.CharacterModel:GetDescendants()) do
        if v:IsA("Shirt") or v:IsA("Pants") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.CorrodedMetal
            v.Color = Color3.fromRGB(60, 30, 5)
        end
    end
end

return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 44 -- upvalues: Ragdoll (val), Activate (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        u6:OnceAppearanceReady(function() -- Line: 47 -- upvalues: Activate (upval), u6 (val), a2 (val)
            Activate(u6, a2)
        end)
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 52 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}