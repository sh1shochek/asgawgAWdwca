-- Decompiled with Potassium's decompiler.

Vector2.new(0, 0);
local u1 = 0;
local CFrame_fromOrientation_ret = CFrame.fromOrientation(-0.2617993877991494, 0, 0);
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local UserFlag = FlagUtil.getUserFlag("UserCameraInputDt");
local UserFlag2 = FlagUtil.getUserFlag("UserFixCameraFPError");
local Players = game:GetService("Players");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u2 = setmetatable({}, BaseCamera);
u2.__index = u2;

function u2.new() -- Line: 40
    -- upvalues: BaseCamera (copy), u2 (copy), CameraUtils (copy)
    local v3 = BaseCamera.new();
    local v4 = setmetatable(v3, u2);
    v4.isFollowCamera = false;
    v4.isCameraToggle = false;
    v4.lastUpdate = tick();
    v4.cameraToggleSpring = CameraUtils.Spring.new(5, 0);

    return v4;
end;

function u2.GetCameraToggleOffset(p5: table, p6: number) -- Line: 51
    -- upvalues: CameraInput (copy), CameraUtils (copy)
    if not p5.isCameraToggle then
        return Vector3.new();
    end;

    local currentSubjectDistance = p5.currentSubjectDistance;

    if CameraInput.getTogglePan() then
        local cameraToggleSpring = p5.cameraToggleSpring;
        local v7 = CameraUtils.map(currentSubjectDistance, 0, p5.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1);
        cameraToggleSpring.goal = math.clamp(v7, 0, 1);
    else
        p5.cameraToggleSpring.goal = 0;
    end;

    local v8 = CameraUtils.map(currentSubjectDistance, 0, 64, 0, 1);
    local v9 = math.clamp(v8, 0, 1) + 1;
    local v10 = p5.cameraToggleSpring:step(p6) * v9;

    return Vector3.new(0, v10, 0);
end;

function u2.SetCameraMovementMode(p11, p12) -- Line: 73
    -- upvalues: BaseCamera (copy)
    BaseCamera.SetCameraMovementMode(p11, p12);
    p11.isFollowCamera = p12 == Enum.ComputerCameraMovementMode.Follow;
    p11.isCameraToggle = p12 == Enum.ComputerCameraMovementMode.CameraToggle;
end;

