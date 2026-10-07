-- ReplicatedStorage.Classes.Freecam
-- Script path: ReplicatedStorage.Classes.Freecam
-- Decompile time: 7.68 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CurrentCamera = workspace.CurrentCamera
local u50 = Vector2.new(9.42477796076938, 5.497787143782138)
local u54 = Vector2.new(4.71238898038469, 2.748893571891069)
local u58 = Vector2.new(0.4, 0.3333333333333333)
local u62 = Vector2.new(3.839724354387525, 2.6179938779914944)

local function IsInMoveRegion(a1) -- Line: 54 -- upvalues: CurrentCamera (val), u58 (val) -- types: a1: vector
    local ViewportSize = CurrentCamera.ViewportSize
    if ViewportSize.X < ViewportSize.Y then
        local Y = a1.Y
        return ViewportSize.Y * 0.6 <= Y
    end
    local v1 = false
    if a1.X <= ViewportSize.X * u58.X then
        local Y_2 = a1.Y
        v1 = ViewportSize.Y * u58.Y <= Y_2
    end
    return v1
end

local function ResolveTouchMoveVector(a1, a2) -- Line: 68
    -- upvalues: CurrentCamera (val)
    local ViewportSize = CurrentCamera.ViewportSize
    local v1 = if not (500 < (math.min(ViewportSize.X, ViewportSize.Y))) then 1 else 2
    local v2 = Vector2.new(a2.X - a1.X, a2.Y - a1.Y)
    local Magnitude = v2.Magnitude
    if Magnitude < v1 * 2 then
        return (Vector3.new(0, 0, 0))
    end
    local v3 = v2.Unit * math.min(Magnitude / (v1 * 20), 1)
    return (Vector3.new(v3.X, 0, v3.Y))
end

local function IsGamepadInput(a1) -- Line: 85 -- types: a1: userdata
    return string.sub(a1.UserInputType.Name, 1, 7) == "Gamepad"
end

local function ApplyDeadZone(a1) -- Line: 92 -- types: a1: userdata
    local Magnitude = a1.Magnitude
    if Magnitude <= 0.15 then
        return Vector2.zero
    end
    return a1.Unit * math.min((Magnitude - 0.15) / 0.85, 1)
end

local function IsGamepadClaimedByUi() -- Line: 104 -- upvalues: GuiService (val)
    local MenuIsOpen = true
    if GuiService.SelectedObject == nil then
        MenuIsOpen = GuiService.MenuIsOpen
    end
    return MenuIsOpen
end

local function GetTouchControlsGui() -- Line: 110 -- upvalues: UserInputService (val), LocalPlayer (val)
    if not UserInputService.TouchEnabled then
        return nil
    end
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not PlayerGui then
        return nil
    end
    return (PlayerGui:FindFirstChild("TouchGui"))
end

local function GetReplicationFocus() -- Line: 125
    local Map = workspace:FindFirstChild("Map")
    local ReplicationFocus = Map and Map:FindFirstChild("ReplicationFocus")
    return ReplicationFocus and ReplicationFocus:FindFirstChild("Focus")
end

local function RemoveJanitorEntry(a1, a2) -- Line: 133 -- types: a2: string
    if a1:Get(a2) then
        a1:Remove(a2)
    end
end

function u0:UpdateMovement(a2) -- Line: 142 -- upvalues: InputController (val), GuiService (val) -- types: a2: number
    local Unit = Vector3.new(0, 0, 0)
    if InputController.isActionActive("Move Forward") then
        Unit = Unit + Vector3.new(0, 0, -1)
    end
    if InputController.isActionActive("Move Backward") then
        Unit = Unit + Vector3.new(0, 0, 1)
    end
    if InputController.isActionActive("Move Left (Strafe)") then
        Unit = Unit + Vector3.new(-1, 0, 0)
    end
    if InputController.isActionActive("Move Right (Strafe)") then
        Unit = Unit + Vector3.new(1, 0, 0)
    end
    local v1 = 40 * (if not InputController.isActionActive("Walk") then 1 else 0.2)
    if Unit ~= Vector3.new(0, 0, 0) then
        Unit = Unit.Unit
    end
    local Unit_3 = Unit + self.TouchMoveVector
    local MenuIsOpen = true
    if GuiService.SelectedObject == nil then
        MenuIsOpen = GuiService.MenuIsOpen
    end
    if not MenuIsOpen then
        local GamepadMove = self.GamepadMove
        local Magnitude = GamepadMove.Magnitude
        local zero = if not (Magnitude <= 0.15) then GamepadMove.Unit * math.min((Magnitude - 0.15) / 0.85, 1) else Vector2.zero
        Unit_3 = Unit_3 + Vector3.new(zero.X, self.GamepadRise - self.GamepadFall, -zero.Y)
    end
    if 1 < Unit_3.Magnitude then
        Unit_3 = Unit_3.Unit
    end
    local CameraCFrame = self.CameraCFrame
    local LookVector = CameraCFrame.LookVector
    local v2 = self.CameraCFrame.Position + (CameraCFrame.RightVector * Unit_3.X + Vector3.new(0, 1, 0) * Unit_3.Y + LookVector * -Unit_3.Z) * (v1 * a2)
    self.CameraCFrame = CFrame.new(v2, v2 + LookVector)
    self:UpdateMouseWheel(a2)
