-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.BaseCamera
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule.BaseCamera
-- Decompile time: 10.52 ms

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local LocalPlayer = Players.LocalPlayer
local success, result = pcall(function() -- Line: 24
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end)
local u86 = success and result
local UserFixCameraCameraCharacterUpdates = FlagUtil.getUserFlag("UserFixCameraCameraCharacterUpdates")
Vector2.new(0, 0)
local u95 = {}
u95.__index = u95

function u95.new() -- Line: 83
    -- upvalues: u95 (val), ConnectionUtil (val), LocalPlayer (val), UserFixCameraCameraCharacterUpdates (val)
    -- upvalues: UserGameSettings (val)
    local v1 = setmetatable({}, u95)
    v1._connections = ConnectionUtil.new()
    v1.gamepadZoomLevels = {0, 10, 20}
    v1.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    v1.cameraType = nil
    v1.cameraMovementMode = nil
    v1.lastCameraTransform = nil
    v1.lastUserPanCamera = tick()
    v1.humanoidRootPart = nil
    v1.humanoidCache = {}
    v1.lastSubject = nil
    v1.lastSubjectPosition = Vector3.new(0, 5, 0)
    v1.lastSubjectCFrame = CFrame.new(v1.lastSubjectPosition)
    v1.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)
    v1.inFirstPerson = false
    v1.inMouseLockedMode = false
    v1.portraitMode = false
    v1.isSmallTouchScreen = false
    v1.resetCameraAngle = true
    v1.enabled = false
    if not UserFixCameraCameraCharacterUpdates then
        v1.PlayerGui = nil
    end
    v1.cameraChangedConn = nil
    v1.viewportSizeChangedConn = nil
    v1.shouldUseVRRotation = false
    v1.VRRotationIntensityAvailable = false
    v1.lastVRRotationIntensityCheckTime = 0
    v1.lastVRRotationTime = 0
    v1.vrRotateKeyCooldown = {}
    v1.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    v1.humanoidJumpOrigin = nil
    v1.trackingHumanoid = nil
    v1.cameraFrozen = false
    v1.subjectStateChangedConn = nil
    v1.gamepadZoomPressConnection = nil
    v1.mouseLockOffset = Vector3.new(0, 0, 0)
    UserGameSettings:SetCameraYInvertVisible()
    UserGameSettings:SetGamepadCameraSensitivityVisible()
    return v1
end

function u95.GetModuleName(a1) -- Line: 152
    return "BaseCamera"
end

function u95:_setUpConfigurations() -- Line: 156
    -- upvalues: LocalPlayer (val), UserFixCameraCameraCharacterUpdates (val)
    self._connections:trackConnection("CHARACTER_ADDED", (LocalPlayer.CharacterAdded:Connect(function(a1) -- Line: 159 -- upvalues: self (val)
        self:OnCharacterAdded(a1)
    end)))
    if UserFixCameraCameraCharacterUpdates then
        self.humanoidRootPart = nil
    elseif LocalPlayer.Character then
        self:OnCharacterAdded(LocalPlayer.Character)
    end
    self._connections:trackConnection("CAMERA_MODE_CHANGED", ((LocalPlayer:GetPropertyChangedSignal("CameraMode")):Connect(function() -- Line: 173 -- upvalues: self (val)
        self:OnPlayerCameraPropertyChange()
    end)))
    self._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", ((LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance")):Connect(function() -- Line: 179 -- upvalues: self (val)
        self:OnPlayerCameraPropertyChange()
    end)))
    self._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", ((LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance")):Connect(function() -- Line: 185 -- upvalues: self (val)
        self:OnPlayerCameraPropertyChange()
    end)))
    self:OnPlayerCameraPropertyChange()
end

function u95:OnCharacterAdded(a2) -- Line: 192
    -- upvalues: UserFixCameraCameraCharacterUpdates (val), UserInputService (val), LocalPlayer (val)
    local resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
    self.resetCameraAngle = resetCameraAngle
    self.humanoidRootPart = nil
    if not UserFixCameraCameraCharacterUpdates and UserInputService.TouchEnabled then
        self.PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        for i, v in ipairs(a2:GetChildren()) do
            if v:IsA("Tool") then
                self.isAToolEquipped = true
            end
        end
        self._connections:trackConnection("char.ChildAdded", (a2.ChildAdded:Connect(function(a1) -- Line: 207 -- upvalues: self (val)
            if a1:IsA("Tool") then
                self.isAToolEquipped = true
            end
        end)))
        self._connections:trackConnection("char.ChildRemoved", (a2.ChildRemoved:Connect(function(a1) -- Line: 215 -- upvalues: self (val)
            if a1:IsA("Tool") then
                self.isAToolEquipped = false
            end
        end)))
    end
