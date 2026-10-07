-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick
-- Decompile time: 3.91 ms

game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
UserSettings():GetService("UserGameSettings")
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local u32 = setmetatable({}, BaseCharacterController)
u32.__index = u32

function u32.new() -- Line: 20 -- upvalues: BaseCharacterController (val), u32 (val)
    local v1 = BaseCharacterController.new()
    local v2 = setmetatable(v1, u32)
    v2.isFollowStick = false
    v2.thumbstickFrame = nil
    v2.moveTouchObject = nil
    v2.onTouchMovedConn = nil
    v2.onTouchEndedConn = nil
    v2.screenPos = nil
    v2.stickImage = nil
    v2.thumbstickSize = nil
    return v2
end

function u32.Enable(a1, a2, a3) -- Line: 35 -- types: a1: table, a2: boolean?
    if a2 == nil then
        return false
    end
    local v1 = not not a2
    if a1.enabled == v1 then
        return true
    end
    a1.moveVector = Vector3.new(0, 0, 0)
    a1.isJumping = false
    if not v1 then
        a1.thumbstickFrame.Visible = false
        a1:OnInputEnded()
    else
        if not a1.thumbstickFrame then
            a1:Create(a3)
        end
        a1.thumbstickFrame.Visible = true
    end
    a1.enabled = v1
end

function u32:OnInputEnded() -- Line: 56
    self.thumbstickFrame.Position = self.screenPos
    self.stickImage.Position = UDim2.new(
        0,
        self.thumbstickFrame.Size.X.Offset / 2 - self.thumbstickSize / 4,
        0,
        self.thumbstickFrame.Size.Y.Offset / 2 - self.thumbstickSize / 4
    )
    self.moveVector = Vector3.new(0, 0, 0)
    self.isJumping = false
    self.thumbstickFrame.Position = self.screenPos
    self.moveTouchObject = nil
end

