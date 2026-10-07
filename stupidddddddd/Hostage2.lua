-- ReplicatedStorage.Controllers.Observers.Game.Hostage
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Hostage
-- Decompile time: 1.20 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Sound = require(ReplicatedStorage.Classes.Sound)
local u20 = Instance.new("Animation", nil)
u20.AnimationId = "rbxassetid://130065050998927"
u20.Name = "HOSTAGE_IDLE"
local u26 = Instance.new("Animation", nil)
u26.AnimationId = "rbxassetid://84183418979817"
u26.Name = "HOSTAGE_CARRYING"

local function updateAnimation(a1) -- Line: 26 -- upvalues: u26 (val), u20 (val) -- types: a1: userdata
    local Humanoid = a1:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return nil
    end
    local Animator = Humanoid:WaitForChild("Animator")
    local v1 = a1:GetAttribute("State") == "Carrying" and Animator:LoadAnimation(u26) or a1:GetAttribute("State") == "Idle" and Animator:LoadAnimation(u20) or nil
    if v1 then
        v1:Play()
    end
    return v1
end

return Observers.observeTag("Hostage", function(a1) -- Line: 44 -- upvalues: Janitor (val), Sound (val), updateAnimation (val)
    local HumanoidRootPart = a1:WaitForChild("HumanoidRootPart", 10)
    local Humanoid = a1:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        local v1 = tick()
        repeat
            task.wait(0.1)
        until (a1:FindFirstChildOfClass("Humanoid")) or 10 < tick() - v1
    end
    local v2 = a1:WaitForChild("Head", 10) or Humanoid or HumanoidRootPart
    if v2 and a1:IsDescendantOf(workspace) then
        local u46 = Janitor.new()
        local Hostage = Sound.new("Hostage")
        local u51 = nil
        Hostage:playOneTime({Name = "Hostage Idle", Parent = v2})
        u46:Add(((a1:GetAttributeChangedSignal("State")):Connect(function() -- Line: 69 -- upvalues: u51 (ref), updateAnimation (upval), a1 (val)
            if u51 then
                u51:Stop()
                u51 = nil
            end
            u51 = updateAnimation(a1)
        end)))
        local v3 = updateAnimation(a1)
        u46:Add(function() -- Line: 77 -- upvalues: Hostage (val)
            Hostage:destroy()
        end)
        return function() -- Line: 80 -- upvalues: u46 (val)
            u46:Destroy()
        end
    end
end)