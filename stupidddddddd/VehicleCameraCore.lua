-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore
-- Decompile time: 3.84 ms

local CameraUtils = require(script.Parent.Parent.CameraUtils)
local VehicleCameraConfig = require(script.Parent.VehicleCameraConfig)
local map = CameraUtils.map
local mapClamp = CameraUtils.mapClamp
local sanitizeAngle = CameraUtils.sanitizeAngle

local function getYaw(a1) -- Line: 10 -- upvalues: sanitizeAngle (val)
    local v1
    _, v1 = a1:toEulerAnglesYXZ()
    return sanitizeAngle(v1)
end

local function getPitch(a1) -- Line: 16 -- upvalues: sanitizeAngle (val)
    return sanitizeAngle((a1:toEulerAnglesYXZ()))
end

local function stepSpringAxis(a1, a2, a3, a4, a5) -- Line: 22 -- upvalues: sanitizeAngle (val)
    local v1 = sanitizeAngle(a4 - a3)
    local v2 = math.exp(-a2 * a1)
    return (sanitizeAngle((v1 * (1 + a2 * a1) + a5 * a1) * v2 + a3)), (a5 * (1 - a2 * a1) - v1 * (a2 * a2 * a1)) * v2
end

local u17 = {}
u17.__index = u17

function u17.new(a1, a2, a3) -- Line: 36 -- upvalues: u17 (val)
    return (setmetatable({
        fRising = a1,
        fFalling = a2,
        g = a3,
        p = a3,
        v = a3 * 0,
    }, u17))
end

function u17:step(a2) -- Line: 46
    local fRising = self.fRising
    local fFalling = self.fFalling
    local g = self.g
    local p = self.p
    local v = self.v
    local v1 = 6.283185307179586 * (v > 0 and fRising or fFalling)
    local v2 = p - g
    local v3 = math.exp(-v1 * a2)
    local v4 = (v2 * (1 + v1 * a2) + v * a2) * v3 + g
    local v5 = (v * (1 - v1 * a2) - v2 * (v1 * v1 * a2)) * v3
    self.p = v4
    self.v = v5
    return v4
end

local u20 = {}
u20.__index = u20

function u20.new(a1) -- Line: 72 -- upvalues: sanitizeAngle (val), u17 (val), VehicleCameraConfig (val), u20 (val)
    local v1
    assert(typeof(a1) == "CFrame")
    local v2 = {yawV = 0, pitchV = 0}
    _, v1 = a1:toEulerAnglesYXZ()
    v2.yawG = sanitizeAngle(v1)
    _, v1 = a1:toEulerAnglesYXZ()
    v2.yawP = sanitizeAngle(v1)
    v2.pitchG = sanitizeAngle((a1:toEulerAnglesYXZ()))
    v2.pitchP = sanitizeAngle((a1:toEulerAnglesYXZ()))
    v2.fSpringYaw = u17.new(VehicleCameraConfig.yawReponseDampingRising, VehicleCameraConfig.yawResponseDampingFalling, 0)
    v2.fSpringPitch = u17.new(VehicleCameraConfig.pitchReponseDampingRising, VehicleCameraConfig.pitchResponseDampingFalling, 0)
    return (setmetatable(v2, u20))
end

function u20:setGoal(a2) -- Line: 99 -- upvalues: sanitizeAngle (val)
    local v1
    assert(typeof(a2) == "CFrame")
    _, v1 = a2:toEulerAnglesYXZ()
    self.yawG = sanitizeAngle(v1)
    self.pitchG = sanitizeAngle((a2:toEulerAnglesYXZ()))
end

function u20:getCFrame() -- Line: 106
    return CFrame.fromEulerAnglesYXZ(self.pitchP, self.yawP, 0)
end

function u20:step(a2, a3, a4, a5) -- Line: 110
    -- upvalues: mapClamp (val), map (val), VehicleCameraConfig (val), sanitizeAngle (val)
    assert(typeof(a2) == "number")
    assert(typeof(a4) == "number")
    assert(typeof(a3) == "number")
    assert(typeof(a5) == "number")
    local fSpringYaw = self.fSpringYaw
    local fSpringPitch = self.fSpringPitch
    fSpringYaw.g = mapClamp(
        map(a5, 0, 1, a4, 0),
        math.rad(VehicleCameraConfig.cutoffMinAngularVelYaw),
        math.rad(VehicleCameraConfig.cutoffMaxAngularVelYaw),
        1,
        0
    )
    fSpringPitch.g = mapClamp(
        map(a5, 0, 1, a3, 0),
        math.rad(VehicleCameraConfig.cutoffMinAngularVelPitch),
        math.rad(VehicleCameraConfig.cutoffMaxAngularVelPitch),
        1,
        0
    )
    local v1 = 6.283185307179586 * VehicleCameraConfig.yawStiffness * fSpringYaw:step(a2)
    local v2 = 6.283185307179586 * VehicleCameraConfig.pitchStiffness * fSpringPitch:step(a2) * map(a5, 0, 1, 1, VehicleCameraConfig.firstPersonResponseMul)
    v1 = v1 * map(a5, 0, 1, 1, VehicleCameraConfig.firstPersonResponseMul)
    local yawG = self.yawG
    local yawP = self.yawP
    local yawV = self.yawV
    local v3 = sanitizeAngle(yawP - yawG)
    local v4 = math.exp(-v1 * a2)
    local v5 = sanitizeAngle((v3 * (1 + v1 * a2) + yawV * a2) * v4 + yawG)
    local v6 = (yawV * (1 - v1 * a2) - v3 * (v1 * v1 * a2)) * v4
    self.yawP = v5
    self.yawV = v6
    local pitchG = self.pitchG
    local pitchP = self.pitchP
    local pitchV = self.pitchV
    v3 = sanitizeAngle(pitchP - pitchG)
    v4 = math.exp(-v2 * a2)
    v5 = sanitizeAngle((v3 * (1 + v2 * a2) + pitchV * a2) * v4 + pitchG)
    v6 = (pitchV * (1 - v2 * a2) - v3 * (v2 * v2 * a2)) * v4
    self.pitchP = v5
    self.pitchV = v6
    return self:getCFrame()
end

local u25 = {}
u25.__index = u25

function u25.new(a1) -- Line: 167 -- upvalues: u20 (val), u25 (val)
    return (setmetatable({vrs = u20.new(a1)}, u25))
end

function u25:step(a2, a3, a4, a5) -- Line: 173
    return self.vrs:step(a2, a3, a4, a5)
end

function u25.setTransform(a1, a2) -- Line: 177
    a1.vrs:setGoal(a2)
end

return u25