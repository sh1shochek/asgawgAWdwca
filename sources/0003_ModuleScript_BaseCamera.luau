-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local VRService = game:GetService("VRService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUI = require(script.Parent:WaitForChild("CameraUI"));
local LocalPlayer = Players.LocalPlayer;
local success, result = pcall(function() -- Line: 24
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom");
end);
local u1 = success and result;
local UserFlag = FlagUtil.getUserFlag("UserFixCameraCameraCharacterUpdates");
Vector2.new(0, 0);
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 83
    -- upvalues: u2 (copy), ConnectionUtil (copy), LocalPlayer (copy), UserFlag (copy), UserGameSettings (copy)
    local v3 = setmetatable({}, u2);
    v3._connections = ConnectionUtil.new();
    v3.gamepadZoomLevels = { 0, 10, 20 };
    v3.FIRST_PERSON_DISTANCE_THRESHOLD = 1;
    v3.cameraType = nil;
    v3.cameraMovementMode = nil;
    v3.lastCameraTransform = nil;
    v3.lastUserPanCamera = tick();
    v3.humanoidRootPart = nil;
    v3.humanoidCache = {};
    v3.lastSubject = nil;
    v3.lastSubjectPosition = Vector3.new(0, 5, 0);
    v3.lastSubjectCFrame = CFrame.new(v3.lastSubjectPosition);
    v3.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);
    v3.inFirstPerson = false;
    v3.inMouseLockedMode = false;
    v3.portraitMode = false;
    v3.isSmallTouchScreen = false;
    v3.resetCameraAngle = true;
    v3.enabled = false;

    if not UserFlag then
        v3.PlayerGui = nil;
    end;

    v3.cameraChangedConn = nil;
    v3.viewportSizeChangedConn = nil;
    v3.shouldUseVRRotation = false;
    v3.VRRotationIntensityAvailable = false;
    v3.lastVRRotationIntensityCheckTime = 0;
    v3.lastVRRotationTime = 0;
    v3.vrRotateKeyCooldown = {};
    v3.cameraTranslationConstraints = Vector3.new(1, 1, 1);
    v3.humanoidJumpOrigin = nil;
    v3.trackingHumanoid = nil;
    v3.cameraFrozen = false;
    v3.subjectStateChangedConn = nil;
    v3.gamepadZoomPressConnection = nil;
    v3.mouseLockOffset = Vector3.new(0, 0, 0);
    UserGameSettings:SetCameraYInvertVisible();
    UserGameSettings:SetGamepadCameraSensitivityVisible();

    return v3;
end;

function u2.GetModuleName(p4) -- Line: 152
    return "BaseCamera";
end;

function u2._setUpConfigurations(u5) -- Line: 156
    -- upvalues: LocalPlayer (copy), UserFlag (copy)
    u5._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p6) -- Line: 159
        -- upvalues: u5 (copy)
        u5:OnCharacterAdded(p6);
    end));

    if UserFlag then
        u5.humanoidRootPart = nil;
    elseif LocalPlayer.Character then
        u5:OnCharacterAdded(LocalPlayer.Character);
    end;

    u5._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- Line: 173
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- Line: 179
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- Line: 185
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5:OnPlayerCameraPropertyChange();
end;

function u2.OnCharacterAdded(u7, p8) -- Line: 192
    -- upvalues: UserFlag (copy), UserInputService (copy), LocalPlayer (copy)
    u7.resetCameraAngle = u7.resetCameraAngle or u7:GetEnabled();
    u7.humanoidRootPart = nil;

    if not UserFlag and UserInputService.TouchEnabled then
        u7.PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

        for _, child in ipairs(p8:GetChildren()) do
            if child:IsA("Tool") then
                u7.isAToolEquipped = true;
            end;
        end;

        u7._connections:trackConnection("char.ChildAdded", p8.ChildAdded:Connect(function(p9) -- Line: 207
            -- upvalues: u7 (copy)
            if p9:IsA("Tool") then
                u7.isAToolEquipped = true;
            end;
        end));
        u7._connections:trackConnection("char.ChildRemoved", p8.ChildRemoved:Connect(function(p10) -- Line: 215
            -- upvalues: u7 (copy)
            if p10:IsA("Tool") then
                u7.isAToolEquipped = false;
            end;
        end));
    end;
