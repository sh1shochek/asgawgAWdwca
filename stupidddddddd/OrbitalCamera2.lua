-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.OrbitalCamera
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.OrbitalCamera
-- Decompile time: 4.38 ms

local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local u43 = setmetatable({}, BaseCamera)
u43.__index = u43

function u43.new() -- Line: 42 -- upvalues: BaseCamera (val), u43 (val)
    local v1 = BaseCamera.new()
    local v2 = setmetatable(v1, u43)
    v2.lastUpdate = tick()
    v2.changedSignalConnections = {}
    v2.refAzimuthRad = nil
    v2.curAzimuthRad = nil
    v2.minAzimuthAbsoluteRad = nil
    v2.maxAzimuthAbsoluteRad = nil
    v2.useAzimuthLimits = nil
    v2.curElevationRad = nil
    v2.minElevationRad = nil
    v2.maxElevationRad = nil
    v2.curDistance = nil
    v2.minDistance = nil
    v2.maxDistance = nil
    v2.gamepadDollySpeedMultiplier = 1
    v2.lastUserPanCamera = tick()
    v2.externalProperties = {}
    v2.externalProperties.InitialDistance = 25
    v2.externalProperties.MinDistance = 10
    v2.externalProperties.MaxDistance = 100
    v2.externalProperties.InitialElevation = 35
    v2.externalProperties.MinElevation = 35
    v2.externalProperties.MaxElevation = 35
    v2.externalProperties.ReferenceAzimuth = -45
    v2.externalProperties.CWAzimuthTravel = 90
    v2.externalProperties.CCWAzimuthTravel = 90
    v2.externalProperties.UseAzimuthLimits = false
    v2:LoadNumberValueParameters()
    return v2
end

function u43:LoadOrCreateNumberValueParameter(a2, a3, a4) -- Line: 81 -- types: self: table, a2: string
    local v1 = script:FindFirstChild(a2)
    if v1 and v1:IsA(a3) then
        self.externalProperties[a2] = v1.Value
        if a4 then
            if self.changedSignalConnections[a2] then
                self.changedSignalConnections[a2]:Disconnect()
            end
            self.changedSignalConnections[a2] = (v1.Changed:Connect(function(a1) -- Line: 101 -- upvalues: self (val), a2 (val), a4 (val)
                self.externalProperties[a2] = a1
                a4(self)
            end))
        end
        return
    end
    if self.externalProperties[a2] == nil then
        return
    end
    v1 = Instance.new(a3)
    v1.Name = a2
    v1.Parent = script
    v1.Value = self.externalProperties[a2]
    if a4 then
        if self.changedSignalConnections[a2] then
            self.changedSignalConnections[a2]:Disconnect()
        end
        self.changedSignalConnections[a2] = (v1.Changed:Connect(function(a1) -- Line: 101 -- upvalues: self (val), a2 (val), a4 (val)
            self.externalProperties[a2] = a1
            a4(self)
        end))
    end
end

function u43:SetAndBoundsCheckAzimuthValues() -- Line: 108
    self.minAzimuthAbsoluteRad = (math.rad(self.externalProperties.ReferenceAzimuth)) - math.abs((math.rad(self.externalProperties.CWAzimuthTravel)))
    self.maxAzimuthAbsoluteRad = (math.rad(self.externalProperties.ReferenceAzimuth)) + math.abs((math.rad(self.externalProperties.CCWAzimuthTravel)))
    self.useAzimuthLimits = self.externalProperties.UseAzimuthLimits
    if self.useAzimuthLimits then
        self.curAzimuthRad = math.max(self.curAzimuthRad, self.minAzimuthAbsoluteRad)
        self.curAzimuthRad = math.min(self.curAzimuthRad, self.maxAzimuthAbsoluteRad)
    end
end

function u43:SetAndBoundsCheckElevationValues() -- Line: 118
    local v1 = math.max(self.externalProperties.MinElevation, -80)
    local v2 = math.min(self.externalProperties.MaxElevation, 80)
    self.minElevationRad = math.rad((math.min(v1, v2)))
    self.maxElevationRad = math.rad((math.max(v1, v2)))
    self.curElevationRad = math.max(self.curElevationRad, self.minElevationRad)
    self.curElevationRad = math.min(self.curElevationRad, self.maxElevationRad)
end

function u43:SetAndBoundsCheckDistanceValues() -- Line: 134
    self.minDistance = self.externalProperties.MinDistance
    self.maxDistance = self.externalProperties.MaxDistance
    self.curDistance = math.max(self.curDistance, self.minDistance)
    self.curDistance = math.min(self.curDistance, self.maxDistance)
end

function u43:LoadNumberValueParameters() -- Line: 142
    self:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    self:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    self:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", self.SetAndBoundsCheckAzimuthValue)
    self:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
    self:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
    self:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
    self:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
    self:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
    self:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
    self:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", self.SetAndBoundsCheckAzimuthValues)
    self.curAzimuthRad = math.rad(self.externalProperties.ReferenceAzimuth)
    self.curElevationRad = math.rad(self.externalProperties.InitialElevation)
    self.curDistance = self.externalProperties.InitialDistance
    self:SetAndBoundsCheckAzimuthValues()
    self:SetAndBoundsCheckElevationValues()
    self:SetAndBoundsCheckDistanceValues()
