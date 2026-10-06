-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local script_Parent = script.Parent;
local CFrame2 = script_Parent.CFrame;
local CFrame_Angles = CFrame.Angles;
RunService.Heartbeat:Connect(function() -- Line: 11
    -- upvalues: script_Parent (copy), CFrame2 (copy), CFrame_Angles (copy)
    if not script_Parent:IsDescendantOf(workspace) then
        return;
    end;

    script_Parent.CFrame = CFrame2 * CFrame_Angles(0, 0, 0.17453292519943295 * time() % 6.283185307179586);
end);