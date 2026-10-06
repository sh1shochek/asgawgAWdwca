-- Decompiled with Potassium's decompiler.

local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 42
    -- upvalues: BaseCamera (copy), u1 (copy)
    local v2 = BaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.changedSignalConnections = {};
    v3.refAzimuthRad = nil;
    v3.curAzimuthRad = nil;
    v3.minAzimuthAbsoluteRad = nil;
    v3.maxAzimuthAbsoluteRad = nil;
    v3.useAzimuthLimits = nil;
    v3.curElevationRad = nil;
    v3.minElevationRad = nil;
    v3.maxElevationRad = nil;
    v3.curDistance = nil;
    v3.minDistance = nil;
    v3.maxDistance = nil;
    v3.gamepadDollySpeedMultiplier = 1;
    v3.lastUserPanCamera = tick();
    v3.externalProperties = {};
    v3.externalProperties.InitialDistance = 25;
    v3.externalProperties.MinDistance = 10;
    v3.externalProperties.MaxDistance = 100;
    v3.externalProperties.InitialElevation = 35;
    v3.externalProperties.MinElevation = 35;
    v3.externalProperties.MaxElevation = 35;
    v3.externalProperties.ReferenceAzimuth = -45;
    v3.externalProperties.CWAzimuthTravel = 90;
    v3.externalProperties.CCWAzimuthTravel = 90;
    v3.externalProperties.UseAzimuthLimits = false;
    v3:LoadNumberValueParameters();

    return v3;
end;

function u1.LoadOrCreateNumberValueParameter(u4: table, u5: string, p6: any, u7: any) -- Line: 81
    local v8 = script:FindFirstChild(u5);

    if v8 and v8:IsA(p6) then
        u4.externalProperties[u5] = v8.Value;
    else
        if u4.externalProperties[u5] == nil then
            return;
        end;

        v8 = Instance.new(p6);
        v8.Name = u5;
        v8.Parent = script;
        v8.Value = u4.externalProperties[u5];
    end;

    if u7 then
        if u4.changedSignalConnections[u5] then
            u4.changedSignalConnections[u5]:Disconnect();
        end;

        u4.changedSignalConnections[u5] = v8.Changed:Connect(function(p9) -- Line: 101
            -- upvalues: u4 (copy), u5 (copy), u7 (copy)
            u4.externalProperties[u5] = p9;
            u7(u4);
        end);
    end;
end;

function u1.SetAndBoundsCheckAzimuthValues(p10) -- Line: 108
    local math_rad_ret = math.rad(p10.externalProperties.ReferenceAzimuth);
    local math_rad_ret2 = math.rad(p10.externalProperties.CWAzimuthTravel);
    p10.minAzimuthAbsoluteRad = math_rad_ret - math.abs(math_rad_ret2);
    local math_rad_ret3 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local math_rad_ret4 = math.rad(p10.externalProperties.CCWAzimuthTravel);
    p10.maxAzimuthAbsoluteRad = math_rad_ret3 + math.abs(math_rad_ret4);
    p10.useAzimuthLimits = p10.externalProperties.UseAzimuthLimits;

    if p10.useAzimuthLimits then
        p10.curAzimuthRad = math.max(p10.curAzimuthRad, p10.minAzimuthAbsoluteRad);
        p10.curAzimuthRad = math.min(p10.curAzimuthRad, p10.maxAzimuthAbsoluteRad);
    end;
end;

function u1.SetAndBoundsCheckElevationValues(p11) -- Line: 118
    local math_max_ret = math.max(p11.externalProperties.MinElevation, -80);
    local math_min_ret = math.min(p11.externalProperties.MaxElevation, 80);
    local math_min_ret2 = math.min(math_max_ret, math_min_ret);
    p11.minElevationRad = math.rad(math_min_ret2);
    local math_max_ret2 = math.max(math_max_ret, math_min_ret);
    p11.maxElevationRad = math.rad(math_max_ret2);
    p11.curElevationRad = math.max(p11.curElevationRad, p11.minElevationRad);
    p11.curElevationRad = math.min(p11.curElevationRad, p11.maxElevationRad);
end;

function u1.SetAndBoundsCheckDistanceValues(p12) -- Line: 134
    p12.minDistance = p12.externalProperties.MinDistance;
    p12.maxDistance = p12.externalProperties.MaxDistance;
    p12.curDistance = math.max(p12.curDistance, p12.minDistance);
    p12.curDistance = math.min(p12.curDistance, p12.maxDistance);
end;

function u1.LoadNumberValueParameters(p13) -- Line: 142
    p13:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil);
    p13:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil);
    p13:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", p13.SetAndBoundsCheckAzimuthValue);
    p13:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p13.SetAndBoundsCheckAzimuthValues);
    p13:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p13.SetAndBoundsCheckAzimuthValues);
    p13:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p13.SetAndBoundsCheckElevationValues);
    p13:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p13.SetAndBoundsCheckElevationValues);
    p13:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p13.SetAndBoundsCheckDistanceValues);
    p13:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p13.SetAndBoundsCheckDistanceValues);
    p13:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p13.SetAndBoundsCheckAzimuthValues);
    p13.curAzimuthRad = math.rad(p13.externalProperties.ReferenceAzimuth);
    p13.curElevationRad = math.rad(p13.externalProperties.InitialElevation);
    p13.curDistance = p13.externalProperties.InitialDistance;
    p13:SetAndBoundsCheckAzimuthValues();
    p13:SetAndBoundsCheckElevationValues();
    p13:SetAndBoundsCheckDistanceValues();
