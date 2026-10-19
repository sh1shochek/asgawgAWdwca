-- FarThrottle (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.FarThrottle

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 27
    -- upvalues: u1 (copy)
    return setmetatable({
        Frame = 0,
        CameraPosition = nil
    }, u1);
end;

function u1.Begin(p2) -- Line: 38
    p2.Frame = p2.Frame + 1;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v3;

    if workspace_CurrentCamera then
        v3 = workspace_CurrentCamera.CFrame.Position;
    else
        v3 = nil;
    end;

    p2.CameraPosition = v3;
end;

function u1.Skips(p4: any, p5: vector, p6: number) -- Line: 45
    local CameraPosition = p4.CameraPosition;
    local v7;

    if CameraPosition == nil or (p4.Frame + p6) % 4 == 0 then
        v7 = false;
    else
        v7 = (p5 - CameraPosition).Magnitude > 45;
    end;

    return v7;
end;

return u1;