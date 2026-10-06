-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Spring = require(ReplicatedStorage.Shared.Spring);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = true;
local u3 = 1;
local u4 = 0;
local u5 = {};
local u6 = {};
local u7 = false;
local u8 = 1;
local u9 = 0.5;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = 0;
local u16 = nil;
local u17 = nil;
local u18 = 0;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = {};
local u23 = Spring.new(1, 100, Constants.DEFAULT_CAMERA_FOV);
local u24 = Spring.new(1, 10, Vector3.new(0, 0, 0));
local u25 = Spring.new(0.4, 25, Vector3.new(0, 0, 0));
local u26 = Spring.new(0.3, 35, Vector3.new(0, 0, 0));
local u27 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u28 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u29 = Spring.new(1, 1, Vector3.new(0, 0, 0));

local function setPerspectiveIndicator(p30: boolean) -- Line: 92
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= p30 then
        MainGui.Visible = p30;
    end;
end;

local function applyMouseEnabled(p31: boolean) -- Line: 100
    -- upvalues: UserInputService (copy), PlayerGui (copy)
    UserInputService.MouseBehavior = p31 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = p31;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= p31 then
        MainGui.Visible = p31;
    end;
end;

local function getAimAssistController() -- Line: 106
    -- upvalues: u11 (ref), ReplicatedStorage (copy)
    if not u11 then
        local success, result = pcall(function() -- Line: 108
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    return u11;
end;

local function getCameraInput() -- Line: 120
    -- upvalues: u10 (ref), LocalPlayer (copy)
    if u10 then
        return u10;
    end;

    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts");

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("PlayerModule");
    end;

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("CameraModule");
    end;

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("CameraInput");
    end;

    if not (PlayerScripts and PlayerScripts:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, PlayerScripts);

    if not (success and (result and result.setTouchSensitivity)) then
        return nil;
    end;

    u10 = result;

    return result;
end;

local function setTouchSensitivity(p32: number) -- Line: 142
    -- upvalues: u13 (ref), getCameraInput (copy)
    if u13 and math.abs(u13 - p32) <= 0.0001 then
        return;
    end;

    local v33 = getCameraInput();

    if v33 then
        u13 = p32;
        v33.setTouchSensitivity(p32);
    end;
end;

local function setGamepadAssistMultiplier(p34: number) -- Line: 156
    -- upvalues: u14 (ref), getCameraInput (copy)
    if u14 and math.abs(u14 - p34) <= 0.0001 then
        return;
    end;

    local v35 = getCameraInput();

    if v35 and v35.setGamepadAssistMultiplier then
        u14 = p34;
        v35.setGamepadAssistMultiplier(p34);
    end;
end;

local function getLockedFOV() -- Line: 174
    -- upvalues: u6 (copy)
    local v36, v37, v38;
    v36, v37, v38 = pairs(u6);
    local v39, v40, v41;

    if type(v36) == "function" then
        v39, v40 = v36(v37, v41);
    else
        v39, v40 = next(v36, v41);
    end;

    v41 = v39;

    return v40;
end;

local function getCameraCFrame(p42: number?) -- Line: 183
    -- upvalues: u11 (ref), ReplicatedStorage (copy), u28 (copy), u25 (copy), u24 (copy), u27 (copy), u29 (copy), u3 (ref), u26 (copy), u16 (ref)
    if not u11 then
        local success, result = pcall(function() -- Line: 108
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v43 = u11;
    local v44 = not v43 and Vector3.new(1, 1, 1) or v43.GetRecoilAssistScale();
    local v45 = u28:getPosition() + u25:getPosition();
    local v46 = u24:getPosition() + u27:getPosition() + u29:getPosition() * (p42 or u3) * v44 + u26:getPosition();

    return u16 * CFrame.new(v45) * CFrame.Angles(v46.X, v46.Y, v46.Z);
end;

local function isSceneCameraActive() -- Line: 197
    -- upvalues: u22 (ref)
    for _, v in u22 do
        if v.IsActive() then
            return true;
        end;
    end;

    return false;
end;

local function getAspectRatioStretch() -- Line: 219
    -- upvalues: u18 (ref), u2 (ref), u22 (ref), workspace_CurrentCamera (copy)
    if u18 > 0 and u2 then
        local v47 = false;

        for _, v in u22 do
            if v.IsActive() then
                v47 = true;
                break;
            end;
        end;

        if not v47 then
            local ViewportSize = workspace_CurrentCamera.ViewportSize;

            return (ViewportSize.X <= 0 or ViewportSize.Y <= 0) and 1 or (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u18 + 1;
        end;
    end;

    return 1;
end;

local function applyAspectRatioStretch() -- Line: 235
    -- upvalues: u18 (ref), u2 (ref), u22 (ref), workspace_CurrentCamera (copy), u20 (ref), u21 (ref)
    local v48;

    if u18 <= 0 or not u2 then
        v48 = 1;
    else
        local v49 = false;

        for _, v in u22 do
            if v.IsActive() then
                v49 = true;
                break;
            end;
        end;

        if v49 then
            v48 = 1;
        else
            local ViewportSize = workspace_CurrentCamera.ViewportSize;
            v48 = (ViewportSize.X <= 0 or ViewportSize.Y <= 0) and 1 or (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u18 + 1;
        end;
    end;

    if v48 <= 1 then
        return;
    end;

    local v50 = 1 / v48;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local FieldOfView = workspace_CurrentCamera.FieldOfView;
    local v51 = CFrame2 * CFrame.new(0, 0, 0, 1, 0, 0, 0, v50, 0, 0, 0, 1);
    local v52 = math.rad(FieldOfView) / 2;
    local v53 = v50 * math.tan(v52);
    local v54 = math.atan(v53) * 2;
    local math_deg_ret = math.deg(v54);
    u20 = CFrame2;
    u21 = FieldOfView;
    workspace_CurrentCamera.CFrame = v51;
    workspace_CurrentCamera.FieldOfView = math_deg_ret;
end;

local function restoreAspectRatioStretch() -- Line: 261
    -- upvalues: u20 (ref), u21 (ref), workspace_CurrentCamera (copy)
    local v55 = u20;
    local v56 = u21;

    if not (v55 and v56) then
        return;
    end;

    u20 = nil;
    u21 = nil;
    workspace_CurrentCamera.CFrame = v55;
    workspace_CurrentCamera.FieldOfView = v56;
end;

local function setTextBoxFocusOverrideActive(p57: boolean) -- Line: 275
    -- upvalues: u1 (copy)
    u1.setForceLockOverride("TextBox", p57);
end;

function u1.getWeaponKickRotation() -- Line: 282
    -- upvalues: u27 (copy)
    return u27:getPosition();
end;

function u1.updateCameraFOV(p58: number) -- Line: 288
    -- upvalues: u6 (copy), u23 (copy)
    local v59;

    for _, v in pairs(u6) do
        v59 = v;
        break;
    end;

    v59 = nil;

    if v59 ~= nil then
        return;
    end;

    u23:setGoal((math.clamp(p58, 1, 80)));
end;

function u1.getTargetFOV() -- Line: 297
    -- upvalues: u23 (copy)
    local Goal = u23:getGoal();

    return math.clamp(Goal, 1, 80);
end;

function u1.setFOVLock(p60: string, p61: boolean, p62: number?) -- Line: 303
    -- upvalues: u6 (copy), u23 (copy)
    local v63;

    if p61 then
        local v64 = p62 or u23:getGoal();
        v63 = math.clamp(v64, 1, 80);
    else
        v63 = nil;
    end;

    u6[p60] = v63;
    local v65;

    for _, v in pairs(u6) do
        v65 = v;
        break;
    end;

    v65 = nil;

    if v65 ~= nil then
        u23:reset(v65);
    end;
end;

function u1.setMouseEnabled(p66: boolean) -- Line: 314
    -- upvalues: u7 (ref), u5 (copy), UserInputService (copy), PlayerGui (copy)
    u7 = p66;

    if next(u5) == nil then
        UserInputService.MouseBehavior = p66 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = p66;
        local MainGui = PlayerGui:FindFirstChild("MainGui");

        if MainGui then
            MainGui = MainGui:FindFirstChild("CameraPerspective");
        end;

        if MainGui and MainGui.Visible ~= p66 then
            MainGui.Visible = p66;
        end;
    end;
end;

function u1.setForceLockOverride(p67: string, p68: boolean) -- Line: 326
    -- upvalues: u5 (copy), u7 (ref), UserInputService (copy), PlayerGui (copy)
    u5[p67] = p68 and true or nil;
    local v69 = next(u5) ~= nil and true or u7;
    UserInputService.MouseBehavior = v69 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = v69;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= v69 then
        MainGui.Visible = v69;
    end;
end;

function u1.resetForceLockOverride() -- Line: 334
    -- upvalues: u5 (copy), u7 (ref), UserInputService (copy), PlayerGui (copy)
    table.clear(u5);
    u7 = false;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= false then
        MainGui.Visible = false;
    end;
end;

function u1.isForceLockOverrideActive() -- Line: 342
    -- upvalues: u5 (copy)
    return next(u5) ~= nil;
end;

function u1.SetEnabled(p70: boolean) -- Line: 348
    -- upvalues: u2 (ref), u16 (ref), u17 (ref), u14 (ref), getCameraInput (copy)
    u2 = p70;

    if not p70 then
        u16 = nil;
        u17 = nil;

        if u14 and math.abs(u14 - 1) <= 0.0001 then
            return;
        end;

        local v71 = getCameraInput();

        if v71 and v71.setGamepadAssistMultiplier then
            u14 = 1;
            v71.setGamepadAssistMultiplier(1);
        end;
    end;
end;

function u1.setPerspective(p72: boolean, p73: boolean, p74: number?) -- Line: 361
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local math_max_ret = math.max(p72 and 0 or (p74 or 5), 0.5);
    u1.setMouseEnabled(p73);

    if LocalPlayer.CameraMaxZoomDistance ~= math_max_ret or LocalPlayer.CameraMinZoomDistance ~= math_max_ret then
        LocalPlayer.CameraMaxZoomDistance = math_max_ret;
        LocalPlayer.CameraMinZoomDistance = math_max_ret;
    end;

    local v75 = p72 and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic;

    if LocalPlayer.CameraMode ~= v75 then
        LocalPlayer.CameraMode = v75;
    end;
end;

function u1.toWeaponFirePosition() -- Line: 382
    -- upvalues: u16 (ref), u27 (copy), u28 (copy), workspace_CurrentCamera (copy), u1 (copy), getCameraCFrame (copy)
    if u16 then
        u27:reset(Vector3.new(0, 0, 0));
        u28:reset(Vector3.new(0, 0, 0));
        workspace_CurrentCamera.CFrame = u16;
        u1.updateCamera((getCameraCFrame(1)));
    end;
end;

function u1.weaponKick(p76: table, p77: table) -- Line: 395
    -- upvalues: u27 (copy), u28 (copy), u1 (copy)
    u27:setDampingRatio(p76.Damper);
    u27:setFrequency(p76.Speed);
    u27:setPosition(p76.Value * 0.017453292519943295);
    u28:setDampingRatio(p77.Damper);
    u28:setFrequency(p77.Speed);
    u28:setPosition(p77.Value);
    u1.updateCamera();
end;

function u1.setWeaponRecoil(p78: table, p79: number) -- Line: 409
    -- upvalues: u29 (copy), u3 (ref)
    u29:setDampingRatio(p78.Damper);
    u29:setFrequency(p78.Speed);
    u29:setGoal(p78.Value);
    u3 = p79;
end;

function u1.resetWeaponRecoil() -- Line: 418
    -- upvalues: u29 (copy), u3 (ref)
    u29:reset(Vector3.new(0, 0, 0));
    u3 = 1;
end;

function u1.BombExploded(p80: number) -- Line: 425
    -- upvalues: u6 (copy), u25 (copy), u26 (copy), u23 (copy)
    local v81;

    for _, v in pairs(u6) do
        v81 = v;
        break;
    end;

    v81 = nil;

    if v81 ~= nil then
        return;
    end;

    local v82 = 1 - math.min(p80 / 75, 1);
    local math_max_ret = math.max(0.35, v82);
    u25:impulse(Vector3.new(1.2, 0.5, 0.7) * math_max_ret);
    u26:impulse(Vector3.new(0.17453292, 0.06981317, 0.05235988) * math_max_ret);
    local Goal = u23:getGoal();
    u23:setGoal(Goal - math_max_ret * 1.5);
    task.delay(0.15, function() -- Line: 439
        -- upvalues: u23 (ref), Goal (copy)
        u23:setGoal(Goal);
    end);
end;

function u1.updateCamera(p83) -- Line: 446
    -- upvalues: u6 (copy), u23 (copy), workspace_CurrentCamera (copy), Constants (copy), u8 (ref), u9 (ref), u11 (ref), ReplicatedStorage (copy), u12 (ref), UserInputService (copy), u13 (ref), getCameraInput (copy), u14 (ref), getCameraCFrame (copy), u17 (ref)
    local v84;

    for _, v in pairs(u6) do
        v84 = v;
        break;
    end;

    v84 = nil;

    if v84 ~= nil and u23:getGoal() ~= v84 then
        u23:reset(v84);
    end;

    local v85 = v84 or u23:getPosition();
    local math_clamp_ret = math.clamp(v85, 1, 80);

    if workspace_CurrentCamera.FieldOfViewMode ~= Enum.FieldOfViewMode.Diagonal then
        workspace_CurrentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal;
    end;

    if math.abs(workspace_CurrentCamera.FieldOfView - math_clamp_ret) > 0.001 then
        workspace_CurrentCamera.FieldOfView = math_clamp_ret;
    end;

    local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV;
    local v86 = u8;

    if math.abs(math_clamp_ret - (DEFAULT_CAMERA_FOV - 37)) < 0.1 or math.abs(math_clamp_ret - (DEFAULT_CAMERA_FOV - 60)) < 0.1 then
        v86 = u8 * u9;
    end;

    if not u11 then
        local success, result = pcall(function() -- Line: 108
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v87 = u11;
    local v88 = not v87 and 1 or v87.GetFrictionMultiplier();
    local v89 = math_clamp_ret / DEFAULT_CAMERA_FOV * v86 * v88;

    if not u12 or math.abs(u12 - v89) > 0.0001 then
        u12 = v89;
        UserInputService.MouseDeltaSensitivity = v89;
    end;

    local v90 = ((not u13 or math.abs(u13 - v89) > 0.0001) and true or false) and getCameraInput();

    if v90 then
        u13 = v89;
        v90.setTouchSensitivity(v89);
    end;

    if not u14 or math.abs(u14 - v88) > 0.0001 then
        local v91 = getCameraInput();

        if v91 and v91.setGamepadAssistMultiplier then
            u14 = v88;
            v91.setGamepadAssistMultiplier(v88);
        end;
    end;

    workspace_CurrentCamera.CFrame = p83 or getCameraCFrame();
    u17 = workspace_CurrentCamera.CFrame;
end;

local function applyAspectRatio(p92) -- Line: 493
    -- upvalues: u18 (ref)
    local v93 = tonumber(p92) or 1;
    u18 = (1 - math.clamp(v93, 0.5, 1)) / 0.5;
end;

function u1.SetAspectRatio(p94) -- Line: 500
    -- upvalues: u19 (ref), u18 (ref)
    u19 = tonumber(p94);
    local v95 = tonumber(p94) or 1;
    u18 = (1 - math.clamp(v95, 0.5, 1)) / 0.5;
end;

function u1.StateChanged(p96, p97) -- Line: 505
    -- upvalues: u1 (copy)
    if p96 == Enum.HumanoidStateType.Freefall and p97 == Enum.HumanoidStateType.Landed then
        u1.OnLanded();
    end;
end;

function u1.OnLanded(p98: number?, p99: number?) -- Line: 511
    -- upvalues: u4 (ref), u15 (ref), u24 (copy)
    if tick() - u4 < 0.3 then
        return;
    end;

    local v100 = typeof(p98) ~= "number" and 12 or math.max(p98, 0);
    local math_clamp_ret = math.clamp((v100 - 2) / 10, 0, 1);

    if math_clamp_ret <= 0 then
        return;
    end;

    if typeof(p99) == "number" then
        math_clamp_ret = math_clamp_ret * (math.clamp(p99, 0, 1) * -0.85 + 1);
    end;

    u4 = tick();
    u15 = u15 + 1;
    local u101 = u15;
    u24:setDampingRatio(1);
    u24:setFrequency(10);
    u24:setGoal((Vector3.new(math_clamp_ret * -0.02181661564992912, 0, 0)));
    task.delay(0.08, function() -- Line: 539
        -- upvalues: u101 (copy), u15 (ref), u24 (ref)
        if u101 == u15 then
            u24:setGoal(Vector3.new(0, 0, 0));
        end;
    end);
end;

function u1.clampFOV(p102: number) -- Line: 170
    return math.clamp(p102, 1, 80);
end;

u1.getAspectRatioStretch = getAspectRatioStretch;

function u1.Initialize() -- Line: 553
    -- upvalues: u11 (ref), ReplicatedStorage (copy), RunServiceController (copy), u25 (copy), u26 (copy), u27 (copy), u28 (copy), u29 (copy), u23 (copy), u24 (copy), u2 (ref), workspace_CurrentCamera (copy), CharacterResolver (copy), LocalPlayer (copy), u16 (ref), u1 (copy), getCameraCFrame (copy), u5 (copy), u7 (ref), UserInputService (copy), PlayerGui (copy), u17 (ref), applyAspectRatioStretch (copy), RunService (copy), restoreAspectRatioStretch (copy)
    if not u11 then
        local success, result = pcall(function() -- Line: 108
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v103 = u11;

    if v103 then
        v103.Initialize();
    end;

    RunServiceController.BindToStepped("CameraController.UpdateSprings", function(p104: any, p105: number) -- Line: 559
        -- upvalues: u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u23 (ref), u24 (ref)
        u25:update(p105);
        u26:update(p105);
        u27:update(p105);
        u28:update(p105);
        u29:update(p105);
        u23:update(p105);
        u24:update(p105);
    end);
    RunServiceController.BindToRenderStep("CameraController.UpdateCamera", Enum.RenderPriority.Camera.Value + 1, function(p106: number) -- Line: 569
        -- upvalues: u2 (ref), workspace_CurrentCamera (ref), u11 (ref), CharacterResolver (ref), LocalPlayer (ref), u16 (ref), u1 (ref), getCameraCFrame (ref), u5 (ref), u7 (ref), UserInputService (ref), PlayerGui (ref)
        if not u2 then
            return;
        end;

        local CFrame2 = workspace_CurrentCamera.CFrame;

        if u11 then
            local MagnetismRotation = u11.GetMagnetismRotation(p106);

            if MagnetismRotation.Magnitude > 1e-6 and (MagnetismRotation.X == MagnetismRotation.X and (MagnetismRotation.Y == MagnetismRotation.Y and (math.abs(MagnetismRotation.X) < 3.141592653589793 and math.abs(MagnetismRotation.Y) < 3.141592653589793))) then
                local PlayerCharacter = CharacterResolver.getPlayerCharacter(LocalPlayer);
                local v107;

                if PlayerCharacter and PlayerCharacter:FindFirstChild("HumanoidRootPart") then
                    v107 = PlayerCharacter.HumanoidRootPart.Position;
                else
                    v107 = CFrame2.Position;
                end;

                local math_clamp_ret = math.clamp(MagnetismRotation.Y, -0.08726646259971647, 0.08726646259971647);
                local math_clamp_ret2 = math.clamp(MagnetismRotation.X, -0.08726646259971647, 0.08726646259971647);
                local v108 = CFrame.fromAxisAngle(CFrame2.RightVector, math_clamp_ret) * CFrame.Angles(0, math_clamp_ret2, 0);
                local v109 = v108:VectorToWorldSpace(CFrame2.Position - v107);
                CFrame2 = CFrame.new(v107 + v109) * (v108 * CFrame2.Rotation);
            end;
        end;

        u16 = CFrame2;
        u1.updateCamera((getCameraCFrame()));
        local v110 = next(u5) ~= nil and true or u7;
        local v111;

        if v110 then
            v111 = Enum.MouseBehavior.Default;
        else
            v111 = Enum.MouseBehavior.LockCenter;
        end;

        if UserInputService.MouseBehavior ~= v111 then
            UserInputService.MouseBehavior = v111;
        end;

        if UserInputService.MouseIconEnabled ~= v110 then
            UserInputService.MouseIconEnabled = v110;
        end;

        local MainGui = PlayerGui:FindFirstChild("MainGui");

        if MainGui then
            MainGui = MainGui:FindFirstChild("CameraPerspective");
        end;

        if MainGui and MainGui.Visible ~= v110 then
            MainGui.Visible = v110;
        end;
    end);
    RunServiceController.BindToRenderStep("CameraController.ResetCameraShake", Enum.RenderPriority.Camera.Value - 1, function() -- Line: 621
        -- upvalues: u2 (ref), u16 (ref), workspace_CurrentCamera (ref), u17 (ref)
        if u2 and (u16 and workspace_CurrentCamera.CFrame == u17) then
            workspace_CurrentCamera.CFrame = u16;
        end;
    end);
    RunServiceController.BindToRenderSteppedEvent("CameraController.AspectRatioStretch", applyAspectRatioStretch, (1 / 0));
    RunService.PreAnimation:Connect(restoreAspectRatioStretch);
    RunServiceController.BindToRenderStep("CameraController.UndoAspectRatioStretch", Enum.RenderPriority.First.Value, restoreAspectRatioStretch);
    UserInputService.TextBoxFocused:Connect(function() -- Line: 637
        -- upvalues: u1 (ref)
        u1.setForceLockOverride("TextBox", true);
    end);
    UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 640
        -- upvalues: UserInputService (ref), u1 (ref)
        task.defer(function() -- Line: 642
            -- upvalues: UserInputService (ref), u1 (ref)
            local v112 = UserInputService:GetFocusedTextBox() ~= nil;
            u1.setForceLockOverride("TextBox", v112);
        end);
    end);
    local v113 = UserInputService:GetFocusedTextBox() ~= nil;
    u1.setForceLockOverride("TextBox", v113);
    local Attribute = LocalPlayer:GetAttribute("Team");

    if not (CharacterResolver.getPlayerCharacter(LocalPlayer) or (Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists")) then
        u1.setForceLockOverride("InitialMenu", true);
    end;
end;

function u1.Start() -- Line: 659
    -- upvalues: ReplicatedStorage (copy), u22 (ref), u1 (copy), Constants (copy), CharacterResolver (copy), LocalPlayer (copy), DataController (copy), u8 (ref), u13 (ref), getCameraInput (copy), u19 (ref), u18 (ref), u9 (ref)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    u22 = {
        MenuSceneController,
        {
            IsActive = MenuSceneController.IsTeamSelectSceneActive
        },
        CaseSceneController,
        require(ReplicatedStorage.Controllers.InspectController),
        require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    };
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);

    local function resetFOV() -- Line: 675
        -- upvalues: CaseSceneController (copy), BlackMarketSceneController (copy), u1 (ref), Constants (ref)
        if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
            u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
        end;
    end;

    CharacterResolver.observeCharacter(LocalPlayer, function(p114: userdata?) -- Line: 680
        -- upvalues: CaseSceneController (copy), BlackMarketSceneController (copy), u1 (ref), Constants (ref), resetFOV (copy)
        if p114 then
            if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
                u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            end;

            p114:GetAttributeChangedSignal("Dead"):Once(resetFOV);
        end;

        return function() -- Line: 685
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Mouse Sensitivity", function(p115: number?) -- Line: 689
        -- upvalues: u8 (ref), u13 (ref), getCameraInput (ref)
        u8 = math.clamp(p115 or 1, 0.1, 10);
        local v116 = u8;

        if u13 and math.abs(u13 - v116) <= 0.0001 then
            return;
        end;

        local v117 = getCameraInput();

        if v117 then
            u13 = v116;
            v117.setTouchSensitivity(v116);
        end;
    end);
    local v118 = u8;
    local v119 = ((not u13 or math.abs(u13 - v118) > 0.0001) and true or false) and getCameraInput();

    if v119 then
        u13 = v118;
        v119.setTouchSensitivity(v118);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Video.Advanced.Aspect Ratio", function(p120) -- Line: 697
        -- upvalues: u19 (ref), u18 (ref)
        if u19 ~= nil then
            local v121 = (tonumber(p120) or 1) - u19;

            if math.abs(v121) > 0.0001 then
                return;
            end;

            u19 = nil;
        end;

        local v122 = tonumber(p120) or 1;
        u18 = (1 - math.clamp(v122, 0.5, 1)) / 0.5;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Zoom Sensitivity Multiplier", function(p123: number?) -- Line: 709
        -- upvalues: u9 (ref)
        u9 = math.clamp(p123 or 0.5, 0.1, 5);
    end);
end;

return u1;