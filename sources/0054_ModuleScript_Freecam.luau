-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local workspace_CurrentCamera = workspace.CurrentCamera;
local Vector2_new_ret = Vector2.new(9.42477796076938, 5.497787143782138);
local Vector2_new_ret2 = Vector2.new(4.71238898038469, 2.748893571891069);
local Vector2_new_ret3 = Vector2.new(0.4, 0.3333333333333333);
local Vector2_new_ret4 = Vector2.new(3.839724354387525, 2.6179938779914944);

local function IsInMoveRegion(p2: vector) -- Line: 54
    -- upvalues: workspace_CurrentCamera (copy), Vector2_new_ret3 (copy)
    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.X < ViewportSize.Y then
        return p2.Y >= ViewportSize.Y * 0.6;
    end;

    local v3;

    if p2.X <= ViewportSize.X * Vector2_new_ret3.X then
        v3 = p2.Y >= ViewportSize.Y * Vector2_new_ret3.Y;
    else
        v3 = false;
    end;

    return v3;
end;

local function ResolveTouchMoveVector(p4: vector, p5: vector) -- Line: 68
    -- upvalues: workspace_CurrentCamera (copy)
    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local v6 = math.min(ViewportSize.X, ViewportSize.Y) > 500 and 2 or 1;
    local Vector2_new_ret5 = Vector2.new(p5.X - p4.X, p5.Y - p4.Y);
    local Magnitude = Vector2_new_ret5.Magnitude;

    if Magnitude < v6 * 2 then
        return Vector3.new(0, 0, 0);
    end;

    local v7 = Vector2_new_ret5.Unit * math.min(Magnitude / (v6 * 20), 1);

    return Vector3.new(v7.X, 0, v7.Y);
end;

local function IsGamepadInput(p8: userdata) -- Line: 85
    return string.sub(p8.UserInputType.Name, 1, 7) == "Gamepad";
end;

local function ApplyDeadZone(p9) -- Line: 92
    local Magnitude = p9.Magnitude;

    if Magnitude <= 0.15 then
        return Vector2.zero;
    end;

    return p9.Unit * math.min((Magnitude - 0.15) / 0.85, 1);
end;

local function IsGamepadClaimedByUi() -- Line: 104
    -- upvalues: GuiService (copy)
    return GuiService.SelectedObject ~= nil and true or GuiService.MenuIsOpen;
end;

local function GetTouchControlsGui() -- Line: 110
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    if not UserInputService.TouchEnabled then
        return nil;
    end;

    local v10 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v10 then
        return v10:FindFirstChild("TouchGui");
    end;

    return nil;
end;

local function GetReplicationFocus() -- Line: 125
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("ReplicationFocus");
    end;

    if Map then
        Map = Map:FindFirstChild("Focus");
    end;

    return Map;
end;

local function RemoveJanitorEntry(p11: any, p12: string) -- Line: 133
    if p11:Get(p12) then
        p11:Remove(p12);
    end;
end;

function u1.UpdateMovement(p13: any, p14: number) -- Line: 142
    -- upvalues: InputController (copy), GuiService (copy)
    local v15 = Vector3.new(0, 0, 0);

    if InputController.isActionActive("Move Forward") then
        v15 = v15 + Vector3.new(0, 0, -1);
    end;

    if InputController.isActionActive("Move Backward") then
        v15 = v15 + Vector3.new(0, 0, 1);
    end;

    if InputController.isActionActive("Move Left (Strafe)") then
        v15 = v15 + Vector3.new(-1, 0, 0);
    end;

    if InputController.isActionActive("Move Right (Strafe)") then
        v15 = v15 + Vector3.new(1, 0, 0);
    end;

    local v16 = 40 * (InputController.isActionActive("Walk") and 0.2 or 1);

    if v15 ~= Vector3.new(0, 0, 0) then
        v15 = v15.Unit;
    end;

    local v17 = v15 + p13.TouchMoveVector;

    if GuiService.SelectedObject == nil and not GuiService.MenuIsOpen then
        local GamepadMove = p13.GamepadMove;
        local Magnitude = GamepadMove.Magnitude;
        local v18;

        if Magnitude <= 0.15 then
            v18 = Vector2.zero;
        else
            v18 = GamepadMove.Unit * math.min((Magnitude - 0.15) / 0.85, 1);
        end;

        v17 = v17 + Vector3.new(v18.X, p13.GamepadRise - p13.GamepadFall, -v18.Y);
    end;

    if v17.Magnitude > 1 then
        v17 = v17.Unit;
    end;

    local CameraCFrame = p13.CameraCFrame;
    local LookVector = CameraCFrame.LookVector;
    local v19 = p13.CameraCFrame.Position + (CameraCFrame.RightVector * v17.X + Vector3.new(0, 1, 0) * v17.Y + LookVector * -v17.Z) * (v16 * p14);
    p13.CameraCFrame = CFrame.new(v19, v19 + LookVector);
    p13:UpdateMouseWheel(p14);
