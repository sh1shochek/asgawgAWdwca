-- ReplicatedStorage.Controllers.CameraController
-- Script path: ReplicatedStorage.Controllers.CameraController
-- Decompile time: 19.82 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Spring = require(ReplicatedStorage.Shared.Spring)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera
local u57 = true
local u58 = 1
local u59 = 0
local u60 = {}
local u61 = {}
local u62 = false
local u63 = 1
local u64 = 0.5
local u65 = nil
local u66 = nil
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = 0
local u71 = nil
local u72 = nil
local u73 = 0
local u74 = nil
local u75 = nil
local u76 = nil
local u77 = {}
local u82 = Spring.new(1, 100, Constants.DEFAULT_CAMERA_FOV)
local u87 = Spring.new(1, 10, (Vector3.new(0, 0, 0)))
local u92 = Spring.new(0.4, 25, (Vector3.new(0, 0, 0)))
local u97 = Spring.new(0.3, 35, (Vector3.new(0, 0, 0)))
local u102 = Spring.new(1, 1, (Vector3.new(0, 0, 0)))
local u107 = Spring.new(1, 1, (Vector3.new(0, 0, 0)))
local u112 = Spring.new(1, 1, (Vector3.new(0, 0, 0)))

local function setPerspectiveIndicator(a1) -- Line: 92 -- upvalues: PlayerGui (val) -- types: a1: boolean
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective and CameraPerspective.Visible ~= a1 then
        CameraPerspective.Visible = a1
    end
end

local function applyMouseEnabled(a1) -- Line: 100
    -- upvalues: UserInputService (val), PlayerGui (val)
    UserInputService.MouseBehavior = a1 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = a1
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective and CameraPerspective.Visible ~= a1 then
        CameraPerspective.Visible = a1
    end
end

