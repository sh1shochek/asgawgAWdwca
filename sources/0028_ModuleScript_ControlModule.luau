-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRService = game:GetService("VRService");
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
script.Parent:WaitForChild("CommonUtils");
local Keyboard = require(script:WaitForChild("Keyboard"));
local Gamepad = require(script:WaitForChild("Gamepad"));
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"));
local success, result = pcall(function() -- Line: 39
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u2 = success and result;
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"));
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"));
local TouchJump = require(script:WaitForChild("TouchJump"));
local VehicleController = require(script:WaitForChild("VehicleController"));
local Value = Enum.ContextActionPriority.Medium.Value;
local u3 = {
    [Enum.TouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.TouchMovementMode.Default] = DynamicThumbstick,
    [Enum.ComputerMovementMode.Default] = Keyboard,
    [Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
};
local u4 = {
    [Enum.UserInputType.Keyboard] = Keyboard,
    [Enum.UserInputType.MouseButton1] = Keyboard,
    [Enum.UserInputType.MouseButton2] = Keyboard,
    [Enum.UserInputType.MouseButton3] = Keyboard,
    [Enum.UserInputType.MouseWheel] = Keyboard,
    [Enum.UserInputType.MouseMovement] = Keyboard,
    [Enum.UserInputType.Gamepad1] = Gamepad,
    [Enum.UserInputType.Gamepad2] = Gamepad,
    [Enum.UserInputType.Gamepad3] = Gamepad,
    [Enum.UserInputType.Gamepad4] = Gamepad,
    [Enum.UserInputType.Gamepad5] = Gamepad,
    [Enum.UserInputType.Gamepad6] = Gamepad,
    [Enum.UserInputType.Gamepad7] = Gamepad,
    [Enum.UserInputType.Gamepad8] = Gamepad
};
local u5 = nil;

function u1.new() -- Line: 104
    -- upvalues: u1 (copy), Players (copy), VehicleController (copy), Value (copy), CharacterResolver (copy), RunService (copy), UserInputService (copy), UserGameSettings (copy), GuiService (copy)
    local u6 = setmetatable({}, u1);
    u6.controllers = {};
    u6.activeControlModule = nil;
    u6.activeController = nil;
    u6.touchJumpController = nil;
    u6.moveFunction = Players.LocalPlayer.Move;
    u6.character = nil;
    u6.humanoid = nil;
    u6.customCharacterMotor = nil;
    u6.lastInputType = Enum.UserInputType.None;
    u6.controlsEnabled = true;
    u6.humanoidSeatedConn = nil;
    u6.vehicleController = nil;
    u6.touchControlFrame = nil;
    u6.currentTorsoAngle = 0;
    u6.inputMoveVector = Vector3.new(0, 0, 0);
    u6.vehicleController = VehicleController.new(Value);
    u6.presentedCharacterDisconnect = CharacterResolver.observeCharacter(Players.LocalPlayer, function(p7, p8) -- Line: 134
        -- upvalues: u6 (copy)
        if p8 and p8 ~= p7 then
            u6:OnCharacterRemoving(p8);
        end;

        if p7 then
            u6:OnCharacterAdded(p7);
        end;

        return function() -- Line: 141
        end;
    end);
    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p9) -- Line: 145
        -- upvalues: u6 (copy)
        u6:OnRenderStepped(p9);
    end);
    UserInputService.LastInputTypeChanged:Connect(function(p10) -- Line: 149
        -- upvalues: u6 (copy)
        u6:OnLastInputTypeChanged(p10);
    end);
    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- Line: 153
        -- upvalues: u6 (copy)
        u6:OnTouchMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- Line: 156
        -- upvalues: u6 (copy)
        u6:OnTouchMovementModeChange();
    end);
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- Line: 160
        -- upvalues: u6 (copy)
        u6:OnComputerMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 163
        -- upvalues: u6 (copy)
        u6:OnComputerMovementModeChange();
    end);
    u6.playerGui = nil;
    u6.touchGui = nil;
    u6.playerGuiAddedConn = nil;
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- Line: 173
        -- upvalues: u6 (copy)
        u6:UpdateTouchGuiVisibility();
        u6:UpdateActiveControlModuleEnabled();
    end);

    if not UserInputService.TouchEnabled then
        u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());

        return u6;
    end;

    u6.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not u6.playerGui then
        u6.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p11) -- Line: 184
            -- upvalues: u6 (copy), UserInputService (ref)
            if p11:IsA("PlayerGui") then
                u6.playerGui = p11;
                u6:CreateTouchGuiContainer();
                u6.playerGuiAddedConn:Disconnect();
                u6.playerGuiAddedConn = nil;
                u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());
            end;
        end);

        return u6;
    end;

    u6:CreateTouchGuiContainer();
    u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());

    return u6;