end

function u95.GetHumanoidRootPart(a1) -- Line: 225 -- upvalues: LocalPlayer (val)
    if not a1.humanoidRootPart and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            a1.humanoidRootPart = Humanoid.RootPart
        end
    end
    return a1.humanoidRootPart
end

function u95.GetBodyPartToFollow(a1, a2, a3) -- Line: 237 -- types: a1: table, a2: userdata, a3: boolean
    if (a2:GetState()) == Enum.HumanoidStateType.Dead then
        local Parent = a2.Parent
        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or a2.RootPart
        end
    end
    return a2.RootPart
end

function u95.GetSubjectCFrame(a1) -- Line: 249
    local lastSubjectCFrame = a1.lastSubjectCFrame
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    if not CameraSubject then
        return lastSubjectCFrame
    end
    if CameraSubject:IsA("Humanoid") then
        local v1 = (CameraSubject:GetState()) == Enum.HumanoidStateType.Dead
        local CameraOffset = CameraSubject.CameraOffset
        if a1:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end
        local RootPart = CameraSubject.RootPart
        if v1 and CameraSubject.Parent and CameraSubject.Parent:IsA("Model") then
            RootPart = CameraSubject.Parent:FindFirstChild("Head") or RootPart
        end
        if RootPart and RootPart:IsA("BasePart") then
            local v2
            if CameraSubject.RigType ~= Enum.HumanoidRigType.R15 then
                v2 = Vector3.new(0, 1.5, 0)
            elseif not CameraSubject.AutomaticScalingEnabled then
                v2 = Vector3.new(0, 2, 0)
            else
                v2 = Vector3.new(0, 1.5, 0)
                local RootPart_2 = CameraSubject.RootPart
                if RootPart == RootPart_2 then
                    v2 = v2 + Vector3.new(0, (RootPart_2.Size.Y - 2) / 2, 0)
                end
            end
            if v1 then
                v2 = Vector3.new(0, 0, 0)
            end
            lastSubjectCFrame = RootPart.CFrame * CFrame.new(v2 + CameraOffset)
        end
    elseif CameraSubject:IsA("BasePart") then
        lastSubjectCFrame = CameraSubject.CFrame
    elseif CameraSubject:IsA("Model") then
        lastSubjectCFrame = if not CameraSubject.PrimaryPart then CFrame.new() else CameraSubject:GetPrimaryPartCFrame()
    end
    if lastSubjectCFrame then
        a1.lastSubjectCFrame = lastSubjectCFrame
    end
    return lastSubjectCFrame
end

function u95.GetSubjectVelocity(a1) -- Line: 320
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    if not CameraSubject then
        return (Vector3.new(0, 0, 0))
    end
    if CameraSubject:IsA("BasePart") then
        return CameraSubject.Velocity
    end
    if CameraSubject:IsA("Humanoid") then
        local RootPart = CameraSubject.RootPart
        if RootPart then
            return RootPart.Velocity
        end
        return (Vector3.new(0, 0, 0))
    end
    if CameraSubject:IsA("Model") then
        local PrimaryPart = CameraSubject.PrimaryPart
        if PrimaryPart then
            return PrimaryPart.Velocity
        end
    end
    return (Vector3.new(0, 0, 0))
end

function u95.GetSubjectRotVelocity(a1) -- Line: 347
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    if not CameraSubject then
        return (Vector3.new(0, 0, 0))
    end
    if CameraSubject:IsA("BasePart") then
        return CameraSubject.RotVelocity
    end
    if CameraSubject:IsA("Humanoid") then
        local RootPart = CameraSubject.RootPart
        if RootPart then
            return RootPart.RotVelocity
        end
        return (Vector3.new(0, 0, 0))
    end
    if CameraSubject:IsA("Model") then
        local PrimaryPart = CameraSubject.PrimaryPart
        if PrimaryPart then
            return PrimaryPart.RotVelocity
        end
    end
    return (Vector3.new(0, 0, 0))
end

