-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = { "CameraMinZoomDistance", "CameraMaxZoomDistance", "CameraMode", "DevCameraOcclusionMode", "DevComputerCameraMode", "DevTouchCameraMode", "DevComputerMovementMode", "DevTouchMovementMode", "DevEnableMouseLock" };
local u3 = { "ComputerCameraMovementMode", "ComputerMovementMode", "ControlMode", "GamepadCameraSensitivity", "MouseSensitivity", "RotationType", "TouchCameraMovementMode", "TouchMovementMode" };
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local VRService = game:GetService("VRService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CommonUtils = script.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local CameraUtils = require(script:WaitForChild("CameraUtils"));
local CameraInput = require(script:WaitForChild("CameraInput"));
local ClassicCamera = require(script:WaitForChild("ClassicCamera"));
local OrbitalCamera = require(script:WaitForChild("OrbitalCamera"));
local LegacyCamera = require(script:WaitForChild("LegacyCamera"));
local VehicleCamera = require(script:WaitForChild("VehicleCamera"));
local VRCamera = require(script:WaitForChild("VRCamera"));
local VRVehicleCamera = require(script:WaitForChild("VRVehicleCamera"));
local Invisicam = require(script:WaitForChild("Invisicam"));
local Poppercam = require(script:WaitForChild("Poppercam"));
local TransparencyController = require(script:WaitForChild("TransparencyController"));
local MouseLockController = require(script:WaitForChild("MouseLockController"));
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local u4 = {};
local u5 = {};

if not Players.LocalPlayer then
    return {};
end;

assert(Players.LocalPlayer, "Strict typing check");
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default);
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow);
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle);
local UserFlag = FlagUtil.getUserFlag("UserRespectLegacyCameraOptions");
FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak");

function u1.new() -- Line: 157
    -- upvalues: TransparencyController (copy), ConnectionUtil (copy), u1 (copy), Players (copy), UserInputService (copy), MouseLockController (copy), UserFlag (copy), RunService (copy), u2 (copy), u3 (copy), UserGameSettings (copy)
    local v6 = {
        activeTransparencyController = TransparencyController.new(),
        connectionUtil = ConnectionUtil.new()
    };
    local u7 = setmetatable(v6, u1);
    u7.activeCameraController = nil;
    u7.activeOcclusionModule = nil;
    u7.activeMouseLockController = nil;
    u7.currentComputerCameraMovementMode = nil;
    u7.cameraSubjectChangedConn = nil;
    u7.cameraTypeChangedConn = nil;
    u7.renderStepName = "cameraRenderUpdate";

    for _, v in pairs(Players:GetPlayers()) do
        u7:OnPlayerAdded(v);
    end;

    u7.connectionUtil:trackConnection("Players.PlayerAdded", Players.PlayerAdded:Connect(function(p8) -- Line: 185
        -- upvalues: u7 (copy)
        u7:OnPlayerAdded(p8);
    end));
    u7.connectionUtil:trackConnection("Players.PlayerRemoving", Players.PlayerRemoving:Connect(function(p9) -- Line: 192
        -- upvalues: u7 (copy)
        u7:OnPlayerRemoving(p9);
    end));
    u7.activeTransparencyController:Enable(true);

    if not UserInputService.TouchEnabled then
        u7.activeMouseLockController = MouseLockController.new();
        assert(u7.activeMouseLockController, "Strict typing check");
        local BindableToggleEvent = u7.activeMouseLockController:GetBindableToggleEvent();

        if BindableToggleEvent then
            u7.connectionUtil:trackConnection("MouseLockToggleEvent", BindableToggleEvent:Connect(function() -- Line: 207
                -- upvalues: u7 (copy)
                u7:OnMouseLockToggled();
            end));
        end;
    end;

    if UserFlag then
        u7:ActivateCameraController();
    else
        u7:ActivateCameraController(u7:GetCameraControlChoice());
    end;

    u7:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode);
    u7:OnCurrentCameraChanged();
    RunService:BindToRenderStep(u7.renderStepName, Enum.RenderPriority.Camera.Value, function(p10) -- Line: 221
        -- upvalues: u7 (copy)
        u7:Update(p10);
    end);

    for _, v in pairs(u2) do
        u7.connectionUtil:trackConnection(`LocalPlayer.{v}`, Players.LocalPlayer:GetPropertyChangedSignal(v):Connect(function() -- Line: 229
            -- upvalues: u7 (copy), v (copy)
            u7:OnLocalPlayerCameraPropertyChanged(v);
        end));
    end;

    for _, v in pairs(u3) do
        u7.connectionUtil:trackConnection(`UserGameSettings.{v}`, UserGameSettings:GetPropertyChangedSignal(v):Connect(function() -- Line: 238
            -- upvalues: u7 (copy), v (copy)
            u7:OnUserGameSettingsPropertyChanged(v);
        end));
    end;

    u7.connectionUtil:trackConnection("Workspace.CurrentCamera", workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 245
        -- upvalues: u7 (copy)
        u7:OnCurrentCameraChanged();
    end));

    return u7;
