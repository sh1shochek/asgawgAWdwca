-- Decompiled with Potassium's decompiler.

local success, result = pcall(function() -- Line: 9
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2");
end);
local u1 = success and result;
local u2 = { 0, 30 };
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
require(script.Parent:WaitForChild("VehicleCamera"));
local VehicleCameraCore = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"));
local VehicleCameraConfig = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"));
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local VRService = game:GetService("VRService");
local LocalPlayer = Players.LocalPlayer;
local Spring = CameraUtils.Spring;
local mapClamp = CameraUtils.mapClamp;
local sanitizeAngle = CameraUtils.sanitizeAngle;

local function pitchVelocity(p3, p4) -- Line: 46
    local v5 = p4.XVector:Dot(p3);

    return math.abs(v5);
end;

local function yawVelocity(p6, p7) -- Line: 51
    local v8 = p7.YVector:Dot(p6);

    return math.abs(v8);
end;

local u9 = 0.016666666666666666;
local u10 = setmetatable({}, VRBaseCamera);
u10.__index = u10;

function u10.new() -- Line: 59
    -- upvalues: VRBaseCamera (copy), u10 (copy), RunService (copy), u9 (ref)
    local v11 = VRBaseCamera.new();
    local v12 = setmetatable(v11, u10);
    v12:Reset();
    RunService.Stepped:Connect(function(p13, p14) -- Line: 64
        -- upvalues: u9 (ref)
        u9 = p14;
    end);

    return v12;
end;

