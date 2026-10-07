-- ReplicatedStorage.Database.Custom.Finishers.Gold
-- Script path: ReplicatedStorage.Database.Custom.Finishers.Gold
-- Decompile time: 0.67 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Finishers = Sound.new("Finishers")

local function Activate(a1, a2) -- Line: 22 -- upvalues: Finishers (val)
    Finishers:play({Name = "Gold", Parent = a1.CharacterModel})
    if a1.CharacterModel:FindFirstChild("CharacterArmor") then
        a1.CharacterModel.CharacterArmor:Destroy()
    end
    for i, v in ipairs(a1.CharacterModel:GetDescendants()) do
        if v:IsA("Shirt") or v:IsA("Pants") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Color = Color3.fromRGB(255, 170, 0)
            v.Material = Enum.Material.Metal
        end
    end
end

return {
    Replication = "All",
    Finisher = function(a1, a2) -- Line: 45 -- upvalues: Ragdoll (val), Activate (val) -- types: a1: userdata
        local u6 = Ragdoll.new(a1, a2)
        u6:OnceAppearanceReady(function() -- Line: 48 -- upvalues: Activate (upval), u6 (val), a2 (val)
            Activate(u6, a2)
        end)
        return {
            OnDestroy = u6.OnDestroy,
            Destroy = function() -- Line: 53 -- upvalues: u6 (val)
                u6:Destroy()
            end,
        }
    end,
}