end;

function u1.GetMoveVector(p12) -- Line: 204
    return not p12.activeController and Vector3.new(0, 0, 0) or p12.activeController:GetMoveVector();
end;

local function NormalizeAngle(p13) -- Line: 211
    local v14 = (p13 + 12.566370614359172) % 6.283185307179586;

    if v14 > 3.141592653589793 then
        v14 = v14 - 6.283185307179586;
    end;

    return v14;
end;

local function AverageAngle(p15, p16) -- Line: 219
    local v17 = (p16 - p15 + 12.566370614359172) % 6.283185307179586;

    if v17 > 3.141592653589793 then
        v17 = v17 - 6.283185307179586;
    end;

    local v18 = (p15 + v17 / 2 + 12.566370614359172) % 6.283185307179586;

    if v18 > 3.141592653589793 then
        v18 = v18 - 6.283185307179586;
    end;

    return v18;
end;

function u1.GetEstimatedVRTorsoFrame(p19) -- Line: 224
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v20, _ = UserCFrame:ToEulerAnglesYXZ();
    local v21 = -v20;

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v22 = UserCFrame.Position - UserCFrame2.Position;
        local v23 = UserCFrame.Position - UserCFrame3.Position;
        local v24 = -math.atan2(v22.X, v22.Z);
        local v25 = (-math.atan2(v23.X, v23.Z) - v24 + 12.566370614359172) % 6.283185307179586;

        if v25 > 3.141592653589793 then
            v25 = v25 - 6.283185307179586;
        end;

        local v26 = (v24 + v25 / 2 + 12.566370614359172) % 6.283185307179586;

        if v26 > 3.141592653589793 then
            v26 = v26 - 6.283185307179586;
        end;

        local v27 = (v21 - p19.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v27 > 3.141592653589793 then
            v27 = v27 - 6.283185307179586;
        end;

        local v28 = (v26 - p19.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v28 > 3.141592653589793 then
            v28 = v28 - 6.283185307179586;
        end;

        local v29;

        if v28 > -1.5707963267948966 then
            v29 = v28 < 1.5707963267948966;
        else
            v29 = false;
        end;

        if not v29 then
            v28 = v27;
        end;

        local math_min_ret = math.min(v28, v27);
        local math_max_ret = math.max(v28, v27);
        local v30 = 0;

        if math_min_ret > 0 then
            math_max_ret = math_min_ret;
        elseif math_max_ret >= 0 then
            math_max_ret = v30;
        end;

        p19.currentTorsoAngle = math_max_ret + p19.currentTorsoAngle;
    else
        p19.currentTorsoAngle = v21;
    end;

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -p19.currentTorsoAngle, 0);
end;

function u1.GetActiveController(p31) -- Line: 269
    return p31.activeController;
end;

function u1.UpdateActiveControlModuleEnabled(u32) -- Line: 274
    -- upvalues: Players (copy), ClickToMoveController (copy), TouchThumbstick (copy), DynamicThumbstick (copy), TouchJump (copy), GuiService (copy), UserInputService (copy)
    local function _() -- Line: 276
        -- upvalues: u32 (copy), Players (ref)
        u32.activeController:Enable(false);

        if u32.touchJumpController then
            u32.touchJumpController:Enable(false);
        end;

        if u32.moveFunction then
            u32.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;
    end;

    local function v33() -- Line: 287
        -- upvalues: u32 (copy), ClickToMoveController (ref), TouchThumbstick (ref), DynamicThumbstick (ref), TouchJump (ref), Players (ref)
        if u32.touchControlFrame and (u32.activeControlModule == ClickToMoveController or (u32.activeControlModule == TouchThumbstick or u32.activeControlModule == DynamicThumbstick)) then
            if not u32.controllers[TouchJump] then
                u32.controllers[TouchJump] = TouchJump.new();
            end;

            u32.touchJumpController = u32.controllers[TouchJump];
            u32.touchJumpController:Enable(true, u32.touchControlFrame);
        elseif u32.touchJumpController then
            u32.touchJumpController:Enable(false);
        end;

        if u32.activeControlModule == ClickToMoveController then
            u32.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u32.touchJumpController);

            return;
        end;

        if u32.touchControlFrame then
            u32.activeController:Enable(true, u32.touchControlFrame);

            return;
        end;

        u32.activeController:Enable(true);
    end;

    if not u32.activeController then
        return;
    end;

    if not u32.controlsEnabled then
        u32.activeController:Enable(false);

        if u32.touchJumpController then
            u32.touchJumpController:Enable(false);
        end;

        if u32.moveFunction then
            u32.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;

        return;
    end;

    if GuiService.TouchControlsEnabled or not (UserInputService.TouchEnabled and (u32.activeControlModule == ClickToMoveController or (u32.activeControlModule == TouchThumbstick or u32.activeControlModule == DynamicThumbstick))) then
        v33();

        return;
    end;

    u32.activeController:Enable(false);

    if u32.touchJumpController then
        u32.touchJumpController:Enable(false);
    end;

    if u32.moveFunction then
        u32.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
    end;
