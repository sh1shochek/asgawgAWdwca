-- ReplicatedStorage.Controllers.Observers.Game.Vent
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Vent
-- Decompile time: 1.15 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Debris_2 = workspace:WaitForChild("Debris")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Sound = require(ReplicatedStorage.Classes.Sound)

local function createDuplicateVent(a1) -- Line: 20 -- upvalues: Debris_2 (val) -- types: a1: userdata
    local Pivot = a1:GetPivot()
    local v1 = a1:Clone()
    v1:SetAttribute("Broken", false)
    v1:RemoveTag("Interactable")
    v1:RemoveTag("Vent")
    v1:PivotTo(Pivot)
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("BasePart") then
            if v.Name == "BreakPoint" then
                v.CanCollide = true
                v.CanQuery = false
                v.Transparency = 0
            else
                v:Destroy()
            end
        end
    end
    v1.Parent = Debris_2
    return v1
end

local function createBreakPoints(a1) -- Line: 47 -- upvalues: Debris (val), Sound (val) -- types: a1: userdata
    local v1
    local Position = a1:GetPivot().Position
    local Attribute = a1:GetAttribute("Direction")
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "Debris"
            v.Anchored = false
            v1 = Vector3.new(Attribute.X * math.random(15, 20), Attribute.Y * math.random(15, 20), Attribute.Z * (math.random(15, 20)))
            v:ApplyImpulse(v1)
        end
    end
    Debris:AddItem(a1, 5)
    ;(Sound.new("Bullet")):PlaySoundAtPosition({Name = "Break Metal Vent", Class = "Bullet", Position = Position})
end

return Observers.observeTag("Vent", function(a1) -- Line: 72
    -- upvalues: Observers (val), createDuplicateVent (val), createBreakPoints (val)
    if not a1:IsDescendantOf(workspace) then
        return
    end
    return Observers.observeAttribute(a1, "Broken", function(a1_2) -- Line: 76 -- upvalues: createDuplicateVent (upval), a1 (val), createBreakPoints (upval)
        if a1_2 then
            local v1 = createDuplicateVent(a1)
            createBreakPoints(v1)
        end
    end)
end)