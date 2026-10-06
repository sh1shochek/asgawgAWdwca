-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local VRService = game:GetService("VRService");
UserSettings():GetService("UserGameSettings");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent:WaitForChild("CameraInput"));
require(script.Parent:WaitForChild("CameraUtils"));
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"));
local u1 = setmetatable({}, VRBaseCamera);
u1.__index = u1;

function u1.new() -- Line: 30
    -- upvalues: VRBaseCamera (copy), u1 (copy), Players (copy)
    local v2 = VRBaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.focusOffset = CFrame.new();
    v3:Reset();
    v3.controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));
    v3.savedAutoRotate = true;

    return v3;
end;

function u1.Reset(p4) -- Line: 43
    -- upvalues: VRBaseCamera (copy)
    p4.needsReset = true;
    p4.needsBlackout = true;
    p4.motionDetTime = 0;
    p4.blackOutTimer = 0;
    p4.lastCameraResetPosition = nil;
    VRBaseCamera.Reset(p4);
end;

function u1.Update(p5, p6) -- Line: 52
    -- upvalues: Players (copy), VRService (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    p5:GetHumanoid();
    local _ = workspace_CurrentCamera.CameraSubject;

    if p5.lastUpdate == nil or p6 > 1 then
        p5.lastCameraTransform = nil;
    end;

    p5:UpdateFadeFromBlack(p6);
    p5:UpdateEdgeBlur(LocalPlayer, p6);
    local lastSubjectPosition = p5.lastSubjectPosition;
    local SubjectPosition = p5:GetSubjectPosition();

    if p5.needsBlackout then
        p5:StartFadeFromBlack();
        local math_clamp_ret = math.clamp(p6, 0.0001, 0.1);
        p5.blackOutTimer = p5.blackOutTimer + math_clamp_ret;

        if p5.blackOutTimer > 0.1 and game:IsLoaded() then
            p5.needsBlackout = false;
            p5.needsReset = true;
        end;
    end;

    if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
        local VRFocus = p5:GetVRFocus(SubjectPosition, p6);

        if p5:IsInFirstPerson() then
            if VRService.AvatarGestures then
                CFrame2, Focus = p5:UpdateImmersionCamera(p6, CFrame2, VRFocus, lastSubjectPosition, SubjectPosition);
            else
                CFrame2, Focus = p5:UpdateFirstPersonTransform(p6, CFrame2, VRFocus, lastSubjectPosition, SubjectPosition);
            end;
        elseif VRService.ThirdPersonFollowCamEnabled then
            CFrame2, Focus = p5:UpdateThirdPersonFollowTransform(p6, CFrame2, VRFocus, lastSubjectPosition, SubjectPosition);
        else
            CFrame2, Focus = p5:UpdateThirdPersonComfortTransform(p6, CFrame2, VRFocus, lastSubjectPosition, SubjectPosition);
        end;

        p5.lastCameraTransform = CFrame2;
        p5.lastCameraFocus = Focus;
    end;

    p5.lastUpdate = tick();

    return CFrame2, Focus;
end;

function u1.GetAvatarFeetWorldYValue(p7) -- Line: 114
    local CameraSubject = workspace.CurrentCamera.CameraSubject;

    if not CameraSubject then
        return nil;
    end;

    if not (CameraSubject:IsA("Humanoid") and CameraSubject.RootPart) then
        return nil;
    end;

    local RootPart = CameraSubject.RootPart;

    return RootPart.Position.Y - RootPart.Size.Y / 2 - CameraSubject.HipHeight;
end;

function u1.UpdateFirstPersonTransform(p8, p9, p10, p11, p12, p13) -- Line: 129
    -- upvalues: Players (copy)
    if p8.needsReset then
        p8:StartFadeFromBlack();
        p8.needsReset = false;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if (p12 - p13).magnitude > 0.01 then
        p8:StartVREdgeBlur(LocalPlayer);
    end;

    local p = p11.p;
    local CameraLookVector = p8:GetCameraLookVector();
    local Unit = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit;
    local Rotation = p8:getRotation(p9);
    local v14 = p8:CalculateNewLookVectorFromArg(Unit, Vector2.new(Rotation, 0));

    return CFrame.new(p - 0.5 * v14, p), p11;
end;

function u1.UpdateImmersionCamera(p15, p16, p17, p18, p19, p20) -- Line: 155
    -- upvalues: CharacterResolver (copy), VRService (copy), Players (copy)
    local SubjectCFrame = p15:GetSubjectCFrame();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local LocalCharacter = CharacterResolver.getLocalCharacter();
    local Humanoid = p15:GetHumanoid();

    if not (Humanoid and LocalCharacter) then
        return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
    end;

    local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
    end;

    p15.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation");

    if not p15.characterOrientation then
        local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment");

        if not RootAttachment then
            return;
        end;

        p15.characterOrientation = Instance.new("AlignOrientation");
        p15.characterOrientation.Name = "CharacterAlignOrientation";
        p15.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
        p15.characterOrientation.Attachment0 = RootAttachment;
        p15.characterOrientation.RigidityEnabled = true;
        p15.characterOrientation.Parent = HumanoidRootPart;
    end;

    if p15.characterOrientation.Enabled == false then
        p15.characterOrientation.Enabled = true;
    end;

    if p15.needsReset then
        p15.needsReset = false;
        p15.savedAutoRotate = Humanoid.AutoRotate;
        Humanoid.AutoRotate = false;

        if p15.NoRecenter then
            p15.NoRecenter = false;
            VRService:RecenterUserHeadCFrame();
        end;

        p15:StartFadeFromBlack();
    elseif Humanoid.Sit then
        if (SubjectCFrame.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 0.01 then
            p15:StartVREdgeBlur(Players.LocalPlayer);
        end;
    else
        local EstimatedVRTorsoFrame = p15.controlModule:GetEstimatedVRTorsoFrame();
        p15.characterOrientation.CFrame = workspace_CurrentCamera.CFrame * EstimatedVRTorsoFrame;

        if p15.controlModule.inputMoveVector.Magnitude > 0 then
            p15.motionDetTime = 0.1;
        end;

        if p15.controlModule.inputMoveVector.Magnitude > 0 or p15.motionDetTime > 0 then
            p15.motionDetTime = p15.motionDetTime - p16;
            p15:StartVREdgeBlur(Players.LocalPlayer);
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local HumanoidRootPart2 = LocalCharacter.HumanoidRootPart;
            local v21 = workspace_CurrentCamera.CFrame * (UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * HumanoidRootPart2.Size.Y / 2, 0);
            local LookVector = HumanoidRootPart2.CFrame.LookVector;
            local v22 = p20 - (v21 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart2.Size.Y * 0.125).Position + workspace_CurrentCamera.CFrame.Position;
            local Vector3_new_ret = Vector3.new(v22.X, p20.Y, v22.Z);
            SubjectCFrame = workspace_CurrentCamera.CFrame.Rotation + Vector3_new_ret;
        else
            SubjectCFrame = workspace_CurrentCamera.CFrame.Rotation + Vector3.new(workspace_CurrentCamera.CFrame.Position.X, p20.Y, workspace_CurrentCamera.CFrame.Position.Z);
        end;

        local Rotation = p15:getRotation(p16);

        if math.abs(Rotation) > 0 then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v23 = UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale;
            local v24 = SubjectCFrame * v23;
            SubjectCFrame = CFrame.new(v24.Position) * CFrame.Angles(0, -math.rad(Rotation * 90), 0) * v24.Rotation * v23:Inverse();
        end;
    end;

    return SubjectCFrame, SubjectCFrame * CFrame.new(0, 0, -0.5);
end;

function u1.UpdateThirdPersonComfortTransform(p25, p26, p27, p28, p29, p30) -- Line: 267
    -- upvalues: Players (copy), VRService (copy)
    local CameraToSubjectDistance = p25:GetCameraToSubjectDistance();
    local v31 = CameraToSubjectDistance < 0.5 and 0.5 or CameraToSubjectDistance;

    if p29 ~= nil and p25.lastCameraFocus ~= nil then
        local _ = Players.LocalPlayer;
        local MoveVector = p25.controlModule:GetMoveVector();
        local v32 = (p29 - p30).magnitude > 0.01 and true or MoveVector.magnitude > 0.01;

        if v32 then
            p25.motionDetTime = 0.1;
        end;

        p25.motionDetTime = p25.motionDetTime - p26;

        if (p25.motionDetTime > 0 and true or v32) and not p25.needsReset then
            local lastCameraFocus = p25.lastCameraFocus;
            p25.VRCameraFocusFrozen = true;

            return p27, lastCameraFocus;
        end;

        local v33 = p25.lastCameraResetPosition == nil and true or (p30 - p25.lastCameraResetPosition).Magnitude > 1;
        local Rotation = p25:getRotation(p26);

        if math.abs(Rotation) > 0 then
            local v34 = p28:ToObjectSpace(p27);
            p27 = p28 * CFrame.Angles(0, -Rotation, 0) * v34;
        end;

        if p25.VRCameraFocusFrozen and v33 or p25.needsReset then
            VRService:RecenterUserHeadCFrame();
            p25.VRCameraFocusFrozen = false;
            p25.needsReset = false;
            p25.lastCameraResetPosition = p30;
            p25:ResetZoom();
            p25:StartFadeFromBlack();
            local Humanoid = p25:GetHumanoid();
            local v35 = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0);
            local Vector3_new_ret = Vector3.new(v35.X, 0, v35.Z);
            local v36 = p28.Position - Vector3_new_ret * v31;
            local Vector3_new_ret2 = Vector3.new(p28.Position.X, v36.Y, p28.Position.Z);
            p27 = CFrame.new(v36, Vector3_new_ret2);
        end;
    end;

    return p27, p28;
end;

function u1.UpdateThirdPersonFollowTransform(p37, p38, p39, p40, p41, p42) -- Line: 334
    -- upvalues: VRService (copy), Players (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CameraToSubjectDistance = p37:GetCameraToSubjectDistance();
    local VRFocus = p37:GetVRFocus(p42, p38);

    if p37.needsReset then
        p37.needsReset = false;
        VRService:RecenterUserHeadCFrame();
        p37:ResetZoom();
        p37:StartFadeFromBlack();
    end;

    if p37.recentered then
        local SubjectCFrame = p37:GetSubjectCFrame();

        if not SubjectCFrame then
            return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
        end;

        local v43 = VRFocus * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance);
        p37.focusOffset = VRFocus:ToObjectSpace(v43);
        p37.recentered = false;

        return v43, VRFocus;
    end;

    local v44 = VRFocus:ToWorldSpace(p37.focusOffset);
    local _ = Players.LocalPlayer;
    local controlModule = p37.controlModule;
    local MoveVector = controlModule:GetMoveVector();

    if (p41 - p42).magnitude > 0.01 or MoveVector.magnitude > 0 then
        local EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame();
        local v45 = workspace_CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * workspace_CurrentCamera.HeadScale);
        local LookVector = v45.LookVector;
        local v46 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance;
        v44 = v44:Lerp(CFrame.new(workspace_CurrentCamera.CFrame.Position + (VRFocus.Position - v46) - v45.Position) * v44.Rotation, 0.01);
    end;

    local Rotation = p37:getRotation(p38);

    if math.abs(Rotation) > 0 then
        local v47 = VRFocus:ToObjectSpace(v44);
        v44 = VRFocus * CFrame.Angles(0, -Rotation, 0) * v47;
    end;

    p37.focusOffset = VRFocus:ToObjectSpace(v44);
    local v48 = v44 * CFrame.new(0, 0, -CameraToSubjectDistance);

    if (v48.Position - workspace_CurrentCamera.Focus.Position).Magnitude > 0.01 then
        p37:StartVREdgeBlur(Players.LocalPlayer);
    end;

    return v44, v48;
end;

function u1.LeaveFirstPerson(p49) -- Line: 412
    -- upvalues: VRBaseCamera (copy)
    VRBaseCamera.LeaveFirstPerson(p49);
    p49.needsReset = true;

    if p49.VRBlur then
        p49.VRBlur.Visible = false;
    end;

    if p49.characterOrientation then
        p49.characterOrientation.Enabled = false;
    end;

    local Humanoid = p49:GetHumanoid();

    if Humanoid then
        Humanoid.AutoRotate = p49.savedAutoRotate;
    end;
end;

return u1;