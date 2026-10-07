-- ReplicatedStorage.Assets.MenuScenes.Hellena.Geometry.Model.Spinny.Rotate.Script
-- Script path: ReplicatedStorage.Assets.MenuScenes.Hellena.Geometry.Model.Spinny.Rotate.Script
-- Decompile time: 0.28 ms

local RunService = game:GetService("RunService")
local Parent = script.Parent
local CFrame_2 = Parent.CFrame
local Angles = CFrame.Angles
RunService.Heartbeat:Connect(function() -- Line: 11 -- upvalues: Parent (val), CFrame_2 (val), Angles (val)
    if not Parent:IsDescendantOf(workspace) then
        return
    end
    Parent.CFrame = CFrame_2 * Angles(0, 0, 0.17453292519943295 * time() % 6.283185307179586)
end)