-- ReplicatedStorage.Controllers.Observers.Game.Market Window
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Market Window
-- Decompile time: 2.15 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Schema = require(ReplicatedStorage.MovementV2.Collision.Schema)
local Debris_2 = workspace:WaitForChild("Debris")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Sound = require(ReplicatedStorage.Classes.Sound)

local function createDuplicateWindow(a1) -- Line: 20 -- upvalues: Schema (val), Debris_2 (val) -- types: a1: userdata
    local Destructible
    local Pivot = a1:GetPivot()
    local v1 = a1:Clone()
    v1:SetAttribute("Broken", false)
    v1:RemoveTag("Market Window")
    v1:RemoveTag("Interactable")
    for i, j in v1:GetDescendants() do
        Destructible = Schema.Tags.Destructible
        j:RemoveTag(Destructible)
    end
    v1:PivotTo(Pivot)
    for i2, v in ipairs(v1:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
            v.Transparency = 0
        end
    end
    v1.Parent = Debris_2
    return v1
end

local function createBreakPoints(a1) -- Line: 43 -- upvalues: Debris (val), Sound (val) -- types: a1: userdata
    local v1
    local Attribute = a1:GetAttribute("Direction")
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "Debris"
            v.Anchored = false
            v1 = Vector3.new(Attribute.X * math.random(7, 12), Attribute.Y * math.random(7, 12), Attribute.Z * (math.random(7, 12)))
            v:ApplyImpulse(v1)
        end
    end
    Debris:AddItem(a1, 5)
    ;(Sound.new("Bullet")):playOneTime({Name = "Break Market Window", Parent = a1.PrimaryPart})
end

return Observers.observeTag("Market Window", function(a1) -- Line: 68
    -- upvalues: Observers (val), createDuplicateWindow (val), createBreakPoints (val)
    if not a1:IsDescendantOf(workspace) then
        return
    end
    return Observers.observeAttribute(a1, "Broken", function(a1_2) -- Line: 72 -- upvalues: createDuplicateWindow (upval), a1 (val), createBreakPoints (upval)
        if a1_2 then
            local v1 = createDuplicateWindow(a1)
            createBreakPoints(v1)
        end
    end)
end)