end;

function u1.UpdateMouseWheel(p20: any, p21: number) -- Line: 190
    -- upvalues: InputController (copy)
    local MouseWheelDelta = p20.MouseWheelDelta;

    if MouseWheelDelta == 0 then
        return;
    end;

    local CameraCFrame = p20.CameraCFrame;
    local LookVector = CameraCFrame.LookVector;
    local v22 = 15 * (InputController.isActionActive("Walk") and 0.5 or 1);
    local v23 = CameraCFrame.Position + LookVector * (MouseWheelDelta > 0 and v22 and v22 or -v22);
    p20.CameraCFrame = CFrame.new(v23, v23 + LookVector);
    p20.MouseWheelDelta = 0;
end;

function u1.UpdateRotation(p24: any, p25: number) -- Line: 208
    -- upvalues: UserInputService (copy), InputController (copy), workspace_CurrentCamera (copy), Vector2_new_ret (copy), Vector2_new_ret2 (copy), GuiService (copy), Vector2_new_ret4 (copy)
    local v26;

    if p24.MoveTouch ~= nil and true or p24.LookTouch ~= nil then
        v26 = Vector2.zero;
    else
        v26 = UserInputService:GetMouseDelta();
    end;

    local v27 = InputController.isActionActive("Walk") and 0.5 or 1;
    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local v28 = v26.X / ViewportSize.X * (Vector2_new_ret.X * v27);
    local v29 = v26.Y / ViewportSize.Y * (Vector2_new_ret.Y * v27);
    local TouchLookDelta = p24.TouchLookDelta;

    if TouchLookDelta ~= Vector2.zero then
        p24.TouchLookDelta = Vector2.zero;
        v28 = v28 + TouchLookDelta.X / ViewportSize.X * (Vector2_new_ret2.X * v27);
        v29 = v29 + TouchLookDelta.Y / ViewportSize.Y * (Vector2_new_ret2.Y * v27);
    end;

    local v30;

    if GuiService.SelectedObject ~= nil and true or GuiService.MenuIsOpen then
        v30 = Vector2.zero;
    else
        local GamepadLook = p24.GamepadLook;
        local Magnitude = GamepadLook.Magnitude;

        if Magnitude <= 0.15 then
            v30 = Vector2.zero;
        else
            v30 = GamepadLook.Unit * math.min((Magnitude - 0.15) / 0.85, 1);
        end;
    end;

    if v30 ~= Vector2.zero then
        local v31 = v30.Unit * v30.Magnitude ^ 2;
        v28 = v28 + v31.X * Vector2_new_ret4.X * v27 * p25;
        v29 = v29 - v31.Y * Vector2_new_ret4.Y * v27 * p25;
    end;

    local CameraCFrame = p24.CameraCFrame;
    local Position = CameraCFrame.Position;
    local LookVector = CameraCFrame.LookVector;
    local v32 = math.asin(LookVector.Y) - v29;
    local math_clamp_ret = math.clamp(v32, -1.3962634015954636, 1.3962634015954636);
    local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Magnitude = Vector3_new_ret.Magnitude;
    local v33 = Magnitude < 0.001 and Vector3.new(0, 0, -1) or Vector3_new_ret / Magnitude;
    local v34 = math.atan2(-v33.X, -v33.Z) - v28;
    local math_cos_ret = math.cos(math_clamp_ret);
    local v35 = -math.sin(v34) * math_cos_ret;
    local math_sin_ret = math.sin(math_clamp_ret);
    local v36 = -math.cos(v34) * math_cos_ret;
    local Vector3_new_ret2 = Vector3.new(v35, math_sin_ret, v36);
    p24.CameraCFrame = CFrame.new(Position, Position + Vector3_new_ret2);
end;

function u1.ReleaseEndedTouches(p37) -- Line: 264
    local MoveTouch = p37.MoveTouch;

    if MoveTouch and MoveTouch.UserInputState == Enum.UserInputState.End then
        p37.MoveTouch = nil;
        p37.TouchMoveVector = Vector3.new(0, 0, 0);
    end;

    local LookTouch = p37.LookTouch;

    if LookTouch and LookTouch.UserInputState == Enum.UserInputState.End then
        p37.LookTouch = nil;
    end;
end;

function u1.ResetTouchInput(p38) -- Line: 280
    p38.TouchLookDelta = Vector2.zero;
    p38.TouchMoveVector = Vector3.new(0, 0, 0);
    p38.MoveTouch = nil;
    p38.MoveTouchStartPosition = Vector3.new(0, 0, 0);
    p38.LookTouch = nil;
end;

