-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.LegacyCamera
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.LegacyCamera
-- Decompile time: 2.27 ms

Vector2.new()
require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local u34 = setmetatable({}, BaseCamera)
u34.__index = u34

function u34.new() -- Line: 21 -- upvalues: BaseCamera (val), u34 (val)
    local v1 = BaseCamera.new()
    local v2 = setmetatable(v1, u34)
    v2.cameraType = Enum.CameraType.Fixed
    v2.lastUpdate = tick()
    v2.lastDistanceToSubject = nil
    return v2
end

function u34.GetModuleName(a1) -- Line: 31
    return "LegacyCamera"
end

function u34.SetCameraToSubjectDistance(a1, a2) -- Line: 36 -- upvalues: BaseCamera (val)
    return BaseCamera.SetCameraToSubjectDistance(a1, a2)
end

function u34.Update(a1, a2) -- Line: 40 -- upvalues: Players (val), CameraInput (val) -- types: a1: table, a2: number
    local v1, v2
    if not a1.cameraType then
        return nil, nil
    end
    local v3 = tick()
    local v4 = v3 - a1.lastUpdate
    local CurrentCamera = workspace.CurrentCamera
    local CFrame_2 = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v5 = CameraInput.getRotation(a2)
    if a1.lastUpdate == nil or v4 > 1 then
        a1.lastDistanceToSubject = nil
    end
    local SubjectPosition = a1:GetSubjectPosition()
    if a1.cameraType == Enum.CameraType.Fixed then
        if SubjectPosition and LocalPlayer and CurrentCamera then
            local CameraToSubjectDistance = a1:GetCameraToSubjectDistance()
            v1 = a1:CalculateNewLookVectorFromArg(nil, v5)
            Focus = CurrentCamera.Focus
            CFrame_2 = CFrame.new(CurrentCamera.CFrame.p, CurrentCamera.CFrame.p + CameraToSubjectDistance * v1)
        end
        a1.lastUpdate = v3
        return CFrame_2, Focus
    end
    if a1.cameraType == Enum.CameraType.Attach then
        local SubjectCFrame = a1:GetSubjectCFrame()
        v1 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
        _, v2 = SubjectCFrame:ToEulerAnglesYXZ()
        v1 = math.clamp(v1 - v5.Y, -1.3962634015954636, 1.3962634015954636)
        Focus = (CFrame.new(SubjectCFrame.p)) * CFrame.fromEulerAnglesYXZ(v1, v2, 0)
        CFrame_2 = Focus * CFrame.new(0, 0, a1:StepZoom())
        a1.lastUpdate = v3
        return CFrame_2, Focus
    end
    if a1.cameraType ~= Enum.CameraType.Watch then
        return CurrentCamera.CFrame, CurrentCamera.Focus
    end
    if SubjectPosition and LocalPlayer and CurrentCamera then
        local unit = nil
        if SubjectPosition == CurrentCamera.CFrame.p then
            warn("Camera cannot watch subject in same position as itself")
            return CurrentCamera.CFrame, CurrentCamera.Focus
        end
        local Humanoid = a1:GetHumanoid()
        if Humanoid and Humanoid.RootPart then
            local v6 = SubjectPosition - CurrentCamera.CFrame.p
            unit = v6.unit
            if a1.lastDistanceToSubject and a1.lastDistanceToSubject == a1:GetCameraToSubjectDistance() then
                a1:SetCameraToSubjectDistance(v6.magnitude)
            end
        end
        local CameraToSubjectDistance_2 = a1:GetCameraToSubjectDistance()
        v2 = a1:CalculateNewLookVectorFromArg(unit, v5)
        Focus = CFrame.new(SubjectPosition)
        CFrame_2 = CFrame.new(SubjectPosition - CameraToSubjectDistance_2 * v2, SubjectPosition)
        a1.lastDistanceToSubject = CameraToSubjectDistance_2
    end
    a1.lastUpdate = v3
    return CFrame_2, Focus
end

return u34