end

function u0:UpdateMouseWheel(a2) -- Line: 190 -- upvalues: InputController (val) -- types: a2: number
    local MouseWheelDelta = self.MouseWheelDelta
    if MouseWheelDelta == 0 then
        return
    end
    local CameraCFrame = self.CameraCFrame
    local LookVector = CameraCFrame.LookVector
    local v1 = 15 * (if not InputController.isActionActive("Walk") then 1 else 0.5)
    local v2 = CameraCFrame.Position + LookVector * (MouseWheelDelta > 0 and v1 or -v1)
    self.CameraCFrame = CFrame.new(v2, v2 + LookVector)
    self.MouseWheelDelta = 0
end

function u0:UpdateRotation(a2) -- Line: 208
    -- upvalues: UserInputService (val), InputController (val), CurrentCamera (val), u50 (val), u54 (val)
    -- upvalues: GuiService (val), u62 (val)
    local zero_2
    local v1 = true
    if self.MoveTouch == nil then
        v1 = self.LookTouch ~= nil
    end
    local zero = if not v1 then UserInputService:GetMouseDelta() else Vector2.zero
    local v2 = if not InputController.isActionActive("Walk") then 1 else 0.5
    local ViewportSize = CurrentCamera.ViewportSize
    local v3 = zero.X / ViewportSize.X * (u50.X * v2)
    local v4 = zero.Y / ViewportSize.Y * (u50.Y * v2)
    local TouchLookDelta = self.TouchLookDelta
    if TouchLookDelta ~= Vector2.zero then
        self.TouchLookDelta = Vector2.zero
        v3 = v3 + TouchLookDelta.X / ViewportSize.X * (u54.X * v2)
        v4 = v4 + TouchLookDelta.Y / ViewportSize.Y * (u54.Y * v2)
    end
    local MenuIsOpen = true
    if GuiService.SelectedObject == nil then
        MenuIsOpen = GuiService.MenuIsOpen
    end
    if not MenuIsOpen then
        local GamepadLook = self.GamepadLook
        local Magnitude = GamepadLook.Magnitude
        zero_2 = if not (Magnitude <= 0.15) then GamepadLook.Unit * math.min((Magnitude - 0.15) / 0.85, 1) else Vector2.zero
    else
        zero_2 = Vector2.zero
    end
    if zero_2 ~= Vector2.zero then
        local v5 = zero_2.Unit * zero_2.Magnitude ^ 2
        v3 = v3 + v5.X * u62.X * v2 * a2
        v4 = v4 - v5.Y * u62.Y * v2 * a2
    end
    local CameraCFrame = self.CameraCFrame
    local Position = CameraCFrame.Position
    local LookVector = CameraCFrame.LookVector
    local v6 = math.clamp(math.asin(LookVector.Y) - v4, -1.3962634015954636, 1.3962634015954636)
    local v7 = Vector3.new(LookVector.X, 0, LookVector.Z)
    local Magnitude_2 = v7.Magnitude
    v7 = if not (Magnitude_2 < 0.001) then v7 / Magnitude_2 else Vector3.new(0, 0, -1)
    local v8 = math.atan2(-v7.X, -v7.Z) - v3
    local v9 = math.cos(v6)
    self.CameraCFrame = CFrame.new(Position, Position + (Vector3.new(-math.sin(v8) * v9, math.sin(v6), -(math.cos(v8)) * v9)))
end

function u0:ReleaseEndedTouches() -- Line: 264
    local MoveTouch = self.MoveTouch
    if MoveTouch and MoveTouch.UserInputState == Enum.UserInputState.End then
        self.MoveTouch = nil
        self.TouchMoveVector = Vector3.new(0, 0, 0)
    end
    local LookTouch = self.LookTouch
    if LookTouch and LookTouch.UserInputState == Enum.UserInputState.End then
        self.LookTouch = nil
    end
end

function u0:ResetTouchInput() -- Line: 280
    self.TouchLookDelta = Vector2.zero
    self.TouchMoveVector = Vector3.new(0, 0, 0)
    self.MoveTouch = nil
    self.MoveTouchStartPosition = Vector3.new(0, 0, 0)
    self.LookTouch = nil
end

