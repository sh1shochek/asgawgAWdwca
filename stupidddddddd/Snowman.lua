-- ReplicatedStorage.Controllers.Observers.Game.Snowman
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Snowman
-- Decompile time: 0.99 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Schema = require(ReplicatedStorage.MovementV2.Collision.Schema)
local Debris_2 = workspace:WaitForChild("Debris")
local Observers = require(ReplicatedStorage.Packages.Observers)

local function createDuplicateSnowman(a1) -- Line: 17 -- upvalues: Schema (val), Debris_2 (val) -- types: a1: userdata
    local Destructible
    local Pivot = a1:GetPivot()
    local v1 = a1:Clone()
    v1:SetAttribute("Broken", false)
    v1:RemoveTag("Snowman")
    v1:RemoveTag("Interactable")
    for i, j in v1:GetDescendants() do
        Destructible = Schema.Tags.Destructible
        j:RemoveTag(Destructible)
    end
    v1:PivotTo(Pivot)
    for i2, v in ipairs(v1:GetChildren()) do
        if v.Name == "Head" then
            v.CanCollide = true
            v.Transparency = 0
        end
    end
    v1.Parent = Debris_2
    return v1
end

local function createBreakPoints(a1) -- Line: 40 -- upvalues: Debris (val) -- types: a1: userdata
    local v1
    local Attribute = a1:GetAttribute("Direction")
    for i, v in ipairs(a1:GetChildren()) do
        if v.Name == "Head" then
            v.CollisionGroup = "Debris"
            v.Anchored = false
            v.Massless = true
            if Attribute then
                v1 = (math.random(30, 40)) * Attribute
                v:ApplyImpulse(v1)
            end
        end
    end
    Debris:AddItem(a1, 10)
end

return Observers.observeTag("Snowman", function(a1) -- Line: 58
    -- upvalues: Observers (val), createDuplicateSnowman (val), createBreakPoints (val)
    if not a1:IsDescendantOf(workspace) then
        return
    end
    return Observers.observeAttribute(a1, "Broken", function(a1_2) -- Line: 62 -- upvalues: createDuplicateSnowman (upval), a1 (val), createBreakPoints (upval)
        if a1_2 then
            local v1 = createDuplicateSnowman(a1)
            createBreakPoints(v1)
        end
    end)
end)