function u95.StepZoom(a1) -- Line: 374 -- upvalues: CameraInput (val), ZoomController (val)
    local currentSubjectDistance = a1.currentSubjectDistance
    local v1 = CameraInput.getZoomDelta()
    local v2 = math.abs(v1)
    if v2 > 0 then
        v2 = if not (v1 > 0) then math.max((currentSubjectDistance + v1) / (1 - v1 * 0.5), 0) else math.max(currentSubjectDistance + v1 * (currentSubjectDistance * 0.5 + 1), a1.FIRST_PERSON_DISTANCE_THRESHOLD)
        if v2 < a1.FIRST_PERSON_DISTANCE_THRESHOLD then
            v2 = 0
        end
        a1:SetCameraToSubjectDistance(v2)
    end
    return ZoomController.GetZoomRadius()
end

function u95:GetSubjectPosition() -- Line: 399
    local lastSubjectPosition = self.lastSubjectPosition
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera and CurrentCamera.CameraSubject
    if not CameraSubject then
        return nil
    end
    if CameraSubject:IsA("Humanoid") then
        local v1 = (CameraSubject:GetState()) == Enum.HumanoidStateType.Dead
        local CameraOffset = CameraSubject.CameraOffset
        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end
        local RootPart = CameraSubject.RootPart
        if v1 and CameraSubject.Parent and CameraSubject.Parent:IsA("Model") then
            RootPart = CameraSubject.Parent:FindFirstChild("Head") or RootPart
        end
        if RootPart and RootPart:IsA("BasePart") then
            local v2
            if CameraSubject.RigType ~= Enum.HumanoidRigType.R15 then
                v2 = Vector3.new(0, 1.5, 0)
            elseif not CameraSubject.AutomaticScalingEnabled then
                v2 = Vector3.new(0, 2, 0)
            else
                v2 = Vector3.new(0, 1.5, 0)
                if RootPart == CameraSubject.RootPart then
                    v2 = v2 + Vector3.new(0, CameraSubject.RootPart.Size.Y / 2 - 1, 0)
                end
            end
            if v1 then
                v2 = Vector3.new(0, 0, 0)
            end
            lastSubjectPosition = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace(v2 + CameraOffset)
        end
    elseif CameraSubject:IsA("VehicleSeat") then
        lastSubjectPosition = CameraSubject.CFrame.p + CameraSubject.CFrame:vectorToWorldSpace((Vector3.new(0, 5, 0)))
    elseif CameraSubject:IsA("SkateboardPlatform") then
        lastSubjectPosition = CameraSubject.CFrame.p + Vector3.new(0, 5, 0)
    elseif CameraSubject:IsA("BasePart") then
        lastSubjectPosition = CameraSubject.CFrame.p
    elseif CameraSubject:IsA("Model") then
        lastSubjectPosition = if not CameraSubject.PrimaryPart then CameraSubject:GetModelCFrame().p else CameraSubject:GetPrimaryPartCFrame().p
    end
    self.lastSubject = CameraSubject
    self.lastSubjectPosition = lastSubjectPosition
    return lastSubjectPosition
end

function u95:OnViewportSizeChanged() -- Line: 476 -- upvalues: UserInputService (val)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    self.portraitMode = ViewportSize.X < ViewportSize.Y
    local TouchEnabled = UserInputService.TouchEnabled
    if TouchEnabled then
        TouchEnabled = true
        if not (ViewportSize.Y < 500) then
            TouchEnabled = ViewportSize.X < 700
        end
    end
    self.isSmallTouchScreen = TouchEnabled
end

