-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VRCamera
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.VRCamera
-- Decompile time: 8.69 ms

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
UserSettings():GetService("UserGameSettings")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local u53 = setmetatable({}, VRBaseCamera)
u53.__index = u53

function u53.new() -- Line: 30 -- upvalues: VRBaseCamera (val), u53 (val), Players (val)
    local v1 = VRBaseCamera.new()
    local v2 = setmetatable(v1, u53)
    v2.lastUpdate = tick()
    v2.focusOffset = CFrame.new()
    v2:Reset()
    v2.controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    v2.savedAutoRotate = true
    return v2
end

function u53:Reset() -- Line: 43 -- upvalues: VRBaseCamera (val)
    self.needsReset = true
    self.needsBlackout = true
    self.motionDetTime = 0
    self.blackOutTimer = 0
    self.lastCameraResetPosition = nil
    VRBaseCamera.Reset(self)
end

function u53.Update(a1, a2) -- Line: 52 -- upvalues: Players (val), VRService (val)
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    a1:GetHumanoid()
    local CameraSubject = CurrentCamera.CameraSubject
    if a1.lastUpdate == nil or a2 > 1 then
        a1.lastCameraTransform = nil
    end
    a1:UpdateFadeFromBlack(a2)
    a1:UpdateEdgeBlur(LocalPlayer, a2)
    local lastSubjectPosition = a1.lastSubjectPosition
    local SubjectPosition = a1:GetSubjectPosition()
    if a1.needsBlackout then
        a1:StartFadeFromBlack()
        a1.blackOutTimer = a1.blackOutTimer + (math.clamp(a2, 0.0001, 0.1))
        if 0.1 < a1.blackOutTimer and game:IsLoaded() then
            a1.needsBlackout = false
            a1.needsReset = true
        end
    end
    if SubjectPosition and LocalPlayer and CurrentCamera then
        local v1, v2
        local v3 = a1:GetVRFocus(SubjectPosition, a2)
        if not a1:IsInFirstPerson() then
            if not VRService.ThirdPersonFollowCamEnabled then
                v1, v2 = a1:UpdateThirdPersonComfortTransform(a2, CFrame, v3, lastSubjectPosition, SubjectPosition)
            else
                v1, v2 = a1:UpdateThirdPersonFollowTransform(a2, CFrame, v3, lastSubjectPosition, SubjectPosition)
            end
        elseif not VRService.AvatarGestures then
            v1, v2 = a1:UpdateFirstPersonTransform(a2, CFrame, v3, lastSubjectPosition, SubjectPosition)
        else
            v1, v2 = a1:UpdateImmersionCamera(a2, CFrame, v3, lastSubjectPosition, SubjectPosition)
        end
        a1.lastCameraTransform = v1
        a1.lastCameraFocus = v2
    end
    a1.lastUpdate = tick()
    return CFrame, Focus
end

function u53.GetAvatarFeetWorldYValue(a1) -- Line: 114
    local CameraSubject = workspace.CurrentCamera.CameraSubject
    if not CameraSubject then
        return nil
    end
    if CameraSubject:IsA("Humanoid") and CameraSubject.RootPart then
        local RootPart = CameraSubject.RootPart
        return RootPart.Position.Y - RootPart.Size.Y / 2 - CameraSubject.HipHeight
    end
    return nil
end

function u53:UpdateFirstPersonTransform(a2, a3, a4, a5, a6) -- Line: 129 -- upvalues: Players (val)
    if self.needsReset then
        self:StartFadeFromBlack()
        self.needsReset = false
    end
    local LocalPlayer = Players.LocalPlayer
    if 0.01 < (a5 - a6).magnitude then
        self:StartVREdgeBlur(LocalPlayer)
    end
    local p = a4.p
    local CameraLookVector = self:GetCameraLookVector()
    return CFrame.new(
        p - 0.5 * (self:CalculateNewLookVectorFromArg(
            Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit,
            (Vector2.new(self:getRotation(a2), 0))
        )),
        p
    ), a4
end

