-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule
-- Decompile time: 9.96 ms

local u0 = {}
u0.__index = u0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
script.Parent:WaitForChild("CommonUtils")
local Keyboard = require(script:WaitForChild("Keyboard"))
local Gamepad = require(script:WaitForChild("Gamepad"))
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))
local success, result = pcall(function() -- Line: 39
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local u79 = success and result
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"))
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local VehicleController = require(script:WaitForChild("VehicleController"))
local Value = Enum.ContextActionPriority.Medium.Value
local u110 = {
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
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController,
}
local u127 = {
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
    [Enum.UserInputType.Gamepad8] = Gamepad,
}
local u142 = nil

function u0.new() -- Line: 104
    -- upvalues: u0 (val), Players (val), VehicleController (val), Value (val), CharacterResolver (val)
    -- upvalues: RunService (val), UserInputService (val), UserGameSettings (val), GuiService (val)
    local u3 = setmetatable({}, u0)
    u3.controllers = {}
    u3.activeControlModule = nil
    u3.activeController = nil
    u3.touchJumpController = nil
    u3.moveFunction = Players.LocalPlayer.Move
    u3.character = nil
    u3.humanoid = nil
    u3.customCharacterMotor = nil
    u3.lastInputType = Enum.UserInputType.None
    u3.controlsEnabled = true
    u3.humanoidSeatedConn = nil
    u3.vehicleController = nil
    u3.touchControlFrame = nil
    u3.currentTorsoAngle = 0
    u3.inputMoveVector = Vector3.new(0, 0, 0)
    u3.vehicleController = VehicleController.new(Value)
    u3.presentedCharacterDisconnect = CharacterResolver.observeCharacter(Players.LocalPlayer, function(a1, a2) -- Line: 134 -- upvalues: u3 (val)
        if a2 and a2 ~= a1 then
            u3:OnCharacterRemoving(a2)
        end
        if a1 then
            u3:OnCharacterAdded(a1)
        end
        return function() end
    end)
    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(a1) -- Line: 145 -- upvalues: u3 (val)
        u3:OnRenderStepped(a1)
    end)
    UserInputService.LastInputTypeChanged:Connect(function(a1) -- Line: 149 -- upvalues: u3 (val)
        u3:OnLastInputTypeChanged(a1)
    end)
    ;(UserGameSettings:GetPropertyChangedSignal("TouchMovementMode")):Connect(function() -- Line: 153 -- upvalues: u3 (val)
        u3:OnTouchMovementModeChange()
    end)
    ;(Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode")):Connect(function() -- Line: 156 -- upvalues: u3 (val)
        u3:OnTouchMovementModeChange()
    end)
    ;(UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode")):Connect(function() -- Line: 160 -- upvalues: u3 (val)
        u3:OnComputerMovementModeChange()
    end)
    ;(Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")):Connect(function() -- Line: 163 -- upvalues: u3 (val)
        u3:OnComputerMovementModeChange()
    end)
    u3.playerGui = nil
    u3.touchGui = nil
    u3.playerGuiAddedConn = nil
    ;(GuiService:GetPropertyChangedSignal("TouchControlsEnabled")):Connect(function() -- Line: 173 -- upvalues: u3 (val)
        u3:UpdateTouchGuiVisibility()
        u3:UpdateActiveControlModuleEnabled()
    end)
    if not UserInputService.TouchEnabled then
        u3:OnLastInputTypeChanged((UserInputService:GetLastInputType()))
        return u3
    end
    u3.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not u3.playerGui then
        u3.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(a1) -- Line: 184 -- upvalues: u3 (val), UserInputService (upval)
            if a1:IsA("PlayerGui") then
                u3.playerGui = a1
                u3:CreateTouchGuiContainer()
                u3.playerGuiAddedConn:Disconnect()
                u3.playerGuiAddedConn = nil
                u3:OnLastInputTypeChanged((UserInputService:GetLastInputType()))
            end
        end)
        return u3
    end
    u3:CreateTouchGuiContainer()
    u3:OnLastInputTypeChanged((UserInputService:GetLastInputType()))
    return u3
