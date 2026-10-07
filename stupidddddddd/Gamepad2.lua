-- StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.Gamepad
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.Gamepad
-- Decompile time: 3.76 ms

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
script.Parent.Parent:WaitForChild("CommonUtils")
local None = Enum.UserInputType.None
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local u29 = setmetatable({}, BaseCharacterController)
u29.__index = u29

function u29.new(a1) -- Line: 23 -- upvalues: BaseCharacterController (val), u29 (val), None (val)
    local v1 = BaseCharacterController.new()
    local v2 = setmetatable(v1, u29)
    v2.CONTROL_ACTION_PRIORITY = a1
    v2.forwardValue = 0
    v2.backwardValue = 0
    v2.leftValue = 0
    v2.rightValue = 0
    v2.activeGamepad = None
    v2.gamepadConnectedConn = nil
    v2.gamepadDisconnectedConn = nil
    return v2
end

function u29.Enable(a1, a2) -- Line: 39 -- upvalues: None (val) -- types: a1: table, a2: boolean
    if a2 == a1.enabled then
        return true
    end
    a1.forwardValue = 0
    a1.backwardValue = 0
    a1.leftValue = 0
    a1.rightValue = 0
    a1.moveVector = Vector3.new(0, 0, 0)
    a1.isJumping = false
    if not a2 then
        a1:UnbindContextActions()
        a1:DisconnectGamepadConnectionListeners()
        a1.activeGamepad = None
        a1.enabled = a2
        return true
    end
    a1.activeGamepad = a1:GetHighestPriorityGamepad()
    if a1.activeGamepad == None then
        return false
    end
    a1:BindContextActions()
    a1:ConnectGamepadConnectionListeners()
    a1.enabled = a2
    return true
end

function u29.GetHighestPriorityGamepad(a1) -- Line: 75 -- upvalues: UserInputService (val), None (val)
    local v1 = None
    for k, v in pairs((UserInputService:GetConnectedGamepads())) do
        if v.Value < v1.Value then
            v1 = v
        end
    end
    return v1
end

function u29:BindContextActions() -- Line: 86 -- upvalues: None (val), ContextActionService (val)
    if self.activeGamepad == None then
        return false
    end
    ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
    local v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY = self.CONTROL_ACTION_PRIORITY
    local ButtonA = Enum.KeyCode.ButtonA
    v1:BindActionAtPriority("jumpAction", function(a1, a2, a3) -- Line: 93 -- upvalues: self (val)
        self.isJumping = a2 == Enum.UserInputState.Begin
        return Enum.ContextActionResult.Sink
    end, false, CONTROL_ACTION_PRIORITY, ButtonA)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_2 = self.CONTROL_ACTION_PRIORITY
    local Thumbstick1 = Enum.KeyCode.Thumbstick1
    v1:BindActionAtPriority("moveThumbstick", function(a1, a2, a3) -- Line: 98 -- upvalues: self (val)
        if a2 == Enum.UserInputState.Cancel then
            self.moveVector = Vector3.new(0, 0, 0)
            return Enum.ContextActionResult.Sink
        end
        if self.activeGamepad ~= a3.UserInputType then
            return Enum.ContextActionResult.Pass
        end
        if a3.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end
        if not (0.2 < a3.Position.magnitude) then
            self.moveVector = Vector3.new(0, 0, 0)
        else
            self.moveVector = Vector3.new(a3.Position.X, 0, -a3.Position.Y)
        end
        return Enum.ContextActionResult.Sink
    end, false, CONTROL_ACTION_PRIORITY_2, Thumbstick1)
    return true
end

function u29:UnbindContextActions() -- Line: 127 -- upvalues: None (val), ContextActionService (val)
    if self.activeGamepad ~= None then
        ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    ContextActionService:UnbindAction("moveThumbstick")
    ContextActionService:UnbindAction("jumpAction")
end

function u29:OnNewGamepadConnected() -- Line: 135 -- upvalues: None (val)
    local HighestPriorityGamepad = self:GetHighestPriorityGamepad()
    if HighestPriorityGamepad == self.activeGamepad then
        return
    end
    if HighestPriorityGamepad == None then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        self:UnbindContextActions()
        return
    end
    if self.activeGamepad ~= None then
        self:UnbindContextActions()
    end
    self.activeGamepad = HighestPriorityGamepad
    self:BindContextActions()
end

function u29:OnCurrentGamepadDisconnected() -- Line: 162 -- upvalues: None (val), ContextActionService (val)
    if self.activeGamepad ~= None then
        ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    local HighestPriorityGamepad = self:GetHighestPriorityGamepad()
    if self.activeGamepad ~= None and HighestPriorityGamepad == self.activeGamepad then
        warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
        self:UnbindContextActions()
        self.activeGamepad = None
        return
    end
    if HighestPriorityGamepad == None then
        self:UnbindContextActions()
        self.activeGamepad = None
        return
    end
    self.activeGamepad = HighestPriorityGamepad
    ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
end

function u29:ConnectGamepadConnectionListeners() -- Line: 187 -- upvalues: UserInputService (val)
    self.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(a1) -- Line: 188 -- upvalues: self (val)
        self:OnNewGamepadConnected()
    end)
    self.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(a1) -- Line: 192 -- upvalues: self (val)
        if self.activeGamepad == a1 then
            self:OnCurrentGamepadDisconnected()
        end
    end)
end

function u29:DisconnectGamepadConnectionListeners() -- Line: 200
    if self.gamepadConnectedConn then
        self.gamepadConnectedConn:Disconnect()
        self.gamepadConnectedConn = nil
    end
    if self.gamepadDisconnectedConn then
        self.gamepadDisconnectedConn:Disconnect()
        self.gamepadDisconnectedConn = nil
    end
end

return u29