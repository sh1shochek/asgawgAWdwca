-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.ClassicCamera
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.ClassicCamera
-- Decompile time: 10.77 ms

Vector2.new(0, 0)
local u4 = 0
local u9 = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserCameraInputDt = FlagUtil.getUserFlag("UserCameraInputDt")
local UserFixCameraFPError = FlagUtil.getUserFlag("UserFixCameraFPError")
local Players = game:GetService("Players")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local u61 = setmetatable({}, BaseCamera)
u61.__index = u61

function u61.new() -- Line: 40 -- upvalues: BaseCamera (val), u61 (val), CameraUtils (val)
    local v1 = BaseCamera.new()
    local v2 = setmetatable(v1, u61)
    v2.isFollowCamera = false
    v2.isCameraToggle = false
    v2.lastUpdate = tick()
    v2.cameraToggleSpring = CameraUtils.Spring.new(5, 0)
    return v2
end

function u61:GetCameraToggleOffset(a2) -- Line: 51
    -- upvalues: CameraInput (val), CameraUtils (val)
    if not self.isCameraToggle then
        return (Vector3.new())
    end
    local currentSubjectDistance = self.currentSubjectDistance
    if not CameraInput.getTogglePan() then
        self.cameraToggleSpring.goal = 0
    else
        self.cameraToggleSpring.goal = math.clamp(CameraUtils.map(currentSubjectDistance, 0, self.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1), 0, 1)
    end
    return (Vector3.new(0, self.cameraToggleSpring:step(a2) * ((math.clamp(CameraUtils.map(currentSubjectDistance, 0, 64, 0, 1), 0, 1)) + 1), 0))
end

function u61.SetCameraMovementMode(a1, a2) -- Line: 73 -- upvalues: BaseCamera (val)
    BaseCamera.SetCameraMovementMode(a1, a2)
    a1.isFollowCamera = a2 == Enum.ComputerCameraMovementMode.Follow
    a1.isCameraToggle = a2 == Enum.ComputerCameraMovementMode.CameraToggle
end