end;

function u1.Enable(p34: table, p35: boolean?) -- Line: 352
    local v36 = p35 == nil and true or p35;

    if p34.controlsEnabled == v36 then
        return;
    end;

    p34.controlsEnabled = v36;

    if not p34.activeController then
        return;
    end;

    p34:UpdateActiveControlModuleEnabled();
end;

function u1.Disable(p37) -- Line: 369
    p37:Enable(false);
end;

function u1.SelectComputerMovementModule(p38) -- Line: 374
    -- upvalues: UserInputService (copy), Players (copy), u4 (copy), u5 (ref), UserGameSettings (copy), Keyboard (copy), ClickToMoveController (copy), u3 (copy)
    if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
        return nil, false;
    end;

    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode;
    local v39;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        v39 = u4[u5];

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v39 == Keyboard then
            v39 = ClickToMoveController;
        end;
    else
        v39 = u3[DevComputerMovementMode];

        if not v39 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode);
        end;
    end;

    if v39 then
        return v39, true;
    end;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true;
    end;

    return nil, false;
end;

function u1.SelectTouchModule(p40) -- Line: 415
    -- upvalues: UserInputService (copy), Players (copy), UserGameSettings (copy), DynamicThumbstick (copy), u3 (copy)
    if not UserInputService.TouchEnabled then
        return nil, false;
    end;

    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode;
    local v41;

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        local TouchMovementMode = UserGameSettings.TouchMovementMode;

        if TouchMovementMode == Enum.TouchMovementMode.ClickToMove then
            v41 = DynamicThumbstick;
        else
            v41 = u3[TouchMovementMode] or DynamicThumbstick;
        end;
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;

        if DevTouchMovementMode == Enum.DevTouchMovementMode.ClickToMove then
            v41 = DynamicThumbstick;
        else
            v41 = u3[DevTouchMovementMode] or DynamicThumbstick;
        end;
    end;

    return v41, true;
end;