end

function u0:GetMoveVector() -- Line: 204
    if self.activeController then
        return self.activeController:GetMoveVector()
    end
    return (Vector3.new(0, 0, 0))
end

local function NormalizeAngle(a1) -- Line: 211
    local v1 = (a1 + 12.566370614359172) % 6.283185307179586
    if v1 > 3.141592653589793 then
        v1 = v1 - 6.283185307179586
    end
    return v1
end

local function AverageAngle(a1, a2) -- Line: 219
    local v1 = (a2 - a1 + 12.566370614359172) % 6.283185307179586
    if v1 > 3.141592653589793 then
        v1 = v1 - 6.283185307179586
    end
    local v2 = (a1 + v1 / 2 + 12.566370614359172) % 6.283185307179586
    if v2 > 3.141592653589793 then
        v2 = v2 - 6.283185307179586
    end
    return v2
end

function u0:GetEstimatedVRTorsoFrame() -- Line: 224 -- upvalues: VRService (val)
    local v1
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    _, v1 = UserCFrame:ToEulerAnglesYXZ()
    v1 = -v1
    if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        self.currentTorsoAngle = v1
    elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local UserCFrame_2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
        local UserCFrame_3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
        local v2 = UserCFrame.Position - UserCFrame_2.Position
        local v3 = UserCFrame.Position - UserCFrame_3.Position
        local v4 = -math.atan2(v2.X, v2.Z)
        local v5 = (-math.atan2(v3.X, v3.Z) - v4 + 12.566370614359172) % 6.283185307179586
        if v5 > 3.141592653589793 then
            v5 = v5 - 6.283185307179586
        end
        local v6 = (v4 + v5 / 2 + 12.566370614359172) % 6.283185307179586
        if v6 > 3.141592653589793 then
            v6 = v6 - 6.283185307179586
        end
        v5 = (v1 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586
        if v5 > 3.141592653589793 then
            v5 = v5 - 6.283185307179586
        end
        local v7 = (v6 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586
        if v7 > 3.141592653589793 then
            v7 = v7 - 6.283185307179586
        end
        local v8 = false
        if v7 > -1.5707963267948966 then
            v8 = v7 < 1.5707963267948966
        end
        if not v8 then
            v7 = v5
        end
        local v9 = math.min(v7, v5)
        local v10 = math.max(v7, v5)
        local v11 = 0
        if v9 > 0 then
            v11 = v9
        elseif v10 < 0 then
            v11 = v10
        end
        self.currentTorsoAngle = v11 + self.currentTorsoAngle
    else
        self.currentTorsoAngle = v1
    end
    return (CFrame.new(UserCFrame.Position)) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function u0.GetActiveController(a1) -- Line: 269
    return a1.activeController
end

function u0:UpdateActiveControlModuleEnabled() -- Line: 274
    -- upvalues: Players (val), ClickToMoveController (val), TouchThumbstick (val), DynamicThumbstick (val)
    -- upvalues: TouchJump (val), GuiService (val), UserInputService (val)
    local function v1() -- Line: 276 -- upvalues: self (val), Players (upval)
        self.activeController:Enable(false)
        if self.touchJumpController then
            self.touchJumpController:Enable(false)
        end
        if self.moveFunction then
            self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    local function v2() -- Line: 287
        -- upvalues: self (val), ClickToMoveController (upval), TouchThumbstick (upval), DynamicThumbstick (upval)
        -- upvalues: TouchJump (upval), Players (upval)
        if not self.touchControlFrame then
            if self.touchJumpController then
                self.touchJumpController:Enable(false)
            end
        elseif self.activeControlModule == ClickToMoveController
            or self.activeControlModule == TouchThumbstick
            or self.activeControlModule == DynamicThumbstick then
            if not self.controllers[TouchJump] then
                self.controllers[TouchJump] = (TouchJump.new())
            end
            self.touchJumpController = self.controllers[TouchJump]
            self.touchJumpController:Enable(true, self.touchControlFrame)
        elseif self.touchJumpController then
            self.touchJumpController:Enable(false)
        end
        if self.activeControlModule == ClickToMoveController then
            self.activeController:Enable(
                true,
                Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
                self.touchJumpController
            )
            return
        end
        if self.touchControlFrame then
            self.activeController:Enable(true, self.touchControlFrame)
            return
        end
        self.activeController:Enable(true)
    end

    if not self.activeController then
        return
    end
    if not self.controlsEnabled then
        self.activeController:Enable(false)
        if self.touchJumpController then
            self.touchJumpController:Enable(false)
        end
        if self.moveFunction then
            self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
        return
    end
    if not GuiService.TouchControlsEnabled and UserInputService.TouchEnabled then
        if self.activeControlModule ~= ClickToMoveController
            and self.activeControlModule ~= TouchThumbstick
            and self.activeControlModule ~= DynamicThumbstick then
            v2()
            return
        end
        self.activeController:Enable(false)
        if self.touchJumpController then
            self.touchJumpController:Enable(false)
        end
        if self.moveFunction then
            self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
        return
    end
    v2()
end

function u0:Enable(a2) -- Line: 352 -- types: self: table, a2: boolean?
    if a2 == nil then
        a2 = true
    end
    if self.controlsEnabled == a2 then
        return
    end
    self.controlsEnabled = a2
    if not self.activeController then
        return
    end
    self:UpdateActiveControlModuleEnabled()
end

function u0.Disable(a1) -- Line: 369
    a1:Enable(false)
end

function u0.SelectComputerMovementModule(a1) -- Line: 374
    -- upvalues: UserInputService (val), Players (val), u127 (val), u142 (ref), UserGameSettings (val), Keyboard (val)
    -- upvalues: ClickToMoveController (val), u110 (val)
    local v1
    if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
        return nil, false
    end
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode
    if DevComputerMovementMode ~= Enum.DevComputerMovementMode.UserChoice then
        v1 = u110[DevComputerMovementMode]
        if not v1 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode)
        end
    else
        v1 = u127[u142]
        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v1 == Keyboard then
            v1 = ClickToMoveController
        end
    end
    if v1 then
        return v1, true
    end
    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end
    return nil, false
end

function u0.SelectTouchModule(a1) -- Line: 415
    -- upvalues: UserInputService (val), Players (val), UserGameSettings (val), DynamicThumbstick (val), u110 (val)
    if not UserInputService.TouchEnabled then
        return nil, false
    end
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        local TouchMovementMode = UserGameSettings.TouchMovementMode
        return TouchMovementMode ~= Enum.TouchMovementMode.ClickToMove and u110[TouchMovementMode] or DynamicThumbstick, true
    end
    if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
        return nil, true
    end
    return DevTouchMovementMode ~= Enum.DevTouchMovementMode.ClickToMove and u110[DevTouchMovementMode] or DynamicThumbstick, true
end

local function getGamepadRightThumbstickPosition() -- Line: 448 -- upvalues: UserInputService (val)
    for k, v in pairs((UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1))) do
        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v.Position
        end
    end
    return (Vector3.new(0, 0, 0))