end;

function u2.GetHumanoidRootPart(p11) -- Line: 225
    -- upvalues: LocalPlayer (copy)
    local v12 = (not p11.humanoidRootPart and LocalPlayer.Character and true or false) and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if v12 then
        p11.humanoidRootPart = v12.RootPart;
    end;

    return p11.humanoidRootPart;
end;

function u2.GetBodyPartToFollow(p13: table, p14: userdata, p15: boolean) -- Line: 237
    if p14:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p14.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or p14.RootPart;
        end;
    end;

    return p14.RootPart;
end;

function u2.GetSubjectCFrame(p16) -- Line: 249
    local lastSubjectCFrame = p16.lastSubjectCFrame;
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return lastSubjectCFrame;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local v17 = workspace_CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = workspace_CurrentCamera.CameraOffset;

        if p16:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = workspace_CurrentCamera.RootPart;

        if v17 and (workspace_CurrentCamera.Parent and workspace_CurrentCamera.Parent:IsA("Model")) then
            RootPart = workspace_CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v18;

            if workspace_CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if workspace_CurrentCamera.AutomaticScalingEnabled then
                    v18 = Vector3.new(0, 1.5, 0);
                    local RootPart2 = workspace_CurrentCamera.RootPart;

                    if RootPart == RootPart2 then
                        v18 = v18 + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0);
                    end;
                else
                    v18 = Vector3.new(0, 2, 0);
                end;
            else
                v18 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectCFrame = RootPart.CFrame * CFrame.new((v17 and Vector3.new(0, 0, 0) or v18) + CameraOffset);
        end;
    elseif workspace_CurrentCamera:IsA("BasePart") then
        lastSubjectCFrame = workspace_CurrentCamera.CFrame;
    elseif workspace_CurrentCamera:IsA("Model") then
        if workspace_CurrentCamera.PrimaryPart then
            lastSubjectCFrame = workspace_CurrentCamera:GetPrimaryPartCFrame();
        else
            lastSubjectCFrame = CFrame.new();
        end;
    end;

    if lastSubjectCFrame then
        p16.lastSubjectCFrame = lastSubjectCFrame;
    end;

    return lastSubjectCFrame;
end;

function u2.GetSubjectVelocity(p19) -- Line: 320
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if workspace_CurrentCamera:IsA("BasePart") then
        return workspace_CurrentCamera.Velocity;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local RootPart = workspace_CurrentCamera.RootPart;

        if RootPart then
            return RootPart.Velocity;
        end;
    else
        local v20 = workspace_CurrentCamera:IsA("Model") and workspace_CurrentCamera.PrimaryPart;

        if v20 then
            return v20.Velocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.GetSubjectRotVelocity(p21) -- Line: 347
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if workspace_CurrentCamera:IsA("BasePart") then
        return workspace_CurrentCamera.RotVelocity;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local RootPart = workspace_CurrentCamera.RootPart;

        if RootPart then
            return RootPart.RotVelocity;
        end;
    else
        local v22 = workspace_CurrentCamera:IsA("Model") and workspace_CurrentCamera.PrimaryPart;

        if v22 then
            return v22.RotVelocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.StepZoom(p23) -- Line: 374
    -- upvalues: CameraInput (copy), ZoomController (copy)
    local currentSubjectDistance = p23.currentSubjectDistance;
    local ZoomDelta = CameraInput.getZoomDelta();

    if math.abs(ZoomDelta) > 0 then
        local v24;

        if ZoomDelta > 0 then
            v24 = math.max(currentSubjectDistance + ZoomDelta * (currentSubjectDistance * 0.5 + 1), p23.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v24 = math.max((currentSubjectDistance + ZoomDelta) / (1 - ZoomDelta * 0.5), 0);
        end;

        p23:SetCameraToSubjectDistance(v24 < p23.FIRST_PERSON_DISTANCE_THRESHOLD and 0 or v24);
    end;

    return ZoomController.GetZoomRadius();
end;

function u2.GetSubjectPosition(p25) -- Line: 399
    local lastSubjectPosition = p25.lastSubjectPosition;
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return nil;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local v26 = workspace_CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = workspace_CurrentCamera.CameraOffset;

        if p25:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = workspace_CurrentCamera.RootPart;

        if v26 and (workspace_CurrentCamera.Parent and workspace_CurrentCamera.Parent:IsA("Model")) then
            RootPart = workspace_CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v27;

            if workspace_CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if workspace_CurrentCamera.AutomaticScalingEnabled then
                    v27 = Vector3.new(0, 1.5, 0);

                    if RootPart == workspace_CurrentCamera.RootPart then
                        v27 = v27 + Vector3.new(0, workspace_CurrentCamera.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v27 = Vector3.new(0, 2, 0);
                end;
            else
                v27 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectPosition = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace((v26 and Vector3.new(0, 0, 0) or v27) + CameraOffset);
        end;
    elseif workspace_CurrentCamera:IsA("VehicleSeat") then
        lastSubjectPosition = workspace_CurrentCamera.CFrame.p + workspace_CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0));
    elseif workspace_CurrentCamera:IsA("SkateboardPlatform") then
        lastSubjectPosition = workspace_CurrentCamera.CFrame.p + Vector3.new(0, 5, 0);
    elseif workspace_CurrentCamera:IsA("BasePart") then
        lastSubjectPosition = workspace_CurrentCamera.CFrame.p;
    elseif workspace_CurrentCamera:IsA("Model") then
        if workspace_CurrentCamera.PrimaryPart then
            lastSubjectPosition = workspace_CurrentCamera:GetPrimaryPartCFrame().p;
        else
            lastSubjectPosition = workspace_CurrentCamera:GetModelCFrame().p;
        end;
    end;

    p25.lastSubject = workspace_CurrentCamera;
    p25.lastSubjectPosition = lastSubjectPosition;

    return lastSubjectPosition;
