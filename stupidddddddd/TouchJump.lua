-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.TouchJump
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.TouchJump
-- Decompile time: 2.28 ms

game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local CharacterUtil = require(CommonUtils:WaitForChild("CharacterUtil"))
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local u41 = setmetatable({}, BaseCharacterController)
u41.__index = u41

function u41.new() -- Line: 50 -- upvalues: BaseCharacterController (val), u41 (val), ConnectionUtil (val)
    local v1 = BaseCharacterController.new()
    local v2 = setmetatable(v1, u41)
    v2.parentUIFrame = nil
    v2.jumpButton = nil
    v2.externallyEnabled = false
    v2.isJumping = false
    v2._active = false
    v2._connectionUtil = ConnectionUtil.new()
    return v2
end

function u41:_reset() -- Line: 64
    self.isJumping = false
    self.touchObject = nil
    if self.jumpButton then
        self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

function u41:EnableButton(a2) -- Line: 74 -- upvalues: GuiService (val)
    if a2 == self._active then
        self:_reset()
        return
    end
    if not a2 then
        if self.jumpButton then
            self.jumpButton.Visible = false
        end
        self._connectionUtil:disconnect("JUMP_INPUT_ENDED")
        self._connectionUtil:disconnect("MENU_OPENED")
    else
        if not self.jumpButton then
            self:Create()
        end
        self.jumpButton.Visible = false
        self._connectionUtil:trackConnection("JUMP_INPUT_ENDED", (self.jumpButton.InputEnded:Connect(function(a1) -- Line: 92 -- upvalues: self (val)
            if a1 == self.touchObject then
                self:_reset()
            end
        end)))
        self._connectionUtil:trackConnection("MENU_OPENED", (GuiService.MenuOpened:Connect(function() -- Line: 102 -- upvalues: self (val)
            if self.touchObject then
                self:_reset()
            end
        end)))
    end
    self:_reset()
    self._active = a2
end

function u41:UpdateEnabled() -- Line: 119 -- upvalues: CharacterUtil (val)
    local v1 = CharacterUtil.getChild("Humanoid", "Humanoid")
    if v1 and self.externallyEnabled and 0 < v1.JumpPower and v1:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        self:EnableButton(true)
        return
    end
    self:EnableButton(false)
end

function u41:_setupConfigurations() -- Line: 128 -- upvalues: CharacterUtil (val)
    local function update() -- Line: 129 -- upvalues: self (val)
        self:UpdateEnabled()
    end

    self._connectionUtil:trackConnection("HUMANOID", (CharacterUtil.onChild("Humanoid", "Humanoid", function(a1) -- Line: 134 -- upvalues: self (val), update (val)
        self:UpdateEnabled()
        self._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", ((a1:GetPropertyChangedSignal("JumpPower")):Connect(update)))
        self._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", (a1.StateEnabledChanged:Connect(function(a1, a2) -- Line: 142 -- upvalues: self (upval)
            if a1 == Enum.HumanoidStateType.Jumping and a2 ~= self._active then
                self:UpdateEnabled()
            end
        end)))
    end)))
end

function u41.Enable(a1, a2, a3) -- Line: 154
    if a3 then
        a1.parentUIFrame = a3
    end
    if a1.externallyEnabled == a2 then
        return
    end
    a1.externallyEnabled = a2
    a1:UpdateEnabled()
    if a2 then
        a1:_setupConfigurations()
        return
    end
    a1._connectionUtil:disconnectAll()
end

function u41:Create() -- Line: 171
    if not self.parentUIFrame then
        return
    end
    if self.jumpButton then
        self.jumpButton:Destroy()
        self.jumpButton = nil
    end
    if self.absoluteSizeChangedConn then
        self.absoluteSizeChangedConn:Disconnect()
        self.absoluteSizeChangedConn = nil
    end
    self.jumpButton = Instance.new("ImageButton")
    self.jumpButton.Name = "JumpButton"
    self.jumpButton.Visible = false
    self.jumpButton.BackgroundTransparency = 1
    self.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    self.jumpButton.ImageRectSize = Vector2.new(144, 144)

    local function ResizeJumpButton() -- Line: 194 -- upvalues: self (val)
        local v1
        local v2 = if not ((math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y)) <= 500) then 120 else 70
        self.jumpButton.Size = UDim2.new(0, v2, 0, v2)
        local jumpButton = self.jumpButton
        local v3 = v1 and UDim2.new(1, -(v2 * 1.5 - 10), 1, -v2 - 20) or UDim2.new(1, -(v2 * 1.5 - 10), 1, -v2 * 1.75)
        jumpButton.Position = v3
    end

    ResizeJumpButton()
    self.absoluteSizeChangedConn = (self.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize")):Connect(ResizeJumpButton)
    self.touchObject = nil
    self.jumpButton.InputBegan:connect(function(a1) -- Line: 208 -- upvalues: self (val)
        if not self.touchObject
            and a1.UserInputType == Enum.UserInputType.Touch
            and a1.UserInputState == Enum.UserInputState.Begin then
            self.touchObject = a1
            self.jumpButton.ImageRectOffset = Vector2.new(146, 146)
            self.isJumping = true
            return
        end
    end)
    self.jumpButton.Parent = self.parentUIFrame
end

return u41