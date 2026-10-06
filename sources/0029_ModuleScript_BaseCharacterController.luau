-- Decompiled with Potassium's decompiler.

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local Vector3_new_ret = Vector3.new();
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 33
    -- upvalues: u1 (copy), Vector3_new_ret (copy), ConnectionUtil (copy)
    local v2 = setmetatable({}, u1);
    v2.enabled = false;
    v2.moveVector = Vector3_new_ret;
    v2.moveVectorIsCameraRelative = true;
    v2.isJumping = false;
    v2._connectionUtil = ConnectionUtil.new();

    return v2;
end;

function u1.GetMoveVector(p3) -- Line: 45
    return p3.moveVector;
end;

function u1.IsMoveVectorCameraRelative(p4) -- Line: 49
    return p4.moveVectorIsCameraRelative;
end;

function u1.GetIsJumping(p5) -- Line: 53
    return p5.isJumping;
end;

function u1.Enable(p6: table, p7: boolean) -- Line: 59
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.");

    return false;
end;

return u1;