local function getGamepadRightThumbstickPosition() -- Line: 448
    -- upvalues: UserInputService (copy)
    local GamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);

    for _, v in pairs(GamepadState) do
        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v.Position;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u1.calculateRawMoveVector(p42: table, p43: userdata, p44: vector) -- Line: 458
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return p44;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    if VRService.VREnabled and p43.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head);
        local EstimatedVRTorsoFrame = p42:GetEstimatedVRTorsoFrame();

        if (CurrentCamera.Focus.Position - CFrame2.Position).Magnitude < 3 then
            CFrame2 = CFrame2 * EstimatedVRTorsoFrame;
        else
            CFrame2 = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale);
        end;
    end;

    if p43:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v45, v46, v47, _, _, v48, _, _, v45 = CFrame2:GetComponents();

        if v48 >= 1 or v48 <= -1 then
            v47 = -v46 * math.sign(v48);
        end;

        local math_sqrt_ret = math.sqrt(v45 * v45 + v47 * v47);

        return Vector3.new((v45 * p44.X + v47 * p44.Z) / math_sqrt_ret, 0, (v45 * p44.Z - v47 * p44.X) / math_sqrt_ret);
    end;

    if not VRService.VREnabled then
        return CFrame2:VectorToWorldSpace(p44);
    end;

    local Vector3_new_ret = Vector3.new(p44.X, 0, p44.Z);

    if Vector3_new_ret.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;

    local v49 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636;
    local math_atan2_ret = math.atan2(-Vector3_new_ret.X, -Vector3_new_ret.Z);
    local _, v50, _ = CFrame2:ToEulerAnglesYXZ();

    return CFrame.fromEulerAnglesYXZ(v49, math_atan2_ret + v50, 0).LookVector;
end;

function u1.OnRenderStepped(p51, p52) -- Line: 517
    -- upvalues: ClickToMoveController (copy), Gamepad (copy), VRService (copy), Players (copy)
    if p51.activeController and (p51.activeController.enabled and p51.humanoid) then
        local MoveVector = p51.activeController:GetMoveVector();
        local v53 = p51.activeController:IsMoveVectorCameraRelative();
        local v54 = p51.controllers[ClickToMoveController];

        if p51.activeControlModule == ClickToMoveController then
            (v54 or p51:GetClickToMoveController()):OnRenderStepped(p52);
        elseif v54 then
            if MoveVector.magnitude > 0 then
                v54:CleanupPath();
            else
                v54:OnRenderStepped(p52);
                MoveVector = v54:GetMoveVector();
                v53 = v54:IsMoveVectorCameraRelative();
            end;
        end;

        if p51.vehicleController and p51.vehicleController.vehicleSeat then
            local v55;
            MoveVector, v55 = p51.vehicleController:Update(MoveVector, v53, p51.activeControlModule == Gamepad);
        end;

        if v53 and (VRService.VREnabled or MoveVector.Magnitude > 0) then
            MoveVector = p51:calculateRawMoveVector(p51.humanoid, MoveVector);
        end;

        p51.inputMoveVector = MoveVector;

        if VRService.VREnabled then
            MoveVector = p51:updateVRMoveVector(MoveVector);
        end;

        p51.moveFunction(Players.LocalPlayer, MoveVector, false);
    end;
end;

