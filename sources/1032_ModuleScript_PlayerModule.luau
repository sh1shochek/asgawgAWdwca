-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 12
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.cameras = require(script:WaitForChild("CameraModule"));
    v2.controls = require(script:WaitForChild("ControlModule"));

    return v2;
end;

function u1.GetCameras(p3) -- Line: 19
    return p3.cameras;
end;

function u1.GetControls(p4) -- Line: 23
    return p4.controls;
end;

function u1.GetClickToMoveController(p5) -- Line: 27
    return p5.controls:GetClickToMoveController();
end;

return u1.new();