end;

function u2.OnViewportSizeChanged(p28) -- Line: 476
    -- upvalues: UserInputService (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize;
    p28.portraitMode = ViewportSize.X < ViewportSize.Y;
    p28.isSmallTouchScreen = UserInputService.TouchEnabled and (ViewportSize.Y < 500 and true or ViewportSize.X < 700);
end;

function u2.OnCurrentCameraChanged(u29) -- Line: 484
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled then
        if u29.viewportSizeChangedConn then
            u29.viewportSizeChangedConn:Disconnect();
            u29.viewportSizeChangedConn = nil;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            u29:OnViewportSizeChanged();
            u29.viewportSizeChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 495
                -- upvalues: u29 (copy)
                u29:OnViewportSizeChanged();
            end);
        end;
    end;

    if u29.cameraSubjectChangedConn then
        u29.cameraSubjectChangedConn:Disconnect();
        u29.cameraSubjectChangedConn = nil;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u29.cameraSubjectChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 509
            -- upvalues: u29 (copy)
            u29:OnNewCameraSubject();
        end);
        u29:OnNewCameraSubject();
    end;
end;

function u2.OnPlayerCameraPropertyChange(p30) -- Line: 516
    p30:SetCameraToSubjectDistance(p30.currentSubjectDistance);
end;

function u2.InputTranslationToCameraAngleChange(p31, p32, p33) -- Line: 521
    return p32 * p33;
end;