function u10.Reset(p15) -- Line: 72
    -- upvalues: VehicleCameraCore (copy), u1 (ref), Spring (copy), VehicleCameraConfig (copy), CameraUtils (copy), u2 (copy)
    p15.vehicleCameraCore = VehicleCameraCore.new(p15:GetSubjectCFrame());

    if u1 then
        p15.pitchSpring = Spring.new(0, 0);
    else
        p15.pitchSpring = Spring.new(0, -math.rad(VehicleCameraConfig.pitchBaseAngle));
    end;

    p15.yawSpring = Spring.new(0, 0);

    if u1 then
        p15.lastPanTick = 0;
        p15.currentDriftAngle = 0;
        p15.needsReset = true;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v16;

    if workspace_CurrentCamera then
        v16 = workspace_CurrentCamera.CameraSubject;
    else
        v16 = workspace_CurrentCamera;
    end;

    assert(workspace_CurrentCamera, "VRVehicleCamera initialization error");
    assert(v16);
    assert(v16:IsA("VehicleSeat"));
    local ConnectedParts = v16:GetConnectedParts(true);
    local LooseBoundingSphere, v17 = CameraUtils.getLooseBoundingSphere(ConnectedParts);
    p15.assemblyRadius = math.max(v17, 5);
    p15.assemblyOffset = v16.CFrame:Inverse() * LooseBoundingSphere;
    p15.gamepadZoomLevels = {};

    for _, v in u2 do
        table.insert(p15.gamepadZoomLevels, v * p15.headScale * p15.assemblyRadius / 10);
    end;

    p15.lastCameraFocus = nil;
    p15:SetCameraToSubjectDistance(p15.gamepadZoomLevels[#p15.gamepadZoomLevels]);
end;

function u10._StepRotation(p18, p19, p20) -- Line: 112
    -- upvalues: sanitizeAngle (copy), CameraInput (copy), VehicleCameraConfig (copy), mapClamp (copy)
    local yawSpring = p18.yawSpring;
    local pitchSpring = p18.pitchSpring;
    local v21 = -p18:getRotation(p19);
    yawSpring.pos = sanitizeAngle(yawSpring.pos + v21);
    pitchSpring.pos = sanitizeAngle((math.clamp(pitchSpring.pos, -1.3962634015954636, 1.3962634015954636)));

    if CameraInput.getRotationActivated() then
        p18.lastPanTick = os.clock();
    end;

    local math_rad_ret = math.rad(VehicleCameraConfig.pitchDeadzoneAngle);

    if os.clock() - p18.lastPanTick > VehicleCameraConfig.autocorrectDelay then
        local v22 = mapClamp(p20, VehicleCameraConfig.autocorrectMinCarSpeed, VehicleCameraConfig.autocorrectMaxCarSpeed, 0, VehicleCameraConfig.autocorrectResponse);
        yawSpring.freq = v22;
        pitchSpring.freq = v22;

        if yawSpring.freq < 0.001 then
            yawSpring.vel = 0;
        end;

        if pitchSpring.freq < 0.001 then
            pitchSpring.vel = 0;
        end;

        local v23 = sanitizeAngle(0 - pitchSpring.pos);

        if math.abs(v23) <= math_rad_ret then
            pitchSpring.goal = pitchSpring.pos;
        else
            pitchSpring.goal = 0;
        end;
    else
        yawSpring.freq = 0;
        yawSpring.vel = 0;
        pitchSpring.freq = 0;
        pitchSpring.vel = 0;
        pitchSpring.goal = 0;
    end;

    return CFrame.fromEulerAnglesYXZ(pitchSpring:step(p19), yawSpring:step(p19), 0);
end;

function u10._GetThirdPersonLocalOffset(p24) -- Line: 176
    -- upvalues: VehicleCameraConfig (copy)
    return p24.assemblyOffset + Vector3.new(0, p24.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0);
end;

function u10._GetFirstPersonLocalOffset(p25: table, p26) -- Line: 180
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head");

        if Head and Head:IsA("BasePart") then
            return p26:Inverse() * Head.Position;
        end;
    end;

    return p25:_GetThirdPersonLocalOffset();
end;

function u10.Update(p27) -- Line: 194
    -- upvalues: u1 (ref), u9 (ref), LocalPlayer (copy), VRService (copy)
    if not u1 then
        return p27:UpdateComfortCamera();
    end;

    local v28 = u9;
    u9 = 0;
    p27:UpdateFadeFromBlack(v28);
    p27:UpdateEdgeBlur(LocalPlayer, v28);

    if VRService.ThirdPersonFollowCamEnabled then
        local v29, v30 = p27:UpdateStepRotation(v28);

        return v29, v30;
    end;

    local v31, v32 = p27:UpdateComfortCamera(v28);

    return v31, v32;
end;

function u10.addDrift(p33, p34, p35) -- Line: 217
    -- upvalues: LocalPlayer (copy), VRService (copy)
    local function NormalizeAngle(p36) -- Line: 218
        local v37 = (p36 + 12.566370614359172) % 6.283185307179586;

        if v37 > 3.141592653589793 then
            v37 = v37 - 6.283185307179586;
        end;

        return v37;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CameraToSubjectDistance = p33:GetCameraToSubjectDistance();
    local SubjectVelocity = p33:GetSubjectVelocity();
    local SubjectCFrame = p33:GetSubjectCFrame();
    require(LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));

    if SubjectVelocity.Magnitude > 0.1 then
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
        local v38 = workspace_CurrentCamera.CFrame * (UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale);
        local _, v39, _ = v38:ToEulerAnglesYXZ();
        local _, v40, _ = SubjectCFrame:ToEulerAnglesYXZ();
        local v41 = (v39 - p33.currentDriftAngle + 12.566370614359172) % 6.283185307179586;

        if v41 > 3.141592653589793 then
            v41 = v41 - 6.283185307179586;
        end;

        local v42 = (v40 - p33.currentDriftAngle + 12.566370614359172) % 6.283185307179586;

        if v42 > 3.141592653589793 then
            v42 = v42 - 6.283185307179586;
        end;

        local math_min_ret = math.min(v42, v41);
        local math_max_ret = math.max(v42, v41);
        local v43 = 0;

        if math_min_ret > 0 then
            math_max_ret = math_min_ret;
        elseif math_max_ret >= 0 then
            math_max_ret = v43;
        end;

        p33.currentDriftAngle = math_max_ret + p33.currentDriftAngle;
        local LookVector = CFrame.fromEulerAnglesYXZ(0, p33.currentDriftAngle, 0).LookVector;
        local v44 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance;
        p34 = p34:Lerp(CFrame.new(workspace_CurrentCamera.CFrame.Position + (p35.Position - v44) - v38.Position) * workspace_CurrentCamera.CFrame.Rotation, 0.01);
    end;

    return p34, p35;
end;

function u10.UpdateRotationCamera(p45, p46) -- Line: 275
    -- upvalues: mapClamp (copy), LocalPlayer (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v47;

    if workspace_CurrentCamera then
        v47 = workspace_CurrentCamera.CameraSubject;
    else
        v47 = workspace_CurrentCamera;
    end;

    local vehicleCameraCore = p45.vehicleCameraCore;
    assert(workspace_CurrentCamera);
    assert(v47);
    assert(v47:IsA("VehicleSeat"));
    local SubjectCFrame = p45:GetSubjectCFrame();
    local SubjectVelocity = p45:GetSubjectVelocity();
    local SubjectRotVelocity = p45:GetSubjectRotVelocity();
    local v48 = SubjectVelocity:Dot(SubjectCFrame.ZVector);
    local math_abs_ret = math.abs(v48);
    local v49 = SubjectCFrame.YVector:Dot(SubjectRotVelocity);
    local math_abs_ret2 = math.abs(v49);
    local v50 = SubjectCFrame.XVector:Dot(SubjectRotVelocity);
    local math_abs_ret3 = math.abs(v50);
    local CameraToSubjectDistance = p45:GetCameraToSubjectDistance();
    local v51 = mapClamp(CameraToSubjectDistance, 0.5, p45.assemblyRadius, 1, 0);
    local v52 = p45:_GetThirdPersonLocalOffset():Lerp(p45:_GetFirstPersonLocalOffset(SubjectCFrame), v51);
    vehicleCameraCore:setTransform(SubjectCFrame);
    local v53 = vehicleCameraCore:step(p46, math_abs_ret3, math_abs_ret2, v51);
    local v54 = p45:_StepRotation(p46, math_abs_ret);
    local v55 = p45:GetVRFocus(SubjectCFrame * v52, p46) * v53 * v54;
    local v56 = v55 * CFrame.new(0, 0, CameraToSubjectDistance);

    if SubjectVelocity.Magnitude > 0.1 then
        p45:StartVREdgeBlur(LocalPlayer);
    end;

    return v56, v55;
end;

function u10.UpdateStepRotation(p57, p58) -- Line: 322
    -- upvalues: mapClamp (copy), UserGameSettings (copy), VRService (copy), LocalPlayer (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local lastSubjectCFrame = p57.lastSubjectCFrame;
    local SubjectCFrame = p57:GetSubjectCFrame();
    local SubjectVelocity = p57:GetSubjectVelocity();
    local CameraToSubjectDistance = p57:GetCameraToSubjectDistance();
    local v59 = mapClamp(CameraToSubjectDistance, 0.5, p57.assemblyRadius, 1, 0);
    local v60 = p57:_GetThirdPersonLocalOffset():Lerp(p57:_GetFirstPersonLocalOffset(SubjectCFrame), v59);
    local VRFocus = p57:GetVRFocus(SubjectCFrame * v60, p58);
    local v61, v62 = p57:addDrift(VRFocus:ToWorldSpace(p57:GetVRFocus(lastSubjectCFrame * v60, p58):ToObjectSpace(workspace_CurrentCamera.CFrame)), VRFocus);
    local Rotation = p57:getRotation(p58);
    local v63;

    if math.abs(Rotation) > 0 then
        local v64 = v62:ToObjectSpace(v61);
        v63 = v62 * CFrame.Angles(0, -Rotation, 0) * v64;

        if not UserGameSettings.VRSmoothRotationEnabled then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v65 = UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale;
            local v66 = v62 * SubjectCFrame.Rotation;
            local v67 = v66:ToObjectSpace(v61 * v65);
            local v68 = Vector3.new(v67.X, 0, v67.Z).Unit:Dot(Vector3.new(0, 0, 1));
            local math_acos_ret = math.acos(v68);
            local v69 = v66:ToObjectSpace(v63 * v65);
            local v70 = Vector3.new(v69.X, 0, v69.Z).Unit:Dot(Vector3.new(0, 0, 1));

            if math.acos(v70) < math_acos_ret then
                if Rotation < 0 then
                    math_acos_ret = math_acos_ret * -1;
                end;

                v63 = v62 * CFrame.Angles(0, -math_acos_ret, 0) * v64;
            end;
        end;
    else
        v63 = v61;
    end;

    if SubjectVelocity.Magnitude > 0.1 then
        p57:StartVREdgeBlur(LocalPlayer);
    end;

    if p57.needsReset then
        p57.needsReset = false;
        VRService:RecenterUserHeadCFrame();
        p57:StartFadeFromBlack();
        p57:ResetZoom();
    end;

    if p57.recentered then
        v63 = v62 * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance);
        p57.recentered = false;
    end;

    return v63, v63 * CFrame.new(0, 0, -CameraToSubjectDistance);
end;

function u10.UpdateComfortCamera(p71, p72) -- Line: 408
    -- upvalues: u1 (ref), u9 (ref), mapClamp (copy), LocalPlayer (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v73;

    if workspace_CurrentCamera then
        v73 = workspace_CurrentCamera.CameraSubject;
    else
        v73 = workspace_CurrentCamera;
    end;

    local vehicleCameraCore = p71.vehicleCameraCore;
    assert(workspace_CurrentCamera);
    assert(v73);
    assert(v73:IsA("VehicleSeat"));

    if not u1 then
        p72 = u9;
        u9 = 0;
    end;

    local SubjectCFrame = p71:GetSubjectCFrame();
    local SubjectVelocity = p71:GetSubjectVelocity();
    local SubjectRotVelocity = p71:GetSubjectRotVelocity();
    local v74 = SubjectVelocity:Dot(SubjectCFrame.ZVector);
    math.abs(v74);
    local v75 = SubjectCFrame.YVector:Dot(SubjectRotVelocity);
    local math_abs_ret = math.abs(v75);
    local v76 = SubjectCFrame.XVector:Dot(SubjectRotVelocity);
    local math_abs_ret2 = math.abs(v76);
    local v77 = p71:StepZoom();
    local v78 = mapClamp(v77, 0.5, p71.assemblyRadius, 1, 0);
    local v79 = p71:_GetThirdPersonLocalOffset():Lerp(p71:_GetFirstPersonLocalOffset(SubjectCFrame), v78);
    vehicleCameraCore:setTransform(SubjectCFrame);
    local v80 = vehicleCameraCore:step(p72, math_abs_ret2, math_abs_ret, v78);

    if not u1 then
        p71:UpdateFadeFromBlack(p72);
    end;

    local v81, v82;

    if p71:IsInFirstPerson() then
        local Unit = Vector3.new(v80.LookVector.X, 0, v80.LookVector.Z).Unit;
        local CFrame_new_ret = CFrame.new(v80.Position, Unit);
        v81 = CFrame.new(SubjectCFrame * v79) * CFrame_new_ret;
        v82 = v81 * CFrame.new(0, 0, v77);

        if u1 then
            if SubjectVelocity.Magnitude > 0.1 then
                p71:StartVREdgeBlur(LocalPlayer);
            end;
        else
            p71:StartVREdgeBlur(LocalPlayer);
        end;
    else
        v81 = CFrame.new(SubjectCFrame * v79) * v80;
        v82 = v81 * CFrame.new(0, 0, v77);

        if not p71.lastCameraFocus then
            p71.lastCameraFocus = v81;
            p71.needsReset = true;
        end;

        local v83 = v81.Position - workspace_CurrentCamera.CFrame.Position;
        local magnitude = v83.magnitude;

        if v83.Unit:Dot(workspace_CurrentCamera.CFrame.LookVector) > 0.56 and (magnitude < 200 and not p71.needsReset) then
            v81 = p71.lastCameraFocus;
            local p = v81.p;
            local CameraLookVector = p71:GetCameraLookVector();
            local v84 = p71:CalculateNewLookVectorFromArg(Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit, Vector2.new(0, 0));
            v82 = CFrame.new(p - v77 * v84, p);
        else
            p71.lastCameraFocus = p71:GetVRFocus(SubjectCFrame.Position, p72);
            p71.needsReset = false;
            p71:StartFadeFromBlack();
            p71:ResetZoom();
        end;

        if not u1 then
            p71:UpdateEdgeBlur(LocalPlayer, p72);
        end;
    end;

    return v82, v81;
end;

return u10;