function u0:ResetGamepadInput() -- Line: 291
    self.GamepadMove = Vector2.zero
    self.GamepadLook = Vector2.zero
    self.GamepadRise = 0
    self.GamepadFall = 0
end

function u0:ShowTouchControls() -- Line: 300 -- upvalues: UserInputService (val), LocalPlayer (val), GuiService (val)
    local u14
    if UserInputService.TouchEnabled then
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        u14 = if PlayerGui then PlayerGui:FindFirstChild("TouchGui") else nil
    else
        u14 = nil
    end
    if not u14 then
        return
    end

    local function applyVisibility() -- Line: 306 -- upvalues: u14 (val), self (val), GuiService (upval)
        local IsActive = self.IsActive and GuiService.TouchControlsEnabled
        u14.Enabled = IsActive
    end

    local IsActive = self.IsActive and GuiService.TouchControlsEnabled
    u14.Enabled = IsActive
    self.Janitor:Add((u14:GetPropertyChangedSignal("Enabled")):Connect(applyVisibility), "Disconnect", "TouchControlsEnabledGuard")
    self.Janitor:Add(
        (GuiService:GetPropertyChangedSignal("TouchControlsEnabled")):Connect(applyVisibility),
        "Disconnect",
        "TouchControlsSettingGuard"
    )
    self.Janitor:Add(function() -- Line: 326 -- upvalues: u14 (val), LocalPlayer (upval), GuiService (upval)
        local TouchControlsEnabled = false
        if LocalPlayer.Character ~= nil then
            TouchControlsEnabled = GuiService.TouchControlsEnabled
        end
        u14.Enabled = TouchControlsEnabled
    end, true, "RestoreTouchControls")
end

function u0:Render(a2) -- Line: 333 -- upvalues: CurrentCamera (val) -- types: a2: number
    self:ReleaseEndedTouches()
    self:UpdateMovement(a2)
    self:UpdateRotation(a2)
    CurrentCamera.CFrame = self.CameraCFrame
end

function u0.Start(a1) -- Line: 342
    -- upvalues: CurrentCamera (val), CameraController (val), UserInputService (val), RunServiceController (val)
    -- upvalues: LocalPlayer (val)
    if a1.IsActive then
        return
    end
    a1.IsActive = true
    a1.CameraCFrame = CurrentCamera.CFrame
    a1.MouseWheelDelta = 0
    a1:ResetTouchInput()
    a1:ResetGamepadInput()
    a1:ShowTouchControls()
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CameraController.setMouseEnabled(false)
    a1.Janitor:Add((UserInputService:GetPropertyChangedSignal("MouseBehavior")):Connect(function() -- Line: 359 -- upvalues: a1 (val), UserInputService (upval)
        if a1.IsActive and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end), "Disconnect", "EnforceMouseBehavior")
    RunServiceController.BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value + 10, function(a1_2) -- Line: 365 -- upvalues: a1 (val) -- types: a1_2: number
        if a1.IsActive then
            a1:Render(a1_2)
        end
    end)
    local Map = workspace:FindFirstChild("Map")
    local ReplicationFocus = Map and Map:FindFirstChild("ReplicationFocus")
    local v1 = ReplicationFocus and ReplicationFocus:FindFirstChild("Focus")
    if v1 then
        LocalPlayer.ReplicationFocus = v1
        a1.Janitor:Add(function() -- Line: 374 -- upvalues: LocalPlayer (upval)
            LocalPlayer.ReplicationFocus = nil
        end, true, "ReplicationFocus")
    end
    a1.Janitor:Add(function() -- Line: 379 -- upvalues: RunServiceController (upval)
        RunServiceController.UnbindFromRenderStep("Freecam")
    end, true)
end

function u0:Stop() -- Line: 386 -- upvalues: RunServiceController (val), CurrentCamera (val)
    if not self.IsActive then
        return
    end
    self.IsActive = false
    RunServiceController.UnbindFromRenderStep("Freecam")
    self:ResetTouchInput()
    self:ResetGamepadInput()
    local Janitor = self.Janitor
    if Janitor:Get("TouchControlsEnabledGuard") then
        Janitor:Remove("TouchControlsEnabledGuard")
    end
    local Janitor_2 = self.Janitor
    if Janitor_2:Get("TouchControlsSettingGuard") then
        Janitor_2:Remove("TouchControlsSettingGuard")
    end
    local Janitor_3 = self.Janitor
    if Janitor_3:Get("RestoreTouchControls") then
        Janitor_3:Remove("RestoreTouchControls")
    end
    CurrentCamera.CameraType = Enum.CameraType.Custom
    local Janitor_4 = self.Janitor
    if Janitor_4:Get("EnforceMouseBehavior") then
        Janitor_4:Remove("EnforceMouseBehavior")
    end
    local Janitor_5 = self.Janitor
    if Janitor_5:Get("ReplicationFocus") then
        Janitor_5:Remove("ReplicationFocus")
    end
