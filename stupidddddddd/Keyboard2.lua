-- StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.Keyboard
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.ControlModule.Keyboard
-- Decompile time: 2.33 ms

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
script.Parent.Parent:WaitForChild("CommonUtils")
local u18 = Vector3.new()
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local u30 = setmetatable({}, BaseCharacterController)
u30.__index = u30

function u30.new(a1) -- Line: 25 -- upvalues: BaseCharacterController (val), u30 (val)
    local v1 = BaseCharacterController.new()
    local v2 = setmetatable(v1, u30)
    v2.CONTROL_ACTION_PRIORITY = a1
    v2.forwardValue = 0
    v2.backwardValue = 0
    v2.leftValue = 0
    v2.rightValue = 0
    v2.jumpEnabled = true
    return v2
end

function u30.Enable(a1, a2) -- Line: 40 -- upvalues: u18 (val) -- types: a1: table, a2: boolean
    if a2 == a1.enabled then
        return true
    end
    a1.forwardValue = 0
    a1.backwardValue = 0
    a1.leftValue = 0
    a1.rightValue = 0
    a1.moveVector = u18
    a1.jumpRequested = false
    a1:UpdateJump()
    if not a2 then
        a1._connectionUtil:disconnectAll()
    else
        a1:BindContextActions()
        a1:ConnectFocusEventListeners()
    end
    a1.enabled = a2
    return true
end

function u30:UpdateMovement(a2) -- Line: 67 -- upvalues: u18 (val)
    if a2 == Enum.UserInputState.Cancel then
        self.moveVector = u18
        return
    end
    self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
end

function u30:UpdateJump() -- Line: 75
    self.isJumping = self.jumpRequested
end

function u30:BindContextActions() -- Line: 79 -- upvalues: ContextActionService (val)
    local v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY = self.CONTROL_ACTION_PRIORITY
    local CharacterForward = Enum.PlayerActions.CharacterForward
    v1:BindActionAtPriority("moveForwardAction", function(a1, a2, a3) -- Line: 84 -- upvalues: self (val)
        self.forwardValue = if a2 ~= Enum.UserInputState.Begin then 0 else -1
        self:UpdateMovement(a2)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY, CharacterForward)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_2 = self.CONTROL_ACTION_PRIORITY
    local CharacterBackward = Enum.PlayerActions.CharacterBackward
    v1:BindActionAtPriority("moveBackwardAction", function(a1, a2, a3) -- Line: 90 -- upvalues: self (val)
        self.backwardValue = if a2 ~= Enum.UserInputState.Begin then 0 else 1
        self:UpdateMovement(a2)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_2, CharacterBackward)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_3 = self.CONTROL_ACTION_PRIORITY
    local CharacterLeft = Enum.PlayerActions.CharacterLeft
    v1:BindActionAtPriority("moveLeftAction", function(a1, a2, a3) -- Line: 96 -- upvalues: self (val)
        self.leftValue = if a2 ~= Enum.UserInputState.Begin then 0 else -1
        self:UpdateMovement(a2)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_3, CharacterLeft)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_4 = self.CONTROL_ACTION_PRIORITY
    local CharacterRight = Enum.PlayerActions.CharacterRight
    v1:BindActionAtPriority("moveRightAction", function(a1, a2, a3) -- Line: 102 -- upvalues: self (val)
        self.rightValue = if a2 ~= Enum.UserInputState.Begin then 0 else 1
        self:UpdateMovement(a2)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_4, CharacterRight)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_5 = self.CONTROL_ACTION_PRIORITY
    local CharacterJump = Enum.PlayerActions.CharacterJump
    v1:BindActionAtPriority("jumpAction", function(a1, a2, a3) -- Line: 108 -- upvalues: self (val)
        local jumpEnabled = self.jumpEnabled and a2 == Enum.UserInputState.Begin
        self.jumpRequested = jumpEnabled
        self:UpdateJump()
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_5, CharacterJump)
    self._connectionUtil:trackBoundFunction("moveForwardAction", function() -- Line: 152 -- upvalues: ContextActionService (upval)
        ContextActionService:UnbindAction("moveForwardAction")
    end)
    self._connectionUtil:trackBoundFunction("moveBackwardAction", function() -- Line: 155 -- upvalues: ContextActionService (upval)
        ContextActionService:UnbindAction("moveBackwardAction")
    end)
    self._connectionUtil:trackBoundFunction("moveLeftAction", function() -- Line: 158 -- upvalues: ContextActionService (upval)
        ContextActionService:UnbindAction("moveLeftAction")
    end)
    self._connectionUtil:trackBoundFunction("moveRightAction", function() -- Line: 161 -- upvalues: ContextActionService (upval)
        ContextActionService:UnbindAction("moveRightAction")
    end)
    self._connectionUtil:trackBoundFunction("jumpAction", function() -- Line: 164 -- upvalues: ContextActionService (upval)
        ContextActionService:UnbindAction("jumpAction")
    end)
end

function u30:ConnectFocusEventListeners() -- Line: 169 -- upvalues: u18 (val), UserInputService (val)
    local function onFocusReleased() -- Line: 170 -- upvalues: self (val), u18 (upval)
        self.moveVector = u18
        self.forwardValue = 0
        self.backwardValue = 0
        self.leftValue = 0
        self.rightValue = 0
        self.jumpRequested = false
        self:UpdateJump()
    end

    self._connectionUtil:trackConnection("textBoxFocusReleased", (UserInputService.TextBoxFocusReleased:Connect(onFocusReleased)))
    self._connectionUtil:trackConnection("textBoxFocused", (UserInputService.TextBoxFocused:Connect(function(a1) -- Line: 180 -- upvalues: self (val)
        self.jumpRequested = false
        self:UpdateJump()
    end)))
    self._connectionUtil:trackConnection("windowFocusReleased", (UserInputService.WindowFocusReleased:Connect(onFocusReleased)))
end

return u30