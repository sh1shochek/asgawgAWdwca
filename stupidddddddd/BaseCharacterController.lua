-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController
-- Decompile time: 0.42 ms

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local u14 = Vector3.new()
local u15 = {}
u15.__index = u15

function u15.new() -- Line: 33 -- upvalues: u15 (val), u14 (val), ConnectionUtil (val)
    local v1 = setmetatable({}, u15)
    v1.enabled = false
    v1.moveVector = u14
    v1.moveVectorIsCameraRelative = true
    v1.isJumping = false
    v1._connectionUtil = ConnectionUtil.new()
    return v1
end

function u15.GetMoveVector(a1) -- Line: 45
    return a1.moveVector
end

function u15.IsMoveVectorCameraRelative(a1) -- Line: 49
    return a1.moveVectorIsCameraRelative
end

function u15.GetIsJumping(a1) -- Line: 53
    return a1.isJumping
end

function u15.Enable(a1, a2) -- Line: 59 -- types: a1: table, a2: boolean
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
    return false
end

return u15