end

function u0.new() -- Line: 413
    -- upvalues: u0 (val), Janitor (val), UserInputService (val), CurrentCamera (val), u58 (val)
    -- upvalues: ResolveTouchMoveVector (val)
    local u3 = setmetatable({}, u0)
    u3.Janitor = Janitor.new()
    u3.CameraCFrame = CFrame.identity
    u3.MouseWheelDelta = 0
    u3.TouchLookDelta = Vector2.zero
    u3.TouchMoveVector = Vector3.new(0, 0, 0)
    u3.MoveTouchStartPosition = Vector3.new(0, 0, 0)
    u3.GamepadMove = Vector2.zero
    u3.GamepadLook = Vector2.zero
    u3.GamepadRise = 0
    u3.GamepadFall = 0
    u3.IsActive = false
    u3.Janitor:Add(UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 428 -- upvalues: u3 (val), CurrentCamera (upval), u58 (upval)
        if u3.IsActive and a1.UserInputType == Enum.UserInputType.Touch and not a2 then
            if not u3.MoveTouch then
                local v1
                local Position = a1.Position
                local ViewportSize = CurrentCamera.ViewportSize
                if not (ViewportSize.X < ViewportSize.Y) then
                    v1 = false
                    if Position.X <= ViewportSize.X * u58.X then
                        local Y_2 = Position.Y
                        v1 = ViewportSize.Y * u58.Y <= Y_2
                    end
                else
                    local Y = Position.Y
                    v1 = ViewportSize.Y * 0.6 <= Y
                end
                if v1 then
                    u3.MoveTouch = a1
                    u3.MoveTouchStartPosition = a1.Position
                    u3.TouchMoveVector = Vector3.new(0, 0, 0)
                    return
                end
            end
            if not u3.LookTouch then
                u3.LookTouch = a1
            end
            return
        end
    end), "Disconnect")
    u3.Janitor:Add(UserInputService.InputChanged:Connect(function(a1, a2) -- Line: 444 -- upvalues: u3 (val), ResolveTouchMoveVector (upval)
        if not u3.IsActive then
            return
        end
        if not (string.sub(a1.UserInputType.Name, 1, 7) == "Gamepad") then
            if a1.UserInputType == Enum.UserInputType.MouseWheel then
                if not a2 then
                    u3.MouseWheelDelta = a1.Position.Z
                end
                return
            end
            if a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if a1 == u3.MoveTouch then
                u3.TouchMoveVector = ResolveTouchMoveVector(u3.MoveTouchStartPosition, a1.Position)
                return
            end
            if a1 == u3.LookTouch then
                u3.TouchLookDelta = u3.TouchLookDelta + Vector2.new(a1.Delta.X, a1.Delta.Y)
            end
            return
        end
        local KeyCode = a1.KeyCode
        if KeyCode == Enum.KeyCode.Thumbstick1 then
            u3.GamepadMove = Vector2.new(a1.Position.X, a1.Position.Y)
            return
        end
        if KeyCode == Enum.KeyCode.Thumbstick2 then
            u3.GamepadLook = Vector2.new(a1.Position.X, a1.Position.Y)
            return
        end
        if KeyCode == Enum.KeyCode.ButtonR2 then
            u3.GamepadRise = a1.Position.Z
            return
        end
        if KeyCode == Enum.KeyCode.ButtonL2 then
            u3.GamepadFall = a1.Position.Z
        end
    end), "Disconnect")
    u3.Janitor:Add(UserInputService.InputEnded:Connect(function(a1) -- Line: 487 -- upvalues: u3 (val)
        if not (string.sub(a1.UserInputType.Name, 1, 7) == "Gamepad") then
            if a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if a1 == u3.MoveTouch then
                u3.MoveTouch = nil
                u3.TouchMoveVector = Vector3.new(0, 0, 0)
                return
            end
            if a1 == u3.LookTouch then
                u3.LookTouch = nil
            end
            return
        end
        local KeyCode = a1.KeyCode
        if KeyCode == Enum.KeyCode.Thumbstick1 then
            u3.GamepadMove = Vector2.zero
            return
        end
        if KeyCode == Enum.KeyCode.Thumbstick2 then
            u3.GamepadLook = Vector2.zero
            return
        end
        if KeyCode == Enum.KeyCode.ButtonR2 then
            u3.GamepadRise = 0
            return
        end
        if KeyCode == Enum.KeyCode.ButtonL2 then
            u3.GamepadFall = 0
        end
    end), "Disconnect")
    u3.Janitor:Add(function() -- Line: 515 -- upvalues: u3 (val)
        if u3.IsActive then
            u3:Stop()
        end
    end)
    return u3
end

function u0:Destroy() -- Line: 527
    self.Janitor:Destroy()
end

return u0