end

function u43.GetModuleName(a1) -- Line: 167
    return "OrbitalCamera"
end

function u43.SetInitialOrientation(a1, a2) -- Line: 171 -- upvalues: CameraUtils (val) -- types: a1: table, a2: userdata
    if a2 and a2.RootPart then
        assert(a2.RootPart, "")
        local Unit = (a2.RootPart.CFrame.LookVector - Vector3.new(0, 0.23000000417232513, 0)).Unit
        local v1 = CameraUtils.GetAngleBetweenXZVectors(Unit, a1:GetCameraLookVector())
        local v2 = (math.asin((a1:GetCameraLookVector()).Y)) - math.asin(Unit.Y)
        if CameraUtils.IsFinite(v1) then end
        if CameraUtils.IsFinite(v2) then end
        return
    end
    warn("OrbitalCamera could not set initial orientation due to missing humanoid")
end

function u43.GetCameraToSubjectDistance(a1) -- Line: 189
    return a1.curDistance
end

function u43:SetCameraToSubjectDistance(a2) -- Line: 193 -- upvalues: Players (val)
    if Players.LocalPlayer then
        self.currentSubjectDistance = math.clamp(a2, self.minDistance, self.maxDistance)
        self.currentSubjectDistance = math.max(self.currentSubjectDistance, self.FIRST_PERSON_DISTANCE_THRESHOLD)
    end
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
    return self.currentSubjectDistance
end

function u43.CalculateNewLookVector(a1, a2, a3) -- Line: 206 -- types: a1: table, a2: vector, a3: userdata
    local CameraLookVector = a2 or a1:GetCameraLookVector()
    local v1 = math.asin(CameraLookVector.Y)
    local v2 = Vector2.new(a3.X, (math.clamp(a3.Y, v1 - 1.3962634015954636, v1 - -1.3962634015954636)))
    local v3 = CFrame.new(Vector3.new(0, 0, 0), CameraLookVector)
    return (CFrame.Angles(0, -v2.X, 0) * v3 * CFrame.Angles(-v2.Y, 0, 0)).LookVector
end

function u43.Update(a1, a2) -- Line: 217 -- upvalues: CameraInput (val), Players (val) -- types: a1: table, a2: number
    local v1 = tick()
    local v2 = v1 - a1.lastUpdate
    local v3 = (CameraInput.getRotation(a2)) ~= Vector2.new()
    local CurrentCamera = workspace.CurrentCamera
    local CFrame_2 = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    local v4 = CameraSubject and CameraSubject:IsA("VehicleSeat")
    local v5 = CameraSubject and CameraSubject:IsA("SkateboardPlatform")
    if a1.lastUpdate == nil or v2 > 1 then
        a1.lastCameraTransform = nil
    end
    if v3 then
        a1.lastUserPanCamera = tick()
    end
    local SubjectPosition = a1:GetSubjectPosition()
    if SubjectPosition and LocalPlayer and CurrentCamera then
        if a1.gamepadDollySpeedMultiplier ~= 1 then
            a1:SetCameraToSubjectDistance(a1.currentSubjectDistance * a1.gamepadDollySpeedMultiplier)
        end
        Focus = CFrame.new(SubjectPosition)
        local v6 = CameraInput.getRotation(a2)
        a1.curAzimuthRad = a1.curAzimuthRad - v6.X
        if not a1.useAzimuthLimits then
            local v7 = a1.curAzimuthRad ~= 0 and (math.sign(a1.curAzimuthRad)) * (math.abs(a1.curAzimuthRad) % 6.283185307179586) or 0
            a1.curAzimuthRad = v7
        else
            a1.curAzimuthRad = math.clamp(a1.curAzimuthRad, a1.minAzimuthAbsoluteRad, a1.maxAzimuthAbsoluteRad)
        end
        a1.curElevationRad = math.clamp(a1.curElevationRad + v6.Y, a1.minElevationRad, a1.maxElevationRad)
        a1.lastCameraTransform = (CFrame.new(
            SubjectPosition + a1.currentSubjectDistance * ((CFrame.fromEulerAnglesYXZ(-a1.curElevationRad, a1.curAzimuthRad, 0)) * Vector3.new(0, 0, 1)),
            SubjectPosition
        ))
        a1.lastCameraFocus = Focus
        if v4 then
            if not CameraSubject:IsA("BasePart") then
                a1.lastSubjectCFrame = nil
            else
                a1.lastSubjectCFrame = CameraSubject.CFrame
            end
        elseif not v5 or not CameraSubject:IsA("BasePart") then
            a1.lastSubjectCFrame = nil
        else
            a1.lastSubjectCFrame = CameraSubject.CFrame
        end
    end
    a1.lastUpdate = v1
    return CFrame_2, Focus
end

return u43