function u95:OnCurrentCameraChanged() -- Line: 484 -- upvalues: UserInputService (val)
    if UserInputService.TouchEnabled then
        if self.viewportSizeChangedConn then
            self.viewportSizeChangedConn:Disconnect()
            self.viewportSizeChangedConn = nil
        end
        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera then
            self:OnViewportSizeChanged()
            self.viewportSizeChangedConn = (CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(function() -- Line: 495 -- upvalues: self (val)
                self:OnViewportSizeChanged()
            end)
        end
    end
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
        self.cameraSubjectChangedConn = nil
    end
    local CurrentCamera_2 = workspace.CurrentCamera
    if CurrentCamera_2 then
        self.cameraSubjectChangedConn = (CurrentCamera_2:GetPropertyChangedSignal("CameraSubject")):Connect(function() -- Line: 509 -- upvalues: self (val)
            self:OnNewCameraSubject()
        end)
        self:OnNewCameraSubject()
    end
end

function u95:OnPlayerCameraPropertyChange() -- Line: 516
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function u95.InputTranslationToCameraAngleChange(a1, a2, a3) -- Line: 521
    return a2 * a3
end

function u95:GamepadZoomPress() -- Line: 527 -- upvalues: LocalPlayer (val), u86 (ref)
    local CameraMinZoomDistance
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
    for i = #self.gamepadZoomLevels, 1, -1 do
        CameraMinZoomDistance = self.gamepadZoomLevels[i]
        if not (CameraMaxZoomDistance < CameraMinZoomDistance) then
            if CameraMinZoomDistance < LocalPlayer.CameraMinZoomDistance then
                CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
                if u86 and CameraMaxZoomDistance == CameraMinZoomDistance then
                    break
                end
            end
            if not u86 and CameraMaxZoomDistance == CameraMinZoomDistance then
                break
            end
            if CameraMinZoomDistance + (CameraMaxZoomDistance - CameraMinZoomDistance) / 2 < CameraToSubjectDistance then
                self:SetCameraToSubjectDistance(CameraMinZoomDistance)
                return
            end
        end
    end
    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function u95.Enable(a1, a2) -- Line: 572 -- types: a1: table, a2: boolean
    if a1.enabled ~= a2 then
        a1.enabled = a2
        a1:OnEnabledChanged()
    end
end

function u95:OnEnabledChanged() -- Line: 580 -- upvalues: CameraInput (val), LocalPlayer (val)
    if not self.enabled then
        self._connections:disconnectAll()
        CameraInput.setInputEnabled(false)
        if self.gamepadZoomPressConnection then
            self.gamepadZoomPressConnection:Disconnect()
            self.gamepadZoomPressConnection = nil
        end
        self:Cleanup()
        return
    end
    self:_setUpConfigurations()
    CameraInput.setInputEnabled(true)
    self.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- Line: 586 -- upvalues: self (val)
        self:GamepadZoomPress()
    end)
    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        self.currentSubjectDistance = 0
        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    end
    if self.cameraChangedConn then
        self.cameraChangedConn:Disconnect()
        self.cameraChangedConn = nil
    end
    self.cameraChangedConn = (workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 601 -- upvalues: self (val)
        self:OnCurrentCameraChanged()
    end)
    self:OnCurrentCameraChanged()
end

function u95:GetEnabled() -- Line: 619
    return self.enabled
end

function u95:Cleanup() -- Line: 623 -- upvalues: CameraUtils (val)
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
    if self.viewportSizeChangedConn then
        self.viewportSizeChangedConn:Disconnect()
        self.viewportSizeChangedConn = nil
    end
    if self.cameraChangedConn then
        self.cameraChangedConn:Disconnect()
        self.cameraChangedConn = nil
    end
    self.lastCameraTransform = nil
    self.lastSubjectCFrame = nil
    CameraUtils.restoreMouseBehavior()
end

function u95:UpdateMouseBehavior() -- Line: 644
    -- upvalues: UserGameSettings (val), CameraUI (val), CameraInput (val), CameraToggleStateController (val)
    -- upvalues: CameraUtils (val)
    local v1 = UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    if self.isCameraToggle and not v1 then
        CameraUI.setCameraModeToastEnabled(true)
        CameraInput.enableCameraToggleInput()
        CameraToggleStateController(self.inFirstPerson)
        return
    end
    CameraUI.setCameraModeToastEnabled(false)
    CameraInput.disableCameraToggleInput()
    if not self.inFirstPerson and not self.inMouseLockedMode then
        CameraUtils.restoreRotationType()
        if CameraInput.getRotationActivated() then
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
            return
        end
        CameraUtils.restoreMouseBehavior()
        return
    end
    CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
    CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
end

function u95.UpdateForDistancePropertyChange(a1) -- Line: 672
    a1:SetCameraToSubjectDistance(a1.currentSubjectDistance)
end

function u95:SetCameraToSubjectDistance(a2) -- Line: 678
    -- upvalues: LocalPlayer (val), ZoomController (val)
    local currentSubjectDistance = self.currentSubjectDistance
    if LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
        local v1 = math.clamp(a2, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)
        if not (v1 < 1) then
            self.currentSubjectDistance = v1
            if self.inFirstPerson then
                self:LeaveFirstPerson()
            end
        else
            self.currentSubjectDistance = 0
            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        end
    else
        self.currentSubjectDistance = 0
        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    end
    ZoomController.SetZoomParameters(self.currentSubjectDistance, (math.sign(a2 - currentSubjectDistance)))
    return self.currentSubjectDistance