function u32:Create(a2) -- Line: 65 -- upvalues: UserInputService (val), GuiService (val)
    if self.thumbstickFrame then
        self.thumbstickFrame:Destroy()
        self.thumbstickFrame = nil
        if self.onTouchMovedConn then
            self.onTouchMovedConn:Disconnect()
            self.onTouchMovedConn = nil
        end
        if self.onTouchEndedConn then
            self.onTouchEndedConn:Disconnect()
            self.onTouchEndedConn = nil
        end
        if self.absoluteSizeChangedConn then
            self.absoluteSizeChangedConn:Disconnect()
            self.absoluteSizeChangedConn = nil
        end
    end
    self.thumbstickFrame = Instance.new("Frame")
    self.thumbstickFrame.Name = "ThumbstickFrame"
    self.thumbstickFrame.Active = true
    self.thumbstickFrame.Visible = false
    self.thumbstickFrame.BackgroundTransparency = 1
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "OuterImage"
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    ImageLabel.ImageRectOffset = Vector2.new()
    ImageLabel.ImageRectSize = Vector2.new(220, 220)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 0, 0, 0)
    self.stickImage = Instance.new("ImageLabel")
    self.stickImage.Name = "StickImage"
    self.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    self.stickImage.ImageRectOffset = Vector2.new(220, 0)
    self.stickImage.ImageRectSize = Vector2.new(111, 111)
    self.stickImage.BackgroundTransparency = 1
    self.stickImage.ZIndex = 2

    local function ResizeThumbstick() -- Line: 105 -- upvalues: a2 (val), self (val), ImageLabel (val)
        local v1
        self.thumbstickSize = if not ((math.min(a2.AbsoluteSize.X, a2.AbsoluteSize.Y)) <= 500) then 120 else 70
        local v2 = v1 and UDim2.new(0, self.thumbstickSize / 2 - 10, 1, -self.thumbstickSize - 20) or UDim2.new(0, self.thumbstickSize / 2, 1, -self.thumbstickSize * 1.75)
        self.screenPos = v2
        self.thumbstickFrame.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
        self.thumbstickFrame.Position = self.screenPos
        ImageLabel.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
        self.stickImage.Size = UDim2.new(0, self.thumbstickSize / 2, 0, self.thumbstickSize / 2)
        self.stickImage.Position = UDim2.new(0, self.thumbstickSize / 2 - self.thumbstickSize / 4, 0, self.thumbstickSize / 2 - self.thumbstickSize / 4)
    end

    ResizeThumbstick()
    self.absoluteSizeChangedConn = (a2:GetPropertyChangedSignal("AbsoluteSize")):Connect(ResizeThumbstick)
    ImageLabel.Parent = self.thumbstickFrame
    self.stickImage.Parent = self.thumbstickFrame
    local u96 = nil

    local function DoMove(a1) -- Line: 127 -- upvalues: self (val) -- types: a1: userdata
        local v1 = a1 / (self.thumbstickSize / 2)
        local magnitude = v1.magnitude
        if not (magnitude < 0.05) then
            v1 = v1.unit * math.min(1, (magnitude - 0.05) / 0.95)
            v1 = Vector3.new(v1.X, 0, v1.Y)
        else
            v1 = Vector3.new()
        end
        self.moveVector = v1
    end

    local function MoveStick(a1) -- Line: 145 -- upvalues: u96 (ref), self (val) -- types: a1: vector
        local v1 = Vector2.new(a1.X - u96.X, a1.Y - u96.Y)
        local magnitude = v1.magnitude
        local v2 = self.thumbstickFrame.AbsoluteSize.X / 2
        if not self.isFollowStick or not (v2 < magnitude) then
            v1 = v1.unit * (math.min(magnitude, v2))
        else
            local v3 = v1.unit * v2
            self.thumbstickFrame.Position = UDim2.new(0, a1.X - self.thumbstickFrame.AbsoluteSize.X / 2 - v3.X, 0, a1.Y - self.thumbstickFrame.AbsoluteSize.Y / 2 - v3.Y)
        end
        self.stickImage.Position = UDim2.new(0, v1.X + self.stickImage.AbsoluteSize.X / 2, 0, v1.Y + self.stickImage.AbsoluteSize.Y / 2)
    end

    self.thumbstickFrame.InputBegan:Connect(function(a1) -- Line: 162 -- upvalues: self (val), u96 (ref) -- types: a1: userdata
        if not self.moveTouchObject
            and a1.UserInputType == Enum.UserInputType.Touch
            and a1.UserInputState == Enum.UserInputState.Begin then
            self.moveTouchObject = a1
            self.thumbstickFrame.Position = UDim2.new(0, a1.Position.X - self.thumbstickFrame.Size.X.Offset / 2, 0, a1.Position.Y - self.thumbstickFrame.Size.Y.Offset / 2)
            u96 = Vector2.new(
                self.thumbstickFrame.AbsolutePosition.X + self.thumbstickFrame.AbsoluteSize.X / 2,
                self.thumbstickFrame.AbsolutePosition.Y + self.thumbstickFrame.AbsoluteSize.Y / 2
            )
            Vector2.new(a1.Position.X - u96.X, a1.Position.Y - u96.Y)
            return
        end
    end)
    self.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(a1, a2) -- Line: 177 -- upvalues: self (val), u96 (ref), MoveStick (val) -- types: a1: userdata, a2: boolean
        if a1 == self.moveTouchObject then
            u96 = Vector2.new(
                self.thumbstickFrame.AbsolutePosition.X + self.thumbstickFrame.AbsoluteSize.X / 2,
                self.thumbstickFrame.AbsolutePosition.Y + self.thumbstickFrame.AbsoluteSize.Y / 2
            )
            local v1 = (Vector2.new(a1.Position.X - u96.X, a1.Position.Y - u96.Y)) / (self.thumbstickSize / 2)
            local magnitude = v1.magnitude
            if not (magnitude < 0.05) then
                v1 = v1.unit * math.min(1, (magnitude - 0.05) / 0.95)
                v1 = Vector3.new(v1.X, 0, v1.Y)
            else
                v1 = Vector3.new()
            end
            self.moveVector = v1
            MoveStick(a1.Position)
        end
    end)
    self.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(a1, a2) -- Line: 187 -- upvalues: self (val)
        if a1 == self.moveTouchObject then
            self:OnInputEnded()
        end
    end)
    GuiService.MenuOpened:Connect(function() -- Line: 193 -- upvalues: self (val)
        if self.moveTouchObject then
            self:OnInputEnded()
        end
    end)
    self.thumbstickFrame.Parent = a2
end

return u32