function u2.GamepadZoomPress(p34) -- Line: 527
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local CameraToSubjectDistance = p34:GetCameraToSubjectDistance();
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;

    for i = #p34.gamepadZoomLevels, 1, -1 do
        local v35 = p34.gamepadZoomLevels[i];
        local v36;

        if CameraMaxZoomDistance < v35 then
            v36 = i;
        else
            if v35 < LocalPlayer.CameraMinZoomDistance then
                v35 = LocalPlayer.CameraMinZoomDistance;

                if u1 and CameraMaxZoomDistance == v35 then
                    break;
                end;
            end;

            if not u1 and CameraMaxZoomDistance == v35 then
                break;
            end;

            if v35 + (CameraMaxZoomDistance - v35) / 2 < CameraToSubjectDistance then
                p34:SetCameraToSubjectDistance(v35);

                return;
            end;

            CameraMaxZoomDistance = v35;
            v36 = i;
        end;
    end;

    p34:SetCameraToSubjectDistance(p34.gamepadZoomLevels[#p34.gamepadZoomLevels]);
end;

function u2.Enable(p37: table, p38: boolean) -- Line: 572
    if p37.enabled ~= p38 then
        p37.enabled = p38;
        p37:OnEnabledChanged();
    end;
end;

function u2.OnEnabledChanged(u39) -- Line: 580
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if not u39.enabled then
        u39._connections:disconnectAll();
        CameraInput.setInputEnabled(false);

        if u39.gamepadZoomPressConnection then
            u39.gamepadZoomPressConnection:Disconnect();
            u39.gamepadZoomPressConnection = nil;
        end;

        u39:Cleanup();

        return;
    end;

    u39:_setUpConfigurations();
    CameraInput.setInputEnabled(true);
    u39.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- Line: 586
        -- upvalues: u39 (copy)
        u39:GamepadZoomPress();
    end);

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        u39.currentSubjectDistance = 0;

        if not u39.inFirstPerson then
            u39:EnterFirstPerson();
        end;
    end;

    if u39.cameraChangedConn then
        u39.cameraChangedConn:Disconnect();
        u39.cameraChangedConn = nil;
    end;

    u39.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 601
        -- upvalues: u39 (copy)
        u39:OnCurrentCameraChanged();
    end);
    u39:OnCurrentCameraChanged();
end;

function u2.GetEnabled(p40) -- Line: 619
    return p40.enabled;
end;

function u2.Cleanup(p41) -- Line: 623
    -- upvalues: CameraUtils (copy)
    if p41.subjectStateChangedConn then
        p41.subjectStateChangedConn:Disconnect();
        p41.subjectStateChangedConn = nil;
    end;

    if p41.viewportSizeChangedConn then
        p41.viewportSizeChangedConn:Disconnect();
        p41.viewportSizeChangedConn = nil;
    end;

    if p41.cameraChangedConn then
        p41.cameraChangedConn:Disconnect();
        p41.cameraChangedConn = nil;
    end;

    p41.lastCameraTransform = nil;
    p41.lastSubjectCFrame = nil;
    CameraUtils.restoreMouseBehavior();
end;

function u2.UpdateMouseBehavior(p42) -- Line: 644
    -- upvalues: UserGameSettings (copy), CameraUI (copy), CameraInput (copy), CameraToggleStateController (copy), CameraUtils (copy)
    if p42.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        CameraUI.setCameraModeToastEnabled(true);
        CameraInput.enableCameraToggleInput();
        CameraToggleStateController(p42.inFirstPerson);

        return;
    end;

    CameraUI.setCameraModeToastEnabled(false);
    CameraInput.disableCameraToggleInput();

    if p42.inFirstPerson or p42.inMouseLockedMode then
        CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);

        return;
    end;

    CameraUtils.restoreRotationType();

    if CameraInput.getRotationActivated() then
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);

        return;
    end;

    CameraUtils.restoreMouseBehavior();
end;

function u2.UpdateForDistancePropertyChange(p43) -- Line: 672
    p43:SetCameraToSubjectDistance(p43.currentSubjectDistance);
end;

function u2.SetCameraToSubjectDistance(p44: table, p45: number) -- Line: 678
    -- upvalues: LocalPlayer (copy), ZoomController (copy)
    local currentSubjectDistance = p44.currentSubjectDistance;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        p44.currentSubjectDistance = 0;

        if not p44.inFirstPerson then
            p44:EnterFirstPerson();
        end;
    else
        local math_clamp_ret = math.clamp(p45, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);

        if math_clamp_ret < 1 then
            p44.currentSubjectDistance = 0;

            if not p44.inFirstPerson then
                p44:EnterFirstPerson();
            end;
        else
            p44.currentSubjectDistance = math_clamp_ret;

            if p44.inFirstPerson then
                p44:LeaveFirstPerson();
            end;
        end;
    end;

    ZoomController.SetZoomParameters(p44.currentSubjectDistance, (math.sign(p45 - currentSubjectDistance)));

    return p44.currentSubjectDistance;
end;

function u2.SetCameraType(p46, p47) -- Line: 716
    p46.cameraType = p47;
end;