function u61.Update(a1, a2) -- Line: 80
    -- upvalues: UserCameraInputDt (val), u9 (val), Players (val), CameraInput (val), u4 (ref), CameraUtils (val)
    -- upvalues: UserFixCameraFPError (val)
    local CFrame_2, CameraHeight, CameraSubject, CameraToSubjectDistance, CameraToggleOffset, CurrentCamera, Focus, Humanoid, HumanoidRootPart, LocalPlayer, MouseLockOffset, SubjectPosition, lookVector, lookVector_2, p, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    local dispatch = 0
    while true do
        if dispatch < 43 then
            if dispatch < 21 then
                if dispatch < 10 then
                    if dispatch < 5 then
                        if dispatch < 2 then
                            if dispatch < 1 then
                                v7 = tick()
                                v12 = v7 - a1.lastUpdate
                            end
                        elseif dispatch < 3 then
                            CurrentCamera = workspace.CurrentCamera
                            CFrame_2 = CurrentCamera.CFrame
                            Focus = CurrentCamera.Focus
                            dispatch = if not a1.resetCameraAngle then 7 else 3
                        elseif dispatch < 4 then
                            HumanoidRootPart = a1:GetHumanoidRootPart()
                        else
                            lookVector = (HumanoidRootPart.CFrame * u9).lookVector
                        end
                    elseif dispatch < 7 then
                        if dispatch < 6 then
                            lookVector = u9.lookVector
                        else
                            a1.resetCameraAngle = false
                        end
                    elseif dispatch < 8 then
                        LocalPlayer = Players.LocalPlayer
                        Humanoid = a1:GetHumanoid()
                        dispatch = if not CurrentCamera.CameraSubject then 9 else 8
                    elseif dispatch < 9 then
                        v1 = CameraSubject:IsA("VehicleSeat")
                    end
                elseif dispatch < 15 then
                    if dispatch < 12 then
                        if dispatch < 11 then
                            v2 = CameraSubject:IsA("SkateboardPlatform")
                        end
                    elseif dispatch < 13 then
                        dispatch = if (Humanoid:GetState()) == Enum.HumanoidStateType.Climbing then 14 else 13
                    else
                        v3 = not (dispatch < 14)
                    end
                elseif dispatch < 18 then
                    if dispatch < 16 then
                        dispatch = if a1.lastUpdate == nil then 17 else 16
                    elseif dispatch < 17 then
                        dispatch = if not (v12 > 1) then 18 else 17
                    else
                        a1.lastCameraTransform = nil
                    end
                elseif dispatch < 19 then
                    v4 = CameraInput.getRotation(v12)
                    a1:StepZoom()
                    CameraHeight = a1:GetCameraHeight()
                    dispatch = if v4 == Vector2.new() then 20 else 19
                elseif dispatch < 20 then
                    u4 = 0
                    a1.lastUserPanCamera = tick()
                else
                    dispatch = if v7 - a1.lastUserPanCamera < 2 then 22 else 21
                end
            elseif dispatch < 32 then
                if dispatch < 26 then
                    if dispatch < 23 then
                        v5 = not (dispatch < 22)
                    elseif dispatch < 24 then
                        SubjectPosition = a1:GetSubjectPosition()
                    else
                        dispatch = if dispatch < 25 then if not LocalPlayer then 85 else 25 else if not CurrentCamera then 85 else 26
                    end
                elseif dispatch < 29 then
                    if dispatch < 27 then
                        CameraToSubjectDistance = a1:GetCameraToSubjectDistance()
                        dispatch = if not (CameraToSubjectDistance < 0) then 28 else 27
                    elseif not (dispatch < 28) then
                        dispatch = if not a1:GetIsMouseLocked() then 34 else 29
                    end
                elseif dispatch < 30 then
                    dispatch = if a1:IsInFirstPerson() then 34 else 30
                elseif dispatch < 31 then
                    v6 = a1:CalculateNewLookCFrameFromArg(lookVector, v4)
                    MouseLockOffset = a1:GetMouseLockOffset()
                else
                    MouseLockOffset = MouseLockOffset + Humanoid.CameraOffset
                end
            elseif dispatch < 37 then
                if dispatch < 34 then
                    if dispatch < 33 then
                        v9 = MouseLockOffset.X * v6.RightVector + MouseLockOffset.Y * v6.UpVector + MouseLockOffset.Z * v6.LookVector
                        dispatch = if not CameraUtils.IsFiniteVector3(v9) then 69 else 33
                    else
                        SubjectPosition = SubjectPosition + v9
                    end
                elseif dispatch < 35 then
                    dispatch = if v4 ~= Vector2.new() then 36 else 35
                else
                    v6 = not (dispatch < 36)
                end
            elseif not (dispatch < 40) then
                dispatch = if dispatch < 41 then if v2 then 43 else 41 else if dispatch < 42 then if not a1.isFollowCamera then 62 else 42 else if not v3 then 62 else 43
            elseif not (dispatch < 38) then
                if dispatch < 39 then
                    dispatch = if not a1.lastCameraTransform then 69 else 39
                else
                    v8 = a1:IsInFirstPerson()
                end
            end
        elseif dispatch < 64 then
            if dispatch < 53 then
                if dispatch < 48 then
                    dispatch = if dispatch < 45 then if dispatch < 44 then if not a1.lastUpdate then 62 else 44 else if not Humanoid then 62 else 45 else if dispatch < 46 then if not Humanoid.Torso then 62 else 46 else if dispatch < 47 then if not v8 then 54 else 47 else if not a1.lastSubjectCFrame then 69 else 48
                elseif dispatch < 50 then
                    dispatch = if dispatch < 49 then if v1 then 50 else 49 else if not v2 then 69 else 50
                elseif dispatch < 51 then
                    dispatch = if not CameraSubject:IsA("BasePart") then 69 else 51
                elseif dispatch < 52 then
                    v9 = -CameraUtils.GetAngleBetweenXZVectors(a1.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector)
                    dispatch = if not CameraUtils.IsFinite(v9) then 53 else 52
                else
                    v4 = v4 + Vector2.new(v9, 0)
                end
            elseif dispatch < 58 then
                if dispatch < 55 then
                    if dispatch < 54 then
                        u4 = 0
                    end
                elseif dispatch < 56 then
                    lookVector_2 = Humanoid.Torso.CFrame.lookVector
                    u4 = math.clamp(u4 + 3.839724354387525 * v12, 0, 4.363323129985824)
                    v10 = math.clamp(u4 * v12, 0, 1)
                    dispatch = if not a1:IsInFirstPerson() then 59 else 56
                else
                    dispatch = if dispatch < 57 then if not a1.isFollowCamera then 58 else 57 else if a1.isClimbing then 59 else 58
                end
            elseif dispatch < 61 then
                if not (dispatch < 59) then
                    if dispatch < 60 then
                        v11 = CameraUtils.GetAngleBetweenXZVectors(lookVector_2, a1:GetCameraLookVector())
                        dispatch = if not CameraUtils.IsFinite(v11) then 69 else 60
                    else
                        dispatch = if not (0.0001 < (math.abs(v11))) then 69 else 61
                    end
                end
            elseif dispatch < 62 then
                v4 = v4 + Vector2.new(v11 * v10, 0)
            else
                dispatch = if dispatch < 63 then if not a1.isFollowCamera then 69 else 63 else if v8 then 69 else 64
            end
        elseif dispatch < 75 then
            if dispatch < 69 then
                if dispatch < 66 then
                    if not (dispatch < 65) then
                        v10 = CameraUtils.GetAngleBetweenXZVectors(-(a1.lastCameraTransform.p - SubjectPosition), a1:GetCameraLookVector())
                        dispatch = if not CameraUtils.IsFinite(v10) then 69 else 66
                    end
                elseif dispatch < 67 then
                    dispatch = if not (0.0001 < (math.abs(v10))) then 69 else 67
                elseif dispatch < 68 then
                    v11 = math.abs(v10)
                    dispatch = if not (0.4 * v12 < v11) then 69 else 68
                else
                    v4 = v4 + Vector2.new(v10, 0)
                end
            elseif dispatch < 72 then
                if dispatch < 70 then
                    dispatch = if a1.isFollowCamera then 75 else 70
                elseif dispatch < 71 then
                    p = (CFrame.new(SubjectPosition)).p
                    v8 = a1:CalculateNewLookVectorFromArg(lookVector, v4)
                    v9 = p - CameraToSubjectDistance * v8
                    dispatch = if not (CameraToSubjectDistance <= 0) then 72 else 71
                else
                    v13 = CFrame.lookAlong(p, v8)
                end
            elseif not (dispatch < 73) then
                v13 = if dispatch < 74 then CFrame.lookAlong(v9, v8) else CFrame.new(v9, p)
            end
        elseif dispatch < 80 then
            if dispatch < 77 then
                if dispatch < 76 then
                    v6 = a1:CalculateNewLookVectorFromArg(lookVector, v4)
                    v8 = (CFrame.new(SubjectPosition)).p - CameraToSubjectDistance * v6
                    dispatch = if not (CameraToSubjectDistance <= 0) then 77 else 76
                else
                    v13 = CFrame.lookAlong(v14.p, v6)
                end
            elseif not (dispatch < 78) then
                v13 = if dispatch < 79 then CFrame.lookAlong(v8, v6) else (CFrame.new(v8, v14.p)) + Vector3.new(0, CameraHeight, 0)
            end
        elseif dispatch < 83 then
            if dispatch < 81 then
                CameraToggleOffset = a1:GetCameraToggleOffset(v12)
                Focus = v14 + CameraToggleOffset
                CFrame_2 = v13 + CameraToggleOffset
                a1.lastCameraTransform = CFrame_2
                a1.lastCameraFocus = Focus
            else
                dispatch = if dispatch < 82 then if not v2 then 84 else 82 else if not CameraSubject:IsA("BasePart") then 84 else 83
            end
        elseif dispatch < 84 then
            a1.lastSubjectCFrame = CameraSubject.CFrame
        else
            if not (dispatch < 85) then
                a1.lastUpdate = v7
                return CFrame_2, Focus
            end
            a1.lastSubjectCFrame = nil
        end
    end
end

return u61