end

function u0:calculateRawMoveVector(a2, a3) -- Line: 458
    -- upvalues: Workspace (val), VRService (val), getGamepadRightThumbstickPosition (val)
    local Components_10, Components_11, Components_2, Components_5, Components_9, v1, v2
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return a3
    end
    local CFrame_2 = CurrentCamera.CFrame
    if VRService.VREnabled and a2.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head)
        v1 = self:GetEstimatedVRTorsoFrame()
        CFrame_2 = if not ((CurrentCamera.Focus.Position - CFrame_2.Position).Magnitude < 3) then CurrentCamera.CFrame * (v1.Rotation + v1.Position * CurrentCamera.HeadScale) else CFrame_2 * v1
    end
    if (a2:GetState()) == Enum.HumanoidStateType.Swimming then
        local v3
        if not VRService.VREnabled then
            return CFrame_2:VectorToWorldSpace(a3)
        end
        local v4 = Vector3.new(a3.X, 0, a3.Z)
        if v4.Magnitude < 0.01 then
            return (Vector3.new(0, 0, 0))
        end
        v1 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
        v2 = math.atan2(-v4.X, -v4.Z)
        _, v3 = CFrame_2:ToEulerAnglesYXZ()
        v2 = v2 + v3
        return CFrame.fromEulerAnglesYXZ(v1, v2, 0).LookVector
    end
    _, _, _, Components_9, Components_10, Components_11, _, _, Components_2, _, _, Components_5 = CFrame_2:GetComponents()
    if not (Components_2 < 1) or not (Components_2 > -1) then
        v1 = Components_9
        v2 = -Components_10 * math.sign(Components_2)
    else
        v1 = Components_5
        v2 = Components_11
    end
    local v5 = math.sqrt(v1 * v1 + v2 * v2)
    return (Vector3.new((v1 * a3.X + v2 * a3.Z) / v5, 0, (v1 * a3.Z - v2 * a3.X) / v5))
