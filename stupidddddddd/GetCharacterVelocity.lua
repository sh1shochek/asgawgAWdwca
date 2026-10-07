-- ReplicatedStorage.Components.Common.GetCharacterVelocity
-- Script path: ReplicatedStorage.Components.Common.GetCharacterVelocity
-- Decompile time: 0.38 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
return function(a1) -- Line: 7 -- upvalues: RuntimeKinematics (val) -- types: a1: userdata?
    return RuntimeKinematics.getVelocity(a1, a1 and a1:FindFirstChild("HumanoidRootPart"))
end