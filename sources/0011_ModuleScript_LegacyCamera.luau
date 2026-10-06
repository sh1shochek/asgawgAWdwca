-- Decompiled with Potassium's decompiler.

Vector2.new();
require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 21
    -- upvalues: BaseCamera (copy), u1 (copy)
    local v2 = BaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.cameraType = Enum.CameraType.Fixed;
    v3.lastUpdate = tick();
    v3.lastDistanceToSubject = nil;

    return v3;
end;

function u1.GetModuleName(p4) -- Line: 31
    return "LegacyCamera";
end;

function u1.SetCameraToSubjectDistance(p5, p6) -- Line: 36
    -- upvalues: BaseCamera (copy)
    return BaseCamera.SetCameraToSubjectDistance(p5, p6);
end;

function u1.Update(p7: table, p8: number) -- Line: 40
    -- upvalues: Players (copy), CameraInput (copy)
    if not p7.cameraType then
        return nil, nil;
    end;

    local v9 = tick();
    local v10 = v9 - p7.lastUpdate;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    local Rotation = CameraInput.getRotation(p8);

    if p7.lastUpdate == nil or v10 > 1 then
        p7.lastDistanceToSubject = nil;
    end;

    local SubjectPosition = p7:GetSubjectPosition();

    if p7.cameraType == Enum.CameraType.Fixed then
        if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
            local CameraToSubjectDistance = p7:GetCameraToSubjectDistance();
            local v11 = p7:CalculateNewLookVectorFromArg(nil, Rotation);
            Focus = workspace_CurrentCamera.Focus;
            CFrame2 = CFrame.new(workspace_CurrentCamera.CFrame.p, workspace_CurrentCamera.CFrame.p + CameraToSubjectDistance * v11);
        end;
    elseif p7.cameraType == Enum.CameraType.Attach then
        local SubjectCFrame = p7:GetSubjectCFrame();
        local v12 = workspace_CurrentCamera.CFrame:ToEulerAnglesYXZ();
        local _, v13 = SubjectCFrame:ToEulerAnglesYXZ();
        local math_clamp_ret = math.clamp(v12 - Rotation.Y, -1.3962634015954636, 1.3962634015954636);
        Focus = CFrame.new(SubjectCFrame.p) * CFrame.fromEulerAnglesYXZ(math_clamp_ret, v13, 0);
        CFrame2 = Focus * CFrame.new(0, 0, p7:StepZoom());
    else
        if p7.cameraType ~= Enum.CameraType.Watch then
            return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
        end;

        if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
            local v14 = nil;

            if SubjectPosition == workspace_CurrentCamera.CFrame.p then
                warn("Camera cannot watch subject in same position as itself");

                return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
            end;

            local Humanoid = p7:GetHumanoid();

            if Humanoid and Humanoid.RootPart then
                local v15 = SubjectPosition - workspace_CurrentCamera.CFrame.p;
                v14 = v15.unit;

                if p7.lastDistanceToSubject and p7.lastDistanceToSubject == p7:GetCameraToSubjectDistance() then
                    p7:SetCameraToSubjectDistance(v15.magnitude);
                end;
            end;

            local CameraToSubjectDistance = p7:GetCameraToSubjectDistance();
            local v16 = p7:CalculateNewLookVectorFromArg(v14, Rotation);
            Focus = CFrame.new(SubjectPosition);
            CFrame2 = CFrame.new(SubjectPosition - CameraToSubjectDistance * v16, SubjectPosition);
            p7.lastDistanceToSubject = CameraToSubjectDistance;
        end;
    end;

    p7.lastUpdate = v9;

    return CFrame2, Focus;
end;

return u1;