local function getAimAssistController() -- Line: 106 -- upvalues: u66 (ref), ReplicatedStorage (val)
    if not u66 then
        local success, result = pcall(function() -- Line: 108 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if success and result then
            u66 = result
        end
    end
    return u66
end

local function getCameraInput() -- Line: 120 -- upvalues: u65 (ref), LocalPlayer (val)
    if u65 then
        return u65
    end
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
    local CameraModule = PlayerModule and PlayerModule:FindFirstChild("CameraModule")
    local CameraInput = CameraModule and CameraModule:FindFirstChild("CameraInput")
    if CameraInput and CameraInput:IsA("ModuleScript") then
        local success, result = pcall(require, CameraInput)
        if success and result and result.setTouchSensitivity then
            u65 = result
            return result
        end
        return nil
    end
    return nil
end

local function setTouchSensitivity(a1) -- Line: 142 -- upvalues: u68 (ref), getCameraInput (val) -- types: a1: number
    if u68 and (math.abs(u68 - a1)) <= 0.0001 then
        return
    end
    local v1 = getCameraInput()
    if v1 then
        u68 = a1
        v1.setTouchSensitivity(a1)
    end
end

local function setGamepadAssistMultiplier(a1) -- Line: 156
    -- upvalues: u69 (ref), getCameraInput (val)
    if u69 and (math.abs(u69 - a1)) <= 0.0001 then
        return
    end
    local v1 = getCameraInput()
    if v1 and v1.setGamepadAssistMultiplier then
        u69 = a1
        v1.setGamepadAssistMultiplier(a1)
    end
end

local function getLockedFOV() -- Line: 174 -- upvalues: u61 (val)
    for k, v in pairs(u61) do
        return v
    end
    return nil
end

local function getCameraCFrame(a1) -- Line: 183
    -- upvalues: u66 (ref), ReplicatedStorage (val), u107 (val), u92 (val), u87 (val), u102 (val), u112 (val), u58 (ref)
    -- upvalues: u97 (val), u71 (ref)
    if not u66 then
        local success, result = pcall(function() -- Line: 108 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if success and result then
            u66 = result
        end
    end
    local v1 = u66
    local v2 = if not v1 then Vector3.new(1, 1, 1) else v1.GetRecoilAssistScale()
    local v3 = (u107:getPosition()) + u92:getPosition()
    local v4 = (u87:getPosition()) + u102:getPosition()
    local v5 = a1 or u58
    local v6 = v4 + (u112:getPosition()) * v5 * v2 + u97:getPosition()
    return u71 * CFrame.new(v3) * CFrame.Angles(v6.X, v6.Y, v6.Z)
end

local function isSceneCameraActive() -- Line: 197 -- upvalues: u77 (ref)
    for i, j in u77 do
        if j.IsActive() then
            return true
        end
    end
    return false
end

local function applyAspectRatioStretch() -- Line: 235
    -- upvalues: u73 (ref), u57 (ref), u77 (ref), CurrentCamera (val), u75 (ref), u76 (ref)
    local CFrame_2, FieldOfView, v1, v2, v3, v4
    if u73 <= 0 or not u57 then
        v1 = 1
    else
        local ViewportSize
        v3 = nil
        for i, j in u77, nil, v3 do
            if j.IsActive() then
                if false then
                    ViewportSize = CurrentCamera.ViewportSize
                    v1 = if ViewportSize.X <= 0 then 1 else if not (ViewportSize.Y <= 0) then (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u73 + 1 else 1
                else
                    v1 = 1
                end
                if v1 <= 1 then
                    return
                end
                v2 = 1 / v1
                CFrame_2 = CurrentCamera.CFrame
                FieldOfView = CurrentCamera.FieldOfView
                v3 = CFrame_2 * CFrame.new(0, 0, 0, 1, 0, 0, 0, v2, 0, 0, 0, 1)
                v4 = math.deg((math.atan(v2 * (math.tan((math.rad(FieldOfView)) / 2)))) * 2)
                u75 = CFrame_2
                u76 = FieldOfView
                CurrentCamera.CFrame = v3
                CurrentCamera.FieldOfView = v4
                return
            end
        end
        if true then
            ViewportSize = CurrentCamera.ViewportSize
            v1 = if ViewportSize.X <= 0 then 1 else if not (ViewportSize.Y <= 0) then (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u73 + 1 else 1
        else
            v1 = 1
        end
    end
    if v1 <= 1 then
        return
    end
    v2 = 1 / v1
    CFrame_2 = CurrentCamera.CFrame
    FieldOfView = CurrentCamera.FieldOfView
    v3 = CFrame_2 * CFrame.new(0, 0, 0, 1, 0, 0, 0, v2, 0, 0, 0, 1)
    v4 = math.deg((math.atan(v2 * (math.tan((math.rad(FieldOfView)) / 2)))) * 2)
    u75 = CFrame_2
    u76 = FieldOfView
    CurrentCamera.CFrame = v3
    CurrentCamera.FieldOfView = v4
end

local function restoreAspectRatioStretch() -- Line: 261 -- upvalues: u75 (ref), u76 (ref), CurrentCamera (val)
    local v1 = u75
    local v2 = u76
    if v1 and v2 then
        u75 = nil
        u76 = nil
        CurrentCamera.CFrame = v1
        CurrentCamera.FieldOfView = v2
        return
    end
end

local function setTextBoxFocusOverrideActive(a1) -- Line: 275 -- upvalues: u0 (val) -- types: a1: boolean
    u0.setForceLockOverride("TextBox", a1)
end

function u0.getWeaponKickRotation() -- Line: 282 -- upvalues: u102 (val)
    return u102:getPosition()
end

function u0.updateCameraFOV(a1) -- Line: 288 -- upvalues: u61 (val), u82 (val) -- types: a1: number
    for k, v in pairs(u61) do
        if v ~= nil then
            return
        end
        u82:setGoal((math.clamp(a1, 1, 80)))
        return
    end
    if false then
        return
    end
    u82:setGoal((math.clamp(a1, 1, 80)))
end

function u0.getTargetFOV() -- Line: 297 -- upvalues: u82 (val)
    return (math.clamp(u82:getGoal(), 1, 80))
end

function u0.setFOVLock(a1, a2, a3) -- Line: 303
    -- upvalues: u61 (val), u82 (val)
    local v1 = u61
    v1[a1] = if not a2 then nil else math.clamp(a3 or u82:getGoal(), 1, 80)
    for k, v in pairs(u61) do
        v1 = v
        if v1 ~= nil then
            u82:reset(v1)
        end
        return
    end
    v1 = nil
    if v1 ~= nil then
        u82:reset(v1)
    end
end

function u0.setMouseEnabled(a1) -- Line: 314
    -- upvalues: u62 (ref), u60 (val), UserInputService (val), PlayerGui (val)
    u62 = a1
    if next(u60) == nil then
        UserInputService.MouseBehavior = a1 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = a1
        local MainGui = PlayerGui:FindFirstChild("MainGui")
        local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
        if CameraPerspective and CameraPerspective.Visible ~= a1 then
            CameraPerspective.Visible = a1
        end
    end
end

function u0.setForceLockOverride(a1, a2) -- Line: 326
    -- upvalues: u60 (val), u62 (ref), UserInputService (val), PlayerGui (val)
    u60[a1] = if not a2 then nil else true
    local v1 = true
    if next(u60) == nil then
        v1 = u62
    end
    UserInputService.MouseBehavior = v1 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = v1
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective and CameraPerspective.Visible ~= v1 then
        CameraPerspective.Visible = v1
    end
end

function u0.resetForceLockOverride() -- Line: 334
    -- upvalues: u60 (val), u62 (ref), UserInputService (val), PlayerGui (val)
    table.clear(u60)
    u62 = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective and CameraPerspective.Visible ~= false then
        CameraPerspective.Visible = false
    end
end

function u0.isForceLockOverrideActive() -- Line: 342 -- upvalues: u60 (val)
    return next(u60) ~= nil
end

function u0.SetEnabled(a1) -- Line: 348
    -- upvalues: u57 (ref), u71 (ref), u72 (ref), u69 (ref), getCameraInput (val)
    u57 = a1
    if not a1 then
        u71 = nil
        u72 = nil
        if u69 and (math.abs(u69 - 1)) <= 0.0001 then
            return
        end
        local v1 = getCameraInput()
        if v1 and v1.setGamepadAssistMultiplier then
            u69 = 1
            v1.setGamepadAssistMultiplier(1)
        end
    end
end

function u0.setPerspective(a1, a2, a3) -- Line: 361
    -- upvalues: u0 (val), LocalPlayer (val)
    local v1 = math.max(if not a1 then a3 or 5 else 0, 0.5)
    u0.setMouseEnabled(a2)
    if LocalPlayer.CameraMaxZoomDistance ~= v1 or LocalPlayer.CameraMinZoomDistance ~= v1 then
        LocalPlayer.CameraMaxZoomDistance = v1
        LocalPlayer.CameraMinZoomDistance = v1
    end
    local LockFirstPerson = a1 and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
    if LocalPlayer.CameraMode ~= LockFirstPerson then
        LocalPlayer.CameraMode = LockFirstPerson
    end
end

function u0.toWeaponFirePosition() -- Line: 382
    -- upvalues: u71 (ref), u102 (val), u107 (val), CurrentCamera (val), u0 (val), getCameraCFrame (val)
    if u71 then
        u102:reset((Vector3.new(0, 0, 0)))
        u107:reset((Vector3.new(0, 0, 0)))
        CurrentCamera.CFrame = u71
        u0.updateCamera((getCameraCFrame(1)))
    end
end

function u0.weaponKick(a1, a2) -- Line: 395 -- upvalues: u102 (val), u107 (val), u0 (val) -- types: a1: table, a2: table
    u102:setDampingRatio(a1.Damper)
    u102:setFrequency(a1.Speed)
    u102:setPosition(a1.Value * 0.017453292519943295)
    u107:setDampingRatio(a2.Damper)
    u107:setFrequency(a2.Speed)
    u107:setPosition(a2.Value)
    u0.updateCamera()
end

function u0.setWeaponRecoil(a1, a2) -- Line: 409 -- upvalues: u112 (val), u58 (ref) -- types: a1: table, a2: number
    u112:setDampingRatio(a1.Damper)
    u112:setFrequency(a1.Speed)
    u112:setGoal(a1.Value)
    u58 = a2
end

function u0.resetWeaponRecoil() -- Line: 418 -- upvalues: u112 (val), u58 (ref)
    u112:reset((Vector3.new(0, 0, 0)))
    u58 = 1
end

function u0.BombExploded(a1) -- Line: 425 -- upvalues: u61 (val), u92 (val), u97 (val), u82 (val) -- types: a1: number
    local u37, v1
    for k, v in pairs(u61) do
        if v ~= nil then
            return
        end
        v1 = math.max(0.35, 1 - (math.min(a1 / 75, 1)))
        u92:impulse(Vector3.new(1.2000000476837158, 0.5, 0.699999988079071) * v1)
        u97:impulse(Vector3.new(0.1745329201221466, 0.06981316953897476, 0.05235987901687622) * v1)
        u37 = u82:getGoal()
        u82:setGoal(u37 - v1 * 1.5)
        task.delay(0.15, function() -- Line: 439 -- upvalues: u82 (upval), u37 (val)
            u82:setGoal(u37)
        end)
        return
    end
    if false then
        return
    end
    v1 = math.max(0.35, 1 - (math.min(a1 / 75, 1)))
    u92:impulse(Vector3.new(1.2000000476837158, 0.5, 0.699999988079071) * v1)
    u97:impulse(Vector3.new(0.1745329201221466, 0.06981316953897476, 0.05235987901687622) * v1)
    u37 = u82:getGoal()
    u82:setGoal(u37 - v1 * 1.5)
    task.delay(0.15, function() -- Line: 439 -- upvalues: u82 (upval), u37 (val)
        u82:setGoal(u37)
    end)
end

function u0.updateCamera(a1) -- Line: 446
    -- upvalues: u61 (val), u82 (val), CurrentCamera (val), Constants (val), u63 (ref), u64 (ref), u66 (ref)
    -- upvalues: ReplicatedStorage (val), u67 (ref), UserInputService (val), u68 (ref), getCameraInput (val), u69 (ref)
    -- upvalues: getCameraCFrame (val), u72 (ref)
    local DEFAULT_CAMERA_FOV, result, success, v1, v2, v3, v4, v5, v6, v7, v8
    for k, v in pairs(u61) do
        v1 = v
        if v1 ~= nil and u82:getGoal() ~= v1 then
            u82:reset(v1)
        end
        v2 = math.clamp(v1 or u82:getPosition(), 1, 80)
        if CurrentCamera.FieldOfViewMode ~= Enum.FieldOfViewMode.Diagonal then
            CurrentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
        end
        if 0.001 < (math.abs(CurrentCamera.FieldOfView - v2)) then
            CurrentCamera.FieldOfView = v2
        end
        DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV
        v3 = v2 / DEFAULT_CAMERA_FOV
        v4 = u63
        if (math.abs(v2 - (DEFAULT_CAMERA_FOV - 37))) < 0.1 or (math.abs(v2 - (DEFAULT_CAMERA_FOV - 60))) < 0.1 then
            v4 = u63 * u64
        end
        if not u66 then
            success, result = pcall(function() -- Line: 108 -- upvalues: ReplicatedStorage (upval)
                return require(ReplicatedStorage.Controllers.AimAssistController)
            end)
            if success and result then
                u66 = result
            end
        end
        v5 = u66
        v6 = if not v5 then 1 else v5.GetFrictionMultiplier()
        v7 = v3 * v4 * v6
        if not u67 or 0.0001 < (math.abs(u67 - v7)) then
            u67 = v7
            UserInputService.MouseDeltaSensitivity = v7
        end
        if not u68 then
            v8 = getCameraInput()
            if v8 then
                u68 = v7
                v8.setTouchSensitivity(v7)
            end
        else
            v8 = math.abs(u68 - v7)
            if not (v8 <= 0.0001) then
                v8 = getCameraInput()
                if v8 then
                    u68 = v7
                    v8.setTouchSensitivity(v7)
                end
            end
        end
        if not u69 then
            v8 = getCameraInput()
            if v8 and v8.setGamepadAssistMultiplier then
                u69 = v6
                v8.setGamepadAssistMultiplier(v6)
            end
        else
            v8 = math.abs(u69 - v6)
            if not (v8 <= 0.0001) then
                v8 = getCameraInput()
                if v8 and v8.setGamepadAssistMultiplier then
                    u69 = v6
                    v8.setGamepadAssistMultiplier(v6)
                end
            end
        end
        CurrentCamera.CFrame = a1 or getCameraCFrame()
        u72 = CurrentCamera.CFrame
        return
    end
    v1 = nil
    if v1 ~= nil and u82:getGoal() ~= v1 then
        u82:reset(v1)
    end
    v2 = math.clamp(v1 or u82:getPosition(), 1, 80)
    if CurrentCamera.FieldOfViewMode ~= Enum.FieldOfViewMode.Diagonal then
        CurrentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
    end
    if 0.001 < (math.abs(CurrentCamera.FieldOfView - v2)) then
        CurrentCamera.FieldOfView = v2
    end
    DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV
    v3 = v2 / DEFAULT_CAMERA_FOV
    v4 = u63
    if (math.abs(v2 - (DEFAULT_CAMERA_FOV - 37))) < 0.1 or (math.abs(v2 - (DEFAULT_CAMERA_FOV - 60))) < 0.1 then
        v4 = u63 * u64
    end
    if not u66 then
        success, result = pcall(function() -- Line: 108 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if success and result then
            u66 = result
        end
    end
    v5 = u66
    v6 = if not v5 then 1 else v5.GetFrictionMultiplier()
    v7 = v3 * v4 * v6
    if not u67 or 0.0001 < (math.abs(u67 - v7)) then
        u67 = v7
        UserInputService.MouseDeltaSensitivity = v7
    end
    if not u68 then
        v8 = getCameraInput()
        if v8 then
            u68 = v7
            v8.setTouchSensitivity(v7)
        end
    else
        v8 = math.abs(u68 - v7)
        if not (v8 <= 0.0001) then
            v8 = getCameraInput()
            if v8 then
                u68 = v7
                v8.setTouchSensitivity(v7)
            end
        end
    end
    if not u69 then
        v8 = getCameraInput()
        if v8 and v8.setGamepadAssistMultiplier then
            u69 = v6
            v8.setGamepadAssistMultiplier(v6)
        end
    else
        v8 = math.abs(u69 - v6)
        if not (v8 <= 0.0001) then
            v8 = getCameraInput()
            if v8 and v8.setGamepadAssistMultiplier then
                u69 = v6
                v8.setGamepadAssistMultiplier(v6)
            end
        end
    end
    CurrentCamera.CFrame = a1 or getCameraCFrame()
    u72 = CurrentCamera.CFrame
end

local function applyAspectRatio(a1) -- Line: 493 -- upvalues: u73 (ref)
    u73 = (1 - math.clamp(tonumber(a1) or 1, 0.5, 1)) / 0.5
end

function u0.SetAspectRatio(a1) -- Line: 500 -- upvalues: u74 (ref), u73 (ref)
    u74 = tonumber(a1)
    u73 = (1 - math.clamp(tonumber(a1) or 1, 0.5, 1)) / 0.5
end

function u0.StateChanged(a1, a2) -- Line: 505 -- upvalues: u0 (val)
    if a1 == Enum.HumanoidStateType.Freefall and a2 == Enum.HumanoidStateType.Landed then
        u0.OnLanded()
    end
end

function u0.OnLanded(a1, a2) -- Line: 511
    -- upvalues: u59 (ref), u70 (ref), u87 (val)
    if tick() - u59 < 0.3 then
        return
    end
    local v1 = math.clamp(((if typeof(a1) ~= "number" then 12 else math.max(a1, 0)) - 2) / 10, 0, 1)
    if v1 <= 0 then
        return
    end
    if typeof(a2) == "number" then
        v1 = v1 * (math.clamp(a2, 0, 1) * -0.85 + 1)
    end
    u59 = tick()
    u70 = u70 + 1
    local u39 = u70
    u87:setDampingRatio(1)
    u87:setFrequency(10)
    u87:setGoal((Vector3.new(v1 * -0.02181661564992912, 0, 0)))
    task.delay(0.08, function() -- Line: 539 -- upvalues: u39 (val), u70 (upval), u87 (upval)
        if u39 == u70 then
            u87:setGoal((Vector3.new(0, 0, 0)))
        end
    end)
end

function u0.clampFOV(a1) -- Line: 170 -- types: a1: number
    return (math.clamp(a1, 1, 80))
end

function u0.getAspectRatioStretch() -- Line: 219 -- upvalues: u73 (ref), u57 (ref), u77 (ref), CurrentCamera (val)
    if not (u73 <= 0) and u57 then
        local ViewportSize
        for i, j in u77 do
            if j.IsActive() then
                if true then
                    return 1
                end
                ViewportSize = CurrentCamera.ViewportSize
                if not (ViewportSize.X <= 0) and not (ViewportSize.Y <= 0) then
                    return (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u73 + 1
                end
                return 1
            end
        end
        if true then
            ViewportSize = CurrentCamera.ViewportSize
            if not (ViewportSize.X <= 0) and not (ViewportSize.Y <= 0) then
                return (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u73 + 1
            end
            return 1
        end
    end
    return 1
end

function u0.Initialize() -- Line: 553
    -- upvalues: u66 (ref), ReplicatedStorage (val), RunServiceController (val), u92 (val), u97 (val), u102 (val)
    -- upvalues: u107 (val), u112 (val), u82 (val), u87 (val), u57 (ref), CurrentCamera (val), CharacterResolver (val)
    -- upvalues: LocalPlayer (val), u71 (ref), u0 (val), getCameraCFrame (val), u60 (val), u62 (ref)
    -- upvalues: UserInputService (val), PlayerGui (val), u72 (ref), applyAspectRatioStretch (val), RunService (val)
    -- upvalues: restoreAspectRatioStretch (val)
    if not u66 then
        local success, result = pcall(function() -- Line: 108 -- upvalues: ReplicatedStorage (upval)
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if success and result then
            u66 = result
        end
    end
    local v1 = u66
    if v1 then
        v1.Initialize()
    end
    RunServiceController.BindToStepped("CameraController.UpdateSprings", function(a1, a2) -- Line: 559
        -- upvalues: u92 (upval), u97 (upval), u102 (upval), u107 (upval), u112 (upval), u82 (upval), u87 (upval)
        u92:update(a2)
        u97:update(a2)
        u102:update(a2)
        u107:update(a2)
        u112:update(a2)
        u82:update(a2)
        u87:update(a2)
    end)
    RunServiceController.BindToRenderStep("CameraController.UpdateCamera", Enum.RenderPriority.Camera.Value + 1, function(a1) -- Line: 569
        -- upvalues: u57 (upval), CurrentCamera (upval), u66 (upval), CharacterResolver (upval), LocalPlayer (upval)
        -- upvalues: u71 (upval), u0 (upval), getCameraCFrame (upval), u60 (upval), u62 (upval)
        -- upvalues: UserInputService (upval), PlayerGui (upval)
        local v1
        if not u57 then
            return
        end
        local CFrame_2 = CurrentCamera.CFrame
        if u66 then
            v1 = u66.GetMagnetismRotation(a1)
            if 1e-06 < v1.Magnitude and v1.X == v1.X and v1.Y == v1.Y then
                local v2 = math.abs(v1.X)
                if v2 < 3.141592653589793 then
                    v2 = math.abs(v1.Y)
                    if v2 < 3.141592653589793 then
                        v2 = CharacterResolver.getPlayerCharacter(LocalPlayer)
                        local Position = if not v2 then CFrame_2.Position else if not v2:FindFirstChild("HumanoidRootPart") then CFrame_2.Position else v2.HumanoidRootPart.Position
                        local v3 = math.clamp(v1.Y, -0.08726646259971647, 0.08726646259971647)
                        local v4 = math.clamp(v1.X, -0.08726646259971647, 0.08726646259971647)
                        local v5 = (CFrame.fromAxisAngle(CFrame_2.RightVector, v3)) * CFrame.Angles(0, v4, 0)
                        CFrame_2 = (CFrame.new(Position + (v5:VectorToWorldSpace(CFrame_2.Position - Position)))) * (v5 * CFrame_2.Rotation)
                    end
                end
            end
        end
        u71 = CFrame_2
        u0.updateCamera((getCameraCFrame()))
        v1 = true
        if next(u60) == nil then
            v1 = u62
        end
        local Default = if not v1 then Enum.MouseBehavior.LockCenter else Enum.MouseBehavior.Default
        if UserInputService.MouseBehavior ~= Default then
            UserInputService.MouseBehavior = Default
        end
        if UserInputService.MouseIconEnabled ~= v1 then
            UserInputService.MouseIconEnabled = v1
        end
        local MainGui = PlayerGui:FindFirstChild("MainGui")
        local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
        if CameraPerspective and CameraPerspective.Visible ~= v1 then
            CameraPerspective.Visible = v1
        end
    end)
    RunServiceController.BindToRenderStep("CameraController.ResetCameraShake", Enum.RenderPriority.Camera.Value - 1, function() -- Line: 621 -- upvalues: u57 (upval), u71 (upval), CurrentCamera (upval), u72 (upval)
        if u57 and u71 and CurrentCamera.CFrame == u72 then
            CurrentCamera.CFrame = u71
        end
    end)
    RunServiceController.BindToRenderSteppedEvent("CameraController.AspectRatioStretch", applyAspectRatioStretch, (1 / 0))
    RunService.PreAnimation:Connect(restoreAspectRatioStretch)
    RunServiceController.BindToRenderStep(
        "CameraController.UndoAspectRatioStretch",
        Enum.RenderPriority.First.Value,
        restoreAspectRatioStretch
    )
    UserInputService.TextBoxFocused:Connect(function() -- Line: 637 -- upvalues: u0 (upval)
        u0.setForceLockOverride("TextBox", true)
    end)
    UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 640 -- upvalues: UserInputService (upval), u0 (upval)
        task.defer(function() -- Line: 642 -- upvalues: UserInputService (upval), u0 (upval)
            local v1 = UserInputService:GetFocusedTextBox() ~= nil
            u0.setForceLockOverride("TextBox", v1)
        end)
    end)
    local v2 = UserInputService:GetFocusedTextBox() ~= nil
    u0.setForceLockOverride("TextBox", v2)
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v3 = true
    if Attribute ~= "Counter-Terrorists" then
        v3 = Attribute == "Terrorists"
    end
    if not CharacterResolver.getPlayerCharacter(LocalPlayer) and not v3 then
        u0.setForceLockOverride("InitialMenu", true)
    end
end

function u0.Start() -- Line: 659
    -- upvalues: ReplicatedStorage (val), u77 (ref), u0 (val), Constants (val), CharacterResolver (val)
    -- upvalues: LocalPlayer (val), DataController (val), u63 (ref), u68 (ref), getCameraInput (val), u74 (ref)
    -- upvalues: u73 (ref), u64 (ref)
    local v1
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    local v2 = {}
    local v3 = {IsActive = MenuSceneController.IsTeamSelectSceneActive}
    local InspectController = require(ReplicatedStorage.Controllers.InspectController)
    v2[1] = MenuSceneController
    v2[2] = v3
    v2[3] = CaseSceneController
    v2[4] = InspectController
    v2[5] = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    u77 = v2
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)

    local function resetFOV() -- Line: 675
        -- upvalues: CaseSceneController (val), BlackMarketSceneController (val), u0 (upval), Constants (upval)
        if not CaseSceneController.IsActive() and not BlackMarketSceneController.IsActive() then
            u0.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
        end
    end

    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 680
        -- upvalues: CaseSceneController (val), BlackMarketSceneController (val), u0 (upval), Constants (upval)
        -- upvalues: resetFOV (val)
        if a1 then
            if not CaseSceneController.IsActive() and not BlackMarketSceneController.IsActive() then
                u0.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
            end
            ;(a1:GetAttributeChangedSignal("Dead")):Once(resetFOV)
        end
        return function() end
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Mouse Sensitivity", function(a1) -- Line: 689 -- upvalues: u63 (upval), u68 (upval), getCameraInput (upval) -- types: a1: number?
        u63 = math.clamp(a1 or 1, 0.1, 10)
        local v1 = u63
        if u68 and (math.abs(u68 - v1)) <= 0.0001 then
            return
        end
        local v2 = getCameraInput()
        if v2 then
            u68 = v1
            v2.setTouchSensitivity(v1)
        end
    end)
    v3 = u63
    if not u68 then
        v1 = getCameraInput()
        if v1 then
            u68 = v3
            v1.setTouchSensitivity(v3)
        end
    else
        v1 = math.abs(u68 - v3)
        if not (v1 <= 0.0001) then
            v1 = getCameraInput()
            if v1 then
                u68 = v3
                v1.setTouchSensitivity(v3)
            end
        end
    end
    DataController.CreateListener(LocalPlayer, "Settings.Video.Advanced.Aspect Ratio", function(a1) -- Line: 697 -- upvalues: u74 (upval), u73 (upval)
        if u74 ~= nil then
            if 0.0001 < (math.abs((tonumber(a1) or 1) - u74)) then
                return
            end
            u74 = nil
        end
        u73 = (1 - math.clamp(tonumber(a1) or 1, 0.5, 1)) / 0.5
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Zoom Sensitivity Multiplier", function(a1) -- Line: 709 -- upvalues: u64 (upval) -- types: a1: number?
        u64 = math.clamp(a1 or 0.5, 0.1, 5)
    end)
end

return u0