end

function u0:OnRenderStepped(a2) -- Line: 517
    -- upvalues: ClickToMoveController (val), Gamepad (val), VRService (val), Players (val)
    if self.activeController and self.activeController.enabled and self.humanoid then
        local MoveVector = self.activeController:GetMoveVector()
        local v1 = self.activeController:IsMoveVectorCameraRelative()
        local v2 = self.controllers[ClickToMoveController]
        if self.activeControlModule == ClickToMoveController then
            (v2 or self:GetClickToMoveController()):OnRenderStepped(a2)
        elseif v2 then
            if not (0 < MoveVector.magnitude) then
                v2:OnRenderStepped(a2)
                MoveVector = v2:GetMoveVector()
                v1 = v2:IsMoveVectorCameraRelative()
            else
                v2:CleanupPath()
            end
        end
        if self.vehicleController and self.vehicleController.vehicleSeat then
            local v3, v4 = self.vehicleController:Update(MoveVector, v1, self.activeControlModule == Gamepad)
            MoveVector = v3
        end
        if v1 then
            if VRService.VREnabled or 0 < MoveVector.Magnitude then
                MoveVector = self:calculateRawMoveVector(self.humanoid, MoveVector)
            end
        end
        self.inputMoveVector = MoveVector
        if VRService.VREnabled then
            MoveVector = self:updateVRMoveVector(MoveVector)
        end
        self.moveFunction(Players.LocalPlayer, MoveVector, false)
    end
end

function u0:updateVRMoveVector(a2) -- Line: 567 -- upvalues: VRService (val)
    local CurrentCamera = workspace.CurrentCamera
    local v1 = CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position
    local v2 = false
    if v1.Magnitude < 5 then
        v2 = true
    end
    if a2.Magnitude == 0 and v2 and VRService.AvatarGestures and self.humanoid and not self.humanoid.Sit then
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local v3 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
        local v4 = -0.7 * self.humanoid.RootPart.Size.Y / 2
        local v5 = (CurrentCamera.CFrame * v3 * CFrame.new(0, v4, 0)).Position - self.humanoid.RootPart.CFrame.Position
        return (Vector3.new(v5.x, 0, v5.z))
    end
    return a2
end

function u0:OnHumanoidSeated(a2, a3) -- Line: 596
    -- upvalues: Value (val)
    if not a2 then
        if self.vehicleController then
            self.vehicleController:Enable(false, a3)
        end
        return
    end
    if a3 and a3:IsA("VehicleSeat") then
        if not self.vehicleController then
            self.vehicleController = self.vehicleController.new(Value)
        end
        self.vehicleController:Enable(true, a3)
        return
    end
end