function u1.updateVRMoveVector(p56, p57) -- Line: 567
    -- upvalues: VRService (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if p57.Magnitude ~= 0 or ((workspace_CurrentCamera.Focus.Position - workspace_CurrentCamera.CFrame.Position).Magnitude >= 5 or not (VRService.AvatarGestures and (p56.humanoid and not p56.humanoid.Sit))) then
        return p57;
    end;

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v58 = (workspace_CurrentCamera.CFrame * (UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * p56.humanoid.RootPart.Size.Y / 2, 0)).Position - p56.humanoid.RootPart.CFrame.Position;

    return Vector3.new(v58.x, 0, v58.z);
end;

function u1.OnHumanoidSeated(p59: table, p60: boolean, p61: userdata) -- Line: 596
    -- upvalues: Value (copy)
    if p60 then
        if p61 and p61:IsA("VehicleSeat") then
            if not p59.vehicleController then
                p59.vehicleController = p59.vehicleController.new(Value);
            end;

            p59.vehicleController:Enable(true, p61);
        end;
    elseif p59.vehicleController then
        p59.vehicleController:Enable(false, p61);
    end;
end;

function u1.OnCharacterAdded(u62, p63) -- Line: 611
    -- upvalues: CharacterResolver (copy)
    u62.customCharacterMotor = nil;
    u62.character = p63;
    u62.humanoid = p63:FindFirstChildOfClass("Humanoid");

    if not u62.humanoid and CharacterResolver.resolve(p63) then
        u62.customCharacterMotor = {
            Sit = false,
            RootPart = CharacterResolver.getRootPart(p63),

            GetState = function() -- Line: 622, Name: GetState
                return Enum.HumanoidStateType.Running;
            end
        };
        u62.humanoid = u62.customCharacterMotor;
    end;

    u62:UpdateTouchGuiVisibility();

    if u62.humanoidSeatedConn then
        u62.humanoidSeatedConn:Disconnect();
        u62.humanoidSeatedConn = nil;
    end;

    if u62.humanoid and (u62.humanoid.Seated and u62.humanoid.Seated.Connect) then
        u62.humanoidSeatedConn = u62.humanoid.Seated:Connect(function(p64, p65) -- Line: 636
            -- upvalues: u62 (copy)
            u62:OnHumanoidSeated(p64, p65);
        end);
    end;
end;

function u1.OnCharacterRemoving(p66, p67) -- Line: 642
    if p66.character ~= p67 then
        return;
    end;

    p66.character = nil;
    p66.humanoid = nil;
    p66.customCharacterMotor = nil;
    p66:UpdateTouchGuiVisibility();
end;

function u1.UpdateTouchGuiVisibility(p68) -- Line: 654
    -- upvalues: GuiService (copy)
    if p68.touchGui then
        p68.touchGui.Enabled = p68.humanoid and GuiService.TouchControlsEnabled and true or false;
    end;
end;

function u1.SwitchToController(p69, p70) -- Line: 668
    -- upvalues: Value (copy)
    if not p70 then
        if p69.activeController then
            p69.activeController:Enable(false);
        end;

        p69.activeController = nil;
        p69.activeControlModule = nil;

        return;
    end;

    if not p69.controllers[p70] then
        p69.controllers[p70] = p70.new(Value);
    end;

    if p69.activeController == p69.controllers[p70] then
        if not p69.activeController.enabled then
            p69:UpdateActiveControlModuleEnabled();
        end;

        return;
    end;

    if p69.activeController then
        p69.activeController:Enable(false);
    end;

    p69.activeController = p69.controllers[p70];
    p69.activeControlModule = p70;
    p69:UpdateActiveControlModuleEnabled();
end;

function u1.OnLastInputTypeChanged(p71, p72) -- Line: 698
    -- upvalues: u5 (ref), u4 (copy)
    if u5 == p72 then
        warn("LastInputType Change listener called with current type.");
    end;

    u5 = p72;

    if u5 == Enum.UserInputType.Touch then
        local v73, v74 = p71:SelectTouchModule();

        if v74 then
            while not p71.touchControlFrame do
                wait();
            end;

            p71:SwitchToController(v73);
        end;
    elseif u4[u5] ~= nil then
        local v75 = p71:SelectComputerMovementModule();

        if v75 then
            p71:SwitchToController(v75);
        end;
    end;

    p71:UpdateTouchGuiVisibility();
end;

function u1.OnComputerMovementModeChange(p76) -- Line: 725
    local v77, v78 = p76:SelectComputerMovementModule();

    if v78 then
        p76:SwitchToController(v77);
    end;
end;

function u1.OnTouchMovementModeChange(p79) -- Line: 732
    local v80, v81 = p79:SelectTouchModule();

    if v81 then
        while not p79.touchControlFrame do
            wait();
        end;

        p79:SwitchToController(v80);
    end;
end;

function u1.CreateTouchGuiContainer(p82) -- Line: 742
    -- upvalues: u2 (ref)
    if p82.touchGui then
        p82.touchGui:Destroy();
    end;

    p82.touchGui = Instance.new("ScreenGui");
    p82.touchGui.Name = "TouchGui";
    p82.touchGui.ResetOnSpawn = false;
    p82.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    p82:UpdateTouchGuiVisibility();

    if u2 then
        p82.touchGui.ClipToDeviceSafeArea = false;
    end;

    p82.touchControlFrame = Instance.new("Frame");
    p82.touchControlFrame.Name = "TouchControlFrame";
    p82.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p82.touchControlFrame.BackgroundTransparency = 1;
    p82.touchControlFrame.Parent = p82.touchGui;
    p82.touchGui.Parent = p82.playerGui;
end;

function u1.GetClickToMoveController(p83) -- Line: 767
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not p83.controllers[ClickToMoveController] then
        p83.controllers[ClickToMoveController] = ClickToMoveController.new(Value);
    end;

    return p83.controllers[ClickToMoveController];
end;

return u1.new();