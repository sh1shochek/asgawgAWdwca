-- ReplicatedStorage.Controllers.Observers.Game.IdleAnimations
-- Script path: ReplicatedStorage.Controllers.Observers.Game.IdleAnimations
-- Decompile time: 1.05 ms

local Ancestors, Tag, observeTag
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController)
local v1 = {
    {
        Tag = "Ceiling Fan",
        AnimationId = "rbxassetid://82806563298602",
        RequireWorkspace = true,
        AnimatorPath = {"AnimationController", "Animator"},
    },
    {
        Tag = "Flag",
        AnimationId = "rbxassetid://103823379066850",
        AnimationName = "FLAG_IDLE",
        AnimatorPath = {"csFlag", "AnimationController", "Animator"},
        Ancestors = {workspace},
    },
    {
        Tag = "VertigoCrane",
        AnimationId = "rbxassetid://75914758947993",
        AnimationName = "CRANE_IDLE",
        RequireWorkspace = true,
        AnimatorPath = {"AnimationController", "Animator"},
    },
    {
        Tag = "VertigoGenerator",
        AnimationId = "rbxassetid://106431666932790",
        AnimationName = "GENERATOR_IDLE",
        RequireWorkspace = true,
        AnimatorPath = {"AnimationController", "Animator"},
    },
}
local u52 = {}
local v2 = nil
local v3 = nil
for i, j in v1, v2, v3 do
    local Animation = Instance.new("Animation")
    Animation.AnimationId = j.AnimationId
    if j.AnimationName then
        Animation.Name = j.AnimationName
    end
    observeTag = Observers.observeTag
    Tag = j.Tag
    Ancestors = j.Ancestors
    table.insert(u52, (observeTag(Tag, function(a1) -- Line: 69 -- upvalues: j (val), GraphicsQualityController (val), Animation (val) -- types: a1: userdata
        local u31 = a1
        for i, j2 in j.AnimatorPath do
            u31 = u31:WaitForChild(j2)
        end
        if j.RequireWorkspace and not a1:IsDescendantOf(workspace) then
            return nil
        end
        return (GraphicsQualityController.RunAnimatedProp(function() -- Line: 79 -- upvalues: u31 (ref), Animation (upval)
            local u4 = u31:LoadAnimation(Animation)
            u4:Play()
            return function() -- Line: 82 -- upvalues: u4 (val)
                u4:Destroy()
            end
        end))
    end, Ancestors)))
end
return function() -- Line: 90 -- upvalues: u52 (val)
    for i, j in u52 do
        j()
    end
end