function u1.ResetGamepadInput(p39) -- Line: 291
    p39.GamepadMove = Vector2.zero;
    p39.GamepadLook = Vector2.zero;
    p39.GamepadRise = 0;
    p39.GamepadFall = 0;
end;

function u1.ShowTouchControls(u40) -- Line: 300
    -- upvalues: UserInputService (copy), LocalPlayer (copy), GuiService (copy)
    local u41;

    if UserInputService.TouchEnabled then
        local v42 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

        if v42 then
            u41 = v42:FindFirstChild("TouchGui");
        else
            u41 = nil;
        end;
    else
        u41 = nil;
    end;

    if not u41 then
        return;
    end;

    local function applyVisibility() -- Line: 306
        -- upvalues: u41 (copy), u40 (copy), GuiService (ref)
        u41.Enabled = u40.IsActive and GuiService.TouchControlsEnabled;
    end;

    u41.Enabled = u40.IsActive and GuiService.TouchControlsEnabled;
    u40.Janitor:Add(u41:GetPropertyChangedSignal("Enabled"):Connect(applyVisibility), "Disconnect", "TouchControlsEnabledGuard");
    u40.Janitor:Add(GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(applyVisibility), "Disconnect", "TouchControlsSettingGuard");
    u40.Janitor:Add(function() -- Line: 326
        -- upvalues: u41 (copy), LocalPlayer (ref), GuiService (ref)
        local v43;

        if LocalPlayer.Character == nil then
            v43 = false;
        else
            v43 = GuiService.TouchControlsEnabled;
        end;

        u41.Enabled = v43;
    end, true, "RestoreTouchControls");
end;

function u1.Render(p44: any, p45: number) -- Line: 333
    -- upvalues: workspace_CurrentCamera (copy)
    p44:ReleaseEndedTouches();
    p44:UpdateMovement(p45);
    p44:UpdateRotation(p45);
    workspace_CurrentCamera.CFrame = p44.CameraCFrame;
end;

function u1.Start(u46) -- Line: 342
    -- upvalues: workspace_CurrentCamera (copy), CameraController (copy), UserInputService (copy), RunServiceController (copy), LocalPlayer (copy)
    if u46.IsActive then
        return;
    end;

    u46.IsActive = true;
    u46.CameraCFrame = workspace_CurrentCamera.CFrame;
    u46.MouseWheelDelta = 0;
    u46:ResetTouchInput();
    u46:ResetGamepadInput();
    u46:ShowTouchControls();
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CameraController.setMouseEnabled(false);
    u46.Janitor:Add(UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(function() -- Line: 359
        -- upvalues: u46 (copy), UserInputService (ref)
        if u46.IsActive and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        end;
    end), "Disconnect", "EnforceMouseBehavior");
    RunServiceController.BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value + 10, function(p47: number) -- Line: 365
        -- upvalues: u46 (copy)
        if u46.IsActive then
            u46:Render(p47);
        end;
    end);
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("ReplicationFocus");
    end;

    if Map then
        Map = Map:FindFirstChild("Focus");
    end;

    if Map then
        LocalPlayer.ReplicationFocus = Map;
        u46.Janitor:Add(function() -- Line: 374
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.ReplicationFocus = nil;
        end, true, "ReplicationFocus");
    end;

    u46.Janitor:Add(function() -- Line: 379
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("Freecam");
    end, true);
end;

function u1.Stop(p48) -- Line: 386
    -- upvalues: RunServiceController (copy), workspace_CurrentCamera (copy)
    if not p48.IsActive then
        return;
    end;

    p48.IsActive = false;
    RunServiceController.UnbindFromRenderStep("Freecam");
    p48:ResetTouchInput();
    p48:ResetGamepadInput();
    local Janitor2 = p48.Janitor;

    if Janitor2:Get("TouchControlsEnabledGuard") then
        Janitor2:Remove("TouchControlsEnabledGuard");
    end;

    local Janitor3 = p48.Janitor;

    if Janitor3:Get("TouchControlsSettingGuard") then
        Janitor3:Remove("TouchControlsSettingGuard");
    end;

    local Janitor4 = p48.Janitor;

    if Janitor4:Get("RestoreTouchControls") then
        Janitor4:Remove("RestoreTouchControls");
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
    local Janitor5 = p48.Janitor;

    if Janitor5:Get("EnforceMouseBehavior") then
        Janitor5:Remove("EnforceMouseBehavior");
    end;

    local Janitor6 = p48.Janitor;

    if Janitor6:Get("ReplicationFocus") then
        Janitor6:Remove("ReplicationFocus");
    end;
end;

