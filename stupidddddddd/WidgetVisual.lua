-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets.WidgetVisual
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets.WidgetVisual
-- Decompile time: 1.84 ms

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GuiInset = GuiService:GetGuiInset()
local Shared = script.Parent.Parent.Parent.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local u23 = {internal = {}, prototype = {}, interface = {}}

function u23.internal.createWidgetRepresentation(a1, a2) -- Line: 17 -- types: a2: userdata
    local v1 = a1.WidgetScreenGui:GetChildren()[1]
    local TextButton = Instance.new("TextButton")
    TextButton.Name = a1.WidgetName
    TextButton.AutoLocalize = false
    TextButton.Size = UDim2.fromOffset(60, 30)
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 0.5
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = TextButton
    a1.FrameRepresentation = TextButton
    a1.BoundingInstance = v1
    TextButton.Parent = a2
end

function u23.internal.observeWidgetChanges(a1) -- Line: 40 -- upvalues: GuiInset (val), UserInputService (val)
    local FrameRepresentation = a1.FrameRepresentation
    a1.MouseInteractionConnection = FrameRepresentation.MouseButton1Down:Connect(function() -- Line: 43 -- upvalues: FrameRepresentation (val), GuiInset (upval), UserInputService (upval), a1 (val)
        local v1 = FrameRepresentation.AbsolutePosition + GuiInset
        local v2 = UserInputService:GetMouseLocation() - v1
        v2 = Vector2.new(math.floor(v2.X), (math.floor(v2.Y)))
        a1.Activated:Fire(v2)
    end)
    a1.AbsolutePositionChangedConnection = (a1.BoundingInstance:GetPropertyChangedSignal("AbsolutePosition")):Connect(function() -- Line: 54 -- upvalues: a1 (val)
        a1:UpdateRepresentation()
    end)
    a1.AbsoluteSizeChangedConnection = (a1.BoundingInstance:GetPropertyChangedSignal("AbsoluteSize")):Connect(function() -- Line: 60 -- upvalues: a1 (val)
        a1:UpdateRepresentation()
    end)
    a1:UpdateRepresentation()
end

function u23.prototype:UpdateRepresentation() -- Line: 67 -- upvalues: GuiInset (val)
    local AbsoluteSize = self.FrameRepresentation.Parent.AbsoluteSize
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v1 = self.BoundingInstance.AbsolutePosition + GuiInset
    local AbsoluteSize_2 = self.BoundingInstance.AbsoluteSize
    local v2 = v1 / ViewportSize
    local v3 = AbsoluteSize_2 / ViewportSize
    local v4 = AbsoluteSize * v2
    local v5 = AbsoluteSize * v3
    self.FrameRepresentation.Position = UDim2.fromOffset(v4.X, v4.Y)
    self.FrameRepresentation.Size = UDim2.fromOffset(v5.X, v5.Y)
end

function u23.prototype:Destroy() -- Line: 83
    self.MouseInteractionConnection:Disconnect()
    self.AbsolutePositionChangedConnection:Disconnect()
    self.AbsoluteSizeChangedConnection:Disconnect()
    self.FrameRepresentation:Destroy()
    self.Activated:Destroy()
end

function u23.interface.new(a1, a2, a3) -- Line: 92
    -- upvalues: Signal (val), u23 (val)
    local v1 = ("Expected parameter #1 'widgetName' to be a string, got %*"):format((type(a1)))
    assert(type(a1) == "string", v1)
    local v2 = {WidgetName = a1, WidgetScreenGui = a2, Activated = Signal.new()}
    v1 = {__index = u23.prototype}
    local v3 = setmetatable(v2, v1)
    u23.internal.createWidgetRepresentation(v3, a3)
    u23.internal.observeWidgetChanges(v3)
    return v3
end

return u23.interface