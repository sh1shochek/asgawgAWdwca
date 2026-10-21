-- ReplicatedStorage.Controllers.CameraController
-- Script path: ReplicatedStorage.Controllers.CameraController
-- Decompile time: 14.89 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local LocalFootsteps = require(ReplicatedStorage.Components.Common.LocalFootsteps);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local SpeedProfile = require(ReplicatedStorage.MovementV2.SpeedProfile);
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
local u16 = false;
local u17 = false;
local u18 = 0;
local u19 = nil;
local u20 = nil;
local u21 = 0;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = {};
local u27 = nil;
local u28 = Spring.new(1, 100, Constants.DEFAULT_CAMERA_FOV);
local u29 = Spring.new(1, 10, Vector3.new(0, 0, 0));
local u30 = Spring.new(0.4, 25, Vector3.new(0, 0, 0));
local u31 = Spring.new(0.3, 35, Vector3.new(0, 0, 0));
local u32 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u33 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u34 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u35 = Spring.new(1, 6, 0);

local function setPerspectiveIndicator(p36: boolean) -- Line: 116
    -- upvalues: PlayerGui (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= p36 then
        MainGui.Visible = p36;
    end;
end;

local function applyMouseEnabled(p37: boolean) -- Line: 124
    -- upvalues: UserInputService (copy), PlayerGui (copy)
    UserInputService.MouseBehavior = p37 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = p37;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= p37 then
        MainGui.Visible = p37;
    end;
end;

local function getAimAssistController() -- Line: 130
    -- upvalues: u11 (ref), ReplicatedStorage (copy)
    if not u11 then
        local success, result = pcall(function() -- Line: 132
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    return u11;
end;

local function getCameraInput() -- Line: 144
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

local function setTouchSensitivity(p38: number) -- Line: 166
    -- upvalues: u13 (ref), getCameraInput (copy)
    if u13 and math.abs(u13 - p38) <= 0.0001 then
        return;
    end;

    local v39 = getCameraInput();

    if v39 then
        u13 = p38;
        v39.setTouchSensitivity(p38);
    end;
end;

local function setGamepadAssistMultiplier(p40: number) -- Line: 180
    -- upvalues: u14 (ref), getCameraInput (copy)
    if u14 and math.abs(u14 - p40) <= 0.0001 then
        return;
    end;

    local v41 = getCameraInput();

    if v41 and v41.setGamepadAssistMultiplier then
        u14 = p40;
        v41.setGamepadAssistMultiplier(p40);
    end;
end;

local function getLockedFOV() -- Line: 198
    -- upvalues: u6 (copy)
    local v42, v43, v44;
    v42, v43, v44 = pairs(u6);
    local v45, v46, v47;

    if type(v42) == "function" then
        v45, v46 = v42(v43, v47);
    else
        v45, v46 = next(v42, v47);
    end;

    v47 = v45;

    return v46;
end;

local function getCameraCFrame(p48: number?) -- Line: 207
    -- upvalues: u11 (ref), ReplicatedStorage (copy), u33 (copy), u30 (copy), u29 (copy), u32 (copy), u34 (copy), u3 (ref), u31 (copy), u19 (ref), u18 (ref)
    if not u11 then
        local success, result = pcall(function() -- Line: 132
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v49 = u11;
    local v50 = not v49 and Vector3.new(1, 1, 1) or v49.GetRecoilAssistScale();
    local v51 = u33:getPosition() + u30:getPosition();
    local v52 = u29:getPosition() + u32:getPosition() + u34:getPosition() * (p48 or u3) * v50 + u31:getPosition();

    return u19 * CFrame.new(v51) * CFrame.Angles(v52.X - u18, v52.Y, v52.Z);
end;

local function isSceneCameraActive() -- Line: 221
    -- upvalues: u26 (ref)
    for _, v in u26 do
        if v.IsActive() then
            return true;
        end;
    end;

    return false;
end;

local function getAspectRatioStretch() -- Line: 240
    -- upvalues: u21 (ref), u2 (ref), u26 (ref), workspace_CurrentCamera (copy)
    if u21 > 0 and u2 then
        local v53 = false;

        for _, v in u26 do
            if v.IsActive() then
                v53 = true;
                break;
            end;
        end;

        if not v53 then
            local ViewportSize = workspace_CurrentCamera.ViewportSize;

            return (ViewportSize.X <= 0 or ViewportSize.Y <= 0) and 1 or (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u21 + 1;
        end;
    end;

    return 1;
end;

local function applyAspectRatioStretch() -- Line: 256
    -- upvalues: u21 (ref), u2 (ref), u26 (ref), workspace_CurrentCamera (copy), u23 (ref), u24 (ref), u25 (ref)
    local v54;

    if u21 <= 0 or not u2 then
        v54 = 1;
    else
        local v55 = false;

        for _, v in u26 do
            if v.IsActive() then
                v55 = true;
                break;
            end;
        end;

        if v55 then
            v54 = 1;
        else
            local ViewportSize = workspace_CurrentCamera.ViewportSize;
            v54 = (ViewportSize.X <= 0 or ViewportSize.Y <= 0) and 1 or (math.max(ViewportSize.X / ViewportSize.Y / 1.3333333333333333, 1.3333333333333333) - 1) * u21 + 1;
        end;
    end;

    if v54 <= 1 then
        return;
    end;

    local v56 = 1 / v54;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local FieldOfView = workspace_CurrentCamera.FieldOfView;
    local v57 = CFrame2 * CFrame.new(0, 0, 0, 1, 0, 0, 0, v56, 0, 0, 0, 1);
    local v58 = math.rad(FieldOfView) / 2;
    local v59 = v56 * math.tan(v58);
    local v60 = math.atan(v59) * 2;
    local math_deg_ret = math.deg(v60);
    u23 = CFrame2;
    u24 = FieldOfView;
    workspace_CurrentCamera.CFrame = v57;
    workspace_CurrentCamera.FieldOfView = math_deg_ret;
    u25 = workspace_CurrentCamera.FieldOfView;
end;

local function restoreAspectRatioStretch() -- Line: 279
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), workspace_CurrentCamera (copy)
    local v61 = u23;
    local v62 = u24;
    local v63 = u25;

    if not (v61 and (v62 and v63)) then
        return;
    end;

    u23 = nil;
    u24 = nil;
    u25 = nil;
    local CFrame2 = workspace_CurrentCamera.CFrame;

    if CFrame2.Position:FuzzyEq(v61.Position, 0.001) and CFrame2.LookVector:FuzzyEq(v61.LookVector, 0.001) then
        workspace_CurrentCamera.CFrame = v61;
    end;

    if math.abs(workspace_CurrentCamera.FieldOfView - v63) <= 0.001 then
        workspace_CurrentCamera.FieldOfView = v62;
    end;
end;

local function isCameraAtAppliedFrame() -- Line: 313
    -- upvalues: u20 (ref), workspace_CurrentCamera (copy)
    local v64 = u20;

    if not v64 then
        return false;
    end;

    local CFrame2 = workspace_CurrentCamera.CFrame;
    local v65;

    if (CFrame2.Position - v64.Position).Magnitude <= 0.001 then
        v65 = (CFrame2.LookVector - v64.LookVector).Magnitude <= 0.0001;
    else
        v65 = false;
    end;

    return v65;
end;

local function isOwnGameplayView() -- Line: 329
    -- upvalues: workspace_CurrentCamera (copy), u26 (ref), u27 (ref), CharacterResolver (copy)
    if workspace_CurrentCamera.CameraType == Enum.CameraType.Custom then
        local v66 = false;

        for _, v in u26 do
            if v.IsActive() then
                v66 = true;
                break;
            end;
        end;

        if not v66 then
            if u27 and u27() then
                return false;
            end;

            local LocalCharacter = CharacterResolver.getLocalCharacter();
            local CameraSubject = workspace_CurrentCamera.CameraSubject;
            local v67;

            if LocalCharacter == nil or CameraSubject == nil then
                v67 = false;
            else
                v67 = CameraSubject:IsDescendantOf(LocalCharacter) and CharacterResolver.isAliveCharacter(LocalCharacter);
            end;

            return v67;
        end;
    end;

    return false;
end;

local function setTextBoxFocusOverrideActive(p68: boolean) -- Line: 346
    -- upvalues: u1 (copy)
    u1.setForceLockOverride("TextBox", p68);
end;

function u1.getWeaponKickRotation() -- Line: 353
    -- upvalues: u32 (copy)
    return u32:getPosition();
end;

function u1.updateCameraFOV(p69: number) -- Line: 359
    -- upvalues: u6 (copy), u28 (copy)
    local v70;

    for _, v in pairs(u6) do
        v70 = v;
        break;
    end;

    v70 = nil;

    if v70 ~= nil then
        return;
    end;

    u28:setGoal((math.clamp(p69, 1, 80)));
end;

function u1.getTargetFOV() -- Line: 368
    -- upvalues: u28 (copy)
    local Goal = u28:getGoal();

    return math.clamp(Goal, 1, 80);
end;

function u1.setFOVLock(p71: string, p72: boolean, p73: number?) -- Line: 374
    -- upvalues: u6 (copy), u28 (copy)
    local v74;

    if p72 then
        local v75 = p73 or u28:getGoal();
        v74 = math.clamp(v75, 1, 80);
    else
        v74 = nil;
    end;

    u6[p71] = v74;
    local v76;

    for _, v in pairs(u6) do
        v76 = v;
        break;
    end;

    v76 = nil;

    if v76 ~= nil then
        u28:reset(v76);
    end;
end;

function u1.setMouseEnabled(p77: boolean) -- Line: 385
    -- upvalues: u7 (ref), u5 (copy), UserInputService (copy), PlayerGui (copy)
    u7 = p77;

    if next(u5) == nil then
        UserInputService.MouseBehavior = p77 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = p77;
        local MainGui = PlayerGui:FindFirstChild("MainGui");

        if MainGui then
            MainGui = MainGui:FindFirstChild("CameraPerspective");
        end;

        if MainGui and MainGui.Visible ~= p77 then
            MainGui.Visible = p77;
        end;
    end;
end;

function u1.setForceLockOverride(p78: string, p79: boolean) -- Line: 397
    -- upvalues: u5 (copy), u7 (ref), UserInputService (copy), PlayerGui (copy)
    u5[p78] = p79 and true or nil;
    local v80 = next(u5) ~= nil and true or u7;
    UserInputService.MouseBehavior = v80 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = v80;
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        MainGui = MainGui:FindFirstChild("CameraPerspective");
    end;

    if MainGui and MainGui.Visible ~= v80 then
        MainGui.Visible = v80;
    end;
end;

function u1.resetForceLockOverride() -- Line: 405
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

function u1.isForceLockOverrideActive() -- Line: 413
    -- upvalues: u5 (copy)
    return next(u5) ~= nil;
end;

function u1.SetEnabled(p81: boolean) -- Line: 419
    -- upvalues: u2 (ref), u19 (ref), u20 (ref), u14 (ref), getCameraInput (copy)
    u2 = p81;

    if not p81 then
        u19 = nil;
        u20 = nil;

        if u14 and math.abs(u14 - 1) <= 0.0001 then
            return;
        end;

        local v82 = getCameraInput();

        if v82 and v82.setGamepadAssistMultiplier then
            u14 = 1;
            v82.setGamepadAssistMultiplier(1);
        end;
    end;
end;

function u1.setPerspective(p83: boolean, p84: boolean, p85: number?) -- Line: 432
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local math_max_ret = math.max(p83 and 0 or (p85 or 5), 0.5);
    u1.setMouseEnabled(p84);

    if LocalPlayer.CameraMaxZoomDistance ~= math_max_ret or LocalPlayer.CameraMinZoomDistance ~= math_max_ret then
        LocalPlayer.CameraMaxZoomDistance = math_max_ret;
        LocalPlayer.CameraMinZoomDistance = math_max_ret;
    end;

    local v86 = p83 and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic;

    if LocalPlayer.CameraMode ~= v86 then
        LocalPlayer.CameraMode = v86;
    end;
end;

function u1.toWeaponFirePosition() -- Line: 453
    -- upvalues: u19 (ref), u32 (copy), u33 (copy), workspace_CurrentCamera (copy), u1 (copy), getCameraCFrame (copy)
    if u19 then
        u32:reset(Vector3.new(0, 0, 0));
        u33:reset(Vector3.new(0, 0, 0));
        workspace_CurrentCamera.CFrame = u19;
        u1.updateCamera((getCameraCFrame(1)));
    end;
end;

function u1.weaponKick(p87: table, p88: table) -- Line: 466
    -- upvalues: u32 (copy), u33 (copy), u1 (copy)
    u32:setDampingRatio(p87.Damper);
    u32:setFrequency(p87.Speed);
    u32:setPosition(p87.Value * 0.017453292519943295);
    u33:setDampingRatio(p88.Damper);
    u33:setFrequency(p88.Speed);
    u33:setPosition(p88.Value);
    u1.updateCamera();
end;

function u1.setWeaponRecoil(p89: table, p90: number) -- Line: 480
    -- upvalues: u34 (copy), u3 (ref)
    u34:setDampingRatio(p89.Damper);
    u34:setFrequency(p89.Speed);
    u34:setGoal(p89.Value);
    u3 = p90;
end;

function u1.setBaseCameraCFrame(p91) -- Line: 495
    -- upvalues: u19 (ref), u20 (ref)
    u19 = p91;
    u20 = p91;
end;

function u1.resetWeaponRecoil() -- Line: 502
    -- upvalues: u34 (copy), u3 (ref)
    u34:reset(Vector3.new(0, 0, 0));
    u3 = 1;
end;

function u1.BombExploded(p92: number) -- Line: 509
    -- upvalues: u6 (copy), u30 (copy), u31 (copy), u28 (copy)
    local v93;

    for _, v in pairs(u6) do
        v93 = v;
        break;
    end;

    v93 = nil;

    if v93 ~= nil then
        return;
    end;

    local v94 = 1 - math.min(p92 / 75, 1);
    local math_max_ret = math.max(0.35, v94);
    u30:impulse(Vector3.new(1.2, 0.5, 0.7) * math_max_ret);
    u31:impulse(Vector3.new(0.17453292, 0.06981317, 0.05235988) * math_max_ret);
    local Goal = u28:getGoal();
    u28:setGoal(Goal - math_max_ret * 1.5);
    task.delay(0.15, function() -- Line: 523
        -- upvalues: u28 (ref), Goal (copy)
        u28:setGoal(Goal);
    end);
end;

function u1.updateCamera(p95) -- Line: 530
    -- upvalues: restoreAspectRatioStretch (copy), u6 (copy), u28 (copy), workspace_CurrentCamera (copy), Constants (copy), u8 (ref), u9 (ref), u11 (ref), ReplicatedStorage (copy), u12 (ref), UserInputService (copy), u13 (ref), getCameraInput (copy), u14 (ref), getCameraCFrame (copy), u20 (ref)
    restoreAspectRatioStretch();
    local v96;

    for _, v in pairs(u6) do
        v96 = v;
        break;
    end;

    v96 = nil;

    if v96 ~= nil and u28:getGoal() ~= v96 then
        u28:reset(v96);
    end;

    local v97 = v96 or u28:getPosition();
    local math_clamp_ret = math.clamp(v97, 1, 80);

    if workspace_CurrentCamera.FieldOfViewMode ~= Enum.FieldOfViewMode.Diagonal then
        workspace_CurrentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal;
    end;

    if math.abs(workspace_CurrentCamera.FieldOfView - math_clamp_ret) > 0.001 then
        workspace_CurrentCamera.FieldOfView = math_clamp_ret;
    end;

    local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV;
    local v98 = u8;

    if math.abs(math_clamp_ret - (DEFAULT_CAMERA_FOV - 37)) < 0.1 or math.abs(math_clamp_ret - (DEFAULT_CAMERA_FOV - 60)) < 0.1 then
        v98 = u8 * u9;
    end;

    if not u11 then
        local success, result = pcall(function() -- Line: 132
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v99 = u11;
    local v100 = not v99 and 1 or v99.GetFrictionMultiplier();
    local v101 = math_clamp_ret / DEFAULT_CAMERA_FOV * v98 * v100;

    if not u12 or math.abs(u12 - v101) > 0.0001 then
        u12 = v101;
        UserInputService.MouseDeltaSensitivity = v101;
    end;

    local v102 = ((not u13 or math.abs(u13 - v101) > 0.0001) and true or false) and getCameraInput();

    if v102 then
        u13 = v101;
        v102.setTouchSensitivity(v101);
    end;

    if not u14 or math.abs(u14 - v100) > 0.0001 then
        local v103 = getCameraInput();

        if v103 and v103.setGamepadAssistMultiplier then
            u14 = v100;
            v103.setGamepadAssistMultiplier(v100);
        end;
    end;

    workspace_CurrentCamera.CFrame = p95 or getCameraCFrame();
    u20 = workspace_CurrentCamera.CFrame;
end;

local function applyAspectRatio(p104) -- Line: 580
    -- upvalues: u21 (ref)
    local v105 = tonumber(p104) or 1;
    u21 = (1 - math.clamp(v105, 0.5, 1)) / 0.5;
end;

function u1.SetAspectRatio(p106) -- Line: 587
    -- upvalues: u22 (ref), u21 (ref)
    u22 = tonumber(p106);
    local v107 = tonumber(p106) or 1;
    u21 = (1 - math.clamp(v107, 0.5, 1)) / 0.5;
end;

function u1.StateChanged(p108, p109) -- Line: 592
    -- upvalues: u1 (copy)
    if p108 == Enum.HumanoidStateType.Freefall and p109 == Enum.HumanoidStateType.Landed then
        u1.OnLanded();
    end;
end;

function u1.OnLanded(p110: number?, p111: number?) -- Line: 598
    -- upvalues: u4 (ref), u15 (ref), u29 (copy)
    if tick() - u4 < 0.3 then
        return;
    end;

    local v112 = typeof(p110) ~= "number" and 12 or math.max(p110, 0);
    local math_clamp_ret = math.clamp((v112 - 2) / 10, 0, 1);

    if math_clamp_ret <= 0 then
        return;
    end;

    if typeof(p111) == "number" then
        math_clamp_ret = math_clamp_ret * (math.clamp(p111, 0, 1) * -0.85 + 1);
    end;

    u4 = tick();
    u15 = u15 + 1;
    local u113 = u15;
    u29:setDampingRatio(1);
    u29:setFrequency(10);
    u29:setGoal((Vector3.new(math_clamp_ret * -0.02181661564992912, 0, 0)));
    task.delay(0.08, function() -- Line: 626
        -- upvalues: u113 (copy), u15 (ref), u29 (ref)
        if u113 == u15 then
            u29:setGoal(Vector3.new(0, 0, 0));
        end;
    end);
end;

function u1.SetSprintHeld(p114: boolean) -- Line: 635
    -- upvalues: u16 (ref), u17 (ref)
    u16 = p114;

    if p114 then
        u17 = true;
    end;
end;

local function getSprintStrength() -- Line: 644
    -- upvalues: u16 (ref), CharacterResolver (copy), LocalPlayer (copy), RuntimeKinematics (copy), SpeedProfile (copy)
    if not u16 then
        return 0;
    end;

    local PlayerCharacter = CharacterResolver.getPlayerCharacter(LocalPlayer);
    local _, _, v115, _, v116 = RuntimeKinematics.resolve(PlayerCharacter, nil);

    return not v116 and 0 or math.clamp((v115 - SpeedProfile.TopSpeed) / (SpeedProfile.SprintSpeed - SpeedProfile.TopSpeed), 0, 1);
end;

local function updateSprintBob(p117: number) -- Line: 657
    -- upvalues: u35 (copy), LocalFootsteps (copy), u16 (ref), CharacterResolver (copy), LocalPlayer (copy), RuntimeKinematics (copy), SpeedProfile (copy), u18 (ref), u17 (ref)
    local v118;

    if LocalFootsteps.isStepping(2.5) and u16 then
        local PlayerCharacter = CharacterResolver.getPlayerCharacter(LocalPlayer);
        local _, _, v119, _, v120 = RuntimeKinematics.resolve(PlayerCharacter, nil);
        v118 = not v120 and 0 or math.clamp((v119 - SpeedProfile.TopSpeed) / (SpeedProfile.SprintSpeed - SpeedProfile.TopSpeed), 0, 1);
    else
        v118 = 0;
    end;

    u35:setGoal(v118);
    u35:update(p117);
    local Position = u35:getPosition();

    if u16 or Position >= 0.001 then
        local v121 = (LocalFootsteps.getPhase() - 0.1) * 3.141592653589793;
        u18 = Position * 0.004363323129985824 * math.cos(v121);

        return;
    end;

    u35:reset(0);
    u18 = 0;
    u17 = false;
end;

function u1.clampFOV(p122: number) -- Line: 194
    return math.clamp(p122, 1, 80);
end;

u1.getAspectRatioStretch = getAspectRatioStretch;

function u1.Initialize() -- Line: 677
    -- upvalues: u11 (ref), ReplicatedStorage (copy), RunServiceController (copy), u30 (copy), u31 (copy), u32 (copy), u33 (copy), u34 (copy), u28 (copy), u29 (copy), u17 (ref), updateSprintBob (copy), u2 (ref), workspace_CurrentCamera (copy), CharacterResolver (copy), LocalPlayer (copy), u19 (ref), u1 (copy), getCameraCFrame (copy), u5 (copy), u7 (ref), UserInputService (copy), PlayerGui (copy), isOwnGameplayView (copy), u20 (ref), applyAspectRatioStretch (copy), RunService (copy), restoreAspectRatioStretch (copy)
    if not u11 then
        local success, result = pcall(function() -- Line: 132
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v123 = u11;

    if v123 then
        v123.Initialize();
    end;

    RunServiceController.BindToStepped("CameraController.UpdateSprings", function(p124: any, p125: number) -- Line: 683
        -- upvalues: u30 (ref), u31 (ref), u32 (ref), u33 (ref), u34 (ref), u28 (ref), u29 (ref), u17 (ref), updateSprintBob (ref)
        u30:update(p125);
        u31:update(p125);
        u32:update(p125);
        u33:update(p125);
        u34:update(p125);
        u28:update(p125);
        u29:update(p125);

        if u17 then
            updateSprintBob(p125);
        end;
    end);
    RunServiceController.BindToRenderStep("CameraController.UpdateCamera", Enum.RenderPriority.Camera.Value + 1, function(p126: number) -- Line: 696
        -- upvalues: u2 (ref), workspace_CurrentCamera (ref), u11 (ref), CharacterResolver (ref), LocalPlayer (ref), u19 (ref), u1 (ref), getCameraCFrame (ref), u5 (ref), u7 (ref), UserInputService (ref), PlayerGui (ref)
        if not u2 then
            return;
        end;

        local CFrame2 = workspace_CurrentCamera.CFrame;

        if u11 then
            local MagnetismRotation = u11.GetMagnetismRotation(p126);

            if MagnetismRotation.Magnitude > 1e-6 and (MagnetismRotation.X == MagnetismRotation.X and (MagnetismRotation.Y == MagnetismRotation.Y and (math.abs(MagnetismRotation.X) < 3.141592653589793 and math.abs(MagnetismRotation.Y) < 3.141592653589793))) then
                local PlayerCharacter = CharacterResolver.getPlayerCharacter(LocalPlayer);
                local v127;

                if PlayerCharacter and PlayerCharacter:FindFirstChild("HumanoidRootPart") then
                    v127 = PlayerCharacter.HumanoidRootPart.Position;
                else
                    v127 = CFrame2.Position;
                end;

                local math_clamp_ret = math.clamp(MagnetismRotation.Y, -0.08726646259971647, 0.08726646259971647);
                local math_clamp_ret2 = math.clamp(MagnetismRotation.X, -0.08726646259971647, 0.08726646259971647);
                local v128 = CFrame.fromAxisAngle(CFrame2.RightVector, math_clamp_ret) * CFrame.Angles(0, math_clamp_ret2, 0);
                local v129 = v128:VectorToWorldSpace(CFrame2.Position - v127);
                CFrame2 = CFrame.new(v127 + v129) * (v128 * CFrame2.Rotation);
            end;
        end;

        u19 = CFrame2;
        u1.updateCamera((getCameraCFrame()));
        local v130 = next(u5) ~= nil and true or u7;
        local v131;

        if v130 then
            v131 = Enum.MouseBehavior.Default;
        else
            v131 = Enum.MouseBehavior.LockCenter;
        end;

        if UserInputService.MouseBehavior ~= v131 then
            UserInputService.MouseBehavior = v131;
        end;

        if UserInputService.MouseIconEnabled ~= v130 then
            UserInputService.MouseIconEnabled = v130;
        end;

        local MainGui = PlayerGui:FindFirstChild("MainGui");

        if MainGui then
            MainGui = MainGui:FindFirstChild("CameraPerspective");
        end;

        if MainGui and MainGui.Visible ~= v130 then
            MainGui.Visible = v130;
        end;
    end);
    RunServiceController.BindToRenderStep("CameraController.ResetCameraShake", Enum.RenderPriority.Camera.Value - 1, function() -- Line: 749
        -- upvalues: u2 (ref), u19 (ref), isOwnGameplayView (ref), u20 (ref), workspace_CurrentCamera (ref)
        if u2 and u19 then
            if isOwnGameplayView() then
                workspace_CurrentCamera.CFrame = u19;
            else
                local v132 = u20;
                local v133;

                if v132 then
                    local CFrame2 = workspace_CurrentCamera.CFrame;

                    if (CFrame2.Position - v132.Position).Magnitude <= 0.001 then
                        v133 = (CFrame2.LookVector - v132.LookVector).Magnitude <= 0.0001;
                    else
                        v133 = false;
                    end;
                else
                    v133 = false;
                end;

                if v133 then
                    workspace_CurrentCamera.CFrame = u19;
                end;
            end;
        end;
    end);
    RunServiceController.BindToRenderSteppedEvent("CameraController.AspectRatioStretch", applyAspectRatioStretch, (1 / 0));
    RunService.PreAnimation:Connect(restoreAspectRatioStretch);
    RunServiceController.BindToRenderStep("CameraController.UndoAspectRatioStretch", Enum.RenderPriority.First.Value, restoreAspectRatioStretch);
    UserInputService.TextBoxFocused:Connect(function() -- Line: 765
        -- upvalues: u1 (ref)
        u1.setForceLockOverride("TextBox", true);
    end);
    UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 768
        -- upvalues: UserInputService (ref), u1 (ref)
        task.defer(function() -- Line: 770
            -- upvalues: UserInputService (ref), u1 (ref)
            local v134 = UserInputService:GetFocusedTextBox() ~= nil;
            u1.setForceLockOverride("TextBox", v134);
        end);
    end);
    local v135 = UserInputService:GetFocusedTextBox() ~= nil;
    u1.setForceLockOverride("TextBox", v135);
    local Attribute = LocalPlayer:GetAttribute("Team");

    if not (CharacterResolver.getPlayerCharacter(LocalPlayer) or (Attribute == "Counter-Terrorists" and true or Attribute == "Terrorists")) then
        u1.setForceLockOverride("InitialMenu", true);
    end;
end;

function u1.Start() -- Line: 787
    -- upvalues: ReplicatedStorage (copy), u26 (ref), u27 (ref), u1 (copy), Constants (copy), CharacterResolver (copy), LocalPlayer (copy), DataController (copy), u8 (ref), u13 (ref), getCameraInput (copy), u22 (ref), u21 (ref), u9 (ref)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    u26 = {
        MenuSceneController,
        {
            IsActive = MenuSceneController.IsTeamSelectSceneActive
        },
        CaseSceneController,
        require(ReplicatedStorage.Controllers.InspectController),
        require(ReplicatedStorage.Controllers.BlackMarketSceneController)
    };
    u27 = require(ReplicatedStorage.Controllers.SpectateController).IsSpectatingNow;
    local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);

    local function resetFOV() -- Line: 804
        -- upvalues: CaseSceneController (copy), BlackMarketSceneController (copy), u1 (ref), Constants (ref)
        if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
            u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
        end;
    end;

    CharacterResolver.observeCharacter(LocalPlayer, function(p136: userdata?) -- Line: 809
        -- upvalues: CaseSceneController (copy), BlackMarketSceneController (copy), u1 (ref), Constants (ref), resetFOV (copy)
        if p136 then
            if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
                u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            end;

            p136:GetAttributeChangedSignal("Dead"):Once(resetFOV);
        end;

        return function() -- Line: 814
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Mouse Sensitivity", function(p137: number?) -- Line: 818
        -- upvalues: u8 (ref), u13 (ref), getCameraInput (ref)
        u8 = math.clamp(p137 or 1, 0.1, 10);
        local v138 = u8;

        if u13 and math.abs(u13 - v138) <= 0.0001 then
            return;
        end;

        local v139 = getCameraInput();

        if v139 then
            u13 = v138;
            v139.setTouchSensitivity(v138);
        end;
    end);
    local v140 = u8;
    local v141 = ((not u13 or math.abs(u13 - v140) > 0.0001) and true or false) and getCameraInput();

    if v141 then
        u13 = v140;
        v141.setTouchSensitivity(v140);
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Video.Advanced.Aspect Ratio", function(p142) -- Line: 826
        -- upvalues: u22 (ref), u21 (ref)
        if u22 ~= nil then
            local v143 = (tonumber(p142) or 1) - u22;

            if math.abs(v143) > 0.0001 then
                return;
            end;

            u22 = nil;
        end;

        local v144 = tonumber(p142) or 1;
        u21 = (1 - math.clamp(v144, 0.5, 1)) / 0.5;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Zoom Sensitivity Multiplier", function(p145: number?) -- Line: 838
        -- upvalues: u9 (ref)
        u9 = math.clamp(p145 or 0.5, 0.1, 5);
    end);
end;

return u1;