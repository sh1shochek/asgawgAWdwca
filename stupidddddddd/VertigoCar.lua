-- ReplicatedStorage.Controllers.Observers.Game.VertigoCar
-- Script path: ReplicatedStorage.Controllers.Observers.Game.VertigoCar
-- Decompile time: 1.20 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)

local function CreateTween(a1, a2) -- Line: 16 -- upvalues: TweenService (val) -- types: a2: userdata
    if not a2:IsDescendantOf(workspace) then
        return
    end
    local PointA = a2:WaitForChild("PointA", 5)
    local PointB = a2:WaitForChild("PointB", 5)
    if PointA and PointB then
        if not a2:IsDescendantOf(workspace) then
            return
        end
        local WorldPosition = PointA.WorldPosition
        local WorldPosition_2 = PointB.WorldPosition
        local Magnitude = (WorldPosition_2 - WorldPosition).Magnitude
        if Magnitude <= 0 then
            return
        end
        local v1 = Magnitude / 42
        local v2 = TweenService:Create(a2, TweenInfo.new(v1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = WorldPosition_2})
        a1:Add(v2, "Cancel")
        while true do
            if not a2:IsDescendantOf(workspace) then
                break
            end
            a2.Position = WorldPosition
            v2:Play()
            v2.Completed:Wait()
        end
        return
    end
    warn((("[VertigoCar] Model \"%*\" is missing PointA or PointB attachments"):format(a2.Name)))
end

return Observers.observeTag("VertigoCar", function(a1) -- Line: 58
    -- upvalues: GraphicsQualityController (val), Janitor (val), CreateTween (val)
    a1.Anchored = true
    if not a1:IsDescendantOf(workspace) then
        return nil
    end
    local v1 = GraphicsQualityController.RunAnimatedProp(function() -- Line: 67 -- upvalues: Janitor (upval), a1 (val), CreateTween (upval)
        local u2 = Janitor.new()
        u2:Add(a1)
        u2:Add((task.spawn(function() -- Line: 70 -- upvalues: CreateTween (upval), u2 (val), a1 (upval)
            CreateTween(u2, a1)
        end)))
        return function() -- Line: 73 -- upvalues: u2 (val)
            u2:Destroy()
        end
    end)
    if not v1 then
        a1:Destroy()
    end
    return v1
end)