function u1.new() -- Line: 413
    -- upvalues: u1 (copy), Janitor (copy), UserInputService (copy), workspace_CurrentCamera (copy), Vector2_new_ret3 (copy), ResolveTouchMoveVector (copy)
    local u49 = setmetatable({}, u1);
    u49.Janitor = Janitor.new();
    u49.CameraCFrame = CFrame.identity;
    u49.MouseWheelDelta = 0;
    u49.TouchLookDelta = Vector2.zero;
    u49.TouchMoveVector = Vector3.new(0, 0, 0);
    u49.MoveTouchStartPosition = Vector3.new(0, 0, 0);
    u49.GamepadMove = Vector2.zero;
    u49.GamepadLook = Vector2.zero;
    u49.GamepadRise = 0;
    u49.GamepadFall = 0;
    u49.IsActive = false;
    u49.Janitor:Add(UserInputService.InputBegan:Connect(function(p50, p51) -- Line: 428
        -- upvalues: u49 (copy), workspace_CurrentCamera (ref), Vector2_new_ret3 (ref)
        if not (u49.IsActive and (p50.UserInputType == Enum.UserInputType.Touch and not p51)) then
            return;
        end;

        if not u49.MoveTouch then
            local Position = p50.Position;
            local ViewportSize = workspace_CurrentCamera.ViewportSize;
            local v52;

            if ViewportSize.X < ViewportSize.Y then
                v52 = Position.Y >= ViewportSize.Y * 0.6;
            elseif Position.X <= ViewportSize.X * Vector2_new_ret3.X then
                v52 = Position.Y >= ViewportSize.Y * Vector2_new_ret3.Y;
            else
                v52 = false;
            end;

            if v52 then
                u49.MoveTouch = p50;
                u49.MoveTouchStartPosition = p50.Position;
                u49.TouchMoveVector = Vector3.new(0, 0, 0);

                return;
            end;
        end;

        if not u49.LookTouch then
            u49.LookTouch = p50;
        end;
    end), "Disconnect");
    u49.Janitor:Add(UserInputService.InputChanged:Connect(function(p53, p54) -- Line: 444
        -- upvalues: u49 (copy), ResolveTouchMoveVector (ref)
        if not u49.IsActive then
            return;
        end;

        if string.sub(p53.UserInputType.Name, 1, 7) ~= "Gamepad" then
            if p53.UserInputType == Enum.UserInputType.MouseWheel then
                if not p54 then
                    u49.MouseWheelDelta = p53.Position.Z;
                end;

                return;
            end;

            if p53.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if p53 == u49.MoveTouch then
                u49.TouchMoveVector = ResolveTouchMoveVector(u49.MoveTouchStartPosition, p53.Position);

                return;
            end;

            if p53 == u49.LookTouch then
                u49.TouchLookDelta = u49.TouchLookDelta + Vector2.new(p53.Delta.X, p53.Delta.Y);
            end;

            return;
        end;

        local KeyCode = p53.KeyCode;

        if KeyCode == Enum.KeyCode.Thumbstick1 then
            u49.GamepadMove = Vector2.new(p53.Position.X, p53.Position.Y);

            return;
        end;

        if KeyCode == Enum.KeyCode.Thumbstick2 then
            u49.GamepadLook = Vector2.new(p53.Position.X, p53.Position.Y);

            return;
        end;

        if KeyCode == Enum.KeyCode.ButtonR2 then
            u49.GamepadRise = p53.Position.Z;

            return;
        end;

        if KeyCode == Enum.KeyCode.ButtonL2 then
            u49.GamepadFall = p53.Position.Z;
        end;
    end), "Disconnect");
    u49.Janitor:Add(UserInputService.InputEnded:Connect(function(p55) -- Line: 487
        -- upvalues: u49 (copy)
        if string.sub(p55.UserInputType.Name, 1, 7) ~= "Gamepad" then
            if p55.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if p55 ~= u49.MoveTouch then
                if p55 == u49.LookTouch then
                    u49.LookTouch = nil;
                end;

                return;
            end;

            u49.MoveTouch = nil;
            u49.TouchMoveVector = Vector3.new(0, 0, 0);

            return;
        end;

        local KeyCode = p55.KeyCode;

        if KeyCode == Enum.KeyCode.Thumbstick1 then
            u49.GamepadMove = Vector2.zero;

            return;
        end;

        if KeyCode == Enum.KeyCode.Thumbstick2 then
            u49.GamepadLook = Vector2.zero;

            return;
        end;

        if KeyCode == Enum.KeyCode.ButtonR2 then
            u49.GamepadRise = 0;

            return;
        end;

        if KeyCode == Enum.KeyCode.ButtonL2 then
            u49.GamepadFall = 0;
        end;
    end), "Disconnect");
    u49.Janitor:Add(function() -- Line: 515
        -- upvalues: u49 (copy)
        if u49.IsActive then
            u49:Stop();
        end;
    end);

    return u49;
end;

function u1.Destroy(p56) -- Line: 527
    p56.Janitor:Destroy();
end;

return u1;