end;

function u1.GetModuleName(p14) -- Line: 167
    return "OrbitalCamera";
end;

function u1.SetInitialOrientation(p15: table, p16: userdata) -- Line: 171
    -- upvalues: CameraUtils (copy)
    if not (p16 and p16.RootPart) then
        warn("OrbitalCamera could not set initial orientation due to missing humanoid");

        return;
    end;

    assert(p16.RootPart, "");
    local Unit = (p16.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit;
    local AngleBetweenXZVectors = CameraUtils.GetAngleBetweenXZVectors(Unit, p15:GetCameraLookVector());
    local Y = p15:GetCameraLookVector().Y;
    local v17 = math.asin(Y) - math.asin(Unit.Y);
    CameraUtils.IsFinite(AngleBetweenXZVectors);
    CameraUtils.IsFinite(v17);
end;

function u1.GetCameraToSubjectDistance(p18) -- Line: 189
    return p18.curDistance;
end;

function u1.SetCameraToSubjectDistance(p19, p20) -- Line: 193
    -- upvalues: Players (copy)
    if Players.LocalPlayer then
        p19.currentSubjectDistance = math.clamp(p20, p19.minDistance, p19.maxDistance);
        p19.currentSubjectDistance = math.max(p19.currentSubjectDistance, p19.FIRST_PERSON_DISTANCE_THRESHOLD);
    end;

    p19.inFirstPerson = false;
    p19:UpdateMouseBehavior();

    return p19.currentSubjectDistance;
end;

function u1.CalculateNewLookVector(p21: table, p22: vector, p23) -- Line: 206
    local v24 = p22 or p21:GetCameraLookVector();
    local math_asin_ret = math.asin(v24.Y);
    local math_clamp_ret = math.clamp(p23.Y, math_asin_ret - 1.3962634015954636, math_asin_ret - -1.3962634015954636);
    local Vector2_new_ret = Vector2.new(p23.X, math_clamp_ret);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), v24);

    return (CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0)).LookVector;
end;

function u1.Update(p25: table, p26: number) -- Line: 217
    -- upvalues: CameraInput (copy), Players (copy)
    local v27 = tick();
    local v28 = v27 - p25.lastUpdate;
    local v29 = CameraInput.getRotation(p26) ~= Vector2.new();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    local v30;

    if workspace_CurrentCamera then
        v30 = workspace_CurrentCamera.CameraSubject;
    else
        v30 = workspace_CurrentCamera;
    end;

    local v31;

    if v30 then
        v31 = v30:IsA("VehicleSeat");
    else
        v31 = v30;
    end;

    local v32;

    if v30 then
        v32 = v30:IsA("SkateboardPlatform");
    else
        v32 = v30;
    end;

    if p25.lastUpdate == nil or v28 > 1 then
        p25.lastCameraTransform = nil;
    end;

    if v29 then
        p25.lastUserPanCamera = tick();
    end;

    local SubjectPosition = p25:GetSubjectPosition();

    if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
        if p25.gamepadDollySpeedMultiplier ~= 1 then
            p25:SetCameraToSubjectDistance(p25.currentSubjectDistance * p25.gamepadDollySpeedMultiplier);
        end;

        Focus = CFrame.new(SubjectPosition);
        local Rotation = CameraInput.getRotation(p26);
        p25.curAzimuthRad = p25.curAzimuthRad - Rotation.X;

        if p25.useAzimuthLimits then
            p25.curAzimuthRad = math.clamp(p25.curAzimuthRad, p25.minAzimuthAbsoluteRad, p25.maxAzimuthAbsoluteRad);
        else
            p25.curAzimuthRad = p25.curAzimuthRad == 0 and 0 or (math.sign(p25.curAzimuthRad) * (math.abs(p25.curAzimuthRad) % 6.283185307179586) or 0);
        end;

        p25.curElevationRad = math.clamp(p25.curElevationRad + Rotation.Y, p25.minElevationRad, p25.maxElevationRad);
        local v33 = SubjectPosition + p25.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-p25.curElevationRad, p25.curAzimuthRad, 0) * Vector3.new(0, 0, 1));
        CFrame2 = CFrame.new(v33, SubjectPosition);
        p25.lastCameraTransform = CFrame2;
        p25.lastCameraFocus = Focus;

        if (v31 or v32) and v30:IsA("BasePart") then
            p25.lastSubjectCFrame = v30.CFrame;
        else
            p25.lastSubjectCFrame = nil;
        end;
    end;

    p25.lastUpdate = v27;

    return CFrame2, Focus;
end;

return u1;