function u2.GetCameraType(p48) -- Line: 721
    return p48.cameraType;
end;

function u2.SetCameraMovementMode(p49, p50) -- Line: 726
    p49.cameraMovementMode = p50;
end;

function u2.GetCameraMovementMode(p51) -- Line: 730
    return p51.cameraMovementMode;
end;

function u2.SetIsMouseLocked(p52: table, p53: boolean) -- Line: 734
    p52.inMouseLockedMode = p53;
end;

function u2.GetIsMouseLocked(p54) -- Line: 738
    return p54.inMouseLockedMode;
end;

function u2.SetMouseLockOffset(p55, p56) -- Line: 742
    p55.mouseLockOffset = p56;
end;

function u2.GetMouseLockOffset(p57) -- Line: 746
    return p57.mouseLockOffset;
end;

function u2.InFirstPerson(p58) -- Line: 750
    return p58.inFirstPerson;
end;

function u2.EnterFirstPerson(p59) -- Line: 754
    p59.inFirstPerson = true;
    p59:UpdateMouseBehavior();
end;

function u2.LeaveFirstPerson(p60) -- Line: 759
    p60.inFirstPerson = false;
    p60:UpdateMouseBehavior();
end;

function u2.GetCameraToSubjectDistance(p61) -- Line: 765
    return p61.currentSubjectDistance;
end;

function u2.GetMeasuredDistanceToFocus(p62) -- Line: 772
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        return (workspace_CurrentCamera.CoordinateFrame.p - workspace_CurrentCamera.Focus.p).magnitude;
    end;

    return nil;
end;

function u2.GetCameraLookVector(p63) -- Line: 780
    return workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;

function u2.CalculateNewLookCFrameFromArg(p64: table, p65: vector?, p66) -- Line: 784
    local v67 = p65 or p64:GetCameraLookVector();
    local math_asin_ret = math.asin(v67.Y);
    local math_clamp_ret = math.clamp(p66.Y, math_asin_ret + -1.3962634015954636, math_asin_ret + 1.3962634015954636);
    local Vector2_new_ret = Vector2.new(p66.X, math_clamp_ret);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), v67);

    return CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0);
end;

function u2.CalculateNewLookVectorFromArg(p68: table, p69: vector?, p70) -- Line: 796
    return p68:CalculateNewLookCFrameFromArg(p69, p70).LookVector;
end;

function u2.CalculateNewLookVectorVRFromArg(p71: table, p72) -- Line: 801
    local unit = ((p71:GetSubjectPosition() - workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit;
    local Vector2_new_ret = Vector2.new(p72.X, 0);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), unit);

    return ((CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;

function u2.GetHumanoid(p73) -- Line: 815
    -- upvalues: LocalPlayer (copy)
    local v74 = LocalPlayer and LocalPlayer.Character;

    if not v74 then
        return nil;
    end;

    local v75 = p73.humanoidCache[LocalPlayer];

    if v75 and v75.Parent == v74 then
        return v75;
    end;

    p73.humanoidCache[LocalPlayer] = nil;
    local v76 = v74:FindFirstChildOfClass("Humanoid");

    if v76 then
        p73.humanoidCache[LocalPlayer] = v76;
    end;

    return v76;
end;

function u2.GetHumanoidPartToFollow(p77: table, p78: userdata, p79: any) -- Line: 833
    if p79 ~= Enum.HumanoidStateType.Dead then
        return p78.Torso;
    end;

    local Parent = p78.Parent;

    if Parent then
        return Parent:FindFirstChild("Head") or p78.Torso;
    end;

    return p78.Torso;
end;

function u2.OnNewCameraSubject(p80) -- Line: 846
    if p80.subjectStateChangedConn then
        p80.subjectStateChangedConn:Disconnect();
        p80.subjectStateChangedConn = nil;
    end;
end;

function u2.IsInFirstPerson(p81) -- Line: 853
    return p81.inFirstPerson;
end;

function u2.Update(p82, p83) -- Line: 857
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;

function u2.GetCameraHeight(p84) -- Line: 861
    -- upvalues: VRService (copy)
    return (not VRService.VREnabled or p84.inFirstPerson) and 0 or 0.25881904510252074 * p84.currentSubjectDistance;
end;

return u2;