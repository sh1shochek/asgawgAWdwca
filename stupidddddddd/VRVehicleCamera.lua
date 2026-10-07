-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera
-- Decompile time: 9.80 ms

local success, result = pcall(function() -- Line: 9
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local u5 = success and result
local u6 = {0, 30}
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
require(script.Parent:WaitForChild("VehicleCamera"))
local VehicleCameraCore = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local VehicleCameraConfig = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local LocalPlayer = Players.LocalPlayer
local Spring = CameraUtils.Spring
local mapClamp = CameraUtils.mapClamp
local sanitizeAngle = CameraUtils.sanitizeAngle

local function pitchVelocity(a1, a2) -- Line: 46
    return (math.abs((a2.XVector:Dot(a1))))
end

local function yawVelocity(a1, a2) -- Line: 51
    return (math.abs((a2.YVector:Dot(a1))))
end

local u86 = 0.016666666666666666
local u90 = setmetatable({}, VRBaseCamera)
u90.__index = u90

function u90.new() -- Line: 59 -- upvalues: VRBaseCamera (val), u90 (val), RunService (val), u86 (ref)
    local v1 = VRBaseCamera.new()
    local v2 = setmetatable(v1, u90)
    v2:Reset()
    RunService.Stepped:Connect(function(a1, a2) -- Line: 64 -- upvalues: u86 (upval)
        u86 = a2
    end)
    return v2
end

function u90:Reset() -- Line: 72
    -- upvalues: VehicleCameraCore (val), u5 (ref), Spring (val), VehicleCameraConfig (val), CameraUtils (val), u6 (val)
    self.vehicleCameraCore = VehicleCameraCore.new(self:GetSubjectCFrame())
    if not u5 then
        self.pitchSpring = Spring.new(0, -math.rad(VehicleCameraConfig.pitchBaseAngle))
    else
        self.pitchSpring = Spring.new(0, 0)
    end
    self.yawSpring = Spring.new(0, 0)
    if u5 then
        self.lastPanTick = 0
        self.currentDriftAngle = 0
        self.needsReset = true
    end
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(CameraSubject)
    assert((CameraSubject:IsA("VehicleSeat")))
    local v1, v2 = CameraUtils.getLooseBoundingSphere((CameraSubject:GetConnectedParts(true)))
    self.assemblyRadius = math.max(v2, 5)
    self.assemblyOffset = CameraSubject.CFrame:Inverse() * v1
    self.gamepadZoomLevels = {}
    for i, j in u6 do
        table.insert(self.gamepadZoomLevels, j * self.headScale * self.assemblyRadius / 10)
    end
    self.lastCameraFocus = nil
    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function u90:_StepRotation(a2, a3) -- Line: 112
    -- upvalues: sanitizeAngle (val), CameraInput (val), VehicleCameraConfig (val), mapClamp (val)
    local yawSpring = self.yawSpring
    local pitchSpring = self.pitchSpring
    yawSpring.pos = sanitizeAngle(yawSpring.pos + -(self:getRotation(a2)))
    pitchSpring.pos = sanitizeAngle((math.clamp(pitchSpring.pos, -1.3962634015954636, 1.3962634015954636)))
    if CameraInput.getRotationActivated() then
        self.lastPanTick = os.clock()
    end
    local v1 = math.rad(VehicleCameraConfig.pitchDeadzoneAngle)
    local v2 = os.clock() - self.lastPanTick
    if not (VehicleCameraConfig.autocorrectDelay < v2) then
        yawSpring.freq = 0
        yawSpring.vel = 0
        pitchSpring.freq = 0
        pitchSpring.vel = 0
        pitchSpring.goal = 0
    else
        v2 = mapClamp(
            a3,
            VehicleCameraConfig.autocorrectMinCarSpeed,
            VehicleCameraConfig.autocorrectMaxCarSpeed,
            0,
            VehicleCameraConfig.autocorrectResponse
        )
        yawSpring.freq = v2
        pitchSpring.freq = v2
        if yawSpring.freq < 0.001 then
            yawSpring.vel = 0
        end
        if pitchSpring.freq < 0.001 then
            pitchSpring.vel = 0
        end
        if not (math.abs((sanitizeAngle(0 - pitchSpring.pos))) <= v1) then
            pitchSpring.goal = 0
        else
            pitchSpring.goal = pitchSpring.pos
        end
    end
    return CFrame.fromEulerAnglesYXZ(pitchSpring:step(a2), yawSpring:step(a2), 0)
end

function u90:_GetThirdPersonLocalOffset() -- Line: 176 -- upvalues: VehicleCameraConfig (val)
    return self.assemblyOffset + Vector3.new(0, self.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function u90:_GetFirstPersonLocalOffset(a2) -- Line: 180
    -- upvalues: LocalPlayer (val)
    local Character = LocalPlayer.Character
    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")
        if Head and Head:IsA("BasePart") then
            return (a2:Inverse()) * Head.Position
        end
    end
    return self:_GetThirdPersonLocalOffset()
end

function u90.Update(a1) -- Line: 194 -- upvalues: u5 (ref), u86 (ref), LocalPlayer (val), VRService (val)
    local v1, v2
    if not u5 then
        return a1:UpdateComfortCamera()
    end
    local v3 = u86
    u86 = 0
    a1:UpdateFadeFromBlack(v3)
    a1:UpdateEdgeBlur(LocalPlayer, v3)
    if VRService.ThirdPersonFollowCamEnabled then
        v1, v2 = a1:UpdateStepRotation(v3)
        return v1, v2
    end
    v1, v2 = a1:UpdateComfortCamera(v3)
    return v1, v2
end

function u90:addDrift(a2, a3) -- Line: 217 -- upvalues: LocalPlayer (val), VRService (val)
    local function NormalizeAngle(a1) -- Line: 218
        local v1 = (a1 + 12.566370614359172) % 6.283185307179586
        if v1 > 3.141592653589793 then
            v1 = v1 - 6.283185307179586
        end
        return v1
    end

    local CurrentCamera = workspace.CurrentCamera
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local SubjectVelocity = self:GetSubjectVelocity()
    local SubjectCFrame = self:GetSubjectCFrame()
    require(LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    if 0.1 < SubjectVelocity.Magnitude then
        local v1, v2
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local v3 = CurrentCamera.CFrame * (UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale)
        _, v1 = v3:ToEulerAnglesYXZ()
        _, v2 = SubjectCFrame:ToEulerAnglesYXZ()
        local v4 = (v1 - self.currentDriftAngle + 12.566370614359172) % 6.283185307179586
        if v4 > 3.141592653589793 then
            v4 = v4 - 6.283185307179586
        end
        local v5 = (v2 - self.currentDriftAngle + 12.566370614359172) % 6.283185307179586
        if v5 > 3.141592653589793 then
            v5 = v5 - 6.283185307179586
        end
        local v6 = math.min(v5, v4)
        local v7 = math.max(v5, v4)
        local v8 = 0
        if v6 > 0 then
            v8 = v6
        elseif v7 < 0 then
            v8 = v7
        end
        self.currentDriftAngle = v8 + self.currentDriftAngle
        local LookVector = CFrame.fromEulerAnglesYXZ(0, self.currentDriftAngle, 0).LookVector
        a2 = a2:Lerp(
            (CFrame.new(CurrentCamera.CFrame.Position + (a3.Position - (Vector3.new(LookVector.X, 0, LookVector.Z)).Unit * CameraToSubjectDistance) - v3.Position)) * CurrentCamera.CFrame.Rotation,
            0.01
        )
    end
    return a2, a3
end

function u90.UpdateRotationCamera(a1, a2) -- Line: 275 -- upvalues: mapClamp (val), LocalPlayer (val)
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    local vehicleCameraCore = a1.vehicleCameraCore
    assert(CurrentCamera)
    assert(CameraSubject)
    assert((CameraSubject:IsA("VehicleSeat")))
    local SubjectCFrame = a1:GetSubjectCFrame()
    local SubjectVelocity = a1:GetSubjectVelocity()
    local SubjectRotVelocity = a1:GetSubjectRotVelocity()
    local v1 = math.abs((SubjectVelocity:Dot(SubjectCFrame.ZVector)))
    local v2 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))
    local v3 = math.abs((SubjectCFrame.XVector:Dot(SubjectRotVelocity)))
    local CameraToSubjectDistance = a1:GetCameraToSubjectDistance()
    local v4 = mapClamp(CameraToSubjectDistance, 0.5, a1.assemblyRadius, 1, 0)
    local v5 = (a1:_GetThirdPersonLocalOffset()):Lerp(a1:_GetFirstPersonLocalOffset(SubjectCFrame), v4)
    vehicleCameraCore:setTransform(SubjectCFrame)
    local v6 = vehicleCameraCore:step(a2, v3, v2, v4)
    local v7 = a1:_StepRotation(a2, v1)
    local v8 = a1:GetVRFocus(SubjectCFrame * v5, a2) * v6 * v7
    local v9 = v8 * CFrame.new(0, 0, CameraToSubjectDistance)
    if 0.1 < SubjectVelocity.Magnitude then
        a1:StartVREdgeBlur(LocalPlayer)
    end
    return v9, v8
end

function u90:UpdateStepRotation(a2) -- Line: 322
    -- upvalues: mapClamp (val), UserGameSettings (val), VRService (val), LocalPlayer (val)
    local CurrentCamera = workspace.CurrentCamera
    local lastSubjectCFrame = self.lastSubjectCFrame
    local SubjectCFrame = self:GetSubjectCFrame()
    local SubjectVelocity = self:GetSubjectVelocity()
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local v1 = mapClamp(CameraToSubjectDistance, 0.5, self.assemblyRadius, 1, 0)
    local v2 = (self:_GetThirdPersonLocalOffset()):Lerp(self:_GetFirstPersonLocalOffset(SubjectCFrame), v1)
    local v3 = self:GetVRFocus(SubjectCFrame * v2, a2)
    local v4, v5 = self:addDrift(v3:ToWorldSpace(((self:GetVRFocus(lastSubjectCFrame * v2, a2)):ToObjectSpace(CurrentCamera.CFrame))), v3)
    local v6 = v4
    v3 = v5
    v4 = self:getRotation(a2)
    v5 = math.abs(v4)
    if v5 > 0 then
        v5 = v3:ToObjectSpace(v6)
        local v7 = v3 * CFrame.Angles(0, -v4, 0) * v5
        if not UserGameSettings.VRSmoothRotationEnabled then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v8 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local v9 = v3 * SubjectCFrame.Rotation
            local v10 = v9:ToObjectSpace(v6 * v8)
            local v11 = math.acos((Vector3.new(v10.X, 0, v10.Z).Unit:Dot((Vector3.new(0, 0, 1)))))
            local v12 = v9:ToObjectSpace(v7 * v8)
            if math.acos((Vector3.new(v12.X, 0, v12.Z).Unit:Dot((Vector3.new(0, 0, 1))))) < v11 then
                if v4 < 0 then
                    v11 = v11 * -1
                end
                v7 = v3 * CFrame.Angles(0, -v11, 0) * v5
            end
        end
        v6 = v7
    end
    if 0.1 < SubjectVelocity.Magnitude then
        self:StartVREdgeBlur(LocalPlayer)
    end
    if self.needsReset then
        self.needsReset = false
        VRService:RecenterUserHeadCFrame()
        self:StartFadeFromBlack()
        self:ResetZoom()
    end
    if self.recentered then
        v3 = v3 * SubjectCFrame.Rotation
        v6 = v3 * CFrame.new(0, 0, CameraToSubjectDistance)
        self.recentered = false
    end
    return v6, v6 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

function u90:UpdateComfortCamera(a2) -- Line: 408 -- upvalues: u5 (ref), u86 (ref), mapClamp (val), LocalPlayer (val)
    local lastCameraFocus, v1, v2
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    local vehicleCameraCore = self.vehicleCameraCore
    assert(CurrentCamera)
    assert(CameraSubject)
    assert((CameraSubject:IsA("VehicleSeat")))
    if u5 then
        v1 = a2
    else
        v1 = u86
        u86 = 0
    end
    local SubjectCFrame = self:GetSubjectCFrame()
    local SubjectVelocity = self:GetSubjectVelocity()
    local SubjectRotVelocity = self:GetSubjectRotVelocity()
    math.abs((SubjectVelocity:Dot(SubjectCFrame.ZVector)))
    local v3 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))
    local v4 = math.abs((SubjectCFrame.XVector:Dot(SubjectRotVelocity)))
    local v5 = self:StepZoom()
    local v6 = mapClamp(v5, 0.5, self.assemblyRadius, 1, 0)
    local v7 = (self:_GetThirdPersonLocalOffset()):Lerp(self:_GetFirstPersonLocalOffset(SubjectCFrame), v6)
    vehicleCameraCore:setTransform(SubjectCFrame)
    local v8 = vehicleCameraCore:step(v1, v4, v3, v6)
    if not u5 then
        self:UpdateFadeFromBlack(v1)
    end
    if self:IsInFirstPerson() then
        local v9 = CFrame.new(v8.Position, (Vector3.new(v8.LookVector.X, 0, v8.LookVector.Z)).Unit)
        lastCameraFocus = CFrame.new(SubjectCFrame * v7) * v9
        v2 = lastCameraFocus * CFrame.new(0, 0, v5)
        if not u5 or 0.1 < SubjectVelocity.Magnitude then
            self:StartVREdgeBlur(LocalPlayer)
        end
    else
        lastCameraFocus = CFrame.new(SubjectCFrame * v7) * v8
        v2 = lastCameraFocus * CFrame.new(0, 0, v5)
        if not self.lastCameraFocus then
            self.lastCameraFocus = lastCameraFocus
            self.needsReset = true
        end
        local v10 = lastCameraFocus.Position - CurrentCamera.CFrame.Position
        local magnitude = v10.magnitude
        if not (0.56 < (v10.Unit:Dot(CurrentCamera.CFrame.LookVector)))
            or not (magnitude < 200)
            or self.needsReset then
            self.lastCameraFocus = self:GetVRFocus(SubjectCFrame.Position, v1)
            self.needsReset = false
            self:StartFadeFromBlack()
            self:ResetZoom()
        else
            local p = self.lastCameraFocus.p
            local CameraLookVector = self:GetCameraLookVector()
            v2 = CFrame.new(
                p - v5 * (self:CalculateNewLookVectorFromArg((Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z)).Unit, (Vector2.new(0, 0)))),
                p
            )
        end
        if not u5 then
            self:UpdateEdgeBlur(LocalPlayer, v1)
        end
    end
    return v2, lastCameraFocus
end

return u90