function u2.Update(p13, p14) -- Line: 80
    -- upvalues: UserFlag (copy), CFrame_fromOrientation_ret (copy), Players (copy), CameraInput (copy), u1 (ref), CameraUtils (copy), UserFlag2 (copy)
    local v15 = tick();
    local v16 = v15 - p13.lastUpdate;

    if UserFlag then
        v16 = p14;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local v17;

    if p13.resetCameraAngle then
        local HumanoidRootPart = p13:GetHumanoidRootPart();

        if HumanoidRootPart then
            v17 = (HumanoidRootPart.CFrame * CFrame_fromOrientation_ret).lookVector;
        else
            v17 = CFrame_fromOrientation_ret.lookVector;
        end;

        p13.resetCameraAngle = false;
    else
        v17 = nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local Humanoid = p13:GetHumanoid();
    local CameraSubject = workspace_CurrentCamera.CameraSubject;
    local v18;

    if CameraSubject then
        v18 = CameraSubject:IsA("VehicleSeat");
    else
        v18 = CameraSubject;
    end;

    local v19;

    if CameraSubject then
        v19 = CameraSubject:IsA("SkateboardPlatform");
    else
        v19 = CameraSubject;
    end;

    local v20;

    if Humanoid then
        v20 = Humanoid:GetState() == Enum.HumanoidStateType.Climbing;
    else
        v20 = Humanoid;
    end;

    if p13.lastUpdate == nil or v16 > 1 then
        p13.lastCameraTransform = nil;
    end;

    local Rotation = CameraInput.getRotation(v16);
    p13:StepZoom();
    local CameraHeight = p13:GetCameraHeight();

    if Rotation ~= Vector2.new() then
        u1 = 0;
        p13.lastUserPanCamera = tick();
    end;

    local v21 = v15 - p13.lastUserPanCamera < 2;
    local SubjectPosition = p13:GetSubjectPosition();

    if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
        local CameraToSubjectDistance = p13:GetCameraToSubjectDistance();
        local v22 = CameraToSubjectDistance < 0 and 0 or CameraToSubjectDistance;

        if p13:GetIsMouseLocked() and not p13:IsInFirstPerson() then
            local v23 = p13:CalculateNewLookCFrameFromArg(v17, Rotation);
            local MouseLockOffset = p13:GetMouseLockOffset();

            if Humanoid then
                MouseLockOffset = MouseLockOffset + Humanoid.CameraOffset;
            end;

            local v24 = MouseLockOffset.X * v23.RightVector + MouseLockOffset.Y * v23.UpVector + MouseLockOffset.Z * v23.LookVector;

            if CameraUtils.IsFiniteVector3(v24) then
                SubjectPosition = SubjectPosition + v24;
            end;
        elseif Rotation == Vector2.new() and p13.lastCameraTransform then
            local v25 = p13:IsInFirstPerson();

            if (v18 or (v19 or p13.isFollowCamera and v20)) and (p13.lastUpdate and (Humanoid and Humanoid.Torso)) then
                if v25 then
                    if p13.lastSubjectCFrame and (v18 or v19) and CameraSubject:IsA("BasePart") then
                        local v26 = -CameraUtils.GetAngleBetweenXZVectors(p13.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector);

                        if CameraUtils.IsFinite(v26) then
                            Rotation = Rotation + Vector2.new(v26, 0);
                        end;

                        u1 = 0;
                    end;
                elseif not v21 then
                    local lookVector = Humanoid.Torso.CFrame.lookVector;
                    u1 = math.clamp(u1 + 3.839724354387525 * v16, 0, 4.363323129985824);
                    local math_clamp_ret = math.clamp(u1 * v16, 0, 1);
                    local v27 = p13:IsInFirstPerson() and not (p13.isFollowCamera and p13.isClimbing) and 1 or math_clamp_ret;
                    local AngleBetweenXZVectors = CameraUtils.GetAngleBetweenXZVectors(lookVector, p13:GetCameraLookVector());

                    if CameraUtils.IsFinite(AngleBetweenXZVectors) and math.abs(AngleBetweenXZVectors) > 0.0001 then
                        Rotation = Rotation + Vector2.new(AngleBetweenXZVectors * v27, 0);
                    end;
                end;
            elseif p13.isFollowCamera and not (v25 or v21) then
                local AngleBetweenXZVectors = CameraUtils.GetAngleBetweenXZVectors(-(p13.lastCameraTransform.p - SubjectPosition), p13:GetCameraLookVector());

                if CameraUtils.IsFinite(AngleBetweenXZVectors) and (math.abs(AngleBetweenXZVectors) > 0.0001 and math.abs(AngleBetweenXZVectors) > 0.4 * v16) then
                    Rotation = Rotation + Vector2.new(AngleBetweenXZVectors, 0);
                end;
            end;
        end;

        local v28, v29;

        if p13.isFollowCamera then
            local v30 = p13:CalculateNewLookVectorFromArg(v17, Rotation);
            v28 = CFrame.new(SubjectPosition);
            local v31 = v28.p - v22 * v30;

            if v22 <= 0 then
                v29 = CFrame.lookAlong(v28.p, v30);
            elseif UserFlag2 then
                v29 = CFrame.lookAlong(v31, v30);
            else
                v29 = CFrame.new(v31, v28.p) + Vector3.new(0, CameraHeight, 0);
            end;
        else
            v28 = CFrame.new(SubjectPosition);
            local p = v28.p;
            local v32 = p13:CalculateNewLookVectorFromArg(v17, Rotation);
            local v33 = p - v22 * v32;

            if v22 <= 0 then
                v29 = CFrame.lookAlong(p, v32);
            elseif UserFlag2 then
                v29 = CFrame.lookAlong(v33, v32);
            else
                v29 = CFrame.new(v33, p);
            end;
        end;

        local CameraToggleOffset = p13:GetCameraToggleOffset(v16);
        Focus = v28 + CameraToggleOffset;
        CFrame2 = v29 + CameraToggleOffset;
        p13.lastCameraTransform = CFrame2;
        p13.lastCameraFocus = Focus;

        if (v18 or v19) and CameraSubject:IsA("BasePart") then
            p13.lastSubjectCFrame = CameraSubject.CFrame;
        else
            p13.lastSubjectCFrame = nil;
        end;
    end;

    p13.lastUpdate = v15;

    return CFrame2, Focus;
end;

return u2;