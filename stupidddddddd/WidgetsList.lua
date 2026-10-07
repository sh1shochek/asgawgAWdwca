-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets.WidgetsList
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets.WidgetsList
-- Decompile time: 1.82 ms

local Parent_4 = script.Parent.Parent.Parent.Parent
local Widget = require(Parent_4.Widget)
local u12 = Color3.fromRGB(183, 241, 77)
local u17 = Color3.fromRGB(132, 156, 137)
local u22 = Color3.fromRGB(241, 77, 77)
local u27 = Color3.fromRGB(147, 115, 137)

local function createWidgetButton(a1, a2) -- Line: 11
    -- upvalues: Widget (val), u17 (val), u27 (val), u12 (val), u22 (val)
    local v1 = Widget:IsVisible(a1)
    local TextButton = Instance.new("TextButton")
    TextButton.Name = a1
    TextButton.AutoLocalize = false
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextButton.Text = (" %*"):format(a1)
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12
    TextButton.TextStrokeTransparency = 0
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.BackgroundColor3 = v1 and u17 or u27
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.new(1, 0, 0, 18)
    local u52 = TextButton.Activated:Connect(function() -- Line: 29 -- upvalues: Widget (upval), a1 (val)
        Widget:SwitchVisibility(a1)
    end)
    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.AnchorPoint = Vector2.new(0, 0.5)
    Frame.BackgroundColor3 = v1 and u12 or u22
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(1, -12, 0.5, 0)
    Frame.Size = UDim2.new(0, 100, 0.3, 0)
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    UIAspectRatioConstraint.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.fromRGB(81, 88, 104)
    UIStroke.Parent = Frame
    Frame.Parent = TextButton
    TextButton.Parent = a2
    local u120 = Widget.WidgetMounted:Connect(function(a1_2) -- Line: 60 -- upvalues: a1 (val), Frame (val), TextButton (ref) -- types: a1_2: string
        if a1_2 ~= a1 then
            return
        end
        Frame.BackgroundColor3 = Color3.fromRGB(183, 241, 77)
        TextButton.BackgroundColor3 = Color3.fromRGB(132, 156, 137)
    end)
    local u126 = Widget.WidgetUnmounted:Connect(function(a1_2) -- Line: 69 -- upvalues: a1 (val), Frame (val), TextButton (ref) -- types: a1_2: string
        if a1_2 ~= a1 then
            return
        end
        Frame.BackgroundColor3 = Color3.fromRGB(241, 77, 77)
        TextButton.BackgroundColor3 = Color3.fromRGB(147, 115, 137)
    end)
    return function() -- Line: 78 -- upvalues: u52 (ref), u120 (ref), u126 (ref), TextButton (ref)
        u52:Disconnect()
        u52 = nil
        u120:Disconnect()
        u120 = nil
        u126:Disconnect()
        u126 = nil
        TextButton:Destroy()
        TextButton = nil
    end
end

return function(a1) -- Line: 93 -- upvalues: Widget (val), createWidgetButton (val) -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Widgets List"
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(172, 195, 245)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.fromScale(1, 0)
    Frame.Size = UDim2.fromScale(0.25, 1)
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Gradient"
    Frame_2.AnchorPoint = Vector2.new(1, 0)
    Frame_2.Size = UDim2.fromScale(0.05, 1)
    Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BackgroundTransparency = 0.8
    Frame_2.BorderSizePixel = 0
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "UIGradient"
    UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), (NumberSequenceKeypoint.new(1, 0))})
    UIGradient.Parent = Frame_2
    Frame_2.Parent = Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.SortOrder = Enum.SortOrder.Name
    UIListLayout.Parent = ScrollingFrame
    ScrollingFrame.Parent = Frame
    Frame.Parent = a1
    local u88 = {}
    for i in Widget:GetAll() do
        table.insert(u88, (createWidgetButton(i, ScrollingFrame)))
    end
    local u108 = Widget.WidgetAdded:Connect(function(a1) -- Line: 145 -- upvalues: u88 (val), createWidgetButton (upval), ScrollingFrame (val)
        table.insert(u88, (createWidgetButton(a1, ScrollingFrame)))
    end)
    return function() -- Line: 149 -- upvalues: u88 (val), u108 (ref), Frame (ref)
        for i, j in u88 do
            j()
        end
        u108:Disconnect()
        u108 = nil
        Frame:Destroy()
        Frame = nil
    end
end