end

function u95.SetCameraType(a1, a2) -- Line: 716
    a1.cameraType = a2
end

function u95.GetCameraType(a1) -- Line: 721
    return a1.cameraType
end

function u95.SetCameraMovementMode(a1, a2) -- Line: 726
    a1.cameraMovementMode = a2
end

function u95.GetCameraMovementMode(a1) -- Line: 730
    return a1.cameraMovementMode
end

function u95.SetIsMouseLocked(a1, a2) -- Line: 734 -- types: a1: table, a2: boolean
    a1.inMouseLockedMode = a2
end

function u95:GetIsMouseLocked() -- Line: 738
    return self.inMouseLockedMode
end

function u95.SetMouseLockOffset(a1, a2) -- Line: 742
    a1.mouseLockOffset = a2
end

function u95.GetMouseLockOffset(a1) -- Line: 746
    return a1.mouseLockOffset
end

function u95.InFirstPerson(a1) -- Line: 750
    return a1.inFirstPerson
end

function u95:EnterFirstPerson() -- Line: 754
    self.inFirstPerson = true
    self:UpdateMouseBehavior()
end

function u95:LeaveFirstPerson() -- Line: 759
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
end

function u95:GetCameraToSubjectDistance() -- Line: 765
    return self.currentSubjectDistance
end

function u95.GetMeasuredDistanceToFocus(a1) -- Line: 772
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        return (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude
    end
    return nil
end

function u95.GetCameraLookVector(a1) -- Line: 780
    return workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function u95:CalculateNewLookCFrameFromArg(a2, a3) -- Line: 784 -- types: self: table, a2: vector?, a3: userdata
    local CameraLookVector = a2 or self:GetCameraLookVector()
    local v1 = math.asin(CameraLookVector.Y)
    local v2 = Vector2.new(a3.X, (math.clamp(a3.Y, v1 + -1.3962634015954636, v1 + 1.3962634015954636)))
    local v3 = CFrame.new(Vector3.new(0, 0, 0), CameraLookVector)
    return CFrame.Angles(0, -v2.X, 0) * v3 * CFrame.Angles(-v2.Y, 0, 0)
end

function u95.CalculateNewLookVectorFromArg(a1, a2, a3) -- Line: 796 -- types: a1: table, a2: vector?, a3: userdata
    return a1:CalculateNewLookCFrameFromArg(a2, a3).LookVector
end

function u95.CalculateNewLookVectorVRFromArg(a1, a2) -- Line: 801 -- types: a1: table, a2: userdata
    local unit = (((a1:GetSubjectPosition()) - workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    local v1 = Vector2.new(a2.X, 0)
    local v2 = CFrame.new(Vector3.new(0, 0, 0), unit)
    return ((CFrame.Angles(0, -v1.X, 0) * v2 * CFrame.Angles(-v1.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

function u95.GetHumanoid(a1) -- Line: 815 -- upvalues: LocalPlayer (val)
    local Character = LocalPlayer and LocalPlayer.Character
    if not Character then
        return nil
    end
    local v1 = a1.humanoidCache[LocalPlayer]
    if v1 and v1.Parent == Character then
        return v1
    end
    a1.humanoidCache[LocalPlayer] = nil
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        a1.humanoidCache[LocalPlayer] = Humanoid
    end
    return Humanoid
end

function u95.GetHumanoidPartToFollow(a1, a2, a3) -- Line: 833 -- types: a1: table, a2: userdata
    if a3 ~= Enum.HumanoidStateType.Dead then
        return a2.Torso
    end
    local Parent = a2.Parent
    if Parent then
        return Parent:FindFirstChild("Head") or a2.Torso
    end
    return a2.Torso
end

function u95:OnNewCameraSubject() -- Line: 846
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
end

function u95.IsInFirstPerson(a1) -- Line: 853
    return a1.inFirstPerson
end

function u95.Update(a1, a2) -- Line: 857
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function u95.GetCameraHeight(a1) -- Line: 861 -- upvalues: VRService (val)
    if VRService.VREnabled and not a1.inFirstPerson then
        return 0.25881904510252074 * a1.currentSubjectDistance
    end
    return 0
end

return u95