end;

function u1.GetCameraMovementModeFromSettings(p11) -- Line: 253
    -- upvalues: Players (copy), CameraUtils (copy), UserInputService (copy), UserGameSettings (copy)
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic);
    end;

    local v12, v13;

    if UserInputService.TouchEnabled then
        v12 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode);
        v13 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode);
    else
        v12 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode);
        v13 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode);
    end;

    if v12 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v13;
    end;

    return v12;
end;

function u1.ActivateOcclusionModule(p14, p15) -- Line: 278
    -- upvalues: Poppercam (copy), Invisicam (copy), u5 (copy), CharacterResolver (copy), Players (copy)
    local v16;

    if p15 == Enum.DevCameraOcclusionMode.Zoom then
        v16 = Poppercam;
    else
        if p15 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode");

            return;
        end;

        v16 = Invisicam;
    end;

    p14.occlusionMode = p15;

    if p14.activeOcclusionModule and p14.activeOcclusionModule:GetOcclusionMode() == p15 then
        if not p14.activeOcclusionModule:GetEnabled() then
            p14.activeOcclusionModule:Enable(true);
        end;

        return;
    end;

    local activeOcclusionModule = p14.activeOcclusionModule;
    p14.activeOcclusionModule = u5[v16];

    if not p14.activeOcclusionModule then
        p14.activeOcclusionModule = v16.new();

        if p14.activeOcclusionModule then
            u5[v16] = p14.activeOcclusionModule;
        end;
    end;

    if p14.activeOcclusionModule then
        if p14.activeOcclusionModule:GetOcclusionMode() ~= p15 then
            warn("CameraScript ActivateOcclusionModule mismatch: ", p14.activeOcclusionModule:GetOcclusionMode(), "~=", p15);
        end;

        if activeOcclusionModule then
            if activeOcclusionModule == p14.activeOcclusionModule then
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module");
            else
                activeOcclusionModule:Enable(false);
            end;
        end;

        if p15 == Enum.DevCameraOcclusionMode.Invisicam then
            local PlayerCharacter = CharacterResolver.getPlayerCharacter(Players.LocalPlayer);

            if PlayerCharacter then
                p14.activeOcclusionModule:CharacterAdded(PlayerCharacter, Players.LocalPlayer);
            end;
        else
            for _, v in pairs(Players:GetPlayers()) do
                local v17;

                if v then
                    v17 = CharacterResolver.getPlayerCharacter(v);
                else
                    v17 = v;
                end;

                if v17 then
                    p14.activeOcclusionModule:CharacterAdded(v17, v);
                end;
            end;

            p14.activeOcclusionModule:OnCameraSubjectChanged(workspace.CurrentCamera.CameraSubject);
        end;

        p14.activeOcclusionModule:Enable(true);
    end;
end;

function u1.ShouldUseVehicleCamera(p18) -- Line: 364
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return false;
    end;

    local CameraType = workspace_CurrentCamera.CameraType;
    local CameraSubject = workspace_CurrentCamera.CameraSubject;
    local v19 = CameraType == Enum.CameraType.Custom and true or CameraType == Enum.CameraType.Follow;
    local v20 = CameraSubject and CameraSubject:IsA("VehicleSeat") or false;
    local v21 = p18.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam;

    if v20 then
        if not v19 then
            v21 = v19;
        end;
    else
        v21 = v20;
    end;

    return v21;
end;

