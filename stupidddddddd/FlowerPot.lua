-- ReplicatedStorage.Controllers.Observers.Game.Flower Pot
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Flower Pot
-- Decompile time: 1.10 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Debris_2 = workspace:WaitForChild("Debris")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Sound = require(ReplicatedStorage.Classes.Sound)

local function createDuplicateFlowerPot(a1) -- Line: 19 -- upvalues: Debris_2 (val) -- types: a1: userdata
    local v1
    local Pivot = a1:GetPivot()
    a1:SetAttribute("Broken", false)
    a1:RemoveTag("Flower Pot")
    a1:RemoveTag("Interactable")
    local v2 = a1:Clone()
    v2:PivotTo(Pivot)
    v2.Parent = Debris_2
    for i, v in ipairs(v2:GetChildren()) do
        if v:IsA("BasePart") then
            v1 = v.Name ~= "Unbroken"
            v.CanCollide = v1
            v1 = if v.Name ~= "Unbroken" then 0 else 1
            v.Transparency = v1
        end
    end
    return v2
end

local function createBreakPoints(a1) -- Line: 40 -- upvalues: Debris (val), Sound (val) -- types: a1: userdata
    local v1
    local Attribute = a1:GetAttribute("Direction")
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "Unbroken" then
            v.CollisionGroup = "Debris"
            v.Anchored = false
            v.Massless = true
        end
    end
    for i2, i3 in ipairs(a1:GetChildren()) do
        if i3:IsA("BasePart") then
            v1 = Attribute * (math.random(2, 3))
            i3:ApplyImpulse(v1)
        end
    end
    Debris:AddItem(a1, 5)
    ;(Sound.new("Bullet")):playOneTime({Name = "Break Flower Pot", Parent = a1.PrimaryPart})
end

return Observers.observeTag("Flower Pot", function(a1) -- Line: 65
    -- upvalues: Observers (val), createDuplicateFlowerPot (val), createBreakPoints (val)
    if not a1:IsDescendantOf(workspace) then
        return
    end
    return Observers.observeAttribute(a1, "Broken", function(a1_2) -- Line: 69 -- upvalues: createDuplicateFlowerPot (upval), a1 (val), createBreakPoints (upval)
        if a1_2 then
            local v1 = createDuplicateFlowerPot(a1)
            createBreakPoints(v1)
        end
    end)
end)