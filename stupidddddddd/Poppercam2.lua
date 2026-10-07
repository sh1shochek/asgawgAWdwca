-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.Poppercam
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.Poppercam
-- Decompile time: 2.42 ms

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local Players = game:GetService("Players")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local LocalPlayer = Players.LocalPlayer
local UserFixCameraFPError = FlagUtil.getUserFlag("UserFixCameraFPError")
local u30 = {}
u30.__index = u30
local u32 = CFrame.new()

local function cframeToAxis(a1) -- Line: 19 -- types: a1: userdata
    local v1, v2 = a1:ToAxisAngle()
    return v1 * v2
end

local function axisToCFrame(a1) -- Line: 24 -- upvalues: u32 (val) -- types: a1: vector
    local Magnitude = a1.Magnitude
    if Magnitude > 1e-05 then
        return CFrame.fromAxisAngle(a1, Magnitude)
    end
    return u32
end

local function extractRotation(a1) -- Line: 32 -- types: a1: userdata
    local Components_10, Components_2, Components_3, Components_4, Components_5, Components_6, Components_7, Components_8, Components_9
    _, _, _, Components_2, Components_3, Components_4, Components_5, Components_6, Components_7, Components_8, Components_9, Components_10 = a1:GetComponents()
    return CFrame.new(
        0,
        0,
        0,
        Components_2,
        Components_3,
        Components_4,
        Components_5,
        Components_6,
        Components_7,
        Components_8,
        Components_9,
        Components_10
    )
end

function u30.new() -- Line: 37 -- upvalues: u30 (val)
    return (setmetatable({}, u30))
end

function u30:Step(a2, a3) -- Line: 43 -- upvalues: u32 (val) -- types: self: table, a2: number, a3: userdata
    local Components_10, Components_11, Components_12, Components_16, Components_17, Components_18, Components_19, Components_20, Components_21, Components_22, Components_23, Components_24, Components_4, Components_5, Components_6, Components_7, Components_8, Components_9
    local v1 = self.lastCFrame or a3
    self.lastCFrame = a3
    local Position = a3.Position
    _, _, _, Components_4, Components_5, Components_6, Components_7, Components_8, Components_9, Components_10, Components_11, Components_12 = a3:GetComponents()
    local u34 = CFrame.new(
        0,
        0,
        0,
        Components_4,
        Components_5,
        Components_6,
        Components_7,
        Components_8,
        Components_9,
        Components_10,
        Components_11,
        Components_12
    )
    local p = v1.p
    _, _, _, Components_16, Components_17, Components_18, Components_19, Components_20, Components_21, Components_22, Components_23, Components_24 = v1:GetComponents()
    local v2 = CFrame.new(
        0,
        0,
        0,
        Components_16,
        Components_17,
        Components_18,
        Components_19,
        Components_20,
        Components_21,
        Components_22,
        Components_23,
        Components_24
    )
    local u66 = (Position - p) / a2
    local v3, v4 = (u34 * v2:inverse()):ToAxisAngle()
    local u76 = v3 * v4 / a2
    return {
        extrapolate = function(a1) -- Line: 58 -- upvalues: u66 (val), Position (val), u76 (val), u32 (upval), u34 (val)
            local v1 = u66 * a1 + Position
            local v2 = u76 * a1
            local Magnitude = v2.Magnitude
            return (if not (Magnitude > 1e-05) then u32 else CFrame.fromAxisAngle(v2, Magnitude)) * u34 + v1
        end,
        posVelocity = u66,
        rotVelocity = u76,
    }
end

function u30:Reset() -- Line: 71
    self.lastCFrame = nil
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local u50 = setmetatable({}, BaseOcclusion)
u50.__index = u50

function u50.new() -- Line: 81 -- upvalues: BaseOcclusion (val), u50 (val), u30 (val)
    local v1 = BaseOcclusion.new()
    local v2 = setmetatable(v1, u50)
    v2.focusExtrapolator = u30.new()
    return v2
end

function u50.GetOcclusionMode(a1) -- Line: 87
    return Enum.DevCameraOcclusionMode.Zoom
end

function u50.Enable(a1, a2) -- Line: 91
    a1.focusExtrapolator:Reset()
end

function u50.Update(a1, a2, a3, a4, a5) -- Line: 95
    -- upvalues: LocalPlayer (val), UserFixCameraFPError (val), ZoomController (val)
    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return a3, a4
    end
    local v1 = if not UserFixCameraFPError then (CFrame.new(a4.p, a3.p)) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) else (CFrame.lookAlong(a4.p, -a3.LookVector)) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    return v1 * CFrame.new(0, 0, (ZoomController.Update(a2, v1, (a1.focusExtrapolator:Step(a2, v1))))), a4
end

function u50.CharacterAdded(a1, a2, a3) end

function u50.CharacterRemoving(a1, a2, a3) end

function u50.OnCameraSubjectChanged(a1, a2) end

return u50