function u1.ActivateCameraController(p22, p23, p24) -- Line: 380
    -- upvalues: UserFlag (copy), LegacyCamera (copy), VRService (copy), VRCamera (copy), ClassicCamera (copy), OrbitalCamera (copy), VRVehicleCamera (copy), VehicleCamera (copy), u4 (copy)
    if UserFlag then
        p24 = workspace.CurrentCamera.CameraType;
        p23 = p22:GetCameraMovementModeFromSettings();
    end;

    local v25 = nil;

    if UserFlag and true or p24 ~= nil then
        if p24 == Enum.CameraType.Scriptable then
            if p22.activeCameraController then
                p22.activeCameraController:Enable(false);
                p22.activeCameraController = nil;
            end;

            return;
        end;

        if p24 == Enum.CameraType.Custom then
            p23 = p22:GetCameraMovementModeFromSettings();
        elseif p24 == Enum.CameraType.Track then
            p23 = Enum.ComputerCameraMovementMode.Classic;
        elseif p24 == Enum.CameraType.Follow then
            p23 = Enum.ComputerCameraMovementMode.Follow;
        elseif p24 == Enum.CameraType.Orbital then
            p23 = Enum.ComputerCameraMovementMode.Orbital;
        elseif p24 == Enum.CameraType.Attach or (p24 == Enum.CameraType.Watch or p24 == Enum.CameraType.Fixed) then
            v25 = LegacyCamera;
        else
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", p24);
        end;
    end;

    if not v25 then
        if VRService.VREnabled then
            v25 = VRCamera;
        elseif p23 == Enum.ComputerCameraMovementMode.Classic or (p23 == Enum.ComputerCameraMovementMode.Follow or (p23 == Enum.ComputerCameraMovementMode.Default or p23 == Enum.ComputerCameraMovementMode.CameraToggle)) then
            v25 = ClassicCamera;
        else
            if p23 ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.");

                return;
            end;

            v25 = OrbitalCamera;
        end;
    end;

    if p22:ShouldUseVehicleCamera() then
        if VRService.VREnabled then
            v25 = VRVehicleCamera;
        else
            v25 = VehicleCamera;
        end;
    end;

    local v26;

    if u4[v25] then
        v26 = u4[v25];

        if v26.Reset then
            v26:Reset();
        end;
    else
        v26 = v25.new();
        u4[v25] = v26;
    end;

    if p22.activeCameraController then
        if p22.activeCameraController == v26 then
            if not p22.activeCameraController:GetEnabled() then
                p22.activeCameraController:Enable(true);
            end;
        else
            p22.activeCameraController:Enable(false);
            p22.activeCameraController = v26;
            p22.activeCameraController:Enable(true);
        end;
    elseif v26 ~= nil then
        p22.activeCameraController = v26;
        assert(p22.activeCameraController, "Strict typing check");
        p22.activeCameraController:Enable(true);
    end;

    if p22.activeCameraController then
        if UserFlag then
            p22.activeCameraController:SetCameraMovementMode(p23);
            p22.activeCameraController:SetCameraType(p24);

            return;
        end;

        if p23 ~= nil then
            p22.activeCameraController:SetCameraMovementMode(p23);

            return;
        end;

        if p24 ~= nil then
            p22.activeCameraController:SetCameraType(p24);
        end;
    end;
end;

function u1.OnCameraSubjectChanged(p27) -- Line: 499
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v28;

    if workspace_CurrentCamera then
        v28 = workspace_CurrentCamera.CameraSubject;
    else
        v28 = nil;
    end;

    if p27.activeTransparencyController then
        p27.activeTransparencyController:SetSubject(v28);
    end;

    if p27.activeOcclusionModule then
        p27.activeOcclusionModule:OnCameraSubjectChanged(v28);
    end;

    local v29;

    if workspace_CurrentCamera then
        v29 = workspace_CurrentCamera.CameraType;
    else
        v29 = nil;
    end;

    p27:ActivateCameraController(nil, v29);
end;

function u1.OnCameraTypeChanged(p30, p31) -- Line: 514
    -- upvalues: UserInputService (copy), CameraUtils (copy)
    if p31 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils.restoreMouseBehavior();
    end;

    p30:ActivateCameraController(nil, p31);
end;

function u1.OnCurrentCameraChanged(u32) -- Line: 526
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    if u32.cameraSubjectChangedConn then
        u32.cameraSubjectChangedConn:Disconnect();
    end;

    if u32.cameraTypeChangedConn then
        u32.cameraTypeChangedConn:Disconnect();
    end;

    u32.cameraSubjectChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 540
        -- upvalues: u32 (copy)
        u32:OnCameraSubjectChanged();
    end);
    u32.cameraTypeChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- Line: 544
        -- upvalues: u32 (copy), workspace_CurrentCamera (copy)
        u32:OnCameraTypeChanged(workspace_CurrentCamera.CameraType);
    end);
    u32:OnCameraSubjectChanged();
    u32:OnCameraTypeChanged(workspace_CurrentCamera.CameraType);
end;

