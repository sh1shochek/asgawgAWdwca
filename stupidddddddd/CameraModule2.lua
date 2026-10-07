-- StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CameraModule
-- Decompile time: 16.74 ms

local u0 = {}
u0.__index = u0
local u1 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock",
}
local u11 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode",
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils = require(script:WaitForChild("CameraUtils"))
local CameraInput = require(script:WaitForChild("CameraInput"))
local ClassicCamera = require(script:WaitForChild("ClassicCamera"))
local OrbitalCamera = require(script:WaitForChild("OrbitalCamera"))
local LegacyCamera = require(script:WaitForChild("LegacyCamera"))
local VehicleCamera = require(script:WaitForChild("VehicleCamera"))
local VRCamera = require(script:WaitForChild("VRCamera"))
local VRVehicleCamera = require(script:WaitForChild("VRVehicleCamera"))
local Invisicam = require(script:WaitForChild("Invisicam"))
local Poppercam = require(script:WaitForChild("Poppercam"))
local TransparencyController = require(script:WaitForChild("TransparencyController"))
local MouseLockController = require(script:WaitForChild("MouseLockController"))
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local u158 = {}
local u159 = {}
if not Players.LocalPlayer then
    return {}
end
assert(Players.LocalPlayer, "Strict typing check")
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)
local UserRespectLegacyCameraOptions = FlagUtil.getUserFlag("UserRespectLegacyCameraOptions")
FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")

function u0.new() -- Line: 157
    -- upvalues: TransparencyController (val), ConnectionUtil (val), u0 (val), Players (val), UserInputService (val)
    -- upvalues: MouseLockController (val), UserRespectLegacyCameraOptions (val), RunService (val), u1 (val), u11 (val)
    -- upvalues: UserGameSettings (val)
    local v1 = {
        activeTransparencyController = TransparencyController.new(),
        connectionUtil = ConnectionUtil.new(),
    }
    local u9 = setmetatable(v1, u0)
    u9.activeCameraController = nil
    u9.activeOcclusionModule = nil
    u9.activeMouseLockController = nil
    u9.currentComputerCameraMovementMode = nil
    u9.cameraSubjectChangedConn = nil
    u9.cameraTypeChangedConn = nil
    u9.renderStepName = "cameraRenderUpdate"
    for k, v in pairs(Players:GetPlayers()) do
        u9:OnPlayerAdded(v)
    end
    u9.connectionUtil:trackConnection("Players.PlayerAdded", (Players.PlayerAdded:Connect(function(a1) -- Line: 185 -- upvalues: u9 (val)
        u9:OnPlayerAdded(a1)
    end)))
    u9.connectionUtil:trackConnection("Players.PlayerRemoving", (Players.PlayerRemoving:Connect(function(a1) -- Line: 192 -- upvalues: u9 (val)
        u9:OnPlayerRemoving(a1)
    end)))
    u9.activeTransparencyController:Enable(true)
    if not UserInputService.TouchEnabled then
        u9.activeMouseLockController = MouseLockController.new()
        assert(u9.activeMouseLockController, "Strict typing check")
        local BindableToggleEvent = u9.activeMouseLockController:GetBindableToggleEvent()
        if BindableToggleEvent then
            u9.connectionUtil:trackConnection("MouseLockToggleEvent", (BindableToggleEvent:Connect(function() -- Line: 207 -- upvalues: u9 (val)
                u9:OnMouseLockToggled()
            end)))
        end
    end
    if not UserRespectLegacyCameraOptions then
        u9:ActivateCameraController((u9:GetCameraControlChoice()))
    else
        u9:ActivateCameraController()
    end
    u9:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    u9:OnCurrentCameraChanged()
    RunService:BindToRenderStep(u9.renderStepName, Enum.RenderPriority.Camera.Value, function(a1) -- Line: 221 -- upvalues: u9 (val)
        u9:Update(a1)
    end)
    for k2, i in pairs(u1) do
        u9.connectionUtil:trackConnection(("LocalPlayer.%*"):format(i), ((Players.LocalPlayer:GetPropertyChangedSignal(i)):Connect(function() -- Line: 229 -- upvalues: u9 (val), i (val)
            u9:OnLocalPlayerCameraPropertyChanged(i)
        end)))
    end
    for k3, j in pairs(u11) do
        u9.connectionUtil:trackConnection(("UserGameSettings.%*"):format(j), ((UserGameSettings:GetPropertyChangedSignal(j)):Connect(function() -- Line: 238 -- upvalues: u9 (val), j (val)
            u9:OnUserGameSettingsPropertyChanged(j)
        end)))
    end
    u9.connectionUtil:trackConnection("Workspace.CurrentCamera", ((workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 245 -- upvalues: u9 (val)
        u9:OnCurrentCameraChanged()
    end)))
    return u9
end

function u0.GetCameraMovementModeFromSettings(a1) -- Line: 253
    -- upvalues: Players (val), CameraUtils (val), UserInputService (val), UserGameSettings (val)
    local v1, v2
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
    end
    if not UserInputService.TouchEnabled then
        v1 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
        v2 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
    else
        v1 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
        v2 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
    end
    if v1 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v2
    end
    return v1
end

function u0:ActivateOcclusionModule(a2) -- Line: 278
    -- upvalues: Poppercam (val), Invisicam (val), u159 (val), CharacterResolver (val), Players (val)
    local activeOcclusionModule, v1, v2, v3, v4
    if a2 == Enum.DevCameraOcclusionMode.Zoom then
        self.occlusionMode = a2
        if self.activeOcclusionModule and self.activeOcclusionModule:GetOcclusionMode() == a2 then
            if not self.activeOcclusionModule:GetEnabled() then
                self.activeOcclusionModule:Enable(true)
            end
            return
        end
        activeOcclusionModule = self.activeOcclusionModule
        self.activeOcclusionModule = u159[Poppercam]
        if not self.activeOcclusionModule then
            self.activeOcclusionModule = v3.new()
            if self.activeOcclusionModule then
                u159[v3] = self.activeOcclusionModule
            end
        end
        if self.activeOcclusionModule then
            if self.activeOcclusionModule:GetOcclusionMode() ~= a2 then
                warn("CameraScript ActivateOcclusionModule mismatch: ", self.activeOcclusionModule:GetOcclusionMode(), "~=", a2)
            end
            if activeOcclusionModule then
                if activeOcclusionModule == self.activeOcclusionModule then
                    warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
                else
                    activeOcclusionModule:Enable(false)
                end
            end
            if a2 ~= Enum.DevCameraOcclusionMode.Invisicam then
                v1 = self
                for k2, i in pairs(Players:GetPlayers()) do
                    v2 = i and CharacterResolver.getPlayerCharacter(i)
                    if v2 then
                        v1.activeOcclusionModule:CharacterAdded(v2, i)
                    end
                end
                v1.activeOcclusionModule:OnCameraSubjectChanged(workspace.CurrentCamera.CameraSubject)
            else
                v4 = CharacterResolver.getPlayerCharacter(Players.LocalPlayer)
                if v4 then
                    self.activeOcclusionModule:CharacterAdded(v4, Players.LocalPlayer)
                end
                v1 = self
            end
            v1.activeOcclusionModule:Enable(true)
        end
        return
    end
    if a2 ~= Enum.DevCameraOcclusionMode.Invisicam then
        warn("CameraScript ActivateOcclusionModule called with unsupported mode")
        return
    end
    self.occlusionMode = a2
    if self.activeOcclusionModule and self.activeOcclusionModule:GetOcclusionMode() == a2 then
        if not self.activeOcclusionModule:GetEnabled() then
            self.activeOcclusionModule:Enable(true)
        end
        return
    end
    activeOcclusionModule = self.activeOcclusionModule
    self.activeOcclusionModule = u159[Invisicam]
    if not self.activeOcclusionModule then
        self.activeOcclusionModule = v3.new()
        if self.activeOcclusionModule then
            u159[v3] = self.activeOcclusionModule
        end
    end
    if self.activeOcclusionModule then
        if self.activeOcclusionModule:GetOcclusionMode() ~= a2 then
            warn("CameraScript ActivateOcclusionModule mismatch: ", self.activeOcclusionModule:GetOcclusionMode(), "~=", a2)
        end
        if activeOcclusionModule then
            if activeOcclusionModule == self.activeOcclusionModule then
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
            else
                activeOcclusionModule:Enable(false)
            end
        end
        if a2 ~= Enum.DevCameraOcclusionMode.Invisicam then
            v1 = self
            for k, v in pairs(Players:GetPlayers()) do
                v2 = v and CharacterResolver.getPlayerCharacter(v)
                if v2 then
                    v1.activeOcclusionModule:CharacterAdded(v2, v)
                end
            end
            v1.activeOcclusionModule:OnCameraSubjectChanged(workspace.CurrentCamera.CameraSubject)
        else
            v4 = CharacterResolver.getPlayerCharacter(Players.LocalPlayer)
            if v4 then
                self.activeOcclusionModule:CharacterAdded(v4, Players.LocalPlayer)
            end
            v1 = self
        end
        v1.activeOcclusionModule:Enable(true)
    end
end

function u0:ShouldUseVehicleCamera() -- Line: 364
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return false
    end
    local CameraType = CurrentCamera.CameraType
    local CameraSubject = CurrentCamera.CameraSubject
    local v1 = true
    if CameraType ~= Enum.CameraType.Custom then
        v1 = CameraType == Enum.CameraType.Follow
    end
    local v2 = CameraSubject and CameraSubject:IsA("VehicleSeat") or false
    local v3 = self.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
    return v2 and v1 and v3
end

function u0:ActivateCameraController(a2, a3) -- Line: 380
    -- upvalues: UserRespectLegacyCameraOptions (val), LegacyCamera (val), VRService (val), VRCamera (val)
    -- upvalues: ClassicCamera (val), OrbitalCamera (val), VRVehicleCamera (val), VehicleCamera (val), u158 (val)
    local v1
    if UserRespectLegacyCameraOptions then
        a3 = workspace.CurrentCamera.CameraType
        a2 = self:GetCameraMovementModeFromSettings()
    end
    local v2 = nil
    if if not UserRespectLegacyCameraOptions then a3 ~= nil else true then
        if a3 == Enum.CameraType.Scriptable then
            if self.activeCameraController then
                self.activeCameraController:Enable(false)
                self.activeCameraController = nil
            end
            return
        end
        if a3 == Enum.CameraType.Custom then
            a2 = self:GetCameraMovementModeFromSettings()
        elseif a3 == Enum.CameraType.Track then
            a2 = Enum.ComputerCameraMovementMode.Classic
        elseif a3 == Enum.CameraType.Follow then
            a2 = Enum.ComputerCameraMovementMode.Follow
        elseif a3 == Enum.CameraType.Orbital then
            a2 = Enum.ComputerCameraMovementMode.Orbital
        elseif a3 == Enum.CameraType.Attach or a3 == Enum.CameraType.Watch then
            v2 = LegacyCamera
        elseif a3 ~= Enum.CameraType.Fixed then
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", a3)
        else
            v2 = LegacyCamera
        end
    end
    if not v2 then
        if not VRService.VREnabled then
            if a2 ~= Enum.ComputerCameraMovementMode.Classic
                and a2 ~= Enum.ComputerCameraMovementMode.Follow
                and a2 ~= Enum.ComputerCameraMovementMode.Default
                and a2 ~= Enum.ComputerCameraMovementMode.CameraToggle then
                if a2 ~= Enum.ComputerCameraMovementMode.Orbital then
                    warn("ActivateCameraController did not select a module.")
                    return
                end
                v2 = OrbitalCamera
                if self:ShouldUseVehicleCamera() then
                    v2 = if not VRService.VREnabled then VehicleCamera else VRVehicleCamera
                end
                if u158[v2] then
                    v1 = u158[v2]
                    if v1.Reset then
                        v1:Reset()
                    end
                else
                    u158[v2] = (v2.new())
                end
                if not self.activeCameraController then
                    if v1 ~= nil then
                        self.activeCameraController = v1
                        assert(self.activeCameraController, "Strict typing check")
                        self.activeCameraController:Enable(true)
                    end
                elseif self.activeCameraController ~= v1 then
                    self.activeCameraController:Enable(false)
                    self.activeCameraController = v1
                    self.activeCameraController:Enable(true)
                elseif not self.activeCameraController:GetEnabled() then
                    self.activeCameraController:Enable(true)
                end
                if self.activeCameraController then
                    if UserRespectLegacyCameraOptions then
                        self.activeCameraController:SetCameraMovementMode(a2)
                        self.activeCameraController:SetCameraType(a3)
                        return
                    end
                    if a2 ~= nil then
                        self.activeCameraController:SetCameraMovementMode(a2)
                        return
                    end
                    if a3 ~= nil then
                        self.activeCameraController:SetCameraType(a3)
                    end
                end
                return
            end
            v2 = ClassicCamera
        else
            v2 = VRCamera
        end
    end
    if self:ShouldUseVehicleCamera() then
        v2 = if not VRService.VREnabled then VehicleCamera else VRVehicleCamera
    end
    if u158[v2] then
        v1 = u158[v2]
        if v1.Reset then
            v1:Reset()
        end
    else
        u158[v2] = (v2.new())
    end
    if not self.activeCameraController then
        if v1 ~= nil then
            self.activeCameraController = v1
            assert(self.activeCameraController, "Strict typing check")
            self.activeCameraController:Enable(true)
        end
    elseif self.activeCameraController ~= v1 then
        self.activeCameraController:Enable(false)
        self.activeCameraController = v1
        self.activeCameraController:Enable(true)
    elseif not self.activeCameraController:GetEnabled() then
        self.activeCameraController:Enable(true)
    end
    if self.activeCameraController then
        if UserRespectLegacyCameraOptions then
            self.activeCameraController:SetCameraMovementMode(a2)
            self.activeCameraController:SetCameraType(a3)
            return
        end
        if a2 ~= nil then
            self.activeCameraController:SetCameraMovementMode(a2)
            return
        end
        if a3 ~= nil then
            self.activeCameraController:SetCameraType(a3)
        end
    end
end

function u0:OnCameraSubjectChanged() -- Line: 499
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = if not CurrentCamera then nil else CurrentCamera.CameraSubject
    if self.activeTransparencyController then
        self.activeTransparencyController:SetSubject(CameraSubject)
    end
    if self.activeOcclusionModule then
        self.activeOcclusionModule:OnCameraSubjectChanged(CameraSubject)
    end
    self:ActivateCameraController(nil, if not CurrentCamera then nil else CurrentCamera.CameraType)
end

function u0:OnCameraTypeChanged(a2) -- Line: 514 -- upvalues: UserInputService (val), CameraUtils (val)
    if a2 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils.restoreMouseBehavior()
    end
    self:ActivateCameraController(nil, a2)
end

function u0:OnCurrentCameraChanged() -- Line: 526
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return
    end
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
    end
    if self.cameraTypeChangedConn then
        self.cameraTypeChangedConn:Disconnect()
    end
    self.cameraSubjectChangedConn = (CurrentCamera:GetPropertyChangedSignal("CameraSubject")):Connect(function() -- Line: 540 -- upvalues: self (val)
        self:OnCameraSubjectChanged()
    end)
    self.cameraTypeChangedConn = (CurrentCamera:GetPropertyChangedSignal("CameraType")):Connect(function() -- Line: 544 -- upvalues: self (val), CurrentCamera (val)
        self:OnCameraTypeChanged(CurrentCamera.CameraType)
    end)
    self:OnCameraSubjectChanged()
    self:OnCameraTypeChanged(CurrentCamera.CameraType)
end

function u0:OnLocalPlayerCameraPropertyChanged(a2) -- Line: 552
    -- upvalues: Players (val), CameraUtils (val)
    if a2 == "CameraMode" then
        if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                self:ActivateCameraController((CameraUtils.ConvertCameraModeEnumToStandard((self:GetCameraMovementModeFromSettings()))))
                return
            end
            warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
            return
        end
        if not self.activeCameraController or self.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            self:ActivateCameraController((CameraUtils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic)))
        end
        if not self.activeCameraController then
            return
        end
        self.activeCameraController:UpdateForDistancePropertyChange()
        return
    end
    if a2 ~= "DevComputerCameraMode" and a2 ~= "DevTouchCameraMode" then
        if a2 == "DevCameraOcclusionMode" then
            self:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
            return
        end
        if a2 ~= "CameraMinZoomDistance" and a2 ~= "CameraMaxZoomDistance" then
            if a2 == "DevTouchMovementMode" or a2 == "DevComputerMovementMode" then
                return
            end
            return
        end
        if not self.activeCameraController then
            return
        end
        self.activeCameraController:UpdateForDistancePropertyChange()
        return
    end
    self:ActivateCameraController((CameraUtils.ConvertCameraModeEnumToStandard((self:GetCameraMovementModeFromSettings()))))
end

function u0:OnUserGameSettingsPropertyChanged(a2) -- Line: 594
    -- upvalues: CameraUtils (val)
    if a2 == "ComputerCameraMovementMode" then
        self:ActivateCameraController((CameraUtils.ConvertCameraModeEnumToStandard((self:GetCameraMovementModeFromSettings()))))
    end
end

function u0:Update(a2) -- Line: 608 -- upvalues: CameraInput (val)
    if self.activeCameraController then
        self.activeCameraController:UpdateMouseBehavior()
        local v1, v2 = self.activeCameraController:Update(a2)
        if self.activeOcclusionModule then
            local v3, v4 = self.activeOcclusionModule:Update(a2, v1, v2)
            v1 = v3
            v2 = v4
        end
        local CurrentCamera = workspace.CurrentCamera
        CurrentCamera.CFrame = v1
        CurrentCamera.Focus = v2
        if self.activeTransparencyController then
            self.activeTransparencyController:Update(a2)
        end
        if CameraInput.getInputEnabled() then
            CameraInput.resetInputForFrameEnd()
        end
    end
end

function u0.GetCameraControlChoice(a1) -- Line: 636
    -- upvalues: UserRespectLegacyCameraOptions (val), UserInputService (val), Players (val), CameraUtils (val)
    -- upvalues: UserGameSettings (val)
    assert(
        not UserRespectLegacyCameraOptions,
        "CameraModule:GetCameraControlChoice should not be called when FFlagUserRespectLegacyCameraOptions is enabled"
    )
    if (UserInputService:GetLastInputType()) ~= Enum.UserInputType.Touch and not UserInputService.TouchEnabled then
        if Players.LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice then
            return CameraUtils.ConvertCameraModeEnumToStandard((CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)))
        end
        return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
    end
    if Players.LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
        return CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
    end
    return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
end

function u0:OnCharacterAdded(a2, a3) -- Line: 660 -- types: self: table, a2: userdata, a3: userdata
    if self.activeOcclusionModule then
        self.activeOcclusionModule:CharacterAdded(a2, a3)
    end
end

function u0:OnCharacterRemoving(a2, a3) -- Line: 666
    if self.activeOcclusionModule then
        self.activeOcclusionModule:CharacterRemoving(a2, a3)
    end
end

function u0:OnPlayerAdded(a2) -- Line: 672 -- upvalues: CharacterResolver (val) -- types: self: table, a2: userdata
    self.connectionUtil:trackBoundFunction(("%*CharacterObserver"):format(a2.UserId), (CharacterResolver.observeCharacter(a2, function(a1, a2_2) -- Line: 675 -- upvalues: self (val), a2 (val) -- types: a1: userdata?, a2_2: userdata?
        if a2_2 and a2_2 ~= a1 then
            self:OnCharacterRemoving(a2_2, a2)
        end
        if a1 then
            self:OnCharacterAdded(a1, a2)
        end
        return function() end
    end)))
end

function u0:OnPlayerRemoving(a2) -- Line: 687 -- types: self: table, a2: userdata
    self.connectionUtil:disconnect((("%*CharacterObserver"):format(a2.UserId)))
end

function u0:OnMouseLockToggled() -- Line: 691
    if self.activeMouseLockController then
        local IsMouseLocked = self.activeMouseLockController:GetIsMouseLocked()
        local MouseLockOffset = self.activeMouseLockController:GetMouseLockOffset()
        if self.activeCameraController then
            self.activeCameraController:SetIsMouseLocked(IsMouseLocked)
            self.activeCameraController:SetMouseLockOffset(MouseLockOffset)
        end
    end
end

u0.new()
return {}