function u53:UpdateImmersionCamera(a2, a3, a4, a5, a6) -- Line: 155
    -- upvalues: CharacterResolver (val), VRService (val), Players (val)
    local SubjectCFrame = self:GetSubjectCFrame()
    local CurrentCamera = workspace.CurrentCamera
    local v1 = CharacterResolver.getLocalCharacter()
    local Humanoid = self:GetHumanoid()
    if Humanoid and v1 then
        local v2
        local HumanoidRootPart = v1:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return CurrentCamera.CFrame, CurrentCamera.Focus
        end
        self.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation")
        if not self.characterOrientation then
            local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")
            if not RootAttachment then
                return
            end
            self.characterOrientation = Instance.new("AlignOrientation")
            self.characterOrientation.Name = "CharacterAlignOrientation"
            self.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
            self.characterOrientation.Attachment0 = RootAttachment
            self.characterOrientation.RigidityEnabled = true
            self.characterOrientation.Parent = HumanoidRootPart
        end
        if self.characterOrientation.Enabled == false then
            self.characterOrientation.Enabled = true
        end
        if self.needsReset then
            self.needsReset = false
            self.savedAutoRotate = Humanoid.AutoRotate
            Humanoid.AutoRotate = false
            if self.NoRecenter then
                self.NoRecenter = false
                VRService:RecenterUserHeadCFrame()
            end
            self:StartFadeFromBlack()
            v2 = SubjectCFrame
        elseif not Humanoid.Sit then
            local HumanoidRootPart_2, LookVector, UserCFrame, v3, v4, v5, v6
            local EstimatedVRTorsoFrame = self.controlModule:GetEstimatedVRTorsoFrame()
            self.characterOrientation.CFrame = CurrentCamera.CFrame * EstimatedVRTorsoFrame
            if 0 < self.controlModule.inputMoveVector.Magnitude then
                self.motionDetTime = 0.1
            end
            if 0 < self.controlModule.inputMoveVector.Magnitude then
                self.motionDetTime = self.motionDetTime - a2
                self:StartVREdgeBlur(Players.LocalPlayer)
                UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                v3 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
                HumanoidRootPart_2 = v1.HumanoidRootPart
                v4 = -0.7 * HumanoidRootPart_2.Size.Y / 2
                v5 = CurrentCamera.CFrame * v3 * CFrame.new(0, v4, 0)
                LookVector = HumanoidRootPart_2.CFrame.LookVector
                v6 = a6 - (v5 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart_2.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
                v6 = Vector3.new(v6.X, a6.Y, v6.Z)
                v2 = CurrentCamera.CFrame.Rotation + v6
            elseif not (0 < self.motionDetTime) then
                v2 = CurrentCamera.CFrame.Rotation + Vector3.new(CurrentCamera.CFrame.Position.X, a6.Y, CurrentCamera.CFrame.Position.Z)
            else
                self.motionDetTime = self.motionDetTime - a2
                self:StartVREdgeBlur(Players.LocalPlayer)
                UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                v3 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
                HumanoidRootPart_2 = v1.HumanoidRootPart
                v4 = -0.7 * HumanoidRootPart_2.Size.Y / 2
                v5 = CurrentCamera.CFrame * v3 * CFrame.new(0, v4, 0)
                LookVector = HumanoidRootPart_2.CFrame.LookVector
                v6 = a6 - (v5 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart_2.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
                v6 = Vector3.new(v6.X, a6.Y, v6.Z)
                v2 = CurrentCamera.CFrame.Rotation + v6
            end
            v3 = self:getRotation(a2)
            local v7 = math.abs(v3)
            if v7 > 0 then
                local UserCFrame_2 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                v7 = UserCFrame_2.Rotation + UserCFrame_2.Position * CurrentCamera.HeadScale
                v4 = v2 * v7
                v2 = (CFrame.new(v4.Position)) * CFrame.Angles(0, -math.rad(v3 * 90), 0) * v4.Rotation * v7:Inverse()
            end
        elseif 0.01 < (SubjectCFrame.Position - CurrentCamera.CFrame.Position).Magnitude then
            self:StartVREdgeBlur(Players.LocalPlayer)
        end
        return v2, v2 * CFrame.new(0, 0, -0.5)
    end
    return CurrentCamera.CFrame, CurrentCamera.Focus
end

function u53:UpdateThirdPersonComfortTransform(a2, a3, a4, a5, a6) -- Line: 267
    -- upvalues: Players (val), VRService (val)
    local v1
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    if CameraToSubjectDistance < 0.5 then
        CameraToSubjectDistance = 0.5
    end
    if a5 == nil or self.lastCameraFocus == nil then
        v1 = a3
    else
        local Humanoid, lookVector, v2
        local LocalPlayer = Players.LocalPlayer
        local v3 = a5 - a6
        local MoveVector = self.controlModule:GetMoveVector()
        local v4 = true
        if not (0.01 < v3.magnitude) then
            v4 = 0.01 < MoveVector.magnitude
        end
        if v4 then
            self.motionDetTime = 0.1
        end
        self.motionDetTime = self.motionDetTime - a2
        if 0 < self.motionDetTime then
            v4 = true
        end
        if v4 and not self.needsReset then
            local lastCameraFocus = self.lastCameraFocus
            self.VRCameraFocusFrozen = true
            return a3, lastCameraFocus
        end
        local v5 = true
        if self.lastCameraResetPosition ~= nil then
            v5 = 1 < (a6 - self.lastCameraResetPosition).Magnitude
        end
        local v6 = self:getRotation(a2)
        local v7 = math.abs(v6)
        if not (v7 > 0) then
            v1 = a3
        else
            v7 = a4:ToObjectSpace(a3)
            v1 = a4 * CFrame.Angles(0, -v6, 0) * v7
        end
        if not self.VRCameraFocusFrozen then
            if self.needsReset then
                VRService:RecenterUserHeadCFrame()
                self.VRCameraFocusFrozen = false
                self.needsReset = false
                self.lastCameraResetPosition = a6
                self:ResetZoom()
                self:StartFadeFromBlack()
                Humanoid = self:GetHumanoid()
                lookVector = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
                v2 = a4.Position - (Vector3.new(lookVector.X, 0, lookVector.Z)) * CameraToSubjectDistance
                v1 = CFrame.new(v2, (Vector3.new(a4.Position.X, v2.Y, a4.Position.Z)))
            end
        elseif v5 or self.needsReset then
            VRService:RecenterUserHeadCFrame()
            self.VRCameraFocusFrozen = false
            self.needsReset = false
            self.lastCameraResetPosition = a6
            self:ResetZoom()
            self:StartFadeFromBlack()
            Humanoid = self:GetHumanoid()
            lookVector = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            v2 = a4.Position - (Vector3.new(lookVector.X, 0, lookVector.Z)) * CameraToSubjectDistance
            v1 = CFrame.new(v2, (Vector3.new(a4.Position.X, v2.Y, a4.Position.Z)))
        end
    end
    return v1, a4
end

function u53:UpdateThirdPersonFollowTransform(a2, a3, a4, a5, a6) -- Line: 334
    -- upvalues: VRService (val), Players (val)
    local EstimatedVRTorsoFrame, LookVector, v1, v2
    local CurrentCamera = workspace.CurrentCamera
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local VRFocus = self:GetVRFocus(a6, a2)
    if self.needsReset then
        self.needsReset = false
        VRService:RecenterUserHeadCFrame()
        self:ResetZoom()
        self:StartFadeFromBlack()
    end
    if self.recentered then
        local SubjectCFrame = self:GetSubjectCFrame()
        if not SubjectCFrame then
            return CurrentCamera.CFrame, CurrentCamera.Focus
        end
        v2 = VRFocus * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance)
        self.focusOffset = VRFocus:ToObjectSpace(v2)
        self.recentered = false
        return v2, VRFocus
    end
    local v3 = VRFocus:ToWorldSpace(self.focusOffset)
    local LocalPlayer = Players.LocalPlayer
    local v4 = a5 - a6
    local controlModule = self.controlModule
    local MoveVector = controlModule:GetMoveVector()
    if 0.01 < v4.magnitude then
        EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame()
        v1 = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale)
        LookVector = v1.LookVector
        v2 = v3:Lerp(
            (CFrame.new(CurrentCamera.CFrame.Position + (VRFocus.Position - (Vector3.new(LookVector.X, 0, LookVector.Z)).Unit * CameraToSubjectDistance) - v1.Position)) * v3.Rotation,
            0.01
        )
    elseif not (0 < MoveVector.magnitude) then
        v2 = v3
    else
        EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame()
        v1 = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale)
        LookVector = v1.LookVector
        v2 = v3:Lerp(
            (CFrame.new(CurrentCamera.CFrame.Position + (VRFocus.Position - (Vector3.new(LookVector.X, 0, LookVector.Z)).Unit * CameraToSubjectDistance) - v1.Position)) * v3.Rotation,
            0.01
        )
    end
    local v5 = self:getRotation(a2)
    v1 = math.abs(v5)
    if v1 > 0 then
        v1 = VRFocus:ToObjectSpace(v2)
        v2 = VRFocus * CFrame.Angles(0, -v5, 0) * v1
    end
    self.focusOffset = VRFocus:ToObjectSpace(v2)
    local v6 = v2 * CFrame.new(0, 0, -CameraToSubjectDistance)
    if 0.01 < (v6.Position - CurrentCamera.Focus.Position).Magnitude then
        self:StartVREdgeBlur(Players.LocalPlayer)
    end
    return v2, v6
end

function u53.LeaveFirstPerson(a1) -- Line: 412 -- upvalues: VRBaseCamera (val)
    VRBaseCamera.LeaveFirstPerson(a1)
    a1.needsReset = true
    if a1.VRBlur then
        a1.VRBlur.Visible = false
    end
    if a1.characterOrientation then
        a1.characterOrientation.Enabled = false
    end
    local Humanoid = a1:GetHumanoid()
    if Humanoid then
        Humanoid.AutoRotate = a1.savedAutoRotate
    end
end

return u53