function u1.OnLocalPlayerCameraPropertyChanged(p33: table, p34: string) -- Line: 552
    -- upvalues: Players (copy), CameraUtils (copy)
    if p34 == "CameraMode" then
        if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode);

                return;
            end;

            local CameraMovementModeFromSettings = p33:GetCameraMovementModeFromSettings();
            p33:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings));

            return;
        end;

        if not p33.activeCameraController or p33.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            p33:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic));
        end;

        if p33.activeCameraController then
            p33.activeCameraController:UpdateForDistancePropertyChange();
        end;
    else
        if p34 == "DevComputerCameraMode" or p34 == "DevTouchCameraMode" then
            local CameraMovementModeFromSettings = p33:GetCameraMovementModeFromSettings();
            p33:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings));

            return;
        end;

        if p34 == "DevCameraOcclusionMode" then
            p33:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode);

            return;
        end;

        if p34 == "CameraMinZoomDistance" or p34 == "CameraMaxZoomDistance" then
            if p33.activeCameraController then
                p33.activeCameraController:UpdateForDistancePropertyChange();
            end;
        else
            if p34 == "DevTouchMovementMode" then
                return;
            end;

            if p34 == "DevComputerMovementMode" then
                return;
            end;

            local _ = p34 == "DevEnableMouseLock";
        end;
    end;
end;

function u1.OnUserGameSettingsPropertyChanged(p35: table, p36: string) -- Line: 594
    -- upvalues: CameraUtils (copy)
    if p36 == "ComputerCameraMovementMode" then
        local CameraMovementModeFromSettings = p35:GetCameraMovementModeFromSettings();
        p35:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings));
    end;
end;

function u1.Update(p37, p38) -- Line: 608
    -- upvalues: CameraInput (copy)
    if p37.activeCameraController then
        p37.activeCameraController:UpdateMouseBehavior();
        local v39, v40 = p37.activeCameraController:Update(p38);

        if p37.activeOcclusionModule then
            v39, v40 = p37.activeOcclusionModule:Update(p38, v39, v40);
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;
        workspace_CurrentCamera.CFrame = v39;
        workspace_CurrentCamera.Focus = v40;

        if p37.activeTransparencyController then
            p37.activeTransparencyController:Update(p38);
        end;

        if CameraInput.getInputEnabled() then
            CameraInput.resetInputForFrameEnd();
        end;
    end;
end;

function u1.GetCameraControlChoice(p41) -- Line: 636
    -- upvalues: UserFlag (copy), UserInputService (copy), Players (copy), CameraUtils (copy), UserGameSettings (copy)
    assert(not UserFlag, "CameraModule:GetCameraControlChoice should not be called when FFlagUserRespectLegacyCameraOptions is enabled");

    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch or UserInputService.TouchEnabled then
        if Players.LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
            return CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode);
        end;

        return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode);
    end;

    if Players.LocalPlayer.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
        return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode);
    end;

    local v42 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode);

    return CameraUtils.ConvertCameraModeEnumToStandard(v42);
end;

function u1.OnCharacterAdded(p43: table, p44: userdata, p45: userdata) -- Line: 660
    if p43.activeOcclusionModule then
        p43.activeOcclusionModule:CharacterAdded(p44, p45);
    end;
end;

function u1.OnCharacterRemoving(p46, p47, p48) -- Line: 666
    if p46.activeOcclusionModule then
        p46.activeOcclusionModule:CharacterRemoving(p47, p48);
    end;
end;

function u1.OnPlayerAdded(u49: table, u50: userdata) -- Line: 672
    -- upvalues: CharacterResolver (copy)
    u49.connectionUtil:trackBoundFunction(`{u50.UserId}CharacterObserver`, CharacterResolver.observeCharacter(u50, function(p51: userdata?, p52: userdata?) -- Line: 675
        -- upvalues: u49 (copy), u50 (copy)
        if p52 and p52 ~= p51 then
            u49:OnCharacterRemoving(p52, u50);
        end;

        if p51 then
            u49:OnCharacterAdded(p51, u50);
        end;

        return function() -- Line: 682
        end;
    end));
end;

function u1.OnPlayerRemoving(p53: table, p54: userdata) -- Line: 687
    p53.connectionUtil:disconnect((`{p54.UserId}CharacterObserver`));
end;

function u1.OnMouseLockToggled(p55) -- Line: 691
    if p55.activeMouseLockController then
        local IsMouseLocked = p55.activeMouseLockController:GetIsMouseLocked();
        local MouseLockOffset = p55.activeMouseLockController:GetMouseLockOffset();

        if p55.activeCameraController then
            p55.activeCameraController:SetIsMouseLocked(IsMouseLocked);
            p55.activeCameraController:SetMouseLockOffset(MouseLockOffset);
        end;
    end;
end;

u1.new();

return {};