function u0:OnCharacterAdded(a2) -- Line: 611 -- upvalues: CharacterResolver (val)
    self.customCharacterMotor = nil
    self.character = a2
    self.humanoid = a2:FindFirstChildOfClass("Humanoid")
    if not self.humanoid and CharacterResolver.resolve(a2) then
        self.customCharacterMotor = {
            Sit = false,
            RootPart = CharacterResolver.getRootPart(a2),
            GetState = function() -- Line: 622
                return Enum.HumanoidStateType.Running
            end,
        }
        self.humanoid = self.customCharacterMotor
    end
    self:UpdateTouchGuiVisibility()
    if self.humanoidSeatedConn then
        self.humanoidSeatedConn:Disconnect()
        self.humanoidSeatedConn = nil
    end
    if self.humanoid and self.humanoid.Seated and self.humanoid.Seated.Connect then
        self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(a1, a2) -- Line: 636 -- upvalues: self (val)
            self:OnHumanoidSeated(a1, a2)
        end)
    end
end

function u0:OnCharacterRemoving(a2) -- Line: 642
    if self.character ~= a2 then
        return
    end
    self.character = nil
    self.humanoid = nil
    self.customCharacterMotor = nil
    self:UpdateTouchGuiVisibility()
end

function u0:UpdateTouchGuiVisibility() -- Line: 654 -- upvalues: GuiService (val)
    if self.touchGui then
        local humanoid = self.humanoid and GuiService.TouchControlsEnabled
        self.touchGui.Enabled = not not humanoid
    end
end

function u0:SwitchToController(a2) -- Line: 668 -- upvalues: Value (val)
    if not a2 then
        if self.activeController then
            self.activeController:Enable(false)
        end
        self.activeController = nil
        self.activeControlModule = nil
        return
    end
    if not self.controllers[a2] then
        self.controllers[a2] = (a2.new(Value))
    end
    if self.activeController == self.controllers[a2] then
        if not self.activeController.enabled then
            self:UpdateActiveControlModuleEnabled()
        end
        return
    end
    if self.activeController then
        self.activeController:Enable(false)
    end
    self.activeController = self.controllers[a2]
    self.activeControlModule = a2
    self:UpdateActiveControlModuleEnabled()
end

function u0:OnLastInputTypeChanged(a2) -- Line: 698 -- upvalues: u142 (ref), u127 (val)
    local v1
    if u142 == a2 then
        warn("LastInputType Change listener called with current type.")
    end
    u142 = a2
    if u142 == Enum.UserInputType.Touch then
        local v2
        v1, v2 = self:SelectTouchModule()
        if v2 then
            while not self.touchControlFrame do
                wait()
            end
            self:SwitchToController(v1)
        end
    elseif u127[u142] ~= nil then
        v1 = self:SelectComputerMovementModule()
        if v1 then
            self:SwitchToController(v1)
        end
    end
    self:UpdateTouchGuiVisibility()
end

function u0:OnComputerMovementModeChange() -- Line: 725
    local v1, v2 = self:SelectComputerMovementModule()
    if v2 then
        self:SwitchToController(v1)
    end
end

function u0:OnTouchMovementModeChange() -- Line: 732
    local v1, v2 = self:SelectTouchModule()
    if v2 then
        while not self.touchControlFrame do
            wait()
        end
        self:SwitchToController(v1)
    end
end

function u0:CreateTouchGuiContainer() -- Line: 742 -- upvalues: u79 (ref)
    if self.touchGui then
        self.touchGui:Destroy()
    end
    self.touchGui = Instance.new("ScreenGui")
    self.touchGui.Name = "TouchGui"
    self.touchGui.ResetOnSpawn = false
    self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self:UpdateTouchGuiVisibility()
    if u79 then
        self.touchGui.ClipToDeviceSafeArea = false
    end
    self.touchControlFrame = Instance.new("Frame")
    self.touchControlFrame.Name = "TouchControlFrame"
    self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    self.touchControlFrame.BackgroundTransparency = 1
    self.touchControlFrame.Parent = self.touchGui
    self.touchGui.Parent = self.playerGui
end

function u0:GetClickToMoveController() -- Line: 767 -- upvalues: ClickToMoveController (val), Value (val)
    if not self.controllers[ClickToMoveController] then
        self.controllers[ClickToMoveController] = (ClickToMoveController.new(Value))
    end
    return